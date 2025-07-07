<?php

namespace App\Http\Requests\Admin;

use App\Models\Document;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Support\Facades\Auth;

class DocumentTrayneeRequest extends FormRequest
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
        $document = Document::where('user_id', Auth::user()->id)->first();

        if ($document) {
            return [
                'document_person' => "required_if:{$document->document_person},null|mimes:jpg,png,jpeg,svg,pdf|max:1024",
                'document_registry' => "required_if:{$document->document_registry},null|mimes:jpg,png,jpeg,svg,pdf|max:1024",
                'registration' => "required_if:{$document->registration},null|mimes:jpg,png,jpeg,svg,pdf|max:1024",
                'historic' => "required_if:{$document->historic},null|mimes:jpg,png,jpeg,svg,pdf|max:1024',
                'declaration' => 'required_if:{$document->declaration},null|mimes:jpg,png,jpeg,svg,pdf|max:1024",
                'residence' => "required_if:{$document->residence},null|mimes:jpg,png,jpeg,svg,pdf|max:1024",
            ];
        } else {
            return [
                'document_person' => "required|mimes:jpg,png,jpeg,svg,pdf|max:1024",
                'document_registry' => "required|mimes:jpg,png,jpeg,svg,pdf|max:1024",
                'registration' => "required|mimes:jpg,png,jpeg,svg,pdf|max:1024",
                'historic' => "required|mimes:jpg,png,jpeg,svg,pdf|max:1024',
                'declaration' => 'required|mimes:jpg,png,jpeg,svg,pdf|max:1024",
                'residence' => "required|mimes:jpg,png,jpeg,svg,pdf|max:1024",
            ];
        }
    }
}
