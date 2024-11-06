<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Stores extends Model
{
    use HasFactory;

    protected $table = 'store';

    public $timestamps = true; //by default timestamp false

    protected $fillable = [
        'uid',
        'name',
        'mobile',
        'lat',
        'lng',
        'verified',
        'address',
        'descriptions',
        'images',
        'cover',
        'commission',
        'open_time',
        'close_time',
        'isClosed',
        'certificate_url',
        'certificate_type',
        'rating',
        'total_rating',
        'cid',
        'zipcode',
        'status',
        'extra_field'
    ];

    protected $casts = [
        'status' => 'integer',
        'verified' => 'integer',
        'isClosed' => 'integer',
    ];

    protected $hidden = [
        'updated_at',
        'created_at',
        'commission'
    ];
}
