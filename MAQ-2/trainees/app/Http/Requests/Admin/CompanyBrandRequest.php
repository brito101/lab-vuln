<?php

namespace App\Http\Requests\Admin;

use Illuminate\Foundation\Http\FormRequest;

class CompanyBrandRequest extends FormRequest
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
            'resume' => 'nullable',
            'facebook' => 'nullable|url|max:150',
            'instagram' => 'nullable|url|max:150',
            'twitter' => 'nullable|url|max:150',
            'linkedin' => 'nullable|url|max:150',
            'youtube' => 'nullable|url|max:150',
            'whatsapp' => 'nullable|url|max:150',
            'telegram' => 'nullable|url|max:150',
            'discord' => 'nullable|nullable|url|max:150',
            'brand_facebook' => 'image|mimes:jpg,png,jpeg,gif,svg,webp|max:1024|dimensions:max_width=1800,max_height=1800',
            'brand_instagram' => 'image|mimes:jpg,png,jpeg,gif,svg,webp|max:1024|dimensions:max_width=1800,max_height=1800',
            'brand_twitter' => 'image|mimes:jpg,png,jpeg,gif,svg,webp|max:1024|dimensions:max_width=1800,max_height=1800'
        ];
    }
}
