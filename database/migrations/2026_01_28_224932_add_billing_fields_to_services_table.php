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
        Schema::table('services', function (Blueprint $table) {
            $table->decimal('balance', 10, 2)->default(0)->after('status');
            $table->string('cut_off_date')->nullable()->after('balance');
            $table->string('last_payment_date')->nullable()->after('cut_off_date');
            $table->integer('billing_day')->nullable()->after('last_payment_date');
            $table->text('billing_notes')->nullable()->after('billing_day');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('services', function (Blueprint $table) {
            $table->dropColumn(['balance', 'cut_off_date', 'last_payment_date', 'billing_day', 'billing_notes']);
        });
    }
};
