<?php

namespace App\Http\Resources\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class HealthNotifResource extends JsonResource
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
            'etat' => $this->etat,
            'dateSave' => $this->dateSave,
            'type' => $this->type,
            'valeur' => $this->valeur,
            'heureNotif' => $this->heureNotif,
            'user' => $this->user,
            'animal' => $this->animal,
        ];
    }

}
