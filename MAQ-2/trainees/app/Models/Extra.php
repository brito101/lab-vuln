<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Extra extends Model
{
    use HasFactory, SoftDeletes;

    protected $dates = ['deleted_at'];

    protected $fillable = [
        'name',
        'institution',
        'level',
        'course_id',
        'user_id'
    ];

    /** Relationships */
    public function course()
    {
        return $this->belongsTo(Course::class);
    }
}
