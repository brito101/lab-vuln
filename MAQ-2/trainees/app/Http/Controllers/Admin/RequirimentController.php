<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\RequirimentRequest;
use App\Models\Requiriment;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class RequirimentController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        if (!Auth::user()->hasPermissionTo('Editar Necessidades Especiais')) {
            abort(403, 'Acesso não autorizado');
        }
        $requiriments = Requiriment::where('user_id', Auth::user()->id)->get();
        return view('admin.requiriments.index', compact('requiriments'));
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        if (!Auth::user()->hasPermissionTo('Editar Necessidades Especiais')) {
            abort(403, 'Acesso não autorizado');
        }
        return view('admin.requiriments.create');
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(RequirimentRequest $request)
    {
        if (!Auth::user()->hasPermissionTo('Editar Necessidades Especiais')) {
            abort(403, 'Acesso não autorizado');
        }

        $data = $request->all();
        $data['user_id'] = auth()->user()->id;
        $requiriment = Requiriment::create($data);

        if ($requiriment->save()) {
            return redirect()
                ->route('admin.requiriments.index')
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
        if (!Auth::user()->hasPermissionTo('Editar Necessidades Especiais')) {
            abort(403, 'Acesso não autorizado');
        }

        $requiriment = Requiriment::where('id', $id)->where('user_id', Auth::user()->id)->first();
        if (empty($requiriment->id)) {
            abort(403, 'Acesso não autorizado');
        }

        return view('admin.requiriments.edit', compact('requiriment'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        if (!Auth::user()->hasPermissionTo('Editar Necessidades Especiais')) {
            abort(403, 'Acesso não autorizado');
        }

        $requiriment = Requiriment::where('id', $id)->where('user_id', Auth::user()->id)->first();

        if (empty($requiriment->id)) {
            abort(403, 'Acesso não autorizado');
        }

        $data = $request->all();

        if ($requiriment->update($data)) {
            return redirect()
                ->route('admin.requiriments.index')
                ->with('success', 'Atualização realizada!');
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
        if (!Auth::user()->hasPermissionTo('Editar Necessidades Especiais')) {
            abort(403, 'Acesso não autorizado');
        }

        $requiriment = Requiriment::where('id', $id)->where('user_id', Auth::user()->id)->first();

        if (empty($requiriment->id)) {
            abort(403, 'Acesso não autorizado');
        }

        if ($requiriment->delete()) {
            return redirect()
                ->route('admin.requiriments.index')
                ->with('success', 'Exclusão realizada!');
        } else {
            return redirect()
                ->back()
                ->with('error', 'Erro ao excluir!');
        }
    }
}
