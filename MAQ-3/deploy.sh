#!/bin/bash

# Script de Deploy Otimizado para Máquina 3 - SOC Lab
# Uso: ./deploy-optimized.sh [build|run|stop|restart|logs|clean|status]

set -e

IMAGE_NAME="maquina3-soc"
CONTAINER_NAME="maquina3"
NETWORK_NAME="soc-network"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para imprimir mensagens coloridas
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}  SOC Lab - Máquina 3 Deploy${NC}"
    echo -e "${BLUE}================================${NC}"
}

# Função para criar rede Docker
create_network() {
    if ! docker network ls | grep -q $NETWORK_NAME; then
        print_status "Criando rede Docker: $NETWORK_NAME"
        docker network create $NETWORK_NAME
    else
        print_status "Rede $NETWORK_NAME já existe"
    fi
}

# Função para construir a imagem
build() {
    print_header
    print_status "Construindo imagem Docker otimizada..."
    
    if docker build -t $IMAGE_NAME .; then
        print_status "Imagem construída com sucesso!"
        print_status "Todas as vulnerabilidades foram configuradas durante o build"
    else
        print_error "Erro ao construir imagem"
        exit 1
    fi
}

# Função para executar o container
run() {
    print_header
    print_status "Iniciando container..."
    
    # Verificar se a imagem existe
    if ! docker images | grep -q $IMAGE_NAME; then
        print_warning "Imagem não encontrada. Construindo..."
        build
    fi
    
    # Criar rede se não existir
    create_network
    
    # Parar e remover container se já existir
    if docker ps -a -q -f name=$CONTAINER_NAME | grep -q .; then
        print_warning "Container já existe. Removendo..."
        docker stop $CONTAINER_NAME 2>/dev/null || true
        docker rm $CONTAINER_NAME 2>/dev/null || true
    fi
    
    # Verificar se as portas estão em uso
    print_status "Verificando portas..."
    
    # Verificar porta SSH
    if ss -tuln | grep -q ":22 "; then
        print_warning "Porta 22 já está em uso. Usando porta 2222 para SSH"
        SSH_PORT=2222
    else
        SSH_PORT=22
    fi
    
    # Verificar porta FTP
    if ss -tuln | grep -q ":21 "; then
        print_warning "Porta 21 já está em uso. Usando porta 2121 para FTP"
        FTP_PORT=2121
    else
        FTP_PORT=21
    fi
    
    # Verificar se as portas alternativas também estão em uso
    if [ "$SSH_PORT" = "2222" ] && ss -tuln | grep -q ":2222 "; then
        print_error "Porta 2222 também está em uso. Parando..."
        exit 1
    fi
    
    if [ "$FTP_PORT" = "2121" ] && ss -tuln | grep -q ":2121 "; then
        print_error "Porta 2121 também está em uso. Parando..."
        exit 1
    fi
    
    print_status "Portas selecionadas: SSH=$SSH_PORT, FTP=$FTP_PORT"
    
    # Executar container com portas verificadas
    docker run -d \
        --name $CONTAINER_NAME \
        --network $NETWORK_NAME \
        -p $FTP_PORT:21 \
        -p $SSH_PORT:22 \
        -p 139:139 \
        -p 445:445 \
        -p 514:514 \
        --hostname $CONTAINER_NAME \
        $IMAGE_NAME
    
    if [ $? -eq 0 ]; then
        print_status "Container iniciado com sucesso!"
        print_status "Container ID: $(docker ps -q -f name=$CONTAINER_NAME)"
        print_status "IP: $(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $CONTAINER_NAME)"
        echo ""
        print_status "SERVIÇOS DISPONÍVEIS:"
        echo "  SSH:     ssh ftpuser@localhost -p $SSH_PORT (password: password123)"
        echo "  SSH:     ssh root@localhost -p $SSH_PORT (password: toor)"
        echo "  FTP:     ftp localhost -p $FTP_PORT (anonymous)"
        echo "  Samba:   smbclient -L //localhost -U anonymous"
        echo ""
        print_status "VULNERABILIDADES CONFIGURADAS:"
        echo "  - SSH com chave RSA 1024 bits (fraca)"
        echo "  - FTP anônimo habilitado"
        echo "  - Samba com compartilhamento público"
        echo "  - Syslog mal configurado"
        echo ""
        print_status "Para acessar o container:"
        echo "  docker exec -it $CONTAINER_NAME bash"
        echo ""
        print_status "Para ver logs:"
        echo "  docker logs -f $CONTAINER_NAME"
        echo ""
        print_status "Para parar:"
        echo "  ./deploy-optimized.sh stop"
        echo ""
        print_status "✅ Container está rodando em background!"
        print_status "💡 Use 'docker logs -f $CONTAINER_NAME' para acompanhar os logs"
        print_status "💡 Use './deploy-optimized.sh status' para verificar o status"
    else
        print_error "Erro ao iniciar container"
        exit 1
    fi
}

# Função para parar o container
stop() {
    print_header
    print_status "Parando container..."
    
    if docker ps -q -f name=$CONTAINER_NAME | grep -q .; then
        docker stop $CONTAINER_NAME
        docker rm $CONTAINER_NAME
        print_status "Container parado e removido"
    else
        print_warning "Container não está rodando"
    fi
}

# Função para reiniciar o container
restart() {
    print_header
    print_status "Reiniciando container..."
    stop
    sleep 2
    run
}

# Função para mostrar logs
logs() {
    print_header
    print_status "Mostrando logs do container..."
    
    if docker ps -q -f name=$CONTAINER_NAME | grep -q .; then
        docker logs -f $CONTAINER_NAME
    else
        print_error "Container não está rodando"
        exit 1
    fi
}

# Função para limpar tudo
clean() {
    print_header
    print_status "Limpando tudo..."
    
    # Parar e remover container
    if docker ps -a -q -f name=$CONTAINER_NAME | grep -q .; then
        docker stop $CONTAINER_NAME 2>/dev/null || true
        docker rm $CONTAINER_NAME 2>/dev/null || true
    fi
    
    # Remover imagem
    if docker images | grep -q $IMAGE_NAME; then
        docker rmi $IMAGE_NAME
    fi
    
    # Remover rede (se não houver outros containers)
    if docker network ls | grep -q $NETWORK_NAME; then
        if ! docker network inspect $NETWORK_NAME | grep -q "Containers"; then
            docker network rm $NETWORK_NAME
        fi
    fi
    
    # Limpeza adicional (opcional)
    if [ "$1" = "full" ]; then
        print_status "Executando limpeza completa..."
        docker system prune -f
        docker volume prune -f
    fi
    
    print_status "Limpeza concluída!"
}

    # Função para mostrar status
status() {
    print_header
    print_status "Status do container:"
    
    if docker ps -q -f name=$CONTAINER_NAME | grep -q .; then
        print_status "Container está rodando"
        echo "Container ID: $(docker ps -q -f name=$CONTAINER_NAME)"
        echo "IP: $(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $CONTAINER_NAME)"
        
        # Determinar portas em uso
        if ss -tuln | grep -q ":22 "; then
            SSH_PORT=2222
        else
            SSH_PORT=22
        fi
        
        if ss -tuln | grep -q ":21 "; then
            FTP_PORT=2121
        else
            FTP_PORT=21
        fi
        
        echo "Portas: $FTP_PORT (FTP), $SSH_PORT (SSH), 139, 445, 514, 30000-31000"
        echo ""
        print_status "Teste de conectividade:"
        echo "SSH:   nc -zv localhost $SSH_PORT"
        echo "FTP:   nc -zv localhost $FTP_PORT"
        echo "Samba: nc -zv localhost 445"
        echo ""
        print_status "Últimos logs do container:"
        docker logs --tail 10 $CONTAINER_NAME
    else
        print_warning "Container não está rodando"
        echo ""
        print_status "Containers existentes:"
        docker ps -a | grep $CONTAINER_NAME || echo "Nenhum container encontrado"
    fi
    
    echo ""
    print_status "Status da imagem:"
    if docker images | grep -q $IMAGE_NAME; then
        docker images | grep $IMAGE_NAME
    else
        print_warning "Imagem não encontrada"
    fi
}

# Função para mostrar ajuda
show_help() {
    print_header
    echo "Uso: $0 [comando]"
    echo ""
    echo "Comandos disponíveis:"
    echo "  build    - Construir imagem Docker"
    echo "  run      - Iniciar container"
    echo "  stop     - Parar container"
    echo "  restart  - Reiniciar container"
    echo "  logs     - Mostrar logs"
    echo "  clean    - Limpar tudo (container, imagem, rede)"
    echo "  clean full - Limpeza completa + docker system prune"
    echo "  status   - Mostrar status"
    echo "  help     - Mostrar esta ajuda"
    echo ""
    echo "Exemplo:"
    echo "  $0 build && $0 run"
}

# Verificar argumentos
if [ $# -eq 0 ]; then
    show_help
    exit 1
fi

# Processar comando
case "$1" in
    build)
        build
        ;;
    run)
        run
        ;;
    stop)
        stop
        ;;
    restart)
        restart
        ;;
    logs)
        logs
        ;;
    clean)
        if [ "$2" = "full" ]; then
            clean full
        else
            clean
        fi
        ;;
    status)
        status
        ;;
    help)
        show_help
        ;;
    *)
        print_error "Comando inválido: $1"
        show_help
        exit 1
        ;;
esac 