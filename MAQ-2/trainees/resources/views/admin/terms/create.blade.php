@extends('adminlte::page')
@section('plugins.select2', true)
@section('plugins.Summernote', true)

@section('title', '- Cadastro de Termo')

@section('content')

    <section class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1><i class="far fa-fw fa-file"></i> Novo Termo</h1>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <li class="breadcrumb-item"><a href="{{ route('admin.home') }}">Home</a></li>
                        <li class="breadcrumb-item"><a href="{{ route('admin.terms.index') }}">Termos</a></li>
                        <li class="breadcrumb-item active">Novo Termo</li>
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
                            <h3 class="card-title">Dados Cadastrais do Termo</h3>
                        </div>

                        <form method="POST" action="{{ route('admin.terms.store') }}">
                            @csrf
                            <div class="card-body">

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <label for="title">Modelo do Termo</label>
                                        <input type="text" class="form-control" id="title"
                                            placeholder="Título do Modelo do Termo" name="title"
                                            value="{{ old('title') }}" required>
                                    </div>
                                    <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                        <x-adminlte-select2 name="type" label="Tipo">
                                            <option {{ old('type') == 'Ativação de Franquia' ? 'selected' : '' }}>Ativação
                                                de Franquia</option>
                                            <option {{ old('type') == 'Início de Cooperação' ? 'selected' : '' }}>Início
                                                de Cooperação</option>
                                            <option {{ old('type') == 'Cancelamento' ? 'selected' : '' }}>Cancelamento
                                            </option>
                                        </x-adminlte-select2>
                                    </div>
                                </div>

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <x-adminlte-select2 name="participant_primary" label="Participante Primário">
                                            <option {{ old('type') == env('APP_NAME') ? 'selected' : '' }}>
                                                {{ env('APP_NAME') }}</option>
                                            <option {{ old('type') == 'Franquia' ? 'selected' : '' }}>Franquia</option>
                                            <option {{ old('type') == 'Empresa' ? 'selected' : '' }}>Empresa
                                            </option>
                                            <option {{ old('type') == 'Estagiário' ? 'selected' : '' }}>Estagiário
                                            </option>
                                            <option {{ old('type') == 'Instituição de Ensino' ? 'selected' : '' }}>
                                                Instituição de Ensino
                                            </option>
                                        </x-adminlte-select2>
                                    </div>
                                    <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                        <x-adminlte-select2 name="participant_secondary" label="Participante Secundário">
                                            <option {{ old('type') == 'Franquia' ? 'selected' : '' }}>Franquia</option>
                                            <option {{ old('type') == 'Empresa' ? 'selected' : '' }}>Empresa
                                            </option>
                                            <option {{ old('type') == 'Estagiário' ? 'selected' : '' }}>Estagiário
                                            </option>
                                            <option {{ old('type') == 'Instituição de Ensino' ? 'selected' : '' }}>
                                                Instituição de Ensino
                                            </option>
                                        </x-adminlte-select2>
                                    </div>
                                </div>

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-12 form-group px-0">
                                        @php
                                            $config = [
                                                'height' => '300',
                                                'toolbar' => [
                                                    // [groupName, [list of button]]
                                                    ['style', ['bold', 'italic', 'underline', 'clear']],
                                                    ['font', ['strikethrough', 'superscript', 'subscript']],
                                                    ['fontsize', ['fontsize']],
                                                    ['color', ['color']],
                                                    ['para', ['ul', 'ol', 'paragraph']],
                                                    ['imagesize', ['imageSize100', 'imageSize50', 'imageSize25']],
                                                    ['float', ['floatLeft', 'floatRight', 'floatNone']],
                                                    ['remove', ['removeMedia']],
                                                    ['height', ['height']],
                                                    ['table', ['table']],
                                                    ['insert', ['link', 'picture', 'video']],
                                                    ['view', ['fullscreen', 'codeview', 'help']],
                                                ],
                                            ];
                                        @endphp
                                        <x-adminlte-text-editor name="content" label="" igroup-size="sm"
                                            label="Texto de Conteúdo" placeholder="Escreva o texto do termo aqui..."
                                            :config="$config">
                                            {{ old('content') ?? '' }}
                                        </x-adminlte-text-editor>
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
