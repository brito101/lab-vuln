<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\VacancyRequest;
use App\Models\Candidate;
use App\Models\Course;
use App\Models\Scholarity;
use App\Models\Vacancy;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Str;

class VacancyController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        if (!Auth::user()->hasPermissionTo('Listar Vagas')) {
            abort(403, 'Acesso não autorizado');
        }
        $vacancies = Vacancy::where('company_id', Auth::user()->company_id)->get();
        return view('admin.vacancies.index', compact('vacancies'));
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        if (!Auth::user()->hasPermissionTo('Criar Vagas')) {
            abort(403, 'Acesso não autorizado');
        }

        $courses = Course::all();
        $scholarities = Scholarity::all();
        return view('admin.vacancies.create', compact('scholarities', 'courses'));
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(VacancyRequest $request)
    {

        if (!Auth::user()->hasPermissionTo('Criar Vagas')) {
            abort(403, 'Acesso não autorizado');
        }

        $data = $request->all();
        $data['user_id'] = auth()->user()->id;
        $data['company_id'] = auth()->user()->company_id;

        $courses = implode(', ', $request->courses);
        $data['courses'] = $courses;

        /** Facebook */
        if ($request->hasFile('brand_facebook') && $request->file('brand_facebook')->isValid()) {
            $name = Str::slug(mb_substr($data['title'], 0, 100)) . '-facebook' . time();
            $extenstion = $request->brand_facebook->extension();
            $nameFile = "{$name}.{$extenstion}";

            $data['brand_facebook'] = $nameFile;

            $upload = $request->brand_facebook->storeAs('vacancies', $nameFile);

            if (!$upload)
                return redirect()
                    ->back()
                    ->withInput()
                    ->with('error', 'Falha ao fazer o upload da imagem');
        }

        /** Instagram */
        if ($request->hasFile('brand_instagram') && $request->file('brand_instagram')->isValid()) {
            $name = Str::slug(mb_substr($data['title'], 0, 100)) . '-instagram' . time();

            $extenstion = $request->brand_instagram->extension();
            $nameFile = "{$name}.{$extenstion}";

            $data['brand_instagram'] = $nameFile;

            $upload = $request->brand_instagram->storeAs('vacancies', $nameFile);

            if (!$upload)
                return redirect()
                    ->back()
                    ->withInput()
                    ->with('error', 'Falha ao fazer o upload da imagem');
        }

        /** Twitter */
        if ($request->hasFile('brand_twitter') && $request->file('brand_twitter')->isValid()) {
            $name = Str::slug(mb_substr($data['title'], 0, 100)) . '-twitter' . time();

            $extenstion = $request->brand_twitter->extension();
            $nameFile = "{$name}.{$extenstion}";

            $data['brand_twitter'] = $nameFile;

            $upload = $request->brand_twitter->storeAs('vacancies', $nameFile);

            if (!$upload) {
                return redirect()
                    ->back()
                    ->withInput()
                    ->with('error', 'Falha ao fazer o upload da imagem');
            }
        }

        $vacancy = Vacancy::create($data);

        if ($vacancy->save()) {
            $vacancy->slug = Str::slug($vacancy->title . '-' . $vacancy->id);
            $vacancy->update();
            return redirect()
                ->route('admin.vacancies.index')
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
        if (!Auth::user()->hasPermissionTo('Editar Vagas')) {
            abort(403, 'Acesso não autorizado');
        }

        $vacancy = Vacancy::where('id', $id)
            ->where('company_id', Auth::user()->company_id)->first();

        if (empty($vacancy->id)) {
            abort(403, 'Acesso não autorizado');
        }

        $courses = Course::all();
        $scholarities = Scholarity::all();
        return view('admin.vacancies.edit', compact('vacancy', 'scholarities', 'courses'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(VacancyRequest $request, $id)
    {
        if (!Auth::user()->hasPermissionTo('Editar Vagas')) {
            abort(403, 'Acesso não autorizado');
        }

        $data = $request->all();
        $data['company_id'] = auth()->user()->company_id;
        $data['user_id'] = auth()->user()->id;

        $courses = implode(', ', $request->courses);
        $data['courses'] = $courses;

        $vacancy = Vacancy::where('id', $id)
            ->where('company_id', Auth::user()->company_id)->first();

        if (empty($vacancy->id)) {
            abort(403, 'Acesso não autorizado');
        }

        /** Facebook */
        if ($request->hasFile('brand_facebook') && $request->file('brand_facebook')->isValid()) {
            $name = Str::slug(mb_substr($vacancy['title'], 0, 100)) . '-facebook' . time();
            $imagePath = storage_path() . '/app/public/vacancies/' . $vacancy->brand_facebook;

            if (File::isFile($imagePath)) {
                unlink($imagePath);
            }

            $extenstion = $request->brand_facebook->extension();
            $nameFile = "{$name}.{$extenstion}";

            $data['brand_facebook'] = $nameFile;

            $upload = $request->brand_facebook->storeAs('vacancies', $nameFile);

            if (!$upload) {
                return redirect()
                    ->back()
                    ->withInput()
                    ->with('error', 'Falha ao fazer o upload da imagem');
            }
        }

        /** Instagram */
        if ($request->hasFile('brand_instagram') && $request->file('brand_instagram')->isValid()) {
            $name = Str::slug(mb_substr($data['title'], 0, 100)) . '-instagram' . time();
            $imagePath = storage_path() . '/app/public/vacancies/' . $vacancy->brand_instagram;

            if (File::isFile($imagePath)) {
                unlink($imagePath);
            }

            $extenstion = $request->brand_instagram->extension();
            $nameFile = "{$name}.{$extenstion}";

            $data['brand_instagram'] = $nameFile;

            $upload = $request->brand_instagram->storeAs('vacancies', $nameFile);

            if (!$upload) {
                return redirect()
                    ->back()
                    ->withInput()
                    ->with('error', 'Falha ao fazer o upload da imagem');
            }
        }

        /** Twitter */
        if ($request->hasFile('brand_twitter') && $request->file('brand_twitter')->isValid()) {
            $name = Str::slug(mb_substr($data['title'], 0, 100)) . '-twitter' . time();
            $imagePath = storage_path() . '/app/public/vacancies/' . $vacancy->brand_twitter;

            if (File::isFile($imagePath)) {
                unlink($imagePath);
            }

            $extenstion = $request->brand_twitter->extension();
            $nameFile = "{$name}.{$extenstion}";

            $data['brand_twitter'] = $nameFile;

            $upload = $request->brand_twitter->storeAs('vacancies', $nameFile);

            if (!$upload) {
                return redirect()
                    ->back()
                    ->withInput()
                    ->with('error', 'Falha ao fazer o upload da imagem');
            }
        }

        $data['slug'] = Str::slug($data['title'] . '-' . $vacancy->id);

        if ($vacancy->update($data)) {
            return redirect()
                ->route('admin.vacancies.index')
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
        if (!Auth::user()->hasPermissionTo('Excluir Vagas')) {
            abort(403, 'Acesso não autorizado');
        }

        $vacancy = Vacancy::where('id', $id)
            ->where('company_id', Auth::user()->company_id)->first();

        if (empty($vacancy->id)) {
            abort(403, 'Acesso não autorizado');
        }
        $imagePathFacebook = storage_path() . '/app/public/vacancies/' . $vacancy->brand_facebook;
        $imagePathInstagram = storage_path() . '/app/public/vacancies/' . $vacancy->brand_instagram;
        $imagePathTwitter = storage_path() . '/app/public/vacancies/' . $vacancy->brand_twitter;

        if ($vacancy->delete()) {

            if (File::isFile($imagePathFacebook)) {
                unlink($imagePathFacebook);
                $vacancy->brand_facebook = null;
                $vacancy->update();
            }

            if (File::isFile($imagePathInstagram)) {
                unlink($imagePathInstagram);
                $vacancy->brand_instagram = null;
                $vacancy->update();
            }

            if (File::isFile($imagePathTwitter)) {
                unlink($imagePathTwitter);
                $vacancy->brand_twitter = null;
                $vacancy->update();
            }

            return redirect()
                ->route('admin.vacancies.index')
                ->with('success', 'Exclusão realizada!');
        } else {
            return redirect()
                ->back()
                ->with('error', 'Erro ao excluir!');
        }
    }

    public function show($id)
    {
        if (!Auth::user()->hasPermissionTo('Visualizar Vagas')) {
            abort(403, 'Acesso não autorizado');
        }

        $vacancy = Vacancy::where('id', $id)->first();

        if (empty($vacancy->id)) {
            abort(403, 'Acesso não autorizado');
        }

        $candidate = Candidate::where('vacancy_id', $vacancy->id)
            ->where('user_id', Auth::user()->id)->first();

        return view('admin.vacancies.show', compact('vacancy', 'candidate'));
    }
}
