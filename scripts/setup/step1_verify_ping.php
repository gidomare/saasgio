#!/usr/bin/env php
<?php

require __DIR__ . '/vendor/autoload.php';
$app = require_once __DIR__ . '/bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

use App\Services\Olt\Vsol\VsolTelnetDriver;
use App\Models\Olt;

$olt = Olt::latest()->first();

$driver = new VsolTelnetDriver([
    'host' => $olt->ip_admin,
    'port' => $olt->telnet_port,
    'username' => $olt->username,
    'password' => $olt->password,
    'timeout' => 30, // Increased timeout for ping
    'prompt_regex' => '/(?:OLT[>#]|PUENTE[A-Z0-9_]*[>#]|[#>])\s*$/m',
]);

echo "=== STEP 1: Ping 10.150.1.4 from OLT ===\n";

// Try standard ping
echo "Executing: ping 10.150.1.4 count 4\n";
try {
    // Try without count first if syntax differs, but usually count is supported
    // Some V-SOLs use 'ping ip x.x.x.x' or just 'ping x.x.x.x'
    $out = $driver->run('ping 10.150.1.4 count 4', 10);
    echo "Output:\n" . $out . "\n\n";
} catch (\Exception $e) {
    echo "Ping failed: " . $e->getMessage() . "\n";
    echo "Retrying with simple ping...\n";
    try {
        $out = $driver->run('ping 10.150.1.4', 10);
        echo "Output:\n" . $out . "\n\n";
    } catch (\Exception $ex) {
         echo "Simple Ping failed: " . $ex->getMessage() . "\n\n";
    }
}

echo "=== Verifying Network Config ===\n";
try {
    $out = $driver->run('show ip route', 5);
    echo "Command: show ip route\nOutput:\n" . $out . "\n\n";
    
    $out = $driver->run('show ip interface brief', 5); // Common command
    echo "Command: show ip interface brief\nOutput:\n" . $out . "\n\n";
} catch (\Exception $e) {
    echo "Network verification commands failed: " . $e->getMessage() . "\n";
}
