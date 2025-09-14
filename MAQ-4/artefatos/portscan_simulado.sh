
#!/bin/bash
# Portscan: varre portas e registra resultado
TARGETS="localhost 127.0.0.1"
PORTS="22 80 443 3306 8080"
for t in $TARGETS; do
	for p in $PORTS; do
		nc -zvw1 $t $p && echo "[PORTSCAN] $t:$p aberto" >> /var/log/portscan.log || echo "[PORTSCAN] $t:$p fechado" >> /var/log/portscan.log
		sleep 1
	done
done
