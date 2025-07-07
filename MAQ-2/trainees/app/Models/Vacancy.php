<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Facades\Auth;

class Vacancy extends Model
{
    use HasFactory, SoftDeletes;

    protected $dates = ['deleted_at'];

    protected $fillable = [
        'title',
        'slug',
        'courses',
        'scholarity_id',
        'description',
        'benefits',
        'experience',
        'period',
        'requirements',
        'neighborhood',
        'state',
        'city',
        'brand_facebook',
        'brand_instagram',
        'brand_twitter',
        'company_id',
        'user_id',
        'views',
        'intended'
    ];

    /** Relationships */
    public function user()
    {
        return $this->belongsTo(User::class)->withDefault([
            'name' => 'Anônimo',
        ]);
    }

    public function company()
    {
        return $this->belongsTo(Company::class);
    }

    public function scholarity()
    {
        return $this->belongsTo(Scholarity::class);
    }

    public function candidate()
    {
        return $this->hasMany(Candidate::class);
    }

    /** Aux */
    public function trainee()
    {
        $candidate = Candidate::where('vacancy_id', $this->id)
            ->where('user_id', Auth::user()->id)->first();
        if ($candidate) {
            return '<i data-vacancy="cancel" data-id="' . $this->id . '" class="text-success fa fa-lg fa-thumbs-up candidate" style="cursor: pointer" title="Clique para cancelar a candidatura"></i>';
        } else {
            return '<i data-vacancy="candidate" data-id="' . $this->id . '" class="text-danger fa fa-lg fa-thumbs-down candidate" style="cursor: pointer" title="Clique para se candidatar"></i>';
        }
    }

    public function courses()
    {
        $courses = $this->courses;
        $courses_arr = explode(',', $courses);
        if (count($courses_arr) > 1) {
            $last = array_pop($courses_arr);
            $courses = implode(',', $courses_arr) . ' e' . $last;
            return $courses;
        } else {
            $last = array_pop($courses_arr);
            $courses = implode(',', $courses_arr) . $last;
            return $courses;
        }
    }

    public function coursesId()
    {
        $courses = $this->courses;
        $courses_arr = explode(',', $courses);
        $list = [];
        if (count($courses_arr) > 1) {
            foreach ($courses_arr as $item) {
                $course = Course::where('name', ltrim($item))->first();
                if ($course) {
                    $list[] = $course->id;
                }
            }
        }
        return $list;
    }
}
