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
        Schema::table('bots', function (Blueprint $table) {
            $table->boolean('chatwoot_enabled')->default(false);
            $table->string('chatwoot_url')->nullable();
            $table->text('chatwoot_token')->nullable();
            $table->string('chatwoot_account_id')->nullable();
            $table->string('chatwoot_inbox_id')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('bots', function (Blueprint $table) {
            $table->dropColumn(['chatwoot_enabled', 'chatwoot_url', 'chatwoot_token', 'chatwoot_account_id', 'chatwoot_inbox_id']);
        });
    }
};
