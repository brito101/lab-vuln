#!/bin/bash

# MAQ-2 - Ambiente Laravel Vulnerável
# Script de gerenciamento simplificado

CONTAINER_NAME="maquina2"
NETWORK_NAME="soc-network"
SUBNET="192.168.201.0/24"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Funções de output
print_header() {
    echo -e "${BLUE}"
    echo "=========================================="
    echo "  MAQ-2 - AMBIENTE LARAVEL VULNERÁVEL"
    echo "=========================================="
    echo -e "${NC}"
}

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Criar estrutura de diretórios
create_directories() {
    print_status "Criando estrutura de diretórios..."
    
    # Diretórios de logs
    mkdir -p logs/{system,nginx,php,laravel,mysql,redis,meilisearch,mailpit,selenium,app,access,error,debug}
    
    # Diretórios vulneráveis
    mkdir -p vulnerable_files/{webshells,configs,backups,uploads}
    mkdir -p uploads
    mkdir -p backups
    mkdir -p configs
    mkdir -p home
    
    # Definir permissões
    chmod -R 755 logs
    chmod -R 755 vulnerable_files
    chmod -R 755 uploads
    chmod -R 755 backups
    chmod -R 755 configs
    chmod -R 755 home
    
    print_success "Estrutura de diretórios criada"
}

# Criar arquivos vulneráveis para teste
create_vulnerable_files() {
    print_status "Criando arquivos vulneráveis para teste..."
    
    # Webshell simples
    cat > vulnerable_files/webshells/shell.php << 'EOF'
<?php
if(isset($_GET['cmd'])) {
    system($_GET['cmd']);
}
?>
EOF

    # Configuração vulnerável
    cat > vulnerable_files/configs/app.config.php << 'EOF'
<?php
return [
    'debug' => true,
    'log_level' => 'debug',
    'database' => [
        'host' => 'localhost',
        'username' => 'root',
        'password' => 'password',
        'database' => 'laravel'
    ]
];
EOF

    # Backup com dados sensíveis
    cat > vulnerable_files/backups/database_backup.sql << 'EOF'
-- Backup da base de dados
INSERT INTO users (name, email, password) VALUES 
('admin', 'admin@test.com', 'password123'),
('user1', 'user1@test.com', 'secret123');
EOF

    # Log de segurança
    cat > vulnerable_files/security.log << 'EOF'
[2024-08-16 10:00:00] Security.INFO: User admin logged in from 192.168.1.100
[2024-08-16 10:05:00] Security.WARNING: Failed login attempt for user admin from 192.168.1.101
[2024-08-16 10:10:00] Security.ERROR: SQL injection attempt detected in query parameter
EOF

    chmod 666 vulnerable_files/webshells/shell.php
    chmod 666 vulnerable_files/configs/app.config.php
    chmod 666 vulnerable_files/backups/database_backup.sql
    chmod 666 vulnerable_files/security.log
    
    print_success "Arquivos vulneráveis criados"
}

# Configurar rede
setup_network() {
    print_status "Configurando rede Docker..."
    
    # Verificar se a rede já existe
    if ! docker network ls | grep -q "$NETWORK_NAME"; then
        docker network create --driver bridge --subnet "$SUBNET" "$NETWORK_NAME"
        print_success "Rede $NETWORK_NAME criada"
    else
        print_warning "Rede $NETWORK_NAME já existe"
    fi
}

# Deploy do container
deploy_container() {
    print_status "Executando deploy com Sail..."
    
    cd trainees
    
    # Verificar se o .env existe, se não, copiar do .env.example
    if [ ! -f .env ]; then
        print_status "Criando arquivo .env a partir do .env.example..."
        cp .env.example .env
    fi
    
    # Instalar dependências do Composer se necessário
    if [ ! -d "vendor" ]; then
        print_status "Instalando dependências do Composer..."
        docker run --rm -v "$(pwd):/var/www/html" -w /var/www/html composer:latest composer install --ignore-platform-reqs
    fi
    
    # Verificar se o Sail está disponível
    if [ ! -f "vendor/bin/sail" ]; then
        print_error "Sail não encontrado. Instalando Laravel Sail..."
        docker run --rm -v "$(pwd):/var/www/html" -w /var/www/html composer:latest composer require laravel/sail --dev --ignore-platform-reqs
    fi
    
    # Executar Sail up
    print_status "Executando 'sail up -d'..."
    if command -v sail &> /dev/null; then
        sail up -d
    elif [ -f "vendor/bin/sail" ]; then
        ./vendor/bin/sail up -d
    else
        print_error "Sail não encontrado. Tentando docker-compose diretamente..."
        docker-compose up -d
    fi
    
    # Aguardar os serviços estarem prontos
    print_status "Aguardando serviços estarem prontos..."
    sleep 30
    
    # Configurar Laravel
    print_status "Configurando Laravel..."
    if command -v sail &> /dev/null; then
        sail artisan key:generate
        sail artisan storage:link
        sail artisan migrate --seed
    elif [ -f "vendor/bin/sail" ]; then
        ./vendor/bin/sail artisan key:generate
        ./vendor/bin/sail artisan storage:link
        ./vendor/bin/sail artisan migrate --seed
    else
        docker-compose exec laravel.test php artisan key:generate
        docker-compose exec laravel.test php artisan storage:link
        docker-compose exec laravel.test php artisan migrate --seed
    fi
    
    cd ..
    
    print_success "Deploy concluído"
}

# Verificar serviços
check_services() {
    print_status "Verificando status dos serviços..."
    
    cd trainees
    
    if command -v sail &> /dev/null; then
        sail ps
    elif [ -f "vendor/bin/sail" ]; then
        ./vendor/bin/sail ps
    else
        docker-compose ps
    fi
    
    cd ..
}

# Mostrar informações de ataque
show_attack_info() {
    print_header
    echo -e "${YELLOW}🎯 VETORES DE ATAQUE DISPONÍVEIS:${NC}"
    echo ""
    echo "1. 🌐 Web Application (Porta 80)"
    echo "   - Laravel com debug ativado"
    echo "   - Logs expostos para análise"
    echo "   - Upload de arquivos vulnerável"
    echo ""
    echo "2. 🗄️  Banco de Dados (Porta 9094)"
    echo "   - MySQL com credenciais padrão"
    echo "   - Usuário: root, Senha: password"
    echo ""
    echo "3. 🔴 Redis (Porta 9095)"
    echo "   - Redis sem autenticação"
    echo ""
    echo "4. 🐳 Container Escape"
    echo "   - Docker socket exposto"
    echo "   - Container privilegiado"
    echo "   - Capabilities perigosas ativadas"
    echo ""
    echo -e "${YELLOW}📁 ARQUIVOS VULNERÁVEIS:${NC}"
    echo "   - Webshell: vulnerable_files/webshells/shell.php"
    echo "   - Config: vulnerable_files/configs/app.config.php"
    echo "   - Backup: vulnerable_files/backups/database_backup.sql"
    echo "   - Logs: vulnerable_files/security.log"
    echo ""
    echo -e "${YELLOW}🔍 LOGS EXPOSTOS PARA ELASTIC:${NC}"
    echo "   - Sistema: logs/system/"
    echo "   - Nginx: logs/nginx/"
    echo "   - PHP: logs/php/"
    echo "   - Laravel: logs/laravel/"
    echo "   - MySQL: logs/mysql/"
    echo "   - Redis: logs/redis/"
    echo "   - Meilisearch: logs/meilisearch/"
    echo "   - Mailpit: logs/mailpit/"
    echo "   - Selenium: logs/selenium/"
    echo ""
    echo -e "${YELLOW}🚀 COMANDOS ÚTEIS:${NC}"
    echo "   - Status: ./maquina2-setup.sh status"
    echo "   - Logs: ./maquina2-setup.sh logs"
    echo "   - Shell: ./maquina2-setup.sh shell"
    echo "   - Teste: ./attack-test.sh"
    echo "   - Escape: ./container-escape-demo.sh"
}

# Monitorar logs
monitor_logs() {
    print_status "Monitorando logs em tempo real..."
    echo "Pressione Ctrl+C para parar"
    
    cd trainees
    
    if command -v sail &> /dev/null; then
        sail logs -f
    elif [ -f "vendor/bin/sail" ]; then
        ./vendor/bin/sail logs -f
    else
        docker-compose logs -f
    fi
    
    cd ..
}

# Parar ambiente
stop_environment() {
    print_status "Parando ambiente..."
    
    cd trainees
    
    if command -v sail &> /dev/null; then
        sail down
    elif [ -f "vendor/bin/sail" ]; then
        ./vendor/bin/sail down
    else
        docker-compose down
    fi
    
    cd ..
    
    print_success "Ambiente parado"
}

# Limpar ambiente
clean_environment() {
    print_status "Limpando ambiente..."
    
    cd trainees
    
    if command -v sail &> /dev/null; then
        sail down -v
    elif [ -f "vendor/bin/sail" ]; then
        ./vendor/bin/sail down -v
    else
        docker-compose down -v
    fi
    
    cd ..
    
    # Remover diretórios criados
    rm -rf logs vulnerable_files uploads backups configs home
    
    print_success "Ambiente limpo"
}

# Função principal
main() {
    case "${1:-deploy}" in
        "deploy")
            print_header
            create_directories
            create_vulnerable_files
            setup_network
            deploy_container
            check_services
            show_attack_info
            ;;
        "start")
            print_status "Iniciando ambiente..."
            cd trainees
            if command -v sail &> /dev/null; then
                sail up -d
            elif [ -f "vendor/bin/sail" ]; then
                ./vendor/bin/sail up -d
            else
                docker-compose up -d
            fi
            cd ..
            ;;
        "stop")
            stop_environment
            ;;
        "restart")
            stop_environment
            sleep 2
            main start
            ;;
        "logs")
            monitor_logs
            ;;
        "status")
            check_services
            ;;
        "clean")
            clean_environment
            ;;
        "shell")
            print_status "Acessando shell do container Laravel..."
            cd trainees
            if command -v sail &> /dev/null; then
                sail shell
            elif [ -f "vendor/bin/sail" ]; then
                ./vendor/bin/sail shell
            else
                docker-compose exec laravel.test bash
            fi
            cd ..
            ;;
        "attack-info")
            show_attack_info
            ;;
        *)
            echo "Uso: $0 [deploy|start|stop|restart|logs|status|clean|shell|attack-info]"
            echo ""
            echo "Comandos disponíveis:"
            echo "  deploy      - Deploy completo do ambiente"
            echo "  start       - Iniciar ambiente"
            echo "  stop        - Parar ambiente"
            echo "  restart     - Reiniciar ambiente"
            echo "  logs        - Monitorar logs em tempo real"
            echo "  status      - Verificar status dos serviços"
            echo "  clean       - Limpar completamente o ambiente"
            echo "  shell       - Acessar shell do container"
            echo "  attack-info - Mostrar informações de ataque"
            exit 1
            ;;
    esac
}

# Executar função principal
main "$@"
