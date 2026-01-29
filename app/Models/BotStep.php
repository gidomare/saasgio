<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class BotStep extends Model
{
    protected $fillable = [
        'bot_id',
        'name',
        'type',
        'content',
        'next_step_id',
        'order',
    ];

    protected $casts = [
        'content' => 'array',
    ];

    public function bot()
    {
        return $this->belongsTo(Bot::class);
    }

    public function nextStep()
    {
        return $this->belongsTo(BotStep::class, 'next_step_id');
    }
}
