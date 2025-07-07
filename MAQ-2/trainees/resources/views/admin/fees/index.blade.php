@extends('adminlte::page')

@section('title', '- Pesquisa Salarial')
@section('plugins.Datatables', true)
@section('plugins.DatatablesPlugins', true)

@section('content')
    @if (auth()->user()->can('Editar Pesquisa Salarial') &&
    auth()->user()->can('Excluir Pesquisa Salarial'))
        @php
            $heads = [['label' => 'ID', 'width' => 5], 'Cargo', ['label' => 'Salário', 'width' => 15], 'Benefícios', 'Empresa', ['label' => 'Ações', 'no-export' => true, 'width' => 10]];

            $list = [];

            foreach ($fees as $fee) {
                $list[] = [$fee->id, $fee->role, $fee->salary, $fee->benefits, $fee->company['alias_name'], '<nobr>' . $fee->links()];
            }

            $config = [
                'data' => $list,
                'order' => [[0, 'asc']],
                'columns' => [null, null, null, null, null, ['orderable' => false]],
                'language' => ['url' => asset('vendor/datatables/js/pt-BR.json')],
            ];
        @endphp
    @else
        @php
            $heads = [['label' => 'ID', 'width' => 5], 'Cargo', ['label' => 'Salário', 'width' => 15], 'Benefícios', 'Empresa'];

            $list = [];

            foreach ($fees as $fee) {
                $list[] = [$fee->id, $fee->role, $fee->salary, $fee->benefits, $fee->company['alias_name']];
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
                    <h1><i class="fas fa-fw fa-money-bill-wave"></i> Pesquisa Salarial</h1>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <li class="breadcrumb-item"><a href="{{ route('admin.home') }}">Home</a></li>
                        <li class="breadcrumb-item active">Pesquisa Salarial</li>
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
                                <h3 class="card-title align-self-center">Salários Cadastradas</h3>
                                @can('Criar Pesquisa Salarial')
                                    <a href="{{ route('admin.salary-list.create') }}" title="Novo Salário"
                                        class="btn btn-success"><i class="fas fa-fw fa-plus"></i>Novo Salário</a>
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
