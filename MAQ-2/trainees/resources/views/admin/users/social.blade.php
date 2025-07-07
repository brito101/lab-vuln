@extends('adminlte::page')

@section('title', '- Editar Redes Sociais')

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
                        <li class="breadcrumb-item active">Editar Redes Sociais</li>
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
                            <h3 class="card-title">Dados Cadastrais de Redes Sociais</h3>
                        </div>

                        <form method="POST" action="{{ route('admin.userNetwork.store', ['user' => $user->id]) }}"
                            enctype="multipart/form-data">
                            @method('PUT')
                            @csrf
                            <input type="hidden" name="id" value="{{ $user->id }}">
                            <div class="card-body">

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <label for="facebook">Facebook</label>
                                        <input type="url" class="form-control" id="facebook"
                                            placeholder="https://www.facebook.com/..." name="facebook"
                                            value="{{ old('facebook') ?? ($user->facebook ? $user->facebook : 'https://www.facebook.com/') }}">
                                    </div>
                                    <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                        <label for="instagram">Instagram</label>
                                        <input type="url" class="form-control" id="instagram"
                                            placeholder="https://www.instagram.com/..." name="instagram"
                                            value="{{ old('instagram') ?? ($user->instagram ? $user->instagram : 'https://www.instagram.com/') }}">
                                    </div>
                                </div>

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <label for="twitter">Twitter</label>
                                        <input type="url" class="form-control" id="twitter"
                                            placeholder="https://www.twitter.com/..." name="twitter"
                                            value="{{ old('twitter') ?? ($user->twitter ? $user->twitter : 'https://www.twitter.com/') }}">
                                    </div>
                                    <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                        <label for="linkedin">Linkedin</label>
                                        <input type="url" class="form-control" id="linkedin"
                                            placeholder="https://www.linkedin.com/in/..." name="linkedin"
                                            value="{{ old('linkedin') ?? ($user->linkedin ? $user->linkedin : 'https://www.linkedin.com/in/') }}">
                                    </div>
                                </div>

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <label for="youtube">YouTube</label>
                                        <input type="url" class="form-control" id="youtube"
                                            placeholder="https://www.youtube.com/c/..." name="youtube"
                                            value="{{ old('youtube') ?? ($user->youtube ? $user->youtube : 'https://www.youtube.com/c/') }}">
                                    </div>
                                    <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                        <label for="whatsapp">WhatsApp</label>
                                        <input type="url" class="form-control" id="whatsapp"
                                            placeholder="https://api.whatsapp.com/send?phone=..." name="whatsapp"
                                            value="{{ old('whatsapp') ?? ($user->whatsapp ? $user->whatsapp : 'https://api.whatsapp.com/send?phone=') }}">
                                    </div>
                                </div>

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <label for="telegram">Telegram</label>
                                        <input type="url" class="form-control" id="telegram"
                                            placeholder="https://t.me/@..." name="telegram"
                                            value="{{ old('telegram') ?? ($user->telegram ? $user->telegram : 'https://t.me/@') }}">
                                    </div>
                                    <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                        <label for="discord">Discord</label>
                                        <input type="url" class="form-control" id="discord"
                                            placeholder="https://discord.com/channels/..." name="discord"
                                            value="{{ old('discord') ?? ($user->discord ? $user->discord : 'https://discord.com/channels/') }}">
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
    <script src="{{ asset('js/address.js') }}"></script>
@endsection
