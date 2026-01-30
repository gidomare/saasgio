<?php

namespace App\Services;

use App\Models\Olt;
use App\Services\Olt\Vsol\VsolTelnetDriver;
use Illuminate\Support\Facades\Log;

class OltService
{
    protected $olt;
    protected $socket;
    protected $prompt;
    protected $vsolDriver = null;

    public function __construct(Olt $olt)
    {
        $this->olt = $olt;
        
        // Detect if this is a VSOL OLT and use the new driver
        if ($this->isVsolOlt()) {
            $this->vsolDriver = new VsolTelnetDriver([
                'host' => $olt->ip_admin,
                'port' => $olt->telnet_port,
                'username' => $olt->username,
                'password' => $olt->password,
                'timeout' => 20,
                'prompt_regex' => '/(?:OLT[>#]|PUENTE[A-Z0-9_]*[>#]|[#>])\s*$/m',
            ]);
        }
    }

    /**
     * Detect if this is a VSOL OLT
     */
    protected function isVsolOlt(): bool
    {
        // Check if brand/model indicates VSOL
        if (stripos($this->olt->brand ?? '', 'vsol') !== false) {
            return true;
        }
        
        // Check if name contains VSOL or PUENTE (common naming)
        if (stripos($this->olt->name ?? '', 'vsol') !== false || 
            stripos($this->olt->name ?? '', 'puente') !== false) {
            return true;
        }
        
        return false;
    }

    /**
     * Connect to OLT via Telnet and login
     */
    protected function connect(): bool
    {
        try {
            // Open telnet connection
            $this->socket = @fsockopen(
                $this->olt->ip_admin,
                $this->olt->telnet_port,
                $errno,
                $errstr,
                10
            );

            if (!$this->socket) {
                throw new \Exception("Connection failed: {$errstr} ({$errno})");
            }

            stream_set_blocking($this->socket, false);
            stream_set_timeout($this->socket, 5);

            // Read banner
            sleep(2);
            $this->read(3);

            // Send username
            $this->write($this->olt->username);
            sleep(1);

            // Send password
            $this->write($this->olt->password);
            sleep(2);

            // Read prompt
            $response = $this->read(2);
            
            // Extract prompt (e.g., "PUENTE_OLT2>")
            if (preg_match('/([A-Za-z0-9_-]+)>\s*$/m', $response, $matches)) {
                $this->prompt = $matches[1];
                Log::info("VSOL Telnet connected. Prompt: {$this->prompt}>");
            } else {
                $this->prompt = 'OLT';
                Log::warning("Could not detect prompt, using default");
            }

            // Enter enable mode
            $this->write('enable');
            sleep(1);
            $response = $this->read(2);

            // If password requested for enable
            if (stripos($response, 'password') !== false) {
                $this->write($this->olt->password);
                sleep(2);
                $this->read(2);
            }

            Log::info("VSOL Telnet in privileged mode");
            return true;

        } catch (\Exception $e) {
            Log::error("VSOL Telnet connection failed: " . $e->getMessage());
            return false;
        }
    }

    /**
     * Disconnect from OLT
     */
    protected function disconnect(): void
    {
        if ($this->socket) {
            fclose($this->socket);
            $this->socket = null;
        }
    }

    /**
     * Read from socket
     */
    protected function read(int $timeout = 2): string
    {
        $output = '';
        $start = time();

        while ((time() - $start) < $timeout) {
            $chunk = fread($this->socket, 8192);
            if ($chunk !== false && $chunk !== '') {
                $output .= $chunk;
            }
            usleep(100000); // 100ms
        }

        return $output;
    }

    /**
     * Write to socket
     */
    protected function write(string $data): void
    {
        fwrite($this->socket, $data . "\r\n");
    }

    /**
     * Execute command with --More-- handling
     */
    protected function exec(string $command): string
    {
        if (!$this->socket) {
            throw new \Exception('Not connected');
        }

        $this->write($command);
        sleep(1);

        $output = '';
        $iterations = 0;
        $maxIterations = 50;
        $emptyReads = 0;

        while ($iterations < $maxIterations) {
            $chunk = $this->read(1);

            if (empty($chunk)) {
                $emptyReads++;
                if ($emptyReads >= 3) {
                    break; // No more data
                }
                $iterations++;
                continue;
            }

            $emptyReads = 0;
            $output .= $chunk;

            // Handle --More--
            if (strpos($chunk, '--More--') !== false) {
                $this->write(' '); // Send space
                sleep(1);
                $iterations++;
                continue;
            }

            // Check for prompt (command finished)
            if (preg_match('/[A-Za-z0-9_-]+[>#]\s*$/m', $chunk)) {
                break;
            }

            $iterations++;
        }

        // Clean output
        $lines = explode("\n", $output);

        // Remove command echo (first line)
        if (count($lines) > 0 && stripos($lines[0], $command) !== false) {
            array_shift($lines);
        }

        // Remove prompt (last line)
        if (count($lines) > 0 && preg_match('/[>#]\s*$/', end($lines))) {
            array_pop($lines);
        }

        return trim(implode("\n", $lines));
    }

    /**
     * Test connection
     */
    public function testConnection(): array
    {
        if (!$this->connect()) {
            return ['success' => false, 'error' => 'Connection failed'];
        }

        $this->disconnect();
        return [
            'success' => true,
            'message' => 'Telnet connection successful',
            'prompt' => $this->prompt,
        ];
    }

    /**
     * Get OLT information
     */
    public function getOltInfo(): array
    {
        if (!$this->connect()) {
            return ['success' => false, 'error' => 'Connection failed'];
        }

        try {
            $output = $this->exec('show running-config');
            $this->disconnect();
            return ['success' => true, 'output' => $output];
        } catch (\Exception $e) {
            $this->disconnect();
            return ['success' => false, 'error' => $e->getMessage()];
        }
    }

    /**
     * Get unconfigured ONUs
     */
    public function getUnconfiguredOnus(): array
    {
        if (!$this->connect()) {
            return ['success' => false, 'error' => 'Connection failed'];
        }

        try {
            // Try different commands
            $commands = [
                'show gpon onu uncfg',
                'show onu uncfg',
                'show running-config | include gpon-onu',
            ];

            $output = '';
            foreach ($commands as $cmd) {
                $output = $this->exec($cmd);
                if (!empty($output) && stripos($output, 'Unknown command') === false) {
                    break;
                }
            }

            $this->disconnect();
            return ['success' => true, 'output' => $output];
        } catch (\Exception $e) {
            $this->disconnect();
            return ['success' => false, 'error' => $e->getMessage()];
        }
    }

    /**
     * Get ONUs from specific port
     */
    public function getOnusFromPort(string $port): array
    {
        if (!$this->connect()) {
            return ['success' => false, 'error' => 'Connection failed'];
        }

        try {
            // Try different command variations for VSOL
            $commands = [
                "show running-config interface gpon-olt_{$port}",
                "show interface gpon-olt_{$port}",
                "show gpon onu state gpon-olt_{$port}",
                "show running-config | include gpon-onu_{$port}",
            ];

            $output = '';
            foreach ($commands as $cmd) {
                $output = $this->exec($cmd);
                if (!empty($output) && stripos($output, 'Unknown command') === false) {
                    break;
                }
            }

            $this->disconnect();
            return ['success' => true, 'output' => $output, 'command_used' => $cmd ?? 'none'];
        } catch (\Exception $e) {
            $this->disconnect();
            return ['success' => false, 'error' => $e->getMessage()];
        }
    }

    /**
     * Get system information
     */
    public function getSystemInfo(): array
    {
        if (!$this->connect()) {
            return ['success' => false, 'error' => 'Connection failed'];
        }

        try {
            $config = $this->exec('show running-config');
            
            // Extract version from config
            $version = 'Unknown';
            if (preg_match('/Software Version\s*:\s*(.+)/i', $config, $matches)) {
                $version = trim($matches[1]);
            }

            $this->disconnect();
            return [
                'success' => true,
                'version' => $version,
                'hostname' => $this->prompt,
                'config_size' => strlen($config),
            ];
        } catch (\Exception $e) {
            $this->disconnect();
            return ['success' => false, 'error' => $e->getMessage()];
        }
    }

    /**
     * Get version
     */
    public function getVersion(): array
    {
        return $this->getSystemInfo();
    }

    /**
     * Get configuration summary
     */
    public function getConfigurationSummary(): array
    {
        if (!$this->connect()) {
            return ['success' => false, 'error' => 'Connection failed'];
        }

        try {
            $config = $this->exec('show running-config');
            $this->disconnect();

            // Parse VLANs
            preg_match_all('/^vlan (\d+)/m', $config, $vlanMatches);
            $vlans = $vlanMatches[1] ?? [];

            // Parse interfaces
            preg_match_all('/^interface (gpon-olt_[\d\/]+)/m', $config, $intMatches);
            $interfaces = $intMatches[1] ?? [];

            return [
                'success' => true,
                'vlans' => array_unique($vlans),
                'interfaces' => array_unique($interfaces),
                'config_lines' => count(explode("\n", $config)),
            ];
        } catch (\Exception $e) {
            $this->disconnect();
            return ['success' => false, 'error' => $e->getMessage()];
        }
    }

    /**
     * Get all ONUs from running-config
     */
    public function getAllOnus(): array
    {
        try {
            if ($this->vsolDriver) {
                    // 1. Get Base Config via Telnet
                    $result = $this->vsolDriver->importOnus();
                    
                    // 2. Get SNMP Status (Fast/Standard)
                    $statuses = []; // key: 0/1:3 -> online/offline
                    try {
                        $snmp = new \App\Services\Olt\Vsol\VsolSnmpService(
                            $this->olt->ip_admin,
                            $this->olt->community_read ?? 'public'
                        );
                        $statuses = $snmp->getOnuStatuses();
                    } catch (\Exception $e) {
                         // warning logged
                    }

                    // 3. Get Detailed Status via CLI (Dying Gasp, etc)
                    $detailedStatuses = [];
                    try {
                         // Only fetch if we successfully imported base config
                         $detailedStatuses = $this->vsolDriver->getOnuStatusDetailed();
                         Log::info("VSOL: Fetched detailed statuses for " . count($detailedStatuses) . " ONUs");
                    } catch (\Exception $e) {
                         Log::warning("VSOL Detailed Status Failed: " . $e->getMessage());
                    }

                    // 4. Get Optical Info (RX/TX/Distance) via CLI Bulk
                    $opticalData = [];
                    try {
                        // Extract unique ports
                        $ponPorts = [];
                        foreach ($result['onus'] as $onu) {
                            $ponStr = str_replace('gpon-olt_', '', $onu['pon']);
                             // Normalize 0/0/1 -> 0/1, 1 -> 0/1
                            if (preg_match('/^\d+$/', $ponStr)) $ponStr = "0/{$ponStr}";
                            elseif (preg_match('/^\d+\/\d+\/(\d+)$/', $ponStr, $m)) $ponStr = "0/{$m[1]}";
                            
                            $ponPorts[$ponStr] = $ponStr;
                        }
                        
                        if (!empty($ponPorts)) {
                            // Only query ports that have ONLINE ONUs to save time?
                            // Actually bulk command is fast enough per port (5-10s).
                            $opticalData = $this->vsolDriver->getOnuOpticalInfo(array_values($ponPorts));
                            Log::debug("VSOL: Fetched optical info for " . count($opticalData) . " ONUs");
                        }
                    } catch (\Exception $e) {
                        Log::warning("VSOL Optical Info Failed: " . $e->getMessage());
                    }

                    // Convert VSOL format to standard format
                    $onus = [];
                    foreach ($result['onus'] as $onu) {
                        // Standardize key to 0/X:Y format
                        // Telnet parser might return '0/1', '1', or '0/0/1'
                        $ponStr = str_replace('gpon-olt_', '', $onu['pon']); // strip prefix if any
                        
                        // If PON is just '1', make it '0/1'
                        if (preg_match('/^\d+$/', $ponStr)) {
                            $ponStr = "0/{$ponStr}";
                        }
                        // If PON is '0/0/1', make it '0/1' (assuming slot 0)
                        elseif (preg_match('/^\d+\/\d+\/(\d+)$/', $ponStr, $m)) {
                             $ponStr = "0/{$m[1]}";
                        }
                        
                        $key = "{$ponStr}:{$onu['onu_id']}";
                        
                        // Default to SNMP status
                        $status = $statuses[$key] ?? 'unknown';
                        
                        // Enhance with CLI detail if available
                        // CLI returns: working, dyinggasp, offline, los?
                        if (isset($detailedStatuses[$key])) {
                            $cliStat = $detailedStatuses[$key];
                            if ($cliStat === 'dyinggasp') {
                                $status = 'dying_gasp';
                            } elseif ($cliStat === 'los') {
                                $status = 'los';
                            } elseif ($cliStat === 'auth_fail') { // example
                                $status = 'auth_fail';
                            }
                            // 'working' maps to 'online' which SNMP likely already has
                        }

                        // Optical Info
                        $opt = $opticalData[$key] ?? [];

                        $onus[] = [
                            'port' => $onu['pon'],
                            'onu_id' => $onu['onu_id'],
                            'serial_number' => $onu['sn'],
                            'onu_type' => $onu['profile'] ?? null,
                            'name' => $onu['name'] ?? null,
                            'vlan' => $onu['vlan'] ?? null,
                            'line_profile' => $onu['line_profile'] ?? null,
                            'dba_profile' => $onu['dba_profile'] ?? null,
                            'service_profile' => $onu['service_profile'] ?? null,
                            'traffic_limit_downstream' => $onu['traffic_limit_downstream'] ?? null,
                            'status' => $status,
                            'rx_power' => $opt['rx_power'] ?? null,
                            'tx_power' => $opt['tx_power'] ?? null,
                            'voltage' => $opt['voltage'] ?? null,
                            'bias_current' => $opt['bias_current'] ?? null,
                            'temperature' => $opt['temperature'] ?? null,
                            'distance' => $opt['distance'] ?? null,
                        ];
                    }
                    
                    return [
                        'success' => true,
                        'total' => count($onus),
                        'onus' => $onus
                    ];
            }
        } catch (\Exception $e) {
            Log::error("VSOL driver error: " . $e->getMessage());
            return ['success' => false, 'error' => $e->getMessage()];
        }
        
        // Fallback to old method for non-VSOL OLTs
        if (!$this->connect()) {
            return ['success' => false, 'error' => 'Connection failed'];
        }

        try {
            $config = $this->exec('show running-config');
            $this->disconnect();

            $onus = $this->parseOnusFromConfig($config);

            return [
                'success' => true,
                'onus' => $onus,
                'total' => count($onus),
            ];
        } catch (\Exception $e) {
            $this->disconnect();
            return ['success' => false, 'error' => $e->getMessage()];
        }
    }

    /**
     * Parse ONUs from running-config
     */
    protected function parseOnusFromConfig(string $config): array
    {
        $onus = [];
        $lines = explode("\n", $config);
        $currentInterface = null;

        foreach ($lines as $line) {
            $line = trim($line);

            // Detect interface context (e.g., "interface gpon-olt_0/4")
            if (preg_match('/interface gpon-olt_([\d\/]+)/', $line, $matches)) {
                $currentInterface = $matches[1];
                continue;
            }

            // Exit interface context
            if ($line === 'exit' || $line === '!') {
                $currentInterface = null;
                continue;
            }

            // Parse ONU add command
            // Format: onu add <id> profile <profile> sn <serial>
            if ($currentInterface && preg_match('/onu add (\d+) profile (\S+) sn ([A-Za-z0-9]+)/i', $line, $matches)) {
                $onuId = (int)$matches[1];
                $profile = $matches[2];
                $serial = $matches[3];

                $key = "{$currentInterface}:{$onuId}";
                $onus[$key] = [
                    'port' => $currentInterface,
                    'onu_id' => $onuId,
                    'serial_number' => $serial,
                    'onu_type' => $profile,
                    'line_profile' => null,
                    'service_profile' => null,
                    'vlan' => null,
                    'name' => null,
                    'status' => 'unknown', // Can't determine from config
                ];
            }

            // Parse ONU description
            // Format: onu <id> desc <description>
            if ($currentInterface && preg_match('/onu (\d+) desc (.+)/', $line, $matches)) {
                $onuId = (int)$matches[1];
                $desc = trim($matches[2]);
                $key = "{$currentInterface}:{$onuId}";
                
                if (isset($onus[$key])) {
                    $onus[$key]['name'] = $desc;
                }
            }

            // Parse ONU VLAN
            // Format: onu <id> service ser_1 gemport 1 vlan <vlan>
            if ($currentInterface && preg_match('/onu (\d+) service .+ vlan (\d+)/', $line, $matches)) {
                $onuId = (int)$matches[1];
                $vlan = (int)$matches[2];
                $key = "{$currentInterface}:{$onuId}";
                
                if (isset($onus[$key])) {
                    $onus[$key]['vlan'] = $vlan;
                }
            }
        }

        return array_values($onus);
    }
}
