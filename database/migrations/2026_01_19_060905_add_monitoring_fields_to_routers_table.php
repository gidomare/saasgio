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
        Schema::table('routers', function (Blueprint $table) {
            $table->boolean('is_online')->default(false)->after('type');
            $table->string('routeros_version')->nullable()->after('is_online');
            $table->integer('cpu_load')->nullable()->after('routeros_version')->comment('Porcentaje de uso de CPU');
            $table->bigInteger('memory_used_bytes')->nullable()->after('cpu_load');
            $table->bigInteger('memory_total_bytes')->nullable()->after('memory_used_bytes');
            $table->string('uptime')->nullable()->after('memory_total_bytes');
            $table->timestamp('last_checked_at')->nullable()->after('uptime');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('routers', function (Blueprint $table) {
            //
        });
    }
};
