<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class SubCategory extends Model
{
    use HasFactory;

    protected $table = 'sub_category';

    public $timestamps = true; //by default timestamp false

    protected $fillable = ['name', 'cover', 'cate_id', 'status', 'extra_field'];

    protected $hidden = [
        'updated_at',
        'created_at',
    ];

    protected $casts = [
        'status' => 'integer',
    ];
}
