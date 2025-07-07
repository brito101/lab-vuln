<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\PostRequest;
use App\Models\Post;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Str;

class PostController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        if (!Auth::user()->hasPermissionTo('Listar Posts')) {
            abort(403, 'Acesso não autorizado');
        }
        $posts = Post::where('company_id', Auth::user()->company_id)->get();
        return view('admin.posts.index', compact('posts'));
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        if (!Auth::user()->hasPermissionTo('Criar Posts')) {
            abort(403, 'Acesso não autorizado');
        }
        return view('admin.posts.create');
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(PostRequest $request)
    {
        if (!Auth::user()->hasPermissionTo('Criar Posts')) {
            abort(403, 'Acesso não autorizado');
        }

        $data = $request->all();
        $data['user_id'] = auth()->user()->id;
        $data['company_id'] = auth()->user()->company_id;

        $files = array('cover', 'brand_facebook', 'brand_instagram', 'brand_twitter');
        foreach ($files as $file) {
            if ($request->hasFile($file) && $request->file($file)->isValid()) {
                $name = Str::slug(mb_substr($data['title'], 0, 100)) . '-' . $file . time();

                $extenstion = $request->$file->extension();
                $nameFile = "{$name}.{$extenstion}";

                $data[$file] = $nameFile;

                $upload = $request->$file->storeAs('posts', $nameFile);

                if (!$upload) {
                    return redirect()
                        ->back()
                        ->withInput()
                        ->with('error', 'Falha ao fazer o upload da imagem');
                }
            }
        }
        $post = Post::create($data);

        if ($post->save()) {
            $post->slug = Str::slug($post->title . '-' . $post->id);
            $post->update();
            return redirect()
                ->route('admin.posts.index')
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
        if (!Auth::user()->hasPermissionTo('Editar Posts')) {
            abort(403, 'Acesso não autorizado');
        }

        $post = Post::where('id', $id)
            ->where('company_id', Auth::user()->company_id)->first();

        if (empty($post->id)) {
            abort(403, 'Acesso não autorizado');
        }

        return view('admin.posts.edit', compact('post'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(PostRequest $request, $id)
    {

        if (!Auth::user()->hasPermissionTo('Editar Posts')) {
            abort(403, 'Acesso não autorizado');
        }

        $data = $request->all();
        $data['company_id'] = auth()->user()->company_id;
        $data['user_id'] = auth()->user()->id;

        $post = Post::where('id', $id)
            ->where('company_id', Auth::user()->company_id)->first();

        if (empty($post->id)) {
            abort(403, 'Acesso não autorizado');
        }

        $files = array('cover', 'brand_facebook', 'brand_instagram', 'brand_twitter');
        foreach ($files as $file) {
            if ($request->hasFile($file) && $request->file($file)->isValid()) {
                $name = Str::slug(mb_substr($post['title'], 0, 100)) . '-' . $file . time();
                $imagePath = storage_path() . '/app/public/posts/' . $post->$file;

                if (File::isFile($imagePath)) {
                    unlink($imagePath);
                }

                $extenstion = $request->$file->extension();
                $nameFile = "{$name}.{$extenstion}";

                $data[$file] = $nameFile;

                $upload = $request->$file->storeAs('posts', $nameFile);

                if (!$upload) {
                    return redirect()
                        ->back()
                        ->withInput()
                        ->with('error', 'Falha ao fazer o upload da imagem');
                }
            }
        }

        $data['slug'] = Str::slug($data['title'] . '-' . $post->id);

        if ($post->update($data)) {
            return redirect()
                ->route('admin.posts.index')
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
        if (!Auth::user()->hasPermissionTo('Excluir Posts')) {
            abort(403, 'Acesso não autorizado');
        }

        $post = Post::where('id', $id)
            ->where('company_id', Auth::user()->company_id)->first();

        if (empty($post->id)) {
            abort(403, 'Acesso não autorizado');
        }

        $imagePathCover = storage_path() . '/app/public/posts/' . $post->cover;
        $imagePathFacebook = storage_path() . '/app/public/posts/' . $post->brand_facebook;
        $imagePathInstagram = storage_path() . '/app/public/posts/' . $post->brand_instagram;
        $imagePathTwitter = storage_path() . '/app/public/posts/' . $post->brand_twitter;

        if ($post->delete()) {
            if (File::isFile($imagePathCover)) {
                unlink($imagePathFacebook);
                $post->brand_facebook = null;
                $post->update();
            }

            if (File::isFile($imagePathFacebook)) {
                unlink($imagePathFacebook);
                $post->brand_facebook = null;
                $post->update();
            }

            if (File::isFile($imagePathInstagram)) {
                unlink($imagePathInstagram);
                $post->brand_instagram = null;
                $post->update();
            }

            if (File::isFile($imagePathTwitter)) {
                unlink($imagePathTwitter);
                $post->brand_twitter = null;
                $post->update();
            }

            return redirect()
                ->route('admin.posts.index')
                ->with('success', 'Exclusão realizada!');
        } else {
            return redirect()
                ->back()
                ->with('error', 'Erro ao excluir!');
        }
    }
}
