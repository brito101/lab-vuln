<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\AllocationRequest;
use App\Models\Allocation;
use App\Models\Company;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class AllocationController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        if (!Auth::user()->hasPermissionTo('Listar Alocações')) {
            abort(403, 'Acesso não autorizado');
        }
        $companies = Company::where('affiliation_id', Auth::user()->affiliation_id)->pluck('id');
        $allocations = Allocation::whereIn('company_id', $companies)->get();
        return view('admin.allocations.index', compact('allocations'));
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        if (!Auth::user()->hasPermissionTo('Criar Alocações')) {
            abort(403, 'Acesso não autorizado');
        }

        $allocations = Allocation::all()->pluck('trainee');
        $companies = Company::where('affiliation_id', Auth::user()->affiliation_id)
            ->where('institution', 'Não')
            ->get();
        $institutions = Company::where('affiliation_id', Auth::user()->affiliation_id)
            ->where('institution', 'Sim')
            ->get();
        $trainees =  User::role('Estagiário')->whereNotIn('id', $allocations)->orderBy('created_at', 'desc')->get();

        return view('admin.allocations.create', compact('companies', 'trainees', 'institutions'));
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(AllocationRequest $request)
    {
        if (!Auth::user()->hasPermissionTo('Criar Alocações')) {
            abort(403, 'Acesso não autorizado');
        }

        $data = $request->all();
        $data['editor'] = Auth::user()->id;
        $allocation = Allocation::create($data);

        if ($allocation->save()) {
            return redirect()
                ->route('admin.allocations.index')
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
        if (!Auth::user()->hasPermissionTo('Editar Alocações')) {
            abort(403, 'Acesso não autorizado');
        }

        $companies = Company::where('affiliation_id', Auth::user()->affiliation_id)
            ->where('institution', 'Não')
            ->get();
        $institutions = Company::where('affiliation_id', Auth::user()->affiliation_id)
            ->where('institution', 'Sim')
            ->get();
        $allocation = Allocation::where('id', $id)->where('company_id', $companies->pluck('id'))->first();
        if (empty($allocation->id)) {
            abort(403, 'Acesso não autorizado');
        }
        return view('admin.allocations.edit', compact('allocation', 'companies', 'institutions'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(AllocationRequest $request, $id)
    {
        if (!Auth::user()->hasPermissionTo('Editar Alocações')) {
            abort(403, 'Acesso não autorizado');
        }

        $data = $request->all();
        $data['editor'] = Auth::user()->id;

        $companies = Company::where('affiliation_id', Auth::user()->affiliation_id)->get();
        $allocation = Allocation::where('id', $id)->where('company_id', $companies->pluck('id'))->first();

        if (empty($allocation->id)) {
            abort(403, 'Acesso não autorizado');
        }

        if ($allocation->update($data)) {
            return redirect()
                ->route('admin.allocations.index')
                ->with('success', 'Atualização realizada!');
        } else {
            return redirect()
                ->back()
                ->withInput()
                ->with('error', 'Erro ao atualizar!');
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
        if (!Auth::user()->hasPermissionTo('Excluir Alocações')) {
            abort(403, 'Acesso não autorizado');
        }

        $companies = Company::where('affiliation_id', Auth::user()->affiliation_id)
            ->where('institution', 'Não')
            ->get();
        $allocation = Allocation::where('id', $id)->where('company_id', $companies->pluck('id'))->first();

        if (empty($allocation->id)) {
            abort(403, 'Acesso não autorizado');
        }

        if ($allocation->delete()) {
            return redirect()
                ->route('admin.allocations.index')
                ->with('success', 'Exclusão realizada!');
        } else {
            return redirect()
                ->back()
                ->with('error', 'Erro ao excluir!');
        }
    }
}
