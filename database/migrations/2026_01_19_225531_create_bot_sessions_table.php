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
        Schema::create('bot_sessions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('bot_id')->constrained()->cascadeOnDelete();
            $table->string('phone_number')->index();
            $table->unsignedBigInteger('current_step_id')->nullable();
            $table->json('variables')->nullable(); // Almacenará datos capturados (nombre, etc.)
            $table->timestamp('last_interaction_at')->nullable();
            $table->timestamps();
            
            $table->index(['bot_id', 'phone_number']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('bot_sessions');
    }
};
