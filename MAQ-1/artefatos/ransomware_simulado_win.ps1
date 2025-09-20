
# Simulador de ransomware simplificado (Windows)
# "Criptografa" arquivos no diretório TEMP

$targetDir = "$env:TEMP\VulnFiles"
$keyFile = "$targetDir\.labkey"
$noteFile = "$targetDir\README_RESCUE.txt"
$ext = ".locked"

Write-Host "[RANSOMWARE] Iniciando simulação de ransomware..."

# Criar diretório se não existir
if (!(Test-Path $targetDir)) { 
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null 
    Write-Host "[RANSOMWARE] Diretório criado: $targetDir"
}

# Criar alguns arquivos de teste
$testFiles = @("documento.txt", "dados.csv", "config.ini", "backup.db")
foreach ($file in $testFiles) {
    $filePath = Join-Path $targetDir $file
    "Conteúdo importante do arquivo $file criado em $(Get-Date)" | Set-Content -Path $filePath
    Write-Host "[RANSOMWARE] Arquivo criado: $file"
}

# Gerar chave
$key = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 32 | ForEach-Object {[char]$_})
Set-Content -Path $keyFile -Value $key
Write-Host "[RANSOMWARE] Chave gerada e salva"

# Simular criptografia (renomear arquivo)
Get-ChildItem -Path $targetDir -File | Where-Object { $_.Extension -ne $ext -and $_.Name -ne ".labkey" -and $_.Name -ne "README_RESCUE.txt" } | ForEach-Object {
    $oldName = $_.FullName
    $newName = "$oldName$ext"
    Rename-Item $oldName $newName
    Write-Host "[RANSOMWARE] Arquivo $($_.Name) criptografado"
    Add-Content -Path "$targetDir\.ransom_log" -Value "Arquivo $($_.Name) criptografado em $(Get-Date)"
    Start-Sleep -Milliseconds 500
}

# Criar nota de resgate
@"
SEUS ARQUIVOS FORAM CRIPTOGRAFADOS!
Para restaurar, use o script de restauração. A chave está em $keyFile.
Data: $(Get-Date)
"@ | Set-Content -Path $noteFile -Encoding UTF8

Write-Host "[RANSOMWARE] Simulação completa! Arquivos criptografados em $targetDir"
Write-Host "[RANSOMWARE] Arquivos afetados:"
Get-ChildItem $targetDir -Filter "*.locked" | Select-Object Name, Length
