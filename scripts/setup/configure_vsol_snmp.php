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
    'timeout' => 20,
    'prompt_regex' => '/(?:OLT[>#]|PUENTE[A-Z0-9_]*[>#]|[#>]|\(config\)[>#])\s*$/m',
]);

echo "=== Configuring SNMP on VSOL OLT ===\n\n";

// Enter config mode
echo "Entering configuration mode...\n";
$driver->run('configure terminal', 5);

// Configure SNMP community (read-only)
echo "Setting SNMP community 'public' (read-only)...\n";
$out = $driver->run('snmp-server community public ro', 5);
echo $out . "\n\n";

// Configure SNMP community (read-write) - optional
echo "Setting SNMP community 'private' (read-write)...\n";
$out = $driver->run('snmp-server community private rw', 5);
echo $out . "\n\n";

// Configure trap destination to CRM
echo "Setting trap destination to CRM (10.150.1.4)...\n";
$out = $driver->run('snmp-server host 10.150.1.4 traps version 2c public', 5);
echo $out . "\n\n";

// Enable SNMP traps
echo "Enabling SNMP traps...\n";
$out = $driver->run('snmp-server enable traps', 5);
echo $out . "\n\n";

// Start SNMP agent
echo "Starting SNMP agent...\n";
$out = $driver->run('snmp-server start', 5);
echo $out . "\n\n";

// Set contact and location
echo "Setting SNMP contact and location...\n";
$out = $driver->run('snmp-server contact admin@saasgio.com', 5);
echo $out . "\n";
$out = $driver->run('snmp-server location PUENTE_OLT2', 5);
echo $out . "\n\n";

// Exit and save
echo "Exiting configuration mode...\n";
$driver->run('end', 5);

echo "Saving configuration...\n";
$out = $driver->run('write memory', 10);
echo $out . "\n\n";

// Verify configuration
echo "=== Verifying SNMP Configuration ===\n";
$out = $driver->run('show running-config | include snmp', 10);
echo $out . "\n\n";

echo "✓ SNMP configuration completed!\n";
