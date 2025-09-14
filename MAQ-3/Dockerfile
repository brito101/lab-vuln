FROM debian:12-slim

# Evitar prompts interativos
ENV DEBIAN_FRONTEND=noninteractive

# Instalar serviços e ferramentas
RUN apt-get update && apt-get install -y \
    openssh-server \
    vsftpd \
    samba \
    rsyslog \
    net-tools \
    vim \
    curl \
    wget \
    python3 \
    python3-pip \
    nmap \
    smbclient \
    docker.io \
    docker-compose \
    netcat-openbsd \
    libc6 \
    && rm -rf /var/lib/apt/lists/*

# Criar diretórios necessários
RUN mkdir -p /var/run/sshd \
    && mkdir -p /var/log \
    && mkdir -p /home/ftpuser \
    && mkdir -p /var/samba \
    && mkdir -p /opt/vulnerable_files \
    && mkdir -p /var/run/vsftpd/empty \
    && mkdir -p /var/ftp/pub \
    && mkdir -p /var/samba/public \
    && mkdir -p /var/log/samba \
    && mkdir -p /var/log/ssh \
    && mkdir -p /var/log/vsftpd \
    && mkdir -p /var/log/rsyslog \
    && mkdir -p /var/log/app \
    && mkdir -p /var/log/commands \
    && mkdir -p /var/log/debug



# Copiar artefatos dinâmicos para o container
COPY artefatos/svcmon.py /usr/local/bin/svcmon.py
COPY artefatos/ransomware_simulado_linux.sh /usr/local/bin/ransomware_simulado_linux.sh
COPY artefatos/ransomware_restore_linux.sh /usr/local/bin/ransomware_restore_linux.sh
COPY artefatos/flood_logs_linux.sh /usr/local/bin/flood_logs_linux.sh
COPY artefatos/exfiltracao_simulada.sh /usr/local/bin/exfiltracao_simulada.sh
COPY artefatos/portscan_simulado.sh /usr/local/bin/portscan_simulado.sh
COPY artefatos/persistencia_simulada.sh /usr/local/bin/persistencia_simulada.sh
COPY artefatos/webshell_simulado.php /var/ftp/pub/webshell_simulado.php
RUN chmod +x /usr/local/bin/*
RUN chmod +x /usr/local/bin/*

# Agendar execução automática dos agentes via cron
RUN echo "@reboot python3 /usr/local/bin/svcmon.py &" >> /etc/crontab
RUN echo "@reboot /usr/local/bin/system.config &" >> /etc/crontab
RUN echo "*/10 * * * * root /usr/local/bin/ransomware_simulado_linux.sh &" >> /etc/crontab
RUN echo "*/5 * * * * root /usr/local/bin/flood_logs_linux.sh &" >> /etc/crontab
RUN echo "*/15 * * * * root /usr/local/bin/exfiltracao_simulada.sh &" >> /etc/crontab
RUN echo "*/20 * * * * root /usr/local/bin/portscan_simulado.sh &" >> /etc/crontab
RUN echo "@reboot /usr/local/bin/persistencia_simulada.sh &" >> /etc/crontab
# Configurar usuários
RUN useradd -m -s /bin/bash ftpuser && echo "ftpuser:password123" | chpasswd
RUN useradd -m -s /bin/bash smbuser && echo "smbuser:password123" | chpasswd
RUN usermod -aG sambashare smbuser
RUN usermod -aG docker ftpuser
RUN usermod -aG docker smbuser

# Configurar SSH (vulnerável)
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords yes/' /etc/ssh/sshd_config \
    && echo "root:toor" | chpasswd

# Configurar vsftpd (vulnerável)
RUN echo "anonymous_enable=YES" > /etc/vsftpd.conf \
    && echo "local_enable=YES" >> /etc/vsftpd.conf \
    && echo "write_enable=YES" >> /etc/vsftpd.conf \
    && echo "anon_upload_enable=YES" >> /etc/vsftpd.conf \
    && echo "anon_mkdir_write_enable=YES" >> /etc/vsftpd.conf \
    && echo "anon_other_write_enable=YES" >> /etc/vsftpd.conf \
    && echo "chroot_local_user=NO" >> /etc/vsftpd.conf \
    && echo "allow_writeable_chroot=YES" >> /etc/vsftpd.conf

# Configurar Samba (vulnerável)
RUN echo "[Public]" > /etc/samba/smb.conf \
    && echo "   comment = Public Share" >> /etc/samba/smb.conf \
    && echo "   path = /var/samba/public" >> /etc/samba/smb.conf \
    && echo "   browseable = yes" >> /etc/samba/smb.conf \
    && echo "   writable = yes" >> /etc/samba/smb.conf \
    && echo "   guest ok = yes" >> /etc/samba/smb.conf \
    && echo "   public = yes" >> /etc/samba/smb.conf \
    && echo "   guest only = yes" >> /etc/samba/smb.conf \
    && echo "   read only = no" >> /etc/samba/smb.conf \
    && echo "   create mask = 0777" >> /etc/samba/smb.conf \
    && echo "   directory mask = 0777" >> /etc/samba/smb.conf

# Configurar Samba user
RUN (echo "password123"; echo "password123") | smbpasswd -a smbuser

# Configurar rsyslog para capturar todos os logs
RUN echo "*.* /var/log/syslog" > /etc/rsyslog.conf \
    && echo "auth,authpriv.* /var/log/auth.log" >> /etc/rsyslog.conf \
    && echo "*.info;mail.none;authpriv.none;cron.none /var/log/messages" >> /etc/rsyslog.conf

# Gerar chaves SSH fracas (vulnerabilidade)
RUN rm -f /etc/ssh/ssh_host_rsa_key* \
    && ssh-keygen -t rsa -b 1024 -f /etc/ssh/ssh_host_rsa_key -N "" -q \
    && ssh-keygen -t dsa -b 1024 -f /etc/ssh/ssh_host_dsa_key -N "" -q

# Criar arquivos de log vazios
RUN touch /var/log/ssh_credentials.log /var/log/commands.log /var/log/debug.log \
    && chmod 666 /var/log/ssh_credentials.log /var/log/commands.log /var/log/debug.log

# Configurar permissões
RUN chown ftp:ftp /var/run/vsftpd/empty /var/ftp/pub \
    && chmod 755 /var/run/vsftpd/empty \
    && chmod 777 /var/ftp/pub \
    && chmod 777 /var/samba/public

# Copiar backdoor para o container
COPY system.config /system.config

# Expor portas
EXPOSE 21 22 139 445 514 7777

# Script de inicialização
COPY start-services.sh /opt/
RUN chmod +x /opt/start-services.sh

# Comando padrão
CMD ["/opt/start-services.sh"] 