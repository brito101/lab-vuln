# Alfa Estágios - Sistema de Vagas para Estágio

## 📋 Descrição

O **Alfa Estágios** é uma plataforma web desenvolvida em Laravel que conecta estudantes a oportunidades de estágio. O sistema funciona como um agente integrador entre escolas/universidades e empresas, facilitando o processo de contratação de estagiários.

## 🏗️ Arquitetura

- **Framework**: Laravel 8.x
- **Banco de Dados**: MySQL 8.0
- **Cache**: Redis
- **Frontend**: AdminLTE 3.2.0
- **Autenticação**: Laravel Sanctum
- **Permissões**: Spatie Laravel Permission
- **Pagamentos**: Laravel Cashier (Stripe)
- **Localização**: Português Brasileiro

## 🚀 Funcionalidades Principais

### Para Estudantes
- Cadastro de currículo
- Busca de vagas de estágio
- Candidatura a oportunidades
- Acompanhamento de processos seletivos
- Upload de documentos
- Perfil profissional completo

### Para Empresas
- Publicação de vagas
- Gestão de candidatos
- Sistema de avaliação
- Relatórios e analytics
- Gestão de processos seletivos

### Para Administradores
- Gestão de usuários e permissões
- Moderação de conteúdo
- Relatórios gerenciais
- Configurações do sistema

## 🛠️ Tecnologias Utilizadas

- **Backend**: PHP 8.2, Laravel Framework
- **Frontend**: HTML5, CSS3, JavaScript, AdminLTE
- **Banco**: MySQL com migrations e seeders
- **Cache**: Redis para performance
- **Busca**: Meilisearch para indexação
- **Email**: Mailpit para desenvolvimento
- **Testes**: PHPUnit, Selenium
- **Containerização**: Docker com Laravel Sail

## 📦 Instalação e Configuração

### Pré-requisitos
- Docker e Docker Compose
- Composer (para instalação local)

### Deploy Automatizado
```bash
# Na raiz do projeto MAQ-2
./maquina2-setup.sh deploy
```

### Deploy Manual
```bash
# 1. Instalar dependências
composer install --ignore-platform-reqs

# 2. Configurar ambiente
cp .env.example .env

# 3. Gerar chave da aplicação
php artisan key:generate

# 4. Criar link simbólico para storage
php artisan storage:link

# 5. Executar migrations e seeders
php artisan migrate --seed

# 6. Iniciar com Sail
./vendor/bin/sail up -d
```

## 🌐 Acesso ao Sistema

- **URL Principal**: http://localhost:80
- **AdminLTE**: http://localhost:80/admin
- **API**: http://localhost:80/api
- **Mailpit**: http://localhost:8025
- **Meilisearch**: http://localhost:7700

## 🔐 Credenciais Padrão

### Usuário Administrador
- **Email**: admin@alfestagios.com
- **Senha**: password

### Usuário Empresa
- **Email**: empresa@teste.com
- **Senha**: password

### Usuário Estudante
- **Email**: estudante@teste.com
- **Senha**: password

## 📊 Estrutura do Banco de Dados

### Tabelas Principais
- `users` - Usuários do sistema
- `companies` - Empresas cadastradas
- `vacancies` - Vagas de estágio
- `candidates` - Candidatos às vagas
- `posts` - Posts do blog
- `documents` - Documentos dos usuários
- `evaluations` - Avaliações de candidatos

### Relacionamentos
- Usuários podem ter múltiplos perfis (estudante, empresa, admin)
- Empresas podem publicar múltiplas vagas
- Candidatos podem se candidatar a múltiplas vagas
- Sistema de permissões baseado em roles

## 🔍 Funcionalidades de Segurança

### Implementadas
- Autenticação via Laravel Sanctum
- Sistema de permissões baseado em roles
- Validação de dados em formulários
- Proteção CSRF
- Sanitização de inputs

### Para Treinamento (Vulnerabilidades Intencionais)
- Debug mode ativado
- Logs detalhados expostos
- Upload de arquivos com validação reduzida
- Exposição de informações do sistema

## 📝 Logs e Monitoramento

### Logs Disponíveis
- **Laravel**: `storage/logs/laravel.log`
- **Acesso**: `storage/logs/access.log`
- **Erros**: `storage/logs/error.log`
- **Segurança**: `storage/logs/security.log`

### Monitoramento
- Logs expostos para coleta via Elastic
- Métricas de performance
- Auditoria de ações dos usuários
- Rastreamento de visitas

## 🧪 Testes

### Testes Automatizados
```bash
# Executar testes PHPUnit
./vendor/bin/sail artisan test

# Executar testes com Selenium
./vendor/bin/sail artisan dusk
```

### Testes de Segurança
```bash
# Script de teste de ataques
../attack-test.sh

# Demonstração de escape de container
../container-escape-demo.sh
```

## 🐳 Docker e Sail

### Serviços Disponíveis
- **laravel.test**: Aplicação principal (porta 80)
- **mysql**: Banco de dados (porta 3306)
- **redis**: Cache e sessões (porta 6379)
- **meilisearch**: Motor de busca (porta 7700)
- **mailpit**: Servidor de email (porta 8025)
- **selenium**: Testes automatizados (porta 4444)

### Comandos Úteis
```bash
# Status dos serviços
./vendor/bin/sail ps

# Logs em tempo real
./vendor/bin/sail logs -f

# Acessar shell do container
./vendor/bin/sail shell

# Executar comandos Artisan
./vendor/bin/sail artisan [comando]
```

## 📚 Recursos de Aprendizado

### Documentação
- [Laravel Documentation](https://laravel.com/docs)
- [AdminLTE Documentation](https://adminlte.io/docs)
- [Laravel Sail Documentation](https://laravel.com/docs/sail)

### Treinamentos
- Sistema de vagas para estágio
- Gestão de candidatos
- Processos seletivos
- Relatórios gerenciais

## 🚨 Avisos de Segurança

⚠️ **ATENÇÃO**: Este ambiente é configurado intencionalmente com vulnerabilidades para fins de treinamento em segurança. **NÃO USE EM PRODUÇÃO**.

### Vulnerabilidades Configuradas
- Debug mode ativado
- Logs expostos
- Upload de arquivos vulnerável
- Container com privilégios elevados
- Docker socket exposto

## 🤝 Suporte

Para dúvidas técnicas ou problemas de configuração:
- **Email**: suporte@alfestagios.com
- **Telefone**: +55 (47) 98884-7801
- **Documentação**: Este README e documentação do Laravel

---

**Alfa Estágios** - Conectando talentos a oportunidades desde 2022.
