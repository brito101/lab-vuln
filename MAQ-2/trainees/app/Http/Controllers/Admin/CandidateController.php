<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\CandidateRequest;
use App\Models\Candidate;
use App\Models\Vacancy;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class CandidateController extends Controller
{
    public function candidateStore(CandidateRequest $request)
    {
        if (!Auth::user()->hasRole('Estagiário')) {
            abort(403, 'Acesso não autorizado');
        }

        $vacancy = Vacancy::where('id', $request->vacancy_id)->first();

        if (empty($vacancy->id)) {
            abort(403, 'Acesso não autorizado');
        }

        $data = $request->all();
        $data['user_id'] = Auth::user()->id;

        $candidate = Candidate::create($data);

        if ($candidate) {
            return redirect()
                ->route('admin.vacancies.show', ['vacancy' => $vacancy->id])
                ->with('success', 'Candidatura realizada!');
        } else {
            return redirect()
                ->back()
                ->withInput()
                ->with('error', 'Erro ao candidatar!');
        }
    }

    public function candidateCancel(CandidateRequest $request)
    {
        if (!Auth::user()->hasRole('Estagiário')) {
            abort(403, 'Acesso não autorizado');
        }

        $vacancy = Vacancy::where('id', $request->vacancy_id)->first();

        if (empty($vacancy->id)) {
            abort(403, 'Acesso não autorizado');
        }

        $candidate = Candidate::where('vacancy_id', $vacancy->id)
            ->where('user_id', Auth::user()->id)->first();

        if ($candidate->delete()) {
            return redirect()
                ->route('admin.vacancies.show', ['vacancy' => $vacancy->id])
                ->with('success', 'Candidatura cancelada!');
        } else {
            return redirect()
                ->back()
                ->withInput()
                ->with('error', 'Erro ao cancelar!');
        }
    }

    public function candidateJson(CandidateRequest $request)
    {
        if (!Auth::user()->hasRole('Estagiário')) {
            return response()->json(['status' => 'error', 'message' => 'Acesso não autorizado']);
        }

        $vacancy = Vacancy::where('id', $request->vacancy_id)->first();

        if (empty($vacancy->id)) {
            return response()->json(['status' => 'error', 'message' => 'Acesso não autorizado']);
        }

        $candidate = Candidate::where('vacancy_id', $vacancy->id)
            ->where('user_id', Auth::user()->id)->first();

        if ($request->option == 'cancel') {
            if ($candidate->delete()) {
                return response()->json([
                    'status' => 'success',
                    'message' => '<i data-vacancy="candidate" data-id="' . $vacancy->id . '" class="text-danger fa fa-lg fa-thumbs-down candidate" style="cursor: pointer" title="Clique para se candidatar"></i>'
                ]);
            } else {
                return response()->json(['status' => 'error', 'message' => 'Acesso não autorizado']);
            }
        }

        if ($request->option == 'candidate') {
            $data = $request->all();
            $data['user_id'] = Auth::user()->id;
            $candidate = Candidate::create($data);
            if ($candidate) {
                return response()->json([
                    'status' => 'success',
                    'message' => '<i data-vacancy="cancel" data-id="' . $vacancy->id . '" class="text-success fa fa-lg fa-thumbs-up candidate" style="cursor: pointer" title="Clique para cancelar a candidatura"></i>'
                ]);
            } else {
                return response()->json(['status' => 'error', 'message' => 'Acesso não autorizado']);
            }
        }
    }
}
