# attack-test.ps1 - Menu para disparar artefatos dinâmicos (Windows)
function Show-Menu {
    Write-Host "==== Disparar Artefatos Dinâmicos ===="
    Write-Host "1) Ransomware Simulado"
    Write-Host "2) Flood de Logs"
    Write-Host "3) Exfiltração Simulada"
    Write-Host "4) Portscan Simulado"
    Write-Host "5) Persistência Simulada"
    Write-Host "6) Webshell ASPX (IIS)"
    Write-Host "7) Executar agente de C2 (svcmon)"
    Write-Host "0) Sair"
}

function Run-Ransomware { Write-Host "Disparando ransomware_simulado_win.ps1..."; powershell.exe -File C:\VulnerableFiles\ransomware_simulado_win.ps1 }
function Run-FloodLogs { Write-Host "Disparando flood_logs_win.ps1..."; powershell.exe -File C:\VulnerableFiles\flood_logs_win.ps1 }
function Run-Exfiltracao { Write-Host "Disparando exfiltracao_simulada_win.ps1..."; powershell.exe -File C:\VulnerableFiles\exfiltracao_simulada_win.ps1 }
function Run-Portscan { Write-Host "Disparando portscan_simulado_win.ps1..."; powershell.exe -File C:\VulnerableFiles\portscan_simulado_win.ps1 }
function Run-Persistencia { Write-Host "Disparando persistencia_simulada_win.ps1..."; powershell.exe -File C:\VulnerableFiles\persistencia_simulada_win.ps1 }
function Show-Webshell { Write-Host "Webshell disponível em C:\inetpub\wwwroot\webshell_simulado_win.aspx" }
function Run-C2Agent { Write-Host "Executando agente de C2 (svcmon.py)..."; python.exe C:\artefatos\svcmon.py }

while ($true) {
    Show-Menu
    $opt = Read-Host "Escolha uma opção"
    switch ($opt) {
        '1' { Run-Ransomware }
        '2' { Run-FloodLogs }
        '3' { Run-Exfiltracao }
        '4' { Run-Portscan }
        '5' { Run-Persistencia }
        '6' { Show-Webshell }
    '7' { Run-C2Agent }
        '0' { break }
        default { Write-Host "Opção inválida" }
    }
}
