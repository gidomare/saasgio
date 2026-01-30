<?php

require __DIR__.'/vendor/autoload.php';

use App\Services\Olt\Vsol\VsolTelnetDriver;
use Illuminate\Support\Facades\Log;

$app = require_once __DIR__.'/bootstrap/app.php';
$app->make('Illuminate\Contracts\Console\Kernel')->bootstrap();

// Get first VSOL OLT
$olt = \App\Models\Olt::where('pon_type', 'GPON')->first();

if (!$olt) {
    echo "No VSOL OLT found\n";
    exit(1);
}

echo "Connecting to OLT: {$olt->name} ({$olt->admin_ip})\n";

try {
    $driver = new VsolTelnetDriver(
        $olt->admin_ip,
        $olt->telnet_username,
        $olt->telnet_password,
        $olt->telnet_port ?? 23
    );

    $driver->connect();
    
    echo "\n=== Testing 'show onu 1-128 distance' command ===\n";
    
    // Get port with ONUs
    $onuListOutput = $driver->run("show running-config interface gpon-olt_1/1/1", 30);
    echo "\nONU List Output (first 500 chars):\n";
    echo substr($onuListOutput, 0, 500) . "\n...\n";
    
    // Enter interface mode
    $driver->run("configure terminal", 5);
    $driver->run("interface gpon-olt_1/1/1", 5);
    
    // Get distance
    $distanceOutput = $driver->run("show onu 1-128 distance", 120);
    
    echo "\n=== RAW Distance Output ===\n";
    echo $distanceOutput;
    echo "\n=== END RAW Output ===\n";
    
    // Parse it
    $parsed = \App\Services\Olt\Vsol\VsolParsers::parseDistance($distanceOutput);
    
    echo "\n=== Parsed Results ===\n";
    foreach (array_slice($parsed, 0, 10) as $onuId => $distance) {
        echo "ONU ID: $onuId => Distance: {$distance}m\n";
    }
    
    $driver->disconnect();
    
} catch (\Exception $e) {
    echo "Error: " . $e->getMessage() . "\n";
    echo $e->getTraceAsString() . "\n";
}
