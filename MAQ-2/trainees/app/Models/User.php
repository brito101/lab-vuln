<?php

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use Spatie\Permission\Traits\HasRoles;
use Shetabit\Visitor\Traits\Visitor;
use Laravel\Cashier\Billable;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable, HasRoles, Visitor, SoftDeletes, Billable;

    protected $dates = ['deleted_at'];

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'name',
        'email',
        'password',
        'genre_id',
        'affiliation_id',
        'company_id',
        'photo',
        'scholarity_id',
        'telephone',
        'cell',
        /** documents */
        'birth',
        'first_parent',
        'second_parent',
        'civil_status',
        'children',
        'nationality',
        'document_person',
        'document_registry',
        'issuer',
        'date_issue',
        'work_card',
        'serie',
        /** address */
        'zipcode',
        'street',
        'number',
        'complement',
        'neighborhood',
        'state',
        'city',
        /** social networks */
        'facebook',
        'instagram',
        'twitter',
        'linkedin',
        'youtube',
        'whatsapp',
        'telegram',
        'discord',
        'document_person',
        'document_registry',
        'issuer',
        'date_issue',
        'work_card',
        'serie',
        'video',
        'team_work',
        'vehicle',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
    ];

    /** Relationships */
    public function genre()
    {
        return $this->belongsTo(Genre::class)->withDefault([
            'name' => 'Não Informado',
        ]);
    }

    public function affiliation()
    {
        return $this->belongsTo(Affiliation::class);
    }

    public function company()
    {
        return $this->belongsTo(Company::class);
    }

    public function scholarity()
    {
        return $this->belongsTo(Scholarity::class);
    }

    public function posts()
    {
        return $this->hasMany(Post::class);
    }

    public function vacancies()
    {
        return $this->hasMany(Post::class);
    }

    public function academics()
    {
        return $this->hasMany(Academic::class);
    }

    public function extra()
    {
        return $this->hasMany(Extra::class);
    }

    public function composing()
    {
        return $this->hasOne(Composing::class);
    }

    public function requiriment()
    {
        return $this->hasMany(Requiriment::class);
    }

    public function professional()
    {
        return $this->hasMany(Professional::class);
    }

    public function evaluations()
    {
        return $this->hasMany(Evaluation::class, 'trainee');
    }


    /** Aux */
    public function age()
    {
        if ($this->attributes['birth']) {
            return Carbon::parse(Carbon::createFromFormat('d/m/Y', $this->attributes['birth'])->format('Y-m-d'))->age . ' anos';
        } else {
            return 'Idade não informada';
        }
    }

    public function compatibility(Vacancy $vacancy)
    {
        $listAcadmics = [];
        $academics = Academic::where('user_id', $this->id)->get();
        foreach ($academics as $academic) {
            $listAcadmics['area'] = $academic->course['name'];
        }

        $listExtraCourses = [];
        $extras = Extra::where('user_id', $this->id)->get();
        foreach ($extras as $extra) {
            $listExtraCourses['area'] = $extra->course['name'];
        }

        $points = 0;
        /** curso acadêmicos */
        foreach (array_values($listAcadmics) as $val) {
            if (strpos($vacancy->courses, $val) !== false) {
                $points += 1;
            }
        }

        /** curso extracurricular */
        foreach (array_values($listExtraCourses) as $val) {
            if (strpos($vacancy->courses, $val) !== false) {
                $points += 1;
            }
        }

        /** escolaridade */
        if (strpos(implode(", ", array_values($this->academics->pluck('scholarity_id')->toArray())), (string)$vacancy->scholarity_id) !== false) {
            $points += 1;
        }

        /** disponibilidade */
        if (strpos(implode(", ", array_values($this->academics->pluck('availability')->toArray())), $vacancy->period) !== false) {
            $points += 1;
        }

        /** estado */
        if ($vacancy->state == $this->state) {
            $points  += 0.5;
        }

        /** cidade e estado */
        if ($vacancy->city == $this->city) {
            $points  += 0.5;
        }

        return $points * 20 . "%";
    }
}
