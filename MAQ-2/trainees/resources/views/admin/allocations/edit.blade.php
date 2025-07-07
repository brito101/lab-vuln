@extends('adminlte::page')

@section('title', '- Edição de Alocações')
@section('plugins.select2', true)

@section('content')

    <section class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1><i class="fa fa-fw fa-handshake"></i> Editar Alocação</h1>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <li class="breadcrumb-item"><a href="{{ route('admin.home') }}">Home</a></li>
                        <li class="breadcrumb-item"><a href="{{ route('admin.allocations.index') }}">Alocações</a>
                        </li>
                        <li class="breadcrumb-item active">Editar Alocação</li>
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

                        <form method="POST"
                            action="{{ route('admin.allocations.update', ['allocation' => $allocation->id]) }}">
                            @method('PUT')
                            @csrf
                            <input type="hidden" value="{{ $allocation->id }}" name="id">
                            <div class="card-body">
                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 form-group px-0">
                                        <label for="trainee_text">Estagiário</label>
                                        <input type="hidden" value="{{ $allocation->trainee }}" name="trainee">
                                        <input type="text" class="form-control" id="trainee_text" name="trainee_text"
                                            value="{{ $allocation->user['name'] . ' (' . $allocation->user['email'] . ')' }}"
                                            disabled>
                                    </div>
                                </div>

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <label for="company_id">Empresa</label>
                                        <x-adminlte-select2 name="company_id">
                                            @foreach ($companies as $company)
                                                <option
                                                    {{ old('company_id') == $company->id ? 'selected' : ($allocation->company_id == $company->id ? 'selected' : '') }}
                                                    value="{{ $company->id }}">{{ $company->alias_name }}</option>
                                            @endforeach
                                        </x-adminlte-select2>
                                    </div>
                                    <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                        <label for="university">Universidade</label>
                                        <x-adminlte-select2 name="university">
                                            @foreach ($institutions as $institution)
                                                <option
                                                    {{ old('university') == $institution->id ? 'selected' : ($allocation->university == $institution->id ? 'selected' : '') }}
                                                    value="{{ $institution->id }}">{{ $institution->alias_name }}
                                                </option>
                                            @endforeach
                                        </x-adminlte-select2>
                                    </div>
                                </div>

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <label for="init">Início</label>
                                        <input type="text" class="form-control date" id="init"
                                            placeholder="Data de Início da Alocação" name="init"
                                            value="{{ old('init') ?? $allocation->init }}" required>
                                    </div>
                                    <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                        <label for="finish">Final</label>
                                        <input type="text" class="form-control date" id="finish"
                                            placeholder="Data Término da Alocação" name="finish"
                                            value="{{ old('finish') ?? $allocation->finish }}" required>
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

@section('custom_js')
    <script src="{{ asset('vendor/jquery/jquery.inputmask.bundle.min.js') }}"></script>
    <script>
        $('.date').inputmask("dd/mm/yyyy");
    </script>
@endsection
