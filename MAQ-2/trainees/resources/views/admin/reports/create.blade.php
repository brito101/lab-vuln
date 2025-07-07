@extends('adminlte::page')
@section('plugins.BsCustomFileInput', true)
@section('plugins.select2', true)

@section('title', '- Criação de Relatório de Estágio')

@section('content')

    <section class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1><i class="fas fa-fw fa-file-download"></i> Novo Relatório de Estágio</h1>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <li class="breadcrumb-item"><a href="{{ route('admin.home') }}">Home</a></li>
                        <li class="breadcrumb-item"><a href="{{ route('admin.reports.index') }}">Relatórios de
                                Estágio</a></li>
                        <li class="breadcrumb-item active">Novo Relatório de Estágio</li>
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
                        <div class="card-header d-flex justify-content-between">
                            <h3 class="card-title">Relatório de Estágio</h3>
                        </div>

                        <form method="POST" action="{{ route('admin.reports.store') }}" enctype="multipart/form-data">
                            @csrf
                            <div class="card-body">

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <label for="title">Título do Relatório</label>
                                        <input type="text" class="form-control" id="title" placeholder="Nome do Relatório"
                                            name="title" value="{{ old('title') }}" required>
                                    </div>
                                    <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                        <label for="type">Tipo de Relatório</label>
                                        <x-adminlte-select2 name="type">
                                            <option {{ old('type') == 'Aproveitamento' ? 'selected' : '' }}>
                                                Aproveitamento</option>
                                            <option {{ old('type') == 'Atividades' ? 'selected' : '' }}>Atividades
                                            </option>
                                            <option {{ old('type') == 'Recibo de Conclusão' ? 'selected' : '' }}>Recibo de
                                                Conclusão</option>
                                            <option {{ old('type') == 'Recibo de Desligamento' ? 'selected' : '' }}>Recibo
                                                de Desligamento</option>
                                            <option
                                                {{ old('type') == 'Termo de Realização do Estágio' ? 'selected' : '' }}>
                                                Termo de Realização do Estágio</option>
                                        </x-adminlte-select2>
                                    </div>
                                </div>

                                <div class="col-12 form-group px-0 pr-md-2 d-flex flex-wrap">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <x-adminlte-input-file name="document" label="Arquivo"
                                            placeholder="Selecione um arquivo..." legend="Selecionar" />
                                    </div>
                                    <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                        <label for="company_id">Empresa Relacionada</label>
                                        <x-adminlte-select2 name="company_id">
                                            @foreach ($companies as $company)
                                                <option {{ old('company_id') == $company->id ? 'selected' : '' }}
                                                    value="{{ $company->id }}">
                                                    {{ $company->alias_name }}</option>
                                            @endforeach
                                        </x-adminlte-select2>
                                    </div>
                                </div>

                                <div class="col-12 form-group px-0 pr-md-2 d-flex flex-wrap">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <label for="institution">Instituição de Ensino Relacionada</label>
                                        <x-adminlte-select2 name="institution">
                                            @foreach ($institutions as $institution)
                                                <option {{ old('institution') == $institution->id ? 'selected' : '' }}
                                                    value="{{ $institution->id }}">
                                                    {{ $institution->alias_name }}</option>
                                            @endforeach
                                        </x-adminlte-select2>
                                    </div>
                                    <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                        <label for="trainee">Estagiário Relacionado</label>
                                        <x-adminlte-select2 name="trainee">
                                            @foreach ($trainees as $trainee)
                                                <option {{ old('trainee') == $trainee->id ? 'selected' : '' }}
                                                    value="{{ $trainee->id }}">
                                                    {{ $trainee->name }} - {{ $trainee->email }}</option>
                                            @endforeach
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
