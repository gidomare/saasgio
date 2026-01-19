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
            $table->unsignedBigInteger('wisphub_id')->nullable()->unique()->after('id');
        });
        Schema::table('plans', function (Blueprint $table) {
            $table->unsignedBigInteger('wisphub_id')->nullable()->unique()->after('id');
        });
        Schema::table('services', function (Blueprint $table) {
            $table->unsignedBigInteger('wisphub_servicio_id')->nullable()->unique()->after('id');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('tables', function (Blueprint $table) {
            //
        });
    }
};
