<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class VpnTunnel extends Model
{
    protected $fillable = [
        'name',
        'config_content',
        'is_active',
        'test_ip',
        'status',
        'last_latency',
        'last_packet_loss',
        'last_check_at',
        'last_test_output',
    ];

    protected $casts = [
        'is_active' => 'boolean',
        'last_check_at' => 'datetime',
    ];

    protected static function boot()
    {
        parent::boot();

        static::saved(function ($tunnel) {
            $configDir = '/config/wg_confs';
            
            if (!file_exists($configDir)) {
                @mkdir($configDir, 0755, true);
            }

            $filename = "{$configDir}/{$tunnel->name}.conf";

            if ($tunnel->is_active) {
                $content = trim($tunnel->config_content) . "\n";
                file_put_contents($filename, $content);

                // Disparar validación asíncrona
                $cmd = "php artisan vpn:test {$tunnel->id} > /dev/null 2>&1 &";
                exec($cmd);
            } else {
                if (file_exists($filename)) {
                    unlink($filename);
                }
                file_put_contents("{$filename}.disabled", $tunnel->config_content);
            }
        });

        static::deleted(function ($tunnel) {
            $configDir = '/config/wg_confs';
            $filename = "{$configDir}/{$tunnel->name}.conf";
            if (file_exists($filename)) {
                unlink($filename);
            }
        });
    }
}
