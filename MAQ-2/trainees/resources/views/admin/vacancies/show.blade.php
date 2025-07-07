@extends('adminlte::page')

@section('content')
    <section class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1><i class="fas fa-fw fa-briefcase"></i> Vaga: {{ $vacancy->title }}</h1>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <li class="breadcrumb-item"><a href="{{ route('admin.home') }}">Home</a></li>
                        <li class="breadcrumb-item active">Vaga: {{ $vacancy->title }}</li>
                    </ol>
                </div>
            </div>
        </div>
    </section>

    <section class="content">
        <div class="container-fluid">
            <div class="row">
                <div class="col-12">

                    @include('components.alert')

                    {{-- @if (empty($candidate))
                        <div class="card-footer">
                            <form method="POST" action="{{ route('admin.candidate.store', ['id' => $vacancy->id]) }}">
                                @csrf
                                <input type="hidden" name="vacancy_id" value="{{ $vacancy->id }}">
                                <button type="submit" class="btn btn-success btn-lg"><i
                                        class="fa fa-lg fa-thumbs-up mr-2"></i>Me Candidatar</button>
                            </form>
                        </div>
                    @else
                        <div class="card-footer">
                            <form method="POST" action="{{ route('admin.candidate.cancel', ['id' => $vacancy->id]) }}">
                                @method('PUT')
                                @csrf
                                <input type="hidden" name="vacancy_id" value="{{ $vacancy->id }}">
                                <button type="submit" class="btn btn-danger btn-lg"><i
                                        class="fa fa-lg fa-thumbs-down mr-2"></i>Cancelar
                                    minha Candidatura</button>
                            </form>
                        </div>
                    @endif --}}

                    <x-adminlte-profile-widget name="{{ $vacancy->company['alias_name'] }}" theme="lightblue"
                        desc="{{ $vacancy->company['city'] . '-' . $vacancy->company['state'] . '. Tel: ' . $vacancy->company['telephone'] }}"
                        img="{{ $vacancy->company['logo'] ? url('storage/companies/' . $vacancy->company['logo']) : asset('/vendor/adminlte/dist/img/logo.png') }}"
                        class="bg-with">

                        {{-- <x-adminlte-profile-row-item icon="fas fa-fw fa-user-friends" title="Candidatos"
                            text="{{ $vacancy->candidate->count() }}" class="border-bottom border-dark mt-n4 mb-4" url="#"
                            badge="warning" /> --}}
                        <div class="d-flex flex-wrap justify-content-between col-12">
                            <div class="col-12 form-group px-0">
                                <label>Cursos de interesse</label>
                                <p>{{ $vacancy->courses() }}</p>
                            </div>
                        </div>
                        <div class="d-flex flex-wrap justify-content-between col-12">
                            <div class="col-12 col-md-6 form-group px-0">
                                <label>Escolaridade</label>
                                <p>{{ $vacancy->scholarity['name'] }}</p>
                            </div>
                            <div class="col-12 col-md-6 form-group px-0">
                                <label>Experiência</label>
                                <p>{{ $vacancy->experience }}</p>
                            </div>
                        </div>
                        <div class="d-flex flex-wrap justify-content-between col-12">
                            <div class="col-12 form-group px-0">
                                <label>Descrição da vaga</label>
                                <p> {{ $vacancy->description }}</p>
                            </div>
                        </div>
                        @if ($vacancy->benefits)
                            <div class="d-flex flex-wrap justify-content-between col-12">
                                <div class="col-12 form-group px-0">
                                    <label>Benefícios</label>
                                    <p>{{ $vacancy->benefits }}</p>
                                </div>
                            </div>
                        @endif
                        @if ($vacancy->period)
                            <div class="d-flex flex-wrap justify-content-between col-12">
                                <div class="col-12 col-md-6 form-group px-0">
                                    <label>Período</label>
                                    <p>{{ $vacancy->period }}</p>
                                </div>
                            </div>
                        @endif
                        @if ($vacancy->requirements)
                            <div class="d-flex flex-wrap justify-content-between col-12">
                                <div class="col-12 form-group px-0">
                                    <label>Requisitos</label>
                                    <p>{{ $vacancy->requirements }}</p>
                                </div>
                            </div>
                        @endif
                        <div class="d-flex flex-wrap justify-content-between col-12">
                            <div class="col-12 form-group px-0">
                                <label>Endereço</label>
                                <p>{{ $vacancy->city }}-{{ $vacancy->state }}. Bairro: {{ $vacancy->neighborhood }}
                                </p>
                            </div>
                        </div>

                        {{-- <x-adminlte-profile-row-item title="Redes Sociais:" class="text-center text-dark border-bottom" />
                        <x-adminlte-profile-row-item icon="fab fa-fw fa-2x fa-instagram text-dark" title="Instagram"
                            url="{{ $vacancy->company['instagram'] }}" size=4 />
                        <x-adminlte-profile-row-item icon="fab fa-fw fa-2x fa-facebook text-dark" title="Facebook"
                            url="{{ $vacancy->company['facebook'] }}" size=4 />
                        <x-adminlte-profile-row-item icon="fab fa-fw fa-2x fa-twitter text-dark" title="Twitter"
                            url="{{ $vacancy->company['twitter'] }}" size=4 /> --}}
                    </x-adminlte-profile-widget>
                </div>
            </div>
        </div>
    </section>
@endsection
