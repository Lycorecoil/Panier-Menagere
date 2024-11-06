<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Products extends Model
{
    use HasFactory;

    protected $table = 'products';

    public $timestamps = true; //by default timestamp false

    protected $fillable = [
        'store_id',
        'cover',
        'name',
        'images',
        'original_price',
        'sell_price',
        'discount',
        'kind',
        'cate_id',
        'sub_cate_id',
        'in_home',
        'is_single',
        'have_gram',
        'gram',
        'have_kg',
        'kg',
        'have_pcs',
        'pcs',
        'have_liter',
        'liter',
        'have_ml',
        'ml',
        'descriptions',
        'key_features',
        'disclaimer',
        'exp_date',
        'type_of',
        'in_offer',
        'in_stoke',
        'rating',
        'total_rating',
        'variations',
        'size',
        'status',
        'extra_field'
    ];

    protected $hidden = [
        'updated_at',
        'created_at',
    ];

    protected $casts = [
        'kind' => 'integer',
        'in_home' => 'integer',
        'is_single' => 'integer',
        'have_gram' => 'integer',
        'have_kg' => 'integer',
        'have_pcs' => 'integer',
        'have_liter' => 'integer',
        'have_ml' => 'integer',
        'type_of' => 'integer',
        'in_offer' => 'integer',
        'in_stoke' => 'integer',
        'size' => 'integer',
        'status' => 'integer',
        'rating' => 'decimal:2',
    ];
}
