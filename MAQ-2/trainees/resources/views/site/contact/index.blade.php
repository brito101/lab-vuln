@extends('site.master.master')

@section('content')
    <div class="inner-banner">
        <div class="container">
            <div class="inner-title text-center">
                <h3>Contato</h3>
            </div>
        </div>
    </div>

    <div class="contact-form-area pt-100 pb-70">
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
                                            required="" data-error="Por favor, informe seu e-mail" placeholder="E-mail">
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
                                            required="" data-error="Por favor, informe um assunto" placeholder="Assunto">
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

    <div class="map-area">
        <div class="container-fluid m-0 p-0">
            <iframe
                src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3574.567879661102!2d-48.72499768573254!3d-26.37283507725342!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x94deb535bfd9359f%3A0x4f34a41abf1ed178!2sR.%20Cel.%20Almeida%2C%20132%20-%20Centro%2C%20Araquari%20-%20SC%2C%2089245-000!5e0!3m2!1spt-BR!2sbr!4v1665796575812!5m2!1spt-BR!2sbr"
                width="600" height="450" style="border:0;" allowfullscreen="" loading="lazy"
                referrerpolicy="no-referrer-when-downgrade"></iframe>
        </div>
    </div>
@endsection
