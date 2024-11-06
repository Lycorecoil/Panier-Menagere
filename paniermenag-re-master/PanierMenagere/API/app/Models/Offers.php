<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Offers extends Model
{
    use HasFactory;

    protected $table = 'offers';

    public $timestamps = true; //by default timestamp false

    protected $fillable = [
        'name',
        'off',
        'type',
        'upto',
        'min',
        'from',
        'to',
        'descriptions',
        'date_time',
        'image',
        'manage',
        'store_id',
        'status',
        'extra_field'
    ];

    protected $hidden = [
        'updated_at',
        'created_at',
    ];

    protected $casts = [
        'status' => 'integer',
        'manage' => 'integer',
    ];
}
