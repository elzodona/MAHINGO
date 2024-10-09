<?php

namespace App\Models;

use App\Models\Necklace;
use App\Models\Categorie;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Animal extends Model
{
    use HasFactory, SoftDeletes;

    protected $guarded = ['id'];

    protected $hidden  = [
        'created_at',
        'updated_at',
        'deleted_at'
    ];

    public function category()
    {
        return $this->belongsTo(Categorie::class, 'categorie_id');
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function necklace()
    {
        return $this->belongsTo(Necklace::class, 'necklace_id');
    }

    public function event()
    {
        return $this->hasMany(Event::class);
    }

}
