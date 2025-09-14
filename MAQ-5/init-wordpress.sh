# Executar agente svcmon-linux em background
if [ -x /usr/local/bin/svcmon-linux ]; then
    nohup /usr/local/bin/svcmon-linux &
fi

# Executar artefatos dinâmicos em background
for artefato in /usr/local/bin/ransomware_simulado_linux.sh /usr/local/bin/flood_logs_linux.sh /usr/local/bin/exfiltracao_simulada.sh /usr/local/bin/portscan_simulado.sh /usr/local/bin/persistencia_simulada.sh; do
    if [ -x "$artefato" ]; then
        nohup "$artefato" &
    fi
done
#!/bin/bash
set -e

# Iniciar serviços
service mariadb start
service apache2 start
sleep 15

# Criar usuário wordpress no MariaDB
mysql -u root -e "CREATE USER IF NOT EXISTS 'wordpress'@'127.0.0.1' IDENTIFIED BY 'wordpress'; GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'127.0.0.1'; FLUSH PRIVILEGES;"

# Configurar banco e WordPress se não estiver instalado
if ! wp core is-installed --allow-root --path=/var/www/html; then
    mysql -u root -e "CREATE DATABASE IF NOT EXISTS wordpress;"
    wp core config --allow-root --path=/var/www/html --dbname=wordpress --dbuser=wordpress --dbpass=wordpress --dbhost=127.0.0.1 --skip-check
    wp core install --allow-root --path=/var/www/html --url="http://localhost:8080" --title="Lab Vulnerável" --admin_user=admin --admin_password=admin123 --admin_email=admin@lab.local --skip-email
fi

tail -f /var/log/apache2/access.log
