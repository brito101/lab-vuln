@extends('site.master.master')

@section('content')
    <div class="inner-banner">
        <div class="container">
            <div class="inner-title text-center">
                <h3>Vagas {{ isset($type) ? 'de ' . $type : '' }}</h3>
            </div>
        </div>
    </div>

    <div class="blog-area pt-100 pb-70">
        <div class="container">
            <div class="section-title text-center">
                <h2>Confira nossas Vagas!</h2>
            </div>
            <div class="row pt-45">
                @forelse ($vacancies as $vacancy)
                    <div class="col-lg-4 col-md-6">
                        <div class="blog-card">
                            <div class="blog-img">
                                <a href="{{ route('vacancy', ['slug' => $vacancy->slug]) }}" title="{{ $vacancy->title }}">
                                    <img src="{{ $vacancy->brand_facebook ? url('storage/vacancies/' . $vacancy->brand_facebook) : asset('img/hanshake-1400x700.jpg') }}"
                                        alt="{{ $vacancy->title }}">
                                </a>
                                <div class="blog-tag">
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
                            <div class="content">
                                <h3>
                                    <a href="{{ route('vacancy', ['slug' => $vacancy->slug]) }}"
                                        title="{{ $vacancy->title }}">{{ $vacancy->title }}</a>
                                </h3>
                                <p style="height: 60px;">{{ Str::limit($vacancy->description, 80) }}</p>
                            </div>
                        </div>
                    </div>

                @empty
                    <p>Estamos preparando vagas de primeira para você :)</p>
                @endforelse

                @if (count($vacancies))
                    <div class="col-lg-12 col-md-12 text-center d-flex justify-content-center">
                        <div class="pagination-area">
                            {{ $vacancies->links() }}
                        </div>
                    </div>
                @endif
            </div>
        </div>
    </div>
@endsection
