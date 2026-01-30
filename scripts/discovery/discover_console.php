<?php

use App\Models\Olt;
use App\Services\Olt\Vsol\VsolTelnetDriver;
use Illuminate\Support\Facades\Log;

require __DIR__ . '/vendor/autoload.php';
$app = require_once __DIR__ . '/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

$olt = Olt::where('name', 'like', '%puente%')->first();

$driver = new VsolTelnetDriver([
    'host' => $olt->ip_admin,
    'port' => $olt->telnet_port,
    'username' => $olt->username,
    'password' => $olt->password,
    'timeout' => 10,
]);

$driver->connectAndLogin();

$commands = [
    'terminal ?',
    'undo terminal ?',
    'no terminal ?',
    'logging ?',
    'no logging ?',
    'undo logging ?',
    'show terminal',
    'terminal length 0',
    'terminal page-break disable',
    'no terminal monitor',
    'undo terminal monitor',
    'undo smart-log',
    'exit',
];

foreach ($commands as $cmd) {
    echo "\n----------------------------------------\n";
    echo "Trying: $cmd\n";
    try {
        $output = $driver->run($cmd, 5);
        echo "Output:\n$output\n";
    } catch (\Exception $e) {
        echo "Error: " . $e->getMessage() . "\n";
    }
}
