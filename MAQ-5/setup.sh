
#!/bin/bash

set -e

CONTAINER_NAME="maq5-web"
IMAGE_NAME="maq5-web"

print_status() { echo -e "[INFO] $1"; }
print_success() { echo -e "[SUCCESS] $1"; }
print_error() { echo -e "[ERROR] $1"; }

deploy_container() {
    print_status "Buildando imagem..."
    docker build -t $IMAGE_NAME .
    print_status "Executando container..."
    docker run -d --name $CONTAINER_NAME -p 8080:80 -p 33060:3306 $IMAGE_NAME
    print_success "Container $CONTAINER_NAME iniciado nas portas 8080 (HTTP) e 33060 (MySQL)"
}

start_container() {
    print_status "Iniciando container..."
    docker start $CONTAINER_NAME || docker run -d --name $CONTAINER_NAME -p 8080:80 -p 33060:3306 $IMAGE_NAME
    print_success "Container $CONTAINER_NAME iniciado."
}

stop_container() {
    print_status "Parando container..."
    docker stop $CONTAINER_NAME || print_error "Container não está rodando."
    print_success "Container parado."
}

restart_container() {
    stop_container
    sleep 2
    start_container
}

logs_container() {
    print_status "Logs do container..."
    docker logs -f $CONTAINER_NAME
}

status_container() {
    print_status "Status do container:"
    docker ps --filter "name=$CONTAINER_NAME" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
}

clean_environment() {
    print_status "Removendo container e imagem..."
    docker stop $CONTAINER_NAME 2>/dev/null || true
    docker rm $CONTAINER_NAME 2>/dev/null || true
    docker rmi $IMAGE_NAME 2>/dev/null || true
    print_success "Ambiente limpo."
}

show_attack_info() {
    echo "\n[INFO] Informações para ataque e coleta de logs:"
    echo "• WordPress vulnerável rodando em http://localhost:8080"
    echo "• Banco MariaDB/MySQL em localhost:33060"
    echo "• Webshell: /var/www/html/webshells/webshell_simulado.php"
    echo "• Artefatos: /usr/local/bin/ (ransomware, flood, exfiltração, portscan, persistência)"
    echo "• Para restaurar arquivos: /usr/local/bin/ransomware_restore_linux.sh"
    echo "• Usuário WordPress: admin / admin123"
}

main() {
    case "${1:-deploy}" in
        "deploy")
            deploy_container
            ;;
        "start")
            start_container
            ;;
        "stop")
            stop_container
            ;;
        "restart")
            restart_container
            ;;
        "logs")
            logs_container
            ;;
        "status")
            status_container
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

main "$@"
