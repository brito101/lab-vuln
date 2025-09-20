#!/bin/bash

# Script de teste de ataques para MAQ-1 (Windows Server via WinRM)
# Executa artefatos PowerShell no Windows Server dentro do container Docker

# Configurações
WINRM_HOST="localhost"
WINRM_PORT="5985"
WINRM_USER="Docker"
WINRM_PASS="admin"
ARTEFATOS_DIR="$(dirname "$0")/artefatos"

# Função para verificar status do container
check_container_status() {
    echo "[INFO] Verificando status do container..."
    
    if ! docker ps | grep -q "maq1-windows"; then
        echo "[ERRO] Container maq1-windows não está rodando!"
        echo "[INFO] Para iniciar o container, execute: ./setup.sh"
        return 1
    fi
    
    local container_uptime=$(docker ps --format "table {{.Names}}\t{{.Status}}" | grep maq1-windows | awk '{print $2,$3}')
    echo "[INFO] Container status: $container_uptime"
    
    # Verificar se o Windows terminou de inicializar primeiro
    if docker logs maq1-windows 2>/dev/null | grep -q "Windows started succesfully"; then
        echo "[INFO] ✅ Windows inicializou com sucesso!"
        echo "[INFO] Verificando se WinRM está pronto..."
        return 0
    fi
    
    # Verificar se está na primeira instalação (só se não iniciou com sucesso)
    if docker logs maq1-windows 2>/dev/null | grep -q "Downloading Windows Server"; then
        echo "[INFO] 🚀 PRIMEIRA INSTALAÇÃO DETECTADA!"
        echo "[INFO] O Windows Server 2022 está sendo baixado e instalado."
        echo "[INFO] Este processo pode demorar 30-60 minutos dependendo da conexão."
        echo "[INFO] 📺 Acompanhe o progresso em: http://localhost:8006"
        echo "[INFO] ⏰ Aguarde a instalação terminar antes de executar ataques."
        return 1
    fi
    
    # Verificar se o container está up há tempo suficiente
    if [[ $container_uptime == *"second"* ]] || [[ $container_uptime == *"minute"* ]]; then
        echo "[WARNING] Container foi iniciado recentemente."
        echo "[INFO] ⏰ Primeira inicialização pode demorar 10-15 minutos para configurar o WinRM."
    fi
    
    return 0
}

# Função para verificar dependências
check_dependencies() {
    if ! command -v python3 &> /dev/null; then
        echo "[ERRO] Python3 não encontrado. Instale com: sudo apt install python3"
        exit 1
    fi
    
    if ! python3 -c "import winrm" 2>/dev/null; then
        echo "[INFO] Instalando biblioteca pywinrm..."
        pip3 install pywinrm || {
            echo "[ERRO] Falha ao instalar pywinrm. Instale manualmente: pip3 install pywinrm"
            exit 1
        }
    fi
}

# Função para testar conectividade WinRM com retry
test_winrm_connection() {
    local max_attempts=3
    local wait_time=10
    
    echo "[INFO] Testando conectividade WinRM..."
    
    for ((i=1; i<=max_attempts; i++)); do
        echo "[INFO] Tentativa $i/$max_attempts..."
        
        # Primeiro teste: verificar se a porta está aberta
        if ! timeout 5 bash -c 'cat < /dev/null > /dev/tcp/localhost/5985' 2>/dev/null; then
            echo "[ERRO] Porta 5985 não está acessível"
            if [[ $i -eq $max_attempts ]]; then
                echo "[INFO] Verifique se o container está rodando: docker ps | grep maq1-windows"
                return 1
            fi
            echo "[INFO] Aguardando ${wait_time}s antes da próxima tentativa..."
            sleep $wait_time
            continue
        fi
        
        # Segundo teste: verificar WinRM via Python
        python3 -c "
import winrm
import sys
try:
    session = winrm.Session('http://$WINRM_HOST:$WINRM_PORT/wsman', 
                           auth=('$WINRM_USER', '$WINRM_PASS'), 
                           transport='basic',
                           operation_timeout_sec=10,
                           read_timeout_sec=15)
    result = session.run_ps('echo \"Conexao OK\"')
    if result.status_code == 0:
        print('[SUCCESS] WinRM conectado com sucesso')
        sys.exit(0)
    else:
        print(f'[ERRO] WinRM retornou código: {result.status_code}')
        sys.exit(1)
except Exception as e:
    print(f'[ERRO] Falha na conexão WinRM: {e}')
    sys.exit(1)
" && return 0
        
        if [[ $i -eq $max_attempts ]]; then
            echo "[ERRO] Container Windows não está acessível via WinRM após $max_attempts tentativas."
            echo ""
            echo "🔍 POSSÍVEIS CAUSAS:"
            echo "  1. 🚀 Windows ainda está sendo instalado/configurado (primeira execução)"
            echo "  2. ⏰ Windows iniciou recentemente e WinRM ainda não está pronto"
            echo "  3. 🔧 WinRM não está configurado (mais provável)"
            echo "  4. 🔑 Credenciais incorretas (Docker:admin)"
            echo ""
            echo "🛠️  SOLUÇÕES:"
            echo "  1. 🔧 Execute: ./setup-winrm.sh (para configurar WinRM)"
            echo "  2. 📺 Acesse http://localhost:8006 para ver o desktop do Windows"
            echo "  3. ⏰ Aguarde mais 10-15 minutos se for primeira instalação"
            echo "  4. 🔄 Teste RDP: conecte em localhost:3389 (Docker:admin)"
            echo ""
            return 1
        fi
        
        echo "[INFO] Aguardando ${wait_time}s antes da próxima tentativa..."
        echo "[INFO] Windows pode estar ainda inicializando... Seja paciente."
        sleep $wait_time
    done
}

# Função para executar script PowerShell
execute_powershell_script() {
    local script_file="$1"
    local script_name=$(basename "$script_file")
    
    if [[ ! -f "$script_file" ]]; then
        echo "[ERRO] Artefato $script_name não encontrado."
        return 1
    fi
    
    echo "[INFO] Disparando $script_name..."
    
    # Lê o conteúdo do script
    local script_content=$(cat "$script_file")
    
    # Scripts que devem rodar em background
    local background_script=""
    if [[ "$script_name" == "persistencia_simulada_win.ps1" ]]; then
        background_script="true"
    fi
    
    # Executa via WinRM
    python3 -c "
import winrm
import sys

script_content = '''$script_content'''

try:
    session = winrm.Session('http://$WINRM_HOST:$WINRM_PORT/wsman', 
                           auth=('$WINRM_USER', '$WINRM_PASS'), 
                           transport='basic',
                           operation_timeout_sec=20,
                           read_timeout_sec=25)
    
    if '$background_script' == 'true':
        # Para scripts de persistência, executa como job
        bg_content = f'''
Start-Job -ScriptBlock {{
{script_content}
}} -Name \"BackgroundAttack\"

Start-Sleep -Seconds 2
Write-Host \"[PERSISTÊNCIA] Serviço iniciado em background\"

\$connection = Test-NetConnection -ComputerName localhost -Port 4444 -InformationLevel Quiet -WarningAction SilentlyContinue
if (\$connection) {{
    Write-Host \"[SUCCESS] Porta 4444 está aberta e escutando\"
}} else {{
    Write-Host \"[INFO] Aguarde alguns segundos para o serviço inicializar\"
}}
'''
        result = session.run_ps(bg_content)
    else:
        result = session.run_ps(script_content)
    
    if result.std_out:
        output = result.std_out.decode('utf-8', errors='replace')
        for line in output.split('\n'):
            if line.strip() and not line.strip().startswith('<') and 'CLIXML' not in line:
                print(line)
    
    sys.exit(result.status_code)
    
except Exception as e:
    print(f'[ERRO] Falha na execução: {e}')
    sys.exit(1)
"
}

# Funções para cada artefato
run_exfiltracao() {
    if test_winrm_connection; then
        execute_powershell_script "$ARTEFATOS_DIR/exfiltracao_simulada_win.ps1"
    fi
}

run_flood_logs() {
    if test_winrm_connection; then
        execute_powershell_script "$ARTEFATOS_DIR/flood_logs_win.ps1"
    fi
}

run_persistencia() {
    if test_winrm_connection; then
        execute_powershell_script "$ARTEFATOS_DIR/persistencia_simulada_win.ps1"
    fi
}

run_portscan() {
    if test_winrm_connection; then
        execute_powershell_script "$ARTEFATOS_DIR/portscan_simulado_win.ps1"
    fi
}

run_ransomware() {
    if test_winrm_connection; then
        execute_powershell_script "$ARTEFATOS_DIR/ransomware_simulado_win.ps1"
    fi
}

run_restore() {
    if test_winrm_connection; then
        execute_powershell_script "$ARTEFATOS_DIR/ransomware_restore_win.ps1"
    fi
}

# Menu principal
artefatos_menu() {
    echo ""; echo "==== Disparar Artefatos Dinâmicos ===="
    echo "1) Exfiltração Simulada"
    echo "2) Flood de Logs"
    echo "3) Persistência Simulada (Bind Shell)"
    echo "4) Portscan Simulado"
    echo "5) Ransomware Simulado"
    echo "6) Restaurar Ransomware"
    echo "0) Sair"
    read -p "Escolha uma opção: " opt
    case $opt in
        1) run_exfiltracao; artefatos_menu ;;
        2) run_flood_logs; artefatos_menu ;;
        3) run_persistencia; artefatos_menu ;;
        4) run_portscan; artefatos_menu ;;
        5) run_ransomware; artefatos_menu ;;
        6) run_restore; artefatos_menu ;;
        0) exit 0 ;;
        *) echo "Opção inválida"; artefatos_menu ;;
    esac
}

# Executar função principal
check_container_status || exit 1
check_dependencies

if [[ "$1" == "artefatos" ]]; then
    artefatos_menu
    exit 0
else
    artefatos_menu
fi
