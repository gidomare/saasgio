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
        Schema::create('olt_events', function (Blueprint $table) {
            $table->id();
            $table->foreignId('olt_id')->constrained('olts')->onDelete('cascade');
            $table->string('event_type'); // onu_register, onu_deregister, onu_los, etc.
            $table->string('onu_sn')->nullable(); // ONU Serial Number
            $table->string('port')->nullable(); // PON port (e.g., gpon-olt_1/1/1)
            $table->integer('onu_id')->nullable(); // ONU ID on port
            $table->string('severity')->default('info'); // info, warning, critical
            $table->json('trap_data')->nullable(); // Raw trap data
            $table->text('message')->nullable(); // Human-readable message
            $table->timestamp('received_at');
            $table->timestamps();
            
            $table->index(['olt_id', 'received_at']);
            $table->index('event_type');
            $table->index('onu_sn');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('olt_events');
    }
};
