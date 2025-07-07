<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\DocumentTrayneeRequest;
use App\Models\Document;
use App\Models\DocumentStatus;
use App\Models\Evaluation;
use App\Models\Vacancy;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Storage;
use Zip;
use Illuminate\Support\Str;

class DocumentTraineeController extends Controller
{
    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function edit()
    {
        if (!Auth::user()->hasPermissionTo('Enviar Documentos Comprobatórios')) {
            abort(403, 'Acesso não autorizado');
        }
        $document = Document::where('user_id', Auth::user()->id)->first();
        return view('admin.documents.edit', compact('document'));
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(DocumentTrayneeRequest $request)
    {
        if (!Auth::user()->hasPermissionTo('Enviar Documentos Comprobatórios')) {
            abort(403, 'Acesso não autorizado');
        }

        $document = Document::where('user_id', Auth::user()->id)->first();

        $data = $request->all();
        $data['user_id'] = Auth::user()->id;

        $listDocument = [
            'document_person',
            'document_registry',
            'registration',
            'historic',
            'declaration',
            'residence'
        ];

        foreach ($listDocument as $doc) {

            if ($request->hasFile($doc) && $request->file($doc)->isValid()) {
                $name = $doc . time();

                if ($document) {
                    $documentPersonPath = storage_path() . '/app/public/documents/' . $document->$doc;
                    if (File::isFile($documentPersonPath)) {
                        unlink($documentPersonPath);
                    }
                }

                $extension = $request->$doc->extension();
                $nameFile = "{$name}.{$extension}";

                $data[$doc] = $nameFile;

                $upload = $request->$doc->storeAs('documents', $nameFile);

                if (!$upload)
                    return redirect()
                        ->back()
                        ->withInput()
                        ->with('error', 'Falha ao fazer o upload do arquivo');
            }
        }

        if ($document) {
            $save = $document->update($data);
        } else {
            $save = Document::create($data);
        }

        if ($save) {
            return redirect()
                ->route('admin.documents.edit')
                ->with('success', 'Envio realizado!');
        } else {
            return redirect()
                ->back()
                ->withInput()
                ->with('error', 'Erro ao Enviar!');
        }
    }

    public function show($id)
    {
        if (!Auth::user()->hasRole('Franquiado')) {
            abort(403, 'Acesso não autorizado');
        }
        $document = Document::where('user_id', $id)->first();
        return view('admin.documents.show', compact('document'));
    }

    public function companyDocument()
    {
        if (!Auth::user()->hasPermissionTo('Gerenciar Documentos Comprobatórios')) {
            abort(403, 'Acesso não autorizado');
        }

        $vacancies = Vacancy::where('company_id', Auth::user()->company_id)->pluck('id');
        $evaluations = Evaluation::whereIn('vacancy_id', $vacancies)->pluck('trainee');
        $documents = Document::whereIn('user_id', $evaluations)->get();

        return view('admin.compatibility.documents', compact('documents'));
    }

    public function downloadDocument($id)
    {
        if (!Auth::user()->hasPermissionTo('Gerenciar Documentos Comprobatórios')) {
            abort(403, 'Acesso não autorizado');
        }

        $document = Document::where('id', $id)->first();
        if (empty($document->id)) {
            abort(403, 'Acesso não autorizado');
        }

        $document_person = storage_path() . '/app/public/documents/' . $document->document_person;
        $document_registry = storage_path() . '/app/public/documents/' . $document->document_registry;
        $registration = storage_path() . '/app/public/documents/' . $document->registration;
        $historic  = storage_path() . '/app/public/documents/' . $document->historic;
        $declaration  = storage_path() . '/app/public/documents/' . $document->declaration;
        $residence  = storage_path() . '/app/public/documents/' . $document->residence;

        $nameFile = Str::slug($document->user->name);
        $zip = Zip::create('documentos-' . $nameFile . '.zip')
            ->add($document_person)
            ->add($document_registry)
            ->add($registration)
            ->add($historic)
            ->add($declaration)
            ->add($residence);

        return $zip;
    }

    public function approveDocument($id)
    {
        if (!Auth::user()->hasPermissionTo('Gerenciar Documentos Comprobatórios')) {
            abort(403, 'Acesso não autorizado');
        }

        $document = Document::where('id', $id)->first();
        if (empty($document->id)) {
            abort(403, 'Acesso não autorizado');
        }

        $documentStatus = DocumentStatus::where('document_id', $document->id)->where('company_id', Auth::user()->company_id)->first();

        $data = [
            'document_id' => $document->id,
            'status' => 'Aprovado',
            'company_id' => Auth::user()->company_id,
        ];

        if (empty($documentStatus->id)) {
            $newDocumentStatus = DocumentStatus::create($data);
        } else {
            $documentStatus->update($data);
        }

        return redirect()
            ->back()
            ->with('success', 'Status alterado para "Aprovado"!');
    }

    public function failDocument($id)
    {
        if (!Auth::user()->hasPermissionTo('Gerenciar Documentos Comprobatórios')) {
            abort(403, 'Acesso não autorizado');
        }

        $document = Document::where('id', $id)->first();
        if (empty($document->id)) {
            abort(403, 'Acesso não autorizado');
        }

        $documentStatus = DocumentStatus::where('document_id', $document->id)->where('company_id', Auth::user()->company_id)->first();

        $data = [
            'document_id' => $document->id,
            'status' => 'Reprovado',
            'company_id' => Auth::user()->company_id,
        ];

        if (empty($documentStatus->id)) {
            $newDocumentStatus = DocumentStatus::create($data);
        } else {
            $documentStatus->update($data);
        }

        return redirect()
            ->back()
            ->with('success', 'Status alterado para "Reprovado"!');
    }

    public function waitingDocument($id)
    {
        if (!Auth::user()->hasPermissionTo('Gerenciar Documentos Comprobatórios')) {
            abort(403, 'Acesso não autorizado');
        }

        $document = Document::where('id', $id)->first();
        if (empty($document->id)) {
            abort(403, 'Acesso não autorizado');
        }

        $documentStatus = DocumentStatus::where('document_id', $document->id)->where('company_id', Auth::user()->company_id)->first();

        $data = [
            'document_id' => $document->id,
            'status' => 'Aguardando',
            'company_id' => Auth::user()->company_id,
        ];

        if (empty($documentStatus->id)) {
            $newDocumentStatus = DocumentStatus::create($data);
        } else {
            $documentStatus->update($data);
        }

        return redirect()
            ->back()
            ->with('success', 'Status alterado para "Aguardando"!');
    }

    public function showStatus()
    {
        if (!Auth::user()->hasPermissionTo('Enviar Documentos Comprobatórios')) {
            abort(403, 'Acesso não autorizado');
        }

        $documents = Document::where('user_id', Auth::user()->id)->pluck('id');
        $documentsStatus = DocumentStatus::whereIn('id', $documents)->get();

        return view('admin.documents.index', compact('documentsStatus'));
    }
}
