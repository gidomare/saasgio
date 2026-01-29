<?php

namespace App\Jobs;

use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Queue\Queueable;

class TestVpnConnectionJob implements ShouldQueue
{
    use Queueable;

    /**
     * Create a new job instance.
     */
    public function __construct(
        public \App\Models\VpnTunnel $vpnTunnel
    ) {}

    public function handle(): void
    {
        $this->vpnTunnel->update(['status' => 'testing']);

        try {
            $interface = $this->vpnTunnel->name;
            $confPath = "/config/wg_confs/{$interface}.conf";

            // 1. Reload Interface (Down/Up) via Docker Exec API
            // Down (Ignore error if not up)
            $this->executeDockerCmd('wms-vpn', ['wg-quick', 'down', $confPath]);
            
            // Up
            $upResult = $this->executeDockerCmd('wms-vpn', ['wg-quick', 'up', $confPath]);
            
            // Log output for debugging
            $logOutput = "Reload Output:\n" . $upResult['output'] . "\n\n";

            // Esperar brevemente a que negocie
            sleep(3);

            // 2. Ejecutar Ping
            // Extraer IP de la configuración del modelo
            $config = $this->vpnTunnel->config_content;
            $ipToPing = null;
            
            if (preg_match('/Address\s*=\s*([0-9\.]+)/i', $config, $matches)) {
                $clientIp = $matches[1];
                $parts = explode('.', $clientIp);
                if (count($parts) === 4) {
                    $parts[3] = '1';
                    $ipToPing = implode('.', $parts);
                }
            }
            
            if (!$ipToPing && $this->vpnTunnel->test_ip) {
                $ipToPing = $this->vpnTunnel->test_ip;
            }

            if ($ipToPing && $ipToPing !== $this->vpnTunnel->test_ip) {
                 $this->vpnTunnel->update(['test_ip' => $ipToPing]);
            }

            if (!$ipToPing) {
                $status = 'connected';
                $loss = 0;
                $latency = 0;
            } else {
                $cmd = "ping -c 3 -W 2 " . escapeshellarg($ipToPing);
                exec($cmd, $output, $returnVar);
                
                $outputStr = implode("\n", $output);
                $logOutput .= "Ping Output:\n" . $outputStr;
                
                preg_match('/(\d+)% packet loss/', $outputStr, $matches);
                $loss = isset($matches[1]) ? intval($matches[1]) : 100;

                preg_match('/min\/avg\/max.* = [\d\.]+\/([\d\.]+)\//', $outputStr, $matchesLat);
                $latency = isset($matchesLat[1]) ? floatval($matchesLat[1]) : null;

                $status = ($loss < 100) ? 'connected' : 'disconnected';
            }

            $this->vpnTunnel->update([
                'status' => $status,
                'last_latency' => $latency ? intval($latency) : null,
                'last_packet_loss' => $loss,
                'last_check_at' => now(),
                'last_test_output' => $logOutput,
            ]);

        } catch (\Throwable $e) {
            \Illuminate\Support\Facades\Log::error("VPN Test Failed: " . $e->getMessage());
            $this->vpnTunnel->update([
                'status' => 'error',
                'last_test_output' => "Error: " . $e->getMessage()
            ]);
        }
    }

    private function executeDockerCmd(string $container, array $cmd): array
    {
        // 1. Create Exec Instance
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_UNIX_SOCKET_PATH, '/var/run/docker.sock');
        curl_setopt($ch, CURLOPT_URL, "http://localhost/containers/{$container}/exec");
        curl_setopt($ch, CURLOPT_POST, 1);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json']);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode([
            'AttachStdout' => true,
            'AttachStderr' => true,
            'Tty' => false,
            'Cmd' => $cmd
        ]));
        $response = curl_exec($ch);
        curl_close($ch);
        
        $json = json_decode($response, true);
        $execId = $json['Id'] ?? null;

        if (!$execId) {
            throw new \Exception("Could not create exec instance on $container");
        }

        // 2. Start Exec
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_UNIX_SOCKET_PATH, '/var/run/docker.sock');
        curl_setopt($ch, CURLOPT_URL, "http://localhost/exec/{$execId}/start");
        curl_setopt($ch, CURLOPT_POST, 1);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json']);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode([
            'Detach' => false,
            'Tty' => false
        ]));
        $output = curl_exec($ch);
        curl_close($ch);

        return ['output' => $output];
    }
}
