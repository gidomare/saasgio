<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Integration extends Model
{
    protected $fillable = [
        'name',
        'slug',
        'settings',
        'is_active',
        'auto_sync',
        'sync_interval_minutes',
        'last_synced_at',
    ];

    protected $casts = [
        'settings' => 'array',
        'is_active' => 'boolean',
        'auto_sync' => 'boolean',
        'last_synced_at' => 'datetime',
    ];
}
