@extends('adminlte::page')

@section('title', '- Cadastro de Usuário')
@section('plugins.select2', true)
@section('plugins.BsCustomFileInput', true)

@section('content')

    <section class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1><i class="fas fa-fw fa-user"></i> Novo Usuário</h1>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <li class="breadcrumb-item"><a href="{{ route('admin.home') }}">Home</a></li>
                        <li class="breadcrumb-item"><a href="{{ route('admin.users.index') }}">Usuários</a></li>
                        <li class="breadcrumb-item active">Novo Usuário</li>
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

                        <form method="POST" action="{{ route('admin.users.store') }}" enctype="multipart/form-data">
                            @csrf
                            <div class="card-body">

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <label for="name">Nome</label>
                                        <input type="text" class="form-control" id="name" placeholder="Nome Completo"
                                            name="name" value="{{ old('name') }}" required>
                                    </div>
                                    <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                        <label for="genre_id">Gênero</label>
                                        <x-adminlte-select2 name="genre_id">
                                            <option value="">Não Informado</option>
                                            @foreach ($genres as $genre)
                                                <option {{ old('genre_id') == $genre->id ? 'selected' : '' }}
                                                    value="{{ $genre->id }}">{{ $genre->name }}</option>
                                            @endforeach
                                        </x-adminlte-select2>
                                    </div>
                                </div>

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <label for="telephone">Telefone</label>
                                        <input type="tel" class="form-control" id="telephone" placeholder="Telefone"
                                            name="telephone" value="{{ old('telephone') }}" required>
                                    </div>
                                    <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                        <label for="cell">Celular</label>
                                        <input type="tel" class="form-control" id="cell" placeholder="Celular" name="cell"
                                            value="{{ old('cell') }}">
                                    </div>
                                </div>

                                @if (Auth::user()->hasRole('Estagiário'))
                                    <div class="d-flex flex-wrap justify-content-between">
                                        <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                            <label for="vehicle">Veículo</label>
                                            <x-adminlte-select2 name="vehicle">
                                                <option {{ old('vehicle') == 'Não possuo veículo' ? 'selected' : '' }}
                                                    value="Não possuo veículo">Não possuo veículo</option>
                                                <option {{ old('vehicle') == 'Possuo carro' ? 'selected' : '' }}
                                                    value="Possuo carro">Possuo carro</option>
                                                <option {{ old('vehicle') == 'Possuo moto' ? 'selected' : '' }}
                                                    value="Possuo moto">Possuo moto</option>
                                            </x-adminlte-select2>
                                        </div>
                                        <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                            <label for="team_work">Trabalho em Equipe</label>
                                            <x-adminlte-select2 name="team_work">
                                                <option {{ old('team_work') == 'Sou líder de equipe' ? 'selected' : '' }}
                                                    value="Sou líder de equipe">Sou líder de equipe</option>
                                                <option
                                                    {{ old('team_work') == 'Trabalho muito bem em equipe' ? 'selected' : '' }}
                                                    value="Trabalho muito bem em equipe">Trabalho muito bem em equipe
                                                </option>
                                                <option
                                                    {{ old('team_work') == 'Sou bom em uma equipe' ? 'selected' : '' }}
                                                    value="Sou bom em uma equipe">Sou bom em uma equipe</option>
                                                <option
                                                    {{ old('team_work') == 'Trabalho melhor sozinho' ? 'selected' : '' }}
                                                    value="Trabalho melhor sozinho">Trabalho melhor sozinho</option>
                                                <option {{ old('team_work') == 'Indiferente' ? 'selected' : '' }}
                                                    value="Indiferente">Indiferente</option>
                                            </x-adminlte-select2>
                                        </div>
                                    </div>
                                @endif

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <x-adminlte-input-file name="photo"
                                            label="Foto (formatos: jpg, jpeg, gif, svg ou webp com tamanho máximo de 1MB e dimensões máximas de 1800x1800px)"
                                            placeholder="Selecione uma imagem..." legend="Selecionar" />
                                    </div>

                                    @if (Auth::user()->hasRole('Estagiário'))
                                        <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                            <label for="instagram">Vídeo de apresentação do Youtube</label>
                                            <input type="url" class="form-control" id="video"
                                                placeholder="https://www.youtube.com/watch?v=..." name="video"
                                                value="{{ old('video') }}">
                                        </div>
                                    @endif
                                </div>

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <label for="email">E-mail</label>
                                        <input type="email" class="form-control" id="email" placeholder="E-mail"
                                            name="email" value="{{ old('email') }}" required>
                                    </div>
                                    <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                        <label for="password">Senha</label>
                                        <input type="password" class="form-control" id="password" placeholder="Senha"
                                            minlength="8" name="password" value="{{ old('password') }}" required>
                                    </div>
                                </div>
                                <div class="d-flex flex-wrap justify-content-between">
                                    @can('Atribuir Perfis')
                                        <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                            <label for="role">Tipo de Usuário</label>
                                            <x-adminlte-select2 name="role">
                                                @foreach ($roles as $role)
                                                    <option {{ old('role') == $role->name ? 'selected' : '' }}
                                                        value="{{ $role->name }}">{{ $role->name }}</option>
                                                @endforeach
                                            </x-adminlte-select2>
                                        </div>

                                    @endcan
                                    @can('Atribuir Empresas')
                                        <div
                                            class="col-12 col-md-6 form-group px-0 {{ Auth::user()->hasPermissionTo('Atribuir Perfis') ? 'pr-md-2' : 'pl-md-2' }}">
                                            <label for="company_id">Empresa</label>
                                            <x-adminlte-select2 name="company_id">
                                                <option value="">Não Informado</option>
                                                @foreach ($companies as $company)
                                                    <option {{ old('company_id') == $company->id ? 'selected' : '' }}
                                                        value="{{ $company->id }}">{{ $company->alias_name }}
                                                    </option>
                                                @endforeach
                                            </x-adminlte-select2>
                                        </div>
                                    @endcan
                                    @can('Atribuir Franquias')
                                        <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                            <label for="affiliation_id">Franquia</label>
                                            <x-adminlte-select2 name="affiliation_id">
                                                <option value="">Não Informado</option>
                                                @foreach ($affiliations as $affiliation)
                                                    <option {{ old('affiliation_id') == $affiliation->id ? 'selected' : '' }}
                                                        value="{{ $affiliation->id }}">{{ $affiliation->alias_name }}
                                                    </option>
                                                @endforeach
                                            </x-adminlte-select2>
                                        </div>
                                    @endcan
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
    <script src="{{ asset('js/phone.js') }}"></script>
@endsection
