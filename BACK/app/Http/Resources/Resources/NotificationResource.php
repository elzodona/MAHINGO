<?php

namespace App\Http\Resources\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class NotificationResource extends JsonResource
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
            'titre' => $this->titre,
            'description' => $this->description,
            'dateEvent' => $this->dateEvent,
            'heureDebut' => $this->heureDebut,
            'heureFin' => $this->heureFin,
            'heureNotif' => $this->heureNotif,
            'user' => $this->user,
            'animal' => $this->animal,
        ];
    }

}
