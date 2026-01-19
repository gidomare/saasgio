<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Plan extends Model
{
    protected $fillable = [
        'name',
        'download_speed_kbps',
        'upload_speed_kbps',
        'price',
        'wisphub_id',
    ];

    protected $casts = [
        'download_speed_kbps' => 'integer',
        'upload_speed_kbps' => 'integer',
        'price' => 'decimal:2',
    ];
}
