<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Academic;
use App\Models\Company;
use App\Models\Extra;
use App\Models\User;
use App\Models\Vacancy;
use Illuminate\Http\Request;
use Illuminate\Support\Arr;
use Illuminate\Support\Facades\Auth;
use stdClass;

class CompatibilityController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */

    public function index()
    {
        if (!Auth::user()->hasPermissionTo('Visualizar Compatibilidade')) {
            abort(403, 'Acesso não autorizado');
        }

        if (Auth::user()->hasRole('Franquiado')) {
            $companies = Company::where('affiliation_id', Auth::user()->affiliation_id)->get();
            $vacancies = Vacancy::whereIn('company_id', $companies->pluck('id'))->get();
            $trainees = User::role('Estagiário')->whereIn('state', $companies->pluck('state'))->orderBy('created_at', 'desc')->paginate(10);
        } else {
            $vacancies = Vacancy::all();
            $trainees = User::role('Estagiário')->orderBy('created_at', 'desc')->paginate(10);
        }

        $chart = new \stdClass();
        $chart->trainee = [];

        foreach ($trainees as $trainee) {
            $data  = [];
            foreach ($vacancies as $vacancy) {

                $listAcadmics = [];
                $academics = Academic::where('user_id', $trainee->id)->get();
                foreach ($academics as $academic) {
                    $listAcadmics['area'] = $academic->course['name'];
                }

                $listExtraCourses = [];
                $extras = Extra::where('user_id', $trainee->id)->get();
                foreach ($extras as $extra) {
                    $listExtraCourses['area'] = $extra->course['name'];
                }

                $points = 0;

                /** curso acadêmicos */
                foreach (array_values($listAcadmics) as $val) {
                    if (strpos($vacancy->courses, $val) !== false) {
                        $points += 1;
                    }
                }

                /** curso extracurricular */
                foreach (array_values($listExtraCourses) as $val) {
                    if (strpos($vacancy->courses, $val) !== false) {
                        $points += 1;
                    }
                }

                /** escolaridade */
                if (strpos(implode(", ", array_values($trainee->academics->pluck('scholarity_id')->toArray())), (string)$vacancy->scholarity_id) !== false) {
                    $points += 1;
                }

                /** disponibilidade */
                if (strpos(implode(", ", array_values($trainee->academics->pluck('availability')->toArray())), $vacancy->period) !== false) {
                    $points += 1;
                }

                /** estado */
                if ($vacancy->state == $trainee->state) {
                    $points  += 0.5;
                }

                /** cidade e estado */
                if ($vacancy->city == $trainee->city) {
                    $points  += 0.5;
                }

                $total = $points * 20;
                $data[$vacancy->id] = $total;
            }
            $listValues[] = ($data);
            $chart->trainee[] = '#' . $trainee->id . ' ' . $trainee->name;
        }

        $finalList = [];
        foreach ($vacancies as $vacancy) {
            $listData['vacancy'] = '#' . $vacancy->id . '-' . $vacancy->title;
            $listData['values'] = Arr::pluck($listValues, $vacancy->id);
            $finalList[] = $listData;
        }

        return view('admin.compatibility.index', compact('chart', 'finalList', 'trainees'));
    }

    public function report()
    {
        if (!Auth::user()->hasPermissionTo('Visualizar Relatório de Compatibilidade')) {
            abort(403, 'Acesso não autorizado');
        }

        if (Auth::user()->hasRole('Franquiado')) {
            $companies = Company::where('affiliation_id', Auth::user()->affiliation_id)->get();
            $vacancies = Vacancy::whereIn('company_id', $companies->pluck('id'))->get();
            $trainees = User::role('Estagiário')->whereIn('state', $companies->pluck('state'))->orderBy('created_at', 'desc')->paginate(9);
        } else {
            $vacancies = Vacancy::all();
            $trainees = User::role('Estagiário')->orderBy('created_at', 'desc')->paginate(9);
        }

        foreach ($trainees as $trainee) {
            foreach ($vacancies as $vacancy) {

                $listAcadmics = [];
                $academics = Academic::where('user_id', $trainee->id)->get();
                foreach ($academics as $academic) {
                    $listAcadmics['area'] = $academic->course['name'];
                }

                $listExtraCourses = [];
                $extras = Extra::where('user_id', $trainee->id)->get();
                foreach ($extras as $extra) {
                    $listExtraCourses['area'] = $extra->course['name'];
                }

                $points = 0;

                /** curso acadêmicos */
                foreach (array_values($listAcadmics) as $val) {
                    if (strpos($vacancy->courses, $val) !== false) {
                        $points += 1;
                    }
                }

                /** curso extracurricular */
                foreach (array_values($listExtraCourses) as $val) {
                    if (strpos($vacancy->courses, $val) !== false) {
                        $points += 1;
                    }
                }

                /** escolaridade */
                if (strpos(implode(", ", array_values($trainee->academics->pluck('scholarity_id')->toArray())), (string)$vacancy->scholarity_id) !== false) {
                    $points += 1;
                }

                /** disponibilidade */
                if (strpos(implode(", ", array_values($trainee->academics->pluck('availability')->toArray())), $vacancy->period) !== false) {
                    $points += 1;
                }

                /** estado */
                if ($vacancy->state == $trainee->state) {
                    $points  += 0.5;
                }

                /** cidade e estado */
                if ($vacancy->city == $trainee->city && $vacancy->state == $trainee->state) {
                    $points  += 0.5;
                }

                $total = $points * 20;
                $vacancy->total = $total;
            }
        }

        return view('admin.compatibility.report', compact('trainees', 'vacancies'));
    }

    public function reportPdf()
    {
        if (!Auth::user()->hasPermissionTo('Visualizar Relatório de Compatibilidade')) {
            abort(403, 'Acesso não autorizado');
        }

        if (Auth::user()->hasRole('Franquiado')) {
            $companies = Company::where('affiliation_id', Auth::user()->affiliation_id)->get();
            $vacancies = Vacancy::whereIn('company_id', $companies->pluck('id'))->get();
            $trainees = User::role('Estagiário')->whereIn('state', $companies->pluck('state'))->orderBy('created_at', 'desc')->paginate(9);
        } else {
            $vacancies = Vacancy::all();
            $trainees = User::role('Estagiário')->orderBy('created_at', 'desc')->paginate(9);
        }

        foreach ($trainees as $trainee) {
            foreach ($vacancies as $vacancy) {

                $listAcadmics = [];
                $academics = Academic::where('user_id', $trainee->id)->get();
                foreach ($academics as $academic) {
                    $listAcadmics['area'] = $academic->course['name'];
                }

                $listExtraCourses = [];
                $extras = Extra::where('user_id', $trainee->id)->get();
                foreach ($extras as $extra) {
                    $listExtraCourses['area'] = $extra->course['name'];
                }

                $points = 0;

                /** curso acadêmicos */
                foreach (array_values($listAcadmics) as $val) {
                    if (strpos($vacancy->courses, $val) !== false) {
                        $points += 1;
                    }
                }

                /** curso extracurricular */
                foreach (array_values($listExtraCourses) as $val) {
                    if (strpos($vacancy->courses, $val) !== false) {
                        $points += 1;
                    }
                }

                /** escolaridade */
                if (strpos(implode(", ", array_values($trainee->academics->pluck('scholarity_id')->toArray())), (string)$vacancy->scholarity_id) !== false) {
                    $points += 1;
                }

                /** disponibilidade */
                if (strpos(implode(", ", array_values($trainee->academics->pluck('availability')->toArray())), $vacancy->period) !== false) {
                    $points += 1;
                }

                /** estado */
                if ($vacancy->state == $trainee->state) {
                    $points  += 0.5;
                }

                /** cidade e estado */
                if ($vacancy->city == $trainee->city) {
                    $points  += 0.5;
                }

                $total = $points * 20;
                $vacancy->total = $total;
            }
        }
        return view('admin.compatibility.pdf', compact('trainees', 'vacancies'));
    }
}
