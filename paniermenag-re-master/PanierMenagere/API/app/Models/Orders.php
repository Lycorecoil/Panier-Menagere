<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Orders extends Model
{
    use HasFactory;

    protected $table = 'orders';

    public $timestamps = true; //by default timestamp false

    protected $fillable = [
        'uid',
        'store_id',
        'date_time',
        'paid_method',
        'order_to',
        'orders',
        'notes',
        'address',
        'driver_id',
        'assignee',
        'total',
        'tax',
        'grand_total',
        'discount',
        'delivery_charge',
        'wallet_used',
        'wallet_price',
        'extra',
        'pay_key',
        'coupon_code',
        'status',
        'payStatus',
        'extra_field'
    ];

    protected $hidden = [
        'updated_at',
        'created_at',
    ];

    protected $casts = [
        'wallet_used' => 'integer',
        'payStatus' => 'integer'
    ];
}
