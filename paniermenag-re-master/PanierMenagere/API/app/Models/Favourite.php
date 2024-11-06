<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Favourite extends Model
{
    use HasFactory;

    protected $table = 'favourite';

    public $timestamps = true; //by default timestamp false

    protected $fillable = ['uid', 'ids', 'status', 'extra_field'];

    protected $hidden = [
        'updated_at',
        'created_at',
    ];

    protected $casts = [
        'status' => 'integer',
    ];
}
