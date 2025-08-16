# Scripts de Reset - Lab Vuln

## 🎯 **Visão Geral**

Este documento descreve os scripts de reset disponíveis no Lab Vuln para restaurar o ambiente ao seu estado inicial entre sessões de treinamento.

## 📋 **Scripts Disponíveis**

### 1. Reset Completo do Ambiente
- **Arquivo**: `reset-environment.sh`
- **Propósito**: Resetar todo o ambiente ao estado inicial
- **Escopo**: Todas as máquinas e componentes

### 2. Scripts de Reset Específicos de Máquina

#### Máquina Laravel (MAQ-2)
- **Arquivo**: `MAQ-2/reset-laravel.sh`
- **Propósito**: Resetar máquina de aplicação web Laravel
- **Requisitos**: Privilégios de root

#### Máquina Linux (MAQ-3)
- **Arquivo**: `MAQ-3/reset-linux.sh`
- **Propósito**: Resetar máquina de infraestrutura Linux
- **Requisitos**: Privilégios de root

#### SIEM Central
- **Arquivo**: `siem-central/reset-siem.sh`
- **Propósito**: Resetar ambiente SIEM central
- **Requisitos**: Privilégios de root

#### Simulações de Ataque
- **Arquivo**: `attack-simulations/reset-attacks.sh`
- **Propósito**: Resetar logs e dados de simulação de ataque
- **Requisitos**: Privilégios de usuário padrão

## 📖 **Instruções de Uso**

### Reset Completo do Ambiente

```bash
# Resetar ambiente completo
./reset-environment.sh
```

### Reset Individual de Máquina

```bash
# Resetar máquina Laravel (executar como root)
cd MAQ-2
sudo ./reset-laravel.sh

# Resetar máquina Linux (executar como root)
cd MAQ-3
sudo ./reset-linux.sh

# Resetar SIEM central (executar como root)
cd siem-central
sudo ./reset-siem.sh

# Resetar simulações de ataque
cd attack-simulations
./reset-attacks.sh
```

## 🔄 **O que Cada Script Reseta**

### Script Principal de Reset (`reset-environment.sh`)
- Containers Docker e volumes
- Dados e configurações SIEM
- Logs de simulação de ataque
- Dados específicos de máquina
- Arquivos de configuração
- Configurações de rede
- Arquivos temporários

### Reset Laravel (`reset-laravel.sh`)
- Containers Docker
- Dados de aplicação Laravel
- Dados de banco de dados
- Configurações de servidor web
- Configurações PHP
- Configurações SIEM
- Arquivos temporários

### Reset Linux (`reset-linux.sh`)
- Containers Docker
- Logs do sistema
- Configurações SSH
- Configurações FTP
- Configurações Samba
- Configurações SIEM

### Reset SIEM (`reset-siem.sh`)
- Containers SIEM
- Dados de logs
- Configurações de entrada
- Dashboards e alertas
- Usuários e permissões
- Configurações de rede

### Reset de Simulações (`reset-attacks.sh`)
- Logs de simulação
- Arquivos de dados de ataque
- Configurações de teste
- Artefatos de ataque
- Histórico de execução

## 🚀 **Execução Automática**

### Reset Programado
```bash
# Configurar reset automático a cada 24 horas
crontab -e

# Adicionar linha:
0 0 * * * /caminho/para/lab-vuln/reset-environment.sh
```

### Reset por Evento
```bash
# Reset após exercício específico
./reset-environment.sh --reason "exercicio_brute_force"

# Reset com backup
./reset-environment.sh --backup
```

## 📊 **Monitoramento de Reset**

### Logs de Reset
- Todos os resets são registrados em `reset-logs/`
- Formato: `reset-YYYYMMDD-HHMMSS.log`
- Inclui detalhes de todas as ações executadas

### Verificação de Reset
```bash
# Verificar status do último reset
./verify-reset.sh

# Verificar integridade dos dados
./verify-data-integrity.sh
```

## ⚠️ **Avisos Importantes**

### Antes do Reset
- **Fazer backup** de dados importantes
- **Documentar** configurações personalizadas
- **Notificar** usuários ativos
- **Verificar** recursos disponíveis

### Durante o Reset
- **Não interromper** o processo
- **Monitorar** logs de execução
- **Aguardar** conclusão completa
- **Verificar** status dos serviços

### Após o Reset
- **Verificar** funcionamento dos serviços
- **Testar** conectividade de rede
- **Validar** configurações SIEM
- **Confirmar** estado limpo

## 🔧 **Personalização**

### Configuração de Reset
```bash
# Editar configurações de reset
vim config/reset-config.conf

# Configurar retenção de dados
vim config/retention-policy.conf
```

### Scripts Personalizados
```bash
# Adicionar script de reset personalizado
cp template-reset.sh custom-reset.sh
chmod +x custom-reset.sh

# Editar para necessidades específicas
vim custom-reset.sh
```

## 📚 **Cenários de Uso**

### Treinamento Regular
- Reset diário para sessões limpas
- Reset semanal para manutenção
- Reset mensal para atualizações

### Exercícios Específicos
- Reset antes de cada cenário
- Reset após exercícios complexos
- Reset para demonstrações

### Manutenção
- Reset para correção de problemas
- Reset para atualizações de segurança
- Reset para limpeza de dados

## 🚨 **Procedimentos de Emergência**

### Reset de Emergência
```bash
# Reset imediato em caso de comprometimento
./emergency-reset.sh

# Reset com isolamento de rede
./emergency-reset.sh --isolate
```

### Recuperação de Falha
```bash
# Se o reset falhar
./recover-reset.sh

# Restaurar de backup
./restore-from-backup.sh
```

## 📞 **Suporte**

### Documentação
- **Configuração**: `config/README.md`
- **Troubleshooting**: `troubleshooting.md`
- **FAQ**: `faq.md`

### Contato
- **Issues**: GitHub Issues
- **Documentação**: Wiki do projeto
- **Comunidade**: Fórum de discussão

---

**Lembre-se**: Os scripts de reset são ferramentas poderosas. Use com cuidado e sempre faça backup antes de executar! 