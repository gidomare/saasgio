<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Router extends Model
{
    protected $fillable = [
        'name',
        'ip_address',
        'api_user',
        'api_password',
        'api_port',
        'type',
        'wisphub_id',
        'is_online',
        'routeros_version',
        'cpu_load',
        'memory_used_bytes',
        'memory_total_bytes',
        'uptime',
        'last_checked_at',
    ];

    protected $casts = [
        'api_password' => 'encrypted',
        'is_online' => 'boolean',
        'last_checked_at' => 'datetime',
    ];
}
