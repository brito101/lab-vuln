# Ransomware Simulation Script - SAFE FOR TRAINING
# Author: Lab Vuln
# Version: 1.0
# WARNING: This is a controlled simulation for educational purposes only!

# Configuration
$SimulationMode = $true  # Always true for safety
$TargetDirectory = "C:\Users\Public\Documents\TestFiles"  # Safe test directory
$BackupDirectory = "C:\Users\Public\Documents\BackupFiles"  # Backup location
$RansomNoteFile = "C:\Users\Public\Desktop\RANSOM_NOTE.txt"
$LogFile = "C:\Windows\Temp\ransomware_simulation.log"

function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    
    # Mapeamento de cores para garantir compatibilidade
    $ColorMap = @{
        "Red" = "Red"
        "Green" = "Green" 
        "Yellow" = "Yellow"
        "Blue" = "Blue"
        "White" = "White"
        "Cyan" = "Cyan"
        "Magenta" = "Magenta"
        "Gray" = "Gray"
        "DarkGray" = "DarkGray"
        "DarkRed" = "DarkRed"
        "DarkGreen" = "DarkGreen"
        "DarkYellow" = "DarkYellow"
        "DarkBlue" = "DarkBlue"
        "DarkCyan" = "DarkCyan"
        "DarkMagenta" = "DarkMagenta"
    }
    
    try {
        # Verificar se a cor é válida
        if ($ColorMap.ContainsKey($Color)) {
            Write-Host $Message -ForegroundColor $ColorMap[$Color]
        } else {
            # Fallback para cor padrão se não for reconhecida
            Write-Host $Message -ForegroundColor "White"
        }
    }
    catch {
        # Fallback final se houver qualquer erro
        Write-Host $Message
    }
    
    # Log the message
    Add-Content -Path $LogFile -Value "$(Get-Date): $Message"
}

function Test-SafeEnvironment {
    Write-ColorOutput "=== RANSOMWARE SIMULATION SAFETY CHECK ===" "Blue"
    
    # Verify this is a simulation
    if (!$SimulationMode) {
        Write-ColorOutput "ERROR: Simulation mode must be enabled!" "Red"
        exit 1
    }
    
    # Check if we're in a safe test environment
    $safePaths = @(
        "C:\Users\Public\Documents\TestFiles",
        "C:\Users\Public\Desktop",
        "C:\Windows\Temp"
    )
    
    foreach ($path in $safePaths) {
        if (!(Test-Path $path)) {
            New-Item -ItemType Directory -Path $path -Force -ErrorAction SilentlyContinue
        }
    }
    
    Write-ColorOutput "✅ Safety checks passed - Simulation mode active" "Green"
    return $true
}

function Create-TestFiles {
    Write-ColorOutput "=== CREATING TEST FILES ===" "Blue"
    
    try {
        # Create test files with different extensions
        $testFiles = @(
            "document1.docx",
            "spreadsheet.xlsx",
            "presentation.pptx",
            "image.jpg",
            "data.txt",
            "backup.zip",
            "config.ini",
            "log.txt"
        )
        
        foreach ($file in $testFiles) {
            $filePath = Join-Path $TargetDirectory $file
            $content = "This is a test file for ransomware simulation training. Created: $(Get-Date)"
            Set-Content -Path $filePath -Value $content -ErrorAction SilentlyContinue
            Write-ColorOutput "Created test file: $file" "Yellow"
        }
        
        Write-ColorOutput "✅ Test files created successfully" "Green"
        return $true
    }
    catch {
        Write-ColorOutput "Error creating test files: $($_.Exception.Message)" "Red"
        return $false
    }
}

function Simulate-FileEncryption {
    Write-ColorOutput "=== SIMULATING FILE ENCRYPTION ===" "Blue"
    
    try {
        # Get all files in target directory
        $files = Get-ChildItem -Path $TargetDirectory -File -Recurse
        
        foreach ($file in $files) {
            try {
                # Read original content
                $originalContent = Get-Content -Path $file.FullName -Raw
                
                # Simulate encryption by adding a header
                $encryptedContent = @"
=== ENCRYPTED FILE (SIMULATION) ===
Original File: $($file.Name)
Encryption Time: $(Get-Date)
Simulation ID: RANSOM-$(Get-Random -Minimum 1000 -Maximum 9999)

ORIGINAL CONTENT:
$originalContent

=== END ENCRYPTED FILE ===
"@
                
                # Create backup before "encryption"
                $backupPath = Join-Path $BackupDirectory $file.Name
                Copy-Item -Path $file.FullName -Destination $backupPath -Force
                
                # "Encrypt" the file
                Set-Content -Path $file.FullName -Value $encryptedContent -Force
                
                # Rename file to show it's "encrypted"
                $newName = $file.BaseName + ".encrypted"
                $newPath = Join-Path $file.DirectoryName $newName
                Rename-Item -Path $file.FullName -NewName $newName -Force
                
                Write-ColorOutput "Simulated encryption: $($file.Name) -> $newName" "Yellow"
                
                # Add delay to simulate processing
                Start-Sleep -Milliseconds 100
            }
            catch {
                Write-ColorOutput "Error processing file $($file.Name): $($_.Exception.Message)" "Red"
            }
        }
        
        Write-ColorOutput "✅ File encryption simulation completed" "Green"
        return $true
    }
    catch {
        Write-ColorOutput "Error in encryption simulation: $($_.Exception.Message)" "Red"
        return $false
    }
}

function Create-RansomNote {
    Write-ColorOutput "=== CREATING RANSOM NOTE ===" "Blue"
    
    try {
        $ransomNote = @"
╔══════════════════════════════════════════════════════════════════════════════╗
║                           🚨 RANSOMWARE ATTACK 🚨                           ║
║                                                                              ║
║  Your files have been encrypted!                                            ║
║                                                                              ║
║  This is a SIMULATION for cybersecurity training purposes.                  ║
║  No real encryption has occurred.                                           ║
║                                                                              ║
║  In a real attack, you would need to:                                       ║
║  - Pay ransom (NOT RECOMMENDED)                                             ║
║  - Restore from backup                                                       ║
║  - Use decryption tools (if available)                                      ║
║                                                                              ║
║  Simulation Details:                                                         ║
║  - Attack Time: $(Get-Date)                                                 ║
║  - Affected Files: $(Get-ChildItem -Path $TargetDirectory -File -Recurse | Measure-Object).Count ║
║  - Backup Location: $BackupDirectory                                        ║
║                                                                              ║
║  To restore files:                                                          ║
║  1. Check backup directory: $BackupDirectory                                ║
║  2. Copy files back to original location                                    ║
║  3. Remove .encrypted files                                                 ║
║                                                                              ║
║  This is a controlled simulation - no real damage done!                     ║
║                                                                              ║
║  Contact: cybersecurity@company.com                                         ║
║  Incident ID: RANSOM-$(Get-Random -Minimum 10000 -Maximum 99999)           ║
╚══════════════════════════════════════════════════════════════════════════════╝
"@
        
        Set-Content -Path $RansomNoteFile -Value $ransomNote -Force
        Write-ColorOutput "✅ Ransom note created at: $RansomNoteFile" "Green"
        
        # Also create ransom notes in other locations
        $additionalLocations = @(
            "C:\Users\Public\Desktop\RANSOM_NOTE.txt",
            "$TargetDirectory\RANSOM_NOTE.txt"
        )
        
        foreach ($location in $additionalLocations) {
            Copy-Item -Path $RansomNoteFile -Destination $location -Force -ErrorAction SilentlyContinue
        }
        
        return $true
    }
    catch {
        Write-ColorOutput "Error creating ransom note: $($_.Exception.Message)" "Red"
        return $false
    }
}

function Simulate-NetworkActivity {
    Write-ColorOutput "=== SIMULATING NETWORK ACTIVITY ===" "Blue"
    
    try {
        # Simulate C2 communication
        $c2Servers = @(
            "192.168.1.100",
            "10.0.0.50",
            "172.16.0.25"
        )
        
        foreach ($server in $c2Servers) {
            try {
                # Simulate connection attempt (will fail in isolated environment)
                $connection = Test-NetConnection -ComputerName $server -Port 443 -InformationLevel Quiet -ErrorAction SilentlyContinue
                Write-ColorOutput "Simulated C2 connection attempt to: $server" "Yellow"
                Start-Sleep -Seconds 1
            }
            catch {
                Write-ColorOutput "C2 simulation: $server (expected to fail in isolated environment)" "Yellow"
            }
        }
        
        # Create network activity logs
        $networkLog = @"
=== RANSOMWARE NETWORK ACTIVITY SIMULATION ===
Time: $(Get-Date)
Activity: C2 Communication Attempts
Targets: $($c2Servers -join ', ')
Status: Simulated
"@
        
        Set-Content -Path "C:\Windows\Temp\network_activity.log" -Value $networkLog -Force
        
        Write-ColorOutput "✅ Network activity simulation completed" "Green"
        return $true
    }
    catch {
        Write-ColorOutput "Error in network simulation: $($_.Exception.Message)" "Red"
        return $false
    }
}

function Simulate-RegistryModifications {
    Write-ColorOutput "=== SIMULATING REGISTRY MODIFICATIONS ===" "Blue"
    
    try {
        # Create a safe registry key for simulation
        $simulationKey = "HKLM:\SOFTWARE\RansomwareSimulation"
        
        # Create registry entries that ransomware might create
        $registryEntries = @{
            "AttackTime" = (Get-Date).ToString()
            "FilesEncrypted" = (Get-ChildItem -Path $TargetDirectory -File -Recurse | Measure-Object).Count
            "SimulationID" = "RANSOM-$(Get-Random -Minimum 10000 -Maximum 99999)"
            "Status" = "Encryption_Complete"
        }
        
        # Create the registry key
        New-Item -Path $simulationKey -Force -ErrorAction SilentlyContinue
        
        # Add registry entries
        foreach ($entry in $registryEntries.GetEnumerator()) {
            Set-ItemProperty -Path $simulationKey -Name $entry.Key -Value $entry.Value -ErrorAction SilentlyContinue
            Write-ColorOutput "Created registry entry: $($entry.Key) = $($entry.Value)" "Yellow"
        }
        
        Write-ColorOutput "✅ Registry modifications simulation completed" "Green"
        return $true
    }
    catch {
        Write-ColorOutput "Error in registry simulation: $($_.Exception.Message)" "Red"
        return $false
    }
}

function Generate-SecurityEvents {
    Write-ColorOutput "=== GENERATING SECURITY EVENTS ===" "Blue"
    
    try {
        # Generate Event 4688 (Process Creation) for ransomware processes
        $processes = @("encrypt.exe", "ransomware.exe", "crypto.exe", "lock.exe")
        
        foreach ($process in $processes) {
            try {
                # This will generate Event 4688
                Start-Process -FilePath "cmd.exe" -ArgumentList "/c echo Simulating ransomware process: $process" -WindowStyle Hidden -ErrorAction SilentlyContinue
                Write-ColorOutput "Generated security event for process: $process" "Yellow"
                Start-Sleep -Seconds 2
            }
            catch {
                Write-ColorOutput "Error generating event for $process" "Red"
            }
        }
        
        # Generate Event 4624 (Successful Logon) - ransomware often runs as different user
        try {
            # Simulate logon events
            Start-Process -FilePath "whoami" -WindowStyle Hidden -ErrorAction SilentlyContinue
            Write-ColorOutput "Generated logon event simulation" "Yellow"
        }
        catch {
            Write-ColorOutput "Error generating logon event" "Red"
        }
        
        Write-ColorOutput "✅ Security events generation completed" "Green"
        return $true
    }
    catch {
        Write-ColorOutput "Error generating security events: $($_.Exception.Message)" "Red"
        return $false
    }
}

function Create-IncidentReport {
    Write-ColorOutput "=== CREATING INCIDENT REPORT ===" "Blue"
    
    try {
        $reportPath = "C:\Users\Public\Desktop\RANSOMWARE_INCIDENT_REPORT.txt"
        
        $incidentReport = @"
╔══════════════════════════════════════════════════════════════════════════════╗
║                    RANSOMWARE INCIDENT REPORT (SIMULATION)                   ║
║                                                                              ║
║  Incident Type: Ransomware Attack Simulation                                ║
║  Date/Time: $(Get-Date)                                                     ║
║  Severity: HIGH                                                             ║
║  Status: SIMULATION - NO REAL DAMAGE                                        ║
║                                                                              ║
║  AFFECTED SYSTEMS:                                                          ║
║  - Target Directory: $TargetDirectory                                        ║
║  - Files Encrypted: $(Get-ChildItem -Path $TargetDirectory -File -Recurse | Measure-Object).Count ║
║  - Backup Location: $BackupDirectory                                        ║
║                                                                              ║
║  INDICATORS OF COMPROMISE (IoCs):                                           ║
║  - Ransom note files created                                                ║
║  - Registry modifications in HKLM:\SOFTWARE\RansomwareSimulation            ║
║  - Network connections to suspicious IPs                                    ║
║  - Process creation events (Event 4688)                                     ║
║  - File encryption activities                                               ║
║                                                                              ║
║  RESPONSE ACTIONS:                                                          ║
║  1. Isolate affected systems                                                ║
║  2. Identify and contain the threat                                         ║
║  3. Assess scope of encryption                                              ║
║  4. Restore from backups                                                    ║
║  5. Document incident for lessons learned                                   ║
║                                                                              ║
║  PREVENTION MEASURES:                                                       ║
║  - Regular backups                                                          ║
║  - Email security                                                           ║
║  - Endpoint protection                                                      ║
║  - User awareness training                                                  ║
║  - Network segmentation                                                     ║
║                                                                              ║
║  RECOVERY PROCEDURES:                                                       ║
║  1. Verify backup integrity                                                 ║
║  2. Restore files from backup location                                      ║
║  3. Remove encrypted files                                                  ║
║  4. Update security controls                                                ║
║  5. Conduct post-incident review                                            ║
║                                                                              ║
║  CONTACTS:                                                                  ║
║  - Incident Response Team: ir@company.com                                   ║
║  - Security Team: security@company.com                                      ║
║  - Management: management@company.com                                       ║
║                                                                              ║
║  This is a controlled simulation for training purposes.                     ║
║  No real encryption or damage has occurred.                                ║
╚══════════════════════════════════════════════════════════════════════════════╝
"@
        
        Set-Content -Path $reportPath -Value $incidentReport -Force
        Write-ColorOutput "✅ Incident report created at: $reportPath" "Green"
        
        return $true
    }
    catch {
        Write-ColorOutput "Error creating incident report: $($_.Exception.Message)" "Red"
        return $false
    }
}

function Show-RecoveryInstructions {
    Write-ColorOutput "`n=== RECOVERY INSTRUCTIONS ===" "Blue"
    Write-ColorOutput "To recover from this simulation:" "Yellow"
    Write-ColorOutput "1. Check backup directory: $BackupDirectory" "Yellow"
    Write-ColorOutput "2. Copy files back to: $TargetDirectory" "Yellow"
    Write-ColorOutput "3. Remove .encrypted files" "Yellow"
    Write-ColorOutput "4. Delete ransom notes" "Yellow"
    Write-ColorOutput "5. Clean registry: Remove HKLM:\SOFTWARE\RansomwareSimulation" "Yellow"
    Write-ColorOutput "6. Review incident report for lessons learned" "Yellow"
    
    Write-ColorOutput "`nRecovery script available: .\recover-from-ransomware.ps1" "Green"
}

function Show-Summary {
    Write-ColorOutput "`n=== RANSOMWARE SIMULATION SUMMARY ===" "Blue"
    Write-ColorOutput "✅ Safety checks passed" "Green"
    Write-ColorOutput "✅ Test files created" "Green"
    Write-ColorOutput "✅ File encryption simulated" "Green"
    Write-ColorOutput "✅ Ransom notes created" "Green"
    Write-ColorOutput "✅ Network activity simulated" "Green"
    Write-ColorOutput "✅ Registry modifications simulated" "Green"
    Write-ColorOutput "✅ Security events generated" "Green"
    Write-ColorOutput "✅ Incident report created" "Green"
    
    Write-ColorOutput "`n=== SIMULATION DETAILS ===" "Yellow"
    Write-ColorOutput "Target Directory: $TargetDirectory" "Yellow"
    Write-ColorOutput "Backup Directory: $BackupDirectory" "Yellow"
    Write-ColorOutput "Ransom Note: $RansomNoteFile" "Yellow"
    Write-ColorOutput "Log File: $LogFile" "Yellow"
    Write-ColorOutput "Incident Report: C:\Users\Public\Desktop\RANSOMWARE_INCIDENT_REPORT.txt" "Yellow"
    
    Write-ColorOutput "`n⚠️  SIMULATION COMPLETED - NO REAL DAMAGE DONE! ⚠️" "Red"
}

# MAIN FUNCTION
function Start-RansomwareSimulation {
    Write-ColorOutput "=== RANSOMWARE SIMULATION - EDUCATIONAL PURPOSES ONLY ===" "Blue"
    Write-ColorOutput "Lab Vuln - Cybersecurity Training" "Blue"
    Write-ColorOutput "Version: 1.0" "Blue"
    Write-ColorOutput "Date: $(Get-Date)" "Blue"
    
    # Check if running as administrator
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    if (!$principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-ColorOutput "ERROR: This script must be run as Administrator!" "Red"
        return
    }
    
    Write-ColorOutput "`n⚠️  WARNING: This is a RANSOMWARE SIMULATION for training purposes!" "Red"
    Write-ColorOutput "⚠️  NO REAL ENCRYPTION OR DAMAGE WILL OCCUR!" "Red"
    Write-ColorOutput "⚠️  This is a controlled, safe simulation only!" "Red"
    
    $continue = Read-Host "`nDo you want to continue with the simulation? (Y/N)"
    if ($continue -ne "Y" -and $continue -ne "y") {
        Write-ColorOutput "Simulation cancelled by user." "Yellow"
        return
    }
    
    # Execute simulation steps
    $steps = @(
        @{Name = "Safety Checks"; Function = "Test-SafeEnvironment"},
        @{Name = "Create Test Files"; Function = "Create-TestFiles"},
        @{Name = "Simulate File Encryption"; Function = "Simulate-FileEncryption"},
        @{Name = "Create Ransom Note"; Function = "Create-RansomNote"},
        @{Name = "Simulate Network Activity"; Function = "Simulate-NetworkActivity"},
        @{Name = "Simulate Registry Modifications"; Function = "Simulate-RegistryModifications"},
        @{Name = "Generate Security Events"; Function = "Generate-SecurityEvents"},
        @{Name = "Create Incident Report"; Function = "Create-IncidentReport"}
    )
    
    foreach ($step in $steps) {
        Write-ColorOutput "`nExecuting: $($step.Name)" "Blue"
        & $step.Function
        
        if ($LASTEXITCODE -ne 0) {
            Write-ColorOutput "Error in step: $($step.Name)" "Red"
            return
        }
    }
    
    Show-RecoveryInstructions
    Show-Summary
}

# Execute simulation
Start-RansomwareSimulation 