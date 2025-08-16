<?php

use Illuminate\Support\Facades\Auth;

return [

    /*
    |--------------------------------------------------------------------------
    | Title
    |--------------------------------------------------------------------------
    |
    | Here you can change the default title of your admin panel.
    |
    | For detailed instructions you can look the title section here:
    | https://github.com/jeroennoten/Laravel-AdminLTE/wiki/Basic-Configuration
    |
    */

    'title' => env('APP_NAME'),
    'title_prefix' => env('APP_NAME'),
    'title_postfix' => '',

    /*
    |--------------------------------------------------------------------------
    | Favicon
    |--------------------------------------------------------------------------
    |
    | Here you can activate the favicon.
    |
    | For detailed instructions you can look the favicon section here:
    | https://github.com/jeroennoten/Laravel-AdminLTE/wiki/Basic-Configuration
    |
    */

    'use_ico_only' => true,
    'use_full_favicon' => false,

    /*
    |--------------------------------------------------------------------------
    | Logo
    |--------------------------------------------------------------------------
    |
    | Here you can change the logo of your admin panel.
    |
    | For detailed instructions you can look the logo section here:
    | https://github.com/jeroennoten/Laravel-AdminLTE/wiki/Basic-Configuration
    |
    */

    'logo' => env('APP_NAME'),
    'logo_img' => 'img/logo.png',
    'logo_img_class' => 'brand-image img-circle elevation-3',
    'logo_img_xl' => null,
    'logo_img_xl_class' => 'brand-image-xs',
    'logo_img_alt' => env('APP_NAME'),

    /*
    |--------------------------------------------------------------------------
    | User Menu
    |--------------------------------------------------------------------------
    |
    | Here you can activate and change the user menu.
    |
    | For detailed instructions you can look the user menu section here:
    | https://github.com/jeroennoten/Laravel-AdminLTE/wiki/Basic-Configuration
    |
    */

    'usermenu_enabled' => false,
    'usermenu_header' => false,
    'usermenu_header_class' => 'bg-primary',
    'usermenu_image' => false,
    'usermenu_desc' => false,
    'usermenu_profile_url' => false,

    /*
    |--------------------------------------------------------------------------
    | Layout
    |--------------------------------------------------------------------------
    |
    | Here we change the layout of your admin panel.
    |
    | For detailed instructions you can look the layout section here:
    | https://github.com/jeroennoten/Laravel-AdminLTE/wiki/Layout-and-Styling-Configuration
    |
    */

    'layout_topnav' => null,
    'layout_boxed' => null,
    'layout_fixed_sidebar' => true,
    'layout_fixed_navbar' => null,
    'layout_fixed_footer' => true,
    'layout_dark_mode' => null,

    /*
    |--------------------------------------------------------------------------
    | Authentication Views Classes
    |--------------------------------------------------------------------------
    |
    | Here you can change the look and behavior of the authentication views.
    |
    | For detailed instructions you can look the auth classes section here:
    | https://github.com/jeroennoten/Laravel-AdminLTE/wiki/Layout-and-Styling-Configuration
    |
    */

    'classes_auth_card' => 'card-outline card-primary',
    'classes_auth_header' => '',
    'classes_auth_body' => '',
    'classes_auth_footer' => '',
    'classes_auth_icon' => '',
    'classes_auth_btn' => 'btn-flat btn-primary',

    /*
    |--------------------------------------------------------------------------
    | Admin Panel Classes
    |--------------------------------------------------------------------------
    |
    | Here you can change the look and behavior of the admin panel.
    |
    | For detailed instructions you can look the admin panel classes here:
    | https://github.com/jeroennoten/Laravel-AdminLTE/wiki/Layout-and-Styling-Configuration
    |
    */

    'classes_body' => '',
    'classes_brand' => '',
    'classes_brand_text' => '',
    'classes_content_wrapper' => '',
    'classes_content_header' => '',
    'classes_content' => '',
    'classes_sidebar' => 'sidebar-dark-primary elevation-4',
    'classes_sidebar_nav' => '',
    'classes_topnav' => 'navbar-white navbar-light',
    'classes_topnav_nav' => 'navbar-expand',
    'classes_topnav_container' => 'container',

    /*
    |--------------------------------------------------------------------------
    | Sidebar
    |--------------------------------------------------------------------------
    |
    | Here we can modify the sidebar of the admin panel.
    |
    | For detailed instructions you can look the sidebar section here:
    | https://github.com/jeroennoten/Laravel-AdminLTE/wiki/Layout-and-Styling-Configuration
    |
    */

    'sidebar_mini' => 'lg',
    'sidebar_collapse' => false,
    'sidebar_collapse_auto_size' => false,
    'sidebar_collapse_remember' => true,
    'sidebar_collapse_remember_no_transition' => true,
    'sidebar_scrollbar_theme' => 'os-theme-light',
    'sidebar_scrollbar_auto_hide' => 'l',
    'sidebar_nav_accordion' => true,
    'sidebar_nav_animation_speed' => 300,

    /*
    |--------------------------------------------------------------------------
    | Control Sidebar (Right Sidebar)
    |--------------------------------------------------------------------------
    |
    | Here we can modify the right sidebar aka control sidebar of the admin panel.
    |
    | For detailed instructions you can look the right sidebar section here:
    | https://github.com/jeroennoten/Laravel-AdminLTE/wiki/Layout-and-Styling-Configuration
    |
    */

    'right_sidebar' => false,
    'right_sidebar_icon' => 'fas fa-cogs',
    'right_sidebar_theme' => 'dark',
    'right_sidebar_slide' => true,
    'right_sidebar_push' => true,
    'right_sidebar_scrollbar_theme' => 'os-theme-light',
    'right_sidebar_scrollbar_auto_hide' => 'l',

    /*
    |--------------------------------------------------------------------------
    | URLs
    |--------------------------------------------------------------------------
    |
    | Here we can modify the url settings of the admin panel.
    |
    | For detailed instructions you can look the urls section here:
    | https://github.com/jeroennoten/Laravel-AdminLTE/wiki/Basic-Configuration
    |
    */

    'use_route_url' => false,
    'dashboard_url' => 'admin',
    'logout_url' => 'logout',
    'login_url' => 'login',
    'register_url' => 'register',
    'password_reset_url' => 'password/reset',
    'password_email_url' => 'password/email',
    'profile_url' => false,

    /*
    |--------------------------------------------------------------------------
    | Laravel Mix
    |--------------------------------------------------------------------------
    |
    | Here we can enable the Laravel Mix option for the admin panel.
    |
    | For detailed instructions you can look the laravel mix section here:
    | https://github.com/jeroennoten/Laravel-AdminLTE/wiki/Other-Configuration
    |
    */

    'enabled_laravel_mix' => false,
    'laravel_mix_css_path' => 'css/app.css',
    'laravel_mix_js_path' => 'js/app.js',

    /*
    |--------------------------------------------------------------------------
    | Menu Items
    |--------------------------------------------------------------------------
    |
    | Here we can modify the sidebar/top navigation of the admin panel.
    |
    | For detailed instructions you can look here:
    | https://github.com/jeroennoten/Laravel-AdminLTE/wiki/Menu-Configuration
    |
    */

    'menu' => [
        // Navbar items:
        // [
        //     'type'         => 'navbar-search',
        //     'text'         => 'search',
        //     'topnav_right' => true,
        // ],
        [
            'type'         => 'fullscreen-widget',
            'topnav_right' => true,
        ],

        // Sidebar items:
        [
            'type' => 'sidebar-menu-search',
            'text' => 'Pesquisa',
        ],
        //Custom menus
        //Curriculo Trainee
        [
            'text'        => 'Visualizar Currículo',
            'url'         => 'admin/curriculum',
            'icon'        => 'fas fa-fw fa-file-alt',
            'can'         => 'Visualizar Currículo',
        ],
        /** Franchisees / Companies / Trainess */
        [
            'text'        => 'Meu Usuário',
            'url'         => 'admin/user/edit',
            'icon'        => 'fas fa-fw fa-user',
            'can'         => 'Editar Usuário',
        ],
        /** Trainess */
        [
            'text'        => 'Dados Pessoais',
            'url'         => '#',
            'icon'        => 'fas fa-fw fa-file',
            'can'         => 'Editar Dados Pessoais',
            'submenu' => [
                [
                    'text' => 'Documentação',
                    'url'  => 'admin/user/document',
                    'icon' => 'fas fa-fw fa-chevron-right',
                ],
                [
                    'text' => 'Endereço',
                    'url'  => 'admin/user/address',
                    'icon' => 'fas fa-fw fa-chevron-right',
                ],
                [
                    'text' => 'Redes Sociais',
                    'url'  => 'admin/user/social-network',
                    'icon' => 'fas fa-fw fa-chevron-right',
                ],
            ]
        ],
        [
            'text'        => 'Info. Acadêmicas',
            'url'         => '#',
            'icon'        => 'fas fa-fw fa-graduation-cap',
            'can'         => 'Editar Informações Acadêmicas',
            'submenu' => [
                [
                    'text' => 'Cursos',
                    'url'  => 'admin/academics',
                    'icon' => 'fas fa-fw fa-chevron-right',
                ],
                [
                    'text' => 'Extracurricular',
                    'url'  => 'admin/extras',
                    'icon' => 'fas fa-fw fa-chevron-right',
                ]
            ]
        ],
        [
            'text'        => 'Exp. Profissionais',
            'url'         => '#',
            'icon'        => 'fas fa-fw fa-briefcase',
            'can'         => 'Editar Experiências Profissionais',
            'submenu' => [
                [
                    'text' => 'Listagem de Experiências',
                    'url'  => 'admin/professionals',
                    'icon' => 'fas fa-fw fa-chevron-right',
                ],
                [
                    'text' => 'Cadastro de Experiências',
                    'url'  => 'admin/professionals/create',
                    'icon' => 'fas fa-fw fa-chevron-right',
                ],
            ]
        ],
        [
            'text'        => 'Info. Complementares',
            'url'         => '#',
            'icon'        => 'fas fa-fw fa-plus',
            'can'         => 'Editar Necessidades Especiais',
            'submenu' => [
                [
                    'text'        => 'Necessidades Especiais',
                    'url'         => '#',
                    'icon'        => 'fas fa-fw fa-wheelchair',
                    'can'         => 'Editar Necessidades Especiais',
                    'submenu' => [
                        [
                            'text' => 'Listagem de Necessidades',
                            'url'  => 'admin/requiriments',
                            'icon' => 'fas fa-fw fa-chevron-right',
                        ],
                        [
                            'text' => 'Cadastro de Necessidades',
                            'url'  => 'admin/requiriments/create',
                            'icon' => 'fas fa-fw fa-chevron-right',
                        ],
                    ]
                ],
            ]
        ],
        [
            'text'        => 'Redação',
            'url'         => 'admin/composing',
            'icon'        => 'fas fa-fw fa-file-contract',
            'can'         => 'Editar Redação',
        ],
        [
            'text'        => 'Doc. Comprobatórios',
            'url'         => 'admin/documents-upload',
            'icon'        => 'fa fa-fw fa-file-upload',
            'can'         => 'Enviar Documentos Comprobatórios',
        ],
        [
            'text'        => 'Avaliação Documental',
            'url'         => 'admin/documents-status',
            'icon'        => 'fa fa-fw fa-check',
            'can'         => 'Enviar Documentos Comprobatórios',
        ],
        [
            'text'        => 'Usuários',
            'url'         => '#',
            'icon'        => 'fas fa-fw fa-users',
            'can'         => 'Acessar Usuários',
            'submenu' => [
                [
                    'text' => 'Listagem de Usuários',
                    'url'  => 'admin/users',
                    'icon' => 'fas fa-fw fa-chevron-right',
                    'can'  => 'Listar Usuários',
                ],
                [
                    'text' => 'Cadastro de Usuários',
                    'url'  => 'admin/users/create',
                    'icon' => 'fas fa-fw fa-chevron-right',
                    'can'  => 'Criar Usuários',
                ],
            ],
        ],
        [
            'text'        => 'Sistema',
            'url'         => '#',
            'icon'        => 'fas fa-fw fa-cogs',
            'can'         => 'Acessar Usuários',
            'submenu' => [
                [
                    'text' => 'Visualizador de Arquivos',
                    'url'  => 'admin/system/file',
                    'icon' => 'fas fa-fw fa-file-code',
                    'can'  => 'Listar Usuários',
                ],
                [
                    'text' => 'Logs do Sistema',
                    'url'  => 'admin/system/log',
                    'icon' => 'fas fa-fw fa-list-alt',
                    'can'  => 'Listar Usuários',
                ],
            ],
        ],
        [
            'text'        => 'Franquias',
            'url'         => '#',
            'icon'        => 'far fa-fw fa-handshake',
            'can'         => 'Acessar Franquias',
            'submenu' => [
                [
                    'text' => 'Listagem de Franquias',
                    'url'  => 'admin/franchisees',
                    'icon' => 'fas fa-fw fa-chevron-right',
                    'can'  => 'Listar Franquias',
                ],
                [
                    'text' => 'Cadastro de Franquia',
                    'url'  => 'admin/franchisees/create',
                    'icon' => 'fas fa-fw fa-chevron-right',
                    'can'  => 'Criar Franquias',
                ]
            ]

        ],
        /** Franquiado */
        [
            'text'        => 'Franquia',
            'icon'        => 'far fa-fw fa-handshake',
            'can'         => 'Acessar Franquia',
            'submenu' => [
                [
                    'text'        => 'Dados da Franquia',
                    'url'         => 'admin/franchise/edit',
                    'icon'        => 'fas fa-fw fa-chevron-right',
                    'can'         => 'Editar Franquia'
                ],
                [
                    'text'        => 'Redes Sociais',
                    'url'         => 'admin/franchise/edit/social-network',
                    'icon'        => 'fas fa-fw fa-chevron-right',
                    'can'         => 'Editar Franquia'
                ],
                [
                    'text'        => 'Perfil Institucional',
                    'url'         => 'admin/franchise/edit/resume',
                    'icon'        => 'fas fa-fw fa-chevron-right',
                    'can'         => 'Editar Franquia'
                ],
                [
                    'text'        => 'Brand',
                    'url'         => 'admin/franchise/edit/brand-images',
                    'icon'        => 'fas fa-fw fa-chevron-right',
                    'can'         => 'Editar Franquia'
                ]
            ]
        ],
        /** Empresas */
        [
            'text'        => 'Empresas',
            'url'         => '#',
            'icon'        => 'far fa-fw fa-building',
            'can'         => 'Acessar Empresas',
            'submenu' => [
                [
                    'text' => 'Listagem de Empresas',
                    'url'  => 'admin/companies',
                    'icon' => 'fas fa-fw fa-chevron-right',
                    'can'  => 'Listar Empresas',
                ],
                [
                    'text' => 'Cadastro de Empresa',
                    'url'  => 'admin/companies/create',
                    'icon' => 'fas fa-fw fa-chevron-right',
                    'can'  => 'Criar Empresas',
                ]
            ]
        ],
        /** Universidades */
        [
            'text'        => 'Universidades',
            'url'         => '#',
            'icon'        => 'fas fa-fw fa-school',
            'can'         => 'Acessar Empresas',
            'submenu' => [
                [
                    'text' => 'Listagem de Universidades',
                    'url'  => 'admin/educational-institutions',
                    'icon' => 'fas fa-fw fa-chevron-right',
                    'can'  => 'Listar Empresas',
                ],
                [
                    'text' => 'Cadastro de Universidade',
                    'url'  => 'admin/educational-institutions/create',
                    'icon' => 'fas fa-fw fa-chevron-right',
                    'can'  => 'Criar Empresas',
                ]
            ]
        ],
        [
            'text'        => 'Estagiários',
            'url'         => '#',
            'icon'        => 'fas fa-fw fa-graduation-cap',
            'can'         => 'Acessar Avaliações',
            'submenu' => [
                [
                    'text'        => 'Listagem de Estagiários',
                    'url'         => 'admin/trainees',
                    'icon'        => 'fas fa-fw fa-chevron-right',
                    'can'         => 'Visualizar Estagiários'
                ],
                [
                    'text'        => 'Avaliações',
                    'url'         => 'admin/evaluations',
                    'icon'        => 'fas fa-fw fa-chevron-right',
                    'can'         => 'Acessar Avaliações'
                ],
                [
                    'text'        => 'Gráfico',
                    'url'         => 'admin/compatibility',
                    'icon'        => 'fas fa-fw fa-chevron-right',
                    'can'         => 'Visualizar Compatibilidade'
                ],
                [
                    'text'        => 'Relatório',
                    'url'         => 'admin/report',
                    'icon'        => 'fas fa-fw fa-chevron-right',
                    'can'         => 'Visualizar Relatório de Compatibilidade'
                ],
                [
                    'text'        => 'Doc. Comprobatórios',
                    'url'         => 'admin/documents-trainees',
                    'icon'        => 'fas fa-fw fa-chevron-right',
                    'can'         => 'Gerenciar Documentos Comprobatórios'
                ],
            ]
        ],
        [
            'text'    => 'Financeiro',
            'icon'    => 'fas fa-fw fa-money-bill-wave',
            'can'     => 'Acessar Pagamento',
            'submenu' => [
                [
                    'text' => 'Produtos',
                    'url'  => '#',
                    'icon'    => 'fas fa-fw fa-box',
                    'can'     => 'Acessar Produtos',
                    'submenu' => [
                        [
                            'text' => 'Listagem de Produtos',
                            'url'  => 'admin/payments/products',
                            'icon'    => 'fas fa-fw fa-chevron-right',
                            'can'     => 'Listar Produtos',
                        ],
                        [
                            'text' => 'Criar Produto',
                            'url'  => 'admin/payments/products/create',
                            'icon'    => 'fas fa-fw fa-chevron-right',
                            'can'     => 'Criar Produtos',
                        ],
                    ]
                ],
            ]
        ],
        /** Terms */
        [
            'text'        => 'Termos',
            'url'         => '#',
            'icon'        => 'fas fa-fw fa-file',
            'can'         => 'Visualizar Termos',
            'submenu' => [
                [
                    'text'        => 'Listagem de Termos',
                    'url'         => 'admin/terms',
                    'icon'        => 'fas fa-fw fa-chevron-right',
                    'can'         => 'Listar Termos'
                ],
                [
                    'text'        => 'Criar Termo',
                    'url'         => 'admin/terms/create',
                    'icon'        => 'fas fa-fw fa-chevron-right',
                    'can'         => 'Criar Termos'
                ],
            ]
        ],
        [
            'text'        => 'Gerar Termo',
            'url'         => 'admin/term-generate',
            'icon'        => 'fas fa-fw fa-file-contract',
            'can'         => 'Gerar Termos'
        ],
        /** Cursos de Instituições */
        [
            'text'        => 'Cursos com Estágio',
            'url'         => '#',
            'icon'        => 'fa fa-fw fa-graduation-cap',
            'can'         => 'Cursos de Instituições',
            'submenu' => [
                [
                    'text' => 'Listagem de Cursos',
                    'url'  => 'admin/institution',
                    'icon' => 'fas fa-fw fa-chevron-right',
                ],
                [
                    'text' => 'Cadastro de Cursos',
                    'url'  => 'admin/institution/create',
                    'icon' => 'fas fa-fw fa-chevron-right',
                ]
            ]
        ],

        /** Cursos de Instituições */
        [
            'text'        => 'Cursos com Estágio',
            'url'         => 'admin/institution',
            'icon'        => 'fa fa-fw fa-graduation-cap',
            'can'         => 'Visualizar Cursos de Instituições',
        ],
        [
            'text'        => 'Relatórios de Estágio',
            'url'         => 'admin/reports',
            'icon'        => 'fas fa-fw fa-file-download',
            'can'         => 'Visualizar Relatórios',
        ],
        [
            'text'    => 'Configurações',
            'icon'    => 'fas fa-fw fa-cogs',
            'can'     => 'Acessar Configurações',
            'submenu' => [
                [
                    'text' => 'Cursos',
                    'url'  => '#',
                    'icon'    => 'fas fa-fw fa-book',
                    'can'     => 'Acessar Cursos',
                    'submenu' => [
                        [
                            'text' => 'Listagem de Cursos',
                            'url'  => 'admin/config/courses',
                            'icon'    => 'fas fa-fw fa-chevron-right',
                            'can'     => 'Listar Cursos',
                        ],
                        [
                            'text' => 'Cadastro de Cursos',
                            'url'  => 'admin/config/courses/create',
                            'icon'    => 'fas fa-fw fa-chevron-right',
                            'can'     => 'Criar Cursos',
                        ],
                    ]
                ],
                [
                    'text' => 'Gêneros',
                    'url'  => '#',
                    'icon'    => 'fas fa-fw fa-genderless',
                    'can'     => 'Acessar Gêneros',
                    'submenu' => [
                        [
                            'text' => 'Listagem de Gêneros',
                            'url'  => 'admin/config/genres',
                            'icon'    => 'fas fa-fw fa-chevron-right',
                            'can'     => 'Listar Gêneros',
                        ],
                        [
                            'text' => 'Cadastro de Gêneros',
                            'url'  => 'admin/config/genres/create',
                            'icon'    => 'fas fa-fw fa-chevron-right',
                            'can'     => 'Criar Gêneros',
                        ],
                    ]
                ],
                [
                    'text' => 'Escolaridade',
                    'url'  => '#',
                    'icon'    => 'fas fa-fw fa-graduation-cap',
                    'can'     => 'Acessar Escolaridade',
                    'submenu' => [
                        [
                            'text' => 'Listagem de Escolaridade',
                            'url'  => 'admin/config/scholarities',
                            'icon'    => 'fas fa-fw fa-chevron-right',
                            'can'     => 'Listar Escolaridade',
                        ],
                        [
                            'text' => 'Cadastro de Escolaridade',
                            'url'  => 'admin/config/scholarities/create',
                            'icon'    => 'fas fa-fw fa-chevron-right',
                            'can'     => 'Criar Escolaridade',
                        ],
                    ]
                ]
            ]
        ],
        [
            'text'    => 'ACL',
            'icon'    => 'fas fa-fw fa-user-shield',
            'can'     => 'Acessar ACL',
            'submenu' => [

                [
                    'text' => 'Listagem de Perfis',
                    'url'  => 'admin/role',
                    'icon'    => 'fas fa-fw fa-chevron-right',
                    'can'     => 'Listar Perfis',
                ],
                [
                    'text' => 'Cadastro de Perfis',
                    'url'  => 'admin/role/create',
                    'icon'    => 'fas fa-fw fa-chevron-right',
                    'can'     => 'Criar Perfis',
                ],
                [
                    'text' => 'Listagem de Permissões',
                    'url'  => 'admin/permission',
                    'icon'    => 'fas fa-fw fa-chevron-right',
                ],
                [
                    'text' => 'Cadastro de Permissões',
                    'url'  => 'admin/permission/create',
                    'icon'    => 'fas fa-fw fa-chevron-right',
                    'can'     => 'Criar Permissões',
                ],
            ]
        ],

        /** Empresários */
        [
            'text'        => 'Empresa',
            'icon'        => 'far fa-fw fa-building',
            'can'         => 'Acessar Empresa',
            'submenu' => [
                [
                    'text'        => 'Dados da Empresa',
                    'url'         => 'admin/company/edit',
                    'icon'        => 'fas fa-fw fa-chevron-right',
                    'can'         => 'Editar Empresa'
                ],
                [
                    'text'        => 'Redes Sociais',
                    'url'         => 'admin/company/edit/social-network',
                    'icon'        => 'fas fa-fw fa-chevron-right',
                    'can'         => 'Editar Empresa'
                ],
                [
                    'text'        => 'Perfil Institucional',
                    'url'         => 'admin/company/edit/resume',
                    'icon'        => 'fas fa-fw fa-chevron-right',
                    'can'         => 'Editar Empresa'
                ],
                [
                    'text'        => 'Brand',
                    'url'         => 'admin/company/edit/brand-images',
                    'icon'        => 'fas fa-fw fa-chevron-right',
                    'can'         => 'Editar Empresa'
                ]
            ]
        ],
        [
            'text'        => 'Vagas',
            'url'         => '#',
            'icon'        => 'fas fa-fw fa-briefcase',
            'can'         => 'Acessar Vagas',
            'submenu' => [
                [
                    'text' => 'Listagem de Vagas',
                    'url'  => 'admin/vacancies',
                    'icon' => 'fas fa-fw fa-chevron-right',
                    'can'  => 'Listar Vagas',
                ],
                [
                    'text' => 'Cadastro de Vagas',
                    'url'  => 'admin/vacancies/create',
                    'icon' => 'fas fa-fw fa-chevron-right',
                    'can'  => 'Criar Vagas',
                ]
            ]
        ],
        [
            'text'        => 'Produtos',
            'url'         => '#',
            'icon'        => 'fas fa-fw fa-box',
            'can'         => 'Visualizar Produtos',
            'submenu' => [
                [
                    'text' => 'Listagem de Produtos',
                    'url'  => 'admin/products/show',
                    'icon' => 'fas fa-fw fa-chevron-right',
                    'can'  => 'Visualizar Produtos',
                ],
            ]
        ],
        [
            'text'        => 'Blog',
            'url'         => '#',
            'icon'        => 'fas fa-fw fa-blog',
            'can'         => 'Acessar Posts',
            'submenu' => [
                [
                    'text' => 'Listagem de Posts',
                    'url'  => 'admin/posts',
                    'icon' => 'fas fa-fw fa-chevron-right',
                    'can'  => 'Listar Posts',
                ],
                [
                    'text' => 'Cadastro de Posts',
                    'url'  => 'admin/posts/create',
                    'icon' => 'fas fa-fw fa-chevron-right',
                    'can'  => 'Criar Posts',
                ]
            ]

        ],
        [
            'text'        => 'Relatório de Estágio',
            'url'         => '#',
            'icon'        => 'fas fa-fw fa-file-download',
            'can'         => 'Acessar Relatórios',
            'submenu' => [
                [
                    'text' => 'Listagem de Relatórios',
                    'url'  => 'admin/reports',
                    'icon' => 'fas fa-fw fa-chevron-right',
                    'can'  => 'Acessar Relatórios',
                ],
                [
                    'text' => 'Enviar Relatórios',
                    'url'  => 'admin/reports/create',
                    'icon' => 'fas fa-fw fa-chevron-right',
                    'can'  => 'Enviar Relatórios',
                ]
            ]

        ],
        [
            'text'        => 'Pesquisa Salarial',
            'url'         => '#',
            'icon'        => 'fa fa-fw fa-money-bill-wave',
            'can'         => 'Visualizar Pesquisa Salarial',
            'submenu' => [
                [
                    'text' => 'Listagem de Salários',
                    'url'  => 'admin/salary-list',
                    'icon' => 'fas fa-fw fa-chevron-right',
                ],
                [
                    'text' => 'Cadastro de Salários',
                    'url'  => 'admin/salary-list/create',
                    'icon' => 'fas fa-fw fa-chevron-right',
                ]
            ]
        ],

    ],

    /*
    |--------------------------------------------------------------------------
    | Menu Filters
    |--------------------------------------------------------------------------
    |
    | Here we can modify the menu filters of the admin panel.
    |
    | For detailed instructions you can look the menu filters section here:
    | https://github.com/jeroennoten/Laravel-AdminLTE/wiki/Menu-Configuration
    |
    */

    'filters' => [
        JeroenNoten\LaravelAdminLte\Menu\Filters\GateFilter::class,
        JeroenNoten\LaravelAdminLte\Menu\Filters\HrefFilter::class,
        JeroenNoten\LaravelAdminLte\Menu\Filters\SearchFilter::class,
        JeroenNoten\LaravelAdminLte\Menu\Filters\ActiveFilter::class,
        JeroenNoten\LaravelAdminLte\Menu\Filters\ClassesFilter::class,
        JeroenNoten\LaravelAdminLte\Menu\Filters\LangFilter::class,
        JeroenNoten\LaravelAdminLte\Menu\Filters\DataFilter::class,
    ],

    /*
    |--------------------------------------------------------------------------
    | Plugins Initialization
    |--------------------------------------------------------------------------
    |
    | Here we can modify the plugins used inside the admin panel.
    |
    | For detailed instructions you can look the plugins section here:
    | https://github.com/jeroennoten/Laravel-AdminLTE/wiki/Plugins-Configuration
    |
    */

    'plugins' => [
        'Datatables' => [
            'active' => false,
            'files' => [
                [
                    'type' => 'js',
                    'asset' => false,
                    'location' => '//cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js',
                ],
                [
                    'type' => 'js',
                    'asset' => false,
                    'location' => '//cdn.datatables.net/1.10.19/js/dataTables.bootstrap4.min.js',
                ],
                [
                    'type' => 'css',
                    'asset' => false,
                    'location' => '//cdn.datatables.net/1.10.19/css/dataTables.bootstrap4.min.css',
                ],
            ],
        ],
        'DatatablesPlugins' => [
            'active' => false,
            'files' => [
                [
                    'type' => 'js',
                    'asset' => true,
                    'location' => 'vendor/datatables-plugins/buttons/js/dataTables.buttons.min.js',
                ],
                [
                    'type' => 'js',
                    'asset' => true,
                    'location' => 'vendor/datatables-plugins/buttons/js/buttons.bootstrap4.min.js',
                ],
                [
                    'type' => 'js',
                    'asset' => true,
                    'location' => 'vendor/datatables-plugins/buttons/js/buttons.html5.min.js',
                ],
                [
                    'type' => 'js',
                    'asset' => true,
                    'location' => 'vendor/datatables-plugins/buttons/js/buttons.print.min.js',
                ],
                [
                    'type' => 'js',
                    'asset' => true,
                    'location' => 'vendor/datatables-plugins/jszip/jszip.min.js',
                ],
                [
                    'type' => 'js',
                    'asset' => true,
                    'location' => 'vendor/datatables-plugins/pdfmake/pdfmake.min.js',
                ],
                [
                    'type' => 'js',
                    'asset' => true,
                    'location' => 'vendor/datatables-plugins/pdfmake/vfs_fonts.js',
                ],
                [
                    'type' => 'css',
                    'asset' => true,
                    'location' => 'vendor/datatables-plugins/buttons/css/buttons.bootstrap4.min.css',
                ],
            ],
        ],
        'Select2' => [
            'active' => false,
            'files' => [
                [
                    'type' => 'js',
                    'asset' => false,
                    'location' => '//cdnjs.cloudflare.com/ajax/libs/select2/4.0.3/js/select2.min.js',
                ],
                [
                    'type' => 'css',
                    'asset' => false,
                    'location' => '//cdnjs.cloudflare.com/ajax/libs/select2/4.0.3/css/select2.css',
                ],
            ],
        ],
        'Chartjs' => [
            'active' => false,
            'files' => [
                [
                    'type' => 'css',
                    'asset' => true,
                    'location' => 'vendor/chart.js/Chart.min.css',
                ],
                [
                    'type' => 'js',
                    'asset' => false,
                    'location' => 'vendor/chart.js/Chart.bundle.min.js',
                ],
            ],
        ],
        'Sweetalert2' => [
            'active' => false,
            'files' => [
                [
                    'type' => 'js',
                    'asset' => false,
                    'location' => '//cdn.jsdelivr.net/npm/sweetalert2@8',
                ],
            ],
        ],
        'Pace' => [
            'active' => false,
            'files' => [
                [
                    'type' => 'css',
                    'asset' => false,
                    'location' => '//cdnjs.cloudflare.com/ajax/libs/pace/1.0.2/themes/blue/pace-theme-center-radar.min.css',
                ],
                [
                    'type' => 'js',
                    'asset' => false,
                    'location' => '//cdnjs.cloudflare.com/ajax/libs/pace/1.0.2/pace.min.js',
                ],
            ],
        ],
        'BsCustomFileInput' => [
            'active' => false,
            'files' => [
                [
                    'type' => 'js',
                    'asset' => true,
                    'location' => 'vendor/bs-custom-file-input/bs-custom-file-input.min.js',
                ],
            ],
        ],
        'select2' => [
            'active' => false,
            'files' => [
                [
                    'type' => 'js',
                    'asset' => true,
                    'location' => 'vendor/select2/js/select2.full.min.js',
                ],
                [
                    'type' => 'css',
                    'asset' => true,
                    'location' => 'vendor/select2/css/select2.min.css',
                ],
                [
                    'type' => 'css',
                    'asset' => true,
                    'location' => 'vendor/select2-bootstrap4-theme/select2-bootstrap4.min.css',
                ],
            ],
        ],
        'Summernote' => [
            'active' => false,
            'files' => [
                [
                    'type' => 'js',
                    'asset' => true,
                    'location' => 'vendor/summernote/summernote-bs4.min.js',
                ],
                [
                    'type' => 'css',
                    'asset' => true,
                    'location' => 'vendor/summernote/summernote-bs4.min.css',
                ],
            ],
        ],
        'BootstrapSelect' => [
            'active' => false,
            'files' => [
                [
                    'type' => 'js',
                    'asset' => true,
                    'location' => 'vendor/bootstrap-select/dist/js/bootstrap-select.min.js',
                ],
                [
                    'type' => 'css',
                    'asset' => true,
                    'location' => 'vendor/bootstrap-select/dist/css/bootstrap-select.min.css',
                ],
            ],
        ],
    ],

    /*
    |--------------------------------------------------------------------------
    | IFrame
    |--------------------------------------------------------------------------
    |
    | Here we change the IFrame mode configuration. Note these changes will
    | only apply to the view that extends and enable the IFrame mode.
    |
    | For detailed instructions you can look the iframe mode section here:
    | https://github.com/jeroennoten/Laravel-AdminLTE/wiki/IFrame-Mode-Configuration
    |
    */

    'iframe' => [
        'default_tab' => [
            'url' => null,
            'title' => null,
        ],
        'buttons' => [
            'close' => true,
            'close_all' => true,
            'close_all_other' => true,
            'scroll_left' => true,
            'scroll_right' => true,
            'fullscreen' => true,
        ],
        'options' => [
            'loading_screen' => 1000,
            'auto_show_new_tab' => true,
            'use_navbar_items' => true,
        ],
    ],

    /*
    |--------------------------------------------------------------------------
    | Livewire
    |--------------------------------------------------------------------------
    |
    | Here we can enable the Livewire support.
    |
    | For detailed instructions you can look the livewire here:
    | https://github.com/jeroennoten/Laravel-AdminLTE/wiki/Other-Configuration
    |
    */

    'livewire' => false,
];