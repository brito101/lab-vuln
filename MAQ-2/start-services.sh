#!/bin/bash

# Script de inicialização dos serviços - MAQ-2
# Este script inicia todos os serviços necessários para o ambiente Laravel

set -e

# Função para logging
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Função para aguardar serviço
wait_for_service() {
    local service_name=$1
    local service_port=$2
    local max_attempts=30
    local attempt=1
    
    log_message "Aguardando $service_name na porta $service_port..."
    
    while [ $attempt -le $max_attempts ]; do
        if nc -z localhost $service_port 2>/dev/null; then
            log_message "$service_name está rodando na porta $service_port"
            return 0
        fi
        
        log_message "Tentativa $attempt/$max_attempts - $service_name ainda não está disponível"
        sleep 2
        attempt=$((attempt + 1))
    done
    
    log_message "ERRO: $service_name não iniciou após $max_attempts tentativas"
    return 1
}

# Iniciar rsyslog
log_message "Iniciando rsyslog..."
service rsyslog start || true
sleep 2

# Iniciar PHP-FPM
log_message "Iniciando PHP-FPM..."
service php8.1-fpm start || true
sleep 2

# Iniciar Nginx
log_message "Iniciando Nginx..."
service nginx start || true
sleep 2

# Verificar se os serviços estão rodando
log_message "Verificando status dos serviços..."

# Verificar PHP-FPM
if pgrep -f "php-fpm" > /dev/null; then
    log_message "✅ PHP-FPM está rodando"
else
    log_message "❌ PHP-FPM não está rodando"
fi

# Verificar Nginx
if pgrep -f "nginx" > /dev/null; then
    log_message "✅ Nginx está rodando"
else
    log_message "❌ Nginx não está rodando"
fi

# Verificar rsyslog
if pgrep -f "rsyslog" > /dev/null; then
    log_message "✅ rsyslog está rodando"
else
    log_message "❌ rsyslog não está rodando"
fi

# Configurar Laravel se necessário
if [ -f "/var/www/html/artisan" ]; then
    log_message "Configurando Laravel..."
    
    cd /var/www/html
    
    # Gerar chave da aplicação se não existir
    if [ ! -f ".env" ]; then
        log_message "Criando arquivo .env..."
        cp .env.example .env 2>/dev/null || {
            cat > .env << 'EOF'
APP_NAME=Laravel
APP_ENV=local
APP_KEY=base64:VULNERABLE_KEY_FOR_TRAINING_ONLY
APP_DEBUG=true
APP_URL=http://localhost

LOG_CHANNEL=stack
LOG_DEPRECATIONS_CHANNEL=null
LOG_LEVEL=debug

DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=sail
DB_PASSWORD=password

BROADCAST_DRIVER=log
CACHE_DRIVER=file
FILESYSTEM_DISK=local
QUEUE_CONNECTION=sync
SESSION_DRIVER=file
SESSION_LIFETIME=120

MEMCACHED_HOST=127.0.0.1

REDIS_HOST=redis
REDIS_PASSWORD=null
REDIS_PORT=6379

MAIL_MAILER=log
MAIL_HOST=mailpit
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS="hello@example.com"
MAIL_FROM_NAME="${APP_NAME}"

AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_DEFAULT_REGION=us-east-1
AWS_BUCKET=
AWS_USE_PATH_STYLE_ENDPOINT=false

PUSHER_APP_ID=
PUSHER_APP_KEY=
PUSHER_APP_SECRET=
PUSHER_HOST=
PUSHER_PORT=443
PUSHER_SCHEME=https
PUSHER_APP_CLUSTER=mt1

VITE_APP_NAME="${APP_NAME}"
VITE_PUSHER_APP_KEY="${PUSHER_APP_KEY}"
VITE_PUSHER_HOST="${PUSHER_HOST}"
VITE_PUSHER_PORT="${PUSHER_PORT}"
VITE_PUSHER_SCHEME="${PUSHER_SCHEME}"
VITE_PUSHER_APP_CLUSTER="${PUSHER_APP_CLUSTER}"
EOF
        }
    fi
    
    # Configurar permissões vulneráveis intencionalmente
    log_message "Configurando permissões vulneráveis..."
    chmod -R 777 storage bootstrap/cache
    chown -R www-data:www-data storage bootstrap/cache
    
    # Limpar caches
    log_message "Limpando caches..."
    php artisan config:clear 2>/dev/null || true
    php artisan cache:clear 2>/dev/null || true
    php artisan view:clear 2>/dev/null || true
    php artisan route:clear 2>/dev/null || true
    
    log_message "✅ Laravel configurado"
else
    log_message "⚠️ Aplicação Laravel não encontrada em /var/www/html"
fi

# Criar arquivos de teste para ataques
log_message "Criando arquivos de teste para ataques..."

# Arquivo com credenciais (vulnerabilidade)
cat > /opt/vulnerable_files/credentials.txt << 'EOF'
# CREDENCIAIS DE TESTE - NÃO USAR EM PRODUÇÃO
DB_HOST=mysql
DB_USER=sail
DB_PASSWORD=password
DB_NAME=laravel

ADMIN_EMAIL=admin@estagio.com
ADMIN_PASSWORD=12345678

PROGRAMADOR_EMAIL=programador@estagio.com
PROGRAMADOR_PASSWORD=12345678

# Chaves de API (fictícias)
STRIPE_KEY=sk_test_vulnerable_key_123
AWS_ACCESS_KEY=AKIAVULNERABLE123
AWS_SECRET_KEY=vulnerable_secret_key_456
EOF

# Arquivo de configuração (vulnerabilidade)
cat > /opt/vulnerable_files/config.conf << 'EOF'
# CONFIGURAÇÃO DE TESTE - VULNERÁVEL
DEBUG_MODE=true
LOG_LEVEL=debug
SHOW_ERRORS=true
ALLOW_FILE_UPLOADS=true
MAX_FILE_SIZE=100MB
ALLOW_REMOTE_INCLUDES=true
ALLOW_URL_FOPEN=true
ALLOW_URL_INCLUDE=true

# Configurações de segurança (intencionalmente fracas)
ENABLE_CSRF=false
ENABLE_XSS_PROTECTION=false
ENABLE_SQL_INJECTION_PROTECTION=false
ENABLE_FILE_UPLOAD_VALIDATION=false
EOF

# Arquivo de backup (vulnerabilidade)
cat > /opt/vulnerable_files/backup.sql << 'EOF'
-- BACKUP DE TESTE - VULNERÁVEL
-- Este arquivo contém dados fictícios para treinamento

USE laravel;

-- Tabela de usuários
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('admin', 'programador', 'franquiado', 'estagiario') DEFAULT 'estagiario',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Inserir usuários de teste
INSERT INTO users (name, email, password, role) VALUES
('Administrador', 'admin@estagio.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin'),
('Programador', 'programador@estagio.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'programador'),
('Franquiado 1', 'franquia1@estagio.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'franquiado'),
('Estagiário', 'estagiario@estagio.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'estagiario');
EOF

# Configurar permissões
chmod 666 /opt/vulnerable_files/*
chmod 666 /var/log/*/*.log

log_message "✅ Arquivos de teste criados"

# Mostrar informações do ambiente
show_info() {
    echo
    echo "=========================================="
    echo "  MAQ-2 - AMBIENTE LARAVEL VULNERÁVEL"
    echo "=========================================="
    echo
    echo "🌐 SERVIÇOS DISPONÍVEIS:"
    echo "   • Web (Laravel): http://localhost:8080"
    echo "   • MySQL: localhost:8081"
    echo "   • Redis: localhost:8082"
    echo "   • Meilisearch: localhost:8083"
    echo "   • Mailpit SMTP: localhost:8084"
    echo "   • Mailpit Dashboard: http://localhost:8085"
    echo "   • Selenium: localhost:8086"
    echo "   • Syslog: localhost:8087"
    echo
    echo "🔓 VULNERABILIDADES CONFIGURADAS:"
    echo "   • Upload de arquivos sem validação"
    echo "   • Arquivo .env exposto"
    echo "   • Debug mode habilitado"
    echo "   • Permissões 777 em storage"
    echo "   • LFI (Local File Inclusion)"
    echo "   • Docker socket exposto"
    echo "   • Container privilegiado"
    echo "   • Capabilities perigosas"
    echo
    echo "📊 LOGS EXPOSTOS PARA ELASTIC:"
    echo "   • Sistema: ./logs/system/"
    echo "   • Nginx: ./logs/nginx/"
    echo "   • PHP: ./logs/php/"
    echo "   • Laravel: ./logs/laravel/"
    echo "   • MySQL: ./logs/mysql/"
    echo "   • Redis: ./logs/redis/"
    echo "   • Aplicação: ./logs/app/"
    echo
    echo "🎯 VETORES DE ATAQUE:"
    echo "   • Upload de webshells PHP"
    echo "   • Acesso direto ao .env"
    echo "   • LFI via visualizador de arquivos"
    echo "   • Escape de container via Docker"
    echo "   • Manipulação de permissões"
    echo
    echo "📝 COMANDOS ÚTEIS:"
    echo "   • Ver logs: tail -f logs/*/*.log"
    echo "   • Acessar container: docker exec -it maquina2-soc bash"
    echo "   • Parar: docker-compose down"
    echo "   • Reiniciar: docker-compose restart"
    echo "   • Status: docker-compose ps"
    echo
}

# Mostrar informações
show_info

# Manter o script rodando para monitorar logs
log_message "Monitorando logs... (Ctrl+C para sair)"
tail -f /var/log/nginx/access.log /var/log/nginx/error.log /var/log/laravel/laravel.log /var/log/app/application.log
