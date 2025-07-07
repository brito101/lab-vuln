<?php

namespace App\Http\Requests\Admin;

use Illuminate\Foundation\Http\FormRequest;

class VacancyRequest extends FormRequest
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
            'title' => 'required|max:100',
            'courses' => 'required|max:191',
            'scholarity_id' => 'required',
            'description' => 'required',
            'benefits' => 'nullable|max:100',
            'experience' => 'nullable|max:100',
            'period' => 'nullable|max:100',
            'requirements' => 'nullable|max:100',
            'neighborhood' => 'required|max:100',
            'state' => 'required|max:2',
            'city' => 'required|max:100',
            'brand_facebook' => 'image|mimes:jpg,png,jpeg,gif,svg,webp|max:1024|dimensions:max_width=1800,max_height=1800',
            'brand_instagram' => 'image|mimes:jpg,png,jpeg,gif,svg,webp|max:1024|dimensions:max_width=1800,max_height=1800',
            'brand_twitter' => 'image|mimes:jpg,png,jpeg,gif,svg,webp|max:1024|dimensions:max_width=1800,max_height=1800',
            'intended' => 'nullable|in:Estágio,Emprego,Estágio ou Emprego|min:3|max:100',
        ];
    }
}
