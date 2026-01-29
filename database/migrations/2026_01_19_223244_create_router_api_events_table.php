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
        Schema::create('router_api_events', function (Blueprint $table) {
            $table->id();
            $table->foreignId('router_id')->constrained()->cascadeOnDelete();
            $table->string('event_name');
            $table->enum('event_type', ['connect', 'disconnect', 'suspend', 'activate']);
            $table->string('http_method')->default('POST');
            $table->text('endpoint_url');
            $table->json('headers')->nullable();
            $table->text('payload_template')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('router_api_events');
    }
};
