@extends('adminlte::page')

@section('title', '- Editar Documentação')
@section('plugins.select2', true)

@section('content')

    <section class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1><i class="fas fa-fw fa-file"></i> Editar Documentação</h1>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <li class="breadcrumb-item"><a href="{{ route('admin.home') }}">Home</a></li>
                        <li class="breadcrumb-item active">Editar Documentação</li>
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
                            <h3 class="card-title">Dados Cadastrais de Documentação</h3>
                        </div>

                        <form method="POST" action="{{ route('admin.document.store', ['user' => $user->id]) }}"
                            enctype="multipart/form-data">
                            @method('PUT')
                            @csrf
                            <input type="hidden" name="id" value="{{ $user->id }}">
                            <div class="card-body">
                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <label for="birth">Data de Nascimento</label>
                                        <input type="text" class="form-control date" id="birth"
                                            placeholder="Data de Nascimento" name="birth"
                                            value="{{ old('birth') ?? $user->birth }}" required>
                                    </div>
                                    <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                        <label for="first_parent">Primeiro Parente</label>
                                        <input type="text" class="form-control" id="first_parent"
                                            placeholder="Nome do parente" name="first_parent"
                                            value="{{ old('first_parent') ?? $user->first_parent }}">
                                    </div>
                                </div>

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <label for="second_parent">Segundo Parente</label>
                                        <input type="text" class="form-control" id="second_parent"
                                            placeholder="Nome do parente" name="second_parent"
                                            value="{{ old('second_parent') ?? $user->second_parent }}">
                                    </div>
                                    <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                        <label for="civil_status">Estado Civil</label>
                                        <x-adminlte-select2 name="civil_status">
                                            <option {{ old('civil_status') == 'Não Informado' ? 'selected' : '' }}
                                                value="Não Informado">Não Informado</option>
                                            <option {{ old('civil_status') == 'Casado' ? 'selected' : '' }}
                                                value="Casado">Casado</option>
                                            <option {{ old('civil_status') == 'Divorciado' ? 'selected' : '' }}
                                                value="Divorciado">Divorciado</option>
                                            <option {{ old('civil_status') == 'Solteiro' ? 'selected' : '' }}
                                                value="Viúvo">Viúvo</option>
                                            <option {{ old('civil_status') == 'Viúvo' ? 'selected' : '' }}
                                                value="Viúvo">
                                                Viúvo</option>
                                        </x-adminlte-select2>
                                    </div>
                                </div>

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <label for="children">Nº de Filhos</label>
                                        <input type="text" class="form-control" id="children" placeholder="Quantidade"
                                            name="children" value="{{ old('children') ?? $user->children }}" required>
                                    </div>
                                    <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                        <label for="nationality">Nacionalidade</label>
                                        <input type="text" class="form-control" id="nationality"
                                            placeholder="Nacionalidade" name="nationality"
                                            value="{{ old('nationality') ?? $user->nationality }}">
                                    </div>
                                </div>

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <label for="document_person">CPF</label>
                                        <input type="text" class="form-control" id="document_person" placeholder="CPF"
                                            name="document_person"
                                            value="{{ old('document_person') ?? $user->document_person }}" required>
                                    </div>
                                    <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                        <label for="document_registry">RG</label>
                                        <input type="text" class="form-control" id="document_registry" placeholder="RG"
                                            name="document_registry"
                                            value="{{ old('document_registry') ?? $user->document_registry }}" required>
                                    </div>
                                </div>

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <label for="issuer">Orgão Emissor</label>
                                        <input type="text" class="form-control" id="issuer"
                                            placeholder="Orgão Emissor" name="issuer"
                                            value="{{ old('issuer') ?? $user->issuer }}" required>
                                    </div>
                                    <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                        <label for="document_registry">Data de Emissão</label>
                                        <input type="text" class="form-control date" id="date_issue"
                                            placeholder="Data de Emissão" name="date_issue"
                                            value="{{ old('date_issue') ?? $user->date_issue }}" required>
                                    </div>
                                </div>

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <label for="work_card">Carteira de Trabalho</label>
                                        <input type="text" class="form-control" id="work_card"
                                            placeholder="Carteira de Trabalho" name="work_card"
                                            value="{{ old('work_card') ?? $user->work_card }}">
                                    </div>
                                    <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                        <label for="serie">Nº de Série</label>
                                        <input type="text" class="form-control" id="serie"
                                            placeholder="Nº de Série" name="serie"
                                            value="{{ old('serie') ?? $user->serie }}">
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

@section('custom_js')
    <script src="{{ asset('vendor/jquery/jquery.inputmask.bundle.min.js') }}"></script>
    <script>
        $('.date').inputmask("99/99/9999");
        $('#document_person').inputmask("999.999.999-99");
    </script>
@endsection
