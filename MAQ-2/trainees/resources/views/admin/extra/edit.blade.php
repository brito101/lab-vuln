@extends('adminlte::page')

@section('title', '- Edição de Curso Extracurricular')
@section('plugins.select2', true)

@section('content')

    <section class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1><i class="fa fa-fw fa-plus"></i> Editar Curso Extracurricular</h1>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <li class="breadcrumb-item"><a href="{{ route('admin.home') }}">Home</a></li>
                        <li class="breadcrumb-item"><a href="{{ route('admin.extras.index') }}">Curso Extracurricular</a>
                        </li>
                        <li class="breadcrumb-item active">Editar Curso Extracurricular</li>
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
                            <h3 class="card-title">Dados Cadastrais do Curso Extracurricular</h3>
                        </div>

                        <form method="POST" action="{{ route('admin.extras.update', ['extra' => $extra->id]) }}">
                            @method('PUT')
                            @csrf
                            <input type="hidden" name="id" value="{{ $extra->id }}">
                            <div class="card-body">
                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <label for="name">Nome do Curso Extracurricular</label>
                                        <input type="text" class="form-control" id="name" placeholder="Nome do curso"
                                            name="name" value="{{ old('name') ?? $extra->name }}" required>
                                    </div>
                                    <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                        <label for="course_id">Categoria</label>
                                        <x-adminlte-select2 name="course_id">
                                            @foreach ($courses as $course)
                                                <option
                                                    {{ old('course_id') == $course->id ? 'selected' : ($extra->course_id == $course->id ? 'selected' : '') }}
                                                    value="{{ $course->id }}">{{ $course->name }}</option>
                                            @endforeach
                                        </x-adminlte-select2>
                                    </div>
                                </div>

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <label for="institution">Insituição de Ensino</label>
                                        <input type="text" class="form-control" id="institution"
                                            placeholder="Nome da Insituição de Ensino" name="institution"
                                            value="{{ old('institution') ?? $extra->institution }}" required>
                                    </div>
                                    <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                        <label for="level">Nível</label>
                                        <input type="text" class="form-control" id="level"
                                            placeholder="Pleno, Fluente, Avançado..." name="level"
                                            value="{{ old('level') ?? $extra->level }}" required>
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
