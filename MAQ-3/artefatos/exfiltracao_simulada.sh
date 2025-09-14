#!/bin/bash
# Simulação de exfiltração real de arquivo
SRC="/etc/passwd"
DST="/opt/vulnerable_files/.exfiltrated_$(date +%s)"
cp "$SRC" "$DST"
echo "Exfiltrado $SRC para $DST" >> /opt/vulnerable_files/.exfiltration_log
