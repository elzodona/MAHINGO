<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class NecklaceRequest extends FormRequest
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
        $neckLaceId = $this->route('id');
        return [
            'identifier'=> $neckLaceId ? 'nullable':'required|string|max:255',
            'photo'=>$neckLaceId ? 'nullable':'required|string',
            'enabled_at'=>$neckLaceId ? 'nullable': 'required|date_format:Y/m/d',
            'desabled_at'=>$neckLaceId ? 'nullable': 'required|date_format:Y/m/d',
            'battery'=>'nullable',
            'position'=>'nullable',
            'temperature'=>'nullable',
            'heart_rate'=>'nullable',
            'localisation'=>'nullable',
            'etat'=>'nullable',
            'user_id'=> $neckLaceId ? 'nullable':'required'
        ];
    }
}
