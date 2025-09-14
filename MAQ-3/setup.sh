#!/bin/bash

# =============================================================================
# MAQ-3 - Laboratório de Infraestrutura Linux Vulnerável
# Script Principal Simplificado - SOC Training Lab
# =============================================================================

set -e

# Configurações
CONTAINER_NAME="maquina3-soc"
IMAGE_NAME="maquina3-soc"
NETWORK_NAME="soc-network"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Funções de output
print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}  MAQ-3 - SOC Training Lab${NC}"
    echo -e "${BLUE}================================${NC}"
}

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARN]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }

# Função para criar estrutura de diretórios
create_directories() {
    print_status "Criando estrutura de diretórios..."
    
    # Diretórios de logs
    mkdir -p logs/{system,auth,ssh,ftp,samba,rsyslog,app,commands,debug}
    mkdir -p vulnerable_files/{dumps,secrets,configs,backups,keys}
    mkdir -p ftp_public/{uploads,downloads,admin}
    mkdir -p samba_public/{documents,backups,shared}
    mkdir -p configs/{ssh,ftp,samba}
    mkdir -p home/{ftpuser,smbuser,admin}
    
    # Criar arquivos de log vazios
    touch logs/system/syslog
    touch logs/auth/auth.log
    touch logs/ssh/ssh.log
    touch logs/ftp/vsftpd.log
    touch logs/samba/smb.log
    touch logs/app/application.log
    touch logs/commands/commands.log
    touch logs/debug/debug.log
    
    # Definir permissões
    chmod -R 755 logs vulnerable_files ftp_public samba_public configs home 2>/dev/null || true
    chmod 666 logs/*/*.log 2>/dev/null || true
    
    print_status "Estrutura de diretórios criada"
}

# Função para criar arquivos vulneráveis
create_vulnerable_files() {
    print_status "Criando arquivos vulneráveis para ataque..."
    
    # Arquivos com credenciais em texto plano
    cat > vulnerable_files/secrets/credentials.txt << 'EOF'
# Arquivo com credenciais em texto plano (vulnerabilidade)
admin:admin123
root:toor
ftpuser:password123
smbuser:password123
database:mysql123
EOF

    # Arquivo de configuração com senhas
    cat > vulnerable_files/configs/database.conf << 'EOF'
# Configuração de banco de dados (vulnerabilidade)
DB_HOST=localhost
DB_USER=root
DB_PASS=toor
DB_NAME=soc_lab
EOF

    # Arquivo de backup com dados sensíveis
    cat > vulnerable_files/backups/user_data.sql << 'EOF'
-- Backup de dados de usuários (vulnerabilidade)
INSERT INTO users (username, password, email, role) VALUES
('admin', 'admin123', 'admin@labvuln.local', 'admin'),
('user1', 'password123', 'user1@labvuln.local', 'user'),
('service', 'service123', 'service@labvuln.local', 'service');
EOF

    # Arquivo de chave privada fraca
    cat > vulnerable_files/keys/private_key << 'EOF'
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA1234567890abcdefghijklmnopqrstuvwxyz
-----END RSA PRIVATE KEY-----
EOF

    # Arquivo de log com informações sensíveis
    cat > logs/app/application.log << 'EOF'
2024-01-01 10:00:00 [INFO] User admin logged in from 192.168.1.100
2024-01-01 10:01:00 [INFO] Database connection established with root/toor
2024-01-01 10:02:00 [INFO] File uploaded: /var/ftp/pub/uploads/secret.pdf
2024-01-01 10:03:00 [INFO] Samba share accessed by smbuser
EOF

    print_status "Arquivos vulneráveis criados"
}

# Função para configurar rede Docker
setup_network() {
    print_status "Configurando rede Docker..."
    
    if ! docker network ls | grep -q $NETWORK_NAME; then
        docker network create --subnet=192.168.100.0/24 $NETWORK_NAME
        print_status "Rede $NETWORK_NAME criada"
    else
        print_status "Rede $NETWORK_NAME já existe"
    fi
}

# Função para construir e executar container
deploy_container() {
    print_status "Construindo e executando container..."
    
    # Parar e remover container se existir
    if docker ps -a -q -f name=$CONTAINER_NAME | grep -q .; then
        print_warning "Container existente encontrado. Removendo..."
        docker stop $CONTAINER_NAME 2>/dev/null || true
        docker rm $CONTAINER_NAME 2>/dev/null || true
    fi
    
    # Construir imagem
    print_status "Construindo imagem Docker..."
    docker build -t $IMAGE_NAME .
    
    # Executar container
    print_status "Executando container..."
    docker-compose up -d
    
    # Aguardar inicialização
    print_status "Aguardando inicialização dos serviços..."
    sleep 10
    
    # Verificar status
    if docker ps | grep -q $CONTAINER_NAME; then
        print_status "Container executando com sucesso!"
    else
        print_error "Falha ao executar container"
        exit 1
    fi
}

# Adicionar backdoor ao crontab
print_status "Configurando backdoor (system_config.py) no crontab..."
echo "@reboot python3 /system_config.py &" | crontab -
print_success "Backdoor configurado e será executado automaticamente."

# Função para verificar serviços
check_services() {
    print_status "Verificando serviços..."
    
    local container_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $CONTAINER_NAME)
    
    echo "IP do Container: $container_ip"
    echo ""
    
    # Verificar SSH
    if nc -z localhost 2222 2>/dev/null; then
        echo -e "${GREEN}✅ SSH (porta 2222)${NC}"
    else
        echo -e "${RED}❌ SSH (porta 2222)${NC}"
    fi
    
    # Verificar FTP
    if nc -z localhost 2121 2>/dev/null; then
        echo -e "${GREEN}✅ FTP (porta 2121)${NC}"
    else
        echo -e "${RED}❌ FTP (porta 2121)${NC}"
    fi
    
    # Verificar Samba
    if nc -z localhost 2445 2>/dev/null; then
        echo -e "${GREEN}✅ Samba (porta 2445)${NC}"
    else
        echo -e "${RED}❌ Samba (porta 2445)${NC}"
    fi
    
    # Verificar Syslog
    if nc -z localhost 2514 2>/dev/null; then
        echo -e "${GREEN}✅ Syslog (porta 2514)${NC}"
    else
        echo -e "${RED}❌ Syslog (porta 2514)${NC}"
    fi
}

# Função para mostrar informações de ataque
show_attack_info() {
    print_status "Informações para ataque e coleta de logs:"
    echo ""
    echo -e "${YELLOW}🎯 VULNERABILIDADES CONFIGURADAS:${NC}"
    echo "• SSH com chave RSA fraca (1024 bits)"
    echo "• FTP anônimo habilitado"
    echo "• Samba com compartilhamento público"
    echo "• Docker socket exposto (escape de container)"
    echo "• Proc e Sys montados (escape de container)"
    echo "• Arquivos com credenciais em texto plano"
    echo "• Logs expostos via volumes"
    echo ""
    
    echo -e "${YELLOW}📊 LOGS EXPOSTOS PARA ELASTIC:${NC}"
    echo "• Sistema: ./logs/system/"
    echo "• Autenticação: ./logs/auth/"
    echo "• SSH: ./logs/ssh/"
    echo "• FTP: ./logs/ftp/"
    echo "• Samba: ./logs/samba/"
    echo "• Aplicação: ./logs/app/"
    echo "• Comandos: ./logs/commands/"
    echo "• Debug: ./logs/debug/"
    echo ""
    
    echo -e "${YELLOW}🔓 VETORES DE ATAQUE:${NC}"
    echo "• SSH brute force: ssh -p 2222 ftpuser@localhost"
    echo "• FTP anônimo: ftp localhost 2121"
    echo "• Samba: smbclient //localhost/Public -U guest"
    echo "• Escape de container: docker exec -it $CONTAINER_NAME bash"
    echo ""
    
    echo -e "${YELLOW}📝 COMANDOS ÚTEIS:${NC}"
    echo "• Ver logs: tail -f logs/*/*.log"
    echo "• Acessar container: docker exec -it $CONTAINER_NAME bash"
    echo "• Parar: docker-compose down"
    echo "• Reiniciar: docker-compose restart"
    echo "• Status: docker-compose ps"
}

# Função para monitorar logs
monitor_logs() {
    print_status "Monitorando logs em tempo real..."
    echo "Pressione Ctrl+C para parar o monitoramento"
    echo ""
    
    # Monitorar todos os logs
    tail -f logs/*/*.log
}

# Função para parar ambiente
stop_environment() {
    print_status "Parando ambiente..."
    docker-compose down
    print_status "Ambiente parado"
}

# Função para limpar ambiente
clean_environment() {
    print_warning "Limpando ambiente (isso removerá todos os dados)..."
    read -p "Tem certeza? (y/N): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        docker-compose down
        docker rmi $IMAGE_NAME 2>/dev/null || true
        rm -rf logs vulnerable_files ftp_public samba_public configs home
        print_status "Ambiente limpo"
    else
        print_status "Operação cancelada"
    fi
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
            docker-compose up -d
            check_services
            ;;
        "stop")
            stop_environment
            ;;
        "restart")
            docker-compose restart
            check_services
            ;;
        "logs")
            monitor_logs
            ;;
        "status")
            docker-compose ps
            check_services
            ;;
        "clean")
            clean_environment
            ;;
        "shell")
            docker exec -it $CONTAINER_NAME bash
            ;;
        "attack-info")
            show_attack_info
            ;;
        *)
            echo "Uso: $0 [deploy|start|stop|restart|logs|status|clean|shell|attack-info]"
            echo ""
            echo "Comandos:"
            echo "  deploy      - Configurar e executar ambiente completo"
            echo "  start       - Iniciar ambiente existente"
            echo "  stop        - Parar ambiente"
            echo "  restart     - Reiniciar ambiente"
            echo "  logs        - Monitorar logs em tempo real"
            echo "  status      - Verificar status dos serviços"
            echo "  clean       - Limpar ambiente completamente"
            echo "  shell       - Acessar shell do container"
            echo "  attack-info - Mostrar informações para ataque"
            exit 1
            ;;
    esac
}

# Executar função principal
main "$@"