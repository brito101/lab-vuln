<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\CompanyBrandRequest;
use App\Http\Requests\Admin\CompanyRequest;
use App\Models\Affiliation;
use App\Models\Company;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Str;

class InstitutionSchoolController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        if (!Auth::user()->hasPermissionTo('Listar Empresas')) {
            abort(403, 'Acesso não autorizado');
        }

        $companies = Company::where('institution', 'Sim')->get();

        if (Auth::user()->hasRole('Franquiado')) {
            $companies = Company::where('affiliation_id', Auth::user()->affiliation_id)
                ->where('institution', 'Sim')
                ->get();
        }

        return view('admin.insitutions_school.index', compact('companies'));
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        if (!Auth::user()->hasPermissionTo('Criar Empresas')) {
            abort(403, 'Acesso não autorizado');
        }

        $affiliates = Affiliation::all();

        return view('admin.insitutions_school.create', compact('affiliates'));
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(CompanyRequest $request)
    {
        if (!Auth::user()->hasPermissionTo('Criar Empresas')) {
            abort(403, 'Acesso não autorizado');
        }
        $data = $request->all();
        $data['user_id'] = auth()->user()->id;
        $data['institution'] = 'Sim';

        if (Auth::user()->hasRole('Franquiado')) {
            $data['affiliation_id'] = auth()->user()->affiliation_id;
        }

        if ($request->hasFile('logo') && $request->file('logo')->isValid()) {
            $name = Str::slug(mb_substr($data['alias_name'], 0, 100)) . time();
            $extenstion = $request->logo->extension();
            $nameFile = "{$name}.{$extenstion}";
            $data['logo'] = $nameFile;
            $upload = $request->logo->storeAs('companies', $nameFile);

            if (!$upload) {
                return redirect()
                    ->back()
                    ->withInput()
                    ->with('error', 'Falha ao fazer o upload da imagem');
            }
        }

        $company = Company::create($data);

        if ($company->save()) {
            return redirect()
                ->route('admin.educational-institutions.index')
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
    public function edit($id = null)
    {
        if ($id && !Auth::user()->hasPermissionTo('Editar Empresas')) {
            abort(403, 'Acesso não autorizado');
        }

        if (is_null($id) && !Auth::user()->hasPermissionTo('Editar Empresa')) {
            abort(403, 'Acesso não autorizado');
        }

        if (is_null($id)) {
            $id = Auth::user()->company_id;
        }

        $company = Company::where('id', $id)->where('institution', 'Sim')->first();

        if (Auth::user()->hasRole('Franquiado')) {
            $company = Company::where('id', $id)
                ->where('affiliation_id', Auth::user()->affiliation_id)
                ->where('institution', 'Sim')
                ->first();
        }

        $affiliates = Affiliation::all();

        if (empty($company->id)) {
            abort(403, 'Acesso não autorizado');
        }
        return view('admin.insitutions_school.edit', compact('company', 'affiliates'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(CompanyRequest $request, $id)
    {
        if (!Auth::user()->hasAnyPermission(['Editar Empresas', 'Editar Empresa'])) {
            abort(403, 'Acesso não autorizado');
        }

        $data = $request->all();

        if (Auth::user()->hasPermissionTo('Editar Empresas')) {
            $company = Company::where('id', $id)->first();
        }

        if (Auth::user()->hasPermissionTo('Editar Empresa')) {
            $company = Company::where('id', Auth::user()->company_id)
                ->where('institution', 'Sim')
                ->first();
        }

        if (Auth::user()->hasRole('Franquiado')) {
            $company = Company::where('id', $id)
                ->where('affiliation_id', Auth::user()->affiliation_id)
                ->where('institution', 'Sim')
                ->first();
            $data['affiliation_id'] = auth()->user()->affiliation_id;
        }

        if (empty($company->id)) {
            abort(403, 'Acesso não autorizado');
        }

        if ($request->hasFile('logo') && $request->file('logo')->isValid()) {
            $name = Str::slug(mb_substr($data['alias_name'], 0, 10)) . time();
            $imagePath = storage_path() . '/app/public/companies/' . $company->logo;

            if (File::isFile($imagePath)) {
                unlink($imagePath);
            }

            $extenstion = $request->logo->extension();
            $nameFile = "{$name}.{$extenstion}";

            $data['logo'] = $nameFile;
            $data['institution'] = 'Sim';


            $upload = $request->logo->storeAs('companies', $nameFile);

            if (!$upload) {
                return redirect()
                    ->back()
                    ->withInput()
                    ->with('error', 'Falha ao fazer o upload da imagem');
            }
        }

        if ($company->update($data)) {
            if (Auth::user()->hasPermissionTo('Editar Empresa')) {
                return redirect()
                    ->route('admin.educational-institutions.edit')
                    ->with('success', 'Atualização realizada!');
            } else {
                return redirect()
                    ->route('admin.educational-institutions.index')
                    ->with('success', 'Atualização realizada!');
            }
        } else {
            return redirect()
                ->back()
                ->withInput()
                ->with('error', 'Erro ao atualizar!');
        }
    }

    public function socialNetwork()
    {
        if (!Auth::user()->hasPermissionTo('Editar Empresa')) {
            abort(403, 'Acesso não autorizado');
        }

        $company = Company::where('id', Auth::user()->company_id)->first();
        if (empty($company->id)) {
            abort(403, 'Acesso não autorizado');
        }
        return view('admin.insitutions_school.social', compact('company'));
    }

    public function socialNetworkStore(CompanyBrandRequest $request)
    {
        $data = $request->all();

        if (!Auth::user()->hasPermissionTo('Editar Empresa')) {
            abort(403, 'Acesso não autorizado');
        }

        $company = Company::where('id', Auth::user()->company_id)->first();
        if (empty($company->id)) {
            abort(403, 'Acesso não autorizado');
        }

        if ($company->update($data)) {
            return redirect()
                ->route('admin.educational-institutions.social')
                ->with('success', 'Atualização realizada!');
        } else {
            return redirect()
                ->back()
                ->withInput()
                ->with('error', 'Erro ao atualizar!');
        }
    }

    public function resume()
    {
        if (!Auth::user()->hasPermissionTo('Editar Empresa')) {
            abort(403, 'Acesso não autorizado');
        }

        $company = Company::where('id', Auth::user()->company_id)
            ->where('institution', 'Sim')
            ->first();
        if (empty($company->id)) {
            abort(403, 'Acesso não autorizado');
        }
        return view('admin.insitutions_school.resume', compact('company'));
    }


    public function resumeStore(CompanyBrandRequest $request)
    {
        $data = $request->all();

        if (!Auth::user()->hasPermissionTo('Editar Empresa')) {
            abort(403, 'Acesso não autorizado');
        }

        $company = Company::where('id', Auth::user()->company_id)
            ->where('institution', 'Sim')
            ->first();
        if (empty($company->id)) {
            abort(403, 'Acesso não autorizado');
        }

        if ($company->update($data)) {
            return redirect()
                ->route('admin.educational-institutions.resume')
                ->with('success', 'Edição realizada!');
        } else {
            return redirect()
                ->back()
                ->withInput()
                ->with('error', 'Erro ao atualizar!');
        }
    }

    public function brandImages()
    {
        if (!Auth::user()->hasPermissionTo('Editar Empresa')) {
            abort(403, 'Acesso não autorizado');
        }

        $company = Company::where('id', Auth::user()->company_id)
            ->where('institution', 'Sim')
            ->first();
        if (empty($company->id)) {
            abort(403, 'Acesso não autorizado');
        }
        return view('admin.insitutions_scholl.brand', compact('company'));
    }

    public function brandImagesStore(CompanyBrandRequest $request)
    {
        $data = $request->all();

        if (!Auth::user()->hasPermissionTo('Editar Empresa')) {
            abort(403, 'Acesso não autorizado');
        }

        $company = Company::where('id', Auth::user()->company_id)
            ->where('institution', 'Sim')
            ->first();
        if (empty($company->id)) {
            abort(403, 'Acesso não autorizado');
        }

        /** Facebook */
        if ($request->hasFile('brand_facebook') && $request->file('brand_facebook')->isValid()) {
            $name = Str::slug(mb_substr($company->alias_name, 0, 10)) . '-facebook' . time();
            $imagePath = storage_path() . '/app/public/companies/' . $company->brand_facebook;

            if (File::isFile($imagePath)) {
                unlink($imagePath);
            }

            $extenstion = $request->brand_facebook->extension();
            $nameFile = "{$name}.{$extenstion}";

            $data['brand_facebook'] = $nameFile;

            $upload = $request->brand_facebook->storeAs('companies', $nameFile);

            if (!$upload) {
                return redirect()
                    ->back()
                    ->withInput()
                    ->with('error', 'Falha ao fazer o upload da imagem');
            }
        }

        /** Instagram */
        if ($request->hasFile('brand_instagram') && $request->file('brand_instagram')->isValid()) {
            $name = Str::slug(mb_substr($company->alias_name, 0, 10))  . '-instagram' . time();
            $imagePath = storage_path() . '/app/public/companies/' . $company->brand_instagram;

            if (File::isFile($imagePath)) {
                unlink($imagePath);
            }

            $extenstion = $request->brand_instagram->extension();
            $nameFile = "{$name}.{$extenstion}";

            $data['brand_instagram'] = $nameFile;

            $upload = $request->brand_instagram->storeAs('companies', $nameFile);

            if (!$upload) {
                return redirect()
                    ->back()
                    ->withInput()
                    ->with('error', 'Falha ao fazer o upload da imagem');
            }
        }

        /** Twitter */
        if ($request->hasFile('brand_twitter') && $request->file('brand_twitter')->isValid()) {
            $name = Str::slug(mb_substr($company->alias_name, 0, 10)) . '-twitter' . time();
            $imagePath = storage_path() . '/app/public/companies/' . $company->brand_twitter;

            if (File::isFile($imagePath)) {
                unlink($imagePath);
            }

            $extenstion = $request->brand_twitter->extension();
            $nameFile = "{$name}.{$extenstion}";

            $data['brand_twitter'] = $nameFile;

            $upload = $request->brand_twitter->storeAs('companies', $nameFile);

            if (!$upload) {
                return redirect()
                    ->back()
                    ->withInput()
                    ->with('error', 'Falha ao fazer o upload da imagem');
            }
        }

        if ($company->update($data)) {
            return redirect()
                ->route('admin.educational-institutions.brand')
                ->with('success', 'Edição realizada!');
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
        if (!Auth::user()->hasPermissionTo('Excluir Empresas')) {
            abort(403, 'Acesso não autorizado');
        }
        $company = Company::where('id', $id)
            ->where('institution', 'Sim')
            ->first();

        if (Auth::user()->hasRole('Franquiado')) {
            $company = Company::where('id', $id)
                ->where('affiliation_id', Auth::user()->affiliation_id)
                ->where('institution', 'Sim')
                ->first();
        }

        if (empty($company->id)) {
            abort(403, 'Acesso não autorizado');
        }
        $imagePath = storage_path() . '/app/public/companies/' . $company->logo;
        $imagePathFacebook = storage_path() . '/app/public/companies/' . $company->brand_facebook;
        $imagePathInstagram = storage_path() . '/app/public/companies/' . $company->brand_instagram;
        $imagePathTwitter = storage_path() . '/app/public/companies/' . $company->brand_twitter;

        if ($company->delete()) {
            if (File::isFile($imagePath)) {
                unlink($imagePath);
                $company->logo = null;
                $company->update();
            }

            if (File::isFile($imagePathFacebook)) {
                unlink($imagePathFacebook);
                $company->brand_facebook = null;
                $company->update();
            }

            if (File::isFile($imagePathInstagram)) {
                unlink($imagePathInstagram);
                $company->brand_instagram = null;
                $company->update();
            }

            if (File::isFile($imagePathTwitter)) {
                unlink($imagePathTwitter);
                $company->brand_twitter = null;
                $company->update();
            }

            return redirect()
                ->route('admin.educational-institutions.index')
                ->with('success', 'Exclusão realizada!');
        } else {
            return redirect()
                ->back()
                ->with('error', 'Erro ao excluir!');
        }
    }
}
