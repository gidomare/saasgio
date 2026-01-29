<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class BotSession extends Model
{
    protected $fillable = [
        'bot_id',
        'phone_number',
        'current_step_id',
        'variables',
        'last_interaction_at',
    ];

    protected $casts = [
        'variables' => 'array',
        'last_interaction_at' => 'datetime',
    ];

    public function bot()
    {
        return $this->belongsTo(Bot::class);
    }

    public function currentStep()
    {
        return $this->belongsTo(BotStep::class, 'current_step_id');
    }
}
