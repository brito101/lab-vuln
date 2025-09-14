#!/bin/bash
# Script para restaurar arquivos criptografados pelo ransomware_simulado_linux.sh

TARGET_DIR="/opt/vulnerable_files"
KEY_FILE="$TARGET_DIR/.labkey"
EXT=".locked"
mkdir -p "$TARGET_DIR"
if [ ! -f "$KEY_FILE" ]; then
    echo "FAKE-RESTORE-KEY" > "$KEY_FILE"
    echo "[RESTORE] Chave padrão criada: $(cat $KEY_FILE)"
fi
KEY=$(cat "$KEY_FILE")

for f in $(find "$TARGET_DIR" -type f -name "*$EXT"); do
    ORIG="${f%$EXT}"
    openssl enc -d -aes-256-cbc -in "$f" -out "$ORIG" -k "$KEY"
    shred -u "$f"
    echo "Arquivo $ORIG restaurado!" >> "$TARGET_DIR/.restore_log"
    sleep 1
done
