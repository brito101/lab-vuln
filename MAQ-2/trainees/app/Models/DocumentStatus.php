<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class DocumentStatus extends Model
{
    use HasFactory, SoftDeletes;

    protected $dates = ['deleted_at'];

    protected $table = 'documents_status';

    protected $fillable = ['status', 'document_id', 'company_id'];

    /** Relationships */

    public function document()
    {
        return $this->belongsTo(Document::class);
    }

    public function company()
    {
        return $this->belongsTo(Company::class);
    }
}
