# Script para restaurar arquivos criptografados pelo ransomware_simulado_win.ps1
$TargetDir = "C:\VulnerableFiles"
$KeyFile = "$TargetDir\labkey.txt"
$Ext = ".locked"
$Key = Get-Content $KeyFile

Get-ChildItem -Path $TargetDir -File | Where-Object { $_.Extension -eq $Ext } | ForEach-Object {
    $Encrypted = Get-Content $_.FullName -Raw
    $Decoded = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($Encrypted))
    $Orig = $Decoded.Replace($Key, "")
    $OrigPath = $_.FullName.Replace($Ext, "")
    Set-Content -Path $OrigPath -Value $Orig
    Remove-Item $_.FullName
}
