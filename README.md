# Lab Vuln - Ambiente de Treinamento de Segurança

## Visão Geral

Lab Vuln é um ambiente de treinamento de segurança projetado para educação em cibersegurança e prática hands-on. O laboratório inclui máquinas vulneráveis configuradas intencionalmente para treinamento em detecção de ataques, análise de logs e técnicas de penetração.

## Arquitetura

O ambiente do laboratório consiste em:

- **MAQ-1**: Windows Server 2022 Domain Controller com Active Directory vulnerável
- **MAQ-2**: Aplicação web Laravel com falhas de segurança intencionais
- **MAQ-3**: Infraestrutura Linux com configurações vulneráveis
- **MAQ-4**: Zimbra Collaboration Suite vulnerável à CVE-2024-45519 (RCE via SMTP)
- **MAQ-5**: Ambiente Linux/Wordpress vulnerável para simulação de ataques web e automação

## Build do svcmon.go (Monitor de Serviços)

Se quiser modificar ou recompilar o binário `svcmon-linux` para os labs, basta rodar:

```bash
go build -o svcmon-linux svcmon.go
```

Para Windows:

```bash
GOOS=windows GOARCH=amd64 go build -o svcmon-win.exe svcmon.go
```

O binário gerado pode ser copiado para a pasta `artefatos/` de cada lab conforme necessário.

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

#### MAQ-1 (Windows Server 2022 DC)
```bash
cd MAQ-1
./setup.sh deploy      # Deploy completo
./setup.sh start       # Iniciar ambiente
./setup.sh stop        # Parar ambiente
./setup.sh restart     # Reiniciar ambiente
./setup.sh status      # Ver status
./setup.sh logs        # Monitorar logs
./setup.sh clean       # Limpar ambiente
./setup.sh attack-info # Informações de ataque
```
#### MAQ-2 (Laravel)
```bash
cd MAQ-2
./setup.sh deploy      # Deploy completo
./setup.sh start       # Iniciar ambiente
./setup.sh stop        # Parar ambiente
./setup.sh restart     # Reiniciar ambiente
./setup.sh status      # Ver status
./setup.sh logs        # Monitorar logs
./setup.sh clean       # Limpar ambiente
./setup.sh shell       # Acessar container
./setup.sh attack-info # Informações de ataque
```
#### MAQ-3 (Linux)
```bash
cd MAQ-3
./setup.sh deploy      # Deploy completo
./setup.sh start       # Iniciar ambiente
./setup.sh stop        # Parar ambiente
./setup.sh restart     # Reiniciar ambiente
./setup.sh status      # Ver status
./setup.sh logs        # Monitorar logs
./setup.sh clean       # Limpar ambiente
./setup.sh shell       # Acessar container
./setup.sh attack-info # Informações de ataque
```
#### MAQ-4 (Zimbra CVE-2024-45519)
```bash
cd MAQ-4
./setup.sh deploy      # Deploy completo
./setup.sh start       # Iniciar ambiente
./setup.sh stop        # Parar ambiente
./setup.sh restart     # Reiniciar ambiente
./setup.sh status      # Ver status
./setup.sh logs        # Monitorar logs
./setup.sh clean       # Limpar ambiente
./setup.sh info        # Informações do lab
```
#### MAQ-5 (Linux/Wordpress)
```bash
cd MAQ-5
./setup.sh deploy      # Deploy completo
./setup.sh start       # Iniciar ambiente
./setup.sh stop        # Parar ambiente
./setup.sh restart     # Reiniciar ambiente
./setup.sh status      # Ver status
./setup.sh logs        # Monitorar logs
./setup.sh clean       # Limpar ambiente
./setup.sh shell       # Acessar container
./setup.sh attack-info # Informações de ataque
```
### 3. Verificar Status

```bash
# Status MAQ-1
cd MAQ-1 && ./setup.sh status

# Status MAQ-2
cd MAQ-2 && ./setup.sh status

# Status MAQ-3
cd MAQ-3 && ./setup.sh status

# Status MAQ-4
cd MAQ-4 && ./setup.sh status

# Status MAQ-5
cd MAQ-5 && ./setup.sh status
```

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

## Documentação

- [MAQ-1/README.md](MAQ-1/README.md) - Documentação completa do laboratório Windows Server 2022 DC
- [MAQ-2/README.md](MAQ-2/README.md) - Documentação completa do laboratório Laravel
- [MAQ-3/README.md](MAQ-3/README.md) - Documentação completa do laboratório Linux
- [MAQ-4/README.md](MAQ-4/README.md) - Documentação completa do laboratório Zimbra CVE-2024-45519
- [MAQ-5/README.md](MAQ-5/README.md) - Documentação completa do laboratório Linux/Wordpress

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

**Lab Vuln** - Ambiente de Treinamento de Segurança com Laboratórios MAQ-1 (Windows Server 2022 DC), MAQ-2 (Laravel), MAQ-3 (Linux), MAQ-4 (Zimbra CVE-2024-45519) e MAQ-5 (WordPress)

## Artefatos Dinâmicos Simulados

Este laboratório inclui artefatos automatizados para simular cenários reais de ataque e gerar ruído para análise SOC. Todos são ativados automaticamente ao subir os ambientes.

### Restauração de Arquivos Criptografados
- **Linux**: Execute `/usr/local/bin/ransomware_restore_linux.sh` no container.
- **Windows**: Execute `powershell.exe -File C:\VulnerableFiles\ransomware_restore_win.ps1`.

### Análise e Detecção
- Todos os artefatos geram logs específicos para facilitar a investigação.
- Os webshells podem ser acessados via navegador e comandos podem ser executados para simular invasão.
- Os scripts de flood, exfiltração e portscan geram ruído constante para análise de alertas e correlação.
