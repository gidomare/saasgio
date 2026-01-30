<?php

$host = '192.168.8.200';
$community = 'public';

// 1. Get Standard Status (Reference)
echo "Getting Standard IF-MIB Status...\n";
$cmd = "snmpwalk -v2c -c $community -Oqn -t 5 -r 2 $host 1.3.6.1.2.1.2.2.1.8 2>&1";
$standardRaw = shell_exec($cmd);
$standardLines = explode("\n", $standardRaw);
echo "Standard Raw First 5 Lines:\n";
print_r(array_slice($standardLines, 0, 5));

$standard = [];
foreach ($standardLines as $line) {
    // Check for string format: .1.3.6.1.2.1.2.2.1.8.1 down
    if (preg_match('/\.(\d+) (up|down)$/i', $line, $m)) {
        $standard[$m[1]] = (strtolower($m[2]) === 'up') ? 1 : 2;
    }
    // Check for numeric format: .1.3.6... = 2
    elseif (preg_match('/\.(\d+) (= )?(\d+)$/', $line, $m)) {
        $standard[$m[1]] = (int)end($m);
    }
}
echo "Found " . count($standard) . " standard interfaces after parse.\n";

// 2. Walk VSOL Proprietary Branch
echo "Walking VSOL Branch .1.3.6.1.4.1.37950.1.1.5.10 ...\n";
$cmd = "snmpwalk -v2c -c $community -Oqn -t 5 -r 2 $host 1.3.6.1.4.1.37950.1.1.5.10 2>&1";
$vsolRaw = shell_exec($cmd);
$vsolLines = explode("\n", $vsolRaw);
echo "VSOL Raw First 5 Lines:\n";
print_r(array_slice($vsolLines, 0, 5));

echo "Found " . count($vsolLines) . " lines in VSOL branch.\n";

// 3. Analyze Correlations
// We are looking for an OID that has entries corresponding to ONUs (indices often match or are derived)
// and values that vary.

echo "\n--- Analysis of Values by OID Parent ---\n";
$groups = [];

foreach ($vsolLines as $line) {
    if (preg_match('/^(.*)\.(\d+) (.+)$/', $line, $m)) {
        $parent = $m[1];
        $idx = $m[2];
        $val = trim($m[3]);
        
        if (!isset($groups[$parent])) {
            $groups[$parent] = [];
        }
        $groups[$parent][] = $val;
    }
}

foreach ($groups as $parent => $values) {
    $count = count($values);
    if ($count < 10) continue; // Noise filter
    
    $dist = array_count_values($values);
    arsort($dist); // Sort by frequency
    
    echo "OID: $parent (Count: $count)\n";
    echo "   Values: " . json_encode($dist) . "\n";
    
    // Check if it has 'interesting' values (more than just 1 or 2 distinct values, or values > 2)
    if (count($dist) > 2 || isset($dist[3]) || isset($dist[4]) || isset($dist[5]) || isset($dist[6])) {
        echo "   *** POTENTIAL CANDIDATE ***\n";
    }
    echo "--------------------------\n";
}
