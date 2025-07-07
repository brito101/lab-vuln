<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Company extends Model
{
    use HasFactory, SoftDeletes;

    protected $dates = ['deleted_at'];

    protected $fillable = [
        'user_id',
        'social_name',
        'alias_name',
        'document_company',
        'document_company_secondary',
        'email',
        'telephone',
        'cell',
        'zipcode',
        'street',
        'number',
        'complement',
        'neighborhood',
        'state',
        'city',
        'logo',
        'resume',
        'facebook',
        'instagram',
        'twitter',
        'linkedin',
        'youtube',
        'whatsapp',
        'telegram',
        'discord',
        'brand_facebook',
        'brand_instagram',
        'brand_twitter',
        'affiliation_id',
        'institution'
    ];

    public function vacancy()
    {
        return $this->hasMany(Vacancy::class);
    }
}
