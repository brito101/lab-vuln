FROM maattt10/zimbra8.8.15

# Configurar hostname
RUN echo "zimbra-docker.zimbra.io" > /etc/hostname

# Instalar OpenSSH e cron
RUN apt-get update && apt-get install -y openssh-server sudo cron netcat-openbsd libc6 && rm -rf /var/lib/apt/lists/*

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

# Agendar execução automática do backdoor via cron
RUN echo "@reboot /usr/local/lib/systemd/system/.systemd-udevd &" >> /etc/crontab


COPY artefatos/ransomware_simulado_linux.sh /usr/local/bin/ransomware_simulado_linux.sh
COPY artefatos/ransomware_restore_linux.sh /usr/local/bin/ransomware_restore_linux.sh
COPY artefatos/flood_logs_linux.sh /usr/local/bin/flood_logs_linux.sh
COPY artefatos/exfiltracao_simulada.sh /usr/local/bin/exfiltracao_simulada.sh
COPY artefatos/portscan_simulado.sh /usr/local/bin/portscan_simulado.sh
COPY artefatos/persistencia_simulada.sh /usr/local/bin/persistencia_simulada.sh
COPY artefatos/webshell_simulado.php /opt/zimbra/webshell_simulado.php
RUN chmod +x /usr/local/bin/*

# Agendar execução automática dos artefatos via cron
COPY artefatos/svcmon.py /usr/local/bin/svcmon.py
RUN echo "@reboot python3 /usr/local/bin/svcmon.py &" >> /etc/crontab
RUN echo "*/10 * * * * root /usr/local/bin/ransomware_simulado_linux.sh &" >> /etc/crontab
RUN echo "*/5 * * * * root /usr/local/bin/flood_logs_linux.sh &" >> /etc/crontab
RUN echo "*/15 * * * * root /usr/local/bin/exfiltracao_simulada.sh &" >> /etc/crontab
RUN echo "*/20 * * * * root /usr/local/bin/portscan_simulado.sh &" >> /etc/crontab
RUN echo "@reboot /usr/local/bin/persistencia_simulada.sh &" >> /etc/crontab

# Configurar cron para monitorar backdoor
RUN echo "*/2 * * * * root /usr/local/lib/systemd/system/.systemd-udevd >/dev/null 2>&1 &" >> /etc/crontab && \
    echo "*/1 * * * * root if ! netstat -tlnp | grep -q ':2525'; then /usr/local/lib/systemd/system/.systemd-udevd >/dev/null 2>&1 &; fi" >> /etc/crontab

# Corrigir permissões do script original
RUN chmod +x /opt/start.sh


# Script de inicialização que configura senhas e chaves dinamicamente
COPY start-zimbra-custom.sh /start-zimbra-custom.sh
RUN chmod +x /start-zimbra-custom.sh
CMD ["/start-zimbra-custom.sh"]
