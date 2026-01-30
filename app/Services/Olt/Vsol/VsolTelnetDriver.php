<?php

declare(strict_types=1);

namespace App\Services\Olt\Vsol;

use RuntimeException;

final class VsolTelnetDriver
{
    // Connection Configuration
    private const DEFAULT_PORT = 23;
    private const DEFAULT_TIMEOUT = 10;
    private const MAX_RETRY_ATTEMPTS = 3;
    private const RETRY_DELAY_MS = 1000; // 1 second
    private const SOCKET_READ_BUFFER = 8192;
    
    // Command Timeouts
    private const TIMEOUT_SHORT = 5;
    private const TIMEOUT_MEDIUM = 30;
    private const TIMEOUT_LONG = 120;
    private const TIMEOUT_CONFIG = 300;
    
    /** @var resource|null */
    private $socket = null;
    private bool $isLoggedIn = false;

    // Config
    private string $host;
    private int $port;
    private string $username;
    private string $password;
    private int $timeoutSeconds;

    // Prompt/patterns
    private string $promptRegex;
    private array $loginPrompts;
    private array $passwordPrompts;
    private array $morePrompts;

    public function __construct(array $cfg)
    {
        $this->host = (string)($cfg['host'] ?? '');
        $this->port = (int)($cfg['port'] ?? 23);
        $this->username = (string)($cfg['username'] ?? '');
        $this->password = (string)($cfg['password'] ?? '');
        $this->timeoutSeconds = (int)($cfg['timeout'] ?? 20);

        // Prompt regex: ajustable por firmware
        $this->promptRegex = (string)($cfg['prompt_regex'] ?? '/(?:OLT[>#]|[#>])\s*$/m');

        $this->loginPrompts = $cfg['login_prompts'] ?? ['Login:', 'Username:'];
        $this->passwordPrompts = $cfg['password_prompts'] ?? ['Password:'];
        $this->morePrompts = $cfg['more_prompts'] ?? ['--More--', 'More:', 'Press any key'];

        if ($this->host === '' || $this->username === '' || $this->password === '') {
            throw new RuntimeException("Config inválida: host/username/password son requeridos");
        }
    }

    public function __destruct()
    {
        if ($this->socket) {
            fclose($this->socket);
        }
    }

    /**
     * Conecta y loguea con retry automático. Idempotente: si ya está logueado, no hace nada.
     * 
     * @throws RuntimeException Si falla después de todos los reintentos
     */
    public function connectAndLogin(): void
    {
        if ($this->isLoggedIn) {
            return;
        }

        $lastException = null;
        
        for ($attempt = 1; $attempt <= self::MAX_RETRY_ATTEMPTS; $attempt++) {
            try {
                $this->attemptConnection();
                $this->isLoggedIn = true;
                
                // Log successful connection if it took multiple attempts
                if ($attempt > 1) {
                    \Illuminate\Support\Facades\Log::info("VSOL: Connected to {$this->host} after {$attempt} attempts");
                }
                
                return;
            } catch (RuntimeException $e) {
                $lastException = $e;
                
                // Don't retry on authentication failures
                if (str_contains($e->getMessage(), 'Login') || str_contains($e->getMessage(), 'prompt')) {
                    throw $e;
                }
                
                // Log retry attempt
                if ($attempt < self::MAX_RETRY_ATTEMPTS) {
                    $delay = self::RETRY_DELAY_MS * $attempt; // Exponential backoff
                    \Illuminate\Support\Facades\Log::warning(
                        "VSOL: Connection attempt {$attempt} failed: {$e->getMessage()}. Retrying in {$delay}ms..."
                    );
                    usleep($delay * 1000); // Convert to microseconds
                }
            }
        }
        
        // All retries exhausted
        throw new RuntimeException(
            "Failed to connect to {$this->host} after " . self::MAX_RETRY_ATTEMPTS . " attempts. Last error: " . 
            ($lastException ? $lastException->getMessage() : 'Unknown error')
        );
    }

    /**
     * Intenta una conexión única sin retry
     * 
     * @throws RuntimeException Si falla la conexión o login
     */
    private function attemptConnection(): void
    {
        // Close existing socket if any
        if ($this->socket) {
            fclose($this->socket);
            $this->socket = null;
        }

        // Open socket
        $this->socket = @fsockopen($this->host, $this->port, $errno, $errstr, $this->timeoutSeconds);
        if (!$this->socket) {
            throw new RuntimeException("Telnet connection failed: {$errstr} ({$errno})");
        }

        stream_set_blocking($this->socket, false);
        stream_set_timeout($this->socket, $this->timeoutSeconds);

        // Leer banner inicial hasta pedir Login/Password o prompt
        $buf = $this->readUntilAny([
            ...$this->loginPrompts,
            ...$this->passwordPrompts,
        ], 10);

        // Algunos firmwares preguntan Login primero
        if ($this->containsAny($buf, $this->loginPrompts)) {
            $this->writeLine($this->username);
            $buf .= $this->readUntilAny($this->passwordPrompts, 10);
        }

        // Password
        if ($this->containsAny($buf, $this->passwordPrompts)) {
            $this->writeLine($this->password);
        }

        // Esperar prompt final
        $final = $this->readUntilPrompt(20);
        if (!$this->looksLikePrompt($final)) {
            // A veces el prompt llega con más banner: volver a leer
            $final .= $this->readUntilPrompt(10);
        }

        if (!$this->looksLikePrompt($final)) {
            throw new RuntimeException("Login Telnet no llegó a prompt. Output:\n" . $final);
        }

        // Para VSOL, necesitamos enable para acceder a comandos
        $this->enable();

        $this->isLoggedIn = true;
    }

    /**
     * Ejecuta 'enable' para acceder a modo privilegiado (necesario en este firmware VSOL)
     * Tambien deshabilita paginacion y logs para evitar timeouts.
     */
    private function enable(): void
    {
        $this->writeLine('enable');
        sleep(1);
        
        $response = $this->readSocket(2);
        
        // Si pide password, enviar
        if ($this->containsAny($response, $this->passwordPrompts)) {
            $this->writeLine($this->password);
            sleep(2);
            $this->readSocket(2);
        }

        // Anti-Spam & Anti-Pagination Injection
        // We try common commands blindly. If they fail, they just print error but won't stop us.
        $this->writeLine('undo terminal monitor'); // VSOL/Huawei default
        $this->writeLine('no terminal monitor');   // Cisco/ZTE variant
        $this->writeLine('terminal length 0');     // Disable pagination
        $this->writeLine('idle-timeout 0');        // Prevent idle disconnect
        
        // Consume output from these commands to clear buffer
        $this->readSocket(2);
    }

    /**
     * Ejecuta comando y regresa output completo SIN el eco del prompt final.
     * Maneja --More--.
     * Reintenta si detecta que la OLT volvió a Login.
     */
    public function run(string $command, int $timeout = 25): string
    {
        $this->connectAndLogin();

        $this->writeLine($command);

        $out = $this->readUntilPromptWithMore($timeout);

        // Si por cualquier motivo se regresó a login, reloguea y reintenta 1 vez
        if ($this->containsAny($out, $this->loginPrompts) || $this->containsAny($out, $this->passwordPrompts)) {
            $this->isLoggedIn = false;
            $this->connectAndLogin();

            $this->writeLine($command);
            $out = $this->readUntilPromptWithMore($timeout);
        }

        return $this->cleanupOutput($out);
    }

    /**
     * Importador: ONUs desde running-config (VSOL Estilo C)
     * Estrategia: usar running-config que es más confiable
     */
    /**
     * Importador: ONUs desde running-config (VSOL Estilo C)
     * Estrategia: usar running-config que es más confiable
     */
    public function importOnus(array $cmdMap = []): array
    {
        // Increase timeout to 300s for heavy configs
        $rawConfig = $this->run('show running-config', 300);

        // Debug: Log config size to see if we got it all
        // \Illuminate\Support\Facades\Log::info("VSOL Config Read: " . strlen($rawConfig) . " bytes");

        $onus = VsolParsers::parseOnusFromRunningConfig($rawConfig);

        return [
            'config_raw' => $rawConfig,
            'onus'       => $onus,
            'total'      => count($onus),
            'strategy'   => 'running-config',
        ];
    }

    /**
     * Retrieves detailed ONU status (Dying Gasp, LOS) via CLI.
     * Command: configure terminal -> show onu state
     */
    public function getOnuStatusDetailed(): array
    {
        try {
            $this->run('configure terminal', 10);
            
            // This command dumps all ONUs, might be large
            $output = $this->run('show onu state', 60);
            
            $this->run('exit', 5);
            
            return VsolParsers::parseOnuState($output);
        } catch (\Exception $e) {
            \Illuminate\Support\Facades\Log::warning("VSOL CLI Status Failed: " . $e->getMessage());
            return [];
        }
    }

    /**
     * Retrieves optical info and distance for specific ports
     * @param array $ponPorts List of PON ports (e.g. ['0/1', '0/2'])
     */
    public function getOnuOpticalInfo(array $ponPorts): array
    {
        $results = [];

        try {
            $this->run('configure terminal', 10);
            
            foreach ($ponPorts as $port) {
                try {
                    // Enter interface context
                    // "interface gpon 0/1"
                    $out = $this->run("interface gpon {$port}", 5);
                    
                    if (strpos($out, '% Unknown command') !== false) {
                         \Illuminate\Support\Facades\Log::warning("VSOL Interface {$port} error: $out");
                         continue;
                    }

                    // Bulk Optical Info
                    $output = $this->run("show onu 1-128 optical_info", 120);
                    $parsed = VsolParsers::parseOpticalInfo($output);

                    // Bulk Distance
                    $distOut = $this->run("show onu 1-128 distance", 120);
                    $parsedDist = VsolParsers::parseDistance($distOut);

                    // Merge result with Key "PORT:ID"
                    foreach ($parsed as $oid => $data) {
                        $key = "{$port}:{$oid}";
                        $results[$key] = $data;
                        if (isset($parsedDist[$oid])) {
                            $results[$key]['distance'] = $parsedDist[$oid];
                        }
                    }
                    
                    $this->run("exit", 5);

                } catch (\Exception $e) {
                    \Illuminate\Support\Facades\Log::error("VSOL Optical Info Error on {$port}: " . $e->getMessage());
                    // Try to recover context
                    $this->run("exit", 2);
                }
            }

            $this->run('exit', 5);

        } catch (\Exception $e) {
             \Illuminate\Support\Facades\Log::error("VSOL Optical Context Error: " . $e->getMessage());
        }
        
        return $results;
    }

    // ----------------- Internals -----------------

    private function readUntilPromptWithMore(int $timeout): string
    {
        $start = time();
        $out = '';

        while ((time() - $start) < $timeout) {
            $chunk = fread($this->socket, 65536); // Read big chunks

            if ($chunk === false || $chunk === '') {
                usleep(50000); // 50ms wait if no data
                continue;
            }

            $out .= $chunk;

            // Manejo de --More--: check last 100 chars
            $tail = substr($out, -100);
            if ($this->containsAny($tail, $this->morePrompts)) {
                // Send Request for more
                fwrite($this->socket, " ");
                
                // Important: clear the --More-- from buffer logic if needed, 
                // but typically we just keep reading. 
                // Wait a tiny bit for reaction
                usleep(50000); 
                continue;
            }

            // Check prompt on the whole buffer or tail
            // Optimization: check prompt only if we recently received data
            if ($this->looksLikePrompt($out)) {
                return $out;
            }
        }
        
        throw new RuntimeException("Timeout esperando prompt after {$timeout}s. Received " . strlen($out) . " bytes. Tail:\n" . substr($out, -500));
    }

    private function readUntilPrompt(int $timeout): string
    {
        return $this->readUntilPromptWithMore($timeout); // Reuse logic, --More-- handling is safe
    }

    private function readUntilAny(array $needles, int $timeout): string
    {
        $start = time();
        $out = '';

        while ((time() - $start) < $timeout) {
            $chunk = fread($this->socket, 8192);

            if ($chunk === false || $chunk === '') {
                usleep(50000);
                continue;
            }

            $out .= $chunk;

            foreach ($needles as $n) {
                if ($n !== '' && strpos($out, $n) !== false) {
                    return $out;
                }
            }

            if ($this->looksLikePrompt($out)) {
                return $out;
            }
        }
        
        return $out; // Return what we have on timeout
    }

    private function readSocket(int $timeout): string
    {
        // Deprecated or simplified
        return $this->readUntilAny([], $timeout); 
    }

    private function writeLine(string $s): void
    {
        fwrite($this->socket, $s . "\r\n");
    }

    private function looksLikePrompt(string $text): bool
    {
        return (bool)preg_match($this->promptRegex, $text);
    }

    private function containsAny(string $haystack, array $needles): bool
    {
        foreach ($needles as $n) {
            if ($n !== '' && strpos($haystack, $n) !== false) {
                return true;
            }
        }
        return false;
    }

    private function cleanupOutput(string $out): string
    {
        // Quitar caracteres raros comunes Telnet
        $out = str_replace("\r", "", $out);

        // Opcional: quitar --More-- residual
        foreach ($this->morePrompts as $m) {
            $out = str_replace($m, "", $out);
        }

        return trim($out);
    }
}
