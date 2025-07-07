<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\ReportRequest;
use App\Models\Company;
use App\Models\Report;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Str;

class ReportController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        if (!Auth::user()->hasAnyPermission(['Acessar Relatórios', 'Visualizar Relatórios'])) {
            abort(403, 'Acesso não autorizado');
        }

        if (Auth::user()->hasRole('Estagiário')) {
            $reports = Report::where('trainee', Auth::user()->id)->get();
        } elseif (Auth::user()->hasRole('Instituição de Ensino')) {
            $reports = Report::where('institution', Auth::user()->company_id)->get();
        } elseif (Auth::user()->hasRole('Empresário')) {
            $reports = Report::where('company_id', Auth::user()->company_id)->get();
        } else {
            $reports = Report::all();
        }

        return view('admin.reports.index', compact('reports'));
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        if (!Auth::user()->hasPermissionTo('Enviar Relatórios')) {
            abort(403, 'Acesso não autorizado');
        }

        if (Auth::user()->hasRole('Empresário')) {
            $companies = Company::where('id', Auth::user()->company_id)->get();
        } else {
            $companies = Company::where('institution', '!=', 'Sim')->get();
        }

        if (Auth::user()->hasRole('Instituição de Ensino')) {
            $institutions = Company::where('id', Auth::user()->company_id)->get();
        } else {
            $institutions = Company::where('institution', 'Sim')->get();
        }

        if (Auth::user()->hasRole('Estagiário')) {
            $trainees = User::where('id', Auth::user()->id)->get();
        } else {
            $trainees = User::role('Estagiário')->get();
        }

        return view('admin.reports.create', compact('companies', 'institutions', 'trainees'));
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(ReportRequest $request)
    {
        if (!Auth::user()->hasPermissionTo('Enviar Relatórios')) {
            abort(403, 'Acesso não autorizado');
        }

        $data = $request->all();
        $data['editor'] = Auth::user()->id;

        if ($request->hasFile('document') && $request->file('document')->isValid()) {
            $name = Str::slug(mb_substr($data['title'], 0, 100)) . time();
            $extenstion = $request->document->extension();
            $nameFile = "{$name}.{$extenstion}";
            $data['document'] = $nameFile;
            $upload = $request->document->storeAs('reports', $nameFile);

            if (!$upload) {
                return redirect()
                    ->back()
                    ->withInput()
                    ->with('error', 'Falha ao fazer o upload do arquivo');
            }
        }

        if (Auth::user()->hasRole('Empresário')) {
            $data['company_id'] = Auth::user()->company_id;
        }

        if (Auth::user()->hasRole('Instituição de Ensino')) {
            $data['institution'] = Auth::user()->company_id;
        }

        if (Auth::user()->hasRole('Estagiário')) {
            $data['trainee'] = Auth::user()->id;
        }

        $report = Report::create($data);

        if ($report->save()) {
            return redirect()
                ->route('admin.reports.index')
                ->with('success', 'Cadastro realizado!');
        } else {
            return redirect()
                ->back()
                ->withInput()
                ->with('error', 'Erro ao cadastrar!');
        }
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        if (!Auth::user()->hasPermissionTo('Enviar Relatórios')) {
            abort(403, 'Acesso não autorizado');
        }

        $report = Report::where('id', $id)->where('editor', Auth::user()->id)->first();
        if (empty($report->id)) {
            abort(403, 'Acesso não autorizado');
        }

        if (Auth::user()->hasRole('Empresário')) {
            $companies = Company::where('id', Auth::user()->company_id)->get();
        } else {
            $companies = Company::where('institution', '!=', 'Sim')->get();
        }

        if (Auth::user()->hasRole('Instituição de Ensino')) {
            $institutions = Company::where('id', Auth::user()->company_id)->get();
        } else {
            $institutions = Company::where('institution', 'Sim')->get();
        }

        if (Auth::user()->hasRole('Estagiário')) {
            $trainees = User::where('id', Auth::user()->id)->get();
        } else {
            $trainees = User::role('Estagiário')->get();
        }

        return view('admin.reports.edit', compact('report', 'companies', 'institutions', 'trainees'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(ReportRequest $request, $id)
    {
        if (!Auth::user()->hasPermissionTo('Enviar Relatórios')) {
            abort(403, 'Acesso não autorizado');
        }

        $report = Report::where('id', $id)->where('editor', Auth::user()->id)->first();
        if (empty($report->id)) {
            abort(403, 'Acesso não autorizado');
        }

        $data = $request->all();
        $data['editor'] = Auth::user()->id;

        if ($request->hasFile('document') && $request->file('document')->isValid()) {
            $name = Str::slug(mb_substr($data['title'], 0, 100)) . time();
            $documentPath = storage_path() . '/app/public/reports/' . $report->document;

            if (File::isFile($documentPath)) {
                unlink($documentPath);
            }

            $extenstion = $request->document->extension();
            $nameFile = "{$name}.{$extenstion}";
            $data['document'] = $nameFile;
            $upload = $request->document->storeAs('reports', $nameFile);

            if (!$upload) {
                return redirect()
                    ->back()
                    ->withInput()
                    ->with('error', 'Falha ao fazer o upload do arquivo');
            }
        }

        if (Auth::user()->hasRole('Empresário')) {
            $data['company_id'] = Auth::user()->company_id;
        }

        if (Auth::user()->hasRole('Instituição de Ensino')) {
            $data['institution'] = Auth::user()->company_id;
        }

        if (Auth::user()->hasRole('Estagiário')) {
            $data['trainee'] = Auth::user()->id;
        }

        if ($report->update($data)) {
            return redirect()
                ->route('admin.reports.index')
                ->with('success', 'Cadastro realizado!');
        } else {
            return redirect()
                ->back()
                ->withInput()
                ->with('error', 'Erro ao cadastrar!');
        }
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        if (!Auth::user()->hasPermissionTo('Enviar Relatórios')) {
            abort(403, 'Acesso não autorizado');
        }

        $report = Report::where('id', $id)->where('editor', Auth::user()->id)->first();
        if (empty($report->id)) {
            abort(403, 'Acesso não autorizado');
        }

        $documentPath = storage_path() . '/app/public/reports/' . $report->document;

        if ($report->delete()) {

            if (File::isFile($documentPath)) {
                unlink($documentPath);
            }

            return redirect()
                ->route('admin.reports.index')
                ->with('success', 'Exclusão realizada!');
        } else {
            return redirect()
                ->back()
                ->with('error', 'Erro ao excluir!');
        }
    }
}
