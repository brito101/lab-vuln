# MAQ-2 - Ambiente Laravel Vulnerável para Treinamento SOC

Este ambiente é **INTENCIONALMENTE VULNERÁVEL** para treinamento de incident response e segurança. **NÃO USE EM PRODUÇÃO!**

## 🚀 **Visão Geral**

O MAQ-2 é um ambiente de treinamento que simula uma aplicação Laravel vulnerável com múltiplas falhas de segurança configuradas intencionalmente para permitir que os alunos pratiquem técnicas de detecção, análise e resposta a incidentes.

## 🏗️ **Arquitetura**

```
┌─────────────────────────────────────────────────────────────┐
│                    MAQ-2 - Ambiente Laravel                 │
├─────────────────────────────────────────────────────────────┤
│  • Container Principal (Ubuntu + Nginx + PHP-FPM)          │
│  • MySQL 8.0 (Porta 8081)                                  │
│  • Redis (Porta 8082)                                       │
│  • Meilisearch (Porta 8083)                                 │
│  • Mailpit (Portas 8084/8085)                               │
│  • Selenium (Porta 8086)                                    │
│  • Syslog (Porta 8087)                                      │
└─────────────────────────────────────────────────────────────┘
```

## 🎯 **Vulnerabilidades Configuradas**

### **Aplicação Web (Laravel)**
- ✅ **Debug Mode Habilitado** - Exposição de informações sensíveis
- ✅ **Upload de Arquivos Sem Validação** - Possibilidade de upload de webshells
- ✅ **Arquivo .env Exposto** - Acesso direto a configurações sensíveis
- ✅ **Permissões 777 em Storage** - Escrita em diretórios críticos
- ✅ **LFI (Local File Inclusion)** - Leitura de arquivos do sistema
- ✅ **Logs Expostos** - Acesso direto a logs da aplicação

### **Container e Sistema**
- ✅ **Docker Socket Exposto** - Escape de container via Docker
- ✅ **Container Privilegiado** - Acesso elevado ao host
- ✅ **Capabilities Perigosas** - SYS_ADMIN, NET_ADMIN, SYS_PTRACE, DAC_READ_SEARCH
- ✅ **Security Options Desabilitadas** - seccomp:unconfined, apparmor:unconfined

## 🚀 **Deploy Rápido**

### **1. Deploy Completo**
```bash
./maquina2-setup.sh deploy
```

### **2. Gerenciamento do Ambiente**
```bash
# Iniciar
./maquina2-setup.sh start

# Parar
./maquina2-setup.sh stop

# Reiniciar
./maquina2-setup.sh restart

# Ver status
./maquina2-setup.sh status

# Monitorar logs
./maquina2-setup.sh logs

# Acessar container
./maquina2-setup.sh shell

# Limpar ambiente
./maquina2-setup.sh clean

# Ver informações de ataque
./maquina2-setup.sh attack-info
```

## 🌐 **Serviços Disponíveis**

| Serviço | Porta | Descrição |
|---------|-------|-----------|
| **Web (Laravel)** | 8080 | Aplicação principal vulnerável |
| **MySQL** | 8081 | Banco de dados |
| **Redis** | 8082 | Cache e sessões |
| **Meilisearch** | 8083 | Motor de busca |
| **Mailpit SMTP** | 8084 | Servidor de email |
| **Mailpit Dashboard** | 8085 | Interface de email |
| **Selenium** | 8086 | Automação de navegador |
| **Syslog** | 8087 | Coleta de logs |

## 📊 **Logs Expostos para Elastic**

### **Estrutura de Diretórios**
```
logs/
├── system/           # Logs do sistema
├── nginx/            # Logs do Nginx
│   ├── access.log    # Acessos HTTP
│   └── error.log     # Erros HTTP
├── php/              # Logs do PHP
│   ├── error.log     # Erros PHP
│   └── fpm.log       # Logs PHP-FPM
├── laravel/          # Logs do Laravel
│   ├── laravel.log   # Log principal
│   └── queue.log     # Log de filas
├── mysql/            # Logs do MySQL
├── redis/            # Logs do Redis
├── meilisearch/      # Logs do Meilisearch
├── mailpit/          # Logs do Mailpit
├── selenium/         # Logs do Selenium
├── app/              # Logs da aplicação
│   ├── application.log
│   └── security.log
├── access/           # Logs de acesso
├── error/            # Logs de erro
└── debug/            # Logs de debug
```

### **Arquivos Importantes para SIEM**
- `logs/nginx/access.log` - Todos os acessos HTTP
- `logs/nginx/error.log` - Erros HTTP e tentativas de ataque
- `logs/laravel/laravel.log` - Logs da aplicação Laravel
- `logs/app/security.log` - Eventos de segurança
- `logs/system/syslog` - Logs do sistema operacional

## 🔓 **Vetores de Ataque**

### **1. Upload de Webshells**
```bash
# Acessar diretório de uploads
http://localhost:8080/uploads/

# Upload de arquivo PHP malicioso
# O sistema aceita qualquer tipo de arquivo
```

### **2. Acesso Direto ao .env**
```bash
# Acessar arquivo de configuração
http://localhost:8080/.env

# Contém credenciais de banco e chaves da aplicação
```

### **3. LFI (Local File Inclusion)**
```bash
# Via visualizador de arquivos da aplicação
http://localhost:8080/admin/system/file?file=../../../etc/passwd

# Via API de logs
http://localhost:8080/admin/system/log?file=../../../var/log/nginx/access.log
```

### **4. Escape de Container**
```bash
# Acessar container
docker exec -it maquina2-soc bash

# Verificar Docker socket
ls -la /var/run/docker.sock

# Tentar escape
docker run --rm -it --privileged -v /:/host ubuntu:latest chroot /host bash
```

### **5. Manipulação de Permissões**
```bash
# Dentro do container
chmod 777 /var/www/html/storage/
chmod 777 /var/www/html/bootstrap/cache/
```

## 🧪 **Scripts de Teste**

### **1. Teste de Ataques**
```bash
# Executar todos os testes
./attack-test.sh

# Este script testa:
# • Acesso a arquivos sensíveis
# • Upload de arquivos maliciosos
# • LFI (Local File Inclusion)
# • SQL Injection
# • XSS (Cross-Site Scripting)
# • Directory Traversal
# • Command Injection
# • Acesso a APIs
# • Brute Force
```

### **2. Demonstração de Escape de Container**
```bash
# Acessar container
docker exec -it maquina2-soc bash

# Executar demonstração completa
./container-escape-demo.sh all

# Ou técnicas específicas
./container-escape-demo.sh docker      # Escape via Docker socket
./container-escape-demo.sh capabilities # Exploiting capabilities
./container-escape-demo.sh privileged  # Exploiting privileged mode
./container-escape-demo.sh laravel     # Exploiting Laravel vulnerabilities
./container-escape-demo.sh web         # Web application vulnerabilities
./container-escape-demo.sh filesystem  # File system access
```

## 🔑 **Credenciais Padrão**

### **Usuários da Aplicação**
- **Administrador**: `admin@estagio.com` / `12345678`
- **Programador**: `programador@estagio.com` / `12345678`
- **Franquiado 1**: `franquia1@estagio.com` / `12345678`
- **Franquiado 2**: `franquia2@estagio.com` / `12345678`
- **Franquiado 3**: `franquia3@estagio.com` / `12345678`
- **Estagiário**: `estagiario@estagio.com` / `12345678`

### **Banco de Dados**
- **Host**: `localhost:8081`
- **Database**: `laravel`
- **Usuário**: `sail`
- **Senha**: `password`

## 📝 **Comandos Úteis**

### **Monitoramento de Logs**
```bash
# Logs em tempo real
tail -f logs/nginx/access.log logs/laravel/laravel.log logs/app/application.log

# Logs específicos
tail -f logs/nginx/error.log          # Erros HTTP
tail -f logs/php/error.log            # Erros PHP
tail -f logs/laravel/laravel.log      # Logs Laravel
tail -f logs/app/security.log         # Eventos de segurança
```

### **Gerenciamento de Container**
```bash
# Status dos containers
docker-compose ps

# Logs dos containers
docker-compose logs -f

# Reiniciar serviços
docker-compose restart

# Parar ambiente
docker-compose down
```

### **Acesso ao Container**
```bash
# Shell do container principal
docker exec -it maquina2-soc bash

# Shell dos serviços auxiliares
docker exec -it maquina2-mysql bash
docker exec -it maquina2-redis bash
```

## 🎯 **Cenários de Treinamento**

### **1. Detecção de Uploads Maliciosos**
- Monitorar logs de upload
- Detectar arquivos PHP suspeitos
- Analisar payloads de ataque

### **2. Análise de Tentativas de LFI**
- Identificar padrões de path traversal
- Correlacionar com logs de acesso
- Detectar tentativas de acesso a arquivos sensíveis

### **3. Monitoramento de Escape de Container**
- Logs de tentativas de execução de comandos
- Acesso ao Docker socket
- Manipulação de capabilities

### **4. Análise de Ataques Web**
- SQL Injection em formulários
- XSS em campos de entrada
- Directory Traversal em APIs

## ⚠️ **Avisos de Segurança**

- **Este ambiente é INTENCIONALMENTE VULNERÁVEL**
- **NUNCA use estas configurações em produção**
- **Isolado em rede Docker para segurança**
- **Apenas para treinamento e laboratório**

## 🔧 **Troubleshooting**

### **Problemas Comuns**

1. **Container não inicia**
   ```bash
   docker-compose logs maquina2
   ./maquina2-setup.sh clean
   ./maquina2-setup.sh deploy
   ```

2. **Serviços não respondem**
   ```bash
   ./maquina2-setup.sh status
   docker exec -it maquina2-soc service nginx status
   docker exec -it maquina2-soc service php8.1-fpm status
   ```

3. **Logs não são gerados**
   ```bash
   docker exec -it maquina2-soc ls -la /var/log/
   docker exec -it maquina2-soc service rsyslog status
   ```

### **Verificação de Saúde**
```bash
# Verificar todos os serviços
./maquina2-setup.sh status

# Verificar conectividade
curl -v http://localhost:8080
nc -zv localhost 8081 8082 8083

# Verificar logs
ls -la logs/*/*.log
```

## 📚 **Recursos de Aprendizado**

- **OWASP Top 10** - Vulnerabilidades web
- **Docker Security** - Escape de containers
- **Laravel Security** - Boas práticas de segurança
- **SIEM Analysis** - Análise de logs de segurança

## 🆘 **Suporte**

Para dúvidas ou problemas:
1. Verificar logs do sistema
2. Consultar documentação
3. Executar `./maquina2-setup.sh attack-info`
4. Contatar instrutor do laboratório

---

**⚠️ LEMBRE-SE: Este ambiente é para TREINAMENTO apenas! ⚠️** 