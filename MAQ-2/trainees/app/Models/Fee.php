<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Facades\Auth;

class Fee extends Model
{
    use HasFactory, SoftDeletes;

    protected $dates = ['deleted_at'];

    protected $fillable = [
        'role',
        'salary',
        'benefits',
        'company_id',
        'editor'
    ];

    /** Relationships */
    public function company()
    {
        return $this->belongsTo(Company::class);
    }

    /** Accessor */
    public function getSalaryAttribute($value)
    {
        return 'R$ ' . number_format($value, 2, ",", ".");
    }

    /** Aux */
    public function links()
    {
        if (Auth::user()->company_id == $this->company_id) {
            return '<a class="btn btn-xs btn-default text-primary mx-1 shadow" title="Editar" href="salary-list/' . $this->id . '/edit"><i class="fa fa-lg fa-fw fa-pen"></i></a>' . '<a class="btn btn-xs btn-default text-danger mx-1 shadow" title="Excluir" href="salary-list/destroy/' . $this->id . '" onclick="return confirm(\'Confirma a exclusão deste item?\')"><i class="fa fa-lg fa-fw fa-trash"></i></a>';
        } else {
            return '<i class="fa fa-lg fa-fw fa-ban">';
        }
    }
}
