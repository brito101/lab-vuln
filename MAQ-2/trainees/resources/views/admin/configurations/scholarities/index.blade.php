@extends('adminlte::page')

@section('title', '- Escolaridade')
@section('plugins.Datatables', true)
@section('plugins.DatatablesPlugins', true)

@section('content')
    @if (auth()->user()->can('Editar Escolaridade') &&
    auth()->user()->can('Excluir Escolaridade'))
        @php
            $heads = [['label' => 'ID', 'width' => 5], 'Nome', 'Sigla', ['label' => 'Ações', 'no-export' => true, 'width' => 10]];

            $list = [];

            foreach ($scholarities as $scholarity) {
                $list[] = [$scholarity->id, $scholarity->name, $scholarity->acronym, '<nobr>' . '<a class="btn btn-xs btn-default text-primary mx-1 shadow" title="Editar" href="scholarities/' . $scholarity->id . '/edit"><i class="fa fa-lg fa-fw fa-pen"></i></a>' . '<a class="btn btn-xs btn-default text-danger mx-1 shadow" title="Excluir" href="scholarities/destroy/' . $scholarity->id . '" onclick="return confirm(\'Confirma a exclusão desta escolaridade?\')"><i class="fa fa-lg fa-fw fa-trash"></i></a>'];
            }

            $config = [
                'data' => $list,
                'order' => [[0, 'asc']],
                'columns' => [null, null, null, ['orderable' => false]],
                'language' => ['url' => asset('vendor/datatables/js/pt-BR.json')],
            ];
        @endphp
    @else
        @php
            $heads = [['label' => 'ID', 'width' => 5], 'Nome', 'Sigla'];

            $list = [];

            foreach ($scholarities as $scholarity) {
                $list[] = [$scholarity->id, $scholarity->name, $scholarity->acronym];
            }

            $config = [
                'data' => $list,
                'order' => [[0, 'asc']],
                'columns' => [null, null, null],
                'language' => ['url' => asset('vendor/datatables/js/pt-BR.json')],
            ];
        @endphp
    @endif

    <section class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1><i class="fas fa-fw fa-graduation-cap"></i> Escolaridade</h1>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <li class="breadcrumb-item"><a href="{{ route('admin.home') }}">Home</a></li>
                        <li class="breadcrumb-item"><a href="#">Configurações</a></li>
                        <li class="breadcrumb-item active">Escolaridade</li>
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
                                <h3 class="card-title align-self-center">Escolaridade Cadastradas</h3>
                                @can('Criar Escolaridade')
                                    <a href="{{ route('admin.scholarities.create') }}" title="Nova Escolaridade"
                                        class="btn btn-success"><i class="fas fa-fw fa-plus"></i>Nova Escolaridade</a>
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
