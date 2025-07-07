<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\AcademicRequest;
use App\Models\Academic;
use App\Models\Course;
use App\Models\Scholarity;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class AcademicController extends Controller
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
        $academics = Academic::where('user_id', Auth::user()->id)->get();
        return view('admin.academics.index', compact('academics'));
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

        $scholarities = Scholarity::all();
        $courses = Course::all();
        return view('admin.academics.create', compact('scholarities', 'courses'));
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(AcademicRequest $request)
    {
        if (!Auth::user()->hasPermissionTo('Editar Informações Acadêmicas')) {
            abort(403, 'Acesso não autorizado');
        }

        $data = $request->all();
        $data['user_id'] = auth()->user()->id;
        $academic = Academic::create($data);

        if ($academic->save()) {
            return redirect()
                ->route('admin.academics.index')
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

        $academic = Academic::where('id', $id)->where('user_id', Auth::user()->id)->first();
        if (empty($academic->id)) {
            abort(403, 'Acesso não autorizado');
        }

        $scholarities = Scholarity::all();
        $courses = Course::all();
        return view('admin.academics.edit', compact('scholarities', 'academic', 'courses'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(AcademicRequest $request, $id)
    {
        if (!Auth::user()->hasPermissionTo('Editar Informações Acadêmicas')) {
            abort(403, 'Acesso não autorizado');
        }

        $academic = Academic::where('id', $id)->where('user_id', Auth::user()->id)->first();

        if (empty($academic->id)) {
            abort(403, 'Acesso não autorizado');
        }

        $data = $request->all();

        if ($academic->update($data)) {
            return redirect()
                ->route('admin.academics.index')
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

        $academic = Academic::where('id', $id)->where('user_id', Auth::user()->id)->first();

        if (empty($academic->id)) {
            abort(403, 'Acesso não autorizado');
        }

        if ($academic->delete()) {
            return redirect()
                ->route('admin.academics.index')
                ->with('success', 'Exclusão realizada!');
        } else {
            return redirect()
                ->back()
                ->with('error', 'Erro ao excluir!');
        }
    }
}
