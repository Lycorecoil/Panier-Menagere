<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class StoreRequest extends Model
{
    use HasFactory;

    protected $table = 'store_request';

    public $timestamps = true; //by default timestamp false

    protected $fillable = [
        'email',
        'password',
        'first_name',
        'last_name',
        'mobile',
        'country_code',
        'cover',
        'lat',
        'lng',
        'address',
        'name',
        'descriptions',
        'open_time',
        'close_time',
        'cid',
        'zipcode',
        'extra_field',
        'status'
    ];

    protected $hidden = [
        'password'
    ];

    protected $casts = [
        'status' => 'integer',
    ];
}
