<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UserRequest extends FormRequest
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
        $userId = $this->route('id'); 
        return [
            'first_name' => $userId ?  'nullable': 'required|string|max:255',
            'last_name' => $userId ? 'nullable':'required|string|max:255',
            'telephone' => $userId ?'nullable': 'required|string|max:20',
            'address' => 'nullable|string',
            'profession' => 'nullable|string|max:255',
            'email' => $userId ? 'email|unique:users,email':'required|email|unique:users,email',
            'password' => $userId ? 'nullable|string|min:8' : 'required|string|min:8',
            'photo' => 'nullable',
        ];
    }
}
