<?php

namespace App\Models;

use App\Models\User;
use App\Models\Animal;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Necklace extends Model
{
    use HasFactory, SoftDeletes;

    protected $guarded = ['id'];
    
    protected $hidden  = [
        'created_at',
        'updated_at',
        'deleted_at'
    ];


    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    
    public function animal()
    {
        return $this->hasOne(Animal::class);
    }
}
