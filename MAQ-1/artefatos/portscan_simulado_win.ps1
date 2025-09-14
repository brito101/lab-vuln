
# Portscan real em alvos locais
$targets = @("localhost", "127.0.0.1")
$ports = @(22, 80, 443, 3389, 445)
foreach ($t in $targets) {
	foreach ($p in $ports) {
		try {
			$tcp = New-Object System.Net.Sockets.TcpClient
			$tcp.Connect($t, $p)
			if ($tcp.Connected) {
				Write-Host "[PORTSCAN] $t:$p aberto"
				Add-Content -Path "$env:temp\portscan_log.txt" -Value "$t:$p aberto em $(Get-Date)"
			}
			$tcp.Close()
		} catch {
			Write-Host "[PORTSCAN] $t:$p fechado"
			Add-Content -Path "$env:temp\portscan_log.txt" -Value "$t:$p fechado em $(Get-Date)"
		}
		Start-Sleep -Seconds 1
	}
}
