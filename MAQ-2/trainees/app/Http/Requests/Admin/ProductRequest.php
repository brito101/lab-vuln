<?php

namespace App\Http\Requests\Admin;

use Illuminate\Foundation\Http\FormRequest;

class ProductRequest extends FormRequest
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
            'price' => str_replace(',', '.', str_replace('.', '', str_replace('R$ ', '', $this->price)))
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
            'name' => 'required|min:1max:191',
            'description' => 'required|min:1max:6500',
            'price_id' => 'required|min:1max:191',
            'price'  => 'required|numeric|between:0,999999999.99',
        ];
    }

    public function messages()
    {
        return [
            'price.between' => 'O campo leitura deve ser entre 0 e 999.999.999,99.'
        ];
    }
}
