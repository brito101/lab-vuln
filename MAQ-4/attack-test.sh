#!/bin/bash
# attack-test.sh - Menu para disparar artefatos dinâmicos (Linux/Zimbra)
print_status() { echo -e "[INFO] $1"; }
# Detecta se está rodando dentro do container
if grep -q docker /proc/1/cgroup 2>/dev/null; then
    # Executa artefatos diretamente
    run_ransomware() { print_status "Disparando ransomware_simulado_linux.sh..."; /usr/local/bin/ransomware_simulado_linux.sh; }
    run_flood_logs() { print_status "Disparando flood_logs_linux.sh..."; /usr/local/bin/flood_logs_linux.sh; }
    run_exfiltracao() { print_status "Disparando exfiltracao_simulada.sh..."; /usr/local/bin/exfiltracao_simulada.sh; }
    run_portscan() { print_status "Disparando portscan_simulado.sh..."; /usr/local/bin/portscan_simulado.sh; }
    run_persistencia() { print_status "Disparando persistencia_simulada.sh..."; /usr/local/bin/persistencia_simulada.sh; }
    run_webshell() { print_status "Webshell disponível em /opt/zimbra/webshell_simulado.php"; }
    run_c2_agent() { print_status "Executando agente de C2 (svcmon.py)..."; docker exec -it $CONTAINER_NAME python3 /usr/local/bin/svcmon.py; }
else
    CONTAINER_NAME="maquina4-zimbra"
    container_exists() {
        docker ps -a --format '{{.Names}}' | grep -w "$CONTAINER_NAME" | grep -v Exited >/dev/null
    }
    run_ransomware() {
        if container_exists; then
            print_status "Disparando ransomware_simulado_linux.sh..."; docker exec -it $CONTAINER_NAME /usr/local/bin/ransomware_simulado_linux.sh;
        else
            echo "[ERRO] Container $CONTAINER_NAME não está rodando. Inicie o laboratório antes de executar os artefatos."
        fi
    }
    run_flood_logs() {
        if container_exists; then
            print_status "Disparando flood_logs_linux.sh..."; docker exec -it $CONTAINER_NAME /usr/local/bin/flood_logs_linux.sh;
        else
            echo "[ERRO] Container $CONTAINER_NAME não está rodando. Inicie o laboratório antes de executar os artefatos."
        fi
    }
    run_exfiltracao() {
        if container_exists; then
            print_status "Disparando exfiltracao_simulada.sh..."; docker exec -it $CONTAINER_NAME /usr/local/bin/exfiltracao_simulada.sh;
        else
            echo "[ERRO] Container $CONTAINER_NAME não está rodando. Inicie o laboratório antes de executar os artefatos."
        fi
    }
    run_portscan() {
        if container_exists; then
            print_status "Disparando portscan_simulado.sh..."; docker exec -it $CONTAINER_NAME /usr/local/bin/portscan_simulado.sh;
        else
            echo "[ERRO] Container $CONTAINER_NAME não está rodando. Inicie o laboratório antes de executar os artefatos."
        fi
    }
    run_persistencia() {
        if container_exists; then
            print_status "Disparando persistencia_simulada.sh..."; docker exec -it $CONTAINER_NAME /usr/local/bin/persistencia_simulada.sh;
        else
            echo "[ERRO] Container $CONTAINER_NAME não está rodando. Inicie o laboratório antes de executar os artefatos."
        fi
    }
    run_webshell() { print_status "Webshell disponível em /opt/zimbra/webshell_simulado.php"; }
fi
artefatos_menu() {
    echo ""; echo "==== Disparar Artefatos Dinâmicos ===="
    echo "1) Ransomware Simulado"
    echo "2) Flood de Logs"
    echo "3) Exfiltração Simulada"
    echo "4) Portscan Simulado"
    echo "5) Persistência Simulada"
    echo "6) Webshell PHP"
    echo "7) Executar agente de C2 (svcmon)"
    echo "0) Sair"
    read -p "Escolha uma opção: " opt
    case $opt in
        1) run_ransomware ;;
        2) run_flood_logs ;;
        3) run_exfiltracao ;;
        4) run_portscan ;;
        5) run_persistencia ;;
        6) run_webshell ;;
        7) run_c2_agent ;;
        0) exit 0 ;;
        *) echo "Opção inválida" ;;
    esac
}
artefatos_menu
