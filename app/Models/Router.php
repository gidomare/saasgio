<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Router extends Model
{
    protected $fillable = [
        'wisphub_id',
        'name',
        'ip_address', // Alias de 'ip' para compatibilidad
        'failover_ip',
        'api_user',
        'api_password',
        'api_port',
        'www_port',
        'lan_interface',
        'router_os_version',
        'external_id',
        'comments',
        'coordinates',
        'service_cut_type',
        'enable_api',
        'auto_add_client',
        'system_ip_pool',
        'traffic_history',
        'general_failover',
        'ipv6_enabled',
        'control_simple_queue',
        'control_pcq_address_list',
        'control_hotspot',
        'control_pppoe',
        'ip_bindings',
        'ip_mac_binding',
        'dhcp_leases',
        'ppp_speed_control_mode',
        'on_connect_script',
        'on_disconnect_script',
        'is_online',
        'cpu_load',
        'memory_used_bytes',
        'memory_total_bytes',
        'uptime',
        'last_checked_at',
    ];

    protected $casts = [
        'api_password' => 'encrypted',
        'is_online' => 'boolean',
        'enable_api' => 'boolean',
        'auto_add_client' => 'boolean',
        'system_ip_pool' => 'boolean',
        'traffic_history' => 'boolean',
        'general_failover' => 'boolean',
        'ipv6_enabled' => 'boolean',
        'control_simple_queue' => 'boolean',
        'control_pcq_address_list' => 'boolean',
        'control_hotspot' => 'boolean',
        'control_pppoe' => 'boolean',
        'ip_bindings' => 'boolean',
        'ip_mac_binding' => 'boolean',
        'dhcp_leases' => 'boolean',
        'last_checked_at' => 'datetime',
    ];

    protected static function boot()
    {
        parent::boot();

        static::saving(function ($router) {
            // Si el router es nuevo y no se pasaron controles, saltamos validación para permitir creación inicial
            if (!$router->exists && !$router->control_pppoe && !$router->control_simple_queue) {
                return;
            }

            // 1. Validar que solo un método de control esté activo
            $controls = [
                $router->control_simple_queue,
                $router->control_pcq_address_list,
                $router->control_hotspot,
                $router->control_pppoe,
            ];
            
            if (count(array_filter($controls)) > 1) {
                throw new \Exception('Error: No se permite activar más de un método de control simultáneamente.');
            }

            // 2. Validaciones específicas de PPPoE
            if ($router->service_cut_type === 'ppp_secret' && !$router->control_pppoe) {
                throw new \Exception('Error: Si el corte es por ppp_secret, el Control PPPoE debe estar activo.');
            }
        });
    }

    public function ipRanges()
    {
        return $this->hasMany(RouterIpRange::class);
    }

    public function apiEvents()
    {
        return $this->hasMany(RouterApiEvent::class);
    }
}
