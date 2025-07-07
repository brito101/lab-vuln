@extends('site.master.master')

@section('content')
    <div class="banner-area">
        <div class="container-fluid">
            <div class="container">
                <div class="banner-item-content banner-item-ptb">
                    <h1>Seja um Franqueado</h1>
                    <p>Proporcionamos a milhares de jovens oportunidades de iniciar a carreira profissional.</p>
                    <div class="banner-btn">
                        <a href="#about" class="default-btn btn-bg-two border-radius-5">Saiba Mais <i
                                class="bx bx-chevron-right"></i></a>
                        <a href="#contact" class="default-btn btn-bg-one border-radius-5 ml-20">Contate-nos<i
                                class="bx bx-chevron-right"></i></a>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <div class="about-area ptb-100" id="about">
        <div class="container">
            <div class="row justify-content-center align-items-center">
                <div class="col-lg-6">
                    <div class="about-play">
                        <img src="{{ asset('img/franchise-video.jpg') }}" alt="About Images">
                        <div class="about-play-content">
                            <span>Assista nosso vídeo de introdução</span>
                            <h2>Solução para a sua franquia!</h2>
                            <div class="play-on-area">
                                <a href="https://www.youtube.com/watch?v=A6knS6gFwzA" class="play-on popup-btn"><i
                                        class="bx bx-play"></i></a>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="about-content ml-25">
                        <div class="section-title">
                            <span class="sp-color2">Nosso modelo empresarial é INOVADOR,</span>
                            <h2>ALTAMENTE RENTÁVEL E COM BAIXA CONCORRÊNCIA</h2>
                            <p>Invista em uma franquia Home Office</p>
                        </div>
                        <div class="row">
                            <div class="col-12">
                                <ul class="about-list text-start">
                                    <li><i class="bx bxs-check-circle"></i>Investimento total R$ 21.000,00 (Inclusa taxa de
                                        franquia, capital de giro e implantação)</li>
                                    <li><i class="bx bxs-check-circle"></i>Retorno do Investimento no 6° mês</li>
                                    <li><i class="bx bxs-check-circle"></i>Lucratividade média mensal de R$ 15.000,00</li>
                                    <li><i class="bx bxs-check-circle"></i>Rentabilidade de 70%</li>
                                </ul>
                            </div>
                        </div>
                        <div class="banner-btn pt-4">
                            <a href="#contact" class="default-btn btn-bg-two border-radius-5">Fale com um de nossos
                                Especialistas<i class="bx bx-chevron-right"></i></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <section class="services-area-two pt-100 pb-70">
        <div class="container">
            <div class="section-title text-center">
                <span class="sp-color1">Nós garantimos</span>
                <h2>Suporte total ao franqueado!</h2>
            </div>
            <div class="row pt-45 d-flex justify-content-center">
                <div class="col-lg-4 col-md-6">
                    <div class="services-item">
                        <img src="{{ asset('img/services-img4.jpg') }}" alt="Images">
                        <div class="content">
                            <i class="bx bxs-business"></i>
                            <h3>Comercial</h3>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6">
                    <div class="services-item">
                        <img src="{{ asset('img/services-img2.jpg') }}" alt="Images">
                        <div class="content">
                            <i class="bx bx-search"></i>
                            <h3>Recrutamento e Seleção</h3>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6">
                    <div class="services-item">
                        <img src="{{ asset('img/services-img6.jpg') }}" alt="Images">
                        <div class="content">
                            <i class="bx bx-comment"></i>
                            <h3>Marketing</h3>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6">
                    <div class="services-item">
                        <img src="{{ asset('img/build-img1.jpg') }}" alt="Images">
                        <div class="content">
                            <i class="bx bx-code-curly"></i>
                            <h3>Software</h3>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6">
                    <div class="services-item">
                        <img src="{{ asset('img/services-img1.jpg') }}" alt="Images">
                        <div class="content">
                            <i class="bx bx-book"></i>
                            <h3>Jurídico</h3>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <div class="contact-form-area pt-100 pb-70" id="contact">
        <div class="container">
            <div class="section-title text-center">
                <h2>Entre em contato conosco!</h2>
            </div>
            <div class="row pt-45">
                <div class="col-12 col-lg-5">
                    <div class="contact-info mr-20">
                        <span>Informações de Contato</span>
                        <h2>{{ env('APP_NAME') }}</h2>
                        <ul>
                            <li>
                                <div class="content">
                                    <i class="bx bx-phone-call"></i>
                                    <h3>Telefone</h3>
                                    <a href="tel:0800 915 7000">
                                        0800 915 7000
                                    </a>
                                </div>
                            </li>
                            <li>
                                <div class="content">
                                    <i class="bx bx bxl-whatsapp"></i>
                                    <h3>WhatsApp</h3>
                                    <a href="tel:+55 (47) 98884-7801">(47) 98884-7801</a>
                                </div>
                            </li>
                            <li>
                                <div class="content">
                                    <i class="bx bxs-map"></i>
                                    <h3>Endereço</h3>
                                    <span>Rua Coronel Almeida, 132, Sala 01, Centro Araquari-SC</span>
                                </div>
                            </li>
                            <li>
                                <div class="content">
                                    <i class="bx bx-message"></i>
                                    <h3>E-mail</h3>
                                    <a href="mailto:contato@alfaestagios.com.br">contato@alfaestagios.com.br </a>
                                </div>
                            </li>
                        </ul>
                    </div>
                </div>
                <div class="col-12 col-lg-7">
                    <div class="contact-form">
                        <form id="contactForm" action="{{ route('sendEmail') }}" method="POST" novalidate="true">
                            <div class="row">
                                <div class="col-lg-6">
                                    <div class="form-group">
                                        <label>Seu nome <span>*</span></label>
                                        <input type="text" name="name" id="name" class="form-control"
                                            required="" data-error="Por favor, informe seu nome" placeholder="Nome">
                                        <div class="help-block with-errors"></div>
                                    </div>
                                </div>
                                <div class="col-lg-6">
                                    <div class="form-group">
                                        <label>E-mail <span>*</span></label>
                                        <input type="email" name="email" id="email" class="form-control"
                                            required="" data-error="Por favor, informe seu e-mail"
                                            placeholder="E-mail">
                                        <div class="help-block with-errors"></div>
                                    </div>
                                </div>
                                <div class="col-lg-6">
                                    <div class="form-group">
                                        <label>Telefone <span>*</span></label>
                                        <input type="text" name="phone_number" id="phone_number" required=""
                                            data-error="Por favor, informe seu telefone" class="form-control"
                                            placeholder="Telefone">
                                        <div class="help-block with-errors"></div>
                                    </div>
                                </div>
                                <div class="col-lg-6">
                                    <div class="form-group">
                                        <label>Assunto <span>*</span></label>
                                        <input type="text" name="msg_subject" id="msg_subject" class="form-control"
                                            required="" data-error="Por favor, informe um assunto"
                                            placeholder="Assunto">
                                        <div class="help-block with-errors"></div>
                                    </div>
                                </div>
                                <div class="col-lg-12 col-md-12">
                                    <div class="form-group">
                                        <label>Mensagem <span>*</span></label>
                                        <textarea name="message" class="form-control" id="message" cols="30" rows="8" required=""
                                            data-error="Escreva sua mensagem" placeholder="Sua mensagem"></textarea>
                                        <div class="help-block with-errors"></div>
                                    </div>
                                </div>

                                <div class="col-lg-12 col-md-12 text-center">
                                    <button type="submit" class="default-btn btn-bg-two border-radius-5 disabled"
                                        style="pointer-events: all; cursor: pointer;">Enviar <i
                                            class="bx bx-chevron-right"></i>
                                    </button>
                                    <div id="msgSubmit" class="h3 text-center hidden"></div>
                                    <div class="clearfix"></div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection
