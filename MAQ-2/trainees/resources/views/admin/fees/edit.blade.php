@extends('adminlte::page')

@section('title', '- Edição de Salário para Pesquisa')

@section('content')

    <section class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1><i class="fas fa-fw fa-money-bill-wave"></i> Editar Salário</h1>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <li class="breadcrumb-item"><a href="{{ route('admin.home') }}">Home</a></li>
                        <li class="breadcrumb-item"><a href="{{ route('admin.salary-list.index') }}">Pesquisa Salarial</a>
                        </li>
                        <li class="breadcrumb-item active">Editar Salário</li>
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
                            <h3 class="card-title">Dados Cadastrais do Salário</h3>
                        </div>

                        <form method="POST" action="{{ route('admin.salary-list.update', ['salary_list' => $fee->id]) }}">
                            @method('PUT')
                            @csrf
                            <input type="hidden" name="id" value="{{ $fee->id }}">
                            <div class="card-body">
                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <label for="role">Cargo/Profissão</label>
                                        <input type="text" class="form-control" id="role"
                                            placeholder="Nome do Cargo, profissão, função..." name="role"
                                            value="{{ old('role') ?? $fee->role }}" required>
                                    </div>
                                    <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                        <label for="salary">Salário</label>
                                        <input type="text" class="form-control" id="salary"
                                            placeholder="Salário, em reais" name="salary"
                                            value="{{ old('salary') ?? $fee->salary }}" required>
                                    </div>
                                </div>

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <label for="benefits">Benefícios</label>
                                        <input type="text" class="form-control" id="benefits"
                                            placeholder="Plano dontológico, vale refeição etc" name="benefits"
                                            value="{{ old('benefits') ?? $fee->benefits }}">
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
        $("#salary").inputmask('currency', {
            "autoUnmask": true,
            radixPoint: ",",
            groupSeparator: ".",
            allowMinus: false,
            prefix: 'R$ ',
            digits: 2,
            digitsOptional: false,
            rightAlign: true,
            unmaskAsNumber: true
        });
    </script>
@endsection
