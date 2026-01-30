#!/usr/bin/env php
<?php

require __DIR__ . '/vendor/autoload.php';
$app = require_once __DIR__ . '/bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

use App\Models\Olt;

$olt = Olt::latest()->first();

echo "=== Extracting ONU lines from running-config ===\n\n";

$socket = fsockopen($olt->ip_admin, $olt->telnet_port, $errno, $errstr, 10);
if (!$socket) {
    die("Connection failed: {$errstr}\n");
}

stream_set_blocking($socket, false);
stream_set_timeout($socket, 5);

function readSocket($socket, $timeout = 2) {
    $output = '';
    $start = time();
    while ((time() - $start) < $timeout) {
        $chunk = fread($socket, 8192);
        if ($chunk !== false && $chunk !== '') {
            $output .= $chunk;
        }
        usleep(100000);
    }
    return $output;
}

function sendCommand($socket, $cmd) {
    fwrite($socket, $cmd . "\r\n");
}

// Login
sleep(2);
readSocket($socket, 3);
sendCommand($socket, $olt->username);
sleep(1);
sendCommand($socket, $olt->password);
sleep(2);
readSocket($socket, 2);

// Enable
sendCommand($socket, 'enable');
sleep(1);
$response = readSocket($socket, 2);
if (stripos($response, 'password') !== false) {
    sendCommand($socket, $olt->password);
    sleep(2);
    readSocket($socket, 2);
}

echo "✓ Logged in and enabled\n\n";

// Get running-config
echo "Executing: show running-config\n";
sendCommand($socket, 'show running-config');
sleep(3);

$fullOutput = '';
for ($i = 0; $i < 50; $i++) {
    $chunk = readSocket($socket, 2);
    $fullOutput .= $chunk;
    
    if (strpos($chunk, '--More--') !== false) {
        fwrite($socket, ' ');
        sleep(1);
    } else if (preg_match('/[>#]\s*$/', $chunk)) {
        break;
    }
}

echo "✓ Received " . strlen($fullOutput) . " bytes\n\n";

// Save full output
file_put_contents('/tmp/vsol_running_config_full.txt', $fullOutput);
echo "✓ Saved to /tmp/vsol_running_config_full.txt\n\n";

// Extract ONU-related lines
$lines = explode("\n", $fullOutput);
$onuLines = [];
$interfaceLines = [];

foreach ($lines as $i => $line) {
    $trimmed = trim($line);
    
    // Look for interface gpon
    if (preg_match('/interface\s+gpon/i', $trimmed)) {
        $interfaceLines[] = "Line $i: $trimmed";
    }
    
    // Look for onu add or onu commands
    if (preg_match('/\bonu\s+(add\s+)?\d+/i', $trimmed)) {
        $onuLines[] = "Line $i: $trimmed";
    }
}

echo "=== INTERFACE GPON LINES (" . count($interfaceLines) . " found) ===\n";
foreach (array_slice($interfaceLines, 0, 10) as $line) {
    echo $line . "\n";
}

echo "\n=== ONU LINES (" . count($onuLines) . " found) ===\n";
foreach (array_slice($onuLines, 0, 30) as $line) {
    echo $line . "\n";
}

// Save extracted lines
file_put_contents('/tmp/vsol_onu_lines.txt', implode("\n", $onuLines));
file_put_contents('/tmp/vsol_interface_lines.txt', implode("\n", $interfaceLines));

echo "\n✓ Extracted lines saved to /tmp/vsol_*_lines.txt\n";

fclose($socket);
