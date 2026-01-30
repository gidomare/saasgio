<?php

namespace App\Console\Commands;

use App\Models\Olt;
use App\Models\Onu;
use App\Services\OltService;
use Illuminate\Console\Command;

class TestOnuImport extends Command
{
    protected $signature = 'onu:test-import';
    protected $description = 'Test ONU import from running-config';

    public function handle()
    {
        $olt = Olt::latest()->first();
        
        if (!$olt) {
            $this->error('No OLT found');
            return 1;
        }

        $this->info("Testing ONU import from: {$olt->name}");
        
        $service = new OltService($olt);
        
        // Get all ONUs
        $this->info("\nGetting all ONUs from running-config...");
        $result = $service->getAllOnus();
        
        if (!$result['success']) {
            $this->error("Failed: {$result['error']}");
            return 1;
        }

        $this->info("✓ Found {$result['total']} ONUs");

        if ($result['total'] == 0) {
            $this->warn("No ONUs found. Checking config manually...");
            
            // Get config and check
            $configResult = $service->getOltInfo();
            if ($configResult['success']) {
                $config = $configResult['output'];
                $this->info("Config size: " . strlen($config) . " bytes");
                
                // Count onu add lines
                $onuAddCount = substr_count($config, 'onu add');
                $this->info("Lines with 'onu add': {$onuAddCount}");
                
                // Show sample
                $lines = explode("\n", $config);
                $this->info("\nSample lines with 'onu add':");
                $count = 0;
                foreach ($lines as $line) {
                    if (stripos($line, 'onu add') !== false) {
                        $this->line("  " . trim($line));
                        $count++;
                        if ($count >= 5) break;
                    }
                }
            }
            
            return 1;
        }

        // Display ONUs
        $this->info("\nONUs found:");
        $this->table(
            ['Port', 'ID', 'Serial', 'Profile', 'VLAN', 'Name'],
            array_map(function($onu) {
                return [
                    $onu['port'],
                    $onu['onu_id'],
                    $onu['serial_number'],
                    $onu['onu_type'],
                    $onu['vlan'] ?? 'N/A',
                    substr($onu['name'] ?? 'N/A', 0, 30),
                ];
            }, array_slice($result['onus'], 0, 20))
        );

        // Ask to import
        if ($this->confirm("\nImport these ONUs to database?", true)) {
            $imported = 0;
            $updated = 0;

            foreach ($result['onus'] as $onuData) {
                $onu = Onu::updateOrCreate(
                    [
                        'olt_id' => $olt->id,
                        'serial_number' => $onuData['serial_number'],
                    ],
                    [
                        'port' => $onuData['port'],
                        'onu_id' => $onuData['onu_id'],
                        'onu_type' => $onuData['onu_type'],
                        'vlan' => $onuData['vlan'],
                        'name' => $onuData['name'],
                        'status' => 'unknown',
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
            $this->info("  New: {$imported}");
            $this->info("  Updated: {$updated}");
        }

        return 0;
    }
}
