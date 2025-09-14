#!/bin/bash
# attack-test.sh - Menu para disparar artefatos dinâmicos (Windows Server via Docker)
print_status() { echo -e "[INFO] $1"; }
CONTAINER_NAME="maq1-windows"
run_ransomware() { print_status "Disparando ransomware_simulado_win.ps1..."; docker exec -it $CONTAINER_NAME powershell.exe -File C:\artefatos\ransomware_simulado_win.ps1; }
run_restore() { print_status "Disparando ransomware_restore_win.ps1..."; docker exec -it $CONTAINER_NAME powershell.exe -File C:\artefatos\ransomware_restore_win.ps1; }
run_flood_logs() { print_status "Disparando flood_logs_win.ps1..."; docker exec -it $CONTAINER_NAME powershell.exe -File C:\artefatos\flood_logs_win.ps1; }
run_exfiltracao() { print_status "Disparando exfiltracao_simulada_win.ps1..."; docker exec -it $CONTAINER_NAME powershell.exe -File C:\artefatos\exfiltracao_simulada_win.ps1; }
run_portscan() { print_status "Disparando portscan_simulado_win.ps1..."; docker exec -it $CONTAINER_NAME powershell.exe -File C:\artefatos\portscan_simulado_win.ps1; }
run_persistencia() { print_status "Disparando persistencia_simulada_win.ps1..."; docker exec -it $CONTAINER_NAME powershell.exe -File C:\artefatos\persistencia_simulada_win.ps1; }
run_webshell() { print_status "Webshell disponível em C:\inetpub\wwwroot\webshell_simulado_win.aspx"; }
run_c2_agent() {
    print_status "Executando agente de C2 (svcmon.py)..."
    docker exec -it $CONTAINER_NAME python.exe C:\artefatos\svcmon.py
}
artefatos_menu() {
    echo ""; echo "==== Disparar Artefatos Dinâmicos (Windows) ===="
    echo "1) Ransomware Simulado"
    echo "2) Restore Ransomware"
    echo "3) Flood de Logs"
    echo "4) Exfiltração Simulada"
    echo "5) Portscan Simulado"
    echo "6) Persistência Simulada"
    echo "7) Webshell ASPX"
    echo "8) Executar agente de C2 (svcmon)"
    echo "0) Sair"
    read -p "Escolha uma opção: " opt
    case $opt in
        1) run_ransomware ;;
        2) run_restore ;;
        3) run_flood_logs ;;
        4) run_exfiltracao ;;
        5) run_portscan ;;
        6) run_persistencia ;;
        7) run_webshell ;;
        8) run_c2_agent ;;
        0) exit 0 ;;
        *) echo "Opção inválida" ;;
    esac
}
if [[ -z "$1" || "$1" == "artefatos" ]]; then
    artefatos_menu
    exit 0
fi
