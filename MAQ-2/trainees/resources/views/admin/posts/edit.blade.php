@extends('adminlte::page')

@section('title', '- Edição de Post')
@section('plugins.BsCustomFileInput', true)
@section('plugins.Summernote', true)

@section('content')

    <section class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1><i class="fas fa-fw fa-blog"></i> Editar Post</h1>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <li class="breadcrumb-item"><a href="{{ route('admin.home') }}">Home</a></li>
                        <li class="breadcrumb-item"><a href="{{ route('admin.posts.index') }}">Posts</a></li>
                        <li class="breadcrumb-item active">Editar Post</li>
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
                            <h3 class="card-title">Dados Cadastrais do Post</h3>
                        </div>

                        <form method="POST" action="{{ route('admin.posts.update', ['post' => $post->id]) }}"
                            enctype="multipart/form-data">
                            @method('PUT')
                            @csrf
                            <input type="hidden" name="id" value="{{ $post->id }}">
                            <div class="card-body">

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <label for="title">Título</label>
                                        <input type="text" class="form-control" id="title" placeholder="Título do Post"
                                            name="title" value="{{ old('title') ?? $post->title }}" required>
                                    </div>
                                    <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                        <label for="headline">Headline</label>
                                        <input type="text" class="form-control" id="headline"
                                            placeholder="Headline para o Post" name="headline"
                                            value="{{ old('headline') ?? $post->headline }}" required>
                                    </div>
                                </div>

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 form-group px-0 d-flex flex-wrap">
                                        <div class="{{ $post->cover != null ? 'col-md-9' : 'col-md-12' }} px-0">
                                            <x-adminlte-input-file name="cover"
                                                label="Foto de Capa (recomendável 1200 x 630 pixels)"
                                                placeholder="Selecione uma imagem..." legend="Selecionar" />
                                        </div>

                                        @if ($post->cover != null)
                                            <div
                                                class='col-12 col-md-3 align-self-center mt-3 d-flex justify-content-center justify-content-md-end px-0'>
                                                <img src="{{ url('storage/posts/' . $post->cover) }}" alt="Foto de Capa"
                                                    style="max-width: 80%;" class="img-thumbnail d-block">
                                            </div>
                                        @endif
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
                                                        ['height', ['height']],
                                                        ['table', ['table']],
                                                        ['insert', ['link', 'picture', 'video']],
                                                        ['view', ['fullscreen', 'codeview', 'help']],
                                                    ],
                                                ];
                                            @endphp
                                            <x-adminlte-text-editor name="content" label="" igroup-size="sm"
                                                placeholder="Escreva o conteúdo do post aqui..." :config="$config">
                                                {{ old('content') ?? $post->content }}
                                            </x-adminlte-text-editor>
                                        </div>
                                    </div>

                                    <h5 class="text-muted">Imagens de Compartilhamento (opcional)</h5>

                                    <div class="d-flex flex-wrap justify-content-between">
                                        <div class="col-12 form-group px-0 d-flex flex-wrap">
                                            <div
                                                class="{{ $post->brand_facebook != null ? 'col-md-9' : 'col-md-12' }} px-0">
                                                <x-adminlte-input-file name="brand_facebook"
                                                    label="Compartilhamento para Facebook (recomendável 1200 x 630 pixels)"
                                                    placeholder="Selecione uma imagem..." legend="Selecionar" />
                                            </div>

                                            @if ($post->brand_facebook != null)
                                                <div
                                                    class='col-12 col-md-3 align-self-center mt-3 d-flex justify-content-center justify-content-md-end px-0'>
                                                    <img src="{{ url('storage/posts/' . $post->brand_facebook) }}"
                                                        alt="Imagem para o Facebook" style="max-width: 80%;"
                                                        class="img-thumbnail d-block">
                                                </div>
                                            @endif
                                        </div>

                                        <div class="col-12 form-group px-0 d-flex flex-wrap">
                                            <div
                                                class="{{ $post->brand_instagram != null ? 'col-md-9' : 'col-md-12' }} px-0">
                                                <x-adminlte-input-file name="brand_instagram"
                                                    label="Compartilhamento para Instagram (recomendável 1080 x 1080 pixels, quadrada)"
                                                    placeholder="Selecione uma imagem..." legend="Selecionar" />
                                            </div>

                                            @if ($post->brand_instagram != null)
                                                <div
                                                    class='col-12 col-md-3 align-self-center mt-3 d-flex justify-content-center justify-content-md-end px-0'>
                                                    <img src="{{ url('storage/posts/' . $post->brand_instagram) }}"
                                                        alt="Imagem para o Instagram" style="max-width: 80%;"
                                                        class="img-thumbnail d-block">
                                                </div>
                                            @endif
                                        </div>

                                        <div class="col-12 form-group px-0 d-flex flex-wrap">
                                            <div
                                                class="{{ $post->brand_twitter != null ? 'col-md-9' : 'col-md-12' }} px-0">
                                                <x-adminlte-input-file name="brand_twitter"
                                                    label="Compartilhamento para Twitter (recomendável 1.1600 x 900  pixels ou proporção 16:9)"
                                                    placeholder="Selecione uma imagem..." legend="Selecionar" />
                                            </div>

                                            @if ($post->brand_twitter != null)
                                                <div
                                                    class='col-12 col-md-3 align-self-center mt-3 d-flex justify-content-center justify-content-md-end px-0'>
                                                    <img src="{{ url('storage/posts/' . $post->brand_twitter) }}"
                                                        alt="Imagem para o twitter" style="max-width: 80%;"
                                                        class="img-thumbnail d-block">
                                                </div>
                                            @endif
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
