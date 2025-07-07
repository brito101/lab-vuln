@extends('adminlte::page')

@section('title', '- Alocação de Vagas')
@section('plugins.Datatables', true)
@section('plugins.DatatablesPlugins', true)

@section('content')
    @if (auth()->user()->can('Editar Alocações') &&
        auth()->user()->can('Excluir Alocações'))
        @php
            $heads = [['label' => 'ID', 'width' => 5], 'Estagiário', 'Universidade', 'Empresa', 'Início', 'Fim', ['label' => 'Ações', 'no-export' => true, 'width' => 10]];

            $list = [];

            foreach ($allocations as $allocation) {
                $list[] = [$allocation->id, $allocation->user['name'] . ' (' . $allocation->user['email'] . ')', $allocation->getUniversity()->alias_name, $allocation->company['alias_name'], $allocation->init, $allocation->finish, '<nobr>' . '<a class="btn btn-xs btn-default text-primary mx-1 shadow" title="Editar" href="allocations/' . $allocation->id . '/edit"><i class="fa fa-lg fa-fw fa-pen"></i></a>' . '<a class="btn btn-xs btn-default text-danger mx-1 shadow" title="Excluir" href="allocations/destroy/' . $allocation->id . '" onclick="return confirm(\'Confirma a exclusão desta alocação?\')"><i class="fa fa-lg fa-fw fa-trash"></i></a>'];
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
            $heads = [['label' => 'ID', 'width' => 5], 'Nome', 'CNPJ', 'E-mail', ['label' => 'Telefone', 'width' => 20]];

            $list = [];

            foreach ($allocations as $allocation) {
                $list[] = [$allocation->id, $allocation->company_id, $allocation->trainee, $allocation->init, $allocation->finish];
            }

            $config = [
                'data' => $list,
                'order' => [[0, 'asc']],
                'columns' => [null, null, null, null, null],
                'language' => ['url' => asset('vendor/datatables/js/pt-BR.json')],
            ];
        @endphp
    @endif

    <section class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1><i class="fa fa-fw fa-handshake"></i> Alocações</h1>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <li class="breadcrumb-item"><a href="{{ route('admin.home') }}">Home</a></li>
                        <li class="breadcrumb-item active">Alocações</li>
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
                                <h3 class="card-title align-self-center">Alocações Cadastradas</h3>
                                @can('Criar Alocações')
                                    <a href="{{ route('admin.allocations.create') }}" title="Nova Alocação"
                                        class="btn btn-success"><i class="fas fa-fw fa-plus"></i>Nova Alocação</a>
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
