<?php

namespace App\Jobs;

use App\Models\Olt;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Log;
use phpseclib3\Net\SSH2;

class ConfigureOltSnmpJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public function __construct(
        public Olt $olt,
        public string $trapHost = '10.150.1.4'
    ) {}

    public function handle(): void
    {
        $logOutput = "=== Configurando SNMP en OLT ===\n";
        $logOutput .= "OLT: {$this->olt->name} ({$this->olt->ip_admin})\n";
        $logOutput .= "Trap Host: {$this->trapHost}\n\n";

        try {
            $ssh = new SSH2($this->olt->ip_admin, $this->olt->ssh_port, 30);
            
            if (!$ssh->login($this->olt->username, $this->olt->password)) {
                throw new \Exception('SSH authentication failed');
            }

            $logOutput .= "✓ SSH conectado\n\n";

            // Comandos SNMP para VSOL
            $commands = [
                'enable',
                'configure terminal',
                'snmp enable',
                "snmp community ro {$this->olt->snmp_community_read}",
                "snmp community rw {$this->olt->snmp_community_write}",
                "snmp host {$this->trapHost} version 2c community {$this->olt->snmp_community_read}",
                'write',
                'exit',
                'exit',
            ];

            $logOutput .= "Ejecutando comandos SNMP:\n";
            foreach ($commands as $cmd) {
                $logOutput .= "  > {$cmd}\n";
                $ssh->write("{$cmd}\n");
                sleep(1);
                $output = $ssh->read();
                if (!empty(trim($output))) {
                    $logOutput .= "    " . trim($output) . "\n";
                }
            }

            $ssh->disconnect();

            $logOutput .= "\n✓ SNMP configurado exitosamente\n";
            $logOutput .= "La OLT enviará traps a: {$this->trapHost}\n";

            $this->olt->update([
                'last_check_output' => $logOutput,
                'last_check_at' => now(),
            ]);

            Log::info("SNMP configured on OLT {$this->olt->name}", [
                'trap_host' => $this->trapHost,
            ]);

        } catch (\Exception $e) {
            $logOutput .= "\n❌ Error: " . $e->getMessage() . "\n";
            
            $this->olt->update([
                'last_check_output' => $logOutput,
                'last_check_at' => now(),
            ]);

            Log::error("SNMP Configuration Failed [{$this->olt->name}]: " . $e->getMessage());
        }
    }
}
