@extends('site.master.master')

@section('content')
    <div class="banner-slider-area">
        <div class="banner-slider owl-carousel owl-theme">
            <div class="banner-item item-bg1">
                <div class="d-table">
                    <div class="d-table-cell">
                        <div class="container">
                            <div class="banner-item-content">
                                <span class="bg-warning"></span>
                                <h1>Estudante</h1>
                                <p>As melhores empresas buscam os melhores talentos na {{ env('APP_NAME') }}.</p>
                                <div class="banner-btn">
                                    <a href="{{ route('student') }}" class="default-btn btn-bg-two border-radius-5">Cadastre
                                        seu
                                        currículo <i class='bx bx-chevron-right'></i></a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="banner-item item-bg2">
                <div class="d-table">
                    <div class="d-table-cell">
                        <div class="container">
                            <div class="banner-item-content">
                                <span class="bg-primary"></span>
                                <h1>Empresas</h1>
                                <p>Cadastre-se para contratar os melhores talentos do mercado.</p>
                                <div class="banner-btn">
                                    <a href="{{ route('company') }}"
                                        class="default-btn btn-bg-one border-radius-5 text-dark">Cadastre-se
                                        <i class='bx bx-chevron-right'></i></a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="banner-item item-bg3">
                <div class="d-table">
                    <div class="d-table-cell">
                        <div class="container">
                            <div class="banner-item-content">
                                <span></span>
                                <h1>Seja um Franqueado</h1>
                                <p>Já somos mais de 100 unidades espalhadas pelo Brasil em menos de 1ano.</p>
                                <div class="banner-btn">
                                    <a href="{{ route('franches') }}" class="default-btn btn-bg-two border-radius-5">Conheça
                                        Agora! <i class='bx bx-chevron-right'></i></a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <section class="work-process-area-two pt-100 pb-70">
        <div class="container">
            <div class="row align-items-center justify-content-center">
                <div class="col-lg-7">
                    <div class="row d-flex align-items-end">
                        <div class="col-lg-6 col-sm-6">
                            <div class="work-process-card-two">
                                <div class="number-title"><i class="bx bx-target-lock"></i></div>
                                <h3>Missão</h3>
                                <p>Proporcionar ao jovem a oportunidade de iniciar a carreira profissional.</p>
                            </div>
                        </div>
                        <div class="col-lg-6 col-sm-6">
                            <div class="work-process-card-two">
                                <div class="number-title"><i class="bx bxs-binoculars"></i></div>
                                <h3>Visão</h3>
                                <p>Ser referência no mercado como uma empresa que integra e desenvolve os jovens
                                    para o
                                    mercado de trabalho.</p>
                            </div>
                        </div>
                    </div>
                    <div class="row d-flex justify-content-center">
                        <div class="col-lg-6 col-sm-6">
                            <div class="work-process-card-two">
                                <div class="number-title"><i class="bx bx-award"></i></div>
                                <h3>Valores</h3>
                                <p>Ética, Integração, Inovação, Assertividade e Agilidade.</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-5">
                    <div class="work-process-rightside">
                        <div class="section-title">
                            <span class="sp-color1">Nosso Processo de Trabalho</span>
                            <h2>Somos uma empresa (AGENTE INTEGRADOR entre Escola/Universidade e Empresa)
                                Baseada na Lei de estágio 11.788</h2>
                            <p>Consideramos o estágio um ato educativo escolar, desenvolvido no ambiente de trabalho,
                                que
                                visa à preparação para o trabalho produtivo de educandos que estejam frequentando o
                                ensino
                                regular em instituições de educação superior, de educação profissional, de ensino médio,
                                da
                                educação especial e dos anos finais do ensino fundamental, na modalidade profissional da
                                educação de jovens e adultos.
                            </p>
                        </div>
                        <a href="#contato" class="default-btn btn-bg-two border-radius-5 text-center">Saiba Mais</a>
                    </div>
                </div>
            </div>
        </div>
    </section>


    <div class="about-area about-bg2 pt-100 pb-70">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6">
                    <div class="about-img-5">
                        <img src="{{ asset('img/trainee.png') }}" alt="About Images">
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="about-content-3 ml-20">
                        <div class="section-title">
                            <span class="sp-color2">Para seus Desafios!</span>
                            <h2>Otimizando processos de seleção com recursos de TI</h2>
                            <p>Uma franquia especializada no processo de recrutamento, seleção e gestão de estagiários.
                                Nosso objetivo é identificar, selecionar e entregar os melhores candidatos para
                                integração entre empresa e escola.</p>
                            <p>Com o uso de um sistema de autogestão de estagiários conseguimos desburocratizar todo o
                                processo de contratação, possibilitando o acesso à informação de forma rápida e
                                acessível aos nossos
                                clientes e tendo assertividade na entrega dos candidatos às vagas.</p>
                        </div>
                        <h3>Nossas Soluções em serviços Digitais</h3>
                        <div class="all-skill-bar">
                            <div class="skill-bar" data-percentage="50%">
                                <h4 class="progress-title-holder clearfix">
                                    <span class="progress-title">Análises de Perfil</span>
                                    <span class="progress-number-wrapper">
                                        <span class="progress-number-mark">
                                            <span class="percent"></span>
                                        </span>
                                    </span>
                                </h4>
                                <div class="progress-content-outter">
                                    <div class="progress-content"></div>
                                </div>
                            </div>
                            <div class="skill-bar mb-0" data-percentage="50%">
                                <h4 class="progress-title-holder clearfix">
                                    <span class="progress-title">Relatórios</span>
                                    <span class="progress-number-wrapper">
                                        <span class="progress-number-mark">
                                            <span class="percent"></span>
                                        </span>
                                    </span>
                                </h4>
                                <div class="progress-content-outter">
                                    <div class="progress-content"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <section class="services-area-four pt-100 pb-70">
        <div class="container">
            <div class="section-title text-center">
                <span class="sp-color2">Vagas Cadastradas</span>
                <h2>Confira nossas últimas vagas!</h2>
            </div>
            <div class="row justify-content-center align-items-center pt-45">

                @forelse ($vacancies as $vacancy)
                    <div class="col-lg-4 col-md-6">
                        <div class="services-card services-card-color-bg2">
                            <a href="{{ route('vacancy', ['slug' => $vacancy->slug]) }}">
                                <img src="{{ $vacancy->brand_facebook ? url('storage/vacancies/' . $vacancy->brand_facebook) : asset('img/hanshake-1400x700.jpg') }}"
                                    alt="{{ $vacancy->title }}">
                            </a>
                            <h3><a href="{{ route('vacancy', ['slug' => $vacancy->slug]) }}">{{ $vacancy->title }}</a>
                            </h3>
                            <p>{{ Str::limit($vacancy->description, 80) }}</p>
                            <a href="{{ route('vacancy', ['slug' => $vacancy->slug]) }}" class="learn-btn">Saiba Mais
                                <i class='bx bx-chevron-right'></i></a>
                        </div>
                    </div>
                @empty
                    Em breve...
                @endforelse

            </div>
        </div>
    </section>

    <section class="services-area pt-100 pb-70">
        <div class="container">
            <div class="section-title text-center">
                <h2>Oportunidade de Negócio</h2>
            </div>
            <div class="row pt-45">
                <div class="col-lg-3 col-sm-6">
                    <div class="services-card" style="height: 250px">
                        <i class="bx bx-arrow-from-bottom"></i>
                        <h3>Alta</a></h3>
                        <p>Lucratividade</p>
                    </div>
                </div>
                <div class="col-lg-3 col-sm-6">
                    <div class="services-card" style="height: 250px">
                        <i class="bx bx-arrow-to-bottom"></i>
                        <h3>Segmento com pouca concorrência</a></h3>
                        <p>E os que atendem são carentes em serviços de inovação</p>
                    </div>
                </div>
                <div class="col-lg-3 col-sm-6">
                    <div class="services-card" style="height: 250px">
                        <i class="bx bx-money-withdraw"></i>
                        <h3>Baixo investimento</a></h3>
                        <p>Alto retorno</p>
                    </div>
                </div>
                <div class="col-lg-3 col-sm-6">
                    <div class="services-card" style="height: 250px">
                        <i class="bx bx-timer"></i>
                        <h3>Recorrência Fixa</a></h3>
                        <p>Contrato de Estagiário tem durabilidade de dois anos</p>
                    </div>
                </div>
            </div>
            <div class="row pt-10 d-flex justify-content-center">
                <div class="col-lg-3 col-sm-6">
                    <div class="services-card" style="height: 250px">
                        <i class="bx bx-building"></i>
                        <h3>Nosso clientes são Empresas</a></h3>
                        <p>Com baixíssimos riscos de inadimplência</p>
                    </div>
                </div>
                <div class="col-lg-3 col-sm-6">
                    <div class="services-card" style="height: 250px">
                        <i class="bx bx-line-chart"></i>
                        <h3><a href="service-details.html">Mercado em</a></h3>
                        <p>Crescente Expansão</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <div class="case-study-area about-bg2 pt-100 pb-70">
        <div class="container">
            <div class="section-title text-center">
                <span class="sp-color2">Blog</span>
                <h2>Confira nossas últimas postagens</h2>
            </div>
            <div class="row pt-45 justify-content-center">
                @forelse ($posts as $post)
                    <div class="col-lg-4 col-md-6">
                        <div class="blog-item">
                            <div class="blog-img3">
                                <a href="{{ route('post', ['slug' => $post->slug]) }}">
                                    <img src="{{ $post->brand_facebook ? url('storage/posts/' . $post->brand_facebook) : asset('img/post-1152x768.jpg') }}"
                                        alt="{{ $post->title }}">
                                </a>
                                <div class="blog-tag">
                                    <h3>{{ $post->created_at->format('d') }}</h3>
                                    @php
                                        switch ($post->created_at->format('M')) {
                                            case 'May':
                                                $month = 'Mai';
                                                break;
                                            case 'Aug':
                                                $month = 'Ago';
                                                break;
                                            case 'Sep':
                                                $month = 'Set';
                                                break;
                                            case 'Oct':
                                                $month = 'Out';
                                                break;
                                            case 'Dec':
                                                $month = 'Dez';
                                                break;
                                            default:
                                                $month = $post->created_at->format('M');
                                                break;
                                        }
                                    @endphp
                                    <span>{{ $month }}</span><br />
                                    <span>{{ $post->created_at->format('Y') }}</span>
                                </div>
                            </div>
                            <div class="content">
                                <h3>
                                    <a href="{{ route('post', ['slug' => $post->slug]) }}">{{ $post->title }}</a>
                                </h3>
                                <p> {{ Str::limit($post->headline, 80) }}</p>
                                <a href="{{ route('post', ['slug' => $post->slug]) }}" class="read-btn">Veja Mais
                                    <i class='bx bx-chevron-right'></i></a>
                            </div>
                        </div>
                    </div>
                @empty
                    Em breve...
                @endforelse

            </div>
        </div>
    </div>
@endsection
