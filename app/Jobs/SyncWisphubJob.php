<?php

namespace App\Jobs;

use App\Services\Integrations\WisphubService;
use App\Models\Integration;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Log;

class SyncWisphubJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    /**
     * Execute the job.
     */
    public function handle(): void
    {
        // Buscar integraciones activas con auto_sync habilitado
        $integrations = Integration::where('is_active', true)
            ->where('auto_sync', true)
            ->where('slug', 'wisphub') // Solo Wisphub por ahora
            ->get();

        foreach ($integrations as $integration) {
            $lastSynced = $integration->last_synced_at;
            $interval = $integration->sync_interval_minutes ?? 60;
            
            // Verificar si toca ejecutar
            if (!$lastSynced || now()->diffInMinutes($lastSynced) >= $interval) {
                try {
                    Log::info("Iniciando Auto-Sync para Wisphub ID: {$integration->id}");
                    $service = new WisphubService();
                    // Injectar la integración manualmente si fuera necesario, 
                    // pero el constructor del service ya busca 'wisphub'. 
                    // OJO: Si hubiera multiples integraciones wisphub, el service deberia aceptar instancia.
                    // Por ahora asumimos una sola global o que el service toma la primera.
                    
                    // Ajuste: WisphubService toma la primera 'wisphub' integration.
                    // Si quisieramos robustez, WisphubService deberia aceptar integration en constructor.
                    // Dado el scope actual, usaremos el service tal cual.
                    
                    $service->sync();
                    
                    $integration->update(['last_synced_at' => now()]);
                    Log::info("Auto-Sync Wisphub finalizado.");
                    
                } catch (\Exception $e) {
                    Log::error("Fallo Auto-Sync Wisphub: " . $e->getMessage());
                }
            }
        }
    }
}
