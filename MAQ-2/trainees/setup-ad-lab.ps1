# Script para configurar Active Directory vulnerável para laboratório
# Execute como Administrador no Windows Server

# Configurações do Domínio
$DomainName = "LAB.LOCAL"
$DomainNetbiosName = "LAB"
$SafeModePassword = ConvertTo-SecureString "Password123!" -AsPlainText -Force

# 1. Instalar AD DS
Write-Host "Instalando Active Directory Domain Services..." -ForegroundColor Green
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# 2. Promover a Domain Controller
Write-Host "Promovendo a Domain Controller..." -ForegroundColor Green
Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -DomainLogonReplicationPort 389 -DomainMode WinThreshold -DomainName $DomainName -DomainNetbiosName $DomainNetbiosName -ForestMode WinThreshold -InstallDns:$true -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$false -SysvolPath "C:\Windows\SYSVOL" -SafeModeAdministratorPassword $SafeModePassword -Force:$true

# 3. Criar Usuários Vulneráveis
Write-Host "Criando usuários vulneráveis..." -ForegroundColor Green

# Usuário Admin com senha fraca
New-ADUser -Name "admin" -GivenName "Administrator" -Surname "User" -SamAccountName "admin" -UserPrincipalName "admin@$DomainName" -AccountPassword (ConvertTo-SecureString "Password123!" -AsPlainText -Force) -ChangePasswordAtLogon $false -Enabled $true
Add-ADGroupMember -Identity "Domain Admins" -Members "admin"

# Usuário normal com senha fraca
New-ADUser -Name "user1" -GivenName "John" -Surname "Doe" -SamAccountName "user1" -UserPrincipalName "user1@$DomainName" -AccountPassword (ConvertTo-SecureString "Password123!" -AsPlainText -Force) -ChangePasswordAtLogon $false -Enabled $true

# Usuário com senha nunca expira
New-ADUser -Name "service" -GivenName "Service" -Surname "Account" -SamAccountName "service" -UserPrincipalName "service@$DomainName" -AccountPassword (ConvertTo-SecureString "Service123!" -AsPlainText -Force) -ChangePasswordAtLogon $false -PasswordNeverExpires $true -Enabled $true

# 4. Configurar Políticas de Senha Vulneráveis
Write-Host "Configurando políticas de senha vulneráveis..." -ForegroundColor Green

# Política de senha fraca
Set-ADDefaultDomainPasswordPolicy -Identity $DomainName -ComplexityEnabled $false -MinPasswordLength 4 -PasswordHistoryCount 0 -LockoutDuration 0 -LockoutThreshold 0

# 5. Configurar Kerberos (vulnerável)
Write-Host "Configurando Kerberos vulnerável..." -ForegroundColor Green

# Desabilitar pre-autenticação para alguns usuários
Set-ADAccountControl -Identity "service" -DoesNotRequirePreAuth $true

# 6. Configurar SMB vulnerável
Write-Host "Configurando SMB vulnerável..." -ForegroundColor Green

# Desabilitar SMB signing
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "SmbServerNameHardeningLevel" -Value 0

# 7. Configurar LDAP vulnerável
Write-Host "Configurando LDAP vulnerável..." -ForegroundColor Green

# Permitir LDAP simples
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\NTDS\Parameters" -Name "LDAPServerIntegrity" -Value 0

# 8. Criar GPOs vulneráveis
Write-Host "Criando GPOs vulneráveis..." -ForegroundColor Green

# GPO para desabilitar UAC
New-GPO -Name "Vulnerable-UAC-Disabled"
Set-GPRegistryValue -Name "Vulnerable-UAC-Disabled" -Key "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -ValueName "EnableLUA" -Type DWord -Value 0

# GPO para desabilitar Windows Defender
New-GPO -Name "Vulnerable-Defender-Disabled"
Set-GPRegistryValue -Name "Vulnerable-Defender-Disabled" -Key "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" -ValueName "DisableAntiSpyware" -Type DWord -Value 1

# 9. Configurar DNS
Write-Host "Configurando DNS..." -ForegroundColor Green

# Permitir transferência de zona
Set-DnsServerPrimaryZone -Name $DomainName -NotifyServers 0.0.0.0 -Notify

# 10. Configurar Firewall (vulnerável)
Write-Host "Configurando firewall vulnerável..." -ForegroundColor Green

# Desabilitar firewall
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

Write-Host "Configuração do AD vulnerável concluída!" -ForegroundColor Green
Write-Host "Domínio: $DomainName" -ForegroundColor Yellow
Write-Host "Usuários criados:" -ForegroundColor Yellow
Write-Host "- admin/Password123! (Domain Admin)" -ForegroundColor Red
Write-Host "- user1/Password123! (User)" -ForegroundColor Red
Write-Host "- service/Service123! (Service Account)" -ForegroundColor Red 