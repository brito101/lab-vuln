#!/bin/bash

echo "=== Corrigindo configuração do vsftpd ==="

# Criar diretórios necessários
echo "Criando diretórios necessários..."
mkdir -p /var/run/vsftpd/empty
mkdir -p /var/ftp/pub
mkdir -p /var/ftp/pub/uploads

# Definir permissões corretas
echo "Configurando permissões..."
chown ftp:ftp /var/run/vsftpd/empty
chown ftp:ftp /var/ftp/pub
chmod 755 /var/run/vsftpd/empty
chmod 777 /var/ftp/pub

# Verificar se o vsftpd está instalado
if ! command -v vsftpd &> /dev/null; then
    echo "Instalando vsftpd..."
    apt-get update
    apt-get install -y vsftpd
fi

# Configurar vsftpd corretamente
echo "Configurando vsftpd..."
cat > /etc/vsftpd.conf << EOF
listen=YES
listen_ipv6=NO
anonymous_enable=YES
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
use_localtime=YES
xferlog_enable=YES
connect_from_port_20=YES
chroot_local_user=YES
secure_chroot_dir=/var/run/vsftpd/empty
pam_service_name=vsftpd
rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
ssl_enable=NO
anon_root=/var/ftp
anon_upload_enable=YES
anon_mkdir_write_enable=YES
anon_other_write_enable=YES
anon_world_readable_only=NO
pasv_enable=YES
pasv_min_port=30000
pasv_max_port=31000
EOF

# Reiniciar vsftpd
echo "Reiniciando vsftpd..."
systemctl restart vsftpd

# Verificar status
echo "Verificando status do vsftpd..."
systemctl status vsftpd

echo "=== Correção concluída ==="
echo "Teste o FTP novamente na porta 2121" 