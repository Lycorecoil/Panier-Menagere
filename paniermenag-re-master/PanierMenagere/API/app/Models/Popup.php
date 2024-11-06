<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Popup extends Model
{
    use HasFactory;

    protected $table = 'popup';

    public $timestamps = true; //by default timestamp false

    protected $fillable = ['shown', 'message', 'date_time', 'status', 'extra_field'];

    protected $hidden = [
        'updated_at',
        'created_at',
    ];

    protected $casts = [
        'status' => 'integer',
        'shown' => 'integer'
    ];
}
