<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\ExtraRequest;
use App\Models\Course;
use App\Models\Extra;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ExtraController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        if (!Auth::user()->hasPermissionTo('Editar Informações Acadêmicas')) {
            abort(403, 'Acesso não autorizado');
        }
        $extras = Extra::where('user_id', Auth::user()->id)->get();
        return view('admin.extra.index', compact('extras'));
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        if (!Auth::user()->hasPermissionTo('Editar Informações Acadêmicas')) {
            abort(403, 'Acesso não autorizado');
        }

        $courses = Course::all();

        return view('admin.extra.create', compact('courses'));
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(ExtraRequest $request)
    {
        if (!Auth::user()->hasPermissionTo('Editar Informações Acadêmicas')) {
            abort(403, 'Acesso não autorizado');
        }

        $data = $request->all();

        $data['user_id'] = Auth::user()->id;

        $extra = Extra::create($data);

        if ($extra->save()) {
            return redirect()
                ->route('admin.extras.index')
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
        if (!Auth::user()->hasPermissionTo('Editar Informações Acadêmicas')) {
            abort(403, 'Acesso não autorizado');
        }

        $courses = Course::all();

        $extra = Extra::where('user_id', Auth::user()->id)->first();
        if (empty($extra->id)) {
            abort(403, 'Acesso não autorizado');
        }

        return view('admin.extra.edit', compact('courses', 'extra'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(ExtraRequest $request, $id)
    {
        if (!Auth::user()->hasPermissionTo('Editar Informações Acadêmicas')) {
            abort(403, 'Acesso não autorizado');
        }

        $extra = Extra::where('id', $id)->where('user_id', Auth::user()->id)->first();

        if (empty($extra->id)) {
            abort(403, 'Acesso não autorizado');
        }

        $data = $request->all();

        if ($extra->update($data)) {
            return redirect()
                ->route('admin.extras.index')
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
        if (!Auth::user()->hasPermissionTo('Editar Informações Acadêmicas')) {
            abort(403, 'Acesso não autorizado');
        }

        $extra = Extra::where('id', $id)->where('user_id', Auth::user()->id)->first();

        if (empty($extra->id)) {
            abort(403, 'Acesso não autorizado');
        }

        if ($extra->delete()) {
            return redirect()
                ->route('admin.extras.index')
                ->with('success', 'Exclusão realizada!');
        } else {
            return redirect()
                ->back()
                ->withInput()
                ->with('error', 'Erro ao excluir!');
        }
    }
}
