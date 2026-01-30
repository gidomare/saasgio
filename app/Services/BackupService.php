<?php

namespace App\Services;

use App\Models\Backup;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Str;
use ZipArchive;

class BackupService
{
    /**
     * Create a new backup
     */
    public function createBackup(string $type = 'manual'): Backup
    {
        $timestamp = now()->format('Y-m-d-H-i-s');
        $filename = "backup-{$timestamp}.zip";
        $path = "backups/{$filename}";

        // Create backup record
        $backup = Backup::create([
            'name' => $filename,
            'path' => $path,
            'disk' => 'local',
            'type' => $type,
            'status' => 'pending',
            'metadata' => [
                'laravel_version' => app()->version(),
                'php_version' => PHP_VERSION,
                'created_by' => auth()->user()?->name ?? 'System',
            ],
        ]);

        try {
            // Run Laravel Backup command
            Artisan::call('backup:run', [
                '--only-db' => false, // Include files
                '--disable-notifications' => true,
            ]);

            // Get the latest backup file from spatie
            $latestBackup = $this->getLatestSpatieBackup();

            if ($latestBackup) {
                // Move to our backups directory
                $newPath = "backups/{$filename}";
                Storage::disk('local')->move($latestBackup, $newPath);

                // Update backup record
                $backup->update([
                    'path' => $newPath,
                    'size' => Storage::disk('local')->size($newPath),
                    'hash' => md5_file(Storage::disk('local')->path($newPath)),
                    'status' => 'completed',
                    'completed_at' => now(),
                ]);

                Log::info("Backup created successfully: {$filename}");
            } else {
                throw new \Exception('Backup file not found after creation');
            }

        } catch (\Exception $e) {
            $backup->update([
                'status' => 'failed',
                'error_message' => $e->getMessage(),
            ]);

            Log::error("Backup failed: " . $e->getMessage());
            throw $e;
        }

        return $backup->fresh();
    }

    /**
     * Get latest backup file created by Spatie
     */
    protected function getLatestSpatieBackup(): ?string
    {
        $backupDisk = config('backup.backup.destination.disks')[0] ?? 'local';
        $backupName = config('backup.backup.name');
        
        $files = Storage::disk($backupDisk)->files($backupName);
        
        if (empty($files)) {
            return null;
        }

        // Sort by modification time, get latest
        usort($files, function ($a, $b) use ($backupDisk) {
            return Storage::disk($backupDisk)->lastModified($b) - 
                   Storage::disk($backupDisk)->lastModified($a);
        });

        return $files[0] ?? null;
    }

    /**
     * Restore from backup
     */
    public function restoreBackup(Backup $backup): bool
    {
        if (!$backup->exists()) {
            throw new \Exception('Backup file not found');
        }

        try {
            $backupPath = Storage::disk($backup->disk)->path($backup->path);
            $extractPath = storage_path('app/restore-temp');

            // Create temp directory
            if (!file_exists($extractPath)) {
                mkdir($extractPath, 0755, true);
            }

            // Extract backup
            $zip = new ZipArchive;
            if ($zip->open($backupPath) === TRUE) {
                $zip->extractTo($extractPath);
                $zip->close();
            } else {
                throw new \Exception('Failed to extract backup file');
            }

            // Find and restore database dump
            $dbDumpFile = $this->findDatabaseDump($extractPath);
            if ($dbDumpFile) {
                $this->restoreDatabase($dbDumpFile);
            }

            // Clean up temp directory
            $this->deleteDirectory($extractPath);

            Log::info("Backup restored successfully: {$backup->name}");
            return true;

        } catch (\Exception $e) {
            Log::error("Restore failed: " . $e->getMessage());
            throw $e;
        }
    }

    /**
     * Find database dump file in extracted backup
     */
    protected function findDatabaseDump(string $path): ?string
    {
        $files = glob($path . '/db-dumps/*.sql');
        return $files[0] ?? null;
    }

    /**
     * Restore database from SQL dump
     */
    protected function restoreDatabase(string $sqlFile): void
    {
        $database = config('database.connections.mysql.database');
        $username = config('database.connections.mysql.username');
        $password = config('database.connections.mysql.password');
        $host = config('database.connections.mysql.host');

        $command = sprintf(
            'mysql -h%s -u%s -p%s %s < %s',
            escapeshellarg($host),
            escapeshellarg($username),
            escapeshellarg($password),
            escapeshellarg($database),
            escapeshellarg($sqlFile)
        );

        exec($command, $output, $returnCode);

        if ($returnCode !== 0) {
            throw new \Exception('Database restore failed');
        }
    }

    /**
     * Clean old backups
     */
    public function cleanOldBackups(int $daysToKeep = 7): int
    {
        $oldBackups = Backup::completed()
            ->olderThan($daysToKeep)
            ->get();

        $deleted = 0;

        foreach ($oldBackups as $backup) {
            if ($backup->deleteFile()) {
                $backup->delete();
                $deleted++;
            }
        }

        Log::info("Cleaned {$deleted} old backups");
        return $deleted;
    }

    /**
     * Get total backups size
     */
    public function getTotalSize(): int
    {
        return Backup::completed()->sum('size');
    }

    /**
     * Get available disk space
     */
    public function getAvailableSpace(): int
    {
        return disk_free_space(storage_path('app'));
    }

    /**
     * Delete directory recursively
     */
    protected function deleteDirectory(string $dir): bool
    {
        if (!file_exists($dir)) {
            return true;
        }

        if (!is_dir($dir)) {
            return unlink($dir);
        }

        foreach (scandir($dir) as $item) {
            if ($item == '.' || $item == '..') {
                continue;
            }

            if (!$this->deleteDirectory($dir . DIRECTORY_SEPARATOR . $item)) {
                return false;
            }
        }

        return rmdir($dir);
    }
}
