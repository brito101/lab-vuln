<?php

namespace App\Http\Requests\Admin;

use Illuminate\Foundation\Http\FormRequest;

class AcademicRequest extends FormRequest
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
            'name' => 'required|min:3|max:100',
            'scholarity_id' => 'required|max:1',
            'course_id' => 'required|max:1',
            'institution' => 'required|min:3|max:100',
            'city' => 'required|min:3|max:100',
            'state' => 'required|min:2|max:100',
            'year' => 'required|min:4|max:100',
            'time' => 'required|min:3|max:100',
            'graduation' => 'required|date_format:d/m/Y|min:6|max:10',
            'availability' => 'required|min:3|max:100'
        ];
    }
}
