<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Onu extends Model
{
    protected $fillable = [
        'olt_id',
        'serial_number',
        'name',
        'port',
        'onu_id',
        'onu_type',
        'status',
        'auth_state',
        'last_online_at',
        'last_offline_at',
        'rx_power',
        'tx_power',
        'olt_rx_power',
        'temperature',
        'voltage',
        'bias_current',
        'distance',
        'vlan',
        'line_profile',
        'service_profile',
        'dba_profile',
        'mac_address',
        'vendor',
        'model',
        'firmware_version',
        'hardware_version',
        'bytes_sent',
        'bytes_received',
        'uptime_seconds',
        'customer_id',
        'service_id',
        'notes',
        'raw_data',
        'discovered_at',
        'provisioned_at',
    ];

    protected $casts = [
        'last_online_at' => 'datetime',
        'last_offline_at' => 'datetime',
        'rx_power' => 'decimal:2',
        'tx_power' => 'decimal:2',
        'olt_rx_power' => 'decimal:2',
        'temperature' => 'decimal:2',
        'voltage' => 'decimal:2',
        'bias_current' => 'decimal:2',
        'distance' => 'decimal:2',
        'bytes_sent' => 'integer',
        'bytes_received' => 'integer',
        'uptime_seconds' => 'integer',
        'raw_data' => 'array',
        'discovered_at' => 'datetime',
        'provisioned_at' => 'datetime',
    ];

    /**
     * Get the OLT that owns this ONU
     */
    public function olt(): BelongsTo
    {
        return $this->belongsTo(Olt::class);
    }

    /**
     * Get the customer that owns this ONU
     */
    public function customer(): BelongsTo
    {
        return $this->belongsTo(Customer::class);
    }

    /**
     * Get the service associated with this ONU
     */
    public function service(): BelongsTo
    {
        return $this->belongsTo(Service::class);
    }

    /**
     * Get full ONU identifier (port:onu_id)
     */
    public function getFullIdentifierAttribute(): string
    {
        return "{$this->port}:{$this->onu_id}";
    }

    /**
     * Get GPON interface name
     */
    public function getInterfaceNameAttribute(): string
    {
        return "gpon-onu_{$this->port}:{$this->onu_id}";
    }

    /**
     * Check if ONU is online
     */
    public function isOnline(): bool
    {
        return $this->status === 'online';
    }

    /**
     * Check if ONU has good signal
     */
    public function hasGoodSignal(): bool
    {
        if ($this->rx_power === null) {
            return false;
        }
        
        // Typical good range: -28 to -8 dBm
        return $this->rx_power >= -28 && $this->rx_power <= -8;
    }

    /**
     * Get signal quality description
     */
    public function getSignalQualityAttribute(): string
    {
        if ($this->rx_power === null) {
            return 'unknown';
        }

        if ($this->rx_power >= -15) {
            return 'excellent';
        } elseif ($this->rx_power >= -23) {
            return 'good';
        } elseif ($this->rx_power >= -27) {
            return 'fair';
        } else {
            return 'poor';
        }
    }

    /**
     * Check if ONU has optical data
     */
    public function hasOpticalData(): bool
    {
        return $this->rx_power !== null && $this->tx_power !== null;
    }

    // ==================== Query Scopes ====================

    /**
     * Scope: Filter by online status
     */
    public function scopeOnline($query)
    {
        return $query->where('status', 'online');
    }

    /**
     * Scope: Filter by offline status
     */
    public function scopeOffline($query)
    {
        return $query->where('status', 'offline');
    }

    /**
     * Scope: Filter by LOS (Loss of Signal) status
     */
    public function scopeLos($query)
    {
        return $query->where('status', 'los');
    }

    /**
     * Scope: Filter by PON port
     */
    public function scopeOnPort($query, string $port)
    {
        return $query->where('port', $port);
    }

    /**
     * Scope: Filter by OLT
     */
    public function scopeForOlt($query, int $oltId)
    {
        return $query->where('olt_id', $oltId);
    }

    /**
     * Scope: Has optical data
     */
    public function scopeWithOpticalData($query)
    {
        return $query->whereNotNull('rx_power')
                     ->whereNotNull('tx_power');
    }

    /**
     * Scope: Good signal quality (RX power > -27 dBm)
     */
    public function scopeGoodSignal($query)
    {
        return $query->where('rx_power', '>', -27);
    }

    /**
     * Scope: Weak signal quality (RX power between -27 and -30 dBm)
     */
    public function scopeWeakSignal($query)
    {
        return $query->whereBetween('rx_power', [-30, -27]);
    }

    /**
     * Scope: Poor signal quality (RX power < -30 dBm)
     */
    public function scopePoorSignal($query)
    {
        return $query->where('rx_power', '<', -30);
    }

    /**
     * Scope: Has customer assigned
     */
    public function scopeAssigned($query)
    {
        return $query->whereNotNull('customer_id');
    }

    /**
     * Scope: No customer assigned
     */
    public function scopeUnassigned($query)
    {
        return $query->whereNull('customer_id');
    }

    /**
     * Scope: Recently discovered (within last N days)
     */
    public function scopeRecentlyDiscovered($query, int $days = 7)
    {
        return $query->where('discovered_at', '>=', now()->subDays($days));
    }

    /**
     * Scope: Active (online and has customer)
     */
    public function scopeActive($query)
    {
        return $query->where('status', 'online')
                     ->whereNotNull('customer_id');
    }
}
