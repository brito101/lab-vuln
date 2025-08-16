# Lab Vuln - Ambiente de Treinamento SOC

## Visão Geral

Lab Vuln é um ambiente abrangente de treinamento de Centro de Operações de Segurança (SOC) projetado para educação em cibersegurança e prática hands-on. O laboratório inclui máquinas vulneráveis, logging centralizado, cenários de resposta a incidentes, simulações de ataque, artefatos forenses e integrações SIEM para experiências completas de treinamento SOC.

## Arquitetura

O ambiente do laboratório consiste em:

- **MAQ-2**: Aplicação web Laravel com falhas de segurança
- **MAQ-3**: Infraestrutura Linux com configurações incorretas
- **SIEM Central**: Logging centralizado e monitoramento (Graylog, Elasticsearch, Wazuh)
- **Simulações de Ataque**: Cenários automatizados de ataque para treinamento
- **Artefatos Forenses**: Dumps de memória, logs de eventos e imagens de disco para análise
- **Integrações SIEM**: Suporte para Wazuh, ELK Stack, Splunk, Graylog, QRadar

## Início Rápido

### 1. Pré-requisitos

```bash
# Instalar Docker e Docker Compose
sudo apt update
sudo apt install docker.io docker-compose

# Adicionar usuário ao grupo docker
sudo usermod -aG docker $USER
```

### 2. Iniciar SIEM Central

```bash
cd siem-central
docker-compose up -d
./configure-graylog.sh
```

### 3. Configurar Máquinas

```bash
# Configurar todas as máquinas para encaminhamento SIEM
./configure-all-syslog.sh
```

### 4. Verificar Configuração

```bash
# Verificar configuração SIEM
./verify-siem-config.sh
```

### 5. Executar Simulações de Ataque

```bash
cd attack-simulations
./brute-force-simulation.sh
./lfi-simulation.sh
./ransomware-simulation.ps1
```

### 6. Criar Artefatos Forenses

```bash
# Artefatos Linux (executar como root)
cd MAQ-3 && sudo ./create-forensic-artifacts.sh
```

### 7. Configurar Plataformas SIEM Adicionais

```bash
# Configuração rápida para diferentes plataformas SIEM
sudo ./siem-quick-setup.sh
```

## Reset do Ambiente

Para múltiplas sessões de treinamento, use os scripts de reset para restaurar o ambiente ao seu estado inicial:

### Reset Completo do Ambiente

```bash
./reset-environment.sh
```

### Reset Individual de Máquina

```bash
# Máquina Laravel
cd MAQ-2 && sudo ./reset-laravel.sh

# Máquina Linux
cd MAQ-3 && sudo ./reset-linux.sh

# SIEM central
cd siem-central && sudo ./reset-siem.sh

# Simulações de ataque
cd attack-simulations && ./reset-attacks.sh
```

Para informações detalhadas sobre scripts de reset, veja [README-reset-scripts.md](README-reset-scripts.md).

## Componentes

### MAQ-2 (Aplicação Web Laravel)

- Aplicação Laravel com vulnerabilidades
- Endpoints de API com bypass de autenticação
- Vulnerabilidades LFI
- Integração SIEM

**Credenciais Padrão:**

- Admin: `admin/admin123`
- Usuário: `user/password123`

**Instruções de Implantação:** Veja [MAQ-2/deploy.sh](MAQ-2/deploy.sh) para script de implantação automatizada usando Docker/Sail. Use [MAQ-2/prepare-deploy-package.sh](MAQ-2/prepare-deploy-package.sh) para criar um pacote de implantação limpo. Para instruções de configuração detalhadas, veja [MAQ-2/README.md](MAQ-2/README.md).

### MAQ-3 (Infraestrutura Linux)

- Servidor Linux com configurações incorretas
- Serviços SSH, FTP e Samba
- Políticas de senha fracas
- Monitoramento de segurança
- **Artefatos Forenses**: Dumps de memória, logs do sistema, imagens de disco

**Credenciais Padrão:**

- Root: `root/root123`
- Usuário: `user/password123`

**Instruções de Configuração:** Veja [MAQ-3/README.md](MAQ-3/README.md) para instruções detalhadas de configuração e configuração.

### SIEM Central

- Graylog para agregação de logs
- Elasticsearch para armazenamento de dados
- Wazuh para monitoramento de segurança
- Logstash para processamento de dados

**Acesso:**

- Graylog: <http://192.168.1.102:9000> (admin/admin123)
- Wazuh: <http://192.168.1.102:5601> (admin/admin123)

## Cenários de Treinamento

### Cenários de Resposta a Incidentes

Veja [scenarios.md](scenarios.md) para cenários detalhados de resposta a incidentes:

- **Iniciante**: Detecção de brute force, alertas simples de malware
- **Intermediário**: Ameaças persistentes avançadas, exfiltração de dados
- **Avançado**: Ataques sofisticados, coordenação de incidentes

### Simulações de Ataque

Simulações automatizadas de ataque para treinamento:

- **Brute Force**: Ataques SSH, FTP e aplicação web
- **LFI**: Vulnerabilidades de Inclusão Local de Arquivo
- **Ransomware**: Simulação de criptografia de arquivos

Veja [attack-simulations/README.md](attack-simulations/README.md) para detalhes.

### Análise Forense

Artefatos forenses abrangentes para exercícios de análise:

- **Análise de Memória**: Dumps de processo, memória do kernel
- **Logs de Eventos**: Arquivos .evtx do Windows, logs do sistema Linux
- **Imagens de Disco**: Cópias lógicas de diretórios importantes
- **Análise de Linha do Tempo**: Linhas do tempo do sistema de arquivos
- **Artefatos de Rede**: Logs de conexão, regras de firewall

Veja [forensic-analysis-guide.md](forensic-analysis-guide.md) para instruções detalhadas de análise.

### Integrações SIEM

Múltiplas integrações de plataforma SIEM para treinamento abrangente:

- **Wazuh**: SIEM open-source com monitoramento baseado em agente
- **ELK Stack**: Elasticsearch, Logstash, Kibana para análise de big data
- **Splunk**: SIEM empresarial com analytics avançados
- **Graylog**: Plataforma de gerenciamento de logs open-source
- **QRadar**: SIEM empresarial IBM com capacidades de IA

Veja [siem-integration-examples.md](siem-integration-examples.md) para instruções detalhadas de integração e [siem-comparison-guide.md](siem-comparison-guide.md) para comparações de plataformas.

## Documentação

- [README-reset-scripts.md](README-reset-scripts.md) - Documentação dos scripts de reset
- [scenarios.md](scenarios.md) - Cenários de resposta a incidentes
- [attack-simulations/README.md](attack-simulations/README.md) - Guia de simulação de ataque
- [siem-integration-guide.md](siem-integration-guide.md) - Configuração e configuração SIEM
- [siem-integration-examples.md](siem-integration-examples.md) - Exemplos de integração SIEM
- [siem-comparison-guide.md](siem-comparison-guide.md) - Comparação de plataformas SIEM
- [forensic-analysis-guide.md](forensic-analysis-guide.md) - Guia de análise forense
- [default-credentials.md](default-credentials.md) - Credenciais padrão para todas as máquinas

## Configuração de Rede

### Endereços IP

- **SIEM Central**: 192.168.1.102
- **MAQ-2 (Laravel)**: 192.168.1.20
- **MAQ-3 (Linux)**: 192.168.1.30

### Portas

- **Graylog**: 9000 (Web), 12201 (Syslog)
- **Wazuh**: 5601 (Web), 1514 (Agente)
- **Elasticsearch**: 9200 (HTTP), 9300 (Transport)
- **Kibana**: 5601 (Web)
- **Splunk**: 8000 (Web), 8089 (Gerenciamento)
- **SSH**: 22
- **FTP**: 21
- **Samba**: 445, 139

## Artefatos Forenses

### Artefatos Linux (MAQ-3)

- **Dumps de Memória**: Dumps de memória do kernel e processo (.raw files)
- **Logs do Sistema**: Logs de autenticação, sistema, serviço
- **Logs de Auditoria**: Informações de trilha de auditoria
- **Artefatos de Rede**: Conexões de rede, regras de firewall
- **Informações de Processo**: Listas de processo, arquivos abertos, módulos carregados
- **Linha do Tempo**: Dados de linha do tempo do sistema de arquivos

### Ferramentas de Análise

- **Análise de Memória**: Volatility, Rekall
- **Logs de Eventos**: Visualizador de Eventos, Log Parser
- **Linha do Tempo**: Plaso, log2timeline
- **Rede**: Wireshark, NetworkMiner
- **Sistema de Arquivos**: The Sleuth Kit, Autopsy

## Suporte a Plataformas SIEM

### Plataformas Suportadas

- **Wazuh**: SIEM open-source com monitoramento abrangente
- **ELK Stack**: Analytics e visualização de big data
- **Splunk**: SIEM de nível empresarial com recursos avançados
- **Graylog**: Gerenciamento de logs open-source
- **QRadar**: SIEM empresarial IBM com capacidades de IA

### Recursos da Plataforma

- **Monitoramento em Tempo Real**: Todas as plataformas suportam análise de logs em tempo real
- **Gerenciamento de Alertas**: Sistemas de alerta e notificação personalizáveis
- **Inteligência de Ameaças**: Integração com feeds de inteligência de ameaças
- **Conformidade**: Monitoramento e relatórios de conformidade integrados
- **Análise Forense**: Capacidades avançadas de busca e correlação

### Configuração Rápida

```bash
# Configurar qualquer plataforma SIEM
sudo ./siem-quick-setup.sh

# Escolher do menu:
# 1. Wazuh
# 2. ELK Stack
# 3. Graylog
# 4. Splunk
# 5. Ambiente Multi-SIEM
```

## Considerações de Segurança

⚠️ **IMPORTANTE**: Este é um ambiente de treinamento com vulnerabilidades intencionais. Não implante em ambientes de produção.

### Medidas de Segurança

- Ambiente de rede isolado
- Sem acesso à internet para máquinas vulneráveis
- Simulações de ataque controladas
- Capacidades de reset para estado limpo
- Artefatos forenses para treinamento de análise
- Suporte multi-SIEM para monitoramento abrangente

### Melhores Práticas

- Use rede de treinamento dedicada
- Resets regulares do ambiente
- Monitore para acesso não autorizado
- Faça backup de dados importantes antes dos resets
- Mantenha cadeia de custódia para artefatos forenses
- Teste integrações SIEM completamente

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
# Verificar conectividade de rede
ping 192.168.1.102

# Verificar rede Docker
docker network ls
```

#### Problemas SIEM

```bash
# Verificar containers SIEM
cd siem-central && docker-compose ps

# Verificar logs SIEM
docker-compose logs

# Testar conectividade SIEM
./siem-tests/test-wazuh.sh
./siem-tests/test-elk.sh
./siem-tests/test-graylog.sh
```

#### Problemas de Artefatos Forenses

```bash
# Verificar criação de artefatos
ls -la MAQ-3/forensic-artifacts/

# Verificar integridade de artefatos
md5sum MAQ-3/forensic-artifacts/*.raw
```

### Reset do Ambiente

Se o ambiente se tornar instável:

```bash
# Reset completo
./reset-environment.sh

# Reiniciar serviços
cd siem-central && docker-compose up -d
./configure-all-syslog.sh
```

## Contribuindo

Para contribuir com o Lab Vuln:

1. Siga as melhores práticas de segurança
2. Teste todas as mudanças em ambiente isolado
3. Atualize a documentação
4. Inclua capacidades de reset para novos componentes
5. Adicione artefatos forenses para novas máquinas
6. Suporte plataformas SIEM adicionais

## Licença

Este projeto é apenas para fins educacionais. Use de forma responsável e apenas em ambientes de treinamento controlados.

## Suporte

Para problemas e perguntas:

1. Verifique a seção de solução de problemas
2. Revise arquivos de log
3. Consulte a documentação
4. Use scripts de reset se necessário
5. Consulte o guia de análise forense para análise de artefatos
6. Verifique guias de integração SIEM para problemas específicos de plataforma

---

**Lab Vuln** - Ambiente Abrangente de Treinamento SOC com Análise Forense e Capacidades Multi-SIEM
