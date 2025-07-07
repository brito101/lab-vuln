@extends('adminlte::page')
@section('title', '- Gráfico de Compatibilidade')

@section('content')
    <section class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1><i class="fa fa-fw fa-chart-bar"></i> Gráfico de Compatibilidade</h1>
                </div>
                <div class="col-sm-6">
                    <ol class="breadcrumb float-sm-right">
                        <li class="breadcrumb-item"><a href="{{ route('admin.home') }}">Home</a></li>
                        <li class="breadcrumb-item active">Gráfico de Compatibilidade</li>
                    </ol>
                </div>
            </div>
        </div>
    </section>

    <section class="content">
        <div class="container-fluid">
            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header border-0">
                            <div class="d-flex justify-content-between">
                                <h3 class="card-title">Vagas X Estagiários</h3>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="position-relative mb-4">
                                <div class="chartjs-size-monitor" z>
                                    <div class="chartjs-size-monitor-expand">
                                        <div class=""></div>
                                    </div>
                                    <div class="chartjs-size-monitor-shrink">
                                        <div class=""></div>
                                    </div>
                                </div>
                                <canvas id="vacancy-chart" style="display: block; width: 489px; height: 200px;"
                                    class="chartjs-render-monitor" width="489" height="200"></canvas>
                            </div>
                        </div>
                        <div class="justify-content-center d-flex">
                            {{ $trainees->links() }}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
@endsection


@section('custom_js')
    <script src="{{ asset('vendor/chart.js/Chart.bundle.min.js') }}"></script>
    <script>
        const vacancyChart = document.getElementById('vacancy-chart');

        function generateRandomColor() {
            var letters = '0123456789ABCDEF';
            var color = '#';
            for (var i = 0; i < 6; i++) {
                color += letters[Math.floor(Math.random() * 16)];
            }
            return color;
        }

        if (vacancyChart) {
            const myChart = new Chart(vacancyChart, {
                type: 'bar',
                data: {
                    labels: {!! json_encode($chart->trainee) !!},
                    datasets: [
                        @foreach ($finalList as $list)
                            {
                                label: "Vaga" + {!! json_encode($list['vacancy']) !!},
                                backgroundColor: generateRandomColor(),
                                data: {!! json_encode($list['values']) !!},
                            },
                        @endforeach
                    ]
                },
                options: {
                    responsive: true,
                    scales: {
                        yAxes: [{
                            ticks: {
                                beginAtZero: true
                            }
                        }],
                        xAxes: [{
                            barThickness: 20,
                            maxBarThickness: 20
                        }]
                    }
                },
            });
        }
    </script>
@endsection
