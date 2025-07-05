#!/bin/bash

# Script de Deploy para Máquina 3 - SOC Lab
# Uso: ./deploy.sh [build|run|stop|restart|logs|clean]

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
    print_status "Construindo imagem Docker..."
    
    if docker build -t $IMAGE_NAME .; then
        print_status "Imagem construída com sucesso!"
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
    
    # Parar container se já estiver rodando
    if docker ps -q -f name=$CONTAINER_NAME | grep -q .; then
        print_warning "Container já está rodando. Parando..."
        docker stop $CONTAINER_NAME
        docker rm $CONTAINER_NAME
    fi
    
    # Executar container
    docker run -d \
        --name $CONTAINER_NAME \
        --network $NETWORK_NAME \
        -p 21:21 \
        -p 22:22 \
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
        print_status "Para acessar o container:"
        echo "  docker exec -it $CONTAINER_NAME bash"
        echo ""
        print_status "Para ver logs:"
        echo "  docker logs -f $CONTAINER_NAME"
        echo ""
        print_status "Para parar:"
        echo "  ./deploy.sh stop"
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
    if docker ps -q -f name=$CONTAINER_NAME | grep -q .; then
        docker stop $CONTAINER_NAME
        docker rm $CONTAINER_NAME
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
        echo "Portas: 21, 22, 139, 445, 514"
    else
        print_warning "Container não está rodando"
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
    echo "Uso: $0 [COMANDO]"
    echo ""
    echo "Comandos disponíveis:"
    echo "  build     - Construir a imagem Docker"
    echo "  run       - Executar o container"
    echo "  stop      - Parar o container"
    echo "  restart   - Reiniciar o container"
    echo "  logs      - Mostrar logs do container"
    echo "  status    - Mostrar status do container"
    echo "  clean     - Limpar tudo (container, imagem, rede)"
    echo "  help      - Mostrar esta ajuda"
    echo ""
    echo "Exemplos:"
    echo "  $0 build"
    echo "  $0 run"
    echo "  $0 logs"
    echo "  $0 stop"
}

# Verificar se Docker está rodando
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        print_error "Docker não está rodando ou não está instalado"
        exit 1
    fi
}

# Main
check_docker

case "${1:-help}" in
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
    status)
        status
        ;;
    clean)
        clean
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        print_error "Comando inválido: $1"
        show_help
        exit 1
        ;;
esac 