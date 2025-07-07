@extends('adminlte::page')

@section('title', '- Documentação Comprobatória')
@section('plugins.Datatables', true)
@section('plugins.DatatablesPlugins', true)

@section('content')

    @php
    $heads = [['label' => 'ID', 'width' => 5], 'Estagiário', 'CPF', 'E-mail', 'Status', ['label' => 'Ações', 'no-export' => true, 'width' => 10]];

    $list = [];

    foreach ($documents as $document) {
        $list[] = [$document->id, $document->user->name, $document->user->document_person, $document->user->email, $document->documentStatus(), '<nobr>' . '<a class="btn btn-xs btn-default text-primary mx-1 shadow" title="Download" href="documents-trainees/download/' . $document->id .'"><i class="fa fa-lg fa-fw fa-download"></i></a>' . $document->links()];
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
                    <h1><i class="fas fa-fw fa-file-upload"></i>Documentos Comprobatórios</h1>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <li class="breadcrumb-item"><a href="{{ route('admin.home') }}">Home</a></li>
                        <li class="breadcrumb-item active">Documentação Comprobatória</li>
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
                                <h3 class="card-title align-self-center">Documentos Cadastrados</h3>
                            </div>
                        </div>
                        <div class="card-body">
                            <x-adminlte-datatable id="table1" :heads="$heads" :heads="$heads" :config="$config"
                                striped hoverable beautify with-buttons />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
@endsection
