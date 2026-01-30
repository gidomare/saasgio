<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('onus', function (Blueprint $table) {
            $table->id();
            
            // Relación con OLT
            $table->foreignId('olt_id')->constrained()->onDelete('cascade');
            
            // Identificación ONU
            $table->string('serial_number')->unique(); // FHTT12345678
            $table->string('name')->nullable(); // Nombre descriptivo
            $table->string('port'); // 1/1/1 (PON port)
            $table->integer('onu_id'); // ID en el puerto (1-128)
            $table->string('onu_type')->default('default'); // Tipo de ONU
            
            // Estado y conexión
            $table->enum('status', ['online', 'offline', 'los', 'unknown'])->default('unknown');
            $table->string('auth_state')->nullable(); // authorized, unauthorized
            $table->timestamp('last_online_at')->nullable();
            $table->timestamp('last_offline_at')->nullable();
            
            // Información óptica
            $table->decimal('rx_power', 8, 2)->nullable(); // dBm
            $table->decimal('tx_power', 8, 2)->nullable(); // dBm
            $table->decimal('olt_rx_power', 8, 2)->nullable(); // dBm (power received by OLT)
            $table->decimal('temperature', 8, 2)->nullable(); // °C
            $table->decimal('voltage', 8, 2)->nullable(); // V
            $table->decimal('bias_current', 8, 2)->nullable(); // mA
            $table->decimal('distance', 8, 2)->nullable(); // km
            
            // Configuración de servicio
            $table->integer('vlan')->nullable(); // VLAN ID
            $table->string('line_profile')->nullable();
            $table->string('service_profile')->nullable();
            $table->string('dba_profile')->nullable();
            
            // MAC Address
            $table->string('mac_address')->nullable();
            
            // Información del equipo
            $table->string('vendor')->nullable();
            $table->string('model')->nullable();
            $table->string('firmware_version')->nullable();
            $table->string('hardware_version')->nullable();
            
            // Estadísticas
            $table->bigInteger('bytes_sent')->default(0);
            $table->bigInteger('bytes_received')->default(0);
            $table->integer('uptime_seconds')->default(0);
            
            // Relación con cliente (opcional)
            $table->foreignId('customer_id')->nullable()->constrained()->onDelete('set null');
            $table->foreignId('service_id')->nullable()->constrained()->onDelete('set null');
            
            // Notas y metadata
            $table->text('notes')->nullable();
            $table->json('raw_data')->nullable(); // Datos raw del OLT
            
            // Timestamps
            $table->timestamp('discovered_at')->nullable(); // Primera vez visto
            $table->timestamp('provisioned_at')->nullable(); // Cuando se aprovisionó
            $table->timestamps();
            
            // Índices
            $table->index(['olt_id', 'port', 'onu_id']);
            $table->index('status');
            $table->index('customer_id');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('onus');
    }
};
