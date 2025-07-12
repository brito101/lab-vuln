# Script de Instalação - Ambiente AD Vulnerável para Laboratório de Segurança
# Autor: Lab Vuln
# Versão: 1.0
# Data: 2024

# Configurações do Laboratório
$DomainName = "vulnlab.local"
$DomainNetbiosName = "VULNLAB"
$SafeModePassword = "P@ssw0rd123!"
$AdminPassword = "P@ssw0rd123!"

# Cores para output
$Red = "Red"
$Green = "Green"
$Yellow = "Yellow"
$Blue = "Blue"

function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Install-WindowsFeatures {
    Write-ColorOutput "=== INSTALANDO RECURSOS DO WINDOWS SERVER ===" $Blue
    
    try {
        # Instalar AD DS e DNS
        Write-ColorOutput "Instalando Active Directory Domain Services..." $Yellow
        Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools -Force
        
        # Instalar ferramentas administrativas
        Write-ColorOutput "Instalando ferramentas administrativas..." $Yellow
        Install-WindowsFeature -Name RSAT-AD-PowerShell, RSAT-AD-AdminCenter, RSAT-AD-Tools -Force
        
        # Instalar IIS para serviços web vulneráveis
        Write-ColorOutput "Instalando IIS..." $Yellow
        Install-WindowsFeature -Name Web-Server, Web-Mgmt-Tools -Force
        
        # Instalar serviços de rede
        Write-ColorOutput "Instalando serviços de rede..." $Yellow
        Install-WindowsFeature -Name Telnet-Client, TFTP-Client -Force
        
        Write-ColorOutput "Recursos do Windows Server instalados com sucesso!" $Green
        return $true
    }
    catch {
        Write-ColorOutput "Erro ao instalar recursos: $($_.Exception.Message)" $Red
        return $false
    }
}

function Install-ADDomain {
    Write-ColorOutput "=== CONFIGURANDO ACTIVE DIRECTORY ===" $Blue
    
    try {
        # Configurar AD
        Write-ColorOutput "Promovendo servidor para Domain Controller..." $Yellow
        Import-Module ADDSDeployment
        
        $ADForestParams = @{
            CreateDnsDelegation = $false
            DatabasePath = "C:\Windows\NTDS"
            DomainMode = "WinThreshold"
            DomainName = $DomainName
            DomainNetbiosName = $DomainNetbiosName
            ForestMode = "WinThreshold"
            InstallDns = $true
            LogPath = "C:\Windows\NTDS"
            NoRebootOnCompletion = $false
            SysvolPath = "C:\Windows\SYSVOL"
            Force = $true
            SafeModeAdministratorPassword = (ConvertTo-SecureString $SafeModePassword -AsPlainText -Force)
        }
        
        Install-ADDSForest @ADForestParams
        
        Write-ColorOutput "Active Directory configurado com sucesso!" $Green
        return $true
    }
    catch {
        Write-ColorOutput "Erro ao configurar AD: $($_.Exception.Message)" $Red
        return $false
    }
}

function Create-VulnerableUsers {
    Write-ColorOutput "=== CRIANDO USUÁRIOS VULNERÁVEIS ===" $Blue
    
    try {
        # Aguardar AD estar disponível
        Start-Sleep -Seconds 30
        
        # Importar módulo AD
        Import-Module ActiveDirectory
        
        # Criar usuários com senhas fracas
        $Users = @(
            @{Name = "admin"; Password = "admin123"; Description = "Administrador com senha fraca"},
            @{Name = "user1"; Password = "password"; Description = "Usuário com senha comum"},
            @{Name = "test"; Password = "test123"; Description = "Usuário de teste"},
            @{Name = "guest"; Password = "guest"; Description = "Usuário guest"},
            @{Name = "admin2"; Password = "admin"; Description = "Segundo admin com senha fraca"},
            @{Name = "service"; Password = "service123"; Description = "Conta de serviço"},
            @{Name = "backup"; Password = "backup"; Description = "Conta de backup"},
            @{Name = "webadmin"; Password = "web123"; Description = "Admin web"}
        )
        
        foreach ($User in $Users) {
            try {
                $SecurePassword = ConvertTo-SecureString $User.Password -AsPlainText -Force
                New-ADUser -Name $User.Name -AccountPassword $SecurePassword -Enabled $true -PasswordNeverExpires $true -Description $User.Description
                Write-ColorOutput "Usuário criado: $($User.Name) - Senha: $($User.Password)" $Green
            }
            catch {
                Write-ColorOutput "Erro ao criar usuário $($User.Name): $($_.Exception.Message)" $Red
            }
        }
        
        # Criar grupos vulneráveis
        $Groups = @("VulnerableUsers", "TestGroup", "ServiceAccounts")
        foreach ($Group in $Groups) {
            try {
                New-ADGroup -Name $Group -GroupScope Global
                Write-ColorOutput "Grupo criado: $Group" $Green
            }
            catch {
                Write-ColorOutput "Erro ao criar grupo $Group: $($_.Exception.Message)" $Red
            }
        }
        
        Write-ColorOutput "Usuários e grupos vulneráveis criados!" $Green
        return $true
    }
    catch {
        Write-ColorOutput "Erro ao criar usuários: $($_.Exception.Message)" $Red
        return $false
    }
}

function Configure-VulnerableServices {
    Write-ColorOutput "=== CONFIGURANDO SERVIÇOS VULNERÁVEIS ===" $Blue
    
    try {
        # Configurar SMB vulnerável
        Write-ColorOutput "Configurando SMB vulnerável..." $Yellow
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "SMB1" -Value 1 -Type DWord
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "SMB2" -Value 1 -Type DWord
        
        # Desabilitar auditoria de segurança
        Write-ColorOutput "Desabilitando auditoria de segurança..." $Yellow
        auditpol /set /category:* /success:disable /failure:disable
        
        # Configurar políticas de senha fracas
        Write-ColorOutput "Configurando políticas de senha fracas..." $Yellow
        net accounts /minpwlen:0
        net accounts /maxpwage:unlimited
        
        # Desabilitar bloqueio de conta
        Write-ColorOutput "Desabilitando bloqueio de conta..." $Yellow
        net accounts /lockoutthreshold:0
        
        # Configurar Kerberos vulnerável
        Write-ColorOutput "Configurando Kerberos vulnerável..." $Yellow
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Kdc" -Name "WeakCryptoAllowed" -Value 1 -Type DWord
        
        Write-ColorOutput "Serviços vulneráveis configurados!" $Green
        return $true
    }
    catch {
        Write-ColorOutput "Erro ao configurar serviços: $($_.Exception.Message)" $Red
        return $false
    }
}

function Install-Tools {
    Write-ColorOutput "=== INSTALANDO FERRAMENTAS DE ATAQUE ===" $Blue
    
    try {
        # Criar diretório para ferramentas
        $ToolsDir = "C:\Tools"
        if (!(Test-Path $ToolsDir)) {
            New-Item -ItemType Directory -Path $ToolsDir -Force
        }
        
        # Download de ferramentas (simulado - você precisará baixar manualmente)
        Write-ColorOutput "Criando diretório de ferramentas em C:\Tools" $Yellow
        Write-ColorOutput "Ferramentas recomendadas para download:" $Yellow
        Write-ColorOutput "- Mimikatz" $Yellow
        Write-ColorOutput "- PowerSploit" $Yellow
        Write-ColorOutput "- BloodHound" $Yellow
        Write-ColorOutput "- CrackMapExec" $Yellow
        Write-ColorOutput "- Responder" $Yellow
        
        # Criar script de download
        $DownloadScript = @"
# Script para download de ferramentas
Write-Host "Baixando ferramentas de ataque..."

# Criar diretórios
New-Item -ItemType Directory -Path "C:\Tools\Mimikatz" -Force
New-Item -ItemType Directory -Path "C:\Tools\PowerSploit" -Force
New-Item -ItemType Directory -Path "C:\Tools\BloodHound" -Force

Write-Host "Diretórios criados. Baixe as ferramentas manualmente."
Write-Host "Links recomendados:"
Write-Host "- Mimikatz: https://github.com/gentilkiwi/mimikatz"
Write-Host "- PowerSploit: https://github.com/PowerShellMafia/PowerSploit"
Write-Host "- BloodHound: https://github.com/BloodHoundAD/BloodHound"
"@
        
        Set-Content -Path "$ToolsDir\download-tools.ps1" -Value $DownloadScript
        
        Write-ColorOutput "Ferramentas configuradas!" $Green
        return $true
    }
    catch {
        Write-ColorOutput "Erro ao configurar ferramentas: $($_.Exception.Message)" $Red
        return $false
    }
}

function Create-Documentation {
    Write-ColorOutput "=== CRIANDO DOCUMENTAÇÃO ===" $Blue
    
    try {
        $DocContent = @"
# LABORATÓRIO AD VULNERÁVEL - Lab Vuln

## Configurações do Ambiente
- Domínio: $DomainName
- NetBIOS: $DomainNetbiosName
- Senha Safe Mode: $SafeModePassword
- Senha Admin: $AdminPassword

## Usuários Criados
- admin/admin123
- user1/password
- test/test123
- guest/guest
- admin2/admin
- service/service123
- backup/backup
- webadmin/web123

## Vulnerabilidades Implementadas
1. Senhas fracas e previsíveis
2. SMB1 habilitado
3. Auditoria de segurança desabilitada
4. Políticas de senha fracas
5. Bloqueio de conta desabilitado
6. Kerberos com criptografia fraca

## Ferramentas Recomendadas
- Mimikatz (extração de credenciais)
- PowerSploit (PowerShell attacks)
- BloodHound (mapeamento de AD)
- CrackMapExec (enumeração)
- Responder (LLMNR/NBT-NS poisoning)

## Cenários de Ataque
1. Enumeração de usuários
2. Força bruta de senhas
3. Kerberoasting
4. Pass-the-Hash
5. Golden Ticket
6. Silver Ticket
7. DCSync
8. SMB Relay

## Comandos Úteis
- net user (listar usuários)
- net group (listar grupos)
- nltest /domain_trusts (trusts)
- dsquery user (LDAP queries)

## Segurança
⚠️ ATENÇÃO: Este ambiente é intencionalmente vulnerável!
- Use apenas em ambiente isolado
- Não conecte à internet
- Não use credenciais reais
- Destrua após uso

## Próximos Passos
1. Baixar ferramentas de ataque
2. Configurar máquina atacante (Kali Linux)
3. Executar cenários de pentest
4. Documentar descobertas

Criado em: $(Get-Date)
"@
        
        Set-Content -Path "C:\AD-Lab-Info.txt" -Value $DocContent
        Write-ColorOutput "Documentação criada em C:\AD-Lab-Info.txt" $Green
        return $true
    }
    catch {
        Write-ColorOutput "Erro ao criar documentação: $($_.Exception.Message)" $Red
        return $false
    }
}

function Show-Summary {
    Write-ColorOutput "`n=== RESUMO DA INSTALAÇÃO ===" $Blue
    Write-ColorOutput "✅ Active Directory configurado" $Green
    Write-ColorOutput "✅ Usuários vulneráveis criados" $Green
    Write-ColorOutput "✅ Serviços vulneráveis configurados" $Green
    Write-ColorOutput "✅ Ferramentas preparadas" $Green
    Write-ColorOutput "✅ Documentação criada" $Green
    
    Write-ColorOutput "`n=== INFORMAÇÕES IMPORTANTES ===" $Yellow
    Write-ColorOutput "Domínio: $DomainName" $Yellow
    Write-ColorOutput "Usuário Admin: Administrator" $Yellow
    Write-ColorOutput "Senha: $AdminPassword" $Yellow
    Write-ColorOutput "Documentação: C:\AD-Lab-Info.txt" $Yellow
    
    Write-ColorOutput "`n=== PRÓXIMOS PASSOS ===" $Blue
    Write-ColorOutput "1. Reiniciar o servidor" $Yellow
    Write-ColorOutput "2. Baixar ferramentas de ataque" $Yellow
    Write-ColorOutput "3. Configurar máquina atacante" $Yellow
    Write-ColorOutput "4. Iniciar testes de penetração" $Yellow
    
    Write-ColorOutput "`n⚠️  AMBIENTE VULNERÁVEL CRIADO COM SUCESSO! ⚠️" $Red
}

# FUNÇÃO PRINCIPAL
function Install-ADLab {
    Write-ColorOutput "=== INSTALADOR DE LABORATÓRIO AD VULNERÁVEL ===" $Blue
    Write-ColorOutput "Lab Vuln - Ambiente de Segurança" $Blue
    Write-ColorOutput "Versão: 1.0" $Blue
    Write-ColorOutput "Data: $(Get-Date)" $Blue
    
    # Verificar se é administrador
    if (!(Test-Administrator)) {
        Write-ColorOutput "ERRO: Este script deve ser executado como Administrador!" $Red
        return
    }
    
    # Verificar se já é DC
    if ((Get-WmiObject -Class Win32_ComputerSystem).DomainRole -eq 5) {
        Write-ColorOutput "ERRO: Este servidor já é um Domain Controller!" $Red
        return
    }
    
    Write-ColorOutput "`nIniciando instalação do laboratório AD vulnerável..." $Yellow
    Write-ColorOutput "⚠️  ATENÇÃO: Este ambiente será intencionalmente vulnerável!" $Red
    
    $continue = Read-Host "`nDeseja continuar? (S/N)"
    if ($continue -ne "S" -and $continue -ne "s") {
        Write-ColorOutput "Instalação cancelada pelo usuário." $Yellow
        return
    }
    
    # Executar instalação
    $steps = @(
        @{Name = "Recursos do Windows"; Function = "Install-WindowsFeatures"},
        @{Name = "Active Directory"; Function = "Install-ADDomain"},
        @{Name = "Usuários Vulneráveis"; Function = "Create-VulnerableUsers"},
        @{Name = "Serviços Vulneráveis"; Function = "Configure-VulnerableServices"},
        @{Name = "Ferramentas"; Function = "Install-Tools"},
        @{Name = "Documentação"; Function = "Create-Documentation"}
    )
    
    foreach ($step in $steps) {
        Write-ColorOutput "`nExecutando: $($step.Name)" $Blue
        & $step.Function
        
        if ($LASTEXITCODE -ne 0) {
            Write-ColorOutput "Erro na etapa: $($step.Name)" $Red
            return
        }
    }
    
    Show-Summary
}

# Executar instalação
Install-ADLab 