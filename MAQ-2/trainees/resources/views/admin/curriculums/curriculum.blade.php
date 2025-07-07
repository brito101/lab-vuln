@extends('adminlte::page')

@section('title', '- Visualizar Currículo')

@section('content')
    <section class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1><i class="fas fa-fw fa-file-alt"></i> Currículo</h1>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <li class="breadcrumb-item active">Currículo</li>
                    </ol>
                </div>
            </div>
        </div>
    </section>

    <div class="row d-flex justify-content-end container py-2 px-0">
        <a href="{{ route('admin.curriculum.pdf', ['id' => $user->id]) }}" target="_blank" class="btn btn-primary"><i
                class="fa fa-print"></i> Imprimir Currículo</a>
        @if (Auth::user()->hasRole('Franquiado'))
            <a href="{{ route('admin.documents.show', ['id' => $user->id]) }}" class="ml-2 btn btn-info"><i
                    class="fa fa-file-upload"></i> Doc. Comprobatórios</a>
        @endif
    </div>

    <section class="content">
        <div class="container-fluid">
            <div class="row">

                <div class="col-12 col-md-3">
                    <div class="card card-primary card-outline">
                        <div class="card-body box-profile">
                            <div class="text-center">
                                <img class="profile-user-img img-fluid img-circle"
                                    src="{{ $user->photo != null ? url('storage/users/' . $user->photo) : asset('/vendor/adminlte/dist/img/avatar.png') }}"
                                    alt="{{ $user->name }}" style="object-fit: cover; aspect-ratio: 1;">
                            </div>
                            <h3 class="profile-username text-center">{{ $user->name }}</h3>
                            <p class="text-muted text-center">Tenho {{ $user->age() }}</p>
                            <p class="text-muted text-center">Gênero: {{ $user->genre['name'] }}</p>
                        </div>
                    </div>

                    <div class="card card-primary">
                        <div class="card-header">
                            <h3 class="card-title">Sobre mim</h3>
                        </div>
                        <div class="card-body">
                            @if (!empty($user->team_work))
                                <strong><i class="fa fa-users mr-1"></i> Trabalho em equipe</strong>
                                <p class="text-muted">{{ $user->team_work }}</p>
                                <hr>
                            @endif
                            @if (!empty($user->vehicle))
                                <strong><i class="fa fa-car mr-1"></i> Veículo</strong>
                                <p class="text-muted">{{ $user->vehicle }}</p>
                                <hr>
                            @endif
                            @if (!empty($user->city))
                                <strong><i class="fas fa-map-marker-alt mr-1"></i> Localização</strong>
                                <p class="text-muted">{{ $user->city }}-{{ $user->state }}</p>
                                <hr>
                            @endif
                            @if (!empty($user->telephone))
                                <strong><i class="fas fa-phone-alt mr-1"></i> Telefone</strong>
                                <p class="text-muted">{{ $user->telephone }}</p>
                                <hr>
                            @endif
                            @if (!empty($user->cell))
                                <strong><i class="fa fa-mobile mr-1"></i> Celular</strong>
                                <p class="text-muted">{{ $user->cell }}</p>
                                <hr>
                            @endif
                            <strong><i class="fa fa-mail-bulk mr-1"></i> E-mail</strong>
                            <p class="text-muted">{{ $user->email }}</p>
                            <hr>
                        </div>
                    </div>
                </div>

                <div class="col-12 col-md-9">
                    <div class="card">
                        <div class="card-header p-2">
                            <ul class="nav nav-pills">
                                <li class="nav-item"><a class="nav-link active" href="#courses" data-toggle="tab">Info.
                                        Acadêmicas</a></li>
                                <li class="nav-item"><a class="nav-link" href="#extracourses" data-toggle="tab">Cursos
                                        Extracurriculares</a></li>
                                <li class="nav-item"><a class="nav-link" href="#experience" data-toggle="tab">Exp.
                                        Profissional</a></li>
                                <li class="nav-item"><a class="nav-link" href="#composing" data-toggle="tab">Redação</a>
                                </li>
                                @if ($user->requiriment->count() > 0)
                                    <li class="nav-item"><a class="nav-link" href="#requiriments"
                                            data-toggle="tab">Necessidades Especiais</a></li>
                                @endif
                            </ul>
                        </div>
                        <div class="card-body">
                            <div class="tab-content">
                                <div class="tab-pane active" id="courses">
                                    @foreach ($user->academics as $academic)
                                        <div class="post">
                                            <div class="user-block ml-n5 mr-5">
                                                <span class="username">
                                                    <a href="#">{{ $academic->name }}</a>
                                                </span>
                                                <span class="description">Previsão de Formatura:
                                                    {{ $academic->graduation }}</span>
                                            </div>

                                            <div>
                                                <ul>
                                                    <li>Área: {{ $academic->course['name'] }}</li>
                                                    <li>Nível: {{ $academic->scholarity['name'] }}</li>
                                                    <li>Período/Ano: {{ $academic->year }}</li>
                                                    <li>Instituição: {{ $academic->institution }}</li>
                                                    <li>Turno: {{ $academic->time }}</li>
                                                    <li>Disponibilidade: {{ $academic->availability }}</li>
                                                </ul>
                                            </div>
                                        </div>
                                    @endforeach
                                </div>

                                <div class="tab-pane" id="extracourses">
                                    @foreach ($user->extra as $extra)
                                        <div class="post">
                                            <div class="user-block ml-n5 mr-5">
                                                <span class="username">
                                                    <a href="#">{{ $extra->name }}</a>
                                                </span>
                                            </div>

                                            <div>
                                                <ul>
                                                    <li>Área: {{ $extra->course['name'] }}</li>
                                                    <li>Nível: {{ $extra->level }}</li>
                                                    <li>Instituição: {{ $extra->institution }}</li>
                                                </ul>
                                            </div>
                                        </div>
                                    @endforeach
                                </div>

                                <div class="tab-pane" id="experience">
                                    <div class="post">
                                        @foreach ($user->professional as $experience)
                                            <div class="post border-0">
                                                <div class="user-block ml-n5 mr-5">
                                                    <span class="username pb-2">Empresa:
                                                        <a href="#">{{ $experience->company }}</a>
                                                    </span>
                                                    <p class="description">Cargo: {{ $experience->role }}</p>
                                                    <p class="description">Início: {{ $experience->start }}</p>
                                                    <p class="description">Término:
                                                        {{ $experience->end ?? 'Não informado' }}</p>
                                                    <p class="description">Tipo de Contrato:
                                                        {{ $experience->contract }}</p>
                                                    <p class="description">Atividades Desempenhadas:
                                                        {{ $experience->activities }}</p>
                                                </div>
                                            </div>
                                        @endforeach
                                    </div>
                                </div>

                                <div class="tab-pane" id="composing">
                                    <div class="post">
                                        @isset($user->composing)
                                            <div class="user-block ml-n5 mr-5 text-center">
                                                <span class="username">
                                                    <a href="#">{{ $user->composing['title'] }}</a>
                                                </span>
                                            </div>
                                            <div>
                                                {!! $user->composing['content'] !!}
                                            </div>
                                        @endisset
                                    </div>
                                </div>

                                @if ($user->requiriment->count() > 0)
                                    <div class="tab-pane" id="requiriments">
                                        <div class="post">
                                            @foreach ($user->requiriment as $req)
                                                <div class="post">
                                                    <div class="user-block ml-n5 mr-5">
                                                        <span class="username">Tipo:
                                                            <a href="#">{{ $req->type }}</a>
                                                        </span>
                                                        <p class="description">Observações: {{ $req->details }}
                                                        </p>
                                                    </div>
                                                </div>
                                            @endforeach
                                        </div>
                                    </div>
                                @endif

                            </div>
                        </div>
                    </div>

                    <div class="invoice p-3 mb-3">

                        <div class="row">
                            <div class="col-12">
                                <h4>
                                    <i class="fa fa-file-archive"></i> Dados Pessoais
                                    <small class="float-right">Data de Nascimento:
                                        {{ $user->birth ?? 'Não Informada' }}</small>
                                </h4>
                            </div>
                        </div>

                        <div class="row invoice-info mt-2">
                            <div class="col-sm-4 invoice-col">
                                <p class="lead mb-n1">Filiação</p>
                                @if ($user->first_parent || $user->second_parent)
                                    <div>
                                        {{ $user->first_parent }}<br>
                                        {{ $user->second_parent }}<br>
                                    </div>
                                @else
                                    <div>
                                        Não Informada
                                    </div>
                                @endif
                            </div>
                            <div class="col-sm-4 invoice-col">
                                <p class="lead mb-n1">Estado Civil</p>
                                {{ $user->civil_status ?? 'Não Informado' }}
                            </div>
                            <div class="col-sm-4 invoice-col">
                                <p class="lead mb-n1">Filhos</p>
                                {{ $user->children ?? '0' }}
                            </div>
                        </div>

                        <div class="row mt-2">
                            <div class="col-6">
                                <p class="lead mb-n1">Nacionalidade</p>
                                <p class="text-dark well well-sm shadow-none">
                                    {{ ucfirst($user->nationality ?? 'Não informada') }}
                                </p>
                                <p class="lead mb-n1">Redes Sociais</p>
                                <p class="text-dark well well-sm shadow-none d-flex flex-wrap">
                                    @if (!empty($user->facebook))
                                        <a href="{{ $user->facebook }}" target="_blank" class="mr-2"
                                            title="{{ $user->name }} no Facebook"><i class="fab fa-facebook"></i></a>
                                    @endif
                                    @if (!empty($user->instagram))
                                        <a href="{{ $user->instagram }}" target="_blank" class="mr-2"
                                            title="{{ $user->name }} no Instagram"><i class="fab fa-instagram"></i></a>
                                    @endif
                                    @if (!empty($user->twitter))
                                        <a href="{{ $user->twitter }}" target="_blank" class="mr-2"
                                            title="{{ $user->name }} no Twitter"><i class="fab fa-twitter"></i></a>
                                    @endif
                                    @if (!empty($user->linkedin))
                                        <a href="{{ $user->linkedin }}" target="_blank" class="mr-2"
                                            title="{{ $user->name }} no Linkedin"><i class="fab fa-linkedin"></i></a>
                                    @endif
                                    @if (!empty($user->youtube))
                                        <a href="{{ $user->youtube }}" target="_blank" class="mr-2"
                                            title="{{ $user->name }} no Youtube"><i class="fab fa-youtube"></i></a>
                                    @endif
                                    @if (!empty($user->whatsapp))
                                        <a href="{{ $user->whatsapp }}" target="_blank" class="mr-2"
                                            title="{{ $user->name }} no WhatsApp"><i class="fab fa-whatsapp"></i></a>
                                    @endif
                                    @if (!empty($user->telegram))
                                        <a href="{{ $user->telegram }}" target="_blank" class="mr-2"
                                            title="{{ $user->name }} no Telegram"><i class="fab fa-telegram"></i></a>
                                    @endif
                                    @if (!empty($user->discord))
                                        <a href="{{ $user->discord }}" target="_blank" class="mr-2"
                                            title="{{ $user->name }} no Discord"><i class="fab fa-discord"></i></a>
                                    @endif
                                </p>
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

                            <div class="col-6">
                                <div class="table-responsive">
                                    <table class="table">
                                        <tbody>
                                            <tr>
                                                <th style="width:50%">CPF:</th>
                                                <td>{{ $user->document_person ?? 'Não informado' }}</td>
                                            </tr>
                                            <tr>
                                                <th>RG</th>
                                                <td>{{ $user->document_registry ?? 'Não informado' }}</td>
                                            </tr>
                                            <tr>
                                                <th>Orgão Emissor</th>
                                                <td>{{ $user->issuer ?? 'Não informado' }}</td>
                                            </tr>
                                            <tr>
                                                <th>Data de Emissão</th>
                                                <td>{{ $user->date_issue ?? 'Não informado' }}</td>
                                            </tr>
                                            <tr>
                                                <th>Carteira de Trabalho</th>
                                                <td>{{ $user->work_card ?? 'Não informado' }}</td>
                                            </tr>
                                            <tr>
                                                <th>Série</th>
                                                <td>{{ $user->serie ?? 'Não informado' }}</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <p class="lead">Usuário criado desde
                                    {{ date_format($user->created_at, 'd/m/Y H:i') }}</p>
                            </div>
                        </div>

                    </div>

                </div>

            </div>
        </div>
    </section>
@endsection
