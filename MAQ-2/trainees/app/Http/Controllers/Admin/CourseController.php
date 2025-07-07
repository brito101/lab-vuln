<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\CourseRequest;
use App\Models\Course;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class CourseController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        if (!Auth::user()->hasPermissionTo('Listar Cursos')) {
            abort(403, 'Acesso não autorizado');
        }
        $courses = Course::all();
        return view('admin.configurations.courses.index', compact('courses'));
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        if (!Auth::user()->hasPermissionTo('Criar Cursos')) {
            abort(403, 'Acesso não autorizado');
        }
        return view('admin.configurations.courses.create');
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(CourseRequest $request)
    {
        if (!Auth::user()->hasPermissionTo('Criar Cursos')) {
            abort(403, 'Acesso não autorizado');
        }
        $data = $request->all();
        $data['user_id'] = Auth::user()->id;
        $course = Course::create($data);

        if ($course->save()) {
            return redirect()
                ->route('admin.courses.index')
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
        if (!Auth::user()->hasPermissionTo('Editar Cursos')) {
            abort(403, 'Acesso não autorizado');
        }
        $course = Course::where('id', $id)->first();
        if (empty($course->id)) {
            abort(403, 'Acesso não autorizado');
        }
        return view('admin.configurations.courses.edit', compact('course'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(CourseRequest $request, $id)
    {
        if (!Auth::user()->hasPermissionTo('Editar Cursos')) {
            abort(403, 'Acesso não autorizado');
        }
        $data = $request->all();
        $course = Course::where('id', $id)->first();
        if (empty($course->id)) {
            abort(403, 'Acesso não autorizado');
        }
        if ($course->update($data)) {
            return redirect()
                ->route('admin.courses.index')
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
        if (!Auth::user()->hasPermissionTo('Excluir Cursos')) {
            abort(403, 'Acesso não autorizado');
        }
        $course = Course::where('id', $id)->first();
        if (empty($course->id)) {
            abort(403, 'Acesso não autorizado');
        }
        if ($course->delete()) {
            return redirect()
                ->route('admin.courses.index')
                ->with('success', 'Exclusão realizada!');
        } else {
            return redirect()
                ->back()
                ->with('error', 'Erro ao excluir!');
        }
    }
}
