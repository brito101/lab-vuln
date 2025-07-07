@extends('adminlte::page')

@section('title', '- Relatórios de Estágio')
@section('plugins.Datatables', true)
@section('plugins.DatatablesPlugins', true)

@section('content')
    @if (Auth::user()->hasPermissionTo('Enviar Relatórios'))
        @php
            $heads = [['label' => 'ID', 'width' => 5], 'Título', 'Autor', 'Empresa', 'Insituição de Ensino', 'Estagiário', ['label' => 'Ações', 'no-export' => true, 'width' => 10]];

            $list = [];

            foreach ($reports as $report) {
                $list[] = [$report->id, $report->title, $report->editorName(), $report->company['alias_name'], $report->institutionName(), $report->traineeName(), '<nobr>' . $report->link()];
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
            $heads = [['label' => 'ID', 'width' => 5], 'Título', 'Autor', 'Empresa', 'Insituição de Ensino', 'Estagiário', ['label' => 'Ações', 'no-export' => true, 'width' => 10]];

            $list = [];

            foreach ($reports as $report) {
                $list[] = [$report->id, $report->title, $report->editorName(), $report->company['alias_name'], $report->institutionName(), $report->traineeName(), $report->link()];
            }

            $config = [
                'data' => $list,
                'order' => [[0, 'asc']],
                'columns' => [null, null, null, null, null, null, ['orderable' => false]],
                'language' => ['url' => asset('vendor/datatables/js/pt-BR.json')],
            ];
        @endphp
    @endif


    <section class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1><i class="fa fa-fw fa-file-download"></i> Relatórios de Estágio</h1>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <li class="breadcrumb-item"><a href="{{ route('admin.home') }}">Home</a></li>
                        <li class="breadcrumb-item active">Relatórios de Estágio</li>
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
                                <h3 class="card-title align-self-center">Relatórios</h3>
                                @can('Enviar Relatórios')
                                    <a href="{{ route('admin.reports.create') }}" title="Novo Relatório"
                                        class="btn btn-success"><i class="fas fa-fw fa-plus"></i>Novo Relatório</a>
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
