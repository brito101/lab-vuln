
# Script para restaurar arquivos criptografados pelo ransomware_simulado_win.ps1
$targetDir = "C:\vulnerable_files"
$keyFile = "$targetDir\.labkey"
$ext = ".locked"
$key = Get-Content $keyFile

Get-ChildItem -Path $targetDir -File | Where-Object { $_.Extension -eq $ext } | ForEach-Object {
	$in = $_.FullName
	$out = $in -replace "$ext$", ""
	certutil -decode $in $out
	Remove-Item $in
	Add-Content -Path "$targetDir\.restore_log" -Value "Arquivo $out restaurado!"
	Start-Sleep -Seconds 1
}
