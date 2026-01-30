<?php

namespace App\Jobs;

use App\Models\Backup;
use App\Services\BackupService;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Log;
use Filament\Notifications\Notification;

class CreateBackupJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public $timeout = 600; // 10 minutes

    public function __construct(
        public string $type = 'manual',
        public ?int $userId = null
    ) {}

    public function handle(BackupService $backupService): void
    {
        try {
            $backup = $backupService->createBackup($this->type);

            // Send success notification
            if ($this->userId) {
                Notification::make()
                    ->title('Backup Completado')
                    ->success()
                    ->body("Backup creado exitosamente: {$backup->formatted_size}")
                    ->sendToDatabase(\App\Models\User::find($this->userId));
            }

            Log::info("Backup job completed successfully", [
                'backup_id' => $backup->id,
                'type' => $this->type,
            ]);

        } catch (\Exception $e) {
            // Send error notification
            if ($this->userId) {
                Notification::make()
                    ->title('Error en Backup')
                    ->danger()
                    ->body("Error al crear backup: {$e->getMessage()}")
                    ->sendToDatabase(\App\Models\User::find($this->userId));
            }

            Log::error("Backup job failed", [
                'error' => $e->getMessage(),
                'type' => $this->type,
            ]);

            throw $e;
        }
    }
}
