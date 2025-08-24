#!/bin/bash

# MAQ-4 - Laboratório Zimbra CVE-2024-45519
# Script de gerenciamento do laboratório

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para exibir mensagens
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Função para verificar se o Docker está rodando
check_docker() {
    if ! docker info >/dev/null 2>&1; then
        print_error "Docker não está rodando. Inicie o Docker e tente novamente."
        exit 1
    fi
    print_success "Docker está rodando"
}

# Função para criar rede Docker
create_network() {
    if ! docker network ls | grep -q "lab-network"; then
        print_status "Criando rede Docker 'lab-network'..."
        docker network create lab-network
        print_success "Rede 'lab-network' criada"
    else
        print_success "Rede 'lab-network' já existe"
    fi
}

# Função para deploy
deploy() {
    print_status "Iniciando deploy do laboratório MAQ-4..."
    
    check_docker
    create_network
    
    print_status "Construindo imagem Docker..."
    docker compose build --no-cache
    
    print_status "Iniciando serviços..."
    docker compose up -d
    
    print_status "Aguardando inicialização dos serviços..."
    sleep 60
    
    print_success "Laboratório MAQ-4 deployado com sucesso!"
    print_status "Aguarde mais alguns minutos para o Zimbra inicializar completamente"
    print_status "Chaves SSH disponíveis em: ./ssh_keys/"
    
    show_info
}

# Função para parar serviços
stop() {
    print_status "Parando serviços do laboratório..."
    docker compose down
    print_success "Serviços parados"
}

# Função para status
status() {
    print_status "Status do laboratório MAQ-4:"
    echo
    
    if docker compose ps | grep -q "maquina4-zimbra"; then
        print_success "Container ativo:"
        docker compose ps
        echo
        
        print_status "Logs recentes:"
        docker compose logs --tail=20
    else
        print_warning "Nenhum serviço ativo"
    fi
}

# Função para limpar
clean() {
    print_warning "Removendo todos os recursos do laboratório..."
    
    docker compose down -v
    docker rmi maq-4-zimbra-vuln:latest 2>/dev/null || true
    
    print_success "Laboratório limpo"
}

# Função para mostrar informações
show_info() {
    echo
    echo "======================================="
    echo "LABORATÓRIO MAQ-4 - ZIMBRA CVE-2024-45519"
    echo "======================================="
    echo "Interface Web: http://localhost:80"
    echo "Interface Web (HTTPS): https://localhost:443"
    echo "Admin Console: https://localhost:7071"
    echo "SMTP: localhost:25"
    echo "SSH: localhost:22"
    echo
    echo "Credenciais SSH:"
    echo "  Root: zimbra123"
    echo "  Analyst: password123 (configurável via ANALYST_PASSWORD)"
    echo "  Chave SSH: ./ssh_keys/analyst_id_rsa"
    echo "  Chave Pública: ./ssh_keys/analyst_id_rsa.pub"
    echo "  Senha da chave: igual à senha do usuário"
    echo
    echo "Exploit: python3 CVE-2024-45519/exploit.py localhost"
    echo "======================================="
}

# Função para testar conectividade
test_connectivity() {
    print_status "Testando conectividade..."
    
    # Testar porta 80
    if curl -s -o /dev/null -w "%{http_code}" http://localhost:80 | grep -q "200"; then
        print_success "Porta 80 (HTTP) - OK"
    else
        print_warning "Porta 80 (HTTP) - Não responde"
    fi
    
    # Testar porta 443
    if curl -s -o /dev/null -w "%{http_code}" https://localhost:443 --insecure | grep -q "200"; then
        print_success "Porta 443 (HTTPS) - OK"
    else
        print_warning "Porta 443 (HTTPS) - Não responde"
    fi
    
    # Testar porta 25
    if timeout 5 bash -c "</dev/tcp/localhost/25" 2>/dev/null; then
        print_success "Porta 25 (SMTP) - OK"
    else
        print_warning "Porta 25 (SMTP) - Não responde"
    fi
    
    # Testar porta 22
    if timeout 5 bash -c "</dev/tcp/localhost/22" 2>/dev/null; then
        print_success "Porta 22 (SSH) - OK"
    else
        print_warning "Porta 22 (SSH) - Não responde"
    fi
}

# Menu principal
case "${1:-}" in
    deploy)
        deploy
        ;;
    stop)
        stop
        ;;
    status)
        status
        ;;
    clean)
        clean
        ;;
    test)
        test_connectivity
        ;;
    info)
        show_info
        ;;
    *)
        echo "Uso: $0 {deploy|stop|status|clean|test|info}"
        echo
        echo "Comandos:"
        echo "  deploy  - Deploy do laboratório"
        echo "  stop    - Parar serviços"
        echo "  status  - Status dos serviços"
        echo "  clean   - Limpar recursos"
        echo "  test    - Testar conectividade"
        echo "  info    - Mostrar informações"
        exit 1
        ;;
esac
