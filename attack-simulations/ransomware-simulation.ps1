# Ransomware Attack Simulation
# Author: Lab Vuln
# Version: 1.0

# Configuration
$SimulationDuration = 300  # 5 minutes
$TargetDirectories = @("C:\Users\Public\Documents", "C:\Temp", "C:\Windows\Temp")
$RansomNoteContent = @"
=== RANSOMWARE ATTACK ===

Your files have been encrypted!
To recover your files, send 1 Bitcoin to: 1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa

Contact: ransomware@example.com
DO NOT RESTART YOUR COMPUTER!

=== END RANSOM NOTE ===
"@

function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

Write-ColorOutput "=== RANSOMWARE ATTACK SIMULATION ===" "Blue"
Write-ColorOutput "Lab Vuln - Scenario 5" "Blue"
Write-ColorOutput "Target: All Windows Machines" "Blue"
Write-ColorOutput "Duration: 45-90 minutes" "Blue"
Write-ColorOutput ""

Write-ColorOutput "⚠️  WARNING: This script simulates ransomware behavior" "Red"
Write-ColorOutput "⚠️  This is for educational purposes only!" "Red"
Write-ColorOutput "⚠️  Files will be modified but not actually encrypted" "Red"
Write-ColorOutput ""

$continue = Read-Host "Do you want to continue? (Y/N)"
if ($continue -ne "Y" -and $continue -ne "y") {
    Write-ColorOutput "Simulation cancelled by user." "Yellow"
    exit
}

# Check if running as administrator
if (!(Test-Administrator)) {
    Write-ColorOutput "ERROR: This script must be run as Administrator!" "Red"
    exit
}

Write-ColorOutput "=== SIMULATION CONFIGURATION ===" "Blue"
Write-ColorOutput "Simulation Duration: $SimulationDuration seconds" "Yellow"
Write-ColorOutput "Target Directories: $($TargetDirectories -join ', ')" "Yellow"
Write-ColorOutput ""

# Create log file
$LogFile = "ransomware-simulation-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"
"Ransomware Simulation Log" | Out-File -FilePath $LogFile
"Date: $(Get-Date)" | Out-File -FilePath $LogFile -Append
"Duration: $SimulationDuration seconds" | Out-File -FilePath $LogFile -Append
"" | Out-File -FilePath $LogFile -Append

Write-ColorOutput "=== STARTING RANSOMWARE SIMULATION ===" "Blue"
Write-ColorOutput "This will simulate ransomware behavior including:" "Yellow"
Write-ColorOutput "- File modification (not real encryption)" "Yellow"
Write-ColorOutput "- Ransom note creation" "Yellow"
Write-ColorOutput "- Registry modifications" "Yellow"
Write-ColorOutput "- Process creation" "Yellow"
Write-ColorOutput "- Network communication simulation" "Yellow"
Write-ColorOutput ""

# Start simulation
$startTime = Get-Date
$attemptCount = 0
$filesModified = 0

Write-ColorOutput "=== EXECUTING ATTACK ===" "Blue"

while ((Get-Date) -lt $startTime.AddSeconds($SimulationDuration)) {
    $attemptCount++
    
    # Select random target directory
    $targetDir = $TargetDirectories | Get-Random
    
    # Create or modify files to simulate encryption
    $files = Get-ChildItem -Path $targetDir -File -ErrorAction SilentlyContinue | Select-Object -First 5
    
    foreach ($file in $files) {
        try {
            # Simulate file encryption by appending text
            $encryptedContent = "ENCRYPTED_$(Get-Date -Format 'yyyyMMddHHmmss')_$($file.Name)"
            $encryptedContent | Out-File -FilePath $file.FullName -Append -ErrorAction SilentlyContinue
            
            $filesModified++
            Write-ColorOutput "Modified: $($file.FullName)" "Green"
            "Modified: $($file.FullName)" | Out-File -FilePath $LogFile -Append
        }
        catch {
            Write-ColorOutput "Failed to modify: $($file.FullName)" "Red"
            "Failed to modify: $($file.FullName)" | Out-File -FilePath $LogFile -Append
        }
    }
    
    # Create ransom notes
    $ransomNotePath = "$targetDir\RANSOM_NOTE.txt"
    $RansomNoteContent | Out-File -FilePath $ransomNotePath -ErrorAction SilentlyContinue
    Write-ColorOutput "Created ransom note: $ransomNotePath" "Yellow"
    "Created ransom note: $ransomNotePath" | Out-File -FilePath $LogFile -Append
    
    # Simulate registry modifications
    try {
        $regPath = "HKLM:\SOFTWARE\RansomwareSim"
        New-Item -Path $regPath -Force -ErrorAction SilentlyContinue | Out-Null
        Set-ItemProperty -Path $regPath -Name "Encrypted" -Value "1" -ErrorAction SilentlyContinue
        Set-ItemProperty -Path $regPath -Name "Timestamp" -Value (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') -ErrorAction SilentlyContinue
        Write-ColorOutput "Modified registry: $regPath" "Yellow"
        "Modified registry: $regPath" | Out-File -FilePath $LogFile -Append
    }
    catch {
        Write-ColorOutput "Failed to modify registry" "Red"
    }
    
    # Simulate process creation
    try {
        $processName = "ransomware_sim_$attemptCount"
        Start-Process -FilePath "cmd.exe" -ArgumentList "/c echo $processName" -WindowStyle Hidden -ErrorAction SilentlyContinue
        Write-ColorOutput "Created process: $processName" "Yellow"
        "Created process: $processName" | Out-File -FilePath $LogFile -Append
    }
    catch {
        Write-ColorOutput "Failed to create process" "Red"
    }
    
    # Simulate network communication
    try {
        $c2Server = "192.168.1.100"
        $port = 4444
        $tcpClient = New-Object System.Net.Sockets.TcpClient
        $tcpClient.ConnectAsync($c2Server, $port).Wait(1000) | Out-Null
        if ($tcpClient.Connected) {
            Write-ColorOutput "C2 Communication: $c2Server`:$port" "Yellow"
            "C2 Communication: $c2Server`:$port" | Out-File -FilePath $LogFile -Append
        }
        $tcpClient.Close()
    }
    catch {
        Write-ColorOutput "C2 Communication failed" "Red"
    }
    
    # Show progress
    $elapsed = ((Get-Date) - $startTime).TotalSeconds
    $remaining = $SimulationDuration - $elapsed
    Write-Host "Progress: $([math]::Round($elapsed, 0))/$SimulationDuration seconds - Files Modified: $filesModified" -NoNewline
    
    Start-Sleep -Seconds 2
}

Write-Host ""
Write-Host ""
Write-ColorOutput "=== SIMULATION COMPLETE ===" "Blue"

# Summary
Write-ColorOutput "=== ATTACK SUMMARY ===" "Blue"
Write-ColorOutput "Total attempts: $attemptCount" "Yellow"
Write-ColorOutput "Files modified: $filesModified" "Yellow"
Write-ColorOutput "Simulation duration: $SimulationDuration seconds" "Yellow"
Write-ColorOutput "Log file: $LogFile" "Yellow"

# Log summary
"" | Out-File -FilePath $LogFile -Append
"=== ATTACK SUMMARY ===" | Out-File -FilePath $LogFile -Append
"Total attempts: $attemptCount" | Out-File -FilePath $LogFile -Append
"Files modified: $filesModified" | Out-File -FilePath $LogFile -Append
"Simulation duration: $SimulationDuration seconds" | Out-File -FilePath $LogFile -Append

Write-ColorOutput "=== SIEM DETECTION INSTRUCTIONS ===" "Blue"
Write-ColorOutput ""
Write-ColorOutput "To detect this attack in SIEM (Graylog), search for:" "Yellow"
Write-ColorOutput ""
Write-ColorOutput "1. File modification events:" "White"
Write-ColorOutput "   source:Windows AND message:`"encrypted`" OR message:`"ransom`"" "White"
Write-ColorOutput ""
Write-ColorOutput "2. Process creation events:" "White"
Write-ColorOutput "   source:Windows AND event_id:4688 AND message:`"ransomware`"" "White"
Write-ColorOutput ""
Write-ColorOutput "3. Registry modifications:" "White"
Write-ColorOutput "   source:Windows AND event_id:4657 AND message:`"RansomwareSim`"" "White"
Write-ColorOutput ""
Write-ColorOutput "4. Network connections:" "White"
Write-ColorOutput "   source:Windows AND message:`"192.168.1.100:4444`"" "White"
Write-ColorOutput ""

Write-ColorOutput "=== RESPONSE PROCEDURES ===" "Blue"
Write-ColorOutput ""
Write-ColorOutput "1. Isolate affected systems" "White"
Write-ColorOutput "2. Disconnect from network" "White"
Write-ColorOutput "3. Alert incident response team" "White"
Write-ColorOutput "4. Document ransom demands" "White"
Write-ColorOutput "5. Determine attack scope" "White"
Write-ColorOutput "6. Identify initial access vector" "White"
Write-ColorOutput "7. Check for data exfiltration" "White"
Write-ColorOutput "8. Implement network segmentation" "White"
Write-ColorOutput "9. Restore from backups" "White"
Write-ColorOutput "10. Patch vulnerabilities" "White"
Write-ColorOutput ""

Write-ColorOutput "=== RECOVERY PROCEDURES ===" "Blue"
Write-ColorOutput ""
Write-ColorOutput "1. Remove modified files:" "White"
Write-ColorOutput "   Get-ChildItem -Path C:\ -Recurse -Filter '*ENCRYPTED*' | Remove-Item" "White"
Write-ColorOutput ""
Write-ColorOutput "2. Remove ransom notes:" "White"
Write-ColorOutput "   Get-ChildItem -Path C:\ -Recurse -Filter 'RANSOM_NOTE.txt' | Remove-Item" "White"
Write-ColorOutput ""
Write-ColorOutput "3. Clean registry:" "White"
Write-ColorOutput "   Remove-Item -Path 'HKLM:\SOFTWARE\RansomwareSim' -Recurse" "White"
Write-ColorOutput ""

Write-ColorOutput "✅ Ransomware simulation completed!" "Green"
Write-ColorOutput "⚠️  Check SIEM for attack detection and response" "Yellow" 