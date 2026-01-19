<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Customer extends Model
{
    protected $fillable = [
        'name',
        'email',
        'phone',
        'address',
        'coordinates',
        'wisphub_id',
        'installation_date',
    ];

    public function services()
    {
        return $this->hasMany(Service::class);
    }
}
