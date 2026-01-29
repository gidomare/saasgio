<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class BotUsageLog extends Model
{
    protected $fillable = [
        'bot_id',
        'phone_number',
        'interaction_type',
        'tokens_used',
        'cost',
        'metadata',
    ];

    protected $casts = [
        'metadata' => 'array',
    ];

    public function bot()
    {
        return $this->belongsTo(Bot::class);
    }
}
