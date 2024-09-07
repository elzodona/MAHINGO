<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class AnimalRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        $animalId = $this->route('id'); 
        return [
            'photo' =>$animalId ?'nullable':'required',
            'name'=>$animalId ?'nullable':'required',
            'date_birth'=>$animalId ?'nullable':'required',
            'sexe'=>$animalId ?'nullable':'required',
            'race'=>$animalId ?'nullable':'required',
            'height'=>$animalId ?'nullable':'required',
            'weight'=>$animalId ?'nullable':'required',
            'necklace_id'=> $animalId ? 'nullable|exists:necklaces,id':'required|exists:necklaces,id|unique:necklaces,id',
            'categorie_id'=>$animalId ?'nullable|exists:categories,id':'required|exists:categories,id'
        ];
    }
}
