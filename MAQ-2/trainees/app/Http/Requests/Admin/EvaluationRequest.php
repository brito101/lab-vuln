<?php

namespace App\Http\Requests\Admin;

use Illuminate\Foundation\Http\FormRequest;

class EvaluationRequest extends FormRequest
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
            'trainee' => 'required',
            'vacancy_id' => 'required',
            'status' => 'nullable|in:Aguardando,Liberado,Em análise,Em contratação,Contratado,Contrato concluído,Contrato cancelado,Incompatível|max:100'
        ];
    }
}
