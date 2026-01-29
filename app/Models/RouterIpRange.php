<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class RouterIpRange extends Model
{
    protected $fillable = ['router_id', 'cidr'];

    public function router()
    {
        return $this->belongsTo(Router::class);
    }
}
