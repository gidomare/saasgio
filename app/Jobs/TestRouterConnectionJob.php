<?php

namespace App\Jobs;

use App\Models\Router;
use App\Services\Network\MikrotikDriver;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Log;
use Filament\Notifications\Notification;

class TestRouterConnectionJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public function __construct(
        public Router $router
    ) {}

    public function handle(): void
    {
        try {
            $driver = new MikrotikDriver();
            $connected = $driver->connect([
                'host' => $this->router->ip_address,
                'port' => $this->router->api_port,
                'username' => $this->router->api_user ?? 'admin',
                'password' => $this->router->api_password ?? '',
            ]);

            if ($connected) {
                $info = $driver->getSystemInfo();
                $driver->disconnect();

                if (isset($info['error'])) {
                    $this->router->update([
                        'is_online' => true,
                        'last_checked_at' => now(),
                    ]);
                    Log::warning("Router {$this->router->name}: Conectado pero error leyendo info - {$info['error']}");

                    Notification::make()
                        ->warning()
                        ->title('Router Conectado con Advertencias')
                        ->body("Se estableció conexión con {$this->router->name}, pero no se pudo leer la información del sistema.")
                        ->send();
                } else {
                    // Guardar información del router
                    $this->router->update([
                        'is_online' => true,
                        'routeros_version' => $info['version'],
                        'cpu_load' => $info['cpu_load'],
                        'memory_used_bytes' => $info['total_memory'] - $info['free_memory'],
                        'memory_total_bytes' => $info['total_memory'],
                        'uptime' => $info['uptime'],
                        'last_checked_at' => now(),
                    ]);
                    
                    $memoryUsedMB = $info['total_memory'] > 0 ? round(($info['total_memory'] - $info['free_memory']) / 1048576, 2) : 0;
                    $memoryTotalMB = round($info['total_memory'] / 1048576, 2);
                    
                    Log::info("Router {$this->router->name}: En línea - Versión: {$info['version']}, CPU: {$info['cpu_load']}%, RAM: {$memoryUsedMB}/{$memoryTotalMB} MB");

                    Notification::make()
                        ->success()
                        ->title('✓ Router en Línea: ' . $this->router->name)
                        ->body("**Versión:** {$info['version']}\n**CPU:** {$info['cpu_load']}%\n**RAM:** {$memoryUsedMB} / {$memoryTotalMB} MB")
                        ->duration(5000)
                        ->send();
                }
            } else {
                $this->router->update([
                    'is_online' => false,
                    'last_checked_at' => now(),
                ]);
                Log::warning("Router {$this->router->name}: No se pudo conectar");

                Notification::make()
                    ->danger()
                    ->title('✗ Error de Conexión: ' . $this->router->name)
                    ->body('No se pudo establecer conexión con el router. Verifica la IP, puerto y credenciales.')
                    ->persistent()
                    ->send();
            }
        } catch (\Exception $e) {
            $this->router->update([
                'is_online' => false,
                'last_checked_at' => now(),
            ]);
            Log::error("Error probando router {$this->router->name}: " . $e->getMessage());

            Notification::make()
                ->danger()
                ->title('Error Crítico en ' . $this->router->name)
                ->body($e->getMessage())
                ->send();
        }
    }
}
