<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Academic;
use App\Models\Company;
use App\Models\User;
use App\Models\Vacancy;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class TraineeController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        if (!Auth::user()->hasPermissionTo('Visualizar Estagiários')) {
            abort(403, 'Acesso não autorizado');
        }

        if (Auth::user()->hasRole('Franquiado')) {
            $companies = Company::where('affiliation_id', Auth::user()->affiliation_id)->get();
            $trainees = User::role('Estagiário')->whereIn('state', $companies->pluck('state'))->orderBy('created_at', 'desc')->paginate(9);
        } elseif (Auth::user()->hasRole('Empresário')) {
            $companies = Company::where('id', Auth::user()->company_id)->get();
            $trainees = User::role('Estagiário')->whereIn('state', $companies->pluck('state'))->orderBy('created_at', 'desc')->paginate(9);
        } else {
            $trainees = User::role('Estagiário')->orderBy('created_at', 'desc')->paginate(9);
        }

        return view('admin.trainees.index', compact('trainees'));
    }

    public function indexSearch(Request $request)
    {
        if (!Auth::user()->hasPermissionTo('Visualizar Estagiários')) {
            abort(403, 'Acesso não autorizado');
        }

        if ($request['academics']) {
            $academics = Academic::where('name', 'like', '%' . $request['academics'] . '%')->pluck('user_id');
        } else {
            $academics = Academic::all()->pluck('user_id');
        }

        if (Auth::user()->hasRole('Franquiado')) {
            $companies = Company::where('affiliation_id', Auth::user()->affiliation_id)->get();
            $trainees = User::role('Estagiário')
                ->where(function ($query) use ($request, $academics) {
                    if ($request->name) {
                        $query->where('name', 'like', '%' . $request['name'] . '%');
                    }
                    if ($request->city) {
                        $query->where('city', $request->city);
                    }
                    if ($request->state) {
                        $query->where('state', $request->state);
                    }
                    if ($request->academics) {
                        $query->whereIn('id', $academics);
                    }
                })
                ->whereIn('state', $companies->pluck('state'))
                ->orderBy('created_at', 'desc')
                ->get();
        } elseif (Auth::user()->hasRole('Empresário')) {
            $companies = Company::where('id', Auth::user()->company_id)->get();
            $trainees = User::role('Estagiário')
                ->where(function ($query) use ($request, $academics) {
                    if ($request->name) {
                        $query->where('name', 'like', '%' . $request['name'] . '%');
                    }
                    if ($request->city) {
                        $query->where('city', $request->city);
                    }
                    if ($request->state) {
                        $query->where('state', $request->state);
                    }
                    if ($request->academics) {
                        $query->whereIn('id', $academics);
                    }
                })
                ->whereIn('state', $companies->pluck('state'))
                ->orderBy('created_at', 'desc')
                ->get();
        } else {
            $trainees = User::role('Estagiário')
                ->where(function ($query) use ($request, $academics) {
                    if ($request->name) {
                        $query->where('name', 'like', '%' . $request['name'] . '%');
                    }
                    if ($request->city) {
                        $query->where('city', $request->city);
                    }
                    if ($request->state) {
                        $query->where('state', $request->state);
                    }
                    if ($request->academics) {
                        $query->whereIn('id', $academics);
                    }
                })
                ->orderBy('created_at', 'desc')
                ->get();
        }

        return view('admin.trainees.index', compact('trainees'));
    }


    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        if (!Auth::user()->hasPermissionTo('Visualizar Estagiários')) {
            abort(403, 'Acesso não autorizado');
        }

        $user = User::role('Estagiário')
            ->where('id', $id)->first();

        if (empty($user->id)) {
            abort(403, 'Acesso não autorizado');
        }

        return view('admin.curriculums.curriculum', compact('user'));
    }

    public function vacancy($id)
    {
        if (!Auth::user()->hasPermissionTo('Visualizar Estagiários')) {
            abort(403, 'Acesso não autorizado');
        }

        $vacancies = Vacancy::where('id', $id)->first();

        if (empty($vacancies->id)) {
            abort(403, 'Acesso não autorizado');
        }

        $trainees = User::role('Estagiário')
            ->whereIn('id', $vacancies->candidate->pluck('user_id'))
            ->orderBy('created_at', 'desc')
            ->paginate(9);

        return view('admin.trainees.index', compact('trainees'));
    }
}
