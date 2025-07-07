<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;

class Report extends Model
{
    use HasFactory, SoftDeletes;

    protected $dates = ['deleted_at'];

    protected $fillable = [
        'title',
        'type',
        'document',
        'company_id',
        'institution',
        'trainee',
        'editor',
    ];

    /** Relationships */
    public function company()
    {
        return $this->belongsTo(Company::class);
    }

    /** Aux */
    public function institutionName()
    {
        $isntitution = Company::where('id', $this->institution)->first();
        return $isntitution->alias_name ?? '';
    }

    public function traineeName()
    {
        $trainee = User::where('id', $this->trainee)->first();
        return $trainee->name ?? '';
    }

    public function editorName()
    {
        $editor = User::where('id', $this->editor)->first();
        return $editor->name ?? '';
    }

    public function link()
    {
        $link = Storage::url('reports/' . $this->document);
        if ($this->editor == Auth::user()->id) {
            return '<a class="btn btn-xs btn-default text-primary mx-1 shadow" title="Download" href="' .  $link . '" target="_blank" download><i class="fa fa-lg fa-fw fa-download"></i></a>' . '<a class="btn btn-xs btn-default text-primary mx-1 shadow" title="Editar" href="reports/' . $this->id . '/edit"><i class="fa fa-lg fa-fw fa-pen"></i></a>' . '<a class="btn btn-xs btn-default text-danger mx-1 shadow" title="Excluir" href="reports/destroy/' . $this->id . '" onclick="return confirm(\'Confirma a exclusão deste relatório?\')"><i class="fa fa-lg fa-fw fa-trash"></i></a>';
        } else {
            return '<a class="btn btn-xs btn-default text-primary mx-1 shadow" title="Download" href="' .  $link . '" target="_blank" download><i class="fa fa-lg fa-fw fa-download"></i></a>';
        }
    }
}
