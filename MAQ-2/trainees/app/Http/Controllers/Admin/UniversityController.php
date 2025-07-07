<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\UniversityRequest;
use App\Models\Company;
use App\Models\Course;
use App\Models\Scholarity;
use App\Models\University;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class UniversityController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        if (!Auth::user()->hasRole('Instituição de Ensino|Programador|Administrador|Franquiado')) {
            abort(403, 'Acesso não autorizado');
        }

        if (Auth::user()->hasRole('Programador|Administrador')) {
            $courses = University::all();
        }

        if (Auth::user()->hasRole('Franquiado')) {
            $companies = Company::where('affiliation_id', Auth::user()->affiliation_id)->get();
            $courses = University::whereIn('company_id', $companies->pluck('id'))->get();
        }

        if (Auth::user()->hasRole('Instituição de Ensino')) {
            $courses = University::where('company_id', Auth::user()->company_id)->get();
        }

        return view('admin.institutions.index', compact('courses'));
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        if (!Auth::user()->hasRole('Instituição de Ensino')) {
            abort(403, 'Acesso não autorizado');
        }

        $courses = Course::all();
        $scholarities = Scholarity::all();


        return view('admin.institutions.create', compact('courses', 'scholarities'));
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(UniversityRequest $request)
    {
        if (!Auth::user()->hasRole('Instituição de Ensino')) {
            abort(403, 'Acesso não autorizado');
        }

        $data = $request->all();
        $data['user_id'] = Auth::user()->id;
        $data['company_id'] = Auth::user()->company_id;
        $course = University::create($data);

        if ($course->save()) {
            return redirect()
                ->route('admin.institution.index')
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
        if (!Auth::user()->hasRole('Instituição de Ensino')) {
            abort(403, 'Acesso não autorizado');
        }

        $institution = University::where('id', $id)->where('company_id', Auth::user()->company_id)->first();
        if (empty($institution->id)) {
            abort(403, 'Acesso não autorizado');
        }

        $scholarities = Scholarity::all();
        $courses = Course::all();
        return view('admin.institutions.edit', compact('institution', 'scholarities', 'courses'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(UniversityRequest $request, $id)
    {
        if (!Auth::user()->hasRole('Instituição de Ensino')) {
            abort(403, 'Acesso não autorizado');
        }

        $institution = University::where('id', $id)->where('company_id', Auth::user()->company_id)->first();
        if (empty($institution->id)) {
            abort(403, 'Acesso não autorizado');
        }

        $data = $request->all();

        if ($institution->update($data)) {
            return redirect()
                ->route('admin.institution.index')
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
        if (!Auth::user()->hasRole('Instituição de Ensino')) {
            abort(403, 'Acesso não autorizado');
        }

        $institution = University::where('id', $id)->where('company_id', Auth::user()->company_id)->first();
        if (empty($institution->id)) {
            abort(403, 'Acesso não autorizado');
        }

        if ($institution->delete()) {
            return redirect()
                ->route('admin.institution.index')
                ->with('success', 'Exclusão realizada!');
        } else {
            return redirect()
                ->back()
                ->with('error', 'Erro ao excluir!');
        }
    }
}
