@extends('adminlte::page')

@section('title', '- Redes Sociais')

@section('content')

    <section class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1><i class="fa fa-fw fa-share-alt"></i> Editar Redes Sociais</h1>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <li class="breadcrumb-item"><a href="{{ route('admin.home') }}">Home</a></li>
                        <li class="breadcrumb-item active">Editar Redes Sociais da Empresa</li>
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
                            <h3 class="card-title">Redes Sociais da Empresa</h3>
                        </div>

                        <form method="POST" action="{{ route('admin.company.social.store') }}">
                            @method('PUT')
                            @csrf
                            <div class="card-body">
                                <input type="hidden" name="id" value="{{ $company->id }}">
                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <label for="facebook">Facebook</label>
                                        <input type="url" class="form-control" id="facebook"
                                            placeholder="https://www.facebook.com/..." name="facebook"
                                            value="{{ old('facebook') ?? ($company->facebook ? $company->facebook : '') }}">
                                    </div>
                                    <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                        <label for="instagram">Instagram</label>
                                        <input type="url" class="form-control" id="instagram"
                                            placeholder="https://www.instagram.com/..." name="instagram"
                                            value="{{ old('instagram') ?? ($company->instagram ? $company->instagram : '') }}">
                                    </div>
                                </div>

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <label for="twitter">Twitter</label>
                                        <input type="url" class="form-control" id="twitter"
                                            placeholder="https://www.twitter.com/..." name="twitter"
                                            value="{{ old('twitter') ?? ($company->twitter ? $company->twitter : '') }}">
                                    </div>
                                    <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                        <label for="linkedin">Linkedin</label>
                                        <input type="url" class="form-control" id="linkedin"
                                            placeholder="https://www.linkedin.com/in/..." name="linkedin"
                                            value="{{ old('linkedin') ?? ($company->linkedin ? $company->linkedin : '') }}">
                                    </div>
                                </div>

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <label for="youtube">YouTube</label>
                                        <input type="url" class="form-control" id="youtube"
                                            placeholder="https://www.youtube.com/c/..." name="youtube"
                                            value="{{ old('youtube') ?? ($company->youtube ? $company->youtube : '') }}">
                                    </div>
                                    <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                        <label for="whatsapp">WhatsApp</label>
                                        <input type="url" class="form-control" id="whatsapp"
                                            placeholder="https://api.whatsapp.com/send?phone=..." name="whatsapp"
                                            value="{{ old('whatsapp') ?? ($company->whatsapp ? $company->whatsapp : '') }}">
                                    </div>
                                </div>

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <label for="telegram">Telegram</label>
                                        <input type="url" class="form-control" id="telegram"
                                            placeholder="https://t.me/@..." name="telegram"
                                            value="{{ old('telegram') ?? ($company->telegram ? $company->telegram : '') }}">
                                    </div>
                                    <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                        <label for="discord">Discord</label>
                                        <input type="url" class="form-control" id="discord"
                                            placeholder="https://discord.com/channels/..." name="discord"
                                            value="{{ old('discord') ?? ($company->discord ? $company->discord : '') }}">
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
