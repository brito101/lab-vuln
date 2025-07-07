@extends('adminlte::page')
@section('plugins.BsCustomFileInput', true)

@section('title', '- Imagens de Compartilhamento')

@section('content')

    <section class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1><i class="fas fa-fw fa-images"></i> Imagens de Compartilhamento</h1>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <li class="breadcrumb-item"><a href="{{ route('admin.home') }}">Home</a></li>
                        <li class="breadcrumb-item active">Imagens de Compartilhamento</li>
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
                            <h3 class="card-title">Imagens de compartilhamento da Empresa</h3>
                        </div>

                        <form method="POST" action="{{ route('admin.company.brand.store') }}"
                            enctype="multipart/form-data">
                            @method('PUT')
                            @csrf
                            <div class=" card-body">
                                <input type="hidden" name="id" value="{{ $company->id }}">

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 form-group px-0 d-flex flex-wrap">
                                        <div
                                            class="{{ $company->brand_facebook != null ? 'col-md-9' : 'col-md-12' }} px-0">
                                            <x-adminlte-input-file name="brand_facebook"
                                                label="Compartilhamento para Facebook (recomendável 1200 x 630 pixels)"
                                                placeholder="Selecione uma imagem..." legend="Selecionar" />
                                        </div>

                                        @if ($company->brand_facebook != null)
                                            <div
                                                class='col-12 col-md-3 align-self-center mt-3 d-flex justify-content-center justify-content-md-end px-0'>
                                                <img src="{{ url('storage/companies/' . $company->brand_facebook) }}"
                                                    alt="Imagem para o Facebook" style="max-width: 80%;"
                                                    class="img-thumbnail d-block">
                                            </div>
                                        @endif
                                    </div>

                                    <div class="col-12 form-group px-0 d-flex flex-wrap">
                                        <div
                                            class="{{ $company->brand_instagram != null ? 'col-md-9' : 'col-md-12' }} px-0">
                                            <x-adminlte-input-file name="brand_instagram"
                                                label="Compartilhamento para Instagram (recomendável 1080 x 1080 pixels, quadrada)"
                                                placeholder="Selecione uma imagem..." legend="Selecionar" />
                                        </div>

                                        @if ($company->brand_instagram != null)
                                            <div
                                                class='col-12 col-md-3 align-self-center mt-3 d-flex justify-content-center justify-content-md-end px-0'>
                                                <img src="{{ url('storage/companies/' . $company->brand_instagram) }}"
                                                    alt="Imagem para o Instagram" style="max-width: 80%;"
                                                    class="img-thumbnail d-block">
                                            </div>
                                        @endif
                                    </div>

                                    <div class="col-12 form-group px-0 d-flex flex-wrap">
                                        <div
                                            class="{{ $company->brand_twitter != null ? 'col-md-9' : 'col-md-12' }} px-0">
                                            <x-adminlte-input-file name="brand_twitter"
                                                label="Compartilhamento para Twitter (recomendável 1.1600 x 900  pixels ou proporção 16:9)"
                                                placeholder="Selecione uma imagem..." legend="Selecionar" />
                                        </div>

                                        @if ($company->brand_twitter != null)
                                            <div
                                                class='col-12 col-md-3 align-self-center mt-3 d-flex justify-content-center justify-content-md-end px-0'>
                                                <img src="{{ url('storage/companies/' . $company->brand_twitter) }}"
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
