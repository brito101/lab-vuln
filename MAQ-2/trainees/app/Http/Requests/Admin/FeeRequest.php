<?php

namespace App\Http\Requests\Admin;

use Illuminate\Foundation\Http\FormRequest;

class FeeRequest extends FormRequest
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

    protected function prepareForValidation()
    {
        $this->merge([
            'salary' =>  str_replace(',', '.', str_replace(['.', 'R$'], '', trim($this->salary)))
        ]);
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        return [
            'role' => 'required|min:1|max:191',
            'salary' => 'required|numeric|between:0,99999999.99',
            'benefits' => 'nullable|max:1500'
        ];
    }

    public function messages()
    {
        return [
            'salary.between' => 'O campo salário deve ser entre 0 e R$ 999.999.999,99'
        ];
    }
}
