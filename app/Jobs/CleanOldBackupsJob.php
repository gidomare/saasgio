<?php

namespace App\Jobs;

use App\Services\BackupService;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Log;

class CleanOldBackupsJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public function __construct(
        public int $daysToKeep = 7
    ) {}

    public function handle(BackupService $backupService): void
    {
        try {
            $deleted = $backupService->cleanOldBackups($this->daysToKeep);

            Log::info("Old backups cleaned", [
                'deleted_count' => $deleted,
                'days_to_keep' => $this->daysToKeep,
            ]);

        } catch (\Exception $e) {
            Log::error("Clean backups job failed", [
                'error' => $e->getMessage(),
            ]);

            throw $e;
        }
    }
}
