# Reset Windows Machine - MAQ-1
# Author: Lab Vuln
# Version: 1.0

# Configuration
$MachineName = "MAQ-1"
$ResetLogFile = "windows-reset-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"

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
}

function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

Write-ColorOutput "=== RESET WINDOWS MACHINE - $MachineName ===" "Blue"
Write-ColorOutput "This script will reset the Windows machine to initial state" "Blue"
Write-ColorOutput ""

Write-ColorOutput "⚠️  WARNING: This will reset Windows machine to initial state!" "Red"
Write-ColorOutput "⚠️  All data, logs, and configurations will be reset!" "Red"
Write-ColorOutput "⚠️  This action cannot be undone!" "Red"
Write-ColorOutput ""

$continue = Read-Host "Do you want to continue? (Y/N)"
if ($continue -ne "Y" -and $continue -ne "y") {
    Write-ColorOutput "Reset cancelled by user." "Yellow"
    exit
}

# Check if running as administrator
if (!(Test-Administrator)) {
    Write-ColorOutput "ERROR: This script must be run as Administrator!" "Red"
    exit
}

# Create log file
"Windows Reset Log" | Out-File -FilePath $ResetLogFile
"Date: $(Get-Date)" | Out-File -FilePath $ResetLogFile -Append
"Machine: $MachineName" | Out-File -FilePath $ResetLogFile -Append
"User: $env:USERNAME" | Out-File -FilePath $ResetLogFile -Append
"" | Out-File -FilePath $ResetLogFile -Append

Write-ColorOutput "=== RESET CONFIGURATION ===" "Blue"
Write-ColorOutput "Target: Windows Active Directory (MAQ-1)" "Yellow"
Write-ColorOutput "Actions: Reset logs, configurations, and data" "Yellow"
Write-ColorOutput ""

# Function to reset Windows Event Logs
function Reset-WindowsEventLogs {
    Write-ColorOutput "=== RESETTING WINDOWS EVENT LOGS ===" "Blue"
    
    try {
        # Clear Security log
        Write-ColorOutput "Clearing Security event log..." "Yellow"
        wevtutil cl Security
        "Cleared Security event log" | Out-File -FilePath $ResetLogFile -Append
        
        # Clear Application log
        Write-ColorOutput "Clearing Application event log..." "Yellow"
        wevtutil cl Application
        "Cleared Application event log" | Out-File -FilePath $ResetLogFile -Append
        
        # Clear System log
        Write-ColorOutput "Clearing System event log..." "Yellow"
        wevtutil cl System
        "Cleared System event log" | Out-File -FilePath $ResetLogFile -Append
        
        # Clear Directory Service log
        Write-ColorOutput "Clearing Directory Service event log..." "Yellow"
        wevtutil cl "Directory Service"
        "Cleared Directory Service event log" | Out-File -FilePath $ResetLogFile -Append
        
        Write-ColorOutput "✅ Windows Event Logs reset" "Green"
    }
    catch {
        Write-ColorOutput "Error resetting Windows Event Logs: $($_.Exception.Message)" "Red"
        "Error resetting Windows Event Logs: $($_.Exception.Message)" | Out-File -FilePath $ResetLogFile -Append
    }
}

# Function to reset Active Directory
function Reset-ActiveDirectory {
    Write-ColorOutput "=== RESETTING ACTIVE DIRECTORY ===" "Blue"
    
    try {
        # Reset AD audit policies
        Write-ColorOutput "Resetting AD audit policies..." "Yellow"
        auditpol /set /category:"Process Creation" /success:enable /failure:enable
        auditpol /set /category:"Logon" /success:enable /failure:enable
        auditpol /set /category:"Object Access" /success:enable /failure:enable
        "Reset AD audit policies" | Out-File -FilePath $ResetLogFile -Append
        
        # Reset Windows Event Forwarding
        Write-ColorOutput "Resetting Windows Event Forwarding..." "Yellow"
        wecutil qc /q
        "Reset Windows Event Forwarding" | Out-File -FilePath $ResetLogFile -Append
        
        Write-ColorOutput "✅ Active Directory reset" "Green"
    }
    catch {
        Write-ColorOutput "Error resetting Active Directory: $($_.Exception.Message)" "Red"
        "Error resetting Active Directory: $($_.Exception.Message)" | Out-File -FilePath $ResetLogFile -Append
    }
}

# Function to reset SIEM configurations
function Reset-SIEMConfigurations {
    Write-ColorOutput "=== RESETTING SIEM CONFIGURATIONS ===" "Blue"
    
    try {
        # Remove syslog configuration
        Write-ColorOutput "Removing syslog configuration..." "Yellow"
        if (Test-Path "C:\Windows\System32\syslog.conf") {
            Remove-Item "C:\Windows\System32\syslog.conf" -Force
            "Removed syslog configuration" | Out-File -FilePath $ResetLogFile -Append
        }
        
        # Remove log forwarding script
        Write-ColorOutput "Removing log forwarding script..." "Yellow"
        if (Test-Path "C:\Windows\Temp\log-forwarding.ps1") {
            Remove-Item "C:\Windows\Temp\log-forwarding.ps1" -Force
            "Removed log forwarding script" | Out-File -FilePath $ResetLogFile -Append
        }
        
        # Remove SIEM event logs
        Write-ColorOutput "Removing SIEM event logs..." "Yellow"
        if (Test-Path "C:\Windows\Temp\siem_events.log") {
            Remove-Item "C:\Windows\Temp\siem_events.log" -Force
            "Removed SIEM event logs" | Out-File -FilePath $ResetLogFile -Append
        }
        
        Write-ColorOutput "✅ SIEM configurations reset" "Green"
    }
    catch {
        Write-ColorOutput "Error resetting SIEM configurations: $($_.Exception.Message)" "Red"
        "Error resetting SIEM configurations: $($_.Exception.Message)" | Out-File -FilePath $ResetLogFile -Append
    }
}

# Function to reset ransomware simulation data
function Reset-RansomwareData {
    Write-ColorOutput "=== RESETTING RANSOMWARE SIMULATION DATA ===" "Blue"
    
    try {
        # Remove encrypted files
        Write-ColorOutput "Removing encrypted files..." "Yellow"
        Get-ChildItem -Path "C:\" -Recurse -Filter "*ENCRYPTED*" -ErrorAction SilentlyContinue | Remove-Item -Force
        "Removed encrypted files" | Out-File -FilePath $ResetLogFile -Append
        
        # Remove ransom notes
        Write-ColorOutput "Removing ransom notes..." "Yellow"
        Get-ChildItem -Path "C:\" -Recurse -Filter "RANSOM_NOTE.txt" -ErrorAction SilentlyContinue | Remove-Item -Force
        "Removed ransom notes" | Out-File -FilePath $ResetLogFile -Append
        
        # Clean registry
        Write-ColorOutput "Cleaning registry..." "Yellow"
        if (Test-Path "HKLM:\SOFTWARE\RansomwareSim") {
            Remove-Item "HKLM:\SOFTWARE\RansomwareSim" -Recurse -Force
            "Cleaned registry" | Out-File -FilePath $ResetLogFile -Append
        }
        
        Write-ColorOutput "✅ Ransomware simulation data reset" "Green"
    }
    catch {
        Write-ColorOutput "Error resetting ransomware data: $($_.Exception.Message)" "Red"
        "Error resetting ransomware data: $($_.Exception.Message)" | Out-File -FilePath $ResetLogFile -Append
    }
}

# Function to reset network configurations
function Reset-NetworkConfigurations {
    Write-ColorOutput "=== RESETTING NETWORK CONFIGURATIONS ===" "Blue"
    
    try {
        # Reset Windows Firewall
        Write-ColorOutput "Resetting Windows Firewall..." "Yellow"
        netsh advfirewall reset
        "Reset Windows Firewall" | Out-File -FilePath $ResetLogFile -Append
        
        # Reset network adapters
        Write-ColorOutput "Resetting network adapters..." "Yellow"
        netsh winsock reset
        netsh int ip reset
        "Reset network adapters" | Out-File -FilePath $ResetLogFile -Append
        
        Write-ColorOutput "✅ Network configurations reset" "Green"
    }
    catch {
        Write-ColorOutput "Error resetting network configurations: $($_.Exception.Message)" "Red"
        "Error resetting network configurations: $($_.Exception.Message)" | Out-File -FilePath $ResetLogFile -Append
    }
}

# Function to reset services
function Reset-Services {
    Write-ColorOutput "=== RESETTING SERVICES ===" "Blue"
    
    try {
        # Reset Windows Event Collector
        Write-ColorOutput "Resetting Windows Event Collector..." "Yellow"
        Stop-Service -Name "wecsvc" -Force -ErrorAction SilentlyContinue
        Set-Service -Name "wecsvc" -StartupType Manual
        "Reset Windows Event Collector" | Out-File -FilePath $ResetLogFile -Append
        
        # Reset WinRM
        Write-ColorOutput "Resetting WinRM..." "Yellow"
        Stop-Service -Name "WinRM" -Force -ErrorAction SilentlyContinue
        Set-Service -Name "WinRM" -StartupType Manual
        "Reset WinRM" | Out-File -FilePath $ResetLogFile -Append
        
        Write-ColorOutput "✅ Services reset" "Green"
    }
    catch {
        Write-ColorOutput "Error resetting services: $($_.Exception.Message)" "Red"
        "Error resetting services: $($_.Exception.Message)" | Out-File -FilePath $ResetLogFile -Append
    }
}

# Function to clean temporary files
function Clean-TemporaryFiles {
    Write-ColorOutput "=== CLEANING TEMPORARY FILES ===" "Blue"
    
    try {
        # Clean Windows temp
        Write-ColorOutput "Cleaning Windows temp directory..." "Yellow"
        Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
        "Cleaned Windows temp directory" | Out-File -FilePath $ResetLogFile -Append
        
        # Clean user temp
        Write-ColorOutput "Cleaning user temp directory..." "Yellow"
        Remove-Item -Path "$env:USERPROFILE\AppData\Local\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
        "Cleaned user temp directory" | Out-File -FilePath $ResetLogFile -Append
        
        # Clean PowerShell logs
        Write-ColorOutput "Cleaning PowerShell logs..." "Yellow"
        Remove-Item -Path "$env:USERPROFILE\Documents\WindowsPowerShell\Logs\*" -Recurse -Force -ErrorAction SilentlyContinue
        "Cleaned PowerShell logs" | Out-File -FilePath $ResetLogFile -Append
        
        Write-ColorOutput "✅ Temporary files cleaned" "Green"
    }
    catch {
        Write-ColorOutput "Error cleaning temporary files: $($_.Exception.Message)" "Red"
        "Error cleaning temporary files: $($_.Exception.Message)" | Out-File -FilePath $ResetLogFile -Append
    }
}

# Main reset process
Write-ColorOutput "=== STARTING WINDOWS RESET ===" "Blue"

# 1. Reset Windows Event Logs
Reset-WindowsEventLogs

# 2. Reset Active Directory
Reset-ActiveDirectory

# 3. Reset SIEM configurations
Reset-SIEMConfigurations

# 4. Reset ransomware simulation data
Reset-RansomwareData

# 5. Reset network configurations
Reset-NetworkConfigurations

# 6. Reset services
Reset-Services

# 7. Clean temporary files
Clean-TemporaryFiles

# Create reset verification
Write-ColorOutput "=== CREATING RESET VERIFICATION ===" "Blue"

$verificationContent = @"
# Windows Reset Verification - $MachineName

## Reset Details
- **Date**: $(Get-Date)
- **Machine**: $MachineName
- **User**: $env:USERNAME
- **Log File**: $ResetLogFile

## Reset Actions Performed
- [x] Windows Event Logs cleared
- [x] Active Directory reset
- [x] SIEM configurations removed
- [x] Ransomware simulation data cleaned
- [x] Network configurations reset
- [x] Services reset
- [x] Temporary files cleaned

## Verification Steps
1. **Check Event Logs**: Event Viewer
2. **Check AD Status**: dcdiag
3. **Check Services**: services.msc
4. **Check Network**: ipconfig /all
5. **Check Temp Files**: dir %TEMP%

## Next Steps
1. Restart machine if needed
2. Reconfigure SIEM forwarding
3. Run vulnerability setup scripts
4. Begin new training session

## Notes
- Windows machine reset to initial state
- Ready for new training session
- Backup any important data before reset
"@

$verificationContent | Out-File -FilePath "windows-reset-verification-$(Get-Date -Format 'yyyyMMdd-HHmmss').md"

Write-ColorOutput "✅ Reset verification file created" "Green"

# Summary
Write-ColorOutput "=== RESET SUMMARY ===" "Blue"
Write-ColorOutput "✅ Windows Event Logs reset" "Green"
Write-ColorOutput "✅ Active Directory reset" "Green"
Write-ColorOutput "✅ SIEM configurations reset" "Green"
Write-ColorOutput "✅ Ransomware simulation data cleaned" "Green"
Write-ColorOutput "✅ Network configurations reset" "Green"
Write-ColorOutput "✅ Services reset" "Green"
Write-ColorOutput "✅ Temporary files cleaned" "Green"
Write-ColorOutput "✅ Reset verification created" "Green"

Write-ColorOutput "=== NEXT STEPS ===" "Blue"
Write-ColorOutput "1. Restart machine if needed" "Yellow"
Write-ColorOutput "2. Reconfigure SIEM forwarding" "Yellow"
Write-ColorOutput "3. Run vulnerability setup scripts" "Yellow"
Write-ColorOutput "4. Begin new training session" "Yellow"

Write-ColorOutput "=== VERIFICATION COMMANDS ===" "Blue"
Write-ColorOutput "Check Event Logs: eventvwr.msc" "White"
Write-ColorOutput "Check AD Status: dcdiag" "White"
Write-ColorOutput "Check Services: services.msc" "White"
Write-ColorOutput "Check Network: ipconfig /all" "White"

Write-ColorOutput "Log file: $ResetLogFile" "Yellow"

Write-ColorOutput "🎯 WINDOWS MACHINE RESET COMPLETED SUCCESSFULLY!" "Green"
Write-ColorOutput "Ready for new training session!" "Green" 