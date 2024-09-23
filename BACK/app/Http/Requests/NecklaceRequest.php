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
            'identifier' => $neckLaceId ? 'nullable|string|max:255' : 'required|string|max:255',
            'photo' => 'nullable|string',
            'enabled_at' => 'nullable|date_format:Y/m/d',
            'desabled_at' => 'nullable|date_format:Y/m/d',
            'battery' => 'nullable|numeric',
            'position' => 'nullable|string',
            'temperature' => 'nullable|numeric',
            'heart_rate' => 'nullable|numeric',
            'localisation' => 'nullable|string',
            'etat' => 'nullable|string',
            'user_id' => 'nullable|exists:users,id',
        ];
    }

}
