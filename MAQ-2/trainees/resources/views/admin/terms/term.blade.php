@extends('adminlte::page')
@section('plugins.select2', true)
@section('plugins.Summernote', true)

@section('title', '- Gerar de Termo')

@section('content')

    <section class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1><i class="fas fa-fw fa-file-contract"></i> Gerar Termo</h1>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <li class="breadcrumb-item"><a href="{{ route('admin.home') }}">Home</a></li>
                        <li class="breadcrumb-item active">Gerar Termo</li>
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
                            <h3 class="card-title">Gerar Termo</h3>
                        </div>

                        <form method="POST" action="{{ route('admin.terms.pdf') }}" target="_blank">
                            @csrf
                            <div class="card-body">
                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 form-group px-0">
                                        <x-adminlte-select2 name="title" label="Modelo">
                                            @foreach ($terms as $term)
                                                <option {{ old('title') == $term->title ? 'selected' : '' }}
                                                    value="{{ $term->title }}">
                                                    {{ $term->title . ' :: ' . $term->type }}</option>
                                            @endforeach
                                        </x-adminlte-select2>
                                    </div>
                                </div>

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <label for="primary_name">Participante Principal</label>
                                        <input type="text" class="form-control" id="primary_name"
                                            placeholder="Nome da Franquia, Empresa ou Estagiário" name="primary_name"
                                            value="{{ old('primary_name') }}" required>
                                    </div>

                                    <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                        <label for="primary_document">Nº Documento</label>
                                        <input type="text" class="form-control" id="primary_document"
                                            placeholder="CNPJ, CPF ou RG" name="primary_document"
                                            value="{{ old('primary_document') }}" required>
                                    </div>
                                </div>

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <label for="secondary_name">Participante Secundário</label>
                                        <input type="text" class="form-control" id="secondary_name"
                                            placeholder="Nome da Franquia, Empresa ou Estagiário" name="secondary_name"
                                            value="{{ old('secondary_name') }}" required>
                                    </div>

                                    <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                        <label for="secondary_document">Nº Documento</label>
                                        <input type="text" class="form-control" id="secondary_document"
                                            placeholder="CNPJ, CPF ou RG" name="secondary_document"
                                            value="{{ old('secondary_document') }}" required>
                                    </div>
                                </div>
                            </div>

                            <div class="card-footer">
                                <button type="submit" class="btn btn-primary"><i
                                        class="fa fa-print mr-2"></i>Imprimir</button>
                            </div>
                        </form>

                    </div>
                </div>
            </div>
        </div>
    </section>
@endsection
