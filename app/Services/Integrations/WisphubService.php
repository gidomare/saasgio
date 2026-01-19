<?php

namespace App\Services\Integrations;

use App\Models\Integration;
use Illuminate\Support\Facades\Http;
use Exception;

class WisphubService
{
    protected $integration;

    public function __construct()
    {
        $this->integration = Integration::firstOrCreate(
            ['slug' => 'wisphub'],
            ['name' => 'Wisphub', 'is_active' => true, 'settings' => ['api_key' => '', 'url' => 'https://wisphub.net/api/']]
        );
    }

    public function getIntegration()
    {
        return $this->integration;
    }

    public function getSettings(): ?array
    {
        return $this->integration->settings ?? null;
    }

    public function updateSettings(array $settings, array $attributes = []): void
    {
        $this->integration->settings = $settings;
        $this->integration->fill($attributes);
        $this->integration->save();
    }

    public function testConnection(): array
    {
        $url = $this->integration->settings['url'] ?? '';
        $apiKey = $this->integration->settings['api_key'] ?? '';

        if (empty($url) || empty($apiKey)) {
            throw new Exception("Configuración incompleta. Por favor guarde la URL y la API Key.");
        }

        try {
            // Simulamos una petición de prueba (ajustar endpoint real cuando se tenga doc)
            // Por ahora hacemos un GET a la URL base o un endpoint de profile
            $response = Http::withHeaders([
                'Authorization' => 'Api-Key ' . $apiKey,
            ])->timeout(5)->get($url); // Asumimos que la URL base responde algo o 404/401 pero conecta

            if ($response->successful() || $response->status() === 404) {
                 // Si responde (aunque sea 404, significa que el server existe), lo tomamos como "Conexión OK" para este nivel de test básico
                 // Lo ideal sería un endpoint /me o /status
                return ['success' => true, 'message' => 'Conexión exitosa con Wisphub.'];
            }
            
            return ['success' => false, 'message' => 'Error HTTP: ' . $response->status()];

        } catch (Exception $e) {
            return ['success' => false, 'message' => 'Error de conexión: ' . $e->getMessage()];
        }
    }

    public function sync(): array
    {
        $url = $this->integration->settings['url'] ?? '';
        $apiKey = $this->integration->settings['api_key'] ?? '';

        if (empty($url) || empty($apiKey)) {
            throw new Exception("Configuración incompleta.");
        }

        $stats = ['imported_customers' => 0, 'updated_customers' => 0, 'errors' => 0];

        try {
            // Los endpoints de catálogos no están disponibles en Wisphub
            // La información de planes y routers viene dentro de cada cliente
            // $this->syncPlans($url, $apiKey);
            // $this->syncRouters($url, $apiKey);

            // Paso 1: Obtener Clientes
            // Limpiamos trailing slash
            $baseUrl = rtrim($url, '/');
            
            // Si el usuario ya puso la ruta completa (ej .../api/clientes), la usamos.
            if (str_contains($baseUrl, '/clientes')) {
                $endpoint = $baseUrl . '/'; 
            } else {
                // Si puso la raiz, agregamos el path estándar
                // Detectamos si falta /api
                if (!str_contains($baseUrl, '/api')) {
                     $baseUrl .= '/api';
                }
                $endpoint = $baseUrl . '/clientes/';
            }

            // Log de depuración (puedes verlo en storage/logs/laravel.log)
            // \Illuminate\Support\Facades\Log::info("Wisphub Sync Endpoint: " . $endpoint);

            $nextUrl = $endpoint;
            
            do {
                // Log::info("Consultando pagina: " . $nextUrl);
                $response = Http::withHeaders(['Authorization' => 'Api-Key ' . $apiKey])
                    ->get($nextUrl);

                if ($response->failed()) {
                    throw new Exception("Error HTTP " . $response->status() . " en " . $nextUrl);
                }

                $data = $response->json();
                $clients = $data['results'] ?? [];
                
                // Determinar siguiente página
                // Wisphub suele devolver 'next': 'http://...' lo que causa 403 si el server fuerza HTTPS
                $nextUrl = $data['next'] ?? null;
                if ($nextUrl) {
                    $nextUrl = str_replace('http://', 'https://', $nextUrl);
                }

                foreach ($clients as $clientData) {
                    try {
                        $this->importClient($clientData);
                        $stats['imported_customers']++;
                    } catch (\Throwable $e) {
                        $stats['errors']++;
                        \Illuminate\Support\Facades\Log::error("Error importClient: " . $e->getMessage(), ['trace' => $e->getTraceAsString()]);
                    }
                }
                
                // Pequeña pausa para evitar bloqueo por Flood/RateLimit (403/429)
                usleep(500000); 

            } while ($nextUrl);

            return [
                'success' => true,
                'message' => "Sincronización finalizada. Importados/Actualizados: {$stats['imported_customers']}. Errores: {$stats['errors']}."
            ];

        } catch (\Throwable $e) {
            return ['success' => false, 'message' => "Fallo crítico: " . $e->getMessage()];
        }
    }
    
    protected function syncPlans($baseUrl, $apiKey)
    {
        // Construcción segura de URL
        // Objetivo: https://api.wisphub.net/api/planes-internet/
        $schemeHost = parse_url($baseUrl, PHP_URL_SCHEME) . '://' . parse_url($baseUrl, PHP_URL_HOST);
        $endpoint = $schemeHost . '/api/planes-internet/';

        $response = Http::withHeaders(['Authorization' => 'Api-Key ' . $apiKey])->get($endpoint);
        if ($response->successful()) {
            foreach ($response->json()['results'] ?? [] as $plan) {
                if (!is_array($plan)) continue;
                try {
                     \App\Models\Plan::updateOrCreate(
                        ['wisphub_id' => $plan['id']],
                        [
                            'name' => $plan['nombre'],
                            // Wisphub envía velocidades en Mbps, convertir a Kbps (1 Mbps = 1000 Kbps)
                            'download_speed_kbps' => intval(($plan['bajada'] ?? 0) * 1000),
                            'upload_speed_kbps' => intval(($plan['subida'] ?? 0) * 1000),
                            'price' => floatval($plan['precio'] ?? 0),
                        ]
                    );
                } catch (\Throwable $e) {
                     \Illuminate\Support\Facades\Log::error("Error syncPlan: " . $e->getMessage(), ['data' => $plan]);
                }
            }
        } else {
            // Log::warning("Fallo syncPlans: " . $response->status());
        }
    }

    protected function syncRouters($baseUrl, $apiKey)
    {
         // Objetivo: https://api.wisphub.net/api/routers/
        $schemeHost = parse_url($baseUrl, PHP_URL_SCHEME) . '://' . parse_url($baseUrl, PHP_URL_HOST);
        $endpoint = $schemeHost . '/api/routers/';

        $response = Http::withHeaders(['Authorization' => 'Api-Key ' . $apiKey])->get($endpoint);
        if ($response->successful()) {
            foreach ($response->json()['results'] ?? [] as $router) {
                if (!is_array($router)) continue;
                try {
                     \App\Models\Router::updateOrCreate(
                        ['wisphub_id' => $router['id']],
                        [
                            'name' => $router['nombre'],
                            'ip_address' => $router['ip'] ?? $router['ip_address'] ?? '0.0.0.0',
                            'type' => 'mikrotik', 
                            'api_port' => intval($router['puerto_api'] ?? $router['api_port'] ?? 8728),
                        ]
                    );
                } catch (\Throwable $e) {
                    \Illuminate\Support\Facades\Log::error("Error syncRouter: " . $e->getMessage(), ['data' => $router]);
                }
            }
        }
    }

    protected function importClient(array $data)
    {
        // ... (código previo de Customer) ...
        $wisphubId = $data['id_servicio'] ?? $data['id'];
        $name = $data['nombre'] ?? 'Cliente Sin Nombre';
        
        // Concatenar dirección completa: Dirección + Localidad + Ciudad
        $addressParts = array_filter([
            $data['direccion'] ?? null,
            $data['localidad'] ?? null,
            $data['ciudad'] ?? null,
        ]);
        $fullAddress = implode("\n", $addressParts);
        
        $customer = \App\Models\Customer::updateOrCreate(
            ['wisphub_id' => $wisphubId],
            [
                'name' => $name,
                'email' => $data['email'] ?? null,
                'phone' => $data['telefono'] ?? null,
                'address' => $fullAddress ?: null,
                'coordinates' => $data['coordenadas'] ?? null,
                'installation_date' => (function() use ($data) {
                    $rawDate = $data['fecha_instalacion'] ?? '';
                    if (empty($rawDate) || $rawDate === 'None') return null;
                    try {
                        // Formato Wisphub: 15/01/2026 14:49:00
                        return \Carbon\Carbon::createFromFormat('d/m/Y H:i:s', $rawDate)->format('Y-m-d');
                    } catch (\Throwable $e) {
                         // Fallback por si el formato cambia
                        try {
                            return \Carbon\Carbon::parse($rawDate)->format('Y-m-d');
                        } catch (\Throwable $e2) {
                            return null;
                        }
                    }
                })(),
            ]
        );

        // 1. Resolver Plan
        $planId = null;
        // Wisphub envía plan_internet como objeto {id, nombre}, no como string
        $planData = $data['plan_internet'] ?? null;
        
        if (is_array($planData) && isset($planData['id'])) {
            // Buscar o crear plan usando wisphub_id
            $plan = \App\Models\Plan::updateOrCreate(
                ['wisphub_id' => $planData['id']],
                [
                    'name' => $planData['nombre'] ?? 'Plan Desconocido',
                    'download_speed_kbps' => 0,
                    'upload_speed_kbps' => 0,
                    'price' => floatval($data['precio_plan'] ?? 0),
                ]
            );
            $planId = $plan->id;
        } else {
            // Fallback si no viene plan_internet
            $planName = is_array($planData) ? ($planData['nombre'] ?? 'Plan Desconocido') : ($planData ?? 'Plan Desconocido');
            $plan = \App\Models\Plan::updateOrCreate(
                ['name' => $planName],
                [
                    'download_speed_kbps' => 0,
                    'upload_speed_kbps' => 0,
                    'price' => floatval($data['precio_plan'] ?? 0),
                ]
            );
            $planId = $plan->id;
        }
        
        // 2. Resolver Router
        $routerId = null;
        // Wisphub envía router como objeto {id, nombre, ip}, no como string
        $routerData = $data['router'] ?? null;
        
        if (is_array($routerData) && isset($routerData['id'])) {
            // Buscar o crear router usando wisphub_id
            $router = \App\Models\Router::updateOrCreate(
                ['wisphub_id' => $routerData['id']],
                [
                    'name' => $routerData['nombre'] ?? 'Router Desconocido',
                    'ip_address' => $routerData['ip'] ?? '0.0.0.0',
                    'type' => 'mikrotik',
                    'api_port' => 8728,
                ]
            );
            $routerId = $router->id;
        } else {
            // Fallback si no viene router
            $routerName = is_array($routerData) ? ($routerData['nombre'] ?? 'Router Desconocido') : ($routerData ?? 'Router Desconocido');
            $router = \App\Models\Router::updateOrCreate(
                ['name' => $routerName],
                [
                    'ip_address' => '0.0.0.0',
                    'type' => 'mikrotik'
                ]
            );
            $routerId = $router->id;
        }

        // Mapeo de Estado
        $statusMap = [
            '1' => 'active', 'activo' => 'active',
            '2' => 'suspended', 'suspendido' => 'suspended', 'corte' => 'suspended',
            'retirado' => 'cancelled', 'cancelado' => 'cancelled'
        ];
        $rawStatus = strtolower((string)($data['estado'] ?? ''));
        $status = $statusMap[$rawStatus] ?? 'active';

        $customer->services()->updateOrCreate(
            ['wisphub_servicio_id' => $data['id_servicio'] ?? $wisphubId],
            [
                'router_id' => $routerId,
                'plan_id' => $planId,
                'ip_address' => $data['ip'] ?? null,
                'mac_address' => $data['mac'] ?? null,
                'pppoe_user' => $data['user_pppoe'] ?? null,
                'pppoe_password' => $data['pass_pppoe'] ?? null,
                'status' => $status,
            ]
        );
    }
}
