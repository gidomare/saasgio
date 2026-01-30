#!/usr/bin/env php
<?php

$host = '192.168.8.200';
$community = 'public';
$baseOid = '1.3.6.1.4.1.37950';

echo "=== V-SOL Smart OID Discovery ===\n";

// Sub-branches to test (refined based on system MIB pointer .1.1.5.10.14)
$branches = [
    '1.3.6.1.4.1.37950.1.1.5.10.14', // System pointer pointed here
    '1.3.6.1.4.1.37950.1.1.5.10.1',  // Seen previously
    '1.3.6.1.4.1.37950.1.1.5.10.12', // Common for optical
    '1.3.6.1.4.1.37950.1.1.5.12.1',  // Seen previously
];

foreach ($branches as $oid) {
    echo "Probing $oid ... ";
    // Use timeout 8s, retries 1 to be aggressive but patient
    $cmd = "snmpwalk -v2c -c $community -Oqn -t 8 -r 1 $host $oid 2>&1 | head -n 5";
    $out = shell_exec($cmd);
    
    if (strpos($out, 'Timeout') !== false) {
        echo "TIMEOUT\n";
    } elseif (trim($out) === '') {
        echo "EMPTY\n";
    } else {
        echo "SUCCESS!\n$out\n";
        // If success, try to find optical-like values in this branch
        echo "  -> Analyzing branch for optical values...\n";
        $cmdFull = "snmpwalk -v2c -c $community -Oqn -t 8 -r 1 $host $oid 2>&1";
        $fullOut = shell_exec($cmdFull);
        $lines = explode("\n", $fullOut);
        
        $opticalFound = 0;
        foreach ($lines as $line) {
            // Look for potential dBm values (e.g. integer -2000 to -100 or float -20.0 to -1.0)
            if (preg_match('/ (-[1-3][0-9]{2,4}|-[1-3][0-9]\.\d+)/', $line)) {
                 if ($opticalFound < 5) echo "    POSSIBLE OPTICAL: $line\n";
                 $opticalFound++;
            }
        }
        echo "  -> Found $opticalFound potential optical metrics.\n";
    }
    echo "------------------------------------------------\n";
}
