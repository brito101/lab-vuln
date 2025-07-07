<?php

namespace App\Http\Requests\Admin;

use Illuminate\Foundation\Http\FormRequest;

class DocumentRequest extends FormRequest
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
            'birth' => 'required|date_format:d/m/Y|min:6|max:10',
            'first_parent' => 'nullable|max:150',
            'second_parent' => 'nullable|max:150',
            'civil_status' => 'nullable|max:150',
            'children' => 'nullable|max:150',
            'nationality' => 'nullable|max:150',
            'document_person' => "required|min:11|max:20|unique:users,document_person,{$this->id},id,deleted_at,NULL",
            'document_registry' => "required|min:5|max:20",
            'issuer' => 'required|min:2|max:150',
            'date_issue' => 'required|date_format:d/m/Y|min:6|max:10',
            'work_card' => 'nullable|max:50',
            'serie' => 'nullable|max:50',
        ];
    }
}
