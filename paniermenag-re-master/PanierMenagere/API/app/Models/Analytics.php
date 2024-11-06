<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Analytics extends Model
{
    use HasFactory;

    protected $table = 'analytics';

    public $timestamps = true; //by default timestamp false

    protected $fillable = ['analytics', 'ip'];
}
