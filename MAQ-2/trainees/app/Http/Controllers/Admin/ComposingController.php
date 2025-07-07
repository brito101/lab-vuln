<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\ComposingRequest;
use App\Models\Composing;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ComposingController extends Controller
{
    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit()
    {
        if (!Auth::user()->hasPermissionTo('Editar Redação')) {
            abort(403, 'Acesso não autorizado');
        }
        $composing = Composing::where('user_id', Auth::user()->id)->first();
        return view('admin.composing.edit', compact('composing'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function store(ComposingRequest $request)
    {
        if (!Auth::user()->hasPermissionTo('Editar Redação')) {
            abort(403, 'Acesso não autorizado');
        }

        $composing = Composing::where('user_id', Auth::user()->id)->first();

        $data = $request->all();
        $data['user_id'] = Auth::user()->id;

        if ($composing) {
            $save = $composing->update($data);
        } else {
            $save = Composing::create($data);
        }

        if ($save) {
            return redirect()
                ->route('admin.composing.edit')
                ->with('success', 'Edição realizada!');
        } else {
            return redirect()
                ->back()
                ->withInput()
                ->with('error', 'Erro ao Editar!');
        }
    }
}
