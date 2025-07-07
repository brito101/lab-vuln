<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Facades\Auth;

class Document extends Model
{
    use HasFactory, SoftDeletes;

    protected $dates = ['deleted_at'];

    protected $fillable = [
        'document_person',
        'document_registry',
        'registration',
        'historic',
        'declaration',
        'residence',
        'user_id',
        'status',
        'company_id',
        'editor'
    ];

    /**Relationships */

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function documentStatus()
    {
        $status =  DocumentStatus::where('document_id', $this->id)->where('company_id', Auth::user()->company_id)->first();
        return $status->status;
    }


    /** Aux functions */
    public function links()
    {
        switch ($this->documentStatus()) {
            case 'Aguardando':
                return '
                <a class="btn btn-xs btn-default text-success mx-1 shadow" title="Aprovar" href="documents-trainees/approve/' . $this->id . '"><i class="fa fa-lg fa-fw fa-thumbs-up"></i></a>
                <a class="btn btn-xs btn-default text-danger mx-1 shadow" title="Reprovar" href="documents-trainees/fail/' . $this->id . '"><i class="fa fa-lg fa-fw fa-thumbs-down"></i></a>
                ';
            case 'Aprovado':
                return '
                    <a class="btn btn-xs btn-default text-secondary mx-1 shadow" title="Aguardando" href="documents-trainees/waiting/' . $this->id . '"><i class="fa fa-lg fa-fw fa-clock"></i></a>
                    <a class="btn btn-xs btn-default text-danger mx-1 shadow" title="Reprovar" href="documents-trainees/fail/' . $this->id . '"><i class="fa fa-lg fa-fw fa-thumbs-down"></i></a>
                    ';
            case 'Reprovado':
                return '
                    <a class="btn btn-xs btn-default text-success mx-1 shadow" title="Aprovar" href="documents-trainees/approve/' . $this->id . '"><i class="fa fa-lg fa-fw fa-thumbs-up"></i></a>
                    <a class="btn btn-xs btn-default text-secondary mx-1 shadow" title="Aguardando" href="documents-trainees/waiting/' . $this->id . '"><i class="fa fa-lg fa-fw fa-clock"></i></a>
                    ';
            default:
                return '
            <a class="btn btn-xs btn-default text-success mx-1 shadow" title="Aprovar" href="documents-trainees/approve/' . $this->id . '"><i class="fa fa-lg fa-fw fa-thumbs-up"></i></a>
            <a class="btn btn-xs btn-default text-secondary mx-1 shadow" title="Aguardando" href="documents-trainees/waiting/' . $this->id . '"><i class="fa fa-lg fa-fw fa-clock"></i></a>
            <a class="btn btn-xs btn-default text-danger mx-1 shadow" title="Reprovar" href="documents-trainees/fail/' . $this->id . '"><i class="fa fa-lg fa-fw fa-thumbs-down"></i></a>
            ';
        }
    }
}
