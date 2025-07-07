@extends('adminlte::page')
@section('title', '- Relatório de Compatibilidade')

@section('content')
    <section class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1><i class="fa fa-fw fa-file"></i> Relatório de Compatibilidade</h1>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <li class="breadcrumb-item"><a href="{{ route('admin.home') }}">Home</a></li>
                        <li class="breadcrumb-item active">Relatório de Compatibilidade</li>
                    </ol>
                </div>
            </div>
        </div>
    </section>

    <section class="content">
        <div class="container-fluid">
            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header">
                            <div class="d-flex flex-wrap justify-content-between col-12 align-content-center">
                                <h3 class="card-title align-self-center">Relatório de Compatibilidade</h3>
                                <a href="{{ route('admin.compatibility.report.pdf') }}" target="_blank"
                                    class="btn btn-primary"><i class="fa fa-print"></i> Imprimir
                                    Relatório</a>
                            </div>
                        </div>

                        <div class="card-body d-flex flex-wrap">
                            @foreach ($trainees as $trainee)
                                <div class="col-12 col-md-4">
                                    <x-adminlte-profile-widget name="{{ $trainee->name }}"
                                        desc="{{ $trainee->academics->pluck('name')->implode('/') }}" theme=" lightblue"
                                        img="{{ $trainee->photo != null ? url('storage/users/' . $trainee->photo) : asset('/vendor/adminlte/dist/img/avatar.png') }}"
                                        layout-type="classic">
                                        <div class="badge badge-info">Vagas:</div>
                                        @foreach ($vacancies as $vacancy)
                                            @if (!empty(array_intersect($vacancy->coursesId(), $trainee->academics->pluck('course_id')->toArray())))
                                                <x-adminlte-profile-row-item
                                                    class="text-center border-bottom border-secondary" />
                                                <x-adminlte-profile-row-item title="Título" text="{{ $vacancy->title }}"
                                                    class="text-primary" />
                                                <x-adminlte-profile-row-item title="Empresa"
                                                    text="{{ $vacancy->company['alias_name'] }}" class="text-primary" />
                                                <x-adminlte-profile-row-item title="Compatibilidade"
                                                    text="{{ $vacancy->total }}%" class="text-primary" />
                                            @endif
                                        @endforeach

                                    </x-adminlte-profile-widget>
                                </div>
                            @endforeach

                        </div>

                        <div class="justify-content-center d-flex">
                            {{ $trainees->links() }}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
@endsection
