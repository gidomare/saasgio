#!/usr/bin/env php
<?php

/**
 * VSOL V1600G-1B Command Catalog Builder
 * 
 * This script tests all possible VSOL commands to build a complete catalog
 * of working commands with their syntax and output formats.
 */

require __DIR__ . '/vendor/autoload.php';

$app = require_once __DIR__.'/bootstrap/app.php';
$app->make('Illuminate\Contracts\Console\Kernel')->bootstrap();

use App\Models\Olt;
use phpseclib3\Net\SSH2;

// Output file
$catalogFile = __DIR__ . '/storage/logs/vsol_command_catalog.json';
$logFile = __DIR__ . '/storage/logs/vsol_command_test.log';

// Get OLT
$olt = Olt::latest()->first();
if (!$olt) {
    die("No OLT found in database\n");
}

echo "╔════════════════════════════════════════════════════════════════╗\n";
echo "║  VSOL V1600G-1B Command Catalog Builder                       ║\n";
echo "╚════════════════════════════════════════════════════════════════╝\n\n";
echo "OLT: {$olt->name}\n";
echo "IP: {$olt->ip_admin}:{$olt->ssh_port}\n";
echo "User: {$olt->username}\n\n";

// Command categories to test
$commandCategories = [
    'System Information' => [
        'show version',
        'show system',
        'show cpu',
        'show memory',
        'show temperature',
        'show running-config',
        'show startup-config',
    ],
    'Profile Management' => [
        'show onu profile',
        'show line-profile',
        'show service-profile',
        'show traffic-table',
        'show dba-profile',
    ],
    'PON/GPON' => [
        'show gpon',
        'show pon',
        'show gpon olt',
        'show gpon onu',
        'show gpon onu uncfg',
        'show gpon onu state',
        'show pon onu uncfg',
        'show interface gpon-olt',
        'show interface pon-olt',
    ],
    'ONU Management' => [
        'show onu running config',
        'show onu running config gpon-onu_1/1/1:1',
        'show onu running config gpon-olt_1/1/1',
        'show mac gpon onu',
        'show mac address-table',
    ],
    'VLAN' => [
        'show vlan',
        'show vlan brief',
        'show vlan id 1',
    ],
    'Interfaces' => [
        'show interface',
        'show interface brief',
        'show interface status',
        'show ip interface',
        'show ip interface brief',
    ],
    'SNMP' => [
        'show snmp',
        'show snmp community',
        'show snmp host',
    ],
    'Logs & Diagnostics' => [
        'show log',
        'show alarm',
        'show optical-module-info',
        'show optical-module-info gpon-olt_1/1/1',
    ],
];

$catalog = [];
$successCount = 0;
$failCount = 0;

// Test each command
foreach ($commandCategories as $category => $commands) {
    echo "\n" . str_repeat("=", 70) . "\n";
    echo "Category: {$category}\n";
    echo str_repeat("=", 70) . "\n\n";
    
    foreach ($commands as $command) {
        echo "Testing: {$command}\n";
        
        $result = testCommand($olt, $command);
        
        $catalog[$category][$command] = $result;
        
        if ($result['success']) {
            echo "  ✓ Success ({$result['output_length']} bytes)\n";
            if (!empty($result['sample'])) {
                echo "  Sample: " . substr($result['sample'], 0, 100) . "...\n";
            }
            $successCount++;
        } else {
            echo "  ✗ Failed: {$result['error']}\n";
            $failCount++;
        }
        
        // Small delay to avoid overwhelming the OLT
        sleep(2);
    }
}

// Save catalog
file_put_contents($catalogFile, json_encode($catalog, JSON_PRETTY_PRINT));
echo "\n\n" . str_repeat("=", 70) . "\n";
echo "SUMMARY\n";
echo str_repeat("=", 70) . "\n";
echo "Total Commands Tested: " . ($successCount + $failCount) . "\n";
echo "Successful: {$successCount}\n";
echo "Failed: {$failCount}\n";
echo "\nCatalog saved to: {$catalogFile}\n";

/**
 * Test a single command via SSH
 */
function testCommand(Olt $olt, string $command): array
{
    try {
        $ssh = new SSH2($olt->ip_admin, $olt->ssh_port, 15);
        $ssh->setTimeout(10);
        
        if (!$ssh->login($olt->username, $olt->password)) {
            return [
                'success' => false,
                'error' => 'SSH authentication failed',
                'output' => null,
                'output_length' => 0,
            ];
        }
        
        // Try exec method
        $output = $ssh->exec($command);
        $ssh->disconnect();
        
        // Check if output looks valid
        if (empty($output)) {
            return [
                'success' => false,
                'error' => 'No output received',
                'output' => null,
                'output_length' => 0,
            ];
        }
        
        // Check for error indicators
        $lowerOutput = strtolower($output);
        if (strpos($lowerOutput, 'invalid') !== false ||
            strpos($lowerOutput, 'unknown command') !== false ||
            strpos($lowerOutput, 'bad command') !== false ||
            strpos($lowerOutput, 'error') !== false) {
            return [
                'success' => false,
                'error' => 'Command returned error',
                'output' => $output,
                'output_length' => strlen($output),
                'sample' => substr($output, 0, 200),
            ];
        }
        
        return [
            'success' => true,
            'error' => null,
            'output' => $output,
            'output_length' => strlen($output),
            'sample' => substr($output, 0, 200),
        ];
        
    } catch (\Exception $e) {
        return [
            'success' => false,
            'error' => $e->getMessage(),
            'output' => null,
            'output_length' => 0,
        ];
    }
}
