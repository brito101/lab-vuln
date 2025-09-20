
# Script para restaurar arquivos "criptografados" pelo ransomware simulado
$targetDir = "$env:TEMP\VulnFiles"
$keyFile = "$targetDir\.labkey"
$ext = ".locked"

Write-Host "[RESTORE] Iniciando restauração de arquivos..."

if (!(Test-Path $targetDir)) {
    Write-Host "[RESTORE] ERRO: Diretório não encontrado: $targetDir"
    exit 1
}

if (!(Test-Path $keyFile)) {
    Write-Host "[RESTORE] ERRO: Arquivo de chave não encontrado: $keyFile"
    exit 1
}

$key = Get-Content $keyFile
Write-Host "[RESTORE] Chave carregada: $($key.Substring(0,8))..."

# Restaurar arquivos (remover extensão .locked)
$restoredCount = 0
Get-ChildItem -Path $targetDir -File | Where-Object { $_.Extension -eq $ext } | ForEach-Object {
    $lockedFile = $_.FullName
    $originalFile = $lockedFile -replace "$ext$", ""
    
    try {
        Rename-Item $lockedFile $originalFile
        Write-Host "[RESTORE] Arquivo restaurado: $($_.Name)"
        Add-Content -Path "$targetDir\.restore_log" -Value "Arquivo $originalFile restaurado em $(Get-Date)"
        $restoredCount++
        Start-Sleep -Milliseconds 300
    } catch {
        Write-Host "[RESTORE] ERRO ao restaurar $($_.Name): $_"
    }
}

if ($restoredCount -gt 0) {
    Write-Host "[RESTORE] Restauração completa! $restoredCount arquivos restaurados."
    Write-Host "[RESTORE] Arquivos restaurados:"
    Get-ChildItem $targetDir -File | Where-Object { $_.Extension -ne ".locked" -and $_.Name -notlike ".*" -and $_.Name -ne "README_RESCUE.txt" } | Select-Object Name, Length
} else {
    Write-Host "[RESTORE] Nenhum arquivo criptografado encontrado para restaurar."
}
