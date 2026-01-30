<?php

namespace App\Jobs;

use App\Models\Olt;
use App\Services\OltService;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Log;

class TestOltConnectionJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public function __construct(
        public Olt $olt
    ) {}

    public function handle(): void
    {
        $this->olt->update(['status' => 'testing']);
        $logOutput = "";

        try {
            $service = new OltService($this->olt);

            // 1. Ping Test
            $logOutput .= "=== Ping Test ===\n";
            $pingCmd = "ping -c 3 -W 2 {$this->olt->ip_admin} 2>&1";
            exec($pingCmd, $pingOutput, $pingReturnCode);
            $pingStr = implode("\n", $pingOutput);
            $logOutput .= $pingStr . "\n\n";

            if ($pingReturnCode !== 0) {
                $logOutput .= "⚠ Ping failed but continuing with SSH test...\n\n";
            }

            // 2. SSH Connection Test
            $logOutput .= "=== SSH Connection Test ===\n";
            
            $connTest = $service->testConnection();
            
            if (!$connTest['success']) {
                throw new \Exception("SSH connection failed: " . ($connTest['error'] ?? 'Unknown error'));
            }
            
            $logOutput .= "✓ SSH authentication successful\n";
            $logOutput .= "✓ Connected to VSOL OLT\n\n";
            
            if (!empty($connTest['banner'])) {
                $logOutput .= "OLT Banner:\n";
                $logOutput .= substr($connTest['banner'], 0, 200) . "\n\n";
            }

            // Success
            $this->olt->update([
                'status' => 'online',
                'last_check_at' => now(),
                'last_check_output' => $logOutput,
                'hardware_info' => [
                    'banner' => $connTest['banner'] ?? null,
                    'last_test' => now()->toDateTimeString(),
                ],
            ]);

        } catch (\Throwable $e) {
            Log::error("OLT Test Failed [{$this->olt->name}]: " . $e->getMessage());
            $this->olt->update([
                'status' => 'error',
                'last_check_at' => now(),
                'last_check_output' => "❌ Error: " . $e->getMessage() . "\n\n" . $logOutput,
            ]);
        }
    }
}
