<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Manage extends Model
{
    use HasFactory;

    protected $table = 'manage';

    public $timestamps = true; //by default timestamp false

    protected $fillable = ['app_close', 'message', 'date_time', 'status', 'extra_field'];

    protected $hidden = [
        'updated_at',
        'created_at',
    ];

    protected $casts = [
        'status' => 'integer',
        'app_close' => 'integer',
    ];
}
