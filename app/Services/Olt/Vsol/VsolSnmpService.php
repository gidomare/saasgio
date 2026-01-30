<?php

namespace App\Services\Olt\Vsol;

use App\Models\Onu;
use Illuminate\Support\Facades\Log;

class VsolSnmpService
{
    protected string $host;
    protected string $community;
    protected int $timeout = 1000; // ms
    protected int $retries = 2;

    public function __construct(string $host, string $community = 'public')
    {
        $this->host = $host;
        $this->community = $community;
    }

    /**
     * Get operational status for all ONUs using standard IF-MIB
     * Uses ifDescr to map to ONUs and ifOperStatus for status
     * 
     * @return array [ 'serial' => 'online'|'offline', ... ]
     */
    public function getOnuStatuses(): array
    {
        // 1. Walk ifDescr (1.3.6.1.2.1.2.2.1.2) to get mapping ifIndex -> Name
        $descriptions = $this->snmpWalk('1.3.6.1.2.1.2.2.1.2');
        
        // 2. Walk ifOperStatus (1.3.6.1.2.1.2.2.1.8) to get status
        $statuses = $this->snmpWalk('1.3.6.1.2.1.2.2.1.8');
        
        $results = [];

        foreach ($descriptions as $index => $desc) {
            // Check if this interface is an ONU
            // Format: GPON0/1:1 or similar, observed: GPON01ONU3 Elizabeth...
            if (preg_match('/GPON0?(\d+)ONU(\d+)/i', $desc, $m)) {
                $ponInfo = $m[1]; // e.g. "1" from GPON01 -> We might need to map this carefully
                $onuId = (int)$m[2];
                
                // Determine PON port. 
                // VSOL often maps GPON01 -> 0/1, GPON05 -> 0/5
                // Let's assume single digit PON for now based on observed "GPON01"
                $ponPort = "0/" . intval($ponInfo); 

                $statusVal = strtolower($statuses[$index] ?? '');
                
                // Handle both numeric (1/2) and string (up/down) values
                if ($statusVal === 'up' || $statusVal === '1') {
                    $statusStr = 'online';
                } elseif ($statusVal === 'down' || $statusVal === '2') {
                    $statusStr = 'offline';
                } elseif ($statusVal === 'notpresent' || $statusVal === '6') {
                    $statusStr = 'notPresent';
                } else {
                    $statusStr = 'unknown';
                }

                // Store with key "PORT:ID" to match our system
                $key = "{$ponPort}:{$onuId}";
                $results[$key] = $statusStr;
            }
        }

        return $results;
    }

    /**
     * Execute snmpwalk via shell_exec using -Oqn for clean output
     */
    protected function snmpWalk(string $oid): array
    {
        // -Oqn: Output OID in numeric format, quick output (no types)
        // -v2c: Version 2c
        // -t 60: Timeout 60 seconds (OLT is slow)
        // -r 3: Retries 3
        // Use snmpbulkwalk for efficiency
        $cmd = sprintf(
            "snmpbulkwalk -v2c -c %s -Oqn -t 60 -r 3 %s %s 2>&1", 
            escapeshellarg($this->community),
            escapeshellarg($this->host),
            escapeshellarg($oid)
        );

        $output = shell_exec($cmd);
        $lines = explode("\n", trim($output));
        $data = [];

        foreach ($lines as $line) {
            // Format: .1.3.6.1.2.1.2.2.1.2.20 GPON01ONU3 Elizabeth_Mercedez
            $parts = explode(' ', $line, 2);
            if (count($parts) < 2) continue;
            
            $oidPart = $parts[0];
            $valPart = trim($parts[1]);

            // Extract last number from OID as index
            if (preg_match('/\.(\d+)$/', $oidPart, $m)) {
                $index = $m[1];
                $data[$index] = $valPart;
            }
        }

        return $data;
    }
    
    /**
     * Helper to get single value
     */
    public function get(string $oid)
    {
        $cmd = sprintf(
            "snmpget -v2c -c %s -Ovq %s %s 2>&1",
            escapeshellarg($this->community),
            escapeshellarg($this->host),
            escapeshellarg($oid)
        );
        
        return trim(shell_exec($cmd));
    }
}
