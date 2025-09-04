#!/bin/bash

# Tsunami Traffic Simulator - Script Bash Wrapper
# Facilita a execução do simulador de tráfego para laboratórios de segurança

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Banner
print_banner() {
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════════════════════════╗"
    echo "║                    🌊 TSUNAMI TRAFFIC SIMULATOR 🌊                          ║"
    echo "║              Simulador de Tráfego para Laboratórios de Segurança            ║"
    echo "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Função de ajuda
show_help() {
    print_banner
    echo -e "${YELLOW}Uso:${NC}"
    echo "  $0 [OPÇÕES]"
    echo ""
    echo -e "${YELLOW}Opções:${NC}"
    echo "  -i, --ips IPs              IP(s) alvo (separados por vírgula)"
    echo "  -d, --duration SEGUNDOS    Duração da simulação em segundos"
    echo "  -p, --packets QUANTIDADE   Número de pacotes por serviço (padrão: 100)"
    echo "  -l, --lab LABORATÓRIO      Tipo de laboratório (MAQ-1, MAQ-2, MAQ-3, MAQ-4)"
    echo "  -h, --help                 Mostra esta ajuda"
    echo "  --install                  Instala dependências necessárias"
    echo "  --status                   Mostra status dos laboratórios"
    echo ""
    echo -e "${YELLOW}Exemplos:${NC}"
    echo "  $0 -i 192.168.1.100 -d 60 -p 100"
    echo "  $0 -i 192.168.1.100,192.168.1.101 -d 120 -p 50 -l MAQ-1"
    echo "  $0 -i 192.168.1.100 -d 300 -p 200 -l MAQ-4"
    echo ""
    echo -e "${YELLOW}Laboratórios disponíveis:${NC}"
    echo "  ${GREEN}MAQ-1${NC}: Windows Server 2022 Domain Controller"
    echo "  ${GREEN}MAQ-2${NC}: Laravel Web Application"
    echo "  ${GREEN}MAQ-3${NC}: Linux Infrastructure"
    echo "  ${GREEN}MAQ-4${NC}: Zimbra CVE-2024-45519"
    echo ""
    echo -e "${YELLOW}Nota:${NC} Este script precisa ser executado com privilégios de root"
}

# Verifica se é root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo -e "${RED}Erro: Este script precisa ser executado com privilégios de root${NC}"
        echo "Use: sudo $0 ..."
        exit 1
    fi
}

# Instala dependências
install_dependencies() {
    echo -e "${BLUE}Instalando dependências...${NC}"
    
    # Atualiza lista de pacotes
    apt update
    
    # Instala Python3 e pip se não estiverem instalados
    if ! command -v python3 &> /dev/null; then
        echo -e "${YELLOW}Instalando Python3...${NC}"
        apt install -y python3 python3-pip
    fi
    
    # Instala Scapy
    echo -e "${YELLOW}Instalando Scapy...${NC}"
    pip3 install scapy
    
    # Instala outras dependências úteis
    echo -e "${YELLOW}Instalando dependências adicionais...${NC}"
    apt install -y python3-netifaces python3-psutil
    
    echo -e "${GREEN}✓ Dependências instaladas com sucesso!${NC}"
}

# Verifica status dos laboratórios
check_lab_status() {
    echo -e "${BLUE}Verificando status dos laboratórios...${NC}"
    echo ""
    
    # MAQ-1
    echo -e "${CYAN}MAQ-1 (Windows Server 2022 DC):${NC}"
    if docker ps | grep -q "maq1"; then
        echo -e "  ${GREEN}✓ Ativo${NC}"
        echo -e "  Portas: 3389 (RDP), 53 (DNS), 389 (LDAP), 445 (SMB), 8006 (Web)"
    else
        echo -e "  ${RED}✗ Inativo${NC}"
    fi
    echo ""
    
    # MAQ-2
    echo -e "${CYAN}MAQ-2 (Laravel Web App):${NC}"
    if docker ps | grep -q "maq2"; then
        echo -e "  ${GREEN}✓ Ativo${NC}"
        echo -e "  Portas: 80 (HTTP), 3306 (MySQL), 6379 (Redis)"
    else
        echo -e "  ${RED}✗ Inativo${NC}"
    fi
    echo ""
    
    # MAQ-3
    echo -e "${CYAN}MAQ-3 (Linux Infrastructure):${NC}"
    if docker ps | grep -q "maq3"; then
        echo -e "  ${GREEN}✓ Ativo${NC}"
        echo -e "  Portas: 2222 (SSH), 2121 (FTP), 139/445 (SMB), 8080 (HTTP)"
    else
        echo -e "  ${RED}✗ Inativo${NC}"
    fi
    echo ""
    
    # MAQ-4
    echo -e "${CYAN}MAQ-4 (Zimbra CVE-2024-45519):${NC}"
    if docker ps | grep -q "maq4"; then
        echo -e "  ${GREEN}✓ Ativo${NC}"
        echo -e "  Portas: 25 (SMTP), 80/443 (HTTP/HTTPS), 22 (SSH), 7071 (Admin)"
    else
        echo -e "  ${RED}✗ Inativo${NC}"
    fi
    echo ""
}

# Valida argumentos
validate_args() {
    if [[ -z "$TARGET_IPS" ]]; then
        echo -e "${RED}Erro: IPs alvo são obrigatórios${NC}"
        echo "Use -i ou --ips para especificar os IPs"
        exit 1
    fi
    
    if [[ -z "$DURATION" ]]; then
        echo -e "${RED}Erro: Duração é obrigatória${NC}"
        echo "Use -d ou --duration para especificar a duração em segundos"
        exit 1
    fi
    
    if [[ "$DURATION" -lt 1 ]]; then
        echo -e "${RED}Erro: Duração deve ser maior que 0${NC}"
        exit 1
    fi
    
    if [[ "$PACKETS" -lt 1 ]]; then
        echo -e "${RED}Erro: Número de pacotes deve ser maior que 0${NC}"
        exit 1
    fi
}

# Função principal
main() {
    # Parse de argumentos
    while [[ $# -gt 0 ]]; do
        case $1 in
            -i|--ips)
                TARGET_IPS="$2"
                shift 2
                ;;
            -d|--duration)
                DURATION="$2"
                shift 2
                ;;
            -p|--packets)
                PACKETS="$2"
                shift 2
                ;;
            -l|--lab)
                LAB="$2"
                shift 2
                ;;
            --install)
                check_root
                install_dependencies
                exit 0
                ;;
            --status)
                check_lab_status
                exit 0
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                echo -e "${RED}Opção desconhecida: $1${NC}"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Validações
    check_root
    validate_args
    
    # Verifica se o script Python existe
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    PYTHON_SCRIPT="$SCRIPT_DIR/tsunami_traffic_simulator.py"
    
    if [[ ! -f "$PYTHON_SCRIPT" ]]; then
        echo -e "${RED}Erro: Script Python não encontrado: $PYTHON_SCRIPT${NC}"
        exit 1
    fi
    
    # Verifica se Scapy está instalado
    if ! python3 -c "import scapy" 2>/dev/null; then
        echo -e "${YELLOW}Scapy não encontrado. Instalando...${NC}"
        pip3 install scapy
    fi
    
    # Constrói comando Python
    PYTHON_CMD="python3 $PYTHON_SCRIPT -i $TARGET_IPS -d $DURATION -p $PACKETS"
    
    if [[ -n "$LAB" ]]; then
        PYTHON_CMD="$PYTHON_CMD -l $LAB"
    fi
    
    # Executa o simulador
    print_banner
    echo -e "${GREEN}Executando simulação...${NC}"
    echo -e "${BLUE}Comando: $PYTHON_CMD${NC}"
    echo ""
    
    eval $PYTHON_CMD
}

# Executa função principal com todos os argumentos
main "$@"
