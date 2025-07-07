@extends('adminlte::page')
@section('plugins.select2', true)

@section('title', '- Cadastro de Necessidades Especiais')

@section('content')

    <section class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1><i class="fa fa-fw fa-wheelchair"></i> Nova Necessidade Especial</h1>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <li class="breadcrumb-item"><a href="{{ route('admin.home') }}">Home</a></li>
                        <li class="breadcrumb-item"><a href="{{ route('admin.requiriments.index') }}">Necessidades
                                Especiais</a></li>
                        <li class="breadcrumb-item active">Nova Necessidade Especial</li>
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
                            <h3 class="card-title">Dados Cadastrais da Necessidade Especial</h3>
                        </div>

                        <form method="POST" action="{{ route('admin.requiriments.store') }}">
                            @csrf
                            <div class="card-body">

                                <div class="d-flex flex-wrap justify-content-between">
                                    <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                        <label for="type">Tipo</label>
                                        <x-adminlte-select2 name="type">
                                            <option value="Visual" {{ old('type') == 'Visual' ? 'selected' : '' }}>Visual
                                            </option>
                                            <option value="Motora" {{ old('type') == 'Motora' ? 'selected' : '' }}>Motora
                                            </option>
                                            <option value="Mental" {{ old('type') == 'Mental' ? 'selected' : '' }}>Mental
                                            </option>
                                            <option value="Auditiva" {{ old('type') == 'Auditiva' ? 'selected' : '' }}>
                                                Auditiva</option>
                                            <option value="Paralisia Cerebral"
                                                {{ old('type') == 'Paralisia Cerebral' ? 'selected' : '' }}>Paralisia
                                                Cerebral</option>
                                        </x-adminlte-select2>
                                    </div>
                                </div>

                                <div class="col-12 px-0">
                                    <label for="details">Observações</label>
                                    <x-adminlte-textarea name="details"
                                        placeholder="Observações sobre a necessidade especial: grau, área etc...">
                                        {{ old('details') }}</x-adminlte-textarea>
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
