<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\AffiliationBrandRequest;
use App\Http\Requests\Admin\AffiliationRequest;
use App\Models\Affiliation;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Str;

class AffiliationController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        if (!Auth::user()->hasPermissionTo('Listar Franquias')) {
            abort(403, 'Acesso não autorizado');
        }
        $affiliations = Affiliation::all();
        return view('admin.franchisees.index', compact('affiliations'));
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        if (!Auth::user()->hasPermissionTo('Criar Franquias')) {
            abort(403, 'Acesso não autorizado');
        }
        return view('admin.franchisees.create');
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(AffiliationRequest $request)
    {
        if (!Auth::user()->hasPermissionTo('Criar Franquias')) {
            abort(403, 'Acesso não autorizado');
        }
        $data = $request->all();
        $data['user_id'] = auth()->user()->id;

        if ($request->hasFile('logo') && $request->file('logo')->isValid()) {
            $name = Str::slug(mb_substr($data['alias_name'], 0, 100)) . time();
            $extenstion = $request->logo->extension();
            $nameFile = "{$name}.{$extenstion}";
            $data['logo'] = $nameFile;
            $upload = $request->logo->storeAs('affiliations', $nameFile);

            if (!$upload) {
                return redirect()
                    ->back()
                    ->withInput()
                    ->with('error', 'Falha ao fazer o upload da imagem');
            }
        }

        $affiliation = Affiliation::create($data);

        if ($affiliation->save()) {
            return redirect()
                ->route('admin.franchisees.index')
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
        if ($id && !Auth::user()->hasPermissionTo('Editar Franquias')) {
            abort(403, 'Acesso não autorizado');
        }

        if (is_null($id) && !Auth::user()->hasPermissionTo('Editar Franquia')) {
            abort(403, 'Acesso não autorizado');
        }

        if (is_null($id)) {
            $id = Auth::user()->affiliation_id;
        }

        $affiliation = Affiliation::where('id', $id)->first();
        if (empty($affiliation->id)) {
            abort(403, 'Acesso não autorizado');
        }
        return view('admin.franchisees.edit', compact('affiliation'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(AffiliationRequest $request, $id)
    {
        if (!Auth::user()->hasAnyPermission(['Editar Franquias', 'Editar Franquia'])) {
            abort(403, 'Acesso não autorizado');
        }

        $data = $request->all();

        if (Auth::user()->hasPermissionTo('Editar Franquias')) {
            $affiliation = Affiliation::where('id', $id)->first();
        }

        if (Auth::user()->hasPermissionTo('Editar Franquia')) {
            $affiliation = Affiliation::where('id', Auth::user()->affiliation_id)->first();
        }

        if (empty($affiliation->id)) {
            abort(403, 'Acesso não autorizado');
        }

        if ($request->hasFile('logo') && $request->file('logo')->isValid()) {
            $name = Str::slug(mb_substr($data['alias_name'], 0, 10)) . time();
            $imagePath = storage_path() . '/app/public/affiliations/' . $affiliation->logo;

            if (File::isFile($imagePath)) {
                unlink($imagePath);
            }

            $extenstion = $request->logo->extension();
            $nameFile = "{$name}.{$extenstion}";

            $data['logo'] = $nameFile;

            $upload = $request->logo->storeAs('affiliations', $nameFile);

            if (!$upload)
                return redirect()
                    ->back()
                    ->withInput()
                    ->with('error', 'Falha ao fazer o upload da imagem');
        }

        if ($affiliation->update($data)) {
            if (Auth::user()->hasPermissionTo('Editar Franquia')) {
                return redirect()
                    ->route('admin.franchise.edit')
                    ->with('success', 'Atualização realizada!');
            } else {
                return redirect()
                    ->route('admin.franchisees.index')
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
        if (!Auth::user()->hasPermissionTo('Editar Franquia')) {
            abort(403, 'Acesso não autorizado');
        }

        $affiliation = Affiliation::where('id', Auth::user()->affiliation_id)->first();
        if (empty($affiliation->id)) {
            abort(403, 'Acesso não autorizado');
        }
        return view('admin.franchisees.social', compact('affiliation'));
    }

    public function socialNetworkStore(AffiliationBrandRequest $request)
    {
        $data = $request->all();

        if (!Auth::user()->hasPermissionTo('Editar Franquia')) {
            abort(403, 'Acesso não autorizado');
        }

        $affiliation = Affiliation::where('id', Auth::user()->affiliation_id)->first();
        if (empty($affiliation->id)) {
            abort(403, 'Acesso não autorizado');
        }

        if ($affiliation->update($data)) {
            return redirect()
                ->route('admin.franchise.social')
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
        if (!Auth::user()->hasPermissionTo('Editar Franquia')) {
            abort(403, 'Acesso não autorizado');
        }

        $affiliation = Affiliation::where('id', Auth::user()->affiliation_id)->first();
        if (empty($affiliation->id)) {
            abort(403, 'Acesso não autorizado');
        }
        return view('admin.franchisees.resume', compact('affiliation'));
    }


    public function resumeStore(AffiliationBrandRequest $request)
    {
        $data = $request->all();

        if (!Auth::user()->hasPermissionTo('Editar Franquia')) {
            abort(403, 'Acesso não autorizado');
        }

        $affiliation = Affiliation::where('id', Auth::user()->affiliation_id)->first();
        if (empty($affiliation->id)) {
            abort(403, 'Acesso não autorizado');
        }

        if ($affiliation->update($data)) {
            return redirect()
                ->route('admin.franchise.resume')
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
        if (!Auth::user()->hasPermissionTo('Editar Franquia')) {
            abort(403, 'Acesso não autorizado');
        }

        $affiliation = Affiliation::where('id', Auth::user()->affiliation_id)->first();
        if (empty($affiliation->id)) {
            abort(403, 'Acesso não autorizado');
        }
        return view('admin.franchisees.brand', compact('affiliation'));
    }

    public function brandImagesStore(AffiliationBrandRequest $request)
    {
        $data = $request->all();

        if (!Auth::user()->hasPermissionTo('Editar Franquia')) {
            abort(403, 'Acesso não autorizado');
        }

        $affiliation = Affiliation::where('id', Auth::user()->affiliation_id)->first();
        if (empty($affiliation->id)) {
            abort(403, 'Acesso não autorizado');
        }

        /** Facebook */
        if ($request->hasFile('brand_facebook') && $request->file('brand_facebook')->isValid()) {
            $name = Str::slug(mb_substr($affiliation->alias_name, 0, 10)) . '-facebook' . time();
            $imagePath = storage_path() . '/app/public/affiliations/' . $affiliation->brand_facebook;

            if (File::isFile($imagePath)) {
                unlink($imagePath);
            }

            $extenstion = $request->brand_facebook->extension();
            $nameFile = "{$name}.{$extenstion}";

            $data['brand_facebook'] = $nameFile;

            $upload = $request->brand_facebook->storeAs('affiliations', $nameFile);

            if (!$upload)
                return redirect()
                    ->back()
                    ->withInput()
                    ->with('error', 'Falha ao fazer o upload da imagem');
        }

        /** Instagram */
        if ($request->hasFile('brand_instagram') && $request->file('brand_instagram')->isValid()) {
            $name = Str::slug(mb_substr($affiliation->alias_name, 0, 10))  . '-instagram' . time();
            $imagePath = storage_path() . '/app/public/affiliations/' . $affiliation->brand_instagram;

            if (File::isFile($imagePath)) {
                unlink($imagePath);
            }

            $extenstion = $request->brand_instagram->extension();
            $nameFile = "{$name}.{$extenstion}";

            $data['brand_instagram'] = $nameFile;

            $upload = $request->brand_instagram->storeAs('affiliations', $nameFile);

            if (!$upload)
                return redirect()
                    ->back()
                    ->withInput()
                    ->with('error', 'Falha ao fazer o upload da imagem');
        }

        /** Twitter */
        if ($request->hasFile('brand_twitter') && $request->file('brand_twitter')->isValid()) {
            $name = Str::slug(mb_substr($affiliation->alias_name, 0, 10)) . '-twitter' . time();
            $imagePath = storage_path() . '/app/public/affiliations/' . $affiliation->brand_twitter;

            if (File::isFile($imagePath)) {
                unlink($imagePath);
            }

            $extenstion = $request->brand_twitter->extension();
            $nameFile = "{$name}.{$extenstion}";

            $data['brand_twitter'] = $nameFile;

            $upload = $request->brand_twitter->storeAs('affiliations', $nameFile);

            if (!$upload)
                return redirect()
                    ->back()
                    ->withInput()
                    ->with('error', 'Falha ao fazer o upload da imagem');
        }

        if ($affiliation->update($data)) {
            return redirect()
                ->route('admin.franchise.brand')
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
        if (!Auth::user()->hasPermissionTo('Excluir Franquias')) {
            abort(403, 'Acesso não autorizado');
        }
        $affiliation = Affiliation::where('id', $id)->first();
        if (empty($affiliation->id)) {
            abort(403, 'Acesso não autorizado');
        }
        $imagePath = storage_path() . '/app/public/affiliations/' . $affiliation->logo;
        $imagePathFacebook = storage_path() . '/app/public/affiliations/' . $affiliation->brand_facebook;
        $imagePathInstagram = storage_path() . '/app/public/affiliations/' . $affiliation->brand_instagram;
        $imagePathTwitter = storage_path() . '/app/public/affiliations/' . $affiliation->brand_twitter;

        if ($affiliation->delete()) {
            if (File::isFile($imagePath)) {
                unlink($imagePath);
                $affiliation->logo = null;
                $affiliation->update();
            }

            if (File::isFile($imagePathFacebook)) {
                unlink($imagePathFacebook);
                $affiliation->brand_facebook = null;
                $affiliation->update();
            }

            if (File::isFile($imagePathInstagram)) {
                unlink($imagePathInstagram);
                $affiliation->brand_instagram = null;
                $affiliation->update();
            }

            if (File::isFile($imagePathTwitter)) {
                unlink($imagePathTwitter);
                $affiliation->brand_twitter = null;
                $affiliation->update();
            }

            return redirect()
                ->route('admin.franchisees.index')
                ->with('success', 'Exclusão realizada!');
        } else {
            return redirect()
                ->back()
                ->with('error', 'Erro ao excluir!');
        }
    }
}
