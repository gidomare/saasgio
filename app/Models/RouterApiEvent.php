<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class RouterApiEvent extends Model
{
    protected $fillable = [
        'router_id',
        'event_name',
        'event_type',
        'http_method',
        'endpoint_url',
        'headers',
        'payload_template'
    ];

    protected $casts = [
        'headers' => 'array',
    ];

    public function router()
    {
        return $this->belongsTo(Router::class);
    }
}
