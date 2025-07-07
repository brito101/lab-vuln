@extends('adminlte::page')
@section('plugins.select2', true)
@section('plugins.select3', true)

@section('title', '- Produtos')

@section('content')
    <section class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1><i class="fa fa-fw fa-box"></i> Produtos {{ env('APP_NAME') }}</h1>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <li class="breadcrumb-item"><a href="{{ route('admin.home') }}">Home</a></li>
                        <li class="breadcrumb-item active">Produtos</li>
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
                            <div class="d-flex flex-wrap justify-content-between col-12 align-content-center">
                                <h3 class="card-title align-self-center">Produtos</h3>
                            </div>
                        </div>
                        <div class="col-12 px-4 pt-4">
                            <x-adminlte-select2 name="trainee" id="trainee">
                                <option value="" disabled selected>
                                    Selecione um Estagiário
                                </option>
                                @foreach ($trainees as $trainee)
                                    <option value="{{ $trainee->id }}">
                                        {{ $trainee->name }} ({{ $trainee->email }})
                                    </option>
                                @endforeach
                            </x-adminlte-select2>
                        </div>
                        <div class="card-body d-flex justify-content-center">

                            @forelse ($products as $product)
                                <div class="col-12 col-sm-6 col-md-4 d-flex align-items-stretch flex-column">
                                    <div class="card bg-light d-flex flex-fill">
                                        <div class="card-header text-muted border-bottom-0">
                                            Produto #{{ $product->id }}
                                        </div>
                                        <div class="card-body pt-0">
                                            <div class="row">
                                                <div class="col-7">
                                                    <h2 class="lead"><b>{{ $product->name }}</b></h2>
                                                    <p class="text-muted text-sm mb-n1">Valor: {{ $product->price }}
                                                    </p>
                                                    <p class="text-muted text-sm my-2"> {{ $product->description }}
                                                    </p>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="card-footer">
                                            <div class="text-center d-flex flex-wrap justify-content-center">
                                                <form method="POST" action="{{ route('admin.productCheckout') }}">
                                                    @csrf
                                                    <input type="hidden" value="{{ $product->id }}" name="product">
                                                    <input type="hidden" value="" name="trainne"
                                                        class="trainee_input">
                                                    <button type="submit" disabled class="btn btn-success btn-stop"><i
                                                            class="fas fa-check mr-2"></i>Comprar</button>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            @empty
                                <p>Não há produtos cadastrados</p>
                            @endforelse
                        </div>


                        <div class="card-footer">
                            <nav aria-label="Products Page Navigation">
                                <ul class="pagination justify-content-center m-0">
                                    {{ $products->links() }}
                                </ul>
                            </nav>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
@endsection

@section('custom_js')
    <script>
        $(document).ready(function() {
            $('.trainee_input').val('');
            $('.btn-stop').attr('disabled', true);
            $('#trainee').on('change', function() {
                $('.trainee_input').val($(this).val());
                $('.btn-stop').attr('disabled', false);
            });
        });
    </script>
@endsection
