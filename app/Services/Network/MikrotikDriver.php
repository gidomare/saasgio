<?php

namespace App\Services\Network;

use App\Contracts\NetworkDriver;
use Illuminate\Support\Facades\Log;
use Exception;

class MikrotikDriver implements NetworkDriver
{
    protected $socket;
    protected $connected = false;

    public function connect(array $credentials): bool
    {
        $host = $credentials['host'] ?? '';
        $port = $credentials['port'] ?? 8728;
        $username = $credentials['username'] ?? 'admin';
        $password = $credentials['password'] ?? '';

        try {
            // Crear socket con timeout de 3 segundos
            $this->socket = @fsockopen($host, $port, $errno, $errstr, 3);
            
            if (!$this->socket) {
                throw new Exception("No se pudo conectar: $errstr ($errno)");
            }

            // Configurar timeout de lectura/escritura
            stream_set_timeout($this->socket, 3);

            // Leer banner
            $this->read();

            // Login
            $this->write('/login', false);
            $this->write('=name=' . $username, false);
            $this->write('=password=' . $password);

            $response = $this->read();
            
            if (!isset($response[0]) || $response[0] != '!done') {
                throw new Exception("Autenticación fallida");
            }

            $this->connected = true;
            return true;

        } catch (Exception $e) {
            Log::error("Error conectando a MikroTik: " . $e->getMessage());
            $this->disconnect();
            return false;
        }
    }

    public function disconnect(): void
    {
        if ($this->socket) {
            @fclose($this->socket);
            $this->socket = null;
        }
        $this->connected = false;
    }

    public function executeCommand(string $command): mixed
    {
        if (!$this->connected) {
            throw new Exception("No conectado al router");
        }

        $this->write($command);
        return $this->read();
    }

    public function getSystemInfo(): array
    {
        if (!$this->connected) {
            return ['error' => 'No conectado'];
        }

        try {
            // Obtener información del sistema
            $this->write('/system/resource/print');
            $response = $this->read();

            $info = [
                'online' => true,
                'cpu_load' => 0,
                'free_memory' => 0,
                'total_memory' => 0,
                'version' => 'Desconocida',
                'uptime' => '0s',
            ];

            foreach ($response as $line) {
                if (strpos($line, '=cpu-load=') === 0) {
                    $info['cpu_load'] = (int)substr($line, 10);
                } elseif (strpos($line, '=free-memory=') === 0) {
                    $info['free_memory'] = (int)substr($line, 13);
                } elseif (strpos($line, '=total-memory=') === 0) {
                    $info['total_memory'] = (int)substr($line, 14);
                } elseif (strpos($line, '=version=') === 0) {
                    $info['version'] = substr($line, 9);
                } elseif (strpos($line, '=uptime=') === 0) {
                    $info['uptime'] = substr($line, 8);
                }
            }

            return $info;

        } catch (Exception $e) {
            return ['error' => $e->getMessage()];
        }
    }

    protected function write(string $command, bool $endCommand = true): void
    {
        fwrite($this->socket, $this->encodeLength(strlen($command)) . $command);
        if ($endCommand) {
            fwrite($this->socket, chr(0));
        }
    }

    protected function read(): array
    {
        $response = [];
        while (true) {
            $line = $this->readLine();
            if ($line === false || strlen($line) == 0) {
                break;
            }
            $response[] = $line;
        }
        return $response;
    }

    protected function readLine(): string|false
    {
        $length = $this->decodeLength();
        if ($length === false || $length == 0) {
            return false;
        }
        return fread($this->socket, $length);
    }

    protected function encodeLength(int $length): string
    {
        if ($length < 0x80) {
            return chr($length);
        } elseif ($length < 0x4000) {
            return chr(($length >> 8) | 0x80) . chr($length & 0xFF);
        } elseif ($length < 0x200000) {
            return chr(($length >> 16) | 0xC0) . chr(($length >> 8) & 0xFF) . chr($length & 0xFF);
        } elseif ($length < 0x10000000) {
            return chr(($length >> 24) | 0xE0) . chr(($length >> 16) & 0xFF) . chr(($length >> 8) & 0xFF) . chr($length & 0xFF);
        } else {
            return chr(0xF0) . chr(($length >> 24) & 0xFF) . chr(($length >> 16) & 0xFF) . chr(($length >> 8) & 0xFF) . chr($length & 0xFF);
        }
    }

    protected function decodeLength(): int|false
    {
        $byte = ord(fread($this->socket, 1));
        if ($byte == 0) {
            return 0;
        } elseif ($byte < 0x80) {
            return $byte;
        } elseif ($byte < 0xC0) {
            return (($byte & 0x3F) << 8) | ord(fread($this->socket, 1));
        } elseif ($byte < 0xE0) {
            return (($byte & 0x1F) << 16) | (ord(fread($this->socket, 1)) << 8) | ord(fread($this->socket, 1));
        } elseif ($byte < 0xF0) {
            return (($byte & 0x0F) << 24) | (ord(fread($this->socket, 1)) << 16) | (ord(fread($this->socket, 1)) << 8) | ord(fread($this->socket, 1));
        } else {
            return (ord(fread($this->socket, 1)) << 24) | (ord(fread($this->socket, 1)) << 16) | (ord(fread($this->socket, 1)) << 8) | ord(fread($this->socket, 1));
        }
    }

    public function provisionService(array $data): bool
    {
        // Add PPP Secret or IP Binding
        return true;
    }

    public function suspendService(string $identifier): bool
    {
        // Disable secret or Firewall address list
        return true;
    }

    public function restoreService(string $identifier): bool
    {
        // Enable secret
        return true;
    }
    
    public function getHealthStats(string $identifier): array
    {
        return ['signal' => -50];
    }
}
