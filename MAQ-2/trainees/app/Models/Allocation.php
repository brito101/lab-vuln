<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Allocation extends Model
{
    use HasFactory, SoftDeletes;

    protected $dates = ['deleted_at'];

    protected $fillable = [
        'affiliation_id',
        'company_id',
        'university',
        'trainee',
        'editor',
        'init',
        'finish'
    ];

    /** Accessors */
    public function getInitAttribute($value)
    {
        return date("d/m/Y", strtotime($value));
    }

    public function getFinishAttribute($value)
    {
        return date("d/m/Y", strtotime($value));
    }

    /** Relationships */
    public function company()
    {
        return $this->belongsTo(Company::class);
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'trainee', 'id');
    }

    /** Aux */
    public function getUniversity()
    {
        $company = Company::where('id', $this->university)->first();
        return $company;
    }
}
