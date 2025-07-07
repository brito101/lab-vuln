<?php

namespace App\Http\Requests\Admin;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Support\Facades\Auth;

class UserRequest extends FormRequest
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
            'email' => "required|min:6|max:100|unique:users,email,{$this->id},id,deleted_at,NULL",
            'genre_id' => "nullable",
            'affiliation_id' => "nullable",
            'company_id' => "nullable",
            'password' => "max:100",
            'photo' => 'image|mimes:jpg,png,jpeg,gif,svg,webp|max:1024|dimensions:max_width=1800,max_height=1800',
            'scholarity_id' => "nullable",
            'telephone' => 'nullable|min:8|max:25',
            'cell' => 'nullable|min:8|max:25',
            'video' => 'nullable|url|max:150',
            'team_work' => "required_if:{Auth::user()->hasRole('Estagiário'),true}|min:2|max:100",
            'vehicle' => "required_if:{Auth::user()->hasRole('Estagiário'),true}|min:2|max:100",
        ];
    }
}
