$ErrorActionPreference = "SilentlyContinue"

Write-Host "[WINRM-SETUP] Configurando WinRM para laboratório..."

# Habilitar WinRM
Enable-PSRemoting -Force -SkipNetworkProfileCheck

# Configurar autenticação básica
Set-Item WSMan:\localhost\Service\Auth\Basic $true

# Permitir conexões não criptografadas (apenas para laboratório)
Set-Item WSMan:\localhost\Service\AllowUnencrypted $true

# Configurar credenciais para usuário Docker
Set-Item WSMan:\localhost\Service\Auth\CredSSP $true

# Configurar política de execução
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope LocalMachine -Force

# Reiniciar serviço WinRM
Restart-Service WinRM

# Configurar firewall
New-NetFirewallRule -DisplayName "WinRM-HTTP" -Direction Inbound -LocalPort 5985 -Protocol TCP -Action Allow -Profile Any

# Testar configuração
$config = Get-WSManInstance -ResourceURI winrm/config/service
Write-Host "[WINRM-SETUP] Porto: $($config.Port)"
Write-Host "[WINRM-SETUP] AllowUnencrypted: $($config.AllowUnencrypted)"
Write-Host "[WINRM-SETUP] Auth Basic: $(Get-WSManInstance -ResourceURI winrm/config/service/auth | Select-Object -ExpandProperty Basic)"

Write-Host "[WINRM-SETUP] Configuração WinRM completa!"
Write-Host "[WINRM-SETUP] Teste de conexão: Test-WSMan -ComputerName localhost -Port 5985"

# Teste final
try {
    Test-WSMan -ComputerName localhost -Port 5985 -ErrorAction Stop
    Write-Host "[WINRM-SETUP] ✅ WinRM funcionando corretamente!"
} catch {
    Write-Host "[WINRM-SETUP] ❌ Erro no teste WinRM: $($_.Exception.Message)"
}