# SIEM Central - Lab Vuln

Este diretório contém a configuração do SIEM central para receber logs de todas as máquinas do laboratório.

## 🎯 Objetivo

Centralizar logs de todas as máquinas vulneráveis para:
- Análise de segurança em tempo real
- Detecção de ataques e anomalias
- Treinamento em análise de logs
- Exercícios de SOC (Security Operations Center)

## 🏗️ Arquitetura

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   MAQ-1     │    │   MAQ-2     │    │   MAQ-3     │
│  (Windows)  │    │  (Laravel)  │    │   (Linux)   │
└─────────────┘    └─────────────┘    └─────────────┘
       │                   │                   │
       └───────────────────┼───────────────────┘
                           │
                    ┌─────────────┐
                    │   SIEM      │
                    │  Central    │
                    │ (Graylog/   │
                    │  Wazuh)     │
                    └─────────────┘
```

## 🚀 Inicialização

### 1. Iniciar o SIEM Central
```bash
cd siem-central
docker-compose up -d
```

### 2. Acessar as Interfaces
- **Graylog**: http://localhost:9000
  - Usuário: admin
  - Senha: admin
- **Wazuh**: http://localhost:1515 (se configurado)

### 3. Configurar Inputs
Após acessar o Graylog:
1. Vá em System > Inputs
2. Adicione um input Syslog UDP na porta 1514
3. Adicione um input GELF UDP na porta 12201

## 📊 Configuração de Logs por Máquina

### MAQ-1 (Windows AD)
```powershell
# Configurar envio de logs para SIEM
# Adicionar ao script install-ad-lab.ps1
$SIEM_IP = "192.168.1.100"  # IP do SIEM
$SIEM_PORT = "1514"

# Configurar Windows Event Forwarding
wecutil qc /q
winrm quickconfig
```

### MAQ-2 (Laravel)
```bash
# Configurar rsyslog para enviar logs Laravel
echo "*.* @192.168.1.100:1514" >> /etc/rsyslog.conf
systemctl restart rsyslog
```

### MAQ-3 (Linux)
```bash
# Configurar rsyslog para enviar logs do sistema
echo "*.* @192.168.1.100:1514" >> /etc/rsyslog.conf
systemctl restart rsyslog
```

## 🔍 Logs Enviados

### MAQ-1 (Windows)
- Eventos de autenticação (4624, 4625)
- Criação de processos (4688)
- Modificações de tarefas agendadas
- Logs de Active Directory
- Eventos de ransomware (simulação)

### MAQ-2 (Laravel)
- Logs de acesso web (Nginx/Apache)
- Logs de aplicação Laravel
- Tentativas de LFI
- Uploads de arquivos
- Mudanças de roles

### MAQ-3 (Linux)
- Logs de autenticação SSH
- Logs de acesso FTP
- Logs de acesso Samba
- Logs do sistema (syslog)

## 🎯 Cenários de Treinamento

### 1. Detecção de Ataques
- Monitorar tentativas de brute force
- Detectar uploads suspeitos
- Identificar tentativas de LFI
- Monitorar eventos de ransomware

### 2. Análise de Logs
- Correlacionar eventos entre máquinas
- Identificar padrões de ataque
- Analisar sequência de eventos
- Criar dashboards de monitoramento

### 3. Resposta a Incidentes
- Investigar alertas em tempo real
- Documentar incidentes
- Criar playbooks de resposta
- Treinar escalação de incidentes

## 🛠️ Ferramentas Incluídas

### Graylog
- Interface web para análise de logs
- Dashboards personalizáveis
- Alertas configuráveis
- Pesquisa avançada de logs

### Wazuh
- Detecção de intrusão
- Análise de integridade
- Monitoramento de logs
- Resposta a incidentes

### Logstash
- Processamento de logs
- Filtros personalizáveis
- Transformação de dados
- Integração com Elasticsearch

## 📈 Dashboards Sugeridos

### Dashboard de Segurança Geral
- Tentativas de login falhadas
- Uploads de arquivos
- Acessos a arquivos sensíveis
- Eventos de ransomware

### Dashboard de Performance
- Uso de recursos por máquina
- Latência de rede
- Erros de aplicação
- Disponibilidade de serviços

### Dashboard de Ataques
- Tentativas de brute force
- Exploração de vulnerabilidades
- Movimento lateral
- Exfiltração de dados

## 🔧 Configuração Avançada

### Alertas
```javascript
// Exemplo de alerta para brute force
{
  "condition": "count > 5",
  "field": "source",
  "time": "5 minutes",
  "message": "Possible brute force attack detected"
}
```

### Filtros
```javascript
// Exemplo de filtro para eventos de ransomware
{
  "field": "message",
  "value": "encrypted",
  "action": "highlight"
}
```

## 🚨 Troubleshooting

### Problemas Comuns
1. **Logs não aparecem**: Verificar conectividade de rede
2. **SIEM não inicia**: Verificar recursos disponíveis (mínimo 4GB RAM)
3. **Portas em uso**: Alterar portas no docker-compose.yml

### Comandos Úteis
```bash
# Verificar status dos containers
docker-compose ps

# Ver logs do SIEM
docker-compose logs -f graylog

# Reiniciar serviços
docker-compose restart

# Backup dos dados
docker-compose down
tar -czf siem-backup.tar.gz graylog_data mongo_data es_data
```

## 📚 Próximos Passos

1. **Configurar alertas** para eventos críticos
2. **Criar dashboards** específicos para cada cenário
3. **Implementar playbooks** de resposta a incidentes
4. **Treinar equipe** no uso das ferramentas
5. **Documentar procedimentos** de análise

---

**Nota**: Este SIEM é para fins educacionais. Em produção, use soluções empresariais adequadas. 