@extends('adminlte::page')
@section('plugins.Summernote', true)

@section('title', '- Editar Redação')

@section('content')

    <section class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1><i class="fas fa-fw fa-file-contract"></i> Editar Redação</h1>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <li class="breadcrumb-item"><a href="{{ route('admin.home') }}">Home</a></li>
                        <li class="breadcrumb-item active">Editar Redação</li>
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
                        <div class="card-header d-flex justify-content-between">
                            <h3 class="card-title">Tema da Redação: <b>Quem sou eu</b></h3>
                        </div>

                        <form method="POST" action="{{ route('admin.composing.store') }}" enctype="multipart/form-data">
                            @method('PUT')
                            @csrf
                            @isset($composing->id)
                                <input type="hidden" name="id" value="{{ $composing->id }}">
                            @endisset
                            <div class="card-body">

                                <div class="col-12 form-group px-0 pr-md-2">
                                    <label for="title">Título</label>
                                    <input type="text" class="form-control text-center" id="title"
                                        placeholder="Título da Redação" name="title"
                                        value="{{ old('title') ?? (isset($composing->title) ? $composing->title : '') }}"
                                        required>
                                </div>

                                <div class="col-12 form-group px-0 pr-md-2">
                                    <label for="content">Texto</label>

                                    <x-adminlte-text-editor name="content" rows="30"
                                        placeholder="Escreva sua redação aqui...">
                                        {{ old('content') ?? (isset($composing->content) ? $composing->content : '') }}
                                    </x-adminlte-text-editor>
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
