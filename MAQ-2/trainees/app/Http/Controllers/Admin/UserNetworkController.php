<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\UserNetworkRequest;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class UserNetworkController extends Controller
{
    public function edit()
    {
        if (!Auth::user()->hasPermissionTo('Editar Dados Pessoais')) {
            abort(403, 'Acesso não autorizado');
        }
        $user = Auth::user();
        return view('admin.users.social', compact('user'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function store(UserNetworkRequest $request)
    {
        if (!Auth::user()->hasPermissionTo('Editar Dados Pessoais')) {
            abort(403, 'Acesso não autorizado');
        }

        $user = User::where('id', Auth::user()->id)->first();
        if (empty($user->id)) {
            abort(403, 'Acesso não autorizado');
        }

        $data = $request->all();
        if ($user->update($data)) {
            return redirect()
                ->route('admin.userNetwork.edit')
                ->with('success', 'Edição realizada!');
        } else {
            return redirect()
                ->back()
                ->withInput()
                ->with('error', 'Erro ao Editar!');
        }
    }
}
