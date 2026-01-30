<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class OltEvent extends Model
{
    protected $fillable = [
        'olt_id',
        'event_type',
        'onu_sn',
        'port',
        'onu_id',
        'severity',
        'trap_data',
        'message',
        'received_at',
    ];

    protected $casts = [
        'trap_data' => 'array',
        'received_at' => 'datetime',
    ];

    public function olt(): BelongsTo
    {
        return $this->belongsTo(Olt::class);
    }
}
