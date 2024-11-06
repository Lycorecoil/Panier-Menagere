<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class General extends Model
{
    use HasFactory;

    protected $table = 'general';

    public $timestamps = true; //by default timestamp false

    protected $fillable = [
        'name',
        'mobile',
        'email',
        'address',
        'city',
        'state',
        'zip',
        'country',
        'min',
        'free',
        'tax',
        'shipping',
        'shippingPrice',
        'status',
        'extra_field'
    ];

    protected $hidden = [
        'updated_at',
        'created_at',
    ];

    protected $casts = [
        'status' => 'integer',
    ];
}
