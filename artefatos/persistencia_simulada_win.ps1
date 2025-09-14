# Simulação de persistência (Windows)
$TaskName = "LabPersistencia"
$ScriptPath = "C:\VulnerableFiles\persistencia_simulada_win.ps1"
$Action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-File $ScriptPath"
$Trigger = New-ScheduledTaskTrigger -AtStartup
Register-ScheduledTask -TaskName $TaskName -Action $Action -Trigger $Trigger -Force
Add-Content "C:\VulnerableFiles\persistencia.log" "Persistência simulada ativada em $(Get-Date)"
