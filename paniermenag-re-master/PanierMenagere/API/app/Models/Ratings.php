<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Ratings extends Model
{
    use HasFactory;

    protected $table = 'rating';

    public $timestamps = true; //by default timestamp false

    protected $fillable = ['uid', 'pid', 'did', 'sid', 'rate', 'msg', 'way', 'status', 'extra_field'];

    protected $hidden = [
        'updated_at',
        'created_at',
    ];

    protected $casts = [
        'status' => 'integer',
    ];
}
