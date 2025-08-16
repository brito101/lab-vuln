# Lab Vuln - Ambiente de Treinamento de Segurança

## Visão Geral

Lab Vuln é um ambiente de treinamento de segurança projetado para educação em cibersegurança e prática hands-on. O laboratório inclui máquinas vulneráveis configuradas intencionalmente para treinamento em detecção de ataques, análise de logs e técnicas de penetração.

## Arquitetura

O ambiente do laboratório consiste em:

- **MAQ-2**: Aplicação web Laravel com falhas de segurança intencionais
- **MAQ-3**: Infraestrutura Linux com configurações vulneráveis

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

### 3. Verificar Status

```bash
# Status MAQ-2
cd MAQ-2 && ./maquina2-setup.sh status

# Status MAQ-3
cd MAQ-3 && ./maquina3-setup.sh status
```

## Componentes

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

## Logs e Monitoramento

### Logs Expostos para Análise

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

### Coleta de Logs

Os logs são expostos via volumes Docker para permitir coleta por agentes de monitoramento externos (Elastic, Logstash, etc.).

## Cenários de Treinamento

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

### Análise de Logs

- Detecção de tentativas de login
- Identificação de padrões de ataque
- Correlação de eventos
- Análise de tráfego de rede

## Reset do Ambiente

Para múltiplas sessões de treinamento, use os scripts de reset para restaurar o ambiente ao seu estado inicial:

### Reset Completo

```bash
# MAQ-2
cd MAQ-2 && ./maquina2-setup.sh clean

# MAQ-3
cd MAQ-3 && ./maquina3-setup.sh clean
```

### Reset Individual

```bash
# Parar ambiente
./maquina2-setup.sh stop    # ou maquina3-setup.sh stop

# Reiniciar ambiente
./maquina2-setup.sh start   # ou maquina3-setup.sh start
```

## Configuração de Rede

### Endereços IP

- **MAQ-2**: 192.168.201.0/24 (rede Docker)
- **MAQ-3**: 192.168.200.0/24 (rede Docker)

### Portas Principais

- **MAQ-2**: 80 (HTTP), 3306 (MySQL), 6379 (Redis)
- **MAQ-3**: 2222 (SSH), 2121 (FTP), 139/445 (Samba)

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

# Remover rede conflitante
docker network rm soc-network
```

#### Problemas de Deploy

```bash
# Limpar ambiente
./maquina2-setup.sh clean    # ou maquina3-setup.sh clean

# Deploy novamente
./maquina2-setup.sh deploy   # ou maquina3-setup.sh deploy
```

### Reset do Ambiente

Se o ambiente se tornar instável:

```bash
# Reset completo
./maquina2-setup.sh clean    # ou maquina3-setup.sh clean

# Deploy novamente
./maquina2-setup.sh deploy   # ou maquina3-setup.sh deploy
```

## Documentação

- [MAQ-2/README.md](MAQ-2/README.md) - Documentação completa do laboratório Laravel
- [MAQ-3/README.md](MAQ-3/README.md) - Documentação completa do laboratório Linux

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

**Lab Vuln** - Ambiente de Treinamento de Segurança com Laboratórios MAQ-2 (Laravel) e MAQ-3 (Linux)
