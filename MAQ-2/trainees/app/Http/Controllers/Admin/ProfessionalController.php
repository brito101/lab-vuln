<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\ProfessionalRequest;
use App\Models\Professional;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ProfessionalController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        if (!Auth::user()->hasPermissionTo('Editar Experiências Profissionais')) {
            abort(403, 'Acesso não autorizado');
        }
        $professionals = Professional::where('user_id', Auth::user()->id)->get();
        return view('admin.professional.index', compact('professionals'));
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        if (!Auth::user()->hasPermissionTo('Editar Experiências Profissionais')) {
            abort(403, 'Acesso não autorizado');
        }

        return view('admin.professional.create');
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(ProfessionalRequest $request)
    {
        if (!Auth::user()->hasPermissionTo('Editar Experiências Profissionais')) {
            abort(403, 'Acesso não autorizado');
        }

        $data = $request->all();
        $data['user_id'] = auth()->user()->id;
        $professional = Professional::create($data);

        if ($professional->save()) {
            return redirect()
                ->route('admin.professionals.index')
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
        if (!Auth::user()->hasPermissionTo('Editar Experiências Profissionais')) {
            abort(403, 'Acesso não autorizado');
        }

        $professional = Professional::where('id', $id)->where('user_id', Auth::user()->id)->first();
        if (empty($professional->id)) {
            abort(403, 'Acesso não autorizado');
        }

        return view('admin.professional.edit', compact('professional'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(ProfessionalRequest $request, $id)
    {
        if (!Auth::user()->hasPermissionTo('Editar Experiências Profissionais')) {
            abort(403, 'Acesso não autorizado');
        }

        $professional = Professional::where('id', $id)->where('user_id', Auth::user()->id)->first();

        if (empty($professional->id)) {
            abort(403, 'Acesso não autorizado');
        }

        $data = $request->all();

        if ($professional->update($data)) {
            return redirect()
                ->route('admin.professionals.index')
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
        if (!Auth::user()->hasPermissionTo('Editar Experiências Profissionais')) {
            abort(403, 'Acesso não autorizado');
        }

        $professional = Professional::where('id', $id)->where('user_id', Auth::user()->id)->first();

        if (empty($professional->id)) {
            abort(403, 'Acesso não autorizado');
        }

        if ($professional->delete()) {
            return redirect()
                ->route('admin.professionals.index')
                ->with('success', 'Exclusão realizada!');
        } else {
            return redirect()
                ->back()
                ->with('error', 'Erro ao excluir!');
        }
    }
}
