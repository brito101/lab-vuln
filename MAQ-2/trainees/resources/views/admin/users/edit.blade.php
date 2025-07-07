@extends('adminlte::page')

@section('title', '- Editar Usuário')
@section('plugins.select2', true)
@section('plugins.BsCustomFileInput', true)

@section('content')

    <section class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1><i class="fas fa-fw fa-user"></i> Editar Usuário</h1>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <li class="breadcrumb-item"><a href="{{ route('admin.home') }}">Home</a></li>
                        @can('Listar Usuários')
                            <li class="breadcrumb-item"><a href="{{ route('admin.users.index') }}">Usuários</a></li>
                        @endcan
                        <li class="breadcrumb-item active">Editar Usuário</li>
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
                            <h3 class="card-title">Dados Cadastrais do Usuário</h3>
                        </div>

                        <form method="POST" action="{{ route('admin.users.update', ['user' => $user->id]) }}"
                            enctype="multipart/form-data">
                            @method('PUT')
                            @csrf
                            <input type="hidden" name="id" value="{{ $user->id }}">
                            <div class="card-body">
                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <label for="name">Nome</label>
                                        <input type="text" class="form-control" id="name" placeholder="Nome Completo"
                                            name="name" value="{{ old('name') ?? $user->name }}" required>
                                    </div>
                                    <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                        <label for="genre_id">Gênero</label>
                                        <x-adminlte-select2 name="genre_id">
                                            <option value="">Não Informado</option>
                                            @foreach ($genres as $genre)
                                                <option
                                                    {{ old('genre_id') == $genre->id ? 'selected' : ($user->genre_id == $genre->id ? 'selected' : '') }}
                                                    value="{{ $genre->id }}">{{ $genre->name }}</option>
                                            @endforeach
                                        </x-adminlte-select2>
                                    </div>
                                </div>

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <label for="telephone">Telefone</label>
                                        <input type="tel" class="form-control" id="telephone" placeholder="Telefone"
                                            name="telephone" value="{{ old('telephone') ?? $user->telephone }}" required>
                                    </div>
                                    <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                        <label for="cell">Celular</label>
                                        <input type="tel" class="form-control" id="cell" placeholder="Celular" name="cell"
                                            value="{{ old('cell') ?? $user->cell }}">
                                    </div>
                                </div>

                                @if (Auth::user()->hasRole('Estagiário'))
                                    <div class="d-flex flex-wrap justify-content-between">
                                        <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                            <label for="vehicle">Veículo</label>
                                            <x-adminlte-select2 name="vehicle" required>
                                                <option
                                                    {{ old('vehicle') == 'Não possuo veículo' ? 'selected' : ($user->vehicle == 'Não possuo veículo' ? 'selected' : '') }}
                                                    value="Não possuo veículo">Não possuo veículo</option>
                                                <option
                                                    {{ old('vehicle') == 'Possuo carro' ? 'selected' : ($user->vehicle == 'Possuo carro' ? 'selected' : '') }}
                                                    value="Possuo carro">Possuo carro</option>
                                                <option
                                                    {{ old('vehicle') == 'Possuo moto' ? 'selected' : ($user->vehicle == 'Possuo moto' ? 'selected' : '') }}
                                                    value="Possuo moto">Possuo moto</option>
                                            </x-adminlte-select2>
                                        </div>

                                        <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                            <label for="team_work">Trabalho em Equipe</label>
                                            <x-adminlte-select2 name="team_work" required>
                                                <option
                                                    {{ old('team_work') == 'Sou líder de equipe' ? 'selected' : ($user->team_work == 'Sou líder de equipe' ? 'selected' : '') }}
                                                    value="Sou líder de equipe">Sou líder de equipe</option>
                                                <option
                                                    {{ old('team_work') == 'Trabalho muito bem em equipe' ? 'selected' : ($user->team_work == 'Trabalho muito bem em equipe' ? 'selected' : '') }}
                                                    value="Trabalho muito bem em equipe">Trabalho muito bem em equipe
                                                </option>
                                                <option
                                                    {{ old('team_work') == 'Sou bom em uma equipe' ? 'selected' : ($user->team_work == 'Sou bom em uma equipe' ? 'selected' : '') }}
                                                    value="Sou bom em uma equipe">Sou bom em uma equipe</option>
                                                <option
                                                    {{ old('team_work') == 'Trabalho melhor sozinho' ? 'selected' : ($user->team_work == 'Trabalho melhor sozinho' ? 'selected' : '') }}
                                                    value="Trabalho melhor sozinho">Trabalho melhor sozinho</option>
                                                <option
                                                    {{ old('team_work') == 'Indiferente' ? 'selected' : ($user->team_work == 'Indiferente' ? 'selected' : '') }}
                                                    value="Indiferente">Indiferente</option>
                                            </x-adminlte-select2>
                                        </div>
                                    </div>
                                @endif

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2 d-flex flex-wrap">

                                        <div class="col-12 px-0">
                                            <x-adminlte-input-file name="photo"
                                                label="Foto (formatos: jpg, jpeg, gif, svg ou webp com tamanho máximo de 1MB e dimensões máximas de 1800x1800px)"
                                                placeholder="Selecione uma imagem..." legend="Selecionar" />
                                        </div>

                                        @if ($user->photo != null)
                                            <div class='col-12 d-flex justify-content-center align-items-center px-0'>
                                                <img src="{{ url('storage/users/' . $user->photo) }}"
                                                    alt="{{ $user->name }}" style="margin: auto; max-width: 50%;"
                                                    class="img-thumbnail d-block">
                                            </div>
                                        @endif
                                    </div>

                                    @if (Auth::user()->hasRole('Estagiário'))
                                        <div class="col-12 col-md-6 form-group px-0 pl-md-2 d-flex flex-wrap">
                                            <div class="col-12 form-group px-0">
                                                <label for="instagram">Vídeo de apresentação do Youtube</label>
                                                <input type="url" class="form-control" id="video"
                                                    placeholder="https://www.youtube.com/watch?v=..." name="video"
                                                    value="{{ old('video') ?? ($user->video ? $user->video : '') }}">

                                                @if ($user->video != null)
                                                    <div class='col-12 align-self-center mt-3 mb-n3 d-flex px-0'>
                                                        <div
                                                            class=' embed-responsive
                                                                                                                                                                                embed-responsive-16by9'>
                                                            <iframe class="embed-responsive-item rounded"
                                                                src="{{ Str::replace('https://www.youtube.com/watch?v=', 'https://www.youtube.com/embed/', $user->video) }}"
                                                                title="YouTube video player" frameborder="0"
                                                                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                                                                allowfullscreen></iframe>
                                                        </div>
                                                    </div>
                                                @endif
                                            </div>
                                        </div>

                                    @endif
                                </div>

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <label for="email">E-mail</label>
                                        <input type="email" class="form-control" id="email" placeholder="E-mail"
                                            name="email" value="{{ old('email') ?? $user->email }}" required>
                                    </div>
                                    <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                        <label for="password">Senha</label>
                                        <input type="password" class="form-control" id="password" placeholder="Senha"
                                            minlength="8" name="password" value="">
                                    </div>
                                </div>
                                <div class="d-flex flex-wrap justify-content-between">
                                    @can('Atribuir Perfis')
                                        <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                            <label for="role">Tipo de Usuário</label>
                                            <x-adminlte-select2 name="role">
                                                @foreach ($roles as $role)
                                                    <option
                                                        {{ old('role') == $role->name ? 'selected' : ($user->roles->first()->id == $role->id ? 'selected' : '') }}
                                                        value="{{ $role->name }}">{{ $role->name }}</option>
                                                @endforeach
                                            </x-adminlte-select2>
                                        </div>
                                    @endcan
                                    @if (Auth::user()->id != $user->id)
                                        @can('Atribuir Franquias')
                                            <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                                <label for="affiliation_id">Franquia</label>
                                                <x-adminlte-select2 name="affiliation_id">
                                                    <option value="">Não Informado</option>
                                                    @foreach ($affiliations as $affiliation)
                                                        <option
                                                            {{ old('affiliation_id') == $affiliation->id ? 'selected' : ($user->affiliation_id == $affiliation->id ? 'selected' : '') }}
                                                            value="{{ $affiliation->id }}">{{ $affiliation->alias_name }}
                                                        </option>
                                                    @endforeach
                                                </x-adminlte-select2>
                                            </div>
                                        @endcan
                                        @can('Atribuir Empresas')
                                            <div
                                                class="col-12 col-md-6 form-group px-0 {{ Auth::user()->hasPermissionTo('Atribuir Perfis') ? 'pl-md-2' : 'pr-md-2' }}">
                                                <label for="company_id">Empresa</label>
                                                <x-adminlte-select2 name="company_id">
                                                    <option value="">Não Informado</option>
                                                    @foreach ($companies as $company)
                                                        <option
                                                            {{ old('company_id') == $company->id ? 'selected' : ($user->company_id == $company->id ? 'selected' : '') }}
                                                            value="{{ $company->id }}">{{ $company->alias_name }}
                                                        </option>
                                                    @endforeach
                                                </x-adminlte-select2>
                                            </div>
                                        @endcan
                                    @endif
                                </div>


                            </div>

                            <div class="card-footer">
                                <button type="submit" class="btn btn-primary">Atualizar</button>
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
    <script src="{{ asset('js/phone.js') }}"></script>
@endsection
