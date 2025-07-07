@extends('site.master.master')

@section('content')
    <div class="inner-banner">
        <div class="container">
            <div class="inner-title text-center">
                <h3>{{ $vacancy->title }}</h3>
            </div>
        </div>
    </div>

    <div class="blog-details-area pt-100 pb-70">
        <div class="container">
            <div class="row">
                <div class="col-lg-8">
                    <div class="blog-article">
                        <div class="blog-article-img">
                            <img src="{{ $vacancy->brand_facebook ? url('storage/vacancies/' . $vacancy->brand_facebook) : asset('img/hanshake-1400x700.jpg') }}"
                                alt="{{ $vacancy->title }}">
                            <div class="blog-article-tag">
                                <h3>{{ $vacancy->created_at->format('d') }}</h3>
                                @php
                                    switch ($vacancy->created_at->format('M')) {
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
                                            $month = $vacancy->created_at->format('M');
                                            break;
                                    }
                                @endphp
                                <span>{{ $month }}</span><br />
                                <span>{{ $vacancy->created_at->format('Y') }}</span>
                            </div>
                        </div>
                        <div class="blog-article-title">
                            <ul class="pb-3">
                                <li><i class="bx bx-show-alt"></i>{{ $vacancy->views }} Visualizações</li>
                            </ul>
                            <div class="blog-article-share">
                                <div class="row align-items-center">
                                    <div class="col-12">
                                        <div class="blog-tag">
                                            <ul>
                                                <li><i class="bx bx-category"></i> Cursos de Interesse:</li>
                                                <li>{{ $vacancy->courses() }}</li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="side-bar-widget row">
                            <div class="side-bar-categories col-12 col-md-5">
                                <ul>
                                    <li>
                                        <div class="line-circle"></div>
                                        <a href="#" class="disabled">Destinada
                                            para:<span>{{ $vacancy->intended }}</span></a>
                                    </li>
                                    <li>
                                        <div class="line-circle"></div>
                                        <a href="#"
                                            class="disabled">Escolaridade<span>{{ $vacancy->scholarity['name'] }}</span></a>
                                    </li>
                                    <li>
                                        <div class="line-circle"></div>
                                        <a href="#"
                                            class="disabled">Experiência<span>{{ $vacancy->experience }}</span></a>
                                    </li>
                                </ul>
                            </div>
                        </div>

                        <div class="article-content pb-3">
                            {{ $vacancy->description }}
                        </div>

                        <div class="d-flex flex-wrap justify-content-between col-12">
                            <div class="col-12 form-group px-0">
                                <label>Endereço:</label>
                                <p>{{ $vacancy->city }}-{{ $vacancy->state }}. Bairro: {{ $vacancy->neighborhood }}
                                </p>
                            </div>
                        </div>

                        @if ($vacancy->benefits)
                            <div class="comments-wrap">
                                <div class="comment-title">
                                    <h3 class="title">Benefícios:</h3>
                                    <p>{{ $vacancy->benefits }}</p>
                                </div>
                            </div>
                        @endif

                        @if ($vacancy->period)
                            <div class="comments-wrap">
                                <div class="comment-title">
                                    <h3 class="title">Período:</h3>
                                    <p>{{ $vacancy->period }}</p>
                                </div>
                            </div>
                        @endif

                        @if ($vacancy->requirements)
                            <div class="comments-wrap">
                                <div class="comment-title">
                                    <h3 class="title">Requisitos:</h3>
                                    <p>{{ $vacancy->requirements }}</p>
                                </div>
                            </div>
                        @endif

                    </div>
                    <div class="d-flex justify-content-start gap-2">
                        <div class="banner-btn">
                            <a href="{{ route('register') }}" class="default-btn btn-bg-two border-radius-5">Crie sua
                                Conta<i class='bx bx-chevron-right'></i></a>
                        </div>
                        <div class="banner-btn">
                            <a href="{{ route('admin.curriculum.show') }}"
                                class="default-btn btn-bg-two border-radius-5">Cadastre seu
                                currículo <i class='bx bx-chevron-right'></i></a>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="side-bar-area">
                        <div class="search-widget">
                        </div>

                        <div class="side-bar-widget">
                            <h3 class="title">Outras Vagas</h3>
                            <div class="widget-popular-post">
                                @forelse ($vacancies as $item)
                                    <article class="item">
                                        <a href="{{ route('vacancy', ['slug' => $item->slug]) }}" target="_blank"
                                            title="{{ $item->title }}" class="thumb">
                                            <img src="{{ $item->brand_facebook ? url('storage/vacancies/' . $item->brand_facebook) : asset('img/hanshake-1400x700.jpg') }}"
                                                alt="{{ $item->title }}" class="full-image">
                                        </a>
                                        <div class="info">
                                            <h4 class="title-text">
                                                <a href="{{ route('vacancy', ['slug' => $item->slug]) }}" target="_blank">
                                                    {{ $item->title }}
                                                </a>
                                            </h4>
                                            <p>{{ $item->created_at->format('d/m/Y') }}</p>
                                        </div>
                                    </article>
                                @empty
                                    <p>Em breve...</p>
                                @endforelse

                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
@endsection
