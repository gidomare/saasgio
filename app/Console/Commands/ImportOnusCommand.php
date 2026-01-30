<?php

namespace App\Console\Commands;

use App\Models\Olt;
use App\Models\Onu;
use App\Services\OltService;
use Illuminate\Console\Command;

class ImportOnusCommand extends Command
{
    protected $signature = 'onu:import {olt_id?} {--port=}';
    protected $description = 'Import ONUs from OLT';

    public function handle()
    {
        $oltId = $this->argument('olt_id') ?? Olt::latest()->first()?->id;
        
        if (!$oltId) {
            $this->error('No OLT found');
            return 1;
        }

        $olt = Olt::find($oltId);
        $this->info("Importing ONUs from OLT: {$olt->name} ({$olt->ip_admin})");
        
        $service = new OltService($olt);
        
        // Get all ONUs using the service (will auto-detect VSOL)
        $this->info("\nGetting all ONUs...");
        
        try {
            $result = $service->getAllOnus();
            
            if (!$result['success']) {
                $this->error("Failed: {$result['error']}");
                return 1;
            }
            
            $allOnus = $result['onus'];
            $this->info("✓ Found {$result['total']} ONUs");
            
            if ($result['total'] == 0) {
                $this->warn("No ONUs found");
                return 0;
            }
            
            // Display sample
            $this->info("\nFirst 20 ONUs:");
            $this->table(
                ['Port', 'ID', 'Serial', 'Type', 'VLAN', 'Rx (dBm)', 'Tx (dBm)', 'Name'],
                array_map(function($onu) {
                    return [
                        $onu['port'],
                        $onu['onu_id'],
                        $onu['serial_number'],
                        $onu['onu_type'] ?? 'N/A',
                        $onu['vlan'] ?? 'N/A',
                        $onu['rx_power'] ?? '-',
                        $onu['tx_power'] ?? '-',
                        substr($onu['name'] ?? 'N/A', 0, 30),
                    ];
                }, array_slice($allOnus, 0, 20))
            );

            // Ask to import
            if (!$this->confirm("\nImport these ONUs to database?", true)) {
                return 0;
            }

            // Import to database
            $this->info("\nImporting...");
            $imported = 0;
            $updated = 0;
            
            foreach ($allOnus as $onuData) {
                $onu = Onu::updateOrCreate(
                    [
                        'olt_id' => $olt->id,
                        'serial_number' => $onuData['serial_number'],
                    ],
                    [
                        'port' => $onuData['port'],
                        'onu_id' => $onuData['onu_id'],
                        'onu_type' => $onuData['onu_type'] ?? null,
                        'vlan' => $onuData['vlan'] ?? null,
                        'name' => $onuData['name'] ?? null,
                        'line_profile' => $onuData['line_profile'] ?? null,
                        'dba_profile' => $onuData['dba_profile'] ?? null,
                        'service_profile' => $onuData['service_profile'] ?? null,
                        'traffic_limit_downstream' => $onuData['traffic_limit_downstream'] ?? null,
                        'status' => $onuData['status'] ?? 'unknown',
                        
                        // Optical Info
                        'rx_power' => $onuData['rx_power'] ?? null,
                        'tx_power' => $onuData['tx_power'] ?? null,
                        'voltage' => $onuData['voltage'] ?? null,
                        'bias_current' => $onuData['bias_current'] ?? null,
                        'temperature' => $onuData['temperature'] ?? null,
                        'distance' => $onuData['distance'] ?? null,
                        'last_online_at' => isset($onuData['status']) && $onuData['status'] === 'online' ? now() : null,
                        'discovered_at' => now(),
                        'raw_data' => $onuData,
                    ]
                );

                if ($onu->wasRecentlyCreated) {
                    $imported++;
                } else {
                    $updated++;
                }
            }
            
            $this->info("\n✓ Import completed:");
            $this->info("  - New: {$imported}");
            $this->info("  - Updated: {$updated}");
            
            $olt->update([
                'last_check_output' => "ONUs imported: {$imported} new, {$updated} updated",
                'last_check_at' => now(),
            ]);
            
        } catch (\Exception $e) {
            $this->error("Exception: " . $e->getMessage());
            return 1;
        }

        return 0;
    }

    protected function parseOnuOutput(string $output, string $port): array
    {
        $onus = [];
        $lines = explode("\n", $output);

        foreach ($lines as $line) {
            $line = trim($line);
            
            // Skip headers and empty lines
            if (empty($line) || stripos($line, 'onu') === 0 || str_starts_with($line, '-')) {
                continue;
            }

            // Try different parsing patterns
            // Pattern 1: ID  SERIAL  STATUS  AUTH
            if (preg_match('/^(\d+)\s+([A-Z0-9]+)\s+(\S+)(?:\s+(\S+))?/', $line, $matches)) {
                $onus[] = [
                    'port' => $port,
                    'onu_id' => (int)$matches[1],
                    'serial_number' => $matches[2],
                    'status' => $this->normalizeStatus($matches[3] ?? 'unknown'),
                    'auth_state' => $matches[4] ?? null,
                    'raw_line' => $line,
                ];
            }
        }

        return $onus;
    }

    protected function normalizeStatus(string $status): string
    {
        $status = strtolower($status);
        
        if (in_array($status, ['online', 'working', 'up'])) {
            return 'online';
        } elseif (in_array($status, ['offline', 'down'])) {
            return 'offline';
        } elseif (in_array($status, ['los', 'dying-gasp'])) {
            return 'los';
        }
        
        return 'unknown';
    }
}
