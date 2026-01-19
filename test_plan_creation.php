<?php

require __DIR__.'/vendor/autoload.php';

$app = require_once __DIR__.'/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

echo "Testing Plan creation...\n";

try {
    // Test 1: Simple create
    echo "Test 1: Simple create with 0 values\n";
    $plan1 = \App\Models\Plan::create([
        'name' => 'Test Plan 1',
        'download_speed_kbps' => 0,
        'upload_speed_kbps' => 0,
        'price' => 0
    ]);
    echo "✓ Test 1 passed - ID: {$plan1->id}\n";
    
    // Test 2: updateOrCreate
    echo "\nTest 2: updateOrCreate with 0 values\n";
    $plan2 = \App\Models\Plan::updateOrCreate(
        ['name' => 'Test Plan 2'],
        [
            'download_speed_kbps' => 0,
            'upload_speed_kbps' => 0,
            'price' => 0
        ]
    );
    echo "✓ Test 2 passed - ID: {$plan2->id}\n";
    
    // Test 3: updateOrCreate with intval
    echo "\nTest 3: updateOrCreate with intval\n";
    $plan3 = \App\Models\Plan::updateOrCreate(
        ['name' => 'Test Plan 3'],
        [
            'download_speed_kbps' => intval(0),
            'upload_speed_kbps' => intval(0),
            'price' => floatval(0)
        ]
    );
    echo "✓ Test 3 passed - ID: {$plan3->id}\n";
    
    echo "\n✓ All tests passed!\n";
    
} catch (\Throwable $e) {
    echo "\n✗ Error: " . $e->getMessage() . "\n";
    echo "File: " . $e->getFile() . ":" . $e->getLine() . "\n";
    echo "\nStack trace:\n" . $e->getTraceAsString() . "\n";
}
