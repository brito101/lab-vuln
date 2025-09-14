
# Flood real de logs no Windows Event Log
for ($i=1; $i -le 50; $i++) {
	Write-EventLog -LogName Application -Source "Windows PowerShell" -EventId 1000 -EntryType Information -Message "[LABVULN] Evento falso de login: user=attacker$i ip=192.168.99.$i"
	Write-Host "[FLOOD] Evento falso de login: user=attacker$i ip=192.168.99.$i"
	Start-Sleep -Seconds 2
}
