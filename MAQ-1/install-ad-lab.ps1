# Script de Instalação - Ambiente AD Vulnerável para Laboratório de Segurança
# Autor: Lab Vuln
# Versão: 1.1
# Data: 2024
# Correção: Tratamento robusto de cores para evitar erros de instalação

# Configurações do Laboratório
$DomainName = "vulnlab.local"
$DomainNetbiosName = "VULNLAB"
$SafeModePassword = "P@ssw0rd123!"
$AdminPassword = "P@ssw0rd123!"

# Função robusta para output colorido
function Write-ColorOutput {
    param(
        [string]$Message, 
        [string]$Color = "White"
    )
    
    # Mapeamento de cores para garantir compatibilidade
    $ColorMap = @{
        "Red" = "Red"
        "Green" = "Green" 
        "Yellow" = "Yellow"
        "Blue" = "Blue"
        "White" = "White"
        "Cyan" = "Cyan"
        "Magenta" = "Magenta"
        "Gray" = "Gray"
        "DarkGray" = "DarkGray"
        "DarkRed" = "DarkRed"
        "DarkGreen" = "DarkGreen"
        "DarkYellow" = "DarkYellow"
        "DarkBlue" = "DarkBlue"
        "DarkCyan" = "DarkCyan"
        "DarkMagenta" = "DarkMagenta"
    }
    
    try {
        # Verificar se a cor é válida
        if ($ColorMap.ContainsKey($Color)) {
            Write-Host $Message -ForegroundColor $ColorMap[$Color]
        } else {
            # Fallback para cor padrão se não for reconhecida
            Write-Host $Message -ForegroundColor "White"
        }
    }
    catch {
        # Fallback final se houver qualquer erro
        Write-Host $Message
    }
}

function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Install-WindowsFeatures {
    Write-ColorOutput "=== INSTALANDO RECURSOS DO WINDOWS SERVER ===" "Blue"
    
    try {
        # Instalar AD DS e DNS
        Write-ColorOutput "Instalando Active Directory Domain Services..." "Yellow"
        Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools -Force
        
        # Instalar ferramentas administrativas
        Write-ColorOutput "Instalando ferramentas administrativas..." "Yellow"
        Install-WindowsFeature -Name RSAT-AD-PowerShell, RSAT-AD-AdminCenter, RSAT-AD-Tools -Force
        
        # Instalar IIS para serviços web vulneráveis
        Write-ColorOutput "Instalando IIS..." "Yellow"
        Install-WindowsFeature -Name Web-Server, Web-Mgmt-Tools -Force
        
        # Instalar serviços de rede
        Write-ColorOutput "Instalando serviços de rede..." "Yellow"
        Install-WindowsFeature -Name Telnet-Client, TFTP-Client -Force
        
        Write-ColorOutput "Recursos do Windows Server instalados com sucesso!" "Green"
        return $true
    }
    catch {
        Write-ColorOutput "Erro ao instalar recursos: $($_.Exception.Message)" "Red"
        return $false
    }
}

function Install-ADDomain {
    Write-ColorOutput "=== CONFIGURANDO ACTIVE DIRECTORY ===" "Blue"
    
    try {
        # Configurar AD
        Write-ColorOutput "Promovendo servidor para Domain Controller..." "Yellow"
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
        
        Write-ColorOutput "Active Directory configurado com sucesso!" "Green"
        return $true
    }
    catch {
        Write-ColorOutput "Erro ao configurar AD: $($_.Exception.Message)" "Red"
        return $false
    }
}

function Create-VulnerableUsers {
    Write-ColorOutput "=== CRIANDO USUÁRIOS VULNERÁVEIS ===" "Blue"
    
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
            @{Name = "testuser"; Password = "test"; Description = "Usuário de teste adicional"}
        )
        
        foreach ($User in $Users) {
            try {
                $SecurePassword = ConvertTo-SecureString $User.Password -AsPlainText -Force
                New-ADUser -Name $User.Name -AccountPassword $SecurePassword -Description $User.Description -Enabled $true -PasswordNeverExpires $true
                Write-ColorOutput "Usuário criado: $($User.Name) - Senha: $($User.Password)" "Green"
            }
            catch {
                Write-ColorOutput "Erro ao criar usuário $($User.Name): $($_.Exception.Message)" "Red"
            }
        }
        
        # Criar grupos vulneráveis
        $Groups = @("VulnerableUsers", "TestGroup", "ServiceAccounts")
        foreach ($Group in $Groups) {
            try {
                New-ADGroup -Name $Group -GroupScope Global
                Write-ColorOutput "Grupo criado: $Group" "Green"
            }
            catch {
                Write-ColorOutput "Erro ao criar grupo $Group: $($_.Exception.Message)" "Red"
            }
        }
        
        Write-ColorOutput "Usuários e grupos vulneráveis criados!" "Green"
        return $true
    }
    catch {
        Write-ColorOutput "Erro ao criar usuários: $($_.Exception.Message)" "Red"
        return $false
    }
}

function Configure-VulnerableServices {
    Write-ColorOutput "=== CONFIGURANDO SERVIÇOS VULNERÁVEIS ===" "Blue"
    
    try {
        # Configurar SMB vulnerável
        Write-ColorOutput "Configurando SMB vulnerável..." "Yellow"
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "SMB1" -Value 1 -Type DWord
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "SMB2" -Value 1 -Type DWord
        
        # Desabilitar auditoria de segurança
        Write-ColorOutput "Desabilitando auditoria de segurança..." "Yellow"
        auditpol /set /category:* /success:disable /failure:disable
        
        # Configurar políticas de senha fracas
        Write-ColorOutput "Configurando políticas de senha fracas..." "Yellow"
        net accounts /minpwlen:0
        net accounts /maxpwage:unlimited
        
        # Desabilitar bloqueio de conta
        Write-ColorOutput "Desabilitando bloqueio de conta..." "Yellow"
        net accounts /lockoutthreshold:0
        
        # Configurar Kerberos vulnerável
        Write-ColorOutput "Configurando Kerberos vulnerável..." "Yellow"
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Kdc" -Name "WeakCryptoAllowed" -Value 1 -Type DWord
        
        Write-ColorOutput "Serviços vulneráveis configurados!" "Green"
        return $true
    }
    catch {
        Write-ColorOutput "Erro ao configurar serviços: $($_.Exception.Message)" "Red"
        return $false
    }
}

function Install-Tools {
    Write-ColorOutput "=== INSTALANDO FERRAMENTAS DE ATAQUE ===" "Blue"
    
    try {
        # Criar diretório para ferramentas
        $ToolsDir = "C:\Tools"
        if (!(Test-Path $ToolsDir)) {
            New-Item -ItemType Directory -Path $ToolsDir -Force
        }
        
        # Download de ferramentas (simulado - você precisará baixar manualmente)
        Write-ColorOutput "Criando diretório de ferramentas em C:\Tools" "Yellow"
        Write-ColorOutput "Ferramentas recomendadas para download:" "Yellow"
        Write-ColorOutput "- Mimikatz" "Yellow"
        Write-ColorOutput "- PowerSploit" "Yellow"
        Write-ColorOutput "- BloodHound" "Yellow"
        Write-ColorOutput "- CrackMapExec" "Yellow"
        Write-ColorOutput "- Responder" "Yellow"
        
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
        
        Write-ColorOutput "Ferramentas configuradas!" "Green"
        return $true
    }
    catch {
        Write-ColorOutput "Erro ao configurar ferramentas: $($_.Exception.Message)" "Red"
        return $false
    }
}

function Create-Documentation {
    Write-ColorOutput "=== CRIANDO DOCUMENTAÇÃO ===" "Blue"
    
    try {
        $DocContent = @"
=== AMBIENTE AD VULNERÁVEL - DOCUMENTAÇÃO ===
Lab Vuln - Ambiente de Segurança
Data: $(Get-Date)

=== CONFIGURAÇÕES DO DOMÍNIO ===
Nome do Domínio: $DomainName
NetBIOS: $DomainNetbiosName
Senha do Modo Seguro: $SafeModePassword
Senha do Administrador: $AdminPassword

=== USUÁRIOS CRIADOS ===
- admin / admin123 (Administrador com senha fraca)
- user1 / password (Usuário com senha comum)
- test / test123 (Usuário de teste)
- guest / guest (Usuário guest)
- admin2 / admin (Segundo admin com senha fraca)
- service / service123 (Conta de serviço)
- backup / backup (Conta de backup)
- testuser / test (Usuário de teste adicional)

=== GRUPOS CRIADOS ===
- VulnerableUsers
- TestGroup
- ServiceAccounts

=== VULNERABILIDADES CONFIGURADAS ===
1. SMB1 e SMB2 habilitados
2. Auditoria de segurança desabilitada
3. Políticas de senha fracas (comprimento mínimo 0)
4. Bloqueio de conta desabilitado
5. Kerberos com criptografia fraca habilitada
6. IIS instalado para serviços web vulneráveis

=== FERRAMENTAS RECOMENDADAS ===
- Mimikatz: https://github.com/gentilkiwi/mimikatz
- PowerSploit: https://github.com/PowerShellMafia/PowerSploit
- BloodHound: https://github.com/BloodHoundAD/BloodHound
- CrackMapExec: https://github.com/byt3bl33d3r/CrackMapExec
- Responder: https://github.com/SpiderLabs/Responder

=== COMANDOS ÚTEIS ===
# Verificar usuários
Get-ADUser -Filter *

# Verificar grupos
Get-ADGroup -Filter *

# Testar conectividade
Test-NetConnection -ComputerName $DomainName -Port 389

# Verificar políticas de senha
net accounts

# Verificar configurações SMB
Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"

=== AVISOS IMPORTANTES ===
⚠️  Este ambiente é intencionalmente vulnerável!
⚠️  NÃO use em produção!
⚠️  Use apenas para fins educacionais!
⚠️  Isolado de redes de produção!

=== PRÓXIMOS PASSOS ===
1. Reiniciar o servidor após a instalação
2. Baixar ferramentas de ataque
3. Configurar máquina atacante
4. Iniciar testes de penetração
5. Documentar descobertas

=== CONTATO ===
Para dúvidas sobre este laboratório, entre em contato com a equipe de segurança.
"@
        
        Set-Content -Path "C:\AD-Lab-Info.txt" -Value $DocContent -Encoding UTF8
        
        Write-ColorOutput "Documentação criada em C:\AD-Lab-Info.txt" "Green"
        return $true
    }
    catch {
        Write-ColorOutput "Erro ao criar documentação: $($_.Exception.Message)" "Red"
        return $false
    }
}

# Função principal
function Main {
    Write-ColorOutput "`n=== INSTALADOR DE LABORATÓRIO AD VULNERÁVEL ===" "Blue"
    Write-ColorOutput "Lab Vuln - Ambiente de Segurança" "Blue"
    Write-ColorOutput "Versão: 1.1 (Corrigida)" "Blue"
    Write-ColorOutput "Data: $(Get-Date)" "Blue"
    Write-ColorOutput ""
    
    # Verificar privilégios de administrador
    if (!(Test-Administrator)) {
        Write-ColorOutput "ERRO: Este script deve ser executado como Administrador!" "Red"
        exit 1
    }
    
    # Verificar se já é Domain Controller
    if ((Get-WmiObject -Class Win32_ComputerSystem).DomainRole -eq 5) {
        Write-ColorOutput "ERRO: Este servidor já é um Domain Controller!" "Red"
        exit 1
    }
    
    Write-ColorOutput "`nIniciando instalação do laboratório AD vulnerável..." "Yellow"
    Write-ColorOutput "⚠️  ATENÇÃO: Este ambiente será intencionalmente vulnerável!" "Red"
    
    # Confirmação do usuário
    $confirmation = Read-Host "`nDeseja continuar? (S/N)"
    if ($confirmation -ne "S" -and $confirmation -ne "s") {
        Write-ColorOutput "Instalação cancelada pelo usuário." "Yellow"
        exit 0
    }
    
    # Lista de etapas de instalação
    $InstallSteps = @(
        @{Name = "Instalar Recursos do Windows"; Function = "Install-WindowsFeatures"},
        @{Name = "Configurar Active Directory"; Function = "Install-ADDomain"},
        @{Name = "Criar Usuários Vulneráveis"; Function = "Create-VulnerableUsers"},
        @{Name = "Configurar Serviços Vulneráveis"; Function = "Configure-VulnerableServices"},
        @{Name = "Instalar Ferramentas"; Function = "Install-Tools"},
        @{Name = "Criar Documentação"; Function = "Create-Documentation"}
    )
    
    # Executar cada etapa
    foreach ($step in $InstallSteps) {
        Write-ColorOutput "`nExecutando: $($step.Name)" "Blue"
        
        if (& $step.Function) {
            Write-ColorOutput "✅ $($step.Name) - Concluído com sucesso!" "Green"
        } else {
            Write-ColorOutput "❌ Erro na etapa: $($step.Name)" "Red"
            Write-ColorOutput "Verifique os logs e tente novamente." "Yellow"
            exit 1
        }
    }
    
    # Resumo final
    Write-ColorOutput "`n=== RESUMO DA INSTALAÇÃO ===" "Blue"
    Write-ColorOutput "✅ Active Directory configurado" "Green"
    Write-ColorOutput "✅ Usuários vulneráveis criados" "Green"
    Write-ColorOutput "✅ Serviços vulneráveis configurados" "Green"
    Write-ColorOutput "✅ Ferramentas preparadas" "Green"
    Write-ColorOutput "✅ Documentação criada" "Green"
    
    Write-ColorOutput "`n=== INFORMAÇÕES IMPORTANTES ===" "Yellow"
    Write-ColorOutput "Domínio: $DomainName" "Yellow"
    Write-ColorOutput "Usuário Admin: Administrator" "Yellow"
    Write-ColorOutput "Senha: $AdminPassword" "Yellow"
    Write-ColorOutput "Documentação: C:\AD-Lab-Info.txt" "Yellow"
    
    Write-ColorOutput "`n=== PRÓXIMOS PASSOS ===" "Blue"
    Write-ColorOutput "1. Reiniciar o servidor" "Yellow"
    Write-ColorOutput "2. Baixar ferramentas de ataque" "Yellow"
    Write-ColorOutput "3. Configurar máquina atacante" "Yellow"
    Write-ColorOutput "4. Iniciar testes de penetração" "Yellow"
    
    Write-ColorOutput "`n⚠️  AMBIENTE VULNERÁVEL CRIADO COM SUCESSO! ⚠️" "Red"
    Write-ColorOutput "⚠️  NÃO USE EM PRODUÇÃO! ⚠️" "Red"
}

# Executar função principal
Main 