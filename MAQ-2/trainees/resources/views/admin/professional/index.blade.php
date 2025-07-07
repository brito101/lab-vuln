@extends('adminlte::page')

@section('title', '- Experiências Profissionais')
@section('plugins.Datatables', true)
@section('plugins.DatatablesPlugins', true)

@section('content')
    @php
    $heads = [['label' => 'ID', 'width' => 5], 'Empresa', 'Cargo', 'Início', 'Fim', ['label' => 'Ações', 'no-export' => true, 'width' => 10]];

    $list = [];

    foreach ($professionals as $professional) {
        $list[] = [$professional->id, $professional->company, $professional->role, $professional->start, $professional->end, '<nobr>' . '<a class="btn btn-xs btn-default text-primary mx-1 shadow" title="Editar" href="professionals/' . $professional->id . '/edit"><i class="fa fa-lg fa-fw fa-pen"></i></a>' . '<a class="btn btn-xs btn-default text-danger mx-1 shadow" title="Excluir" href="professionals/destroy/' . $professional->id . '" onclick="return confirm(\'Confirma a exclusão desta experiência profissional?\')"><i class="fa fa-lg fa-fw fa-trash"></i></a>'];
    }

    $config = [
        'data' => $list,
        'order' => [[0, 'asc']],
        'columns' => [null, null, null, null, null, ['orderable' => false]],
        'language' => ['url' => asset('vendor/datatables/js/pt-BR.json')],
    ];
    @endphp


    <section class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1><i class="fa fa-fw fa-briefcase"></i> Experiências Profissionais</h1>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <li class="breadcrumb-item"><a href="{{ route('admin.home') }}">Home</a></li>
                        <li class="breadcrumb-item active">Experiências Profissionais</li>
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
                                <h3 class="card-title align-self-center">Experiências Profissionais Cadastradas</h3>
                                <a href="{{ route('admin.professionals.create') }}" title="Nova Experiência Profissional"
                                    class="btn btn-success"><i class="fas fa-fw fa-plus"></i>Nova Experiência
                                    Profissional</a>
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
