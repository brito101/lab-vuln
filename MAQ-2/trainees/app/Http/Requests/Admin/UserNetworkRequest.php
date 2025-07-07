<?php

namespace App\Http\Requests\Admin;

use Illuminate\Foundation\Http\FormRequest;

class UserNetworkRequest extends FormRequest
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
            'facebook' => 'nullable|url|max:150',
            'instagram' => 'nullable|url|max:150',
            'twitter' => 'nullable|url|max:150',
            'linkedin' => 'nullable|url|max:150',
            'youtube' => 'nullable|url|max:150',
            'whatsapp' => 'nullable|url|max:150',
            'telegram' => 'nullable|url|max:150',
            'discord' => 'nullable|nullable|url|max:150',
        ];
    }
}
