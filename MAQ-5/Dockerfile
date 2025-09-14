FROM debian:12-slim

ENV DEBIAN_FRONTEND=noninteractive

# Instalar Apache, PHP, MariaDB, ferramentas e artefatos
RUN apt-get update && apt-get install -y \
    apache2 \
    php \
    php-mysql \
    mariadb-server \
    unzip \
    curl \
    wget \
    python3 \
    python3-pip \
    net-tools \
    nmap \
    netcat-openbsd \
    libc6 \
    && rm -rf /var/lib/apt/lists/*

# Criar diretórios vulneráveis
RUN mkdir -p /var/www/html/webshells /var/www/html/backups /var/www/html/.git /opt/vulnerable_files

COPY artefatos/svcmon.py /usr/local/bin/svcmon.py
COPY artefatos/ransomware_simulado_linux.sh /usr/local/bin/ransomware_simulado_linux.sh
COPY artefatos/ransomware_restore_linux.sh /usr/local/bin/ransomware_restore_linux.sh
COPY artefatos/flood_logs_linux.sh /usr/local/bin/flood_logs_linux.sh
COPY artefatos/exfiltracao_simulada.sh /usr/local/bin/exfiltracao_simulada.sh
COPY artefatos/portscan_simulado.sh /usr/local/bin/portscan_simulado.sh
COPY artefatos/persistencia_simulada.sh /usr/local/bin/persistencia_simulada.sh
COPY artefatos/webshell_simulado.php /var/www/html/webshells/webshell_simulado.php
RUN chmod +x /usr/local/bin/*
RUN echo "@reboot python3 /usr/local/bin/svcmon.py &" >> /etc/crontab
COPY init-wordpress.sh /init-wordpress.sh
RUN chmod +x /init-wordpress.sh

# Instalar WordPress vulnerável
WORKDIR /var/www/html
RUN wget https://wordpress.org/latest.zip && unzip latest.zip && mv wordpress/* . && rm -rf wordpress latest.zip
RUN chown -R www-data:www-data /var/www/html
RUN rm -f /var/www/html/index.html


# Instalar wp-cli para uso no entrypoint
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Expor portas
EXPOSE 80 3306

# Agendar execução automática dos artefatos via cron
RUN echo "@reboot /usr/local/bin/ransomware_simulado_linux.sh &" >> /etc/crontab
RUN echo "*/5 * * * * root /usr/local/bin/flood_logs_linux.sh &" >> /etc/crontab
RUN echo "*/15 * * * * root /usr/local/bin/exfiltracao_simulada.sh &" >> /etc/crontab
RUN echo "*/20 * * * * root /usr/local/bin/portscan_simulado.sh &" >> /etc/crontab
RUN echo "@reboot /usr/local/bin/persistencia_simulada.sh &" >> /etc/crontab

CMD ["/bin/bash", "/init-wordpress.sh"]
