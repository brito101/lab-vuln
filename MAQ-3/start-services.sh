#!/bin/bash

echo "=== Iniciando Máquina 3 - Servidor de Infraestrutura/Arquivos ==="

# Garantir que os diretórios existem
mkdir -p /var/log/samba /var/log/samba/cores
mkdir -p /var/run/vsftpd/empty
mkdir -p /var/ftp/pub
chown ftp:ftp /var/run/vsftpd/empty
chown ftp:ftp /var/ftp/pub
chmod 755 /var/run/vsftpd/empty
chmod 777 /var/ftp/pub

# Iniciar rsyslog
echo "Iniciando rsyslog..."
rm -f /run/rsyslogd.pid
rsyslogd -n &

# Iniciar Samba
echo "Iniciando Samba..."
smbd -D
nmbd -D

# Iniciar vsftpd
echo "Iniciando vsftpd..."
vsftpd /etc/vsftpd.conf &

# Iniciar SSH
echo "Iniciando SSH..."
/usr/sbin/sshd -D &

# Função para mostrar informações do sistema
show_info() {
    echo "=========================================="
    echo "MÁQUINA 3 - SERVIDOR DE INFRAESTRUTURA"
    echo "=========================================="
    echo "IP: $(hostname -I | awk '{print $1}')"
    echo "Hostname: $(hostname)"
    echo ""
    echo "SERVIÇOS ATIVOS:"
    echo "- SSH: Porta 22"
    echo "- FTP: Porta 21 (vsftpd com acesso anônimo)"
    echo "- Samba: Portas 139, 445"
    echo "- Syslog: Porta 514"
    echo ""
    echo "USUÁRIOS CRIADOS:"
    echo "- ftpuser:password123"
    echo "- smbuser:password123"
    echo "- root:toor (acesso SSH habilitado)"
    echo ""
    echo "VULNERABILIDADES CONFIGURADAS:"
    echo "- SSH com chave RSA 1024 bits (fraca)"
    echo "- FTP anônimo habilitado"
    echo "- Samba com compartilhamento público"
    echo "- Syslog mal configurado (vazamento de credenciais)"
    echo ""
    echo "ARQUIVOS SENSÍVEIS:"
    echo "- /opt/vulnerable_files/dumps/"
    echo "- /var/ftp/pub/"
    echo "- /var/samba/public/"
    echo ""
    echo "LOGS DE ATAQUE:"
    echo "- /var/log/ssh_credentials.log"
    echo "- /var/log/commands.log"
    echo "- /var/log/debug.log"
    echo "=========================================="
}

# Mostrar informações
show_info

# Manter o container rodando
echo "Container iniciado. Pressione Ctrl+C para parar."
echo "Logs dos serviços estão sendo gravados..."

# Monitorar logs em tempo real
tail -f /var/log/auth.log /var/log/ssh_credentials.log /var/log/commands.log /var/log/debug.log &

# Manter o container rodando indefinidamente
exec tail -f /dev/null 