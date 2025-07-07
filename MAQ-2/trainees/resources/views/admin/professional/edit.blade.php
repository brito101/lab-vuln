@extends('adminlte::page')

@section('title', '- Edição de Experiência Profissional')

@section('content')

    <section class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1><i class="fa fa-fw fa-briefcase"></i> Editar Experiência Profissional</h1>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <li class="breadcrumb-item"><a href="{{ route('admin.home') }}">Home</a></li>
                        <li class="breadcrumb-item"><a href="{{ route('admin.professionals.index') }}">Experiências
                                Profissionais</a></li>
                        <li class="breadcrumb-item active">Editar Experiência Profissional</li>
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
                            <h3 class="card-title">Dados Cadastrais da Experiência Profissional</h3>
                        </div>

                        <form method="POST"
                            action="{{ route('admin.professionals.update', ['professional' => $professional->id]) }}">
                            @method('PUT')
                            @csrf
                            <input type="hidden" name="id" value="{{ $professional->id }}">
                            <div class="card-body">

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <label for="company">Nome da Empresa</label>
                                        <input type="text" class="form-control" id="company" placeholder="Nome da Empresa"
                                            name="company" value="{{ old('company') ?? $professional->company }}"
                                            required>
                                    </div>
                                    <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                        <label for="role">Cargo</label>
                                        <input type="text" class="form-control" id="role" placeholder="Cargo" name="role"
                                            value="{{ old('role') ?? $professional->role }}" required>
                                    </div>
                                </div>

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <label for="start">Início</label>
                                        <input type="text" class="form-control date" id="start" placeholder="Data de Início"
                                            name="start" value="{{ old('start') ?? $professional->start }}" required>
                                    </div>
                                    <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                        <label for="end">Término</label>
                                        <input type="text" class="form-control date" id="end"
                                            placeholder="Data do Término (anulável)" name="end"
                                            value="{{ old('end') ?? $professional->end }}">
                                    </div>
                                </div>

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <label for="contract">Regime Contratual</label>
                                        <input type="text" class="form-control" id="contract"
                                            placeholder="CLT, CNPJ, contrato..." name="contract"
                                            value="{{ old('contract') ?? $professional->contract }}" required>
                                    </div>
                                </div>

                                <div class="col-12 px-0">
                                    <label for="activities">Atividades</label>
                                    <x-adminlte-textarea name="activities"
                                        placeholder="Descrição das atividades desempenhadas em no máximo 1500 caracteres...">
                                        {{ old('activities') ?? $professional->activities }}</x-adminlte-textarea>
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
        $('.date').inputmask("99/99/9999");
    </script>
@endsection
