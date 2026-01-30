<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Crypt;

class Olt extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'ip_admin',
        'ip_private',
        'model',
        'pon_type',
        'ssh_port',
        'telnet_port',
        'snmp_port',
        'snmp_community_read',
        'snmp_community_write',
        'username',
        'password',
        'admin_olt_script',
        'status',
        'last_check_at',
        'last_check_output',
        'hardware_info',
    ];

    protected $casts = [
        'last_check_at' => 'datetime',
        'hardware_info' => 'array',
    ];

    protected $hidden = [
        'password',
    ];

    // Encrypt password when setting
    public function setPasswordAttribute($value)
    {
        if ($value) {
            $this->attributes['password'] = Crypt::encryptString($value);
        }
    }

    // Decrypt password when getting
    public function getPasswordAttribute($value)
    {
        if ($value) {
            try {
                return Crypt::decryptString($value);
            } catch (\Exception $e) {
                return null;
            }
        }
        return null;
    }

    /**
     * Get the ONUs for this OLT
     */
    public function onus()
    {
        return $this->hasMany(\App\Models\Onu::class);
    }
}
