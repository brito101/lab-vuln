<?php

namespace App\Http\Requests\Admin;

use Illuminate\Foundation\Http\FormRequest;

class TermRequest extends FormRequest
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
            'title' => 'required|min:1|max:191',
            'type' => 'required|min:1|max:191',
            'participant_primary' => 'required|min:1|max:191',
            'participant_secondary' => 'required|min:1|max:191',
            'content' => 'required|max:409600',
        ];
    }
}
