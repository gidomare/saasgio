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
            // Información General
            if (!Schema::hasColumn('routers', 'failover_ip')) {
                $table->string('failover_ip')->nullable()->after('ip_address');
            }
            if (!Schema::hasColumn('routers', 'api_user')) {
                $table->string('api_user')->nullable()->after('failover_ip');
            }
            if (!Schema::hasColumn('routers', 'api_password')) {
                $table->text('api_password')->nullable()->after('api_user');
            }
            if (!Schema::hasColumn('routers', 'api_port')) {
                $table->integer('api_port')->default(8728)->after('api_password');
            }
            $table->integer('www_port')->default(80)->after('api_port');
            $table->string('lan_interface')->nullable()->after('www_port');
            $table->enum('router_os_version', ['7_or_higher', '6_or_lower'])->default('7_or_higher')->after('lan_interface');
            $table->string('external_id')->nullable()->after('router_os_version');
            $table->text('comments')->nullable()->after('external_id');
            $table->string('coordinates')->nullable()->after('comments');

            // Campo Clave: Tipo de Corte
            $table->enum('service_cut_type', [
                'ppp_secret', 
                'address_list_moroso', 
                'simple_queue', 
                'hotspot_user'
            ])->default('ppp_secret')->after('coordinates');

            // Switches / Features (Generales)
            $table->boolean('enable_api')->default(true);
            $table->boolean('auto_add_client')->default(false);
            $table->boolean('system_ip_pool')->default(false);
            $table->boolean('traffic_history')->default(false);
            $table->boolean('general_failover')->default(false);
            $table->boolean('ipv6_enabled')->default(false);

            // Métodos de Control (Mutuamente excluyentes)
            $table->boolean('control_simple_queue')->default(false);
            $table->boolean('control_pcq_address_list')->default(false);
            $table->boolean('control_hotspot')->default(false);
            $table->boolean('control_pppoe')->default(false);

            // Binding / DHCP
            $table->boolean('ip_bindings')->default(false);
            $table->boolean('ip_mac_binding')->default(false);
            $table->boolean('dhcp_leases')->default(false);

            // Config PPPoE
            $table->enum('ppp_speed_control_mode', [
                'profile_ppp_dynamic_queue',
                'simple_queue_ppp'
            ])->nullable();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('routers', function (Blueprint $table) {
            $table->dropColumn([
                'failover_ip',
                'www_port',
                'lan_interface',
                'router_os_version',
                'external_id',
                'comments',
                'coordinates',
                'service_cut_type',
                'enable_api',
                'auto_add_client',
                'system_ip_pool',
                'traffic_history',
                'general_failover',
                'ipv6_enabled',
                'control_simple_queue',
                'control_pcq_address_list',
                'control_hotspot',
                'control_pppoe',
                'ip_bindings',
                'ip_mac_binding',
                'dhcp_leases',
                'ppp_speed_control_mode'
            ]);
        });
    }
};
