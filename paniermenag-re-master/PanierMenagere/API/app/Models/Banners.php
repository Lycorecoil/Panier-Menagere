<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Banners extends Model
{
    use HasFactory;

    protected $table = 'banners';

    public $timestamps = true; //by default timestamp false

    protected $fillable = ['city_id', 'cover', 'position', 'link', 'type', 'message', 'from', 'to', 'status', 'extra_field'];

    protected $hidden = [
        'updated_at',
        'created_at',
    ];

    protected $casts = [
        'status' => 'integer',
        'position' => 'integer',
        'type' => 'integer',
    ];
}
