# MAQ-5: Web Server Linux Vulnerável (WordPress)

## Visão Geral

Este laboratório simula um servidor web Linux rodando WordPress vulnerável, com artefatos dinâmicos para análise SOC e resposta a incidentes.

### Serviços
- Apache2 (porta 8080)
- MySQL/MariaDB (porta 33060)
- WordPress com plugins/temas inseguros
- Diretórios sensíveis expostos (.git, backups)

### Artefatos Dinâmicos
- **ransomware_simulado_linux.sh**: Criptografa arquivos do site e gera nota de resgate. Restaure com `ransomware_restore_linux.sh`.
- **flood_logs_linux.sh**: Gera eventos falsos em logs do Apache e sistema.
- **exfiltracao_simulada.sh**: Simula exfiltração de dados do site/banco.
- **portscan_simulado.sh**: Simula varredura de portas internas.
- **persistencia_simulada.sh**: Simula persistência via cron.
- **webshell_simulado.php**: Webshell PHP para simulação de invasão (`/var/www/html/webshells`).

### Restauração
Execute `/usr/local/bin/ransomware_restore_linux.sh` no container para restaurar arquivos criptografados.


### Como verificar se os artefatos foram executados

- **Ransomware Simulado:**
	- Verifique arquivos com extensão `.locked` e o arquivo de nota de resgate em `/opt/vulnerable_files`:
		```bash
		docker exec maq5-web ls -l /opt/vulnerable_files
		docker exec maq5-web cat /opt/vulnerable_files/README_RESCUE.txt
		```
- **Flood de Logs:**
	- Veja os eventos falsos em `/var/log/auth.log`:
		```bash
		docker exec maq5-web tail -n 20 /var/log/auth.log
		```
- **Exfiltração Simulada:**
	- Arquivos exfiltrados e log em `/opt/vulnerable_files/.exfiltration_log`:
		```bash
		docker exec maq5-web ls -l /opt/vulnerable_files
		docker exec maq5-web cat /opt/vulnerable_files/.exfiltration_log
		```
- **Portscan Simulado:**
	- Resultados do scan em `/var/log/portscan.log`:
		```bash
		docker exec maq5-web tail -n 20 /var/log/portscan.log
		```
- **Persistência Simulada:**
	- Log de persistência em `/var/log/persistencia.log`:
		```bash
		docker exec maq5-web tail -n 20 /var/log/persistencia.log
		```
- **Webshell Simulado:**
	- Acesse no navegador: `http://localhost:8080/webshells/webshell_simulado.php`

Todos os artefatos geram logs específicos para facilitar investigação e correlação de alertas.

### Deploy Rápido
```bash
cd MAQ-5
./setup.sh deploy
```

Acesse o WordPress em http://localhost:8080
Acesse o banco de dados em localhost:33060

Para disparar artefatos manualmente:
```bash
./attack-test.sh artefatos
```
