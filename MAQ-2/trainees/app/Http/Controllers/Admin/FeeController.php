<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\FeeRequest;
use App\Models\Fee;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class FeeController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        if (!Auth::user()->hasPermissionTo('Listar Pesquisa Salarial')) {
            abort(403, 'Acesso não autorizado');
        }
        $fees = Fee::all();
        return view('admin.fees.index', compact('fees'));
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        if (!Auth::user()->hasPermissionTo('Criar Pesquisa Salarial')) {
            abort(403, 'Acesso não autorizado');
        }
        return view('admin.fees.create');
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(FeeRequest $request)
    {
        if (!Auth::user()->hasPermissionTo('Criar Pesquisa Salarial')) {
            abort(403, 'Acesso não autorizado');
        }

        $data = $request->all();

        $data['company_id'] = Auth::user()->company_id;
        $data['editor'] = Auth::user()->id;

        $extra = Fee::create($data);

        if ($extra->save()) {
            return redirect()
                ->route('admin.salary-list.index')
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
        if (!Auth::user()->hasPermissionTo('Editar Pesquisa Salarial')) {
            abort(403, 'Acesso não autorizado');
        }

        $fee = Fee::where('id', $id)->first();
        if (empty($fee->id) || $fee->company_id != Auth::user()->company_id) {
            abort(403, 'Acesso não autorizado');
        }

        return view('admin.fees.edit', compact('fee'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(FeeRequest $request, $id)
    {
        if (!Auth::user()->hasPermissionTo('Editar Pesquisa Salarial')) {
            abort(403, 'Acesso não autorizado');
        }

        $fee = Fee::where('id', $id)->first();
        if (empty($fee->id) || $fee->company_id != Auth::user()->company_id) {
            abort(403, 'Acesso não autorizado');
        }

        $data = $request->all();

        $data['company_id'] = Auth::user()->company_id;
        $data['editor'] = Auth::user()->id;

        if ($fee->update($data)) {
            return redirect()
                ->route('admin.salary-list.index')
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
        if (!Auth::user()->hasPermissionTo('Editar Pesquisa Salarial')) {
            abort(403, 'Acesso não autorizado');
        }

        $fee = Fee::where('id', $id)->first();
        if (empty($fee->id) || $fee->company_id != Auth::user()->company_id) {
            abort(403, 'Acesso não autorizado');
        }

        if ($fee->delete()) {
            return redirect()
                ->route('admin.salary-list.index')
                ->with('success', 'Exclusão realizada!');
        } else {
            return redirect()
                ->back()
                ->with('error', 'Erro ao excluir!');
        }
    }
}
