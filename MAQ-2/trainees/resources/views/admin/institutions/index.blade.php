@extends('adminlte::page')

@section('title', '- Cursos')
@section('plugins.Datatables', true)
@section('plugins.DatatablesPlugins', true)

@section('content')
    @can('Cursos de Instituições')
        @php
        $heads = [['label' => 'ID', 'width' => 5], 'Curso', 'Orientador', 'Nível', 'Área', 'Escolaridade', ['label' => 'Ações', 'no-export' => true, 'width' => 10]];

        $list = [];

        foreach ($courses as $course) {
            $list[] = [$course->id, $course->name, $course->advisor, $course->level, $course->course['name'], $course->scholarity['name'], '<nobr>' . '<a class="btn btn-xs btn-default text-primary mx-1 shadow" title="Editar" href="institution/' . $course->id . '/edit"><i class="fa fa-lg fa-fw fa-pen"></i></a>' . '<a class="btn btn-xs btn-default text-danger mx-1 shadow" title="Excluir" href="institution/destroy/' . $course->id . '" onclick="return confirm(\'Confirma a exclusão deste curso?\')"><i class="fa fa-lg fa-fw fa-trash"></i></a>'];
        }

        $config = [
            'data' => $list,
            'order' => [[0, 'asc']],
            'columns' => [null, null, null, null, null, null, ['orderable' => false]],
            'language' => ['url' => asset('vendor/datatables/js/pt-BR.json')],
        ];
        @endphp
    @else
        @php
        $heads = [['label' => 'ID', 'width' => 5], 'Curso', 'Orientador', 'Nível', 'Área', 'Escolaridade', 'Insituição'];

        $list = [];

        foreach ($courses as $course) {
            $list[] = [$course->id, $course->advisor, $course->name, $course->level, $course->course['name'], $course->scholarity['name'], $course->company['alias_name']];
        }

        $config = [
            'data' => $list,
            'order' => [[0, 'asc']],
            'columns' => [null, null, null, null, null, null, ['orderable' => false]],
            'language' => ['url' => asset('vendor/datatables/js/pt-BR.json')],
        ];
        @endphp
    @endcan


    <section class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1><i class="fa fa-fw fa-graduation-cap"></i> Cursos com Estágio</h1>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <li class="breadcrumb-item"><a href="{{ route('admin.home') }}">Home</a></li>
                        <li class="breadcrumb-item active">Cursos</li>
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
                            <div class="d-flex flex-wrap justify-content-between col-12 align-content-center">
                                <h3 class="card-title align-self-center">Cursos Cadastrados</h3>
                                @can('Cursos de Instituições')
                                    <a href="{{ route('admin.institution.create') }}" title="Novo Curso"
                                        class="btn btn-success"><i class="fas fa-fw fa-plus"></i>Novo Curso</a>
                                @endcan
                            </div>
                        </div>
                        <div class="card-body">
                            <x-adminlte-datatable id="table1" :heads="$heads" :heads="$heads" :config="$config" striped
                                hoverable beautify with-buttons />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
@endsection
