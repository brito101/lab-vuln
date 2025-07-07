@extends('adminlte::page')

@section('title', '- Termo')

@section('content')

    <section class="content bg-white p-0 m-0" style="height: 100vh">
        <div class="container-fluid bg-white">
            <div class="row d-flex justify-content-center align-content-center">
                <h1 class="font-weight-bold">
                    {{ env('APP_NAME') . ' - ' . $data['title'] }}
                </h1>
            </div>
            <div class="row pt-5">
                <div class="w-100">
                    <h2 class="text-center">Termo de {{ $term->type }}</h2>
                </div>
            </div>
            <div class="row pt-5">
                <div class="w-100">
                    <h3><u>Participantes</u></h3>
                </div>
                <p class="w-100">{{ $data['primary_name'] }}, documento {{ $data['primary_document'] }}</p>
                <p class="w-100">{{ $data['secondary_name'] }}, documento {{ $data['secondary_document'] }}</p>
            </div>
            <div class="row pt-5">
                <div class="w-100">
                    <h3><u>Diretrizes do Termo</u></h3>
                </div>
                <div class="w-100">
                    {!! $term->content !!}
                </div>
            </div>

            <div class="row pt-5 fixed-bottom">
                <div class="w-100">
                    <h3 class="text-center"><u>Assinaturas</u></h3>
                </div>
                <div class="w-100 d-flex flex-wrap justify-content-between">
                    <div class="pt-5 px-5 col-6 text-center">____________________________________________</div>
                    <div class="pt-5 px-5 col-6 text-center">____________________________________________</div>
                    <div class="col-6 text-left">Nome:</div>
                    <div class="col-6 text-left">Nome:</div>
                    <div class="col-6 text-left">Documento:</div>
                    <div class="col-6 text-left">Documento:</div>
                </div>
            </div>

        </div>
    </section>
@endsection

@section('custom_js')
    <script>
        window.onload = function() {
            $(".content-wrapper").css("background-color", "#fff");
            $(".main-footer").remove();
            window.print();
            setTimeout(function() {
                window.close();
            }, 1000);
        }
    </script>
@endsection
