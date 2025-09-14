#!/bin/bash
# Simulação de exfiltração de dados
SRC="/etc/passwd"
DST="/opt/vulnerable_files/.exfiltrated_$(date +%s)"
mkdir -p /opt/vulnerable_files
cp "$SRC" "$DST"
echo "Exfiltrado $SRC para $DST" >> /opt/vulnerable_files/.exfiltration_log
