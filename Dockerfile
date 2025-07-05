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
    && rm -rf /var/lib/apt/lists/*

# Criar diretórios necessários
RUN mkdir -p /var/run/sshd \
    && mkdir -p /var/log \
    && mkdir -p /home/ftpuser \
    && mkdir -p /var/samba \
    && mkdir -p /opt/vulnerable_files

# Copiar scripts de configuração
COPY install-services.sh /opt/
COPY configure-vulnerabilities.sh /opt/
COPY setup-files.sh /opt/
COPY start-services.sh /opt/

# Dar permissões de execução aos scripts
RUN chmod +x /opt/*.sh

# Expor portas
EXPOSE 21 22 139 445 514

# Comando padrão
CMD ["/opt/start-services.sh"]