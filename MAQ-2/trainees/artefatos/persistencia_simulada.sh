#!/bin/bash
# Simulação de persistência
LOGDIR="/opt/vulnerable_files"
mkdir -p "$LOGDIR"
LOGFILE="$LOGDIR/persistencia.log"
echo "[SIMULACAO] Persistência registrada em $(date)" >> "$LOGFILE"
echo "[SIMULACAO] (Não foi possível modificar crontab real por falta de permissão)" >> "$LOGFILE"
