<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;

class TestVpnConnection extends Command
{
    protected $signature = 'vpn:test {tunnel_id}';
    protected $description = 'Test VPN connection';

    public function handle()
    {
        $id = $this->argument('tunnel_id');
        $tunnel = \App\Models\VpnTunnel::find($id);

        if (!$tunnel) {
            $this->error("Tunnel not found");
            return;
        }

        $tunnel->update(['status' => 'testing']);
        $logOutput = "";

        try {
            $interface = $tunnel->name;
            $confPath = "/config/wg_confs/{$interface}.conf";
            
            // 1. Clean up any existing interface first
            $cleanCmd = "docker exec wms-vpn wg-quick down {$confPath} 2>&1 || true";
            exec($cleanCmd, $cleanOutput);
            $logOutput .= "=== Cleanup ===\n" . implode("\n", $cleanOutput) . "\n\n";
            
            sleep(1);
            
            // 2. Bring up interface
            $upCmd = "docker exec wms-vpn wg-quick up {$confPath} 2>&1";
            exec($upCmd, $upOutput, $upReturnCode);
            $logOutput .= "=== Interface Up ===\n" . implode("\n", $upOutput) . "\n\n";

            if ($upReturnCode !== 0) {
                throw new \Exception("Failed to bring up interface");
            }

            sleep(3);

            // 3. Check handshake status (most reliable indicator)
            $wgCmd = "docker exec wms-vpn wg show {$interface} 2>&1";
            exec($wgCmd, $wgOutput);
            $wgStr = implode("\n", $wgOutput);
            $logOutput .= "=== Wireguard Status ===\n{$wgStr}\n\n";
            
            // Check if we have a recent handshake
            $hasHandshake = preg_match('/latest handshake: (\d+) (second|minute)s? ago/', $wgStr);
            
            // 4. Try to ping - extract potential targets from config
            $config = $tunnel->config_content;
            $pingTargets = [];
            
            // Try to extract AllowedIPs
            if (preg_match('/AllowedIPs\s*=\s*([^\n]+)/i', $config, $matches)) {
                $allowedIPs = $matches[1];
                // Parse CIDR ranges
                if (preg_match('/(\d+\.\d+\.\d+)\.\d+\/\d+/', $allowedIPs, $cidrMatch)) {
                    $network = $cidrMatch[1];
                    $pingTargets[] = "{$network}.1";   // Try .1 first
                    $pingTargets[] = "{$network}.254"; // Try .254
                    $pingTargets[] = "{$network}.0";   // Try .0
                }
            }
            
            // Also try extracting from Address
            if (preg_match('/Address\s*=\s*(\d+\.\d+\.\d+)\.\d+/i', $config, $addrMatch)) {
                $network = $addrMatch[1];
                if (!in_array("{$network}.1", $pingTargets)) {
                    $pingTargets[] = "{$network}.1";
                }
            }
            
            $pingSuccess = false;
            $latency = null;
            $loss = 100;
            $testedIp = null;
            
            foreach ($pingTargets as $target) {
                $pingCmd = "docker exec wms-vpn ping -c 3 -W 2 {$target} 2>&1";
                exec($pingCmd, $pingOutput, $pingReturnCode);
                $pingStr = implode("\n", $pingOutput);
                $logOutput .= "=== Ping Test to {$target} ===\n{$pingStr}\n\n";
                
                if (preg_match('/(\d+)% packet loss/', $pingStr, $matches)) {
                    $currentLoss = intval($matches[1]);
                    if ($currentLoss < 100) {
                        $pingSuccess = true;
                        $loss = $currentLoss;
                        $testedIp = $target;
                        
                        if (preg_match('/min\/avg\/max.* = [\d\.]+\/([\d\.]+)\//', $pingStr, $latMatches)) {
                            $latency = floatval($latMatches[1]);
                        }
                        break; // Found working target
                    }
                }
                
                $pingOutput = []; // Reset for next iteration
            }
            
            // Determine final status
            if ($hasHandshake || $pingSuccess) {
                $status = 'connected';
            } else {
                $status = 'disconnected';
            }
            
            if ($testedIp) {
                $tunnel->update(['test_ip' => $testedIp]);
            }

            $tunnel->update([
                'status' => $status,
                'last_latency' => $latency ? intval($latency) : null,
                'last_packet_loss' => $loss,
                'last_check_at' => now(),
                'last_test_output' => $logOutput,
            ]);

        } catch (\Throwable $e) {
            \Illuminate\Support\Facades\Log::error("VPN Test Failed: " . $e->getMessage());
            $tunnel->update([
                'status' => 'error',
                'last_test_output' => "Error: " . $e->getMessage() . "\n\n" . $logOutput
            ]);
        }
    }
}
