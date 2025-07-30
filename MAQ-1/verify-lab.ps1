# Script de Verificação do Laboratório AD
# Autor: Lab Vuln
# Versão: 1.0

function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    
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

function Test-ADInstallation {
    Write-ColorOutput "=== VERIFICANDO INSTALAÇÃO DO AD ===" "Blue"
    
    $errors = @()
    
    # Verificar se é Domain Controller
    try {
        $domainRole = (Get-WmiObject -Class Win32_ComputerSystem).DomainRole
        if ($domainRole -eq 5) {
            Write-ColorOutput "✅ Servidor é Domain Controller" "Green"
        } else {
            Write-ColorOutput "❌ Servidor não é Domain Controller (Role: $domainRole)" "Red"
            $errors += "Servidor não é DC"
        }
    }
    catch {
        Write-ColorOutput "❌ Erro ao verificar role do servidor" "Red"
        $errors += "Erro ao verificar role"
    }
    
    # Verificar se AD DS está instalado
    try {
        $adFeature = Get-WindowsFeature -Name AD-Domain-Services
        if ($adFeature.InstallState -eq "Installed") {
            Write-ColorOutput "✅ AD Domain Services instalado" "Green"
        } else {
            Write-ColorOutput "❌ AD Domain Services não instalado" "Red"
            $errors += "AD DS não instalado"
        }
    }
    catch {
        Write-ColorOutput "❌ Erro ao verificar AD DS" "Red"
        $errors += "Erro ao verificar AD DS"
    }
    
    # Verificar se DNS está funcionando
    try {
        $dnsTest = Resolve-DnsName -Name "vulnlab.local" -ErrorAction SilentlyContinue
        if ($dnsTest) {
            Write-ColorOutput "✅ DNS funcionando para vulnlab.local" "Green"
        } else {
            Write-ColorOutput "❌ DNS não funcionando para vulnlab.local" "Red"
            $errors += "DNS não funcionando"
        }
    }
    catch {
        Write-ColorOutput "❌ Erro ao testar DNS" "Red"
        $errors += "Erro no DNS"
    }
    
    return $errors
}

function Test-ADUsers {
    Write-ColorOutput "=== VERIFICANDO USUÁRIOS DO AD ===" "Blue"
    
    $errors = @()
    $expectedUsers = @("admin", "user1", "test", "guest", "admin2", "service", "backup", "webadmin")
    $foundUsers = @()
    
    try {
        Import-Module ActiveDirectory
        
        foreach ($user in $expectedUsers) {
            try {
                $adUser = Get-ADUser -Identity $user -ErrorAction SilentlyContinue
                if ($adUser) {
                    Write-ColorOutput "✅ Usuário encontrado: $user" "Green"
                    $foundUsers += $user
                } else {
                    Write-ColorOutput "❌ Usuário não encontrado: $user" "Red"
                    $errors += "Usuário $user não encontrado"
                }
            }
            catch {
                Write-ColorOutput "❌ Erro ao verificar usuário $user" "Red"
                $errors += "Erro ao verificar $user"
            }
        }
        
        Write-ColorOutput "`nUsuários encontrados: $($foundUsers.Count)/$($expectedUsers.Count)" "Yellow"
        
    }
    catch {
        Write-ColorOutput "❌ Erro ao importar módulo AD" "Red"
        $errors += "Erro ao importar módulo AD"
    }
    
    return $errors
}

function Test-ADGroups {
    Write-ColorOutput "=== VERIFICANDO GRUPOS DO AD ===" "Blue"
    
    $errors = @()
    $expectedGroups = @("VulnerableUsers", "TestGroup", "ServiceAccounts")
    $foundGroups = @()
    
    try {
        foreach ($group in $expectedGroups) {
            try {
                $adGroup = Get-ADGroup -Identity $group -ErrorAction SilentlyContinue
                if ($adGroup) {
                    Write-ColorOutput "✅ Grupo encontrado: $group" "Green"
                    $foundGroups += $group
                } else {
                    Write-ColorOutput "❌ Grupo não encontrado: $group" "Red"
                    $errors += "Grupo $group não encontrado"
                }
            }
            catch {
                Write-ColorOutput "❌ Erro ao verificar grupo $group" "Red"
                $errors += "Erro ao verificar $group"
            }
        }
        
        Write-ColorOutput "`nGrupos encontrados: $($foundGroups.Count)/$($expectedGroups.Count)" "Yellow"
        
    }
    catch {
        Write-ColorOutput "❌ Erro ao verificar grupos" "Red"
        $errors += "Erro ao verificar grupos"
    }
    
    return $errors
}

function Test-VulnerableServices {
    Write-ColorOutput "=== VERIFICANDO SERVIÇOS VULNERÁVEIS ===" "Blue"
    
    $errors = @()
    
    # Verificar SMB1
    try {
        $smb1 = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "SMB1" -ErrorAction SilentlyContinue
        if ($smb1.SMB1 -eq 1) {
            Write-ColorOutput "✅ SMB1 habilitado (vulnerável)" "Green"
        } else {
            Write-ColorOutput "❌ SMB1 não habilitado" "Red"
            $errors += "SMB1 não habilitado"
        }
    }
    catch {
        Write-ColorOutput "❌ Erro ao verificar SMB1" "Red"
        $errors += "Erro ao verificar SMB1"
    }
    
    # Verificar auditoria
    try {
        $auditPolicy = auditpol /get /category:"Account Logon" | Select-String "Success and Failure"
        if ($auditPolicy -match "No Auditing") {
            Write-ColorOutput "✅ Auditoria desabilitada (vulnerável)" "Green"
        } else {
            Write-ColorOutput "❌ Auditoria habilitada" "Red"
            $errors += "Auditoria habilitada"
        }
    }
    catch {
        Write-ColorOutput "❌ Erro ao verificar auditoria" "Red"
        $errors += "Erro ao verificar auditoria"
    }
    
    # Verificar políticas de senha
    try {
        $passwordPolicy = net accounts
        if ($passwordPolicy -match "Minimum password length.*0") {
            Write-ColorOutput "✅ Política de senha fraca (vulnerável)" "Green"
        } else {
            Write-ColorOutput "❌ Política de senha forte" "Red"
            $errors += "Política de senha forte"
        }
    }
    catch {
        Write-ColorOutput "❌ Erro ao verificar política de senha" "Red"
        $errors += "Erro ao verificar política de senha"
    }
    
    return $errors
}

function Test-NetworkConnectivity {
    Write-ColorOutput "=== VERIFICANDO CONECTIVIDADE DE REDE ===" "Blue"
    
    $errors = @()
    $targetIP = "192.168.1.10"
    $ports = @(389, 445, 88, 53)
    
    # Testar conectividade básica
    try {
        $ping = Test-Connection -ComputerName $targetIP -Count 1 -Quiet
        if ($ping) {
            Write-ColorOutput "✅ Conectividade básica OK" "Green"
        } else {
            Write-ColorOutput "❌ Sem conectividade básica" "Red"
            $errors += "Sem conectividade básica"
        }
    }
    catch {
        Write-ColorOutput "❌ Erro ao testar conectividade" "Red"
        $errors += "Erro na conectividade"
    }
    
    # Testar portas importantes
    foreach ($port in $ports) {
        try {
            $connection = Test-NetConnection -ComputerName $targetIP -Port $port -InformationLevel Quiet
            if ($connection.TcpTestSucceeded) {
                Write-ColorOutput "✅ Porta $port aberta" "Green"
            } else {
                Write-ColorOutput "❌ Porta $port fechada" "Red"
                $errors += "Porta $port fechada"
            }
        }
        catch {
            Write-ColorOutput "❌ Erro ao testar porta $port" "Red"
            $errors += "Erro na porta $port"
        }
    }
    
    return $errors
}

function Test-IISInstallation {
    Write-ColorOutput "=== VERIFICANDO INSTALAÇÃO DO IIS ===" "Blue"
    
    $errors = @()
    
    try {
        $iisFeature = Get-WindowsFeature -Name Web-Server
        if ($iisFeature.InstallState -eq "Installed") {
            Write-ColorOutput "✅ IIS instalado" "Green"
            
            # Verificar se está rodando
            $iisService = Get-Service -Name W3SVC -ErrorAction SilentlyContinue
            if ($iisService -and $iisService.Status -eq "Running") {
                Write-ColorOutput "✅ Serviço IIS rodando" "Green"
            } else {
                Write-ColorOutput "❌ Serviço IIS não está rodando" "Red"
                $errors += "IIS não está rodando"
            }
        } else {
            Write-ColorOutput "❌ IIS não instalado" "Red"
            $errors += "IIS não instalado"
        }
    }
    catch {
        Write-ColorOutput "❌ Erro ao verificar IIS" "Red"
        $errors += "Erro ao verificar IIS"
    }
    
    return $errors
}

function Show-Summary {
    param([array]$AllErrors)
    
    Write-ColorOutput "`n=== RESUMO DA VERIFICAÇÃO ===" "Blue"
    
    if ($AllErrors.Count -eq 0) {
        Write-ColorOutput "🎉 TODOS OS TESTES PASSARAM!" "Green"
        Write-ColorOutput "✅ Laboratório AD vulnerável está funcionando corretamente" "Green"
    } else {
        Write-ColorOutput "⚠️  ENCONTRADOS $($AllErrors.Count) PROBLEMAS:" "Yellow"
        foreach ($errorItem in $AllErrors) {
            Write-ColorOutput "❌ $errorItem" "Red"
        }
        Write-ColorOutput "`nRecomendações:" "Yellow"
        Write-ColorOutput "1. Verifique se o script de instalação foi executado completamente" "Yellow"
        Write-ColorOutput "2. Reinicie o servidor se necessário" "Yellow"
        Write-ColorOutput "3. Execute novamente o script de instalação" "Yellow"
    }
    
    Write-ColorOutput "`n=== INFORMAÇÕES DO SISTEMA ===" "Blue"
    Write-ColorOutput "Sistema Operacional: $((Get-WmiObject -Class Win32_OperatingSystem).Caption)" "Yellow"
    Write-ColorOutput "Domínio: $env:USERDOMAIN" "Yellow"
    Write-ColorOutput "Computador: $env:COMPUTERNAME" "Yellow"
    Write-ColorOutput "IP: $(Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -notlike "127.*" -and $_.IPAddress -notlike "169.*"} | Select-Object -First 1 -ExpandProperty IPAddress)" "Yellow"
}

# FUNÇÃO PRINCIPAL
function Verify-ADLab {
    Write-ColorOutput "=== VERIFICADOR DE LABORATÓRIO AD ===" "Blue"
    Write-ColorOutput "Lab Vuln - Ambiente de Segurança" "Blue"
    Write-ColorOutput "Versão: 1.0" "Blue"
    Write-ColorOutput "Data: $(Get-Date)" "Blue"
    
    $allErrors = @()
    
    # Executar verificações
    $checks = @(
        @{Name = "Instalação do AD"; Function = "Test-ADInstallation"},
        @{Name = "Usuários do AD"; Function = "Test-ADUsers"},
        @{Name = "Grupos do AD"; Function = "Test-ADGroups"},
        @{Name = "Serviços Vulneráveis"; Function = "Test-VulnerableServices"},
        @{Name = "Conectividade de Rede"; Function = "Test-NetworkConnectivity"},
        @{Name = "Instalação do IIS"; Function = "Test-IISInstallation"}
    )
    
    foreach ($check in $checks) {
        Write-ColorOutput "`nExecutando: $($check.Name)" "Blue"
        $errors = & $check.Function
        $allErrors += $errors
    }
    
    Show-Summary -AllErrors $allErrors
}

# Executar verificação
Verify-ADLab 