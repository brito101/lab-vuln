# SIEM Central - Lab Vuln

## 🎯 **Visão Geral**

O SIEM Central é o componente central de monitoramento e análise de logs do Lab Vuln. Ele fornece uma plataforma unificada para coleta, processamento e análise de logs de todas as máquinas vulneráveis, permitindo detecção de ataques em tempo real e análise forense.

## 🏗️ **Arquitetura**

```
┌─────────────┐    ┌─────────────┐
│   MAQ-2     │    │   MAQ-3     │
│  (Laravel)  │    │   (Linux)   │
└─────────────┘    └─────────────┘
       │                   │
       └───────────────────┘
                │
         ┌─────────────┐
         │   SIEM      │
         │  Central    │
         │ (Graylog/   │
         │  Wazuh)     │
         └─────────────┘
```

## 🚀 **Inicialização**

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

## 📊 **Configuração de Logs por Máquina**

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

## 🔍 **Logs Enviados**

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

## 🎯 **Cenários de Treinamento**

### 1. Detecção de Ataques
- Monitorar tentativas de brute force
- Detectar uploads suspeitos
- Identificar tentativas de LFI
- Monitorar eventos de ransomware

### 2. Análise de Logs
- Correlação de eventos entre máquinas
- Análise de padrões de ataque
- Investigação de incidentes
- Criação de dashboards personalizados

### 3. Resposta a Incidentes
- Configuração de alertas automáticos
- Escalação de incidentes
- Documentação de resposta
- Análise pós-incidente

## 🔐 **Considerações de Segurança**

### Ambiente de Laboratório
- SIEM configurado apenas para uso em laboratório
- Autenticação mínima para facilidade de uso
- Sem criptografia entre máquinas e SIEM
- Credenciais padrão para todos os serviços

### Considerações de Produção
- Habilitar autenticação e criptografia
- Usar senhas fortes e únicas
- Implementar controles de acesso apropriados
- Atualizações de segurança regulares
- Segmentação de rede
- Procedimentos de backup e recuperação

## 📋 **Checklist**

### Pré-Configuração
- [ ] Docker e Docker Compose instalados
- [ ] Pelo menos 4GB RAM disponível
- [ ] Pelo menos 10GB espaço em disco
- [ ] Ambiente de rede isolado
- [ ] Todas as máquinas funcionando

### Configuração SIEM
- [ ] Containers SIEM iniciados
- [ ] Graylog acessível em http://localhost:9000
- [ ] Inputs configurados no Graylog
- [ ] Logs de teste recebidos

### Configuração de Máquina
- [ ] MAQ-2 (Laravel) configurada
- [ ] MAQ-3 (Linux) configurada
- [ ] Encaminhamento de logs funcionando
- [ ] Monitoramento de segurança ativo

### Verificação
- [ ] Todos os serviços funcionando
- [ ] Logs aparecendo no SIEM
- [ ] Dashboards criados
- [ ] Alertas configurados
- [ ] Cenários de treinamento funcionando

## 📞 **Suporte**

### Documentação
- SIEM Central: `siem-central/README.md`
- Específica de máquina: `MAQ-X/README.md`
- Credenciais: `siem-central/default-credentials.md`

### Scripts
- Configuração Rápida: `./quick-setup-siem.sh`
- Configuração: `./configure-all-syslog.sh`
- Verificação: `./verify-siem-config.sh`

### Logs
- Logs SIEM: `siem-central/docker-compose logs`
- Logs de Máquina: Verificar diretórios individuais de máquina
- Logs de Configuração: `/var/log/` em máquinas Linux

---

**Lembre-se**: Esta configuração SIEM é para fins educacionais. Em produção, sempre implemente medidas de segurança apropriadas! 