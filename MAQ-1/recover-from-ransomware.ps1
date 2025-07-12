# Ransomware Recovery Script - SAFE RECOVERY
# Author: Vuln Lab
# Version: 1.0
# This script recovers from the ransomware simulation

# Configuration
$TargetDirectory = "C:\Users\Public\Documents\TestFiles"
$BackupDirectory = "C:\Users\Public\Documents\BackupFiles"
$RansomNoteFile = "C:\Users\Public\Desktop\RANSOM_NOTE.txt"
$LogFile = "C:\Windows\Temp\ransomware_recovery.log"

function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
    Add-Content -Path $LogFile -Value "$(Get-Date): $Message"
}

function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Restore-FilesFromBackup {
    Write-ColorOutput "=== RESTORING FILES FROM BACKUP ===" "Blue"
    
    try {
        if (!(Test-Path $BackupDirectory)) {
            Write-ColorOutput "Backup directory not found: $BackupDirectory" "Red"
            return $false
        }
        
        # Get all backup files
        $backupFiles = Get-ChildItem -Path $BackupDirectory -File
        
        if ($backupFiles.Count -eq 0) {
            Write-ColorOutput "No backup files found in: $BackupDirectory" "Red"
            return $false
        }
        
        # Restore each file
        foreach ($backupFile in $backupFiles) {
            try {
                $originalPath = Join-Path $TargetDirectory $backupFile.Name
                
                # Remove encrypted file if it exists
                if (Test-Path $originalPath) {
                    Remove-Item -Path $originalPath -Force
                    Write-ColorOutput "Removed encrypted file: $($backupFile.Name)" "Yellow"
                }
                
                # Restore original file
                Copy-Item -Path $backupFile.FullName -Destination $originalPath -Force
                Write-ColorOutput "Restored file: $($backupFile.Name)" "Green"
            }
            catch {
                Write-ColorOutput "Error restoring $($backupFile.Name): $($_.Exception.Message)" "Red"
            }
        }
        
        Write-ColorOutput "✅ File restoration completed" "Green"
        return $true
    }
    catch {
        Write-ColorOutput "Error in file restoration: $($_.Exception.Message)" "Red"
        return $false
    }
}

function Remove-EncryptedFiles {
    Write-ColorOutput "=== REMOVING ENCRYPTED FILES ===" "Blue"
    
    try {
        # Find all .encrypted files
        $encryptedFiles = Get-ChildItem -Path $TargetDirectory -Filter "*.encrypted" -Recurse
        
        foreach ($file in $encryptedFiles) {
            try {
                Remove-Item -Path $file.FullName -Force
                Write-ColorOutput "Removed encrypted file: $($file.Name)" "Yellow"
            }
            catch {
                Write-ColorOutput "Error removing $($file.Name): $($_.Exception.Message)" "Red"
            }
        }
        
        Write-ColorOutput "✅ Encrypted files removal completed" "Green"
        return $true
    }
    catch {
        Write-ColorOutput "Error removing encrypted files: $($_.Exception.Message)" "Red"
        return $false
    }
}

function Remove-RansomNotes {
    Write-ColorOutput "=== REMOVING RANSOM NOTES ===" "Blue"
    
    try {
        $ransomNoteLocations = @(
            "C:\Users\Public\Desktop\RANSOM_NOTE.txt",
            "$TargetDirectory\RANSOM_NOTE.txt",
            "C:\Users\Public\Documents\RANSOM_NOTE.txt"
        )
        
        foreach ($location in $ransomNoteLocations) {
            if (Test-Path $location) {
                try {
                    Remove-Item -Path $location -Force
                    Write-ColorOutput "Removed ransom note: $location" "Yellow"
                }
                catch {
                    Write-ColorOutput "Error removing ransom note $location: $($_.Exception.Message)" "Red"
                }
            }
        }
        
        Write-ColorOutput "✅ Ransom notes removal completed" "Green"
        return $true
    }
    catch {
        Write-ColorOutput "Error removing ransom notes: $($_.Exception.Message)" "Red"
        return $false
    }
}

function Clean-RegistryEntries {
    Write-ColorOutput "=== CLEANING REGISTRY ENTRIES ===" "Blue"
    
    try {
        $simulationKey = "HKLM:\SOFTWARE\RansomwareSimulation"
        
        if (Test-Path $simulationKey) {
            try {
                Remove-Item -Path $simulationKey -Recurse -Force
                Write-ColorOutput "Removed registry key: $simulationKey" "Yellow"
            }
            catch {
                Write-ColorOutput "Error removing registry key: $($_.Exception.Message)" "Red"
            }
        } else {
            Write-ColorOutput "Registry key not found: $simulationKey" "Yellow"
        }
        
        Write-ColorOutput "✅ Registry cleaning completed" "Green"
        return $true
    }
    catch {
        Write-ColorOutput "Error cleaning registry: $($_.Exception.Message)" "Red"
        return $false
    }
}

function Clean-TemporaryFiles {
    Write-ColorOutput "=== CLEANING TEMPORARY FILES ===" "Blue"
    
    try {
        $tempFiles = @(
            "C:\Windows\Temp\ransomware_simulation.log",
            "C:\Windows\Temp\ransomware_recovery.log",
            "C:\Windows\Temp\network_activity.log"
        )
        
        foreach ($file in $tempFiles) {
            if (Test-Path $file) {
                try {
                    Remove-Item -Path $file -Force
                    Write-ColorOutput "Removed temp file: $file" "Yellow"
                }
                catch {
                    Write-ColorOutput "Error removing temp file $file: $($_.Exception.Message)" "Red"
                }
            }
        }
        
        Write-ColorOutput "✅ Temporary files cleaning completed" "Green"
        return $true
    }
    catch {
        Write-ColorOutput "Error cleaning temp files: $($_.Exception.Message)" "Red"
        return $false
    }
}

function Verify-Recovery {
    Write-ColorOutput "=== VERIFYING RECOVERY ===" "Blue"
    
    try {
        $verificationResults = @()
        
        # Check if files are restored
        $restoredFiles = Get-ChildItem -Path $TargetDirectory -File -Recurse | Where-Object {$_.Extension -ne ".encrypted"}
        $verificationResults += "Restored files: $($restoredFiles.Count)"
        
        # Check if encrypted files are removed
        $encryptedFiles = Get-ChildItem -Path $TargetDirectory -Filter "*.encrypted" -Recurse
        $verificationResults += "Remaining encrypted files: $($encryptedFiles.Count)"
        
        # Check if ransom notes are removed
        $ransomNotes = Get-ChildItem -Path "C:\Users\Public" -Filter "*RANSOM*" -Recurse
        $verificationResults += "Remaining ransom notes: $($ransomNotes.Count)"
        
        # Check if registry is cleaned
        $registryKey = "HKLM:\SOFTWARE\RansomwareSimulation"
        $registryExists = Test-Path $registryKey
        $verificationResults += "Registry key exists: $registryExists"
        
        # Display verification results
        foreach ($result in $verificationResults) {
            Write-ColorOutput $result "Yellow"
        }
        
        if ($encryptedFiles.Count -eq 0 -and $ransomNotes.Count -eq 0 -and !$registryExists) {
            Write-ColorOutput "✅ Recovery verification successful!" "Green"
            return $true
        } else {
            Write-ColorOutput "⚠️  Some items may still need manual cleanup" "Yellow"
            return $false
        }
    }
    catch {
        Write-ColorOutput "Error in recovery verification: $($_.Exception.Message)" "Red"
        return $false
    }
}

function Create-RecoveryReport {
    Write-ColorOutput "=== CREATING RECOVERY REPORT ===" "Blue"
    
    try {
        $reportPath = "C:\Users\Public\Desktop\RANSOMWARE_RECOVERY_REPORT.txt"
        
        $recoveryReport = @"
╔══════════════════════════════════════════════════════════════════════════════╗
║                    RANSOMWARE RECOVERY REPORT                                ║
║                                                                              ║
║  Recovery Type: Ransomware Simulation Recovery                              ║
║  Date/Time: $(Get-Date)                                                     ║
║  Status: COMPLETED                                                          ║
║                                                                              ║
║  RECOVERY ACTIONS PERFORMED:                                                ║
║  ✅ Files restored from backup                                               ║
║  ✅ Encrypted files removed                                                 ║
║  ✅ Ransom notes deleted                                                    ║
║  ✅ Registry entries cleaned                                                ║
║  ✅ Temporary files removed                                                 ║
║                                                                              ║
║  RECOVERY DETAILS:                                                          ║
║  - Target Directory: $TargetDirectory                                        ║
║  - Backup Directory: $BackupDirectory                                        ║
║  - Files Restored: $(Get-ChildItem -Path $TargetDirectory -File -Recurse | Measure-Object).Count ║
║  - Recovery Time: $(Get-Date)                                               ║
║                                                                              ║
║  LESSONS LEARNED:                                                           ║
║  - Importance of regular backups                                            ║
║  - Need for incident response procedures                                    ║
║  - Value of user awareness training                                         ║
║  - Importance of security monitoring                                        ║
║  - Need for recovery testing                                                ║
║                                                                              ║
║  PREVENTION RECOMMENDATIONS:                                                ║
║  - Implement email security                                                 ║
║  - Use endpoint protection                                                  ║
║  - Regular security updates                                                 ║
║  - Network segmentation                                                     ║
║  - User training programs                                                   ║
║                                                                              ║
║  RECOVERY VERIFICATION:                                                     ║
║  - All files restored successfully                                          ║
║  - No encrypted files remaining                                             ║
║  - No ransom notes found                                                    ║
║  - Registry cleaned                                                         ║
║                                                                              ║
║  This recovery was performed on a controlled simulation.                    ║
║  In real incidents, additional steps may be required.                      ║
╚══════════════════════════════════════════════════════════════════════════════╝
"@
        
        Set-Content -Path $reportPath -Value $recoveryReport -Force
        Write-ColorOutput "✅ Recovery report created at: $reportPath" "Green"
        
        return $true
    }
    catch {
        Write-ColorOutput "Error creating recovery report: $($_.Exception.Message)" "Red"
        return $false
    }
}

function Show-Summary {
    Write-ColorOutput "`n=== RANSOMWARE RECOVERY SUMMARY ===" "Blue"
    Write-ColorOutput "✅ Files restored from backup" "Green"
    Write-ColorOutput "✅ Encrypted files removed" "Green"
    Write-ColorOutput "✅ Ransom notes deleted" "Green"
    Write-ColorOutput "✅ Registry entries cleaned" "Green"
    Write-ColorOutput "✅ Temporary files removed" "Green"
    Write-ColorOutput "✅ Recovery verification completed" "Green"
    Write-ColorOutput "✅ Recovery report created" "Green"
    
    Write-ColorOutput "`n=== RECOVERY DETAILS ===" "Yellow"
    Write-ColorOutput "Target Directory: $TargetDirectory" "Yellow"
    Write-ColorOutput "Backup Directory: $BackupDirectory" "Yellow"
    Write-ColorOutput "Recovery Report: C:\Users\Public\Desktop\RANSOMWARE_RECOVERY_REPORT.txt" "Yellow"
    Write-ColorOutput "Log File: $LogFile" "Yellow"
    
    Write-ColorOutput "`n🎉 RANSOMWARE RECOVERY COMPLETED SUCCESSFULLY! 🎉" "Green"
}

# MAIN FUNCTION
function Start-RansomwareRecovery {
    Write-ColorOutput "=== RANSOMWARE RECOVERY TOOL ===" "Blue"
    Write-ColorOutput "Lab Vuln - Cybersecurity Training" "Blue"
    Write-ColorOutput "Version: 1.0" "Blue"
    Write-ColorOutput "Date: $(Get-Date)" "Blue"
    
    # Check if running as administrator
    if (!(Test-Administrator)) {
        Write-ColorOutput "ERROR: This script must be run as Administrator!" "Red"
        return
    }
    
    Write-ColorOutput "`nThis tool will recover from the ransomware simulation." "Yellow"
    Write-ColorOutput "It will restore files from backup and clean up simulation artifacts." "Yellow"
    
    $continue = Read-Host "`nDo you want to proceed with recovery? (Y/N)"
    if ($continue -ne "Y" -and $continue -ne "y") {
        Write-ColorOutput "Recovery cancelled by user." "Yellow"
        return
    }
    
    # Execute recovery steps
    $steps = @(
        @{Name = "Restore Files from Backup"; Function = "Restore-FilesFromBackup"},
        @{Name = "Remove Encrypted Files"; Function = "Remove-EncryptedFiles"},
        @{Name = "Remove Ransom Notes"; Function = "Remove-RansomNotes"},
        @{Name = "Clean Registry Entries"; Function = "Clean-RegistryEntries"},
        @{Name = "Clean Temporary Files"; Function = "Clean-TemporaryFiles"},
        @{Name = "Verify Recovery"; Function = "Verify-Recovery"},
        @{Name = "Create Recovery Report"; Function = "Create-RecoveryReport"}
    )
    
    foreach ($step in $steps) {
        Write-ColorOutput "`nExecuting: $($step.Name)" "Blue"
        & $step.Function
        
        if ($LASTEXITCODE -ne 0) {
            Write-ColorOutput "Error in step: $($step.Name)" "Red"
            return
        }
    }
    
    Show-Summary
}

# Execute recovery
Start-RansomwareRecovery 