<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\ScholarityRequest;
use App\Models\Scholarity;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ScholarityController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        if (!Auth::user()->hasPermissionTo('Listar Escolaridade')) {
            abort(403, 'Acesso não autorizado');
        }
        $scholarities = Scholarity::all();
        return view('admin.configurations.scholarities.index', compact('scholarities'));
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        if (!Auth::user()->hasPermissionTo('Criar Escolaridade')) {
            abort(403, 'Acesso não autorizado');
        }
        return view('admin.configurations.scholarities.create');
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(ScholarityRequest $request)
    {
        if (!Auth::user()->hasPermissionTo('Criar Escolaridade')) {
            abort(403, 'Acesso não autorizado');
        }
        $data = $request->all();
        $data['user_id'] = auth()->user()->id;
        $scholarity = Scholarity::create($data);

        if ($scholarity->save()) {
            return redirect()
                ->route('admin.scholarities.index')
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
        if (!Auth::user()->hasPermissionTo('Editar Escolaridade')) {
            abort(403, 'Acesso não autorizado');
        }
        $scholarity = Scholarity::where('id', $id)->first();
        if (empty($scholarity->id)) {
            abort(403, 'Acesso não autorizado');
        }
        return view('admin.configurations.scholarities.edit', compact('scholarity'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(ScholarityRequest $request, $id)
    {
        if (!Auth::user()->hasPermissionTo('Editar Escolaridade')) {
            abort(403, 'Acesso não autorizado');
        }
        $data = $request->all();
        $scholarity = Scholarity::where('id', $id)->first();
        if (empty($scholarity->id)) {
            abort(403, 'Acesso não autorizado');
        }
        if ($scholarity->update($data)) {
            return redirect()
                ->route('admin.scholarities.index')
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
        if (!Auth::user()->hasPermissionTo('Excluir Escolaridade')) {
            abort(403, 'Acesso não autorizado');
        }
        $scholarity = Scholarity::where('id', $id)->first();
        if (empty($scholarity->id)) {
            abort(403, 'Acesso não autorizado');
        }
        if ($scholarity->delete()) {
            return redirect()
                ->route('admin.scholarities.index')
                ->with('success', 'Exclusão realizada!');
        } else {
            return redirect()
                ->back()
                ->with('error', 'Erro ao excluir!');
        }
    }
}
