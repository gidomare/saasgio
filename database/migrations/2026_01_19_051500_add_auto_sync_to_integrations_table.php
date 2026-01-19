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
        Schema::table('integrations', function (Blueprint $table) {
            $table->boolean('auto_sync')->default(false)->after('settings');
            $table->integer('sync_interval_minutes')->default(60)->after('auto_sync');
            $table->timestamp('last_synced_at')->nullable()->after('sync_interval_minutes');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('integrations', function (Blueprint $table) {
            //
        });
    }
};
