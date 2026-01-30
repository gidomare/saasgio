#!/usr/bin/env php
<?php

require __DIR__ . '/vendor/autoload.php';
$app = require_once __DIR__ . '/bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

use App\Services\OltService;
use App\Models\Olt;
use App\Services\Olt\Vsol\VsolSnmpService;

$olt = Olt::latest()->first();
$service = new OltService($olt);

// 1. Get SNMP Statuses
echo "Getting SNMP Statuses...\n";
$snmp = new VsolSnmpService($olt->ip_admin, 'public');
$statuses = $snmp->getOnuStatuses();
$snmpKeys = array_keys($statuses);
echo "SNMP Keys (first 5): " . implode(', ', array_slice($snmpKeys, 0, 5)) . "\n";
echo "Online SNMP Keys: " . implode(', ', array_keys(array_filter($statuses, fn($s) => $s === 'online'))) . "\n\n";

// 2. Get Telnet ONUs (Simulated via getAllOnus but intercepting)
// We can just call getAllOnus since we added logging there, or inspect the result.
echo "Getting All ONUs via Service...\n";
$result = $service->getAllOnus();

if ($result['success']) {
    $onus = $result['onus'];
    echo "Telnet Keys (first 5 from result):\n";
    foreach (array_slice($onus, 0, 5) as $onu) {
        $key = "{$onu['port']}:{$onu['onu_id']}";
        echo "  $key (Status: {$onu['status']})\n";
    }
    
    // Check for match
    $matches = 0;
    foreach ($onus as $onu) {
        $key = "{$onu['port']}:{$onu['onu_id']}";
        if (isset($statuses[$key])) {
            $matches++;
            if ($statuses[$key] === 'online') {
                echo "  MATCH ONLINE: $key\n";
            }
        }
    }
    echo "\nTotal Matches keys: $matches / " . count($onus) . "\n";
}
