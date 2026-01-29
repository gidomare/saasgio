<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class BotKnowledgeBase extends Model
{
    protected $table = 'bot_knowledge_base';

    protected $fillable = [
        'bot_id',
        'question_normalized',
        'answer',
        'usage_count',
    ];

    public function bot()
    {
        return $this->belongsTo(Bot::class);
    }
}
