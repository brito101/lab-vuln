<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class University extends Model
{
    use HasFactory, SoftDeletes;

    protected $dates = ['deleted_at'];

    protected $fillable = [
        'name',
        'level',
        'scholarity_id',
        'course_id',
        'company_id',
        'user_id',
        'advisor'
    ];

    /** Relationships */
    public function company()
    {
        return $this->belongsTo(Company::class);
    }

    public function scholarity()
    {
        return $this->belongsTo(Scholarity::class);
    }

    public function course()
    {
        return $this->belongsTo(Course::class);
    }
}
