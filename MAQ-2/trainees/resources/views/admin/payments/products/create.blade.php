@extends('adminlte::page')

@section('title', '- Cadastro de Produto')

@section('content')

    <section class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1><i class="fa fa-fw fa-box"></i> Novo Produto</h1>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <li class="breadcrumb-item"><a href="{{ route('admin.home') }}">Home</a></li>
                        <li class="breadcrumb-item"><a href="{{ route('admin.products.index') }}">Produtos</a></li>
                        <li class="breadcrumb-item active">Novo Produto</li>
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
                            <h3 class="card-title">Dados Cadastrais do Produto</h3>
                        </div>

                        <form method="POST" action="{{ route('admin.products.store') }}">
                            @csrf
                            <div class="card-body">

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <label for="name">Nome da Produto</label>
                                        <input type="text" class="form-control" id="name" placeholder="Nome do Produto"
                                            name="name" value="{{ old('name') }}" required>
                                    </div>
                                    <div class="col-12 col-md-3 form-group px-0 px-md-2">
                                        <label for="price">Preço em Reais</label>
                                        <input type="text" class="form-control" id="price" placeholder="Preço em Reais"
                                            name="price" value="{{ old('price') }}" required>
                                    </div>
                                    <div class="col-12 col-md-3 form-group px-0 pl-md-2">
                                        <label for="price_id">ID da API</label>
                                        <input type="text" class="form-control" id="price_id" placeholder="price_..."
                                            name="price_id" value="{{ old('price_id') }}" required>
                                    </div>
                                </div>
                            </div>

                            <div class="d-flex flex-wrap justify-content-between px-3">
                                <div class="col-12 form-group px-1">
                                    <label for="description">Descrição</label>
                                    <x-adminlte-textarea name="description"
                                        placeholder="Insira a descrição do produto..." />
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

@section('custom_js')
    <script src="{{ asset('vendor/jquery/jquery.inputmask.bundle.min.js') }}"></script>
    <script>
        $('#price').inputmask("currency", {
            autoUnmask: true,
            radixPoint: ",",
            groupSeparator: ".",
            allowMinus: false,
            prefix: "R$ ",
            digits: 2,
            digitsOptional: false,
            rightAlign: true,
            unmaskAsNumber: true,
        });
    </script>
@endsection
