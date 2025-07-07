<?php

namespace App\Http\Controllers\Site;

use App\Http\Controllers\Controller;
use App\Mail\Contact;
use App\Models\Affiliation;
use App\Models\Company;
use App\Models\Post;
use App\Models\Vacancy;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;
use Meta;

class SiteController extends Controller
{

    public function index()
    {
        Meta::set('title', env('APP_NAME'));
        Meta::set('robots', 'index,follow');
        Meta::set('description', 'AGENTE INTEGRADOR entre Escola/Universidade e Empresa');
        Meta::set('image', asset('img/hanshake-1400x700.jpg'));
        $vacancies = Vacancy::orderBy('created_at', 'desc')->take(3)->get();
        $posts = Post::orderBy('created_at', 'desc')->take(3)->get();
        return view('site.home.index', compact('vacancies', 'posts'));
    }

    public function company()
    {
        Meta::set('title', env('APP_NAME') . ' - Empresas');
        Meta::set('robots', 'index,follow');
        Meta::set('description', 'Os melhores talentos para a sua empresa.');
        Meta::set('image', asset('img/hanshake-1400x700.jpg'));
        return view('site.company.index');
    }

    public function student()
    {
        Meta::set('title', env('APP_NAME') . ' - Estudantes');
        Meta::set('robots', 'index,follow');
        Meta::set('description', 'Dê um passo em direção ao sucesso!');
        Meta::set('image', asset('img/hanshake-1400x700.jpg'));

        $vacancies = Vacancy::inRandomOrder()->limit(10)->get();
        return view('site.students.index', compact('vacancies'));
    }

    public function franches()
    {
        Meta::set('title', env('APP_NAME') . ' - Seja um Franquiado');
        Meta::set('robots', 'index,follow');
        Meta::set('description', 'A melhor Franquia de Estágios!');
        Meta::set('image', asset('img/hanshake-1400x700.jpg'));
        return view('site.franches.index',);
    }

    public function vacancies()
    {
        Meta::set('title', env('APP_NAME') . ' - Vagas');
        Meta::set('robots', 'index,follow');
        Meta::set('description', 'Vagas de estágio e emprego disponíveis na ' . env('APP_NAME'));
        Meta::set('image', asset('img/hanshake-1400x700.jpg'));
        $vacancies = Vacancy::orderBy('created_at', 'desc')->paginate(9);
        return view('site.vacancies.index', compact('vacancies'));
    }

    public function vacanciesInternship()
    {
        Meta::set('title', env('APP_NAME') . ' - Vagas de Estágio');
        Meta::set('robots', 'index,follow');
        Meta::set('description', 'Vagas de estágio disponíveis na ' . env('APP_NAME'));
        Meta::set('image', asset('img/hanshake-1400x700.jpg'));
        $vacancies = Vacancy::where('intended', 'Estágio')->orWhere('intended', 'Estágio ou Emprego')->orderBy('created_at', 'desc')->paginate(9);
        $type = 'Estágio';
        return view('site.vacancies.index', compact('vacancies', 'type'));
    }

    public function vacanciesJob()
    {
        Meta::set('title', env('APP_NAME') . ' - Vagas de Emprego');
        Meta::set('robots', 'index,follow');
        Meta::set('description', 'Vagas de emprego disponíveis na ' . env('APP_NAME'));
        Meta::set('image', asset('img/hanshake-1400x700.jpg'));
        $vacancies = Vacancy::where('intended', 'Emprego')->orWhere('intended', 'Estágio ou Emprego')->orderBy('created_at', 'desc')->paginate(9);
        $type = 'Emprego';
        return view('site.vacancies.index', compact('vacancies', 'type'));
    }

    public function vacancy($slug)
    {

        $vacancy = Vacancy::where('slug', $slug)->first();
        if (empty($vacancy->id)) {
            abort(404, 'Página não encontrada');
        }

        $vacancy->views += 1;
        $vacancy->update();

        $vacancies = Vacancy::whereNotIn('id', [$vacancy->id])->inRandomOrder()->limit(3)->get();

        Meta::set('title', env('APP_NAME') . ' - ' . $vacancy->title);
        Meta::set('robots', 'index,follow');
        Meta::set('description', $vacancy->title . ' - ' . $vacancy->city . '-' . $vacancy->state);
        Meta::set('image', $vacancy->brand_facebook ? url('storage/vacancies/' . $vacancy->brand_facebook) : asset('img/hanshake-1400x700.jpg'));
        return view('site.vacancies.item', compact('vacancy', 'vacancies'));
    }

    public function posts()
    {
        Meta::set('title', env('APP_NAME') . ' - Blog');
        Meta::set('robots', 'index,follow');
        Meta::set('description', 'Confira as últimas postagens na ' . env('APP_NAME'));
        Meta::set('image', asset('img/post-1152x768.jpg'));
        $posts = Post::orderBy('created_at', 'desc')->paginate(9);
        return view('site.blog.index', compact('posts'));
    }

    public function post($slug)
    {

        $post = Post::where('slug', $slug)->first();
        if (empty($post->id)) {
            abort(404, 'Página não encontrada');
        }

        $post->views += 1;
        $post->update();

        $posts = Post::whereNotIn('id', [$post->id])->inRandomOrder()->limit(3)->get();

        Meta::set('title', env('APP_NAME') . ' - ' . $post->title);
        Meta::set('robots', 'index,follow');
        Meta::set('description', $post->headline);
        Meta::set('image', $post->brand_facebook ? url('storage/posts/' . $post->brand_facebook) : asset('img/post-1152x768.jpg'));
        return view('site.blog.item', compact('post', 'posts'));
    }

    public function police()
    {
        Meta::set('title', env('APP_NAME') . ' - Política de Privacidade');
        Meta::set('robots', 'index,follow');
        Meta::set('description', 'Política de Privacidade');
        Meta::set('image', asset('img/hanshake-1400x700.jpg'));
        return view('site.police.index');
    }

    public function contact()
    {
        Meta::set('title', env('APP_NAME') . ' - Contato');
        Meta::set('robots', 'index,follow');
        Meta::set('description', 'Fale Conosco!');
        Meta::set('image', asset('img/hanshake-1400x700.jpg'));
        return view('site.contact.index');
    }

    public function sendEmail(Request $request)
    {
        $data = [
            "name" => $request->name,
            "email" => $request->email,
            "msg_subject" => $request->msg_subject,
            "phone_number" =>  $request->phone_number,
            "message" => $request->message
        ];

        $contact = new Contact($data);

        Mail::send($contact);

        return response()->json('success');
    }
}
