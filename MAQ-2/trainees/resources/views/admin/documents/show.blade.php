 @extends('adminlte::page')
 @section('plugins.BsCustomFileInput', true)

 @section('title', '- Documentos Comprobatórios')

 @section('content')

     <section class="content-header">
         <div class="container-fluid">
             <div class="row mb-2">
                 <div class="col-sm-6">
                     <h1><i class="fas fa-fw fa-file-upload"></i>Documentos Comprobatórios</h1>
                 </div>
                 <div class="col-sm-6">
                     <ol class="breadcrumb float-sm-right">
                         <li class="breadcrumb-item"><a href="{{ route('admin.home') }}">Home</a></li>
                         <li class="breadcrumb-item active">Documentos Comprobatórios</li>
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
                         <div class="card-header d-flex justify-content-between">
                             <h3 class="card-title">Documentos Comprobatórios do estagiário
                                 <span class="text-primary">{{ $document->user->name ?? '' }}</span>
                             </h3>
                         </div>

                         <div class="card-body">

                             <div class="col-12 form-group px-0 pr-md-2 d-flex flex-wrap">
                                 <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                     <label for="document_person">CPF</label>
                                     @if (isset($document->document_person))
                                         @if ($document->document_person)
                                             @if (substr($document->document_person, -3) == 'pdf')
                                                 <embed src="{{ url('storage/documents/' . $document->document_person) }}"
                                                     type="application/pdf" width="100%" height="200px">
                                             @else
                                                 <img src="{{ url('storage/documents/' . $document->document_person) }}"
                                                     alt="{{ $document->document_person }}"
                                                     style="margin: auto; height: 200px; max-width: 50%;"
                                                     class="img-thumbnail d-block">
                                             @endif
                                         @endif
                                     @else
                                         <p>Documento inexistente</p>
                                     @endif
                                 </div>
                                 <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                     <label for="document_registry">RG</label>
                                     @if (isset($document->document_registry))
                                         @if ($document->document_registry)
                                             @if (substr($document->document_registry, -3) == 'pdf')
                                                 <embed
                                                     src="{{ url('storage/documents/' . $document->document_registry) }}"
                                                     type="application/pdf" width="100%" height="200px">
                                             @else
                                                 <img src="{{ url('storage/documents/' . $document->document_registry) }}"
                                                     alt="{{ $document->document_registry }}"
                                                     style="margin: auto; height: 200px; max-width: 50%;"
                                                     class="img-thumbnail d-block">
                                             @endif
                                         @endif
                                     @else
                                         <p>Documento inexistente</p>
                                     @endif
                                 </div>
                             </div>

                             <div class="col-12 form-group px-0 pr-md-2 d-flex flex-wrap">
                                 <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                     <label for="registration">Atestado de Matrícula</label>
                                     @if (isset($document->registration))
                                         @if ($document->registration)
                                             @if (substr($document->registration, -3) == 'pdf')
                                                 <embed src="{{ url('storage/documents/' . $document->registration) }}"
                                                     type="application/pdf" width="100%" height="200px">
                                             @else
                                                 <img src="{{ url('storage/documents/' . $document->registration) }}"
                                                     alt="{{ $document->registration }}"
                                                     style="margin: auto; height: 200px; max-width: 50%;"
                                                     class="img-thumbnail d-block">
                                             @endif
                                         @endif
                                     @else
                                         <p>Documento inexistente</p>
                                     @endif
                                 </div>
                                 <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                     <label for="historic">Histórico Escolar</label>
                                     @if (isset($document->historic))
                                         @if ($document->historic)
                                             @if (substr($document->historic, -3) == 'pdf')
                                                 <embed src="{{ url('storage/documents/' . $document->historic) }}"
                                                     type="application/pdf" width="100%" height="200px">
                                             @else
                                                 <img src="{{ url('storage/documents/' . $document->historic) }}"
                                                     alt="{{ $document->historic }}"
                                                     style="margin: auto; height: 200px; max-width: 50%;"
                                                     class="img-thumbnail d-block">
                                             @endif
                                         @endif
                                     @else
                                         <p>Documento inexistente</p>
                                     @endif
                                 </div>
                             </div>

                             <div class="col-12 form-group px-0 pr-md-2 d-flex flex-wrap">
                                 <div class="col-12 col-md-6 form-group px-0 pr-md-2">
                                     <label for="declaration">Declaração da Instituição de Ensino</label>
                                     @if (isset($document->declaration))
                                         @if ($document->declaration)
                                             @if (substr($document->declaration, -3) == 'pdf')
                                                 <embed src="{{ url('storage/documents/' . $document->declaration) }}"
                                                     type="application/pdf" width="100%" height="200px">
                                             @else
                                                 <img src="{{ url('storage/documents/' . $document->declaration) }}"
                                                     alt="{{ $document->declaration }}"
                                                     style="margin: auto; height: 200px; max-width: 50%;"
                                                     class="img-thumbnail d-block">
                                             @endif
                                         @endif
                                     @else
                                         <p>Documento inexistente</p>
                                     @endif
                                 </div>
                                 <div class="col-12 col-md-6 form-group px-0 pl-md-2">
                                     <label for="residence">Comprovante de Residência</label>
                                     @if (isset($document->residence))
                                         @if ($document->residence)
                                             @if (substr($document->residence, -3) == 'pdf')
                                                 <embed src="{{ url('storage/documents/' . $document->residence) }}"
                                                     type="application/pdf" width="100%" height="200px">
                                             @else
                                                 <img src="{{ url('storage/documents/' . $document->residence) }}"
                                                     alt="{{ $document->residence }}"
                                                     style="margin: auto; height: 200px; max-width: 50%;"
                                                     class="img-thumbnail d-block">
                                             @endif
                                         @endif
                                     @else
                                         <p>Documento inexistente</p>
                                     @endif
                                 </div>
                             </div>

                         </div>

                     </div>
                 </div>
             </div>
         </div>
     </section>
 @endsection
