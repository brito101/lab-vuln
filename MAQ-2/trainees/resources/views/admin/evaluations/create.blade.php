@extends('adminlte::page')

@section('title', '- Cadastro de Alocações')
@section('plugins.select2', true)

@section('content')

    <section class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1><i class="fa fa-fw fa-handshake"></i> Nova Alocação</h1>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <li class="breadcrumb-item"><a href="{{ route('admin.home') }}">Home</a></li>
                        <li class="breadcrumb-item"><a href="{{ route('admin.evaluations.index') }}">Alocações</a>
                        </li>
                        <li class="breadcrumb-item active">Nova Alocação</li>
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

                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">Dados Cadastrais da Alocação</h3>
                        </div>

                        <form method="POST" action="{{ route('admin.evaluations.store') }}">
                            @csrf

                            <div class="card-body">
                                <div class="d-flex flex-wrap justify-content-between">

                                    <div class="col-12 form-group px-0">
                                        <label for="trainee">Estagiário</label>
                                        <x-adminlte-select2 name="trainee">
                                            @foreach ($trainees as $trainee)
                                                <option {{ old('trainee') == $trainee->id ? 'selected' : '' }}
                                                    value="{{ $trainee->id }}">{{ $trainee->name }} -
                                                    ({{ $trainee->email }})
                                                </option>
                                            @endforeach
                                        </x-adminlte-select2>
                                    </div>
                                </div>

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 form-group px-0 ">
                                        <label for="vacancy_id">Vaga</label>
                                        <x-adminlte-select2 name="vacancy_id">
                                            @foreach ($vacancies as $vacancy)
                                                <option {{ old('vacancy_id') == $vacancy->id ? 'selected' : '' }}
                                                    value="{{ $vacancy->id }}">{{ $vacancy->title }} // Empresa:
                                                    {{ $vacancy->company->alias_name }}
                                                </option>
                                            @endforeach
                                        </x-adminlte-select2>
                                    </div>
                                </div>

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 form-group px-0 ">
                                        <label for="status">Situação</label>

                                        <x-adminlte-select2 name="status">
                                            <option {{ old('status') == 'Aguardando' ? 'selected' : '' }}
                                                value="Aguardando">Aguardando
                                            </option>
                                            <option {{ old('status') == 'Em análise' ? 'selected' : '' }}
                                                value="Em análise">
                                                Em análise
                                            </option>
                                            <option {{ old('status') == 'Em contratação' ? 'selected' : '' }}
                                                value="Em contratação">
                                                Em contratação
                                            </option>
                                            <option {{ old('status') == 'Contratado' ? 'selected' : '' }}
                                                value="Contratado">Contratado
                                            </option>
                                            <option {{ old('status') == 'Contrato concluído' ? 'selected' : '' }}
                                                value="Contrato concluído">Contrato concluído
                                            </option>
                                            <option {{ old('status') == 'Contrato cancelado' ? 'selected' : '' }}
                                                value="Contrato cancelado">Contrato cancelado
                                            </option>
                                            <option {{ old('status') == 'Incompatível' ? 'selected' : '' }}
                                                value="Incompatível">Incompatível
                                            </option>
                                        </x-adminlte-select2>
                                    </div>
                                </div>
                            </div>

                            <div class="card-footer">
                                <button type="submit" class="btn btn-primary">Enviar</button>
                            </div>
                        </form>

                    </div>
                </div>
            </div>
        </div>
    </section>
@endsection
