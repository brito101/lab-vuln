# MAQ-1: Laboratório de Vulnerabilidades - Windows Server 2022

## Visão Geral

Este laboratório simula um ambiente Windows Server 2022 para estudos de segurança e análise de vulnerabilidades. Utiliza a imagem `dockur/windows` que executa Windows Server via QEMU/KVM dentro de um container Docker.

**⚠️ ATENÇÃO: Este é um ambiente de LABORATÓRIO com vulnerabilidades intencionais. NUNCA use em produção!**

## 🎯 Objetivos do Laboratório

- Configurar Windows Server 2022 em ambiente containerizado
- Implementar simulações de ataques via WinRM (Windows Remote Management)
- Demonstrar técnicas de análise de artefatos maliciosos
- Praticar resposta a incidentes em ambiente controlado
- Estudar comportamentos de malware em sistemas Windows

## 🚀 Instruções de Execução

### 1. Preparar o Ambiente
```bash
# Clonar o repositório (se necessário)
git clone <repository-url>
cd lab-vuln/MAQ-1

# Verificar dependências
python3 --version
docker --version
```

### 2. Iniciar o Laboratório
```bash
# Iniciar o container Windows
./setup.sh

# IMPORTANTE: Na primeira execução, o Windows Server 2022 será baixado e instalado
# Este processo pode demorar 30-60 minutos dependendo da sua conexão
# Monitore o progresso em: http://localhost:8006

# Para acompanhar a instalação em tempo real:
./monitor-installation.sh

# Aguardar alguns minutos para o Windows inicializar completamente
# O processo pode demorar 5-10 minutos após a instalação
```

### 3. Configurar WinRM (OBRIGATÓRIO)

**⚠️ IMPORTANTE: O WinRM deve ser configurado manualmente DENTRO do Windows após a primeira inicialização.**

```bash
# 1. Verificar se há instruções de configuração
./setup-winrm.sh

# 2. Acessar o Windows:
#    - Web: http://localhost:8006
#    - RDP: localhost:3389 (usuário: Docker, senha: admin)

# 3. Dentro do Windows, abrir PowerShell como Administrador e executar:
#    PowerShell -ExecutionPolicy Bypass -File "\\host.lan\Data\configure-winrm.ps1"

# 4. Testar a conectividade:
./setup-winrm.sh test
```

**🔧 O que o script `configure-winrm.ps1` faz:**
- Habilita o serviço WinRM
- Configura autenticação básica
- Permite conexões não criptografadas (apenas para laboratório)
- Configura regras de firewall
- Testa a configuração automaticamente

### 4. Executar Simulações de Ataquedows Server 2022

## Visão Geral

Este laboratório simula um ambiente Windows Server 2022 para estudos de segurança e análise de vulnerabilidades. Utiliza a imagem `dockur/windows` que executa Windows Server via QEMU/KVM dentro de um container Docker.

**⚠️ ATENÇÃO: Este é um ambiente de LABORATÓRIO com vulnerabilidades intencionais. NUNCA use em produção!**

## 🎯 Objetivos do Laboratório

- Configurar Windows Server 2022 em ambiente containerizado
- Implementar simulações de ataques via WinRM (Windows Remote Management)
- Demonstrar técnicas de análise de artefatos maliciosos
- Praticar resposta a incidentes em ambiente controlado
- Estudar comportamentos de malware em sistemas Windows

## 🚀 Instruções de Execução

### 1. Preparar o Ambiente
```bash
# Clonar o repositório (se necessário)
git clone <repository-url>
cd lab-vuln/MAQ-1

# Verificar dependências
python3 --version
docker --version
```

### 2. Iniciar o Laboratório
```bash
# Iniciar o container Windows
./setup.sh

# IMPORTANTE: Na primeira execução, o Windows Server 2022 será baixado e instalado
# Este processo pode demorar 30-60 minutos dependendo da sua conexão
# Monitore o progresso em: http://localhost:8006

# Para acompanhar a instalação em tempo real:
./monitor-installation.sh

# Aguardar alguns minutos para o Windows inicializar completamente
# O processo pode demorar 5-10 minutos após a instalação
```

### 3. Executar Simulações de Ataque
```bash
# Acessar menu interativo
./attack-test.sh

# OU acessar menu diretamente
./attack-test.sh artefatos
```

### 5. Acessar o Sistema Windows

- **Web Interface (noVNC)**: http://localhost:8006
- **RDP**: `localhost:3389`
  - Usuário: `Docker`
  - Senha: `admin`

## 🏗️ Arquitetura do Laboratório

```
┌─────────────────────────────────────────────────────────────┐
│                    LABORATÓRIO MAQ-1                       │
├─────────────────────────────────────────────────────────────┤
│  Windows Server 2022 (via dockur/windows)                  │
│  - QEMU/KVM dentro de container Docker                     │
│  - WinRM na porta 5985 (requer configuração manual)       │
│  - Usuário: Docker / Senha: admin                          │
│  - Políticas de execução PowerShell permissivas            │
├─────────────────────────────────────────────────────────────┤
│  Portas Expostas no Host:                                  │
│  • 8006  - Web Viewer (noVNC)                              │
│  • 3389  - RDP (Remote Desktop Protocol)                   │
│  • 5985  - WinRM (Windows Remote Management)               │
├─────────────────────────────────────────────────────────────┤
│  Integração Host ↔ Windows:                               │
│  • Scripts PowerShell executados via pywinrm              │
│  • Comunicação HTTP básica (usuário Docker:admin)         │
│  • Execução de jobs em background para persistência       │
└─────────────────────────────────────────────────────────────┘
```

## 🔥 Simulações de Ataque Disponíveis

### 1. Exfiltração Simulada (`exfiltracao_simulada_win.ps1`)
- **Objetivo**: Simular roubo de arquivos sensíveis
- **Comportamento**: 
  - Copia arquivo `hosts` do sistema para diretório temporário
  - Renomeia com timestamp para simular exfiltração
  - Gera log da atividade
- **Verificação**: Verificar arquivo em `C:\Users\Docker\AppData\Local\Temp\`

### 2. Flood de Logs (`flood_logs_win.ps1`)
- **Objetivo**: Gerar ruído em logs de segurança
- **Comportamento**:
  - Cria 50 eventos falsos de tentativas de login
  - Simula ataques de força bruta com IPs fictícios
  - Polui logs para dificultar análise
- **Verificação**: Logs ficam visíveis no Event Viewer do Windows

### 3. Persistência Simulada (`persistencia_simulada_win.ps1`)
- **Objetivo**: Simular backdoor persistente
- **Comportamento**:
  - Cria bind shell TCP na porta 4444
  - Executa como job em background
  - Mantém conexão disponível para "atacante"
- **Verificação**: `telnet localhost 4444` (do host Linux)

### 4. Portscan Simulado (`portscan_simulado_win.ps1`)
- **Objetivo**: Simular reconnaissance de rede
- **Comportamento**:
  - Escaneia portas comuns em localhost e 127.0.0.1
  - Identifica serviços ativos (RDP, SMB, etc.)
  - Gera logs de tentativas de conexão
- **Verificação**: Output mostra portas abertas/fechadas

### 5. Ransomware Simulado (`ransomware_simulado_win.ps1`)
- **Objetivo**: Simular ataque de ransomware
- **Comportamento**:
  - Cria arquivos falsos (documentos, configs, backups)
  - Gera chave de criptografia aleatória
  - Criptografa arquivos e adiciona extensão `.locked`
  - Cria logs de arquivos afetados
- **Verificação**: Arquivos `.locked` em `C:\Users\Docker\AppData\Local\Temp\VulnFiles\`

### 6. Restauração de Ransomware (`ransomware_restore_win.ps1`)
- **Objetivo**: Simular recuperação de dados
- **Comportamento**:
  - Lê chave de criptografia salva
  - Descriptografa arquivos `.locked`
  - Restaura nomes originais
  - Remove arquivos criptografados
- **Verificação**: Arquivos originais restaurados sem extensão `.locked`

## 🛠️ Dependências e Requisitos

### Sistema Host (Linux)
- **Docker**: 20.10+ e Docker Compose
- **Python 3**: 3.8+ com pip
- **Biblioteca pywinrm**: Instalada automaticamente pelo script
- **Conectividade**: Acesso à internet para download da imagem
- **Recursos**: Mínimo 4GB RAM, 20GB espaço em disco

### Imagem Docker
- **Base**: `dockur/windows:latest`
- **SO**: Windows Server 2022
- **Recursos**: 2 CPU cores, 3GB RAM configurados
- **Armazenamento**: Volume persistente para dados

## 📋 Como Verificar Resultados dos Ataques

### Via RDP (Recomendado)
```bash
# Conectar via RDP: localhost:3389
# Usuário: Docker / Senha: admin

# Navegar para verificar artefatos:
# C:\Users\Docker\AppData\Local\Temp\
# - exfiltrated_hosts_*.txt (exfiltração)
# - VulnFiles\ (ransomware)

# Event Viewer para logs:
# Windows Logs > Security
# Windows Logs > Application
```

### Via PowerShell Remoto
```bash
# O script attack-test.sh já mostra saídas dos comandos
# Logs aparecem automaticamente durante execução
```

### Verificar Serviços
```bash
# Testar bind shell (se persistência ativa)
telnet localhost 4444

# Verificar processo svcmon-win.exe (se executado)
# Via RDP: Task Manager > Processes
```

## 🔧 Solução de Problemas

### Primeira Instalação (Muito Importante!)
```bash
# Na PRIMEIRA execução, o sistema irá:
# 1. Baixar Windows Server 2022 (~5GB)
# 2. Extrair e configurar a imagem
# 3. Criar disco virtual de 128GB
# 4. Instalar e configurar o Windows

# TEMPO ESTIMADO: 30-60 minutos (dependendo da conexão)

# Monitorar instalação:
./monitor-installation.sh

# Acompanhar visualmente:
# http://localhost:8006
```

### Container não inicia
```bash
# Verificar portas em uso
netstat -tlnp | grep -E "(8006|3389|5985)"

# Verificar logs do Docker
docker logs maq1-windows

# Reiniciar serviço Docker
sudo systemctl restart docker
```

### WinRM não conecta
```bash
# 1. Verificar se o container está rodando
docker ps | grep maq1-windows

# 2. Verificar se Windows inicializou completamente
docker logs maq1-windows | grep "Windows started"

# 3. Executar diagnóstico completo
./diagnose-winrm.sh

# 4. Se necessário, configurar WinRM manualmente:
#    - Acesse http://localhost:8006
#    - Abra PowerShell como Administrador
#    - Execute: PowerShell -ExecutionPolicy Bypass -File "\\host.lan\Data\configure-winrm.ps1"

# 5. Testar conectividade após configuração
./setup-winrm.sh test
```

**⚠️ LEMBRE-SE: O WinRM DEVE ser configurado manualmente dentro do Windows na primeira execução!**

### Scripts PowerShell falham
```bash
# Verificar se Windows terminou de inicializar
# Tentar conectar via RDP primeiro
# Verificar política de execução no Windows:
# Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope LocalMachine
```

### Performance lenta
```bash
# Aumentar recursos no docker-compose.yml:
# cpus: "4"
# mem_limit: 4g

# Verificar recursos disponíveis no host
free -h
df -h
```

## ⚠️ Avisos Importantes de Segurança

- **🚨 NUNCA** execute este laboratório em redes de produção
- **🚨 NUNCA** use as credenciais (`Docker:admin`) em sistemas reais
- As simulações podem **gerar alertas** em sistemas de monitoramento
- Arquivos maliciosos são **simulações** e não causam danos reais
- O ambiente contém **credenciais fracas propositalmente**
- Destinado **EXCLUSIVAMENTE** para fins educacionais e treinamento

## 🧹 Limpeza e Manutenção

### Parar o Laboratório
```bash
# Parar container preservando dados
./setup.sh stop

# Parar e remover completamente
./setup.sh clean
```

### Reset Completo
```bash
# Remover volumes e recriar
docker-compose down -v
docker system prune -f
./setup.sh
```

## 📝 Estrutura do Projeto

```
MAQ-1/
├── attack-test.sh              # Script principal de ataques
├── setup.sh                   # Script de configuração
├── README.md                  # Esta documentação
├── .gitignore                 # Exclusões do Git
├── artefatos/                 # Scripts PowerShell
│   ├── exfiltracao_simulada_win.ps1
│   ├── flood_logs_win.ps1
│   ├── persistencia_simulada_win.ps1
│   ├── portscan_simulado_win.ps1
│   ├── ransomware_simulado_win.ps1
│   ├── ransomware_restore_win.ps1
│   ├── svcmon-win.exe         # Agente C2 simulado
│   └── webshell_simulado_win.aspx
├── logs/                      # Estrutura para logs
├── vulnerable_files/          # Arquivos vulneráveis simulados
└── windows/                   # Configurações Docker
    ├── compose.yml           # Docker Compose
    ├── Dockerfile           # Build personalizado
    └── system.config        # Configurações do sistema
```

## 🎓 Cenários de Uso Educacional

### Para Analistas de Segurança
- Análise de artefatos de ransomware
- Identificação de técnicas de persistência
- Investigação de exfiltração de dados
- Análise de logs de segurança

### Para Administradores de Sistema
- Resposta a incidentes de segurança
- Configuração de monitoramento
- Hardening de sistemas Windows
- Políticas de prevenção

### Para Estudantes de Cibersegurança
- Compreensão de ataques reais
- Prática de análise forense
- Desenvolvimento de scripts de detecção
- Estudo de comportamento de malware

## 📚 Referências Técnicas

- **dockur/windows**: https://github.com/dockur/windows
- **WinRM Protocol**: https://docs.microsoft.com/en-us/windows/win32/winrm/portal
- **PyWinRM Library**: https://pypi.org/project/pywinrm/
- **PowerShell Security**: https://docs.microsoft.com/en-us/powershell/scripting/security/

---

**⚠️ LEMBRE-SE: Este é um ambiente de LABORATÓRIO com vulnerabilidades intencionais para fins educacionais. NUNCA use em produção! ⚠️**
