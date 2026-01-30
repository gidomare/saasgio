<?php

namespace App\Jobs;

use App\Models\Olt;
use App\Models\Onu;
use App\Services\OltService;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Log;

class ImportOnusFromOltJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public function __construct(
        public Olt $olt
    ) {}

    public function handle(): void
    {
        $service = new OltService($this->olt);
        
        Log::info("Starting ONU import from OLT: {$this->olt->name}");

        try {
            // Use getAllOnus which will automatically use VSOL driver if applicable
            $result = $service->getAllOnus();
            
            if (!$result['success']) {
                throw new \Exception($result['error'] ?? 'Failed to get ONUs');
            }
            
            $allOnus = $result['onus'];
            Log::info("Found {$result['total']} ONUs from OLT");

            // Import/update ONUs in database
            $imported = 0;
            $updated = 0;

            foreach ($allOnus as $onuData) {
                $onu = Onu::updateOrCreate(
                    [
                        'olt_id' => $this->olt->id,
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

            Log::info("ONU import completed: {$imported} imported, {$updated} updated");

            $this->olt->update([
                'last_check_output' => "ONUs imported: {$imported} new, {$updated} updated (Total: {$result['total']})",
                'last_check_at' => now(),
            ]);

        } catch (\Exception $e) {
            Log::error("ONU import failed: " . $e->getMessage());
            
            $this->olt->update([
                'last_check_output' => "Import failed: " . $e->getMessage(),
                'last_check_at' => now(),
            ]);
            
            throw $e; // Re-throw to mark job as failed
        }
    }

    /**
     * Parse ONU output from show gpon onu state
     */
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

            // Parse line format (varies by OLT, adjust as needed)
            // Example: 1  FHTT12345678  online  authorized
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



    /**
     * Normalize ONU status
     */
    protected function normalizeStatus(string $status): string
    {
        $status = strtolower($status);
        
        if (in_array($status, ['online', 'working'])) {
            return 'online';
        } elseif (in_array($status, ['offline', 'down'])) {
            return 'offline';
        } elseif (in_array($status, ['los', 'dying-gasp'])) {
            return 'los';
        }
        
        return 'unknown';
    }
}
