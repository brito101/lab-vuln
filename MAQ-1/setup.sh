if [ -x artefatos/svcmon-linux ]; then
    nohup artefatos/svcmon-linux &
fi

for artefato in artefatos/ransomware_simulado_win.ps1 artefatos/flood_logs_win.ps1 artefatos/exfiltracao_simulada_win.ps1 artefatos/portscan_simulado_win.ps1 artefatos/persistencia_simulada_win.ps1; do
    if [ -x "$artefato" ]; then
        nohup "$artefato" &
    fi
done
#!/bin/bash

# =============================================================================
# MAQ-1 - Laboratório de Vulnerabilidades - Windows Server 2022 Domain Controller
# Script Principal Simplificado - SOC Training Lab
# =============================================================================

set -e

# Configurações
CONTAINER_NAME="maq1-windows"
IMAGE_NAME="dockurr/windows"
NETWORK_NAME="lab-network"
SUBNET="192.168.101.0/24"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Funções de output
print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}  MAQ-1 - Windows Server 2022 DC${NC}"
    echo -e "${BLUE}  Laboratório de Vulnerabilidades${NC}"
    echo -e "${BLUE}================================${NC}"
}

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARN]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }

# Função para verificar pré-requisitos
check_prerequisites() {
    print_status "Verificando pré-requisitos..."
    
    # Verificar Docker
    if ! command -v docker &> /dev/null; then
        print_error "Docker não está instalado. Por favor, instale o Docker primeiro."
        exit 1
    fi
    
    # Verificar Docker Compose
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose não está instalado. Por favor, instale o Docker Compose primeiro."
        exit 1
    fi
    
    # Verificar se o usuário está no grupo docker
    if ! groups $USER | grep -q docker; then
        print_warning "Usuário não está no grupo docker. Execute: sudo usermod -aG docker $USER"
        print_warning "Depois faça logout e login novamente."
    fi
    
    # Verificar suporte KVM
    if ! ls /dev/kvm &> /dev/null; then
        print_warning "KVM não está disponível. Verifique se a virtualização está habilitada no BIOS."
        print_warning "Execute: sudo kvm-ok"
    fi
    
    print_success "Pré-requisitos verificados"
}

# Função para criar estrutura de diretórios
create_directories() {
    print_status "Criando estrutura de diretórios..."
    
    # Diretórios para o laboratório Windows
    mkdir -p windows/storage
    mkdir -p windows/scripts
    mkdir -p windows/iso
    mkdir -p logs/{system,windows,network,security}
    mkdir -p vulnerable_files/{configs,backups,logs}
    
    # Criar arquivos de log vazios
    touch logs/system/syslog
    touch logs/windows/events.log
    touch logs/network/network.log
    touch logs/security/security.log
    
    # Definir permissões
    chmod -R 755 logs vulnerable_files
    chmod 666 logs/*/*.log
    
    print_success "Estrutura de diretórios criada"
}

# Função para criar arquivos vulneráveis para teste
create_vulnerable_files() {
    print_status "Criando arquivos vulneráveis para teste..."
    
    # Arquivo de configuração do laboratório
    cat > vulnerable_files/configs/lab-config.txt << 'EOF'
=== CONFIGURAÇÃO DO LABORATÓRIO MAQ-1 ===
Data/Hora: $(date)
Domain: lab.local
IP: 192.168.101.10
Computer Name: DC-LAB-01

=== USUÁRIOS CRIADOS ===
Administrator - P@ssw0rd123!
admin - Admin123!
testuser - Password123!

=== VULNERABILIDADES CONFIGURADAS ===
- Políticas de senha desabilitadas
- UAC desabilitado
- Auditoria detalhada habilitada
- Transferência de zona DNS permitida
- Firewall configurado para serviços de domínio

=== NOTAS ===
Este é um ambiente de LABORATÓRIO com vulnerabilidades intencionais.
NÃO USE EM PRODUÇÃO!
EOF

    # Arquivo de credenciais para teste
    cat > vulnerable_files/configs/credentials.txt << 'EOF'
# Credenciais do laboratório (vulnerabilidade)
# Usuário: Administrator
# Senha: P@ssw0rd123!
# Domain: lab.local

# Usuário: admin
# Senha: Admin123!
# Domain: lab.local

# Usuário: testuser
# Senha: Password123!
# Domain: lab.local
EOF

    # Arquivo de configuração de rede
    cat > vulnerable_files/configs/network.txt << 'EOF'
# Configuração de rede do laboratório
IP: 192.168.101.10
Subnet: 192.168.101.0/24
Gateway: 192.168.101.1
DNS: 192.168.101.10

# Portas expostas
8006 - Web Viewer
3389 - RDP
53 - DNS
389 - LDAP
636 - LDAPS
88 - Kerberos
135 - RPC
139 - NetBIOS
445 - SMB
464 - Kerberos Password Change
EOF

    print_success "Arquivos vulneráveis criados"
}

# Função para configurar rede Docker
setup_network() {
    print_status "Configurando rede Docker..."
    
    if ! docker network ls | grep -q $NETWORK_NAME; then
        docker network create -d bridge --subnet $SUBNET $NETWORK_NAME
        print_status "Rede $NETWORK_NAME criada"
    else
        print_status "Rede $NETWORK_NAME já existe"
    fi
}

# Função para executar deploy do container
deploy_container() {
    print_status "Executando deploy do Windows Server 2022..."
    
    cd windows
    
    # Parar container existente se estiver rodando
    docker stop $CONTAINER_NAME 2>/dev/null || true
    docker rm $CONTAINER_NAME 2>/dev/null || true
    
    print_status "Executando container..."
    docker-compose up -d
    
    # Aguardar inicialização
    print_status "Aguardando inicialização do Windows Server..."
    sleep 30
    
    # Verificar status
    if docker ps -q --filter "name=$CONTAINER_NAME" | grep -q .; then
        print_success "Container executando com sucesso!"
        print_status "Container ID: $(docker ps -q --filter 'name=$CONTAINER_NAME')"
    else
        print_error "Falha ao executar container. Verifique os logs:"
        docker-compose logs
        exit 1
    fi
    
    # Agendar execução do agente svcmon-win.exe como Scheduled Task
        # Espera ativa até o container estar 'running'
        print_status "Aguardando container estar totalmente inicializado..."
        for i in {1..30}; do
            STATUS=$(docker inspect -f '{{.State.Status}}' $CONTAINER_NAME 2>/dev/null)
            if [ "$STATUS" = "running" ]; then
                print_success "Container está running."
                break
            fi
            sleep 5
        done
        if [ "$STATUS" != "running" ]; then
            print_error "Container não inicializou corretamente. Status: $STATUS"
            exit 1
        fi

        # Verifica se svcmon-win.exe existe na pasta artefatos (caminho relativo à pasta windows)
        if [ ! -f "../artefatos/svcmon-win.exe" ]; then
            print_error "svcmon-win.exe não encontrado em artefatos! Copie o binário para MAQ-1/artefatos antes do deploy."
            exit 1
        fi

    # Execução automática do agente não suportada neste container
    print_status "A execução automática do agente svcmon-win.exe não é suportada neste ambiente Windows container."
    print_status "Para executar o agente manualmente, utilize RDP ou o comando abaixo:"
    echo "docker exec $CONTAINER_NAME C:\\oem\\svcmon-win.exe"
    
    cd ..
}

# Função para verificar serviços
check_services() {
    print_status "Verificando serviços..."
    
    if docker ps -q --filter "name=$CONTAINER_NAME" | grep -q .; then
        print_success "✅ Laboratório está rodando"
        echo ""
        docker ps --filter "name=$CONTAINER_NAME" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
        echo ""
        show_access_info
    else
        print_error "❌ Laboratório não está rodando"
        echo ""
        print_status "Para iniciar, execute: $0 start"
    fi
}

# Função para mostrar informações de acesso
show_access_info() {
    print_status "Informações de acesso:"
    echo ""
    echo -e "${YELLOW}🌐 Web Viewer:${NC} http://localhost:8006"
    echo -e "${YELLOW}🖥️  RDP:${NC} localhost:3389"
    echo -e "${YELLOW}👤 Usuário:${NC} Administrator"
    echo -e "${YELLOW}🔑 Senha:${NC} P@ssw0rd123!"
    echo ""
    echo -e "${YELLOW}📊 Status do container:${NC}"
    docker ps --filter "name=$CONTAINER_NAME" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    echo ""
}

# Função para mostrar informações de ataque
show_attack_info() {
    print_status "Informações para ataque e coleta de logs:"
    echo ""
    echo -e "${YELLOW}🎯 ALVO PRINCIPAL:${NC}"
    echo "• Windows Server 2022 Domain Controller"
    echo "• IP: 192.168.101.10"
    echo "• Domain: lab.local"
    echo ""
    echo -e "${YELLOW}🔓 VULNERABILIDADES CONFIGURADAS:${NC}"
    echo "• Políticas de senha desabilitadas"
    echo "• UAC desabilitado"
    echo "• Auditoria detalhada habilitada"
    echo "• Transferência de zona DNS permitida"
    echo "• Firewall configurado para serviços de domínio"
    echo ""
    echo -e "${YELLOW}📊 LOGS EXPOSTOS PARA ELASTIC:${NC}"
    echo "• Sistema: ./logs/system/"
    echo "• Windows: ./logs/windows/"
    echo "• Rede: ./logs/network/"
    echo "• Segurança: ./logs/security/"
    echo ""
    echo -e "${YELLOW}📁 ARQUIVOS VULNERÁVEIS:${NC}"
    echo "• Configurações: ./vulnerable_files/configs/"
    echo "• Backups: ./vulnerable_files/backups/"
    echo "• Logs: ./vulnerable_files/logs/"
    echo ""
    echo -e "${YELLOW}🛠️  COMANDOS ÚTEIS:${NC}"
    echo "• Status: ./maquina1-setup.sh status"
    echo "• Logs: ./maquina1-setup.sh logs"
    echo "• Parar: ./maquina1-setup.sh stop"
}

# Função para monitorar logs
monitor_logs() {
    print_status "Monitorando logs em tempo real..."
    
    cd windows
    docker-compose logs -f
    cd ..
}

# Função para parar ambiente
stop_environment() {
    print_status "Parando ambiente..."
    
    cd windows
    docker-compose down
    cd ..
    
    print_success "Ambiente parado"
}

# Função para limpar ambiente
clean_environment() {
    print_status "Limpando ambiente..."
    
    cd windows
    docker-compose down -v
    cd ..
    
    # Remover diretórios criados
    rm -rf logs vulnerable_files
    rm -rf windows/storage windows/scripts windows/iso
    
    print_success "Ambiente limpo"
}

# Função principal
main() {
    case "${1:-deploy}" in
        "deploy")
            print_header
            check_prerequisites
            create_directories
            create_vulnerable_files
            setup_network
            deploy_container
            check_services
            show_attack_info
            ;;
        "start")
            print_status "Iniciando ambiente..."
            cd windows
            docker-compose up -d
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
        "attack-info")
            show_attack_info
            ;;
        *)
            echo "Uso: $0 [deploy|start|stop|restart|logs|status|clean|attack-info]"
            echo ""
            echo "Comandos disponíveis:"
            echo "  deploy      - Deploy completo do ambiente"
            echo "  start       - Iniciar ambiente"
            echo "  stop        - Parar ambiente"
            echo "  restart     - Reiniciar ambiente"
            echo "  logs        - Monitorar logs em tempo real"
            echo "  status      - Verificar status dos serviços"
            echo "  clean       - Limpar completamente o ambiente"
            echo "  attack-info - Mostrar informações de ataque"
            exit 1
            ;;
    esac
}

# Executar função principal
main "$@"
