<?php

namespace App\Http\Resources\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class AnimalResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
            return [
                'id' => $this->id,
                'photo' =>$this->photo,
                'name'=>$this->name,
                'date_birth'=>$this->date_birth,
                'sexe'=>$this->sexe,
                'race'=>$this->race,
                'taille'=>$this->taille,
                'poids'=>$this->poids,
                'necklace_id'=> $this->necklace,
                'categorie_id'=>$this->category,
                'user_id' => $this->user
            ];

    }
}
