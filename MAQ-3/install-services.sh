#!/bin/bash

echo "=== Instalando e configurando serviços ==="

# Atualizar sistema
apt-get update

# Instalar serviços adicionais se necessário
apt-get install -y \
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
    enum4linux \
    smbclient

# Criar usuário para FTP
useradd -m -s /bin/bash ftpuser
echo "ftpuser:password123" | chpasswd

# Criar usuário para Samba
useradd -m -s /bin/bash smbuser
echo "smbuser:password123" | chpasswd

# Adicionar usuários ao grupo samba
usermod -aG sambashare smbuser

echo "=== Serviços instalados com sucesso ===" 