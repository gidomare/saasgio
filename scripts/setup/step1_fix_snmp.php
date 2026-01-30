#!/usr/bin/env php
<?php

require __DIR__ . '/vendor/autoload.php';
$app = require_once __DIR__ . '/bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

use App\Services\Olt\Vsol\VsolTelnetDriver;
use App\Models\Olt;

$olt = Olt::latest()->first();

echo "=== STEP 1: CORRECTING SNMP CONFIGURATION ===\n";

$driver = new VsolTelnetDriver([
    'host' => $olt->ip_admin,
    'port' => $olt->telnet_port,
    'username' => $olt->username,
    'password' => $olt->password,
    'timeout' => 30,
    'prompt_regex' => '/(?:OLT[>#]|PUENTE[A-Z0-9_]*[>#]|[#>])\s*$/m',
]);

echo "Entering config mode...\n";
$driver->run('configure terminal', 5);

// 1. Remove bad hosts if possible (optional, but good practice)
// "no snmp-server host 255.255.255.0" might work
echo "Cleaning old config (best effort)...\n";
try {
    $driver->run('no snmp-server host 255.255.255.0 version 2c community public', 2);
} catch (\Exception $e) { echo "Ignored error cleaning host.\n"; }

// 2. Set correct host
echo "Setting correct trap host (10.150.1.4)...\n";
// Removing "traps" keyword as it caused "Unknown command" before, trying standard syntax
// OLT often uses: snmp-server host IP version 2c community COMM
$out = $driver->run('snmp-server host 10.150.1.4 version 2c community public', 5);
echo $out . "\n";

// 3. Ensure traps are enabled
echo "Enabling traps...\n";
$driver->run('snmp-server enable traps', 2);

// 4. Save
echo "Saving...\n";
$driver->run('end', 2);
$driver->run('write memory', 10);

echo "\n=== VERIFYING CONFIG ===\n";
$config = $driver->run('show running-config', 60);
$lines = explode("\n", $config);
foreach ($lines as $line) {
    if (stripos($line, 'snmp') !== false) {
        echo trim($line) . "\n";
    }
}
