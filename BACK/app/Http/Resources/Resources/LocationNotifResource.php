<?php

namespace App\Http\Resources\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class LocationNotifResource extends JsonResource
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
            'altitude' => $this->altitude,
            'longitude' => $this->longitude,
            'heureNotif' => $this->heureNotif,
            'user' => $this->user,
            'animal' => $this->animal,
        ];
    }
}
