<?php

namespace App\Http\Resources\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class NecklaceResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id'=>$this->id,
            'identifier' => $this->identifier,
            'photo' => $this->photo,
            'enabled_at' =>$this->enabled_at,
            'desabled_at' => $this->desabled_at,
            'battery' => $this->battery,
            'position' => $this->position,
            'temperature' => $this->temperature,
            'heart_rate' => $this->heart_rate,
            'localisation' => $this->localisation,
            'etat' => $this->etat,
            'user_id'=> $this->user,
            'animal'=>$this->animal
        ];
    }
}
