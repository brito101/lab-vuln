FROM debian:11-slim

# Evitar prompts interativos durante a instalação
ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependências básicas
RUN apt-get update && apt-get install -y \
    openssh-server \
    vsftpd \
    samba \
    rsyslog \
    net-tools \
    vim \
    curl \
    wget \
    unzip \
    python3 \
    python3-pip \
    nmap \
    smbclient \
    && rm -rf /var/lib/apt/lists/*

# Criar diretórios necessários
RUN mkdir -p /var/run/sshd \
    && mkdir -p /var/log \
    && mkdir -p /home/ftpuser \
    && mkdir -p /var/samba \
    && mkdir -p /opt/vulnerable_files \
    && mkdir -p /var/run/vsftpd/empty \
    && mkdir -p /var/ftp/pub \
    && mkdir -p /var/ftp/pub/uploads \
    && mkdir -p /var/samba/public \
    && mkdir -p /var/samba/admin \
    && mkdir -p /var/log/samba \
    && mkdir -p /var/log/samba/cores

# Copiar scripts de configuração
COPY install-services.sh /opt/
COPY configure-vulnerabilities.sh /opt/
COPY setup-files.sh /opt/
COPY start-services.sh /opt/
COPY install-enum4linux.sh /opt/

# Dar permissões de execução aos scripts
RUN chmod +x /opt/*.sh

# Configurar permissões do vsftpd
RUN chown ftp:ftp /var/run/vsftpd/empty \
    && chown ftp:ftp /var/ftp/pub \
    && chmod 755 /var/run/vsftpd/empty \
    && chmod 777 /var/ftp/pub

# Executar configuração durante o build
RUN /opt/install-services.sh
RUN /opt/install-enum4linux.sh
RUN /opt/configure-vulnerabilities.sh
RUN /opt/setup-files.sh

# Criar usuários durante o build (se não existirem)
RUN id ftpuser &>/dev/null || (useradd -m -s /bin/bash ftpuser && echo "ftpuser:password123" | chpasswd)
RUN id smbuser &>/dev/null || (useradd -m -s /bin/bash smbuser && echo "smbuser:password123" | chpasswd)
RUN usermod -aG sambashare smbuser 2>/dev/null || true

# Configurar SSH para permitir root login
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN echo "root:toor" | chpasswd

# Garantir que as senhas dos usuários estão corretas
RUN echo "ftpuser:password123" | chpasswd
RUN echo "smbuser:password123" | chpasswd

# Configurar Samba
RUN (echo "password123"; echo "password123") | smbpasswd -a smbuser

# Criar arquivos de log
RUN touch /var/log/ssh_credentials.log /var/log/commands.log /var/log/debug.log
RUN chmod 666 /var/log/ssh_credentials.log /var/log/commands.log /var/log/debug.log

# Gerar chaves SSH fracas durante o build
RUN rm -f /etc/ssh/ssh_host_rsa_key* && ssh-keygen -t rsa -b 1024 -f /etc/ssh/ssh_host_rsa_key -N "" -q

# Expor portas
EXPOSE 21 22 139 445 514 30000-31000

# Comando padrão - apenas iniciar serviços
CMD ["/opt/start-services.sh"] 