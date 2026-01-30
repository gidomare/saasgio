<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Storage;

class Backup extends Model
{
    protected $fillable = [
        'name',
        'path',
        'disk',
        'size',
        'type',
        'status',
        'error_message',
        'hash',
        'metadata',
        'completed_at',
    ];

    protected $casts = [
        'metadata' => 'array',
        'completed_at' => 'datetime',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    /**
     * Get human-readable size
     */
    public function getFormattedSizeAttribute(): string
    {
        $bytes = $this->size;
        $units = ['B', 'KB', 'MB', 'GB', 'TB'];
        
        for ($i = 0; $bytes > 1024; $i++) {
            $bytes /= 1024;
        }
        
        return round($bytes, 2) . ' ' . $units[$i];
    }

    /**
     * Check if backup file exists
     */
    public function exists(): bool
    {
        return Storage::disk($this->disk)->exists($this->path);
    }

    /**
     * Delete backup file from storage
     */
    public function deleteFile(): bool
    {
        if ($this->exists()) {
            return Storage::disk($this->disk)->delete($this->path);
        }
        return false;
    }

    /**
     * Get download URL
     */
    public function getDownloadUrl(): string
    {
        return route('backup.download', $this->id);
    }

    /**
     * Scope: Only completed backups
     */
    public function scopeCompleted($query)
    {
        return $query->where('status', 'completed');
    }

    /**
     * Scope: Only failed backups
     */
    public function scopeFailed($query)
    {
        return $query->where('status', 'failed');
    }

    /**
     * Scope: Manual backups
     */
    public function scopeManual($query)
    {
        return $query->where('type', 'manual');
    }

    /**
     * Scope: Automatic backups
     */
    public function scopeAutomatic($query)
    {
        return $query->where('type', 'automatic');
    }

    /**
     * Scope: Old backups (older than X days)
     */
    public function scopeOlderThan($query, int $days)
    {
        return $query->where('created_at', '<', now()->subDays($days));
    }
}
