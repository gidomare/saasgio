<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('bots', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->text('description')->nullable();
            $table->boolean('is_active')->default(true);
            $table->boolean('test_mode')->default(false);
            $table->json('whitelist')->nullable();
            $table->json('schedules')->nullable();
            
            // IA Config
            $table->boolean('ai_enabled')->default(false);
            $table->string('ai_provider')->default('openai');
            $table->text('ai_api_key')->nullable();
            $table->string('ai_model')->default('gpt-3.5-turbo');
            $table->integer('ai_max_tokens')->default(150);
            $table->integer('ai_daily_token_limit')->default(10000);
            
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('bots');
    }
};
