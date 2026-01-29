<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Bot extends Model
{
    protected $fillable = [
        'name',
        'description',
        'is_active',
        'test_mode',
        'whitelist',
        'schedules',
        'ai_enabled',
        'ai_provider',
        'ai_api_key',
        'ai_model',
        'ai_max_tokens',
        'ai_daily_token_limit',
        'chatwoot_enabled',
        'chatwoot_url',
        'chatwoot_token',
        'chatwoot_account_id',
        'chatwoot_inbox_id',
    ];

    protected $casts = [
        'is_active' => 'boolean',
        'test_mode' => 'boolean',
        'whitelist' => 'array',
        'schedules' => 'array',
        'ai_enabled' => 'boolean',
        'ai_api_key' => 'encrypted',
        'chatwoot_enabled' => 'boolean',
        'chatwoot_token' => 'encrypted',
    ];

    public function steps()
    {
        return $this->hasMany(BotStep::class)->orderBy('order');
    }

    public function sessions()
    {
        return $this->hasMany(BotSession::class);
    }

    public function knowledgeItems()
    {
        return $this->hasMany(BotKnowledgeBase::class);
    }

    public function usageLogs()
    {
        return $this->hasMany(BotUsageLog::class);
    }
}
