<?php

namespace App\Console\Commands;

use App\Models\Olt;
use App\Services\OltService;
use Illuminate\Console\Command;

class TestOltConnection extends Command
{
    protected $signature = 'olt:test {olt_id?}';
    protected $description = 'Test OLT connection and commands';

    public function handle()
    {
        $oltId = $this->argument('olt_id') ?? Olt::latest()->first()?->id;
        
        if (!$oltId) {
            $this->error('No OLT found');
            return 1;
        }

        $olt = Olt::find($oltId);
        $this->info("Testing OLT: {$olt->name} ({$olt->ip_admin})");
        
        $service = new OltService($olt);
        
        // Test 1: Connection
        $this->info("\n1. Testing connection...");
        $result = $service->testConnection();
        if ($result['success']) {
            $this->info("✓ Connected successfully");
            $this->info("  Prompt: {$result['prompt']}");
        } else {
            $this->error("✗ Connection failed: {$result['error']}");
            return 1;
        }

        // Test 2: Get version
        $this->info("\n2. Getting version...");
        $result = $service->getVersion();
        if ($result['success']) {
            $this->info("✓ Version retrieved");
            $this->line("  Version: {$result['version']}");
            $this->line("  Hostname: {$result['hostname']}");
        } else {
            $this->error("✗ Failed: {$result['error']}");
        }

        // Test 3: Get ONUs from port 1/1/1
        $this->info("\n3. Getting ONUs from port 1/1/1...");
        $result = $service->getOnusFromPort('1/1/1');
        if ($result['success']) {
            $this->info("✓ ONUs retrieved");
            $this->line("Output length: " . strlen($result['output']) . " bytes");
            $this->line($result['output']);
        } else {
            $this->error("✗ Failed: {$result['error']}");
        }

        $this->info("\n✓ All tests completed");
        return 0;
    }
}
