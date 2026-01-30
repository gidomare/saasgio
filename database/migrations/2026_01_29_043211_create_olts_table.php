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
        Schema::create('olts', function (Blueprint $table) {
            $table->id();
            
            // Basic Info
            $table->string('name');
            $table->string('ip_admin');
            $table->string('ip_private')->nullable();
            $table->string('model')->default('VSOL-V1600');
            $table->string('pon_type')->default('GPON'); // GPON, EPON, XPON
            
            // Connection Ports
            $table->integer('ssh_port')->default(22);
            $table->integer('telnet_port')->default(23);
            $table->integer('snmp_port')->default(161);
            
            // SNMP v2c
            $table->string('snmp_community_read')->default('public');
            $table->string('snmp_community_write')->default('private');
            
            // Credentials (encrypted)
            $table->string('username')->nullable();
            $table->text('password')->nullable();
            
            // Optional Script (for Mikrotik proxy)
            $table->text('admin_olt_script')->nullable();
            
            // Status & Monitoring
            $table->string('status')->default('unknown'); // online, offline, error, testing
            $table->timestamp('last_check_at')->nullable();
            $table->text('last_check_output')->nullable();
            
            // Hardware Info (read from OLT)
            $table->json('hardware_info')->nullable(); // firmware, uptime, cpu, temp, etc.
            
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('olts');
    }
};
