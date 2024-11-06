<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Languages extends Model
{
    use HasFactory;

    protected $table = 'languages';

    public $timestamps = true; //by default timestamp false

    protected $fillable = ['name', 'cover', 'content', 'is_default', 'status', 'extra_field'];

    protected $hidden = [
        'updated_at',
        'created_at',
    ];

    protected $casts = [
        'status' => 'integer',
        'is_default' => 'integer'
    ];
}
