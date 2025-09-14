# Simulação de exfiltração de dados (Windows)
$Src = "C:\Windows\System32\drivers\etc\hosts"
$Dst = "C:\VulnerableFiles\.exfiltrated_$(Get-Date -Format yyyyMMddHHmmss)"
Copy-Item $Src $Dst
Add-Content "C:\VulnerableFiles\.exfiltration_log" "Exfiltrado $Src para $Dst"
