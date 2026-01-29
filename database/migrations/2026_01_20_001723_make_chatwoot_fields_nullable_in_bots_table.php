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
            $table->boolean('chatwoot_enabled')->default(false)->nullable()->change();
            $table->string('chatwoot_url')->nullable()->change();
            $table->text('chatwoot_token')->nullable()->change();
            $table->string('chatwoot_account_id')->nullable()->change();
            $table->string('chatwoot_inbox_id')->nullable()->change();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('bots', function (Blueprint $table) {
            //
        });
    }
};
