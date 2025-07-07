<!--
@born  Oct 14, 2022
@author  Rodrigo Brito <contato@rodrigobrito.dev.br>
-->

<!doctype html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preload" href="{{ asset('css/app.css') }}" as="style">
    <link rel="stylesheet" href="{{ asset('css/app.css') }}">
    <link rel="stylesheet" href="{{ asset('site/css/animate.min.css') }}">
    <link rel="stylesheet" href="{{ asset('site/boxicons/css/boxicons.min.css') }}">
    <link rel="icon" href="{{ asset('img/favicon.png') }}" type="image/png">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    @metas
</head>

<body>
    <div class="preloader">
        <div class="d-table">
            <div class="d-table-cell">
                <div class="spinner"></div>
            </div>
        </div>
    </div>

    <header class="top-header top-header-bg">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-7 col-md-6">
                    <div class="top-head-left">
                        <div class="top-contact">
                            <h3>Suporte : <a href="tel:{{ env('TEL_SUPPORT') }}">{{ env('TEL_SUPPORT') }}</a>
                            </h3>
                        </div>
                    </div>
                </div>
                <div class="col-lg-5 col-md-6">
                    <div class="top-header-right">
                        <div class="top-header-social top-header-social-bg">
                            <ul>
                                <li>
                                    <a href="https://www.facebook.com/profile.php?id=100076260017396 target="_blank">
                                        <i class='bx bxl-facebook'></i>
                                    </a>
                                </li>
                                {{-- <li>
                                    <a href="https://twitter.com/?lang=pt-BR" target="_blank">
                                        <i class='bx bxl-twitter'></i>
                                    </a>
                                </li> --}}
                                {{-- <li>
                                    <a href="https://www.linkedin.com/" target="_blank">
                                        <i class='bx bxl-linkedin-square'></i>
                                    </a>
                                </li> --}}
                                <li>
                                    <a href="https://www.instagram.com/alfaestagio/" target="_blank">
                                        <i class='bx bxl-instagram'></i>
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </header>


    <div class="navbar-area">
        <div class="mobile-nav">
            <a href="{{ route('home') }}" class="logo text-primary">
                {{ env('APP_NAME') }}
            </a>
        </div>

        <div class="main-nav">
            <div class="container">
                <nav class="navbar navbar-expand-md navbar-light ">
                    <a class="navbar-brand text-primary" href="{{ route('home') }}">
                        {{ env('APP_NAME') }}
                    </a>
                    <div class="collapse navbar-collapse mean-menu" id="navbarSupportedContent">
                        <ul class="navbar-nav m-auto">
                            <li class="nav-item">
                                <a href="{{ route('home') }}"
                                    class="nav-link {{ Route::currentRouteName() == 'home' ? 'active' : '' }}">
                                    Home
                                </a>
                            </li>
                            <li class="nav-item">
                                <a href="#"
                                    class="nav-link {{ Route::currentRouteName() == 'company' || Route::currentRouteName() == 'student' ? 'active' : '' }}">
                                    O que fazemos?
                                    <i class='bx bx-caret-down'></i>
                                </a>
                                <ul class="dropdown-menu">
                                    <li class="nav-item">
                                        <a href="{{ route('student') }}" class="nav-link">
                                            Estudantes
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="{{ route('company') }}" class="nav-link">
                                            Empresas
                                        </a>
                                    </li>
                                </ul>
                            </li>
                            <li class="nav-item">
                                <a href="{{ route('vacancies') }}"
                                    class="nav-link {{ Route::currentRouteName() == 'vacancies' || Route::currentRouteName() == 'vacancy' || Route::currentRouteName() == 'vacancies.internship' || Route::currentRouteName() == 'vacancies.job' ? 'active' : '' }}">
                                    Vagas
                                    <i class='bx bx-caret-down'></i>
                                </a>
                                <ul class="dropdown-menu">
                                    <li class="nav-item">
                                        <a href="{{ route('vacancies.internship') }}" class="nav-link">
                                            Estágio
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="{{ route('vacancies.job') }}" class="nav-link">
                                            Emprego
                                        </a>
                                    </li>
                                </ul>
                            </li>

                            {{-- <li class="nav-item">
                                <a href="#"
                                    class="nav-link {{ Route::currentRouteName() == 'units' ? 'active' : '' }}">
                                    Unidades
                                </a>
                            </li> --}}

                            <li class="nav-item">
                                <a href="{{ route('posts') }}"
                                    class="nav-link {{ Route::currentRouteName() == 'posts' || Route::currentRouteName() == 'post' ? 'active' : '' }}">
                                    Blog
                                </a>
                            </li>

                            <li class="nav-item">
                                <a href="{{ route('franches') }}"
                                    class="nav-link {{ Route::currentRouteName() == 'franches' ? 'active' : '' }}">
                                    Seja um franqueado
                                </a>
                            </li>

                            <li class="nav-item">
                                <a href="{{ route('contact') }}"
                                    class="nav-link {{ Route::currentRouteName() == 'contact' ? 'active' : '' }}">
                                    Contato
                                </a>
                            </li>

                        </ul>
                        <div class="nav-side">
                            <div class="nav-side-item">
                                <div class="get-btn">
                                    <a href="{{ route('admin.home') }}"
                                        class="default-btn btn-bg-two border-radius-5 btn-login">Login
                                        <i class='bx bx-chevron-right'></i></a>
                                </div>
                            </div>
                        </div>
                    </div>
                </nav>
            </div>
        </div>
    </div>

    @yield('content')


    <footer class="footer-area footer-bg2">
        <div class="container">
            <div class="footer-top pt-100 pb-70">
                <div class="row">
                    <div class="col-lg-4 col-sm-6">
                        <div class="footer-widget">
                            <div class="footer-logo">
                                <a href="{{ route('home') }}" class="text-white h2">
                                    {{ env('APP_NAME') }}
                                </a>
                            </div>
                            <p>
                                "A vida passa por vários estágios. Um deles é a busca de grandes experiências para se
                                tornar um excelente profissional"
                            </p>
                            <div class="social-link">
                                <ul>
                                    <li>
                                        <a href="https://www.facebook.com/profile.php?id=100076260017396"
                                            target="_blank">
                                            <i class='bx bxl-facebook'></i>
                                        </a>
                                    </li>
                                    {{-- <li>
                                        <a href="https://twitter.com/?lang=en" target="_blank">
                                            <i class='bx bxl-twitter'></i>
                                        </a> --}}
                                    </li>
                                    {{-- <li>
                                        <a href="https://www.linkedin.com/" target="_blank">
                                            <i class='bx bxl-linkedin-square'></i>
                                        </a>
                                    </li> --}}
                                    <li>
                                        <a href="https://www.instagram.com/alfaestagio/" target="_blank">
                                            <i class='bx bxl-instagram'></i>
                                        </a>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-2 col-sm-6">
                        <div class="footer-widget pl-2">
                            <h3>Links</h3>
                            <ul class="footer-list">
                                <li>
                                    <a href="{{ route('vacancies') }}" title="Vagas">
                                        <i class='bx bx-chevron-right'></i>
                                        Vagas
                                    </a>
                                </li>
                                {{-- <li>
                                    <a href="#" title="Unidades">
                                        <i class='bx bx-chevron-right'></i>
                                        Unidades
                                    </a>
                                </li> --}}
                                <li>
                                    <a href="{{ route('posts') }}" title="Blog">
                                        <i class='bx bx-chevron-right'></i>
                                        Blog
                                    </a>
                                </li>
                                <li>
                                    <a href="{{ route('contact') }}" title="Contato">
                                        <i class='bx bx-chevron-right'></i>
                                        Contato
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="col-lg-3 col-sm-6">
                        <div class="footer-widget pl-5">
                            <h3>O que fazemos?</h3>
                            <ul class="footer-list">
                                <li>
                                    <a href="{{ route('student') }}" title="Estudantes">
                                        <i class='bx bx-chevron-right'></i>
                                        Estudantes
                                    </a>
                                </li>
                                <li>
                                    <a href="{{ route('company') }}" title="Empresas">
                                        <i class='bx bx-chevron-right'></i>
                                        Empresas
                                    </a>
                                </li>
                                <li>
                                    <a href="{{ route('franches') }}" title="Franquias">
                                        <i class='bx bx-chevron-right'></i>
                                        Franquias
                                    </a>
                                </li>
                                <li>
                                    <a href="{{ route('police') }}" title="Política de Privacidade">
                                        <i class='bx bx-chevron-right'></i>
                                        Política de Privacidade
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="col-lg-3 col-sm-6">
                        <div class="footer-widget">
                            <h3>Contato</h3>
                            <ul class="footer-contact-list">
                                <li>
                                    <i class="bx bxs-map"></i>
                                    <div class="content">
                                        <a href="#">
                                            Rua Coronel Almeida, 132, Sala 01, Centro Araquari-SC
                                        </a>
                                    </div>
                                </li>
                                <li>
                                    <i class="bx bx-phone-call"></i>
                                    <div class="content">
                                        <a href="tel:0800 915 7000">
                                            0800 915 7000
                                        </a>
                                    </div>
                                </li>
                                <li>
                                    <i class="bx bx bxl-whatsapp"></i>
                                    <div class="content">
                                        <a href="tel:{{ env('TEL_SUPPORT') }}">
                                            {{ env('TEL_SUPPORT') }}
                                        </a>
                                    </div>
                                </li>
                                <li>
                                    <i class="bx bx-message"></i>
                                    <div class="content">
                                        <a href="mailto{{ env('MAIL_SUPPORT') }}">
                                            {{ env('MAIL_SUPPORT') }}
                                        </a>
                                    </div>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
            <div class="copy-right-area">
                <div class="copy-right-text">
                    <p>
                        Copyright © 2022-{{ date('Y') }} {{ env('APP_NAME') }}. Todos os direitos reservados.
                        {{-- <a href="https://rodrigobrito.dev.br" target="_blank">Desenvolvido por Rodrigo Brito</a> --}}
                    </p>
                </div>
            </div>
        </div>
    </footer>


    <div class="switch-box">
        <label id="switch" class="switch">
            <input type="checkbox" onchange="toggleTheme()" id="slider">
            <span class="slider round"></span>
        </label>
    </div>


    <script src="{{ asset('site/js/jquery.min.js') }}"></script>
    <script src="{{ asset('site/js/bootstrap.bundle.min.js') }}"></script>
    <script src="{{ asset('site/js/owl.carousel.min.js') }}"></script>
    <script src="{{ asset('site/js/jquery.magnific-popup.min.js') }}"></script>
    <script src="{{ asset('site/js/jquery.nice-select.min.js') }}"></script>
    <script src="{{ asset('site/js/wow.min.js') }}"></script>
    <script src="{{ asset('site/js/mainmenu.js') }}"></script>
    <script src="{{ asset('site/js/form-validator.min.js') }}"></script>
    <script src="{{ asset('site/js/contact-form-script.js') }}"></script>
    <script src="{{ asset('site/js/custom.js') }}"></script>
</body>

</html>
