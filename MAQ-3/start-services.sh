#!/bin/bash

echo "=== Iniciando MAQ-3 - Servidor Linux Vulnerável ==="

# Função para log
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a /var/log/app/application.log
}

# Iniciar rsyslog
log_message "Iniciando rsyslog..."
rsyslogd -n &
sleep 2

# Iniciar Samba
log_message "Iniciando Samba..."
smbd -D
nmbd -D
sleep 2

# Iniciar vsftpd
log_message "Iniciando vsftpd..."
vsftpd /etc/vsftpd.conf &
sleep 2

# Iniciar SSH
log_message "Iniciando SSH..."
/usr/sbin/sshd -D &
sleep 2

# Configurar logging de comandos (captura de ataques)
log_message "Configurando captura de comandos..."

# Capturar comandos SSH
echo "session required pam_tty_audit.so enable=* log_passwd" >> /etc/pam.d/sshd

# Capturar comandos de todos os usuários
echo 'export PROMPT_COMMAND="history -a; echo \"\$(date '+%Y-%m-%d %H:%M:%S') - \$(whoami)@\$(hostname):\$(pwd) - \$(history 1 | sed \"s/^[ ]*[0-9]\+[ ]*//\")\" >> /var/log/commands.log"' >> /etc/bash.bashrc

# Capturar tentativas de login SSH
echo "auth,authpriv.* /var/log/ssh_credentials.log" >> /etc/rsyslog.conf

# Capturar logs de debug
echo "*.debug /var/log/debug.log" >> /etc/rsyslog.conf

# Reiniciar rsyslog para aplicar configurações
pkill rsyslogd
rsyslogd -n &

# Criar arquivos de teste para ataque
log_message "Criando arquivos de teste para ataque..."

# Arquivo com credenciais em texto plano
cat > /var/ftp/pub/credentials.txt << 'EOF'
# Credenciais do sistema (vulnerabilidade)
admin:admin123
root:toor
ftpuser:password123
smbuser:password123
EOF

# Arquivo de configuração sensível
cat > /var/samba/public/config.conf << 'EOF'
# Configuração sensível (vulnerabilidade)
DB_HOST=localhost
DB_USER=root
DB_PASS=toor
API_KEY=sk-1234567890abcdef
SECRET_TOKEN=secret123
EOF

# Arquivo de backup com dados
cat > /var/samba/public/backup.sql << 'EOF'
-- Backup de dados (vulnerabilidade)
INSERT INTO users (username, password, email) VALUES
('admin', 'admin123', 'admin@labvuln.local'),
('user1', 'password123', 'user1@labvuln.local');
EOF

# Definir permissões
chmod 666 /var/ftp/pub/credentials.txt
chmod 666 /var/samba/public/config.conf
chmod 666 /var/samba/public/backup.sql

# Mostrar informações do sistema
log_message "Sistema inicializado com sucesso"
echo ""
echo "=========================================="
echo "MAQ-3 - SERVIDOR LINUX VULNERÁVEL"
echo "=========================================="
echo "IP: $(hostname -I | awk '{print $1}')"
echo "Hostname: $(hostname)"
echo ""
echo "SERVIÇOS ATIVOS:"
echo "- SSH: Porta 22 (root:toor, ftpuser:password123)"
echo "- FTP: Porta 21 (acesso anônimo habilitado)"
echo "- Samba: Portas 139, 445 (acesso público)"
echo "- Syslog: Porta 514"
echo ""
echo "VULNERABILIDADES:"
echo "- SSH com chaves fracas (1024 bits)"
echo "- FTP anônimo com upload habilitado"
echo "- Samba com acesso público total"
echo "- Docker socket exposto (escape de container)"
echo "- Proc e Sys montados (escape de container)"
echo "- Arquivos com credenciais em texto plano"
echo ""
echo "LOGS CAPTURADOS:"
echo "- Sistema: /var/log/syslog"
echo "- Autenticação: /var/log/auth.log"
echo "- SSH: /var/log/ssh_credentials.log"
echo "- Comandos: /var/log/commands.log"
echo "- Debug: /var/log/debug.log"
echo "- Aplicação: /var/log/app/application.log"
echo ""
echo "ARQUIVOS VULNERÁVEIS:"
echo "- /var/ftp/pub/credentials.txt"
echo "- /var/samba/public/config.conf"
echo "- /var/samba/public/backup.sql"
echo "=========================================="

# Função para monitorar logs em tempo real
monitor_logs() {
    log_message "Iniciando monitoramento de logs..."
    tail -f /var/log/syslog /var/log/auth.log /var/log/ssh_credentials.log /var/log/commands.log /var/log/debug.log /var/log/app/application.log
}

# Iniciar monitoramento em background
monitor_logs &

# Manter o container rodando
log_message "Container ativo. Pressione Ctrl+C para parar."
exec tail -f /dev/null 