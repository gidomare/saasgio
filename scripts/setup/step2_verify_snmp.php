#!/usr/bin/env php
<?php

require __DIR__ . '/vendor/autoload.php';
$app = require_once __DIR__ . '/bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

use App\Services\Olt\Vsol\VsolTelnetDriver;
use App\Models\Olt;

$olt = Olt::latest()->first();

echo "=== STEP 2: Verify SNMP Configuration on OLT ===\n";

$driver = new VsolTelnetDriver([
    'host' => $olt->ip_admin,
    'port' => $olt->telnet_port,
    'username' => $olt->username,
    'password' => $olt->password,
    'timeout' => 30,
    'prompt_regex' => '/(?:OLT[>#]|PUENTE[A-Z0-9_]*[>#]|[#>])\s*$/m',
]);

try {
    // Read full config and filter for SNMP
    echo "Reading running-config...\n";
    $config = $driver->run('show running-config', 60);
    
    echo "\n--- SNMP Configuration Found --- \n";
    $lines = explode("\n", $config);
    $snmpFound = false;
    foreach ($lines as $line) {
        if (stripos($line, 'snmp') !== false) {
            echo trim($line) . "\n";
            $snmpFound = true;
        }
    }
    
    if (!$snmpFound) {
        echo "No 'snmp' commands found in running-config!\n";
    }
} catch (\Exception $e) {
    echo "Failed to read config: " . $e->getMessage() . "\n";
}

echo "\n=== STEP 3: Verify Connection from CRM to OLT ===\n";

$oltIp = $olt->ip_admin;
echo "Target OLT IP: $oltIp\n";

// 1. Ping from CRM
echo "\n1. Ping Check (CRM -> OLT):\n";
$pingCmd = "ping -c 3 $oltIp 2>&1";
echo shell_exec($pingCmd) . "\n";

// 2. SNMP Walk from CRM
echo "2. SNMP Walk Check (CRM -> OLT):\n";
$snmpCmd = "snmpwalk -v2c -c public -Oqn $oltIp system 2>&1";
echo "Executing: $snmpCmd\n";
echo shell_exec($snmpCmd) . "\n";
