# Simulação de port scan interno (Windows)
$Targets = @("localhost", "192.168.201.2", "192.168.201.3")
$Ports = @(22, 80, 443, 3389, 8080)
foreach ($t in $Targets) {
  foreach ($p in $Ports) {
    try {
      $tcp = New-Object System.Net.Sockets.TcpClient
      $tcp.Connect($t, $p)
      Add-Content "C:\VulnerableFiles\portscan.log" "[PORTSCAN] $t:$p aberto"
      $tcp.Close()
    } catch {
      Add-Content "C:\VulnerableFiles\portscan.log" "[PORTSCAN] $t:$p fechado"
    }
    Start-Sleep -Seconds 1
  }
}
