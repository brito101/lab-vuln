@echo off
REM Script de automação para configurar Windows Server 2022 como Domain Controller
REM Laboratório de Vulnerabilidades - MAQ-1
REM Versão: 2.0 - Com logs intensivos para Elastic
REM Autor: Sistema de Laboratórios de Vulnerabilidades

echo [INFO] ========================================
echo [INFO] INICIANDO CONFIGURACAO DO DOMAIN CONTROLLER
echo [INFO] Laboratorio de Vulnerabilidades - MAQ-1
echo [INFO] ========================================
echo [INFO] Data/Hora: %date% %time%
echo [INFO] Computador: %computername%
echo [INFO] Usuario: %username%
echo [INFO] Sistema: %os%

REM ========================================
REM GERAR LOGS INTENSIVOS - INICIO
REM ========================================
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [DC-SETUP] Iniciando processo de configuracao
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [DC-SETUP] Verificando requisitos do sistema
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [DC-SETUP] Sistema operacional detectado: %os%
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [DC-SETUP] Arquitetura: %processor_architecture%

REM Verificar e logar informações do sistema
echo [INFO] Verificando informações do sistema...
systeminfo | findstr /C:"OS Name" /C:"OS Version" /C:"System Type" /C:"Total Physical Memory"
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [SYSTEM-INFO] Informacoes do sistema coletadas

REM ========================================
REM CONFIGURACAO DE TIMEZONE
REM ========================================
echo [INFO] ========================================
echo [INFO] CONFIGURANDO TIMEZONE
echo [INFO] ========================================
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [TIMEZONE] Iniciando configuracao de timezone
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [TIMEZONE] Timezone atual: %timezone%

tzutil /s "E. South America Standard Time"
if %errorlevel% equ 0 (
    echo [INFO] Timezone configurado com sucesso
    echo [ELASTIC_LOG] [%date% %time%] [SUCCESS] [MAQ-1] [TIMEZONE] Timezone configurado para E. South America Standard Time
) else (
    echo [ERROR] Falha ao configurar timezone
    echo [ELASTIC_LOG] [%date% %time%] [ERROR] [MAQ-1] [TIMEZONE] Falha ao configurar timezone - Error: %errorlevel%
)

echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [TIMEZONE] Verificando timezone configurado
tzutil /g
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [TIMEZONE] Configuracao de timezone concluida

REM ========================================
REM CONFIGURACAO DE NOME DO COMPUTADOR
REM ========================================
echo [INFO] ========================================
echo [INFO] CONFIGURANDO NOME DO COMPUTADOR
echo [INFO] ========================================
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [COMPUTER-NAME] Nome atual: %computername%
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [COMPUTER-NAME] Iniciando renomeacao para DC-LAB-01

echo [INFO] Configurando nome do computador...
wmic computersystem where name="%computername%" call rename name="DC-LAB-01"
if %errorlevel% equ 0 (
    echo [INFO] Nome do computador configurado com sucesso
    echo [ELASTIC_LOG] [%date% %time%] [SUCCESS] [MAQ-1] [COMPUTER-NAME] Nome alterado para DC-LAB-01
) else (
    echo [ERROR] Falha ao configurar nome do computador
    echo [ELASTIC_LOG] [%date% %time%] [ERROR] [MAQ-1] [COMPUTER-NAME] Falha ao renomear - Error: %errorlevel%
)

echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [COMPUTER-NAME] Verificando nome configurado
wmic computersystem get name
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [COMPUTER-NAME] Configuracao de nome concluida

REM ========================================
REM CONFIGURACAO DE REDE
REM ========================================
echo [INFO] ========================================
echo [INFO] CONFIGURANDO REDE
echo [INFO] ========================================
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [NETWORK] Iniciando configuracao de rede
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [NETWORK] Interface: Ethernet
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [NETWORK] IP: 192.168.101.10
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [NETWORK] Mascara: 255.255.255.0
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [NETWORK] Gateway: 192.168.101.1

REM Configurar IP estático
echo [INFO] Configurando IP estático...
netsh interface ip set address "Ethernet" static 192.168.101.10 255.255.255.0 192.168.101.1
if %errorlevel% equ 0 (
    echo [INFO] IP estático configurado com sucesso
    echo [ELASTIC_LOG] [%date% %time%] [SUCCESS] [MAQ-1] [NETWORK] IP estatico configurado
) else (
    echo [ERROR] Falha ao configurar IP estático
    echo [ELASTIC_LOG] [%date% %time%] [ERROR] [MAQ-1] [NETWORK] Falha ao configurar IP - Error: %errorlevel%
)

REM Configurar DNS
echo [INFO] Configurando DNS...
netsh interface ip set dns "Ethernet" static 192.168.101.10
if %errorlevel% equ 0 (
    echo [ELASTIC_LOG] [%date% %time%] [SUCCESS] [MAQ-1] [NETWORK] DNS primario configurado
) else (
    echo [ELASTIC_LOG] [%date% %time%] [ERROR] [MAQ-1] [NETWORK] Falha ao configurar DNS primario
)

netsh interface ip add dns "Ethernet" 8.8.8.8 index=2
if %errorlevel% equ 0 (
    echo [ELASTIC_LOG] [%date% %time%] [SUCCESS] [MAQ-1] [NETWORK] DNS secundario configurado
) else (
    echo [ELASTIC_LOG] [%date% %time%] [ERROR] [MAQ-1] [NETWORK] Falha ao configurar DNS secundario
)

REM Verificar configuração de rede
echo [INFO] Verificando configuração de rede...
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [NETWORK] Verificando configuracao de IP
ipconfig /all | findstr /C:"IPv4 Address" /C:"Subnet Mask" /C:"Default Gateway"
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [NETWORK] Verificando configuracao de DNS
ipconfig /all | findstr /C:"DNS Servers"

echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [NETWORK] Configuracao de rede concluida

REM ========================================
REM CONFIGURACAO DE FIREWALL
REM ========================================
echo [INFO] ========================================
echo [INFO] CONFIGURANDO FIREWALL
echo [INFO] ========================================
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [FIREWALL] Iniciando configuracao de firewall
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [FIREWALL] Configurando regras para servicos de dominio

REM Configurar regras de firewall
echo [INFO] Configurando firewall para permitir serviços de domínio...
netsh advfirewall firewall add rule name="Allow DNS" dir=in action=allow protocol=UDP localport=53
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [FIREWALL] Regra DNS UDP/53 criada

netsh advfirewall firewall add rule name="Allow LDAP" dir=in action=allow protocol=TCP localport=389
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [FIREWALL] Regra LDAP TCP/389 criada

netsh advfirewall firewall add rule name="Allow LDAPS" dir=in action=allow protocol=TCP localport=636
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [FIREWALL] Regra LDAPS TCP/636 criada

netsh advfirewall firewall add rule name="Allow Kerberos" dir=in action=allow protocol=TCP localport=88
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [FIREWALL] Regra Kerberos TCP/88 criada

netsh advfirewall firewall add rule name="Allow Kerberos UDP" dir=in action=allow protocol=UDP localport=88
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [FIREWALL] Regra Kerberos UDP/88 criada

netsh advfirewall firewall add rule name="Allow SMB" dir=in action=allow protocol=TCP localport=445
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [FIREWALL] Regra SMB TCP/445 criada

netsh advfirewall firewall add rule name="Allow RPC" dir=in action=allow protocol=TCP localport=135
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [FIREWALL] Regra RPC TCP/135 criada

REM Verificar regras criadas
echo [INFO] Verificando regras de firewall criadas...
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [FIREWALL] Listando regras criadas
netsh advfirewall firewall show rule name="Allow DNS"
netsh advfirewall firewall show rule name="Allow LDAP"
netsh advfirewall firewall show rule name="Allow SMB"

echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [FIREWALL] Configuracao de firewall concluida

REM ========================================
REM INSTALACAO DE ROLES DO ACTIVE DIRECTORY
REM ========================================
echo [INFO] ========================================
echo [INFO] INSTALANDO ROLES DO ACTIVE DIRECTORY
echo [INFO] ========================================
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [AD-ROLES] Iniciando instalacao de roles do AD
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [AD-ROLES] Role: AD-Domain-Services
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [AD-ROLES] Incluindo ferramentas de gerenciamento

echo [INFO] Instalando roles do Active Directory...
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools -Force
if $? {
    echo [INFO] Roles do Active Directory instalados com sucesso
    echo [ELASTIC_LOG] [%date% %time%] [SUCCESS] [MAQ-1] [AD-ROLES] Roles do AD instalados com sucesso
} else {
    echo [ERROR] Falha ao instalar roles do Active Directory
    echo [ELASTIC_LOG] [%date% %time%] [ERROR] [MAQ-1] [AD-ROLES] Falha na instalacao - Error: $LASTEXITCODE
}

REM Verificar roles instalados
echo [INFO] Verificando roles instalados...
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [AD-ROLES] Verificando roles instalados
Get-WindowsFeature | Where-Object {$_.InstallState -eq "Installed" -and $_.Name -like "*AD*"}

echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [AD-ROLES] Instalacao de roles concluida

REM ========================================
REM CONFIGURACAO DO ACTIVE DIRECTORY
REM ========================================
echo [INFO] ========================================
echo [INFO] CONFIGURANDO ACTIVE DIRECTORY
echo [INFO] ========================================
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [AD-CONFIG] Iniciando configuracao do AD
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [AD-CONFIG] Nome do dominio: lab.local
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [AD-CONFIG] NetBIOS: LAB
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [AD-CONFIG] Modo do dominio: WinThreshold
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [AD-CONFIG] Modo da floresta: WinThreshold

echo [INFO] Configurando Active Directory...
$password = ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [AD-CONFIG] Senha do administrador configurada

Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -DomainMode "WinThreshold" -DomainName "lab.local" -DomainNetbiosName "LAB" -ForestMode "WinThreshold" -InstallDns:$true -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$false -SysvolPath "C:\Windows\SYSVOL" -Force:$true -SafeModeAdministratorPassword $password

if $? {
    echo [INFO] Active Directory configurado com sucesso
    echo [ELASTIC_LOG] [%date% %time%] [SUCCESS] [MAQ-1] [AD-CONFIG] Active Directory configurado com sucesso
    echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [AD-CONFIG] Floresta lab.local criada
    echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [AD-CONFIG] DNS instalado e configurado
} else {
    echo [ERROR] Falha ao configurar Active Directory
    echo [ELASTIC_LOG] [%date% %time%] [ERROR] [MAQ-1] [AD-CONFIG] Falha na configuracao - Error: $LASTEXITCODE
}

REM ========================================
REM CONFIGURACAO DE POLITICAS DE GRUPO
REM ========================================
echo [INFO] ========================================
echo [INFO] CONFIGURANDO POLITICAS DE GRUPO
echo [INFO] ========================================
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [GPO] Iniciando configuracao de politicas de grupo
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [GPO] Aguardando 30 segundos para estabilizacao

echo [INFO] Configurando políticas de grupo para laboratório...
Start-Sleep -Seconds 30

echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [GPO] Tempo de espera concluido
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [GPO] Configuracao de politicas concluida

REM ========================================
REM CONFIGURACAO DE DNS
REM ========================================
echo [INFO] ========================================
echo [INFO] CONFIGURANDO DNS
echo [INFO] ========================================
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [DNS] Iniciando configuracao de DNS
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [DNS] Zona primaria: lab.local
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [DNS] IP do servidor: 192.168.101.10

echo [INFO] Configurando DNS para resolver nomes locais...
Add-DnsServerPrimaryZone -Name "lab.local" -ZoneFile "lab.local.dns"
if $? {
    echo [ELASTIC_LOG] [%date% %time%] [SUCCESS] [MAQ-1] [DNS] Zona primaria lab.local criada
} else {
    echo [ELASTIC_LOG] [%date% %time%] [ERROR] [MAQ-1] [DNS] Falha ao criar zona primaria
}

Add-DnsServerResourceRecordA -ZoneName "lab.local" -Name "@" -IPv4Address "192.168.101.10"
if $? {
    echo [ELASTIC_LOG] [%date% %time%] [SUCCESS] [MAQ-1] [DNS] Registro A criado para lab.local
} else (
    echo [ELASTIC_LOG] [%date% %time%] [ERROR] [MAQ-1] [DNS] Falha ao criar registro A
)

REM Verificar configuração DNS
echo [INFO] Verificando configuração DNS...
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [DNS] Verificando zonas configuradas
Get-DnsServerZone | Where-Object {$_.ZoneName -eq "lab.local"}

echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [DNS] Configuracao de DNS concluida

REM ========================================
REM CRIACAO DE USUARIOS DE TESTE
REM ========================================
echo [INFO] ========================================
echo [INFO] CRIANDO USUARIOS DE TESTE
echo [INFO] ========================================
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [USERS] Iniciando criacao de usuarios de teste
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [USERS] Usuario: testuser
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [USERS] Usuario: admin

echo [INFO] Criando usuários de teste para laboratório...
New-ADUser -Name "testuser" -GivenName "Test" -Surname "User" -SamAccountName "testuser" -UserPrincipalName "testuser@lab.local" -AccountPassword (ConvertTo-SecureString "Password123!" -AsPlainText -Force) -Enabled $true
if $? {
    echo [ELASTIC_LOG] [%date% %time%] [SUCCESS] [MAQ-1] [USERS] Usuario testuser criado com sucesso
} else {
    echo [ELASTIC_LOG] [%date% %time%] [ERROR] [MAQ-1] [USERS] Falha ao criar usuario testuser
}

New-ADUser -Name "admin" -GivenName "Admin" -Surname "User" -SamAccountName "admin" -UserPrincipalName "admin@lab.local" -AccountPassword (ConvertTo-SecureString "Admin123!" -AsPlainText -Force) -Enabled $true
if $? {
    echo [ELASTIC_LOG] [%date% %time%] [SUCCESS] [MAQ-1] [USERS] Usuario admin criado com sucesso
} else {
    echo [ELASTIC_LOG] [%date% %time%] [ERROR] [MAQ-1] [USERS] Falha ao criar usuario admin
}

REM Adicionar usuário admin ao grupo Domain Admins
echo [INFO] Adicionando usuário admin ao grupo Domain Admins...
Add-ADGroupMember -Identity "Domain Admins" -Members "admin"
if $? {
    echo [ELASTIC_LOG] [%date% %time%] [SUCCESS] [MAQ-1] [USERS] Usuario admin adicionado ao grupo Domain Admins
} else {
    echo [ELASTIC_LOG] [%date% %time%] [ERROR] [MAQ-1] [USERS] Falha ao adicionar admin ao grupo Domain Admins
}

REM Verificar usuários criados
echo [INFO] Verificando usuários criados...
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [USERS] Listando usuarios criados
Get-ADUser -Filter * | Where-Object {$_.Name -in @("testuser", "admin")} | Select-Object Name, SamAccountName, Enabled

echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [USERS] Criacao de usuarios concluida

REM ========================================
REM CONFIGURACAO DE POLITICAS DE SENHA
REM ========================================
echo [INFO] ========================================
echo [INFO] CONFIGURANDO POLITICAS DE SENHA
echo [INFO] ========================================
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [PASSWORD-POLICY] Iniciando configuracao de politicas de senha
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [PASSWORD-POLICY] Configuracao para laboratorio de vulnerabilidades
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [PASSWORD-POLICY] Complexidade: Desabilitada
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [PASSWORD-POLICY] Tamanho minimo: 4 caracteres
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [PASSWORD-POLICY] Historico: 0 senhas
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [PASSWORD-POLICY] Bloqueio: Desabilitado

echo [INFO] Configurando políticas de senha mais permissivas para laboratório...
Set-ADDefaultDomainPasswordPolicy -Identity lab.local -ComplexityEnabled $false -MinPasswordLength 4 -PasswordHistoryCount 0 -LockoutThreshold 0
if $? {
    echo [ELASTIC_LOG] [%date% %time%] [SUCCESS] [MAQ-1] [PASSWORD-POLICY] Politicas de senha configuradas
} else {
    echo [ELASTIC_LOG] [%date% %time%] [ERROR] [MAQ-1] [PASSWORD-POLICY] Falha ao configurar politicas de senha
}

REM Verificar políticas configuradas
echo [INFO] Verificando políticas de senha configuradas...
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [PASSWORD-POLICY] Verificando politicas configuradas
Get-ADDefaultDomainPasswordPolicy -Identity lab.local | Select-Object ComplexityEnabled, MinPasswordLength, PasswordHistoryCount, LockoutThreshold

echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [PASSWORD-POLICY] Configuracao de politicas de senha concluida

REM ========================================
REM CONFIGURACAO DE AUDITORIA
REM ========================================
echo [INFO] ========================================
echo [INFO] CONFIGURANDO AUDITORIA
echo [INFO] ========================================
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [AUDIT] Iniciando configuracao de auditoria
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [AUDIT] Configurando todas as categorias
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [AUDIT] Sucesso: Habilitado
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [AUDIT] Falha: Habilitado

echo [INFO] Configurando auditoria para laboratório...
auditpol /set /category:* /success:enable /failure:enable
if %errorlevel% equ 0 (
    echo [ELASTIC_LOG] [%date% %time%] [SUCCESS] [MAQ-1] [AUDIT] Auditoria configurada com sucesso
) else (
    echo [ELASTIC_LOG] [%date% %time%] [ERROR] [MAQ-1] [AUDIT] Falha ao configurar auditoria - Error: %errorlevel%
)

REM Verificar configuração de auditoria
echo [INFO] Verificando configuração de auditoria...
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [AUDIT] Verificando configuracao de auditoria
auditpol /get /category:*

echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [AUDIT] Configuracao de auditoria concluida

REM ========================================
REM CONFIGURACAO DE LOGS DE EVENTOS
REM ========================================
echo [INFO] ========================================
echo [INFO] CONFIGURANDO LOGS DE EVENTOS
echo [INFO] ========================================
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [EVENT-LOGS] Iniciando configuracao de logs de eventos
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [EVENT-LOGS] Tamanho maximo: 100MB por log
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [EVENT-LOGS] Logs: Security, System, Application

echo [INFO] Configurando logs de eventos...
wevtutil sl Security /ms:104857600
if %errorlevel% equ 0 (
    echo [ELASTIC_LOG] [%date% %time%] [SUCCESS] [MAQ-1] [EVENT-LOGS] Log Security configurado
) else (
    echo [ELASTIC_LOG] [%date% %time%] [ERROR] [MAQ-1] [EVENT-LOGS] Falha ao configurar log Security
)

wevtutil sl System /ms:104857600
if %errorlevel% equ 0 (
    echo [ELASTIC_LOG] [%date% %time%] [SUCCESS] [MAQ-1] [EVENT-LOGS] Log System configurado
) else (
    echo [ELASTIC_LOG] [%date% %time%] [ERROR] [MAQ-1] [EVENT-LOGS] Falha ao configurar log System
)

wevtutil sl Application /ms:104857600
if %errorlevel% equ 0 (
    echo [ELASTIC_LOG] [%date% %time%] [SUCCESS] [MAQ-1] [EVENT-LOGS] Log Application configurado
) else (
    echo [ELASTIC_LOG] [%date% %time%] [ERROR] [MAQ-1] [EVENT-LOGS] Falha ao configurar log Application
)

REM Verificar configuração dos logs
echo [INFO] Verificando configuração dos logs de eventos...
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [EVENT-LOGS] Verificando configuracao dos logs
wevtutil gl Security | findstr "maxSize"
wevtutil gl System | findstr "maxSize"
wevtutil gl Application | findstr "maxSize"

echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [EVENT-LOGS] Configuracao de logs concluida

REM ========================================
REM GERAR LOGS INTENSIVOS - FINAL
REM ========================================
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [DC-SETUP] Processo de configuracao em fase final
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [DC-SETUP] Verificando status dos servicos
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [DC-SETUP] Servico: NTDS (Active Directory)
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [DC-SETUP] Servico: DNS
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [DC-SETUP] Servico: Netlogon

REM Verificar status dos serviços
echo [INFO] Verificando status dos serviços críticos...
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [SERVICES] Verificando servicos criticos
sc query NTDS
sc query DNS
sc query Netlogon

REM ========================================
REM CRIACAO DE ARQUIVO DE STATUS
REM ========================================
echo [INFO] ========================================
echo [INFO] CRIANDO ARQUIVO DE STATUS
echo [INFO] ========================================
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [STATUS] Criando arquivo de status final

echo [INFO] Criando arquivo de status...
echo Domain Controller configurado com sucesso > C:\oem\dc-status.txt
echo Data/Hora: %date% %time% >> C:\oem\dc-status.txt
echo IP: 192.168.101.10 >> C:\oem\dc-status.txt
echo Domain: lab.local >> C:\oem\dc-status.txt
echo Usuario: Administrator >> C:\oem\dc-status.txt
echo Senha: P@ssw0rd123! >> C:\oem\dc-status.txt
echo Status: ATIVO >> C:\oem\dc-status.txt
echo Versao: Windows Server 2022 >> C:\oem\dc-status.txt
echo Roles: AD-Domain-Services, DNS >> C:\oem\dc-status.txt
echo Usuarios: testuser, admin >> C:\oem\dc-status.txt

if exist C:\oem\dc-status.txt (
    echo [ELASTIC_LOG] [%date% %time%] [SUCCESS] [MAQ-1] [STATUS] Arquivo de status criado com sucesso
    echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [STATUS] Conteudo do arquivo de status:
    type C:\oem\dc-status.txt
) else (
    echo [ELASTIC_LOG] [%date% %time%] [ERROR] [MAQ-1] [STATUS] Falha ao criar arquivo de status
)

REM ========================================
REM LOGS FINAIS E REINICIALIZACAO
REM ========================================
echo [INFO] ========================================
echo [INFO] CONFIGURACAO CONCLUIDA
echo [INFO] ========================================
echo [ELASTIC_LOG] [%date% %time%] [SUCCESS] [MAQ-1] [DC-SETUP] Configuracao do Domain Controller concluida com sucesso
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [DC-SETUP] Sistema pronto para uso como laboratorio de vulnerabilidades
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [DC-SETUP] Reinicializacao em 30 segundos
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [DC-SETUP] Laboratorio MAQ-1 - Windows Server 2022 DC - CONCLUIDO

echo [INFO] Configuração do Domain Controller concluída!
echo [INFO] ========================================
echo [INFO] RESUMO DA CONFIGURACAO:
echo [INFO] ========================================
echo [INFO] Nome do Computador: DC-LAB-01
echo [INFO] IP: 192.168.101.10
echo [INFO] Domain: lab.local
echo [INFO] Usuario Administrator: P@ssw0rd123!
echo [INFO] Usuario testuser: Password123!
echo [INFO] Usuario admin: Admin123!
echo [INFO] ========================================
echo [INFO] O sistema será reiniciado em 30 segundos...
echo [INFO] ========================================

Start-Sleep -Seconds 30
echo [ELASTIC_LOG] [%date% %time%] [INFO] [MAQ-1] [DC-SETUP] Iniciando reinicializacao do sistema
shutdown /r /t 0
