# Scripts de Simulação de Ataque - Lab Vuln

## 🎯 **Visão Geral**

Este diretório contém scripts automatizados de simulação de ataque para o ambiente Lab Vuln. Estes scripts são projetados para gerar padrões de ataque realistas para treinamento de analistas SOC e teste de detecção SIEM.

## ⚠️ **Avisos Importantes**

- **Todos os scripts são apenas para fins educacionais**
- **Nunca use estes scripts em ambientes de produção**
- **Sempre execute em ambientes de laboratório isolados**
- **Siga princípios de hacking ético**
- **Documente todas as atividades**

## 📋 **Simulações Disponíveis**

### **🟢 Cenários Iniciantes**

#### **1. Ataque de Força Bruta (`brute-force-simulation.sh`)**
- **Alvo**: MAQ-3 (Serviço SSH)
- **Duração**: 5 minutos
- **Técnica**: Força bruta SSH com credenciais comuns
- **Detecção**: Monitorar falhas de autenticação SSH
- **Resposta**: Bloquear IP de origem, implementar limitação de taxa

**Uso:**
```bash
cd attack-simulations
./brute-force-simulation.sh
```

**Detecção SIEM:**
```sql
source:MAQ-3 AND message:"authentication failure"
source:MAQ-3 AND message:"Failed password"
```

#### **2. Ataque LFI (`lfi-simulation.sh`)**
- **Alvo**: MAQ-2 (Aplicação Web Laravel)
- **Duração**: 10 minutos
- **Técnica**: Inclusão Local de Arquivo via travessia de caminho
- **Detecção**: Monitorar logs do servidor web para travessia de caminho
- **Resposta**: Bloquear IP, corrigir vulnerabilidades, adicionar regras WAF

**Uso:**
```bash
cd attack-simulations
./lfi-simulation.sh
```

**Detecção SIEM:**
```sql
source:MAQ-2 AND message:"../" OR message:"..\\"
source:MAQ-2 AND message:"file_get_contents" AND message:"error"
```

### **🔴 Cenários Avançados**

#### **3. Simulação de Ransomware (`ransomware-simulation.ps1`)**
- **Alvo**: Máquinas Windows (requer ambiente Windows)
- **Duração**: 5 minutos
- **Técnica**: Modificação de arquivos, mudanças de registro, comunicação C2
- **Detecção**: Monitorar mudanças de arquivo, criação de processo, conexões de rede
- **Resposta**: Isolar sistemas, alertar equipe de IR, restaurar de backups

**Uso:**
```powershell
cd attack-simulations
.\ransomware-simulation.ps1
```

**Detecção SIEM:**
```sql
source:Windows AND message:"encrypted" OR message:"ransom"
source:Windows AND event_id:4688 AND message:"ransomware"
source:Windows AND event_id:4657 AND message:"RansomwareSim"
```

## 🚀 **Início Rápido**

### **Pré-requisitos**
1. SIEM configurado e funcionando
2. Todas as máquinas configuradas para encaminhamento de logs
3. Conectividade de rede entre máquinas
4. Permissões apropriadas (admin/root)

### **Instruções de Configuração**
```bash
# 1. Configurar SIEM e máquinas
./configure-all-syslog.sh
./quick-setup-siem.sh

# 2. Verificar configuração
./verify-siem-config.sh

# 3. Executar simulações
cd attack-simulations
./brute-force-simulation.sh
./lfi-simulation.sh
# Para Windows: .\ransomware-simulation.ps1
```

### **Ordem de Execução**
1. **Iniciar SIEM** e verificar se está funcionando
2. **Configurar dashboards** no Graylog
3. **Executar simulação** em um terminal
4. **Monitorar SIEM** em outro terminal
5. **Documentar descobertas** e procedimentos de resposta

## 📊 **Monitoramento e Detecção**

### **Dashboards SIEM**
Crie estes dashboards no Graylog para monitoramento eficaz:

#### **Dashboard de Eventos de Segurança**
- Tentativas de autenticação falhadas
- Acesso suspeito a arquivos
- Eventos de criação de processo
- Conexões de rede

#### **Dashboard de Detecção de Ataque**
- Padrões de força bruta
- Tentativas LFI/RFI
- Indicadores de ransomware
- Comunicação C2

#### **Dashboard de Performance do Sistema**
- Uso de recursos
- Disponibilidade de serviço
- Tráfego de rede
- Taxas de erro

### **Regras de Alerta**
Configure estas regras de alerta no Graylog:

#### **Alerta de Força Bruta**
```javascript
// Alertar quando múltiplas tentativas SSH falhadas detectadas
{
  "condition": "count > 10",
  "field": "source_ip",
  "time": "5 minutes",
  "message": "Possível ataque de força bruta detectado"
}
```

#### **Alerta LFI**
```javascript
// Alertar quando travessia de caminho detectada
{
  "condition": "message contains '../'",
  "field": "source",
  "time": "1 minute",
  "message": "Tentativa de ataque LFI detectada"
}
```

#### **Alerta de Ransomware**
```javascript
// Alertar quando indicadores de criptografia detectados
{
  "condition": "message contains 'encrypted'",
  "field": "source",
  "time": "1 minute",
  "message": "Atividade de ransomware detectada"
}
```

## 📝 **Documentação e Logging**

### **Arquivos de Log**
Cada simulação cria arquivos de log detalhados:
- `brute-force-simulation-YYYYMMDD-HHMMSS.log`
- `lfi-simulation-YYYYMMDD-HHMMSS.log`
- `ransomware-simulation-YYYYMMDD-HHMMSS.log`

### **Conteúdo do Log**
- Parâmetros de ataque e configuração
- Detalhes de tentativa e resultados
- Estatísticas de sucesso/falha
- Timestamps e durações
- Instruções de detecção SIEM

### **Relatórios de Análise**
Após cada simulação, crie:
1. **Relatório de Detecção**: O que foi detectado e quando
2. **Relatório de Resposta**: Ações tomadas e sua eficácia
3. **Lições Aprendidas**: Melhorias para a próxima vez
4. **Recomendações**: Aprimoramentos de segurança

## 🛠️ **Personalização**

### **Modificando Parâmetros de Ataque**
Edite as variáveis de configuração em cada script:

#### **Script de Força Bruta**
```bash
TARGET_IP="192.168.1.103"  # Mudar IP alvo
ATTACK_DURATION=300         # Mudar duração
DELAY_BETWEEN_ATTEMPTS=2    # Mudar delay
```

#### **Script LFI**
```bash
TARGET_URL="http://192.168.1.102:8000"  # Mudar URL alvo
ATTACK_DURATION=600                      # Mudar duração
```

#### **Script de Ransomware**
```powershell
$SimulationDuration = 300  # Mudar duração
$TargetDirectories = @("C:\Users\Public\Documents")  # Mudar alvos
```

### **Adicionando Novas Simulações**
Para criar uma nova simulação:

1. **Criar script** com cabeçalhos e avisos apropriados
2. **Adicionar configuração** variáveis no topo
3. **Incluir funcionalidade** de logging
4. **Adicionar instruções** de detecção SIEM
5. **Documentar procedimentos** de resposta
6. **Testar completamente** em ambiente de laboratório

## 🔧 **Solução de Problemas**

### **Problemas Comuns**

#### **Scripts Não Funcionando**
- Verificar acessibilidade do alvo
- Verificar conectividade de rede
- Garantir permissões apropriadas
- Verificar arquivos de log para erros

#### **SIEM Não Detectando**
- Verificar se encaminhamento de logs está funcionando
- Verificar se entradas SIEM estão configuradas
- Testar com envio manual de logs
- Revisar consultas de busca

#### **Falsos Positivos**
- Ajustar limiares de detecção
- Refinar consultas de busca
- Atualizar regras de alerta
- Documentar padrões de falso positivo

### **Comandos de Debug**
```bash
# Testar conectividade do alvo
ping <target_ip>
nc -z <target_ip> <port>

# Testar conectividade SIEM
echo "<134>$(date '+%b %d %H:%M:%S') test: Test message" | nc -u localhost 1514

# Verificar encaminhamento de logs
systemctl status laravel-log-forwarder.service  # MAQ-2
systemctl status system-log-monitor.service     # MAQ-3

# Visualizar logs de simulação
tail -f *.log
```

## 📚 **Objetivos de Aprendizado**

### **Habilidades Técnicas**
- Análise de logs e correlação
- Reconhecimento de padrões de ataque
- Procedimentos de resposta a incidentes
- Configuração e monitoramento SIEM

### **Habilidades Interpessoais**
- Comunicação sob pressão
- Coordenação de equipe
- Tomada de decisão
- Documentação

### **Conhecimento de Segurança**
- Metodologias de ataque
- Técnicas de detecção
- Estratégias de resposta
- Medidas de prevenção

## 🚨 **Diretrizes de Segurança**

### **Antes de Executar Simulações**
1. **Verificar isolamento do laboratório**
2. **Verificar se todos os sistemas são apenas para laboratório**
3. **Garantir permissões apropriadas**
4. **Documentar hora de início**
5. **Preparar ferramentas de monitoramento**

### **Durante Simulações**
1. **Monitorar SIEM continuamente**
2. **Documentar todas as atividades**
3. **Seguir procedimentos de resposta**
4. **Comunicar com a equipe**
5. **Preservar evidências**

### **Após Simulações**
1. **Completar relatórios de incidente**
2. **Analisar eficácia da detecção**
3. **Identificar melhorias**
4. **Atualizar procedimentos**
5. **Compartilhar lições aprendidas**

## 📞 **Suporte**

### **Documentação**
- **Cenários**: `../scenarios.md`
- **Integração SIEM**: `../SIEM-INTEGRATION-GUIDE.md`
- **Configs de Máquina**: `../MAQ-X/README.md`

### **Scripts**
- **Configuração**: `../configure-all-syslog.sh`
- **Configuração SIEM**: `../quick-setup-siem.sh`
- **Verificação**: `../verify-siem-config.sh`

### **Procedimentos de Emergência**
- **Parar todas as atividades** se algo der errado
- **Documentar o que aconteceu**
- **Notificar instrutor/supervisor**
- **Seguir procedimentos de resposta a incidentes**
- **Preservar evidências para análise**

---

**Lembre-se**: Estas simulações são para aprendizado. Sempre pratique divulgação responsável e princípios de hacking ético! 