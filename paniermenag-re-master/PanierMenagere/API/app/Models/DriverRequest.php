<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class DriverRequest extends Model
{
    use HasFactory;

    protected $table = 'driver_request';

    public $timestamps = true; //by default timestamp false

    protected $fillable = [
        'first_name',
        'last_name',
        'email',
        'password',
        'country_code',
        'mobile',
        'cover',
        'lat',
        'lng',
        'gender',
        'city',
        'address',
        'status',
        'extra_field'
    ];

    protected $hidden = [
        'updated_at',
        'created_at',
    ];

    protected $casts = [
        'status' => 'integer',
        'gender' => 'integer',
    ];
}
