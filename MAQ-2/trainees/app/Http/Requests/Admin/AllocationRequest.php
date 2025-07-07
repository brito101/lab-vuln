<?php

namespace App\Http\Requests\Admin;

use Carbon\Carbon;
use Illuminate\Foundation\Http\FormRequest;

class AllocationRequest extends FormRequest
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
            'init' => Carbon::createFromFormat('d/m/Y', $this->init)->format('Y-m-d'),
            'finish' => Carbon::createFromFormat('d/m/Y', $this->finish)->format('Y-m-d')
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
            'company_id' => 'required|min:1',
            'university' => 'required|min:1',
            'trainee' => 'required|min:1',
            'init' => 'required|date_format:Y-m-d',
            'finish' => 'nullable|date_format:Y-m-d',
        ];
    }
}
