
# Simulação de exfiltração real de arquivo
$src = "$env:windir\System32\drivers\etc\hosts"
$dst = "$env:temp\exfiltrated_hosts_$(Get-Date -Format yyyyMMddHHmmss).txt"
Copy-Item $src $dst
Write-Host "[EXFIL] Exfiltrado $src para $dst"
Add-Content -Path "$env:temp\exfiltration_log.txt" -Value "Exfiltrado $src para $dst em $(Get-Date)"
