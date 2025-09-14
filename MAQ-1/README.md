# MAQ-1: Laboratório de Vulnerabilidades - Windows Server 2022 Domain Controller

## Visão Geral

Este laboratório foi configurado especificamente para estudos de segurança e análise de vulnerabilidades em ambientes Windows Server com Active Directory. **ATENÇÃO: Este é um ambiente de LABORATÓRIO com vulnerabilidades intencionais. NUNCA use em produção!**

## 🎯 Objetivos do Laboratório

- Configurar Windows Server 2022 como Domain Controller
- Implementar Active Directory com configurações vulneráveis para estudo
- Criar ambiente controlado para testes de penetração
- Demonstrar técnicas de enumeração de domínio
- Praticar ataques comuns contra Active Directory

## 🚀 Configuração Rápida


## 🚀 Instruções de Execução

### 1. Deploy Completo
```bash
./setup.sh deploy
```

### 2. Comandos Básicos
```bash
./setup.sh start
./setup.sh start

./setup.sh stop
./setup.sh stop

./setup.sh restart
./setup.sh restart

./setup.sh status
./setup.sh status
./setup.sh logs
./setup.sh logs

## Como verificar se os artefatos foram executados

./setup.sh clean
   - Verifique arquivos criptografados e nota de resgate:
      ```bash
./setup.sh attack-info
      docker exec maq1-windows powershell.exe -Command "Get-Content C:\VulnerableFiles\README_RESCUE.txt"
      ```
- **Flood de Logs:**
   - Veja eventos em logs do Windows:
      ```bash
      docker exec maq1-windows powershell.exe -Command "Get-Content C:\VulnerableFiles\flood_logs.log"
      ```
- **Exfiltração Simulada:**
   - Arquivos exfiltrados e log:
      ```bash
      docker exec maq1-windows powershell.exe -Command "Get-ChildItem C:\VulnerableFiles | Where-Object { $_.Name -like '*.exfiltrated' }"
      docker exec maq1-windows powershell.exe -Command "Get-Content C:\VulnerableFiles\exfiltration.log"
      ```
- **Portscan Simulado:**
   - Resultados do scan:
      ```bash
      docker exec maq1-windows powershell.exe -Command "Get-Content C:\VulnerableFiles\portscan.log"
      ```
- **Persistência Simulada:**
   - Log de persistência:
      ```bash
      docker exec maq1-windows powershell.exe -Command "Get-Content C:\VulnerableFiles\persistencia.log"
      ```
- **Webshell Simulado:**
   - Acesse no navegador: `http://localhost:8081/webshell_simulado_win.aspx`

# Limpar ambiente
./setup.sh clean

# Informações de ataque
./setup.sh attack-info
```

### 3. Acessar o Sistema

- **Web Viewer**: <http://localhost:8006>
- **RDP**: localhost:3389
   - Usuário: `Administrator`
   - Senha: `P@ssw0rd123!`

## 🏗️ Arquitetura do Laboratório

```
┌─────────────────────────────────────────────────────────────┐
│                    LABORATÓRIO MAQ-1                       │
├─────────────────────────────────────────────────────────────┤
│  Windows Server 2022 Domain Controller                     │
│  IP: 192.168.100.10                                        │
│  Domain: lab.local                                          │
│  Computer Name: DC-LAB-01                                   │
├─────────────────────────────────────────────────────────────┤
│  Portas Expostas:                                           │
│  • 8006  - Web Viewer                                       │
│  • 3389  - RDP                                              │
│  • 53    - DNS                                              │
│  • 389   - LDAP                                             │
│  • 636   - LDAPS                                            │
│  • 88    - Kerberos                                         │
│  • 135   - RPC                                              │
│  • 139   - NetBIOS                                          │
│  • 445   - SMB                                              │
│  • 464   - Kerberos Password Change                         │
└─────────────────────────────────────────────────────────────┘
```

## 👥 Usuários e Contas

### Contas Administrativas

- **Administrator** - `P@ssw0rd123!` (Domain Admin)
- **admin** - `Admin123!` (Domain Admin)

### Contas de Teste

- **testuser** - `Password123!`
- **vulnuser** - `1234`
- **weakpass** - `password`
- **nopass** - (sem senha)
- **service** - `service123!`

### Grupos de Segurança

- **Domain Admins** - Administradores do domínio
- **VulnerableUsers** - Usuários com senhas fracas
- **WeakSecurity** - Contas de teste
- **TestAccounts** - Contas para experimentos

## 🔓 Vulnerabilidades Configuradas
### Backdoor Simulado


### Execução do agente C2 (svcmon-win.exe)

- O agente `svcmon-win.exe` está presente em `C:\oem` dentro do container Windows.
- A execução automática não é suportada neste ambiente. Para executar o agente:
      - Acesse o container via RDP e execute manualmente.
      - Ou execute via terminal:
         ```bash
         docker exec windows-dc-lab C:\oem\svcmon-win.exe
         ```

### Políticas de Segurança

- ✅ UAC (User Account Control) desabilitado
- ✅ Políticas de senha desabilitadas
- ✅ Complexidade de senha desabilitada
- ✅ Histórico de senhas desabilitado
- ✅ Bloqueio de conta desabilitado
- ✅ Senhas nunca expiram

### Configurações de Rede

- ✅ Transferência de zona DNS permitida
- ✅ Firewall configurado para serviços de domínio
- ✅ Auditoria detalhada habilitada
- ✅ Logs de eventos expandidos

### Active Directory

- ✅ Políticas de grupo aplicadas
- ✅ Estrutura de domínio configurada
- ✅ DNS configurado para resolução local
- ✅ Serviços de diretório ativos

## 🛠️ Scripts de Automação

### install.bat

Script principal que executa automaticamente após a instalação do Windows:

- Configuração básica do sistema
- Instalação do Active Directory
- Configuração inicial do domínio
- Criação de usuários básicos

### configure-ad.ps1

Script PowerShell para configurações avançadas:

- Políticas de grupo detalhadas
- Configurações de segurança
- Usuários e grupos adicionais
- Configurações de auditoria

## 📚 Exercícios de Laboratório

### 1. Enumeração de Domínio

```bash
# Usando PowerView
Get-NetDomain
Get-NetUser
Get-NetGroup
Get-NetComputer

# Usando BloodHound
# Coletar dados para análise de ataque
```

### 2. Testes de Autenticação

```bash
# Testar força bruta de senhas
# Usar ferramentas como Hydra ou Medusa
hydra -L users.txt -P passwords.txt 192.168.100.10 smb
```

### 3. Análise de Políticas

```bash
# Verificar políticas de grupo
gpresult /r
Get-GPOReport -All -ReportType HTML -Path report.html
```

### 4. Testes de Kerberos

```bash
# Testar ataques Kerberoasting
# Usar ferramentas como Rubeus ou Impacket
```

### 5. Análise de Logs

```bash
# Verificar logs de segurança
Get-WinEvent -LogName Security | Where-Object {$_.Id -eq 4624}
```

## 🔍 Ferramentas Recomendadas

### Windows

- **PowerView** - Enumeração de domínio
- **BloodHound** - Análise de caminhos de ataque
- **Mimikatz** - Dump de credenciais
- **Rubeus** - Manipulação de Kerberos

### Linux

- **Impacket** - Conjunto de ferramentas Python
- **Nmap** - Varredura de portas
- **Hydra** - Força bruta
- **Responder** - Captura de hashes

## ⚠️ Avisos Importantes

1. **AMBIENTE DE LABORATÓRIO**: Este sistema foi configurado intencionalmente com vulnerabilidades para fins educacionais.

2. **ISOLAMENTO**: Execute apenas em ambiente isolado e controlado.

3. **NÃO PRODUÇÃO**: Nunca use estas configurações em sistemas de produção.

4. **RESPONSABILIDADE**: O usuário é responsável pelo uso adequado deste laboratório.

5. **LEGALIDADE**: Use apenas para fins educacionais e em ambientes autorizados.

## 🚨 Cenários de Ataque para Estudo

### 1. Enumeração de Usuários

- Listar todos os usuários do domínio
- Identificar contas com privilégios elevados
- Mapear estrutura organizacional

### 2. Força Bruta de Senhas

- Testar senhas comuns
- Identificar contas com senhas fracas
- Explorar políticas de senha

### 3. Elevação de Privilégios

- Abuso de grupos de segurança
- Exploração de políticas de grupo
- Manipulação de permissões

### 4. Persistência

- Criação de contas ocultas
- Modificação de políticas
- Backdoors no sistema

## 📖 Recursos Adicionais

### Documentação Microsoft

- [Active Directory Domain Services Overview](https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview)
- [Group Policy Management](https://docs.microsoft.com/en-us/windows-server/group-policy/group-policy-management-console)

### Ferramentas de Segurança

- [BloodHound](https://github.com/BloodHoundAD/BloodHound)
- [PowerView](https://github.com/PowerShellMafia/PowerSploit)
- [Impacket](https://github.com/SecureAuthCorp/Impacket)

### Cursos e Treinamentos

- [Active Directory Security](https://www.sans.org/courses/active-directory-security/)
- [Windows Security](https://www.offensive-security.com/)

## 🆘 Suporte e Troubleshooting

### Problemas Comuns

1. **Container não inicia**
   - Verificar suporte KVM
   - Verificar recursos disponíveis
   - Verificar permissões Docker

2. **Windows não instala**
   - Verificar conectividade de rede
   - Verificar espaço em disco
   - Verificar logs do container

3. **Active Directory não funciona**
   - Aguardar instalação completa
   - Verificar scripts de automação
   - Verificar logs do Windows

### Logs Úteis

```bash
# Logs do container
docker logs windows-dc-lab

# Logs do Windows (após instalação)
# Event Viewer > Windows Logs
```

## 📝 Changelog

### v1.0.0 (2024-01-XX)

- Configuração inicial do laboratório
- Windows Server 2022 como Domain Controller
- Scripts de automação para Active Directory
- Configurações de vulnerabilidades para estudo

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo `license.md` para mais detalhes.

## 🤝 Contribuições

Contribuições são bem-vindas! Por favor, abra uma issue ou pull request para melhorias no laboratório.

---

**⚠️ LEMBRE-SE: Este é um ambiente de LABORATÓRIO com vulnerabilidades intencionais para fins educacionais. NUNCA use em produção! ⚠️**

# Agente de Simulação C2 (svcmon)

Este laboratório inclui o agente `svcmon` (Go), que simula beaconing C2 para fins de detecção SOC:
- O binário `svcmon-win.exe` é copiado para o container e executado automaticamente via Scheduled Task.
- O agente realiza requisições periódicas para https://www.rodrigobrito.dev.br e registra logs em `C:\svcmon.log`.
- Objetivo: Permitir que analistas detectem atividade de beaconing e investiguem artefatos de C2.

## Artefatos Simulados
- Backdoor Python (`system.config`)
- Agente C2 Go (`svcmon-win.exe`)

## Execução Automática
- Ambos os artefatos são executados automaticamente no boot do container.

## Artefatos Dinâmicos Simulados

Este ambiente inclui artefatos automatizados para simular ataques reais e gerar ruído para análise SOC. Todos são ativados automaticamente via Scheduled Task.

- **ransomware_simulado_win.ps1**: Criptografa arquivos em `C:\VulnerableFiles` e gera nota de resgate. Restaure com `ransomware_restore_win.ps1`.
- **flood_logs_win.ps1**: Gera eventos falsos em logs do Windows.
- **exfiltracao_simulada_win.ps1**: Simula exfiltração de dados do sistema.
- **portscan_simulado_win.ps1**: Simula varredura de portas internas.
- **persistencia_simulada_win.ps1**: Simula persistência via Scheduled Task.
- **webshell_simulado_win.aspx**: Webshell ASPX para simulação de invasão (IIS).

### Restauração
Execute `powershell.exe -File C:\VulnerableFiles\ransomware_restore_win.ps1` para restaurar arquivos criptografados.

### Análise
Todos os artefatos geram logs em `C:\VulnerableFiles` para facilitar investigação e correlação de alertas.
