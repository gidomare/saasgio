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
            throw new Exception("Configuración incompleta. Verifica URL y API Key en Wisphub Settings.");
        }

        $stats = [
            'synced_services' => 0,
            'deleted_services' => 0,
            'deleted_customers' => 0,
            'errors' => 0
        ];

        try {
            // Paso 1: Sincronizar catálogos (Planes y Routers)
            $this->syncPlans($url, $apiKey);
            $this->syncRouters($url, $apiKey);

            // Paso 2: Sincronizar clientes y servicios
            $syncedServiceIds = [];
            $syncedCustomerIds = [];
            
            $endpoint = $this->buildClientEndpoint($url);
            $nextUrl = $endpoint;
            
            do {
                $response = Http::withHeaders(['Authorization' => 'Api-Key ' . $apiKey])
                    ->timeout(30)
                    ->get($nextUrl);

                if ($response->failed()) {
                    throw new Exception("Error HTTP {$response->status()} al consultar clientes en: {$nextUrl}");
                }

                $data = $response->json();
                $clients = $data['results'] ?? [];
                
                foreach ($clients as $clientData) {
                    try {
                        $result = $this->importClient($clientData);
                        $syncedServiceIds[] = $result['service_id'];
                        $syncedCustomerIds[] = $result['customer_id'];
                        $stats['synced_services']++;
                    } catch (\Throwable $e) {
                        $stats['errors']++;
                        \Illuminate\Support\Facades\Log::error("Error al importar cliente desde Wisphub", [
                            'wisphub_id' => $clientData['id_servicio'] ?? $clientData['id'] ?? 'unknown',
                            'error' => $e->getMessage(),
                            'trace' => $e->getTraceAsString()
                        ]);
                    }
                }
                
                $nextUrl = $data['next'] ?? null;
                if ($nextUrl) {
                    $nextUrl = str_replace('http://', 'https://', $nextUrl);
                }
                
                // Pausa para evitar rate limiting
                usleep(500000);

            } while ($nextUrl);

            // Paso 3: Calcular saldos reales desde facturas pendientes
            // Wisphub NO usa el campo 'saldo' - calcula deuda sumando facturas pendientes
            $this->syncBalancesFromInvoices($url, $apiKey);

            // Paso 4: Eliminar servicios que ya no existen en Wisphub
            if (count($syncedServiceIds) > 0) {
                $deletedServices = \App\Models\Service::whereNotNull('wisphub_servicio_id')
                    ->whereNotIn('id', $syncedServiceIds)
                    ->delete();
                $stats['deleted_services'] = $deletedServices;
            }

            // Paso 5: Eliminar clientes que ya no tienen servicios
            $deletedCustomers = \App\Models\Customer::whereDoesntHave('services')->delete();
            $stats['deleted_customers'] = $deletedCustomers;

            return [
                'success' => true,
                'message' => sprintf(
                    "Sincronización completada. Servicios: %d sincronizados, %d eliminados. Clientes huérfanos eliminados: %d. Errores: %d",
                    $stats['synced_services'],
                    $stats['deleted_services'],
                    $stats['deleted_customers'],
                    $stats['errors']
                ),
                'stats' => $stats
            ];

        } catch (\Throwable $e) {
            \Illuminate\Support\Facades\Log::error("Error crítico en sincronización Wisphub", [
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);
            
            return [
                'success' => false,
                'message' => "Error crítico: " . $e->getMessage(),
                'stats' => $stats
            ];
        }
    }

    /**
     * Construye el endpoint correcto para consultar clientes
     */
    protected function buildClientEndpoint(string $url): string
    {
        $baseUrl = rtrim($url, '/');
        
        if (str_contains($baseUrl, '/clientes')) {
            return $baseUrl . '/';
        }
        
        if (!str_contains($baseUrl, '/api')) {
            $baseUrl .= '/api';
        }
        
        return $baseUrl . '/clientes/';
    }

    /**
     * Calcula los saldos reales consultando facturas pendientes
     * Wisphub NO usa el campo 'saldo' del cliente - suma facturas pendientes
     */
    protected function syncBalancesFromInvoices(string $baseUrl, string $apiKey): void
    {
        try {
            $host = parse_url($baseUrl, PHP_URL_HOST);
            $scheme = parse_url($baseUrl, PHP_URL_SCHEME) ?: 'https';
            $endpoint = "{$scheme}://{$host}/api/facturas/?limit=300";

            $balances = [];
            $nextUrl = $endpoint;
            $invoiceCount = 0;

            // Paso 1: Recopilar todas las facturas pendientes
            do {
                $response = Http::withHeaders(['Authorization' => 'Api-Key ' . $apiKey])
                    ->timeout(30)
                    ->get($nextUrl);

                if ($response->failed()) {
                    \Illuminate\Support\Facades\Log::warning("syncBalancesFromInvoices: Error al consultar facturas", [
                        'url' => $nextUrl,
                        'status' => $response->status()
                    ]);
                    break;
                }

                $data = $response->json();
                $invoices = $data['results'] ?? [];

                foreach ($invoices as $invoice) {
                    $invoiceCount++;
                    
                    // Solo procesar facturas pendientes
                    if (($invoice['estado'] ?? '') !== 'Pendiente de Pago') {
                        continue;
                    }

                    $invoiceTotal = floatval($invoice['total'] ?? 0);
                    if ($invoiceTotal <= 0) {
                        continue;
                    }

                    // Extraer servicios únicos de esta factura
                    // IMPORTANTE: Una factura puede tener múltiples artículos para el mismo servicio
                    // Solo debemos sumar el total de la factura UNA VEZ por servicio
                    $servicesInInvoice = [];
                    foreach ($invoice['articulos'] ?? [] as $articulo) {
                        $servicioId = $articulo['servicio']['id_servicio'] ?? null;
                        if ($servicioId && !in_array($servicioId, $servicesInInvoice)) {
                            $servicesInInvoice[] = $servicioId;
                        }
                    }

                    // Sumar el total de la factura a cada servicio único
                    foreach ($servicesInInvoice as $servicioId) {
                        $balances[$servicioId] = ($balances[$servicioId] ?? 0) + $invoiceTotal;
                    }
                }

                $nextUrl = $data['next'] ?? null;
                if ($nextUrl) {
                    $nextUrl = str_replace('http://', 'https://', $nextUrl);
                }

                usleep(300000); // Pausa para evitar rate limiting

            } while ($nextUrl);

            // Paso 2: Actualizar balances en la base de datos
            $updatedCount = 0;
            
            // Actualizar servicios con deuda
            foreach ($balances as $wisphubId => $totalBalance) {
                $updated = \App\Models\Service::where('wisphub_servicio_id', $wisphubId)
                    ->update(['balance' => $totalBalance]);
                if ($updated > 0) {
                    $updatedCount++;
                }
            }

            // Poner en 0 los servicios sin deuda pendiente
            \App\Models\Service::whereNotNull('wisphub_servicio_id')
                ->whereNotIn('wisphub_servicio_id', array_keys($balances))
                ->update(['balance' => 0]);

            \Illuminate\Support\Facades\Log::info("syncBalancesFromInvoices completado", [
                'invoices_processed' => $invoiceCount,
                'services_with_debt' => count($balances),
                'services_updated' => $updatedCount
            ]);

        } catch (\Throwable $e) {
            \Illuminate\Support\Facades\Log::error("Error en syncBalancesFromInvoices", [
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);
        }
    }
    
    protected function syncPlans($baseUrl, $apiKey)
    {
        // Limpiar URL base para obtener solo el host
        $host = parse_url($baseUrl, PHP_URL_HOST);
        $scheme = parse_url($baseUrl, PHP_URL_SCHEME) ?: 'https';
        $endpoint = "{$scheme}://{$host}/api/planes-internet/";

        try {
            $response = Http::withHeaders(['Authorization' => 'Api-Key ' . $apiKey])->get($endpoint);
            if ($response->successful()) {
                foreach ($response->json()['results'] ?? [] as $plan) {
                    if (!is_array($plan)) continue;
                    \App\Models\Plan::updateOrCreate(
                        ['wisphub_id' => $plan['id']],
                        [
                            'name' => $plan['nombre'] ?? 'Plan',
                            'download_speed_kbps' => intval(($plan['bajada'] ?? 0) * 1024),
                            'upload_speed_kbps' => intval(($plan['subida'] ?? 0) * 1024),
                            'price' => floatval($plan['precio'] ?? 0),
                        ]
                    );
                }
            }
        } catch (\Throwable $e) {
            \Illuminate\Support\Facades\Log::error("Error syncPlans: " . $e->getMessage());
        }
    }

    protected function syncRouters($baseUrl, $apiKey)
    {
        $host = parse_url($baseUrl, PHP_URL_HOST);
        $scheme = parse_url($baseUrl, PHP_URL_SCHEME) ?: 'https';
        $endpoint = "{$scheme}://{$host}/api/routers/";

        try {
            $response = Http::withHeaders(['Authorization' => 'Api-Key ' . $apiKey])->get($endpoint);
            
            if ($response->successful()) {
                $results = $response->json()['results'] ?? [];
                
                foreach ($results as $routerData) {
                    if (!is_array($routerData)) continue;
                    
                    // Mapeo de Método de Corte (Wisphub -> Local)
                    $metodoCorteWs = (string)($routerData['metodo_corte'] ?? '1');
                    $serviceCutType = match($metodoCorteWs) {
                        '4' => 'ppp_secret',
                        '2' => 'address_list_moroso',
                        '3' => 'hotspot_user',
                        default => 'simple_queue', // '1' o otros
                    };

                    // Mapeo de Versión ROS
                    $versionRos = (str_contains((string)($routerData['version_ros'] ?? ''), '7')) 
                        ? '7_or_higher' : '6_or_lower';

                    if (empty($routerData['id'])) {
                        \Illuminate\Support\Facades\Log::warning("syncRouters: Router sin ID ignorado", $routerData);
                        continue;
                    }

                    \App\Models\Router::updateOrCreate(
                        ['wisphub_id' => $routerData['id']],
                        [
                            'wisphub_id' => $routerData['id'], // Aseguramos que se guarde el ID
                            'name' => $routerData['nombre'] ?? 'Router Wisphub',
                            'ip_address' => $routerData['ip'] ?? '0.0.0.0',
                            'api_user' => $routerData['user_api'] ?? 'admin',
                            'api_password' => $routerData['pass_api'] ?? null,
                            'api_port' => intval($routerData['puerto_api'] ?? 8728),
                            'www_port' => intval($routerData['puerto_www'] ?? 80),
                            'lan_interface' => $routerData['interfaz_lan'] ?? null,
                            'router_os_version' => $versionRos,
                            'service_cut_type' => $serviceCutType,
                            
                            // Switches de control basados en el método
                            'control_pppoe' => ($serviceCutType === 'ppp_secret'),
                            'control_simple_queue' => ($serviceCutType === 'simple_queue' || $serviceCutType === 'address_list_moroso'),
                            'control_hotspot' => ($serviceCutType === 'hotspot_user'),
                            'control_pcq_address_list' => ($serviceCutType === 'address_list_moroso'),
                            
                            // Features generales (asumimos true si están habilitados en WS)
                            'enable_api' => true,
                            'ip_bindings' => ($serviceCutType === 'address_list_moroso' || $serviceCutType === 'hotspot_user'),
                            'dhcp_leases' => ($serviceCutType !== 'ppp_secret'),
                            
                            'coordinates' => $routerData['gps'] ?? null,
                            'comments' => 'Sincronizado desde Wisphub',
                        ]
                    );
                }
            }
        } catch (\Throwable $e) {
            \Illuminate\Support\Facades\Log::error("Error syncRouters: " . $e->getMessage());
        }
    }

    /**
     * Importa un cliente desde Wisphub al CRM local
     * Retorna los IDs del servicio y cliente creados/actualizados
     */
    protected function importClient(array $data): array
    {
        $wisphubId = $data['id_servicio'] ?? $data['id'];
        $name = $data['nombre'] ?? 'Cliente Sin Nombre';
        
        // Concatenar dirección completa
        $addressParts = array_filter([
            $data['direccion'] ?? null,
            $data['localidad'] ?? null,
            $data['ciudad'] ?? null,
        ]);
        $fullAddress = implode("\n", $addressParts);
        
        // Crear o actualizar cliente
        $customer = \App\Models\Customer::updateOrCreate(
            ['wisphub_id' => $wisphubId],
            [
                'name' => $name,
                'email' => $data['email'] ?? null,
                'phone' => $data['telefono'] ?? null,
                'address' => $fullAddress ?: null,
                'coordinates' => $data['coordenadas'] ?? null,
                'installation_date' => $this->parseInstallationDate($data['fecha_instalacion'] ?? null),
            ]
        );

        // Resolver Plan
        $planId = $this->resolvePlan($data);
        
        // Resolver Router
        $routerId = $this->resolveRouter($data);

        // Mapeo directo de estado desde Wisphub
        $statusMap = [
            '1' => 'active', 
            'activo' => 'active', 
            'gratis' => 'active',
            '2' => 'suspended', 
            'suspendido' => 'suspended', 
            'corte' => 'suspended',
            'retirado' => 'cancelled', 
            'cancelado' => 'cancelled'
        ];
        $rawStatus = strtolower((string)($data['estado'] ?? ''));
        $status = $statusMap[$rawStatus] ?? 'active';

        // Crear o actualizar servicio con mapeo DIRECTO desde Wisphub
        $service = $customer->services()->updateOrCreate(
            ['wisphub_servicio_id' => $data['id_servicio'] ?? $wisphubId],
            [
                'router_id' => $routerId,
                'plan_id' => $planId,
                'ip_address' => $data['ip'] ?? null,
                'mac_address' => $data['mac'] ?? null,
                'pppoe_user' => $data['user_pppoe'] ?? null,
                'pppoe_password' => $data['pass_pppoe'] ?? null,
                'status' => $status,
                
                // Mapeo DIRECTO de campos financieros - sin cálculos
                'balance' => floatval($data['saldo'] ?? 0),
                'cut_off_date' => $data['fecha_corte'] ?? null,
                'last_payment_date' => $data['ultima_fecha_pago'] ?? null,
                'billing_day' => isset($data['dia_pago']) ? intval($data['dia_pago']) : null,
                'billing_notes' => $data['comentarios'] ?? null,
            ]
        );

        return [
            'service_id' => $service->id,
            'customer_id' => $customer->id
        ];
    }

    /**
     * Parsea la fecha de instalación desde el formato de Wisphub
     */
    protected function parseInstallationDate(?string $rawDate): ?string
    {
        if (empty($rawDate) || $rawDate === 'None') {
            return null;
        }

        try {
            // Formato Wisphub: 15/01/2026 14:49:00
            return \Carbon\Carbon::createFromFormat('d/m/Y H:i:s', $rawDate)->format('Y-m-d');
        } catch (\Throwable $e) {
            // Fallback
            try {
                return \Carbon\Carbon::parse($rawDate)->format('Y-m-d');
            } catch (\Throwable $e2) {
                return null;
            }
        }
    }

    /**
     * Resuelve el plan desde los datos de Wisphub
     */
    protected function resolvePlan(array $data): ?int
    {
        $planData = $data['plan_internet'] ?? null;
        
        if (is_array($planData) && isset($planData['id'])) {
            $plan = \App\Models\Plan::updateOrCreate(
                ['wisphub_id' => $planData['id']],
                [
                    'name' => $planData['nombre'] ?? 'Plan Desconocido',
                    'download_speed_kbps' => 0,
                    'upload_speed_kbps' => 0,
                    'price' => floatval($data['precio_plan'] ?? 0),
                ]
            );
            return $plan->id;
        }
        
        // Fallback
        $planName = is_array($planData) ? ($planData['nombre'] ?? 'Plan Desconocido') : ($planData ?? 'Plan Desconocido');
        $plan = \App\Models\Plan::updateOrCreate(
            ['name' => $planName],
            [
                'download_speed_kbps' => 0,
                'upload_speed_kbps' => 0,
                'price' => floatval($data['precio_plan'] ?? 0),
            ]
        );
        return $plan->id;
    }

    /**
     * Resuelve el router desde los datos de Wisphub
     */
    protected function resolveRouter(array $data): ?int
    {
        $routerData = $data['router'] ?? null;
        
        if (is_array($routerData) && isset($routerData['id'])) {
            $router = \App\Models\Router::where('wisphub_id', $routerData['id'])->first();
            
            if (!$router) {
                $router = \App\Models\Router::create([
                    'wisphub_id' => $routerData['id'],
                    'name' => $routerData['nombre'] ?? 'Router Nuevo',
                    'ip_address' => $routerData['ip'] ?? '0.0.0.0',
                    'type' => 'mikrotik',
                    'api_port' => 8728,
                ]);
            }
            return $router->id;
        }
        
        // Fallback
        $routerName = is_array($routerData) ? ($routerData['nombre'] ?? 'Router Desconocido') : ($routerData ?? 'Router Desconocido');
        $router = \App\Models\Router::firstOrCreate(
            ['name' => $routerName],
            ['ip_address' => '0.0.0.0', 'type' => 'mikrotik']
        );
        return $router->id;
    }
}
