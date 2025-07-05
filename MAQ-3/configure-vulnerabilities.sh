#!/bin/bash

echo "=== Configurando vulnerabilidades ==="

# 1. Configurar SSH com chave fraca
echo "Configurando SSH vulnerável..."

# Gerar chave SSH fraca (RSA 1024 bits - ainda fraca mas aceita)
ssh-keygen -t rsa -b 1024 -f /etc/ssh/ssh_host_rsa_key -N "" -q

# Configurar SSH para permitir autenticação por senha e root
cat > /etc/ssh/sshd_config << EOF
Port 22
Protocol 2
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_dsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key
UsePrivilegeSeparation yes
KeyRegenerationInterval 3600
ServerKeyBits 512
SyslogFacility AUTH
LogLevel INFO
LoginGraceTime 120
PermitRootLogin yes
StrictModes yes
RSAAuthentication yes
PubkeyAuthentication yes
AuthorizedKeysFile %h/.ssh/authorized_keys
IgnoreRhosts yes
RhostsRSAAuthentication no
HostbasedAuthentication no
PermitEmptyPasswords yes
ChallengeResponseAuthentication no
PasswordAuthentication yes
X11Forwarding yes
X11DisplayOffset 10
PrintMotd no
PrintLastLog yes
TCPKeepAlive yes
AcceptEnv LANG LC_*
Subsystem sftp /usr/lib/openssh/sftp-server
UsePAM yes
EOF

# 2. Configurar FTP anônimo (vsftpd)
echo "Configurando FTP anônimo..."

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
EOF

# Criar diretório para FTP anônimo
mkdir -p /var/ftp/pub
chown ftp:ftp /var/ftp/pub
chmod 777 /var/ftp/pub

# 3. Configurar Samba vulnerável
echo "Configurando Samba vulnerável..."

cat > /etc/samba/smb.conf << EOF
[global]
   workgroup = WORKGROUP
   server string = Vulnerable File Server
   server role = standalone server
   map to guest = bad user
   guest account = nobody
   security = user
   passdb backend = tdbsam
   printing = cups
   printcap name = cups
   load printers = yes
   cups options = raw
   log file = /var/log/samba/log.%m
   max log size = 50
   logging = file
   panic action = /usr/share/samba/panic-action %d
   server role_check:infer = yes
   obey pam restrictions = yes
   unix password sync = yes
   passwd program = /usr/bin/passwd %u
   passwd chat = *Enter\snew\s*\spassword:* %n\n *Retype\snew\s*\spassword:* %n\n *password\supdated\ssuccessfully* .
   pam password change = yes
   map to guest = bad user
   usershare allow guests = yes

[public]
   comment = Public Share
   path = /var/samba/public
   browseable = yes
   read only = no
   guest ok = yes
   writable = yes
   create mask = 0777
   directory mask = 0777

[admin]
   comment = Admin Share
   path = /var/samba/admin
   browseable = yes
   read only = no
   guest ok = no
   valid users = smbuser
   writable = yes
   create mask = 0777
   directory mask = 0777
EOF

# Criar diretórios do Samba
mkdir -p /var/samba/public /var/samba/admin
chmod 777 /var/samba/public
chmod 755 /var/samba/admin
chown smbuser:smbuser /var/samba/admin

# Adicionar usuário Samba
echo -e "password123\npassword123" | smbpasswd -a smbuser

# 4. Configurar Syslog mal configurado
echo "Configurando Syslog vulnerável..."

cat > /etc/rsyslog.conf << EOF
# rsyslog configuration file

# For more information see /usr/share/doc/rsyslog-*/rsyslog_conf.html
# or latest version online at http://www.rsyslog.com/doc/rsyslog_conf.html
# If you experience problems, see http://www.rsyslog.com/doc/troubleshoot.html

#### MODULES ####

module(load="imuxsock") # provides support for local system logging (e.g. via logger command)
module(load="imklog")   # provides kernel logging support (previously done by rklogd)
#module(load="immark")  # provides --MARK-- message capability

# provides UDP syslog reception
module(load="imudp")
input(type="imudp" port="514")

# provides TCP syslog reception
module(load="imtcp")
input(type="imtcp" port="514")

#### GLOBAL DIRECTIVES ####

# Where to place auxiliary files
global(workDirectory="/var/spool/rsyslog")

# Use default timestamp format
module(load="builtin:omfile" Template="RSYSLOG_TraditionalFileFormat")

# Include all config files in /etc/rsyslog.d/
include(file="/etc/rsyslog.d/*.conf" mode="optional")

#### RULES ####

# Log all kernel messages to the console.
# Logging much else clutters up the screen.
#kern.*                                                 /dev/console

# Log anything (except mail) of level info or higher.
# Don't log private authentication messages!
*.info;mail.none;authpriv.none;cron.none                /var/log/messages

# The authpriv file has restricted access.
authpriv.*                                              /var/log/secure

# Log all the mail messages in one place.
mail.*                                                  /var/log/maillog

# Log cron stuff
cron.*                                                  /var/log/cron

# Everybody gets emergency messages
*.emerg                                                 :omusrmsg:*

# Save news errors of level crit and higher in a special file.
uucp,news.crit                                          /var/log/spooler

# Save boot messages also to boot.log
local7.*                                                /var/log/boot.log

# Log SSH connections with passwords (VULNERABILIDADE)
auth,authpriv.*                                         /var/log/auth.log
auth,authpriv.*                                         /var/log/ssh_credentials.log

# Log all commands executed (VULNERABILIDADE)
*.info                                                  /var/log/commands.log

# Log sensitive information (VULNERABILIDADE)
*.debug                                                 /var/log/debug.log
EOF

# Criar arquivos de log
touch /var/log/ssh_credentials.log /var/log/commands.log /var/log/debug.log
chmod 666 /var/log/ssh_credentials.log /var/log/commands.log /var/log/debug.log

echo "=== Vulnerabilidades configuradas com sucesso ===" 