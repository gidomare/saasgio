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
        Schema::table('vpn_tunnels', function (Blueprint $table) {
            $table->string('test_ip')->nullable()->after('config_content');
            $table->string('status')->default('pending')->after('is_active'); // connected, disconnected, pending
            $table->integer('last_latency')->nullable()->after('status'); // ms
            $table->integer('last_packet_loss')->nullable()->after('last_latency'); // %
            $table->timestamp('last_check_at')->nullable()->after('last_packet_loss');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('vpn_tunnels', function (Blueprint $table) {
            //
        });
    }
};
