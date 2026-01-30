#!/usr/bin/env php
<?php

require __DIR__ . '/vendor/autoload.php';

use App\Models\Olt;
use App\Services\OltService;

$olt = Olt::latest()->first();
$service = new OltService($olt);

echo "=== Testing ONU Parser ===\n\n";

// Get config
echo "1. Getting running-config...\n";
$result = $service->getOltInfo();

if (!$result['success']) {
    die("Failed to get config: {$result['error']}\n");
}

$config = $result['output'];
echo "Config size: " . strlen($config) . " bytes\n\n";

// Save to file for inspection
file_put_contents('/tmp/vsol_config.txt', $config);
echo "Saved to /tmp/vsol_config.txt\n\n";

// Parse manually
echo "2. Parsing ONUs manually...\n";
$lines = explode("\n", $config);
$currentInterface = null;
$onus = [];
$debugLines = 0;

foreach ($lines as $lineNum => $line) {
    $originalLine = $line;
    $line = trim($line);
    
    // Detect interface
    if (preg_match('/interface gpon-olt_([\d\/]+)/', $line, $matches)) {
        $currentInterface = $matches[1];
        echo "  Line $lineNum: Found interface $currentInterface\n";
        $debugLines++;
        if ($debugLines > 5) break;
        continue;
    }
    
    // Parse ONU
    if ($currentInterface && preg_match('/onu add (\d+) profile (\S+) sn ([A-Za-z0-9]+)/i', $line, $matches)) {
        echo "  Line $lineNum: Found ONU {$matches[1]} - SN: {$matches[3]}\n";
        $onus[] = [
            'port' => $currentInterface,
            'onu_id' => $matches[1],
            'serial' => $matches[3],
        ];
        $debugLines++;
        if ($debugLines > 10) break;
    }
}

echo "\nTotal ONUs found: " . count($onus) . "\n";

if (count($onus) > 0) {
    echo "\nFirst 5 ONUs:\n";
    for ($i = 0; $i < min(5, count($onus)); $i++) {
        $onu = $onus[$i];
        echo "  {$onu['port']}:{$onu['onu_id']} - {$onu['serial']}\n";
    }
}

echo "\n3. Testing OltService->getAllOnus()...\n";
$result = $service->getAllOnus();
echo "Result: " . ($result['success'] ? 'SUCCESS' : 'FAILED') . "\n";
echo "Total from service: " . $result['total'] . "\n";
