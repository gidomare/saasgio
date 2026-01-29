<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Service extends Model
{
    protected $fillable = [
        'customer_id', // Antes customer_name
        'router_id',
        'plan_id',
        'wisphub_servicio_id',
        'ip_address',
        'mac_address',
        'pppoe_user',
        'pppoe_password',
        'status',
        'balance',
        'cut_off_date',
        'last_payment_date',
        'billing_day',
        'billing_notes',
    ];

    public function customer()
    {
        return $this->belongsTo(Customer::class);
    }
    public function router()
    {
        return $this->belongsTo(Router::class);
    }

    public function plan()
    {
        return $this->belongsTo(Plan::class);
    }
}
