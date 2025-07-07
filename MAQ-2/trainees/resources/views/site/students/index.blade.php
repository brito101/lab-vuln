@extends('site.master.master')

@section('content')
    <div class="inner-banner">
        <div class="container">
            <div class="inner-title text-center">
                <h3>O que fazemos?</h3>
                <ul>
                    <li>Estudantes</li>
                </ul>
            </div>
        </div>
        <div class="inner-shape">
            <img src="assets/images/shape/inner-shape.png" alt="Images">
        </div>
    </div>

    <div class="service-details-area pt-100 pb-70">
        <div class="container">
            <div class="row">
                <div class="col-lg-8">
                    <div class="service-article">
                        <div class="service-article-img">
                            <img src="{{ asset('img/students-800x400.jpg') }}" alt="Images">
                        </div>
                        <div class="service-article-content">
                            <h2>Bem vindo ao primeiro passo para sua carreira!</h2>
                            <p>
                                O estágio que você tanto procura está bem aqui!
                                Siga o passo a passo abaixo para cadastrar o seu currículo:
                            </p>
                            <div class="row">
                                <div class="col-lg-6 col-md-6">
                                    <ul class="service-article-list service-article-rs">
                                        <li><i class="bx bxs-check-circle"></i>Preencha seus dados iniciais clicando em
                                            Cadastre-se</li>
                                        <li><i class="bx bxs-check-circle"></i>Preencha seus dados pessoais</li>
                                    </ul>
                                </div>
                                <div class="col-lg-6 col-md-6">
                                    <ul class="service-article-list">
                                        <li><i class="bx bxs-check-circle"></i>Preencha seus dados escolares</li>
                                        <li><i class="bx bxs-check-circle"></i>Confira seu currículo</li>
                                    </ul>
                                </div>
                            </div>

                            <div class="contact-form-area pt-5 pb-5">
                                <div class="container">
                                    <div class="section-title text-center">
                                        <h2>Dê um passo em direção ao sucesso!</h2>
                                    </div>
                                    <div class="row pt-20">
                                        <div class="col-12">
                                            <div class="contact-form">
                                                <form action="{{ route('register') }}" method="POST" novalidate="true">
                                                    @csrf
                                                    <div class="row">
                                                        <div class="col-lg-6">
                                                            <div class="form-group">
                                                                <label>Nome <span>*</span></label>
                                                                <input type="text" name="name" id="name"
                                                                    class="form-control" required=""
                                                                    data-error="Por favor, informe seu Nome completo"
                                                                    placeholder="Nome completo">
                                                                <div class="help-block with-errors"></div>
                                                            </div>
                                                        </div>
                                                        <div class="col-lg-6">
                                                            <div class="form-group">
                                                                <label>E-mail<span>*</span></label>
                                                                <input type="email" name="email" id="email"
                                                                    class="form-control" required=""
                                                                    data-error="Por favor, informe um e-mail"
                                                                    placeholder="E-mail">
                                                                <div class="help-block with-errors"></div>
                                                            </div>
                                                        </div>
                                                        <div class="col-lg-6">
                                                            <div class="form-group">
                                                                <label>Senha <span>*</span></label>
                                                                <input type="password" name="password" id="password"
                                                                    required="" data-error="Por favor, uma senha "
                                                                    class="form-control" placeholder="*****">
                                                                <div class="help-block with-errors"></div>
                                                            </div>
                                                        </div>
                                                        <div class="col-lg-6">
                                                            <div class="form-group">
                                                                <label>Confirme sua senha <span>*</span></label>
                                                                <input type="password" name="password_confirmation"
                                                                    id="password_confirmation" class="form-control"
                                                                    required=""
                                                                    data-error="Por favor, confirme sua senha"
                                                                    placeholder="*****">
                                                                <div class="help-block with-errors"></div>
                                                            </div>
                                                        </div>

                                                        <div class="col-lg-12 col-md-12 text-center">
                                                            <button type="submit"
                                                                class="default-btn btn-bg-two border-radius-5 disabled"
                                                                style="pointer-events: all; cursor: pointer;">Cadastre-se
                                                                <i class="bx bx-chevron-right"></i>
                                                            </button>
                                                        </div>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="service-article-another">
                            <h2>Não espere mais para conquistar uma carreira de sucesso!</h2>
                            <p>Aqui você encontrará a oportunidade de estágio para se destacar no mercado.</p>
                            <div class="row">
                                <div class="col-lg-6 col-sm-6">
                                    <div class="service-article-another-img">
                                        <img src="{{ asset('img/student-left-500x300.jpg') }}" alt="Images">
                                    </div>
                                </div>
                                <div class="col-lg-6 col-sm-6">
                                    <div class="service-article-another-img">
                                        <img src="{{ asset('img/student-right-500x300.jpg') }}" alt="Images">
                                    </div>
                                </div>
                            </div>
                            <p>
                                <a href="{{ route('register') }}" class="default-btn btn-bg-two border-radius-5 disabled"
                                    style="pointer-events: all; cursor: pointer;">Cadastre-se
                                    <i class="bx bx-chevron-right"></i>
                                </a>
                                <a href="{{ route('login') }}" class="default-btn btn-bg-two border-radius-5 disabled"
                                    style="pointer-events: all; cursor: pointer;">Login
                                    <i class="bx bx-chevron-right"></i>
                                </a>
                            </p>
                        </div>
                        <div class="service-work-process">
                            <h2>Faça a conexão com a conquista do seu futuro!
                            </h2>
                            <p>De forma rápida e simples você abre oportunidades para se conectar com o sucesso da sua
                                carreira.
                            </p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="side-bar-area">
                        <div class="side-bar-widget">
                            <h3 class="title">Conquiste sua
                                grande oportunidade!</h3>
                            <div class="side-bar-categories">
                                <ul>
                                    <li>
                                        <div class="line-circle"></div>
                                        <a>Seu currículo estará em evidência e
                                            conectado com um banco de dados constantemente atualizado para novos
                                            talentos</a>
                                    </li>
                                    <li>
                                        <div class="line-circle"></div>
                                        <a>Aqui existem inúmeras possibilidades
                                            para que seu cadastro se torne a tão sonhada oportunidade do mercado de
                                            trabalho</a>
                                    </li>
                                    <li>
                                        <div class="line-circle"></div>
                                        <a>Seu currículo estará em atencioso
                                            monitoramento, o ligando a muito mais possibilidades de vagas ideais para o seu
                                            perfil</a>
                                    </li>
                                    <li>
                                        <div class="line-circle"></div>
                                        <a>As atualizações de oportunidades são constantes, criando muito mais
                                            possibilidades de surgirem processos seletivos para você</a>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <div class="side-bar-widget">
                            <h3 class="title">Suas chances de conquistar o mercado de trabalho são reais com a nossa
                                plataforma!</h3>
                            <ul class="side-bar-widget-tag">
                                @foreach ($vacancies as $vacancy)
                                    <li><a href="{{ route('vacancy', ['slug' => $vacancy->slug]) }}"
                                            target="_blank">{{ $vacancy->title }}</a></li>
                                @endforeach
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection
