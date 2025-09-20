#!/bin/bash

# Script de teste de ataques para MAQ-1 (Windows Server via WinRM)
# Executa artefatos PowerShell no Windows Server dentro do container Docker

# Configurações
WINRM_HOST="localhost"
WINRM_PORT="5985"
WINRM_USER="Docker"
WINRM_PASS="admin"
ARTEFATOS_DIR="$(dirname "$0")/artefatos"

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

# Função para testar conectividade WinRM
test_winrm_connection() {
    python3 -c "
import winrm
try:
    session = winrm.Session('http://$WINRM_HOST:$WINRM_PORT/wsman', 
                           auth=('$WINRM_USER', '$WINRM_PASS'), 
                           transport='basic')
    result = session.run_ps('echo \"Conexao OK\"')
    if result.status_code == 0:
        exit(0)
    else:
        exit(1)
except Exception:
    exit(1)
" || {
        echo "[ERRO] Container Windows não está acessível via WinRM."
        echo "[INFO] Verifique se o container está rodando e a porta 5985 está exposta."
        return 1
    }
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
check_dependencies

if [[ "$1" == "artefatos" ]]; then
    artefatos_menu
    exit 0
else
    artefatos_menu
fi
