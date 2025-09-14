#!/bin/bash
# Flood de logs para simulação de ruído
for i in {1..50}; do
    logger "[LABVULN] Evento falso de login: user=attacker$i ip=192.168.99.$i"
    echo "$(date) - Evento falso de login: user=attacker$i ip=192.168.99.$i" >> /var/log/auth.log
    sleep 2
done
