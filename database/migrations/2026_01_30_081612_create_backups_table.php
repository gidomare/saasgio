<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('backups', function (Blueprint $table) {
            $table->id();
            $table->string('name'); // backup-2026-01-30-02-00-00.zip
            $table->string('path'); // storage/app/backups/...
            $table->string('disk')->default('local');
            $table->bigInteger('size')->default(0); // bytes
            $table->string('type')->default('manual'); // manual, automatic
            $table->string('status')->default('completed'); // pending, completed, failed
            $table->text('error_message')->nullable();
            $table->string('hash')->nullable(); // MD5 hash for integrity
            $table->json('metadata')->nullable(); // additional info
            $table->timestamp('completed_at')->nullable();
            $table->timestamps();
            
            $table->index('created_at');
            $table->index('status');
            $table->index('type');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('backups');
    }
};
