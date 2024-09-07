<?php

namespace App\Models;

use App\Models\Animal;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Categorie extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = ['libelle'];
    
    protected $hidden  = [
        'created_at',
        'updated_at',
        'deleted_at'
    ];

    public function animals()
    {
        return $this->hasMany(Animal::class);
    }
}
