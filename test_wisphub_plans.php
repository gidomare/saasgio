<?php

require __DIR__.'/vendor/autoload.php';

$app = require_once __DIR__.'/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

echo "Testing Wisphub API Plans endpoint...\n\n";

$integration = \App\Models\Integration::where('slug', 'wisphub')->first();

if (!$integration) {
    die("No Wisphub integration found\n");
}

$url = $integration->settings['url'] ?? '';
$apiKey = $integration->settings['api_key'] ?? '';

if (empty($url) || empty($apiKey)) {
    die("Missing URL or API Key\n");
}

// Construir URL del endpoint de planes
$schemeHost = parse_url($url, PHP_URL_SCHEME) . '://' . parse_url($url, PHP_URL_HOST);
$endpoint = $schemeHost . '/api/planes-internet/';

echo "Endpoint: $endpoint\n\n";

try {
    $response = \Illuminate\Support\Facades\Http::withHeaders([
        'Authorization' => 'Api-Key ' . $apiKey
    ])->get($endpoint);
    
    if ($response->successful()) {
        $data = $response->json();
        
        echo "Response structure:\n";
        echo "================\n";
        
        if (isset($data['results']) && is_array($data['results']) && count($data['results']) > 0) {
            echo "Found " . count($data['results']) . " plans\n\n";
            echo "First plan structure:\n";
            print_r($data['results'][0]);
            
            echo "\n\nSecond plan (if exists):\n";
            if (isset($data['results'][1])) {
                print_r($data['results'][1]);
            }
        } else {
            echo "Full response:\n";
            print_r($data);
        }
    } else {
        echo "Error: HTTP " . $response->status() . "\n";
        echo "Response: " . $response->body() . "\n";
    }
} catch (\Exception $e) {
    echo "Exception: " . $e->getMessage() . "\n";
}
