<?php

namespace App\Http\Requests\Admin;

use Illuminate\Foundation\Http\FormRequest;

class ProfessionalRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        return [
            'company' => 'required|min:2|max:100',
            'role' => 'required|min:2|max:100',
            'start' => 'required|date_format:d/m/Y|min:6|max:10',
            'end' => 'nullable|date_format:d/m/Y|min:6|max:10',
            'contract' => 'required|min:2|max:100',
            'activities' => 'required|min:2|max:1500',
        ];
    }
}
