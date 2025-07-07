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
                        <li class="breadcrumb-item"><a href="{{ route('admin.institution.index') }}">Cursos</a></li>
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

                        <form method="POST" action="{{ route('admin.institution.store') }}">
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
                                        <label for="level">Nível</label>
                                        <input type="text" class="form-control" id="level"
                                            placeholder="Bacharelado, Pleno, Fluente, Avançado..." name="level"
                                            value="{{ old('level') }}" required>
                                    </div>
                                </div>

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <label for="advisor">Orientador</label>
                                        <input type="text" class="form-control" id="advisor"
                                            placeholder="Nome do Orientador" name="advisor" value="{{ old('advisor') }}">
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
