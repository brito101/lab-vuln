@extends('adminlte::page')

@section('title', '- Cadastro de Curso')
@section('plugins.select2', true)

@section('content')

    <section class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1><i class="fa fa-fw fa-graduation-cap"></i> Novo Curso</h1>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <li class="breadcrumb-item"><a href="{{ route('admin.home') }}">Home</a></li>
                        <li class="breadcrumb-item"><a href="{{ route('admin.academics.index') }}">Cursos</a></li>
                        <li class="breadcrumb-item active">Novo Curso</li>
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
                            <h3 class="card-title">Dados Cadastrais do Curso</h3>
                        </div>

                        <form method="POST" action="{{ route('admin.academics.store') }}">
                            @csrf
                            <div class="card-body">

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <label for="name">Nome do Curso</label>
                                        <input type="text" class="form-control" id="name" placeholder="Nome do curso"
                                            name="name" value="{{ old('name') }}" required>
                                    </div>
                                    <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                        <label for="course_id">Categoria</label>
                                        <x-adminlte-select2 name="course_id">
                                            @foreach ($courses as $course)
                                                <option {{ old('course_id') == $course->id ? 'selected' : '' }}
                                                    value="{{ $course->id }}">{{ $course->name }}</option>
                                            @endforeach
                                        </x-adminlte-select2>
                                    </div>
                                </div>

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <label for="scholarity_id">Escolaridade</label>
                                        <x-adminlte-select2 name="scholarity_id">
                                            @foreach ($scholarities as $scholarity)
                                                <option {{ old('scholarity_id') == $scholarity->id ? 'selected' : '' }}
                                                    value="{{ $scholarity->id }}">{{ $scholarity->name }}</option>
                                            @endforeach
                                        </x-adminlte-select2>
                                    </div>
                                    <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                        <label for="institution">Instituição de Ensino</label>
                                        <input type="text" class="form-control" id="institution"
                                            placeholder="Instituição de Ensino" name="institution"
                                            value="{{ old('institution') }}" required>
                                    </div>
                                </div>

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <label for="city">Cidade</label>
                                        <input type="text" class="form-control" id="city" placeholder="Cidade" name="city"
                                            value="{{ old('city') }}" required>
                                    </div>
                                    <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                        <label for="state">Estado</label>
                                        <input type="text" class="form-control" id="state" placeholder="Estado"
                                            name="state" value="{{ old('state') }}" required>
                                    </div>
                                </div>

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <label for="year">Período/Ano</label>
                                        <input type="text" class="form-control" id="year" placeholder="Período do curso"
                                            name="year" value="{{ old('year') }}" required>
                                    </div>
                                    <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                        <label for="time">Turno</label>
                                        <x-adminlte-select2 name="time">
                                            <option {{ old('time') == 'Matutino' ? 'selected' : '' }} value="Matutino">
                                                Matutino</option>
                                            <option {{ old('time') == 'Vespertino' ? 'selected' : '' }}
                                                value="Vespertino">Vespertino</option>
                                            <option {{ old('time') == 'Noturno' ? 'selected' : '' }} value="Noturno">
                                                Noturno</option>
                                            <option {{ old('time') == 'Integral' ? 'selected' : '' }} value="Integral">
                                                Integral</option>
                                            <option {{ old('time') == 'EAD' ? 'selected' : '' }} value="EAD">
                                                EAD</option>
                                        </x-adminlte-select2>
                                    </div>
                                </div>

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <label for="graduation">Data de Conclusão</label>
                                        <input type="text" class="form-control" id="graduation"
                                            placeholder="ata de Conclusão do Curso" name="graduation"
                                            value="{{ old('graduation') }}" required>
                                    </div>
                                    <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                        <label for="availability">Disponibilidade</label>
                                        <x-adminlte-select2 name="availability">
                                            <option {{ old('availability') == 'Comercial' ? 'selected' : '' }}
                                                value="Comercial">
                                                Comercial</option>
                                            <option {{ old('availability') == 'Manhã' ? 'selected' : '' }} value="Manhã">
                                                Manhã</option>
                                            <option {{ old('availability') == 'Tarde' ? 'selected' : '' }} value="Tarde">
                                                Tarde</option>
                                            <option {{ old('availability') == 'Noite' ? 'selected' : '' }} value="Noite">
                                                Noite</option>
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

@section('custom_js')
    <script src="{{ asset('vendor/jquery/jquery.inputmask.bundle.min.js') }}"></script>
    <script>
        $('#state').inputmask("AA");
        $('#graduation').inputmask("99/99/9999");
    </script>
@endsection
