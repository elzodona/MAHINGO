<?php

namespace App\Http\Resources\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class UserResource extends JsonResource
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
            'first_name' => $this->first_name,
            'last_name' => $this->last_name,
            'telephone' =>$this->telephone,
            'address' => $this->address,
            'profession' => $this->profession,
            'email' => $this->email,
            'photo' => $this->photo,
            'necklaces'=>$this->necklaces ? $this->necklaces : null
        ];
    }
}
