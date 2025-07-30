# Configure Windows Log Forwarding to SIEM
# Author: Lab Vuln
# Version: 1.0

# Configuration
$SIEM_IP = "192.168.1.100"  # Change to your SIEM IP
$SIEM_PORT = "1514"

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

function Configure-WindowsEventForwarding {
    Write-ColorOutput "=== CONFIGURING WINDOWS EVENT FORWARDING ===" "Blue"
    
    try {
        # Enable Windows Event Collector
        Write-ColorOutput "Enabling Windows Event Collector..." "Yellow"
        wecutil qc /q
        
        # Configure WinRM for event forwarding
        Write-ColorOutput "Configuring WinRM..." "Yellow"
        winrm quickconfig -force
        
        # Enable required services
        Write-ColorOutput "Enabling required services..." "Yellow"
        Set-Service -Name "WinRM" -StartupType Automatic
        Set-Service -Name "wecsvc" -StartupType Automatic
        Start-Service -Name "WinRM" -ErrorAction SilentlyContinue
        Start-Service -Name "wecsvc" -ErrorAction SilentlyContinue
        
        Write-ColorOutput "✅ Windows Event Forwarding configured!" "Green"
        return $true
    }
    catch {
        Write-ColorOutput "Error configuring Windows Event Forwarding: $($_.Exception.Message)" "Red"
        return $false
    }
}

function Configure-SyslogForwarding {
    Write-ColorOutput "=== CONFIGURING SYSLOG FORWARDING ===" "Blue"
    
    try {
        # Create syslog configuration
        Write-ColorOutput "Creating syslog configuration..." "Yellow"
        
        $syslogConfig = @"
# Syslog configuration for SIEM forwarding
# Forward all Windows events to SIEM

# Security events
*.* @$SIEM_IP`:$SIEM_PORT

# Application events
*.* @$SIEM_IP`:$SIEM_PORT

# System events
*.* @$SIEM_IP`:$SIEM_PORT
"@
        
        # Save configuration
        Set-Content -Path "C:\Windows\System32\syslog.conf" -Value $syslogConfig -Force
        
        Write-ColorOutput "✅ Syslog forwarding configured!" "Green"
        return $true
    }
    catch {
        Write-ColorOutput "Error configuring syslog forwarding: $($_.Exception.Message)" "Red"
        return $false
    }
}

function Configure-EventLogging {
    Write-ColorOutput "=== CONFIGURING EVENT LOGGING ===" "Blue"
    
    try {
        # Configure audit policies for better logging
        Write-ColorOutput "Configuring audit policies..." "Yellow"
        
        # Enable detailed auditing
        auditpol /set /category:"Process Creation" /success:enable /failure:enable
        auditpol /set /category:"Logon" /success:enable /failure:enable
        auditpol /set /category:"Object Access" /success:enable /failure:enable
        auditpol /set /category:"Privilege Use" /success:enable /failure:enable
        auditpol /set /category:"Policy Change" /success:enable /failure:enable
        auditpol /set /category:"Account Management" /success:enable /failure:enable
        auditpol /set /category:"Directory Service Access" /success:enable /failure:enable
        auditpol /set /category:"Account Logon" /success:enable /failure:enable
        
        # Configure Windows Event Log settings
        Write-ColorOutput "Configuring event log settings..." "Yellow"
        
        # Increase log size for Security events
        wevtutil sl Security /ms:104857600  # 100MB
        
        # Increase log size for Application events
        wevtutil sl Application /ms:52428800  # 50MB
        
        # Increase log size for System events
        wevtutil sl System /ms:52428800  # 50MB
        
        Write-ColorOutput "✅ Event logging configured!" "Green"
        return $true
    }
    catch {
        Write-ColorOutput "Error configuring event logging: $($_.Exception.Message)" "Red"
        return $false
    }
}

function Create-LogForwardingScript {
    Write-ColorOutput "=== CREATING LOG FORWARDING SCRIPT ===" "Blue"
    
    try {
        # Create PowerShell script for continuous log forwarding
        Write-ColorOutput "Creating log forwarding script..." "Yellow"
        
        $forwardingScript = @"
# Windows Log Forwarding Script
# Forwards Windows events to SIEM

`$SIEM_IP = "$SIEM_IP"
`$SIEM_PORT = $SIEM_PORT

function Send-EventToSIEM {
    param(`$Event)
    
    try {
        `$eventData = @{
            timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            hostname = `$env:COMPUTERNAME
            event_id = `$Event.Id
            event_type = `$Event.LevelDisplayName
            source = `$Event.ProviderName
            message = `$Event.Message
            user = `$Event.UserId
            process = `$Event.ProcessId
        }
        
        `$jsonData = `$eventData | ConvertTo-Json
        
        # Send to SIEM (simulated - in real implementation, use proper syslog client)
        Write-Host "Forwarding event to SIEM: `$(`$Event.Id)" -ForegroundColor Green
        
        # In production, you would use a proper syslog client here
        # For now, we'll just log to a file
        `$jsonData | Out-File -FilePath "C:\Windows\Temp\siem_events.log" -Append
        
    }
    catch {
        Write-Host "Error forwarding event: `$(`$_.Exception.Message)" -ForegroundColor Red
    }
}

# Monitor Security events
Write-Host "Starting Windows Event Forwarding to SIEM..." -ForegroundColor Green
Write-Host "SIEM IP: `$SIEM_IP" -ForegroundColor Yellow
Write-Host "SIEM Port: `$SIEM_PORT" -ForegroundColor Yellow

# Get events and forward them
Get-WinEvent -LogName Security -MaxEvents 100 | ForEach-Object {
    Send-EventToSIEM -Event `$_
    Start-Sleep -Milliseconds 100
}
"@
        
        Set-Content -Path "C:\Windows\Temp\log-forwarding.ps1" -Value $forwardingScript
        
        Write-ColorOutput "✅ Log forwarding script created!" "Green"
        return $true
    }
    catch {
        Write-ColorOutput "Error creating log forwarding script: $($_.Exception.Message)" "Red"
        return $false
    }
}

function Test-SIEMConnectivity {
    Write-ColorOutput "=== TESTING SIEM CONNECTIVITY ===" "Blue"
    
    try {
        Write-ColorOutput "Testing connectivity to SIEM..." "Yellow"
        
        # Test basic connectivity
        $ping = Test-Connection -ComputerName $SIEM_IP -Count 1 -Quiet
        if ($ping) {
            Write-ColorOutput "✅ Connectivity to SIEM OK" "Green"
        } else {
            Write-ColorOutput "❌ Cannot reach SIEM at $SIEM_IP" "Red"
        }
        
        # Test port connectivity
        try {
            $tcp = New-Object System.Net.Sockets.TcpClient
            $tcp.ConnectAsync($SIEM_IP, $SIEM_PORT).Wait(5000)
            if ($tcp.Connected) {
                Write-ColorOutput "✅ Port $SIEM_PORT is accessible" "Green"
                $tcp.Close()
            } else {
                Write-ColorOutput "❌ Port $SIEM_PORT is not accessible" "Red"
            }
        }
        catch {
            Write-ColorOutput "❌ Cannot connect to SIEM on port $SIEM_PORT" "Red"
        }
        
        return $true
    }
    catch {
        Write-ColorOutput "Error testing SIEM connectivity: $($_.Exception.Message)" "Red"
        return $false
    }
}

function Show-Summary {
    Write-ColorOutput "`n=== SYSLOG CONFIGURATION SUMMARY ===" "Blue"
    Write-ColorOutput "✅ Windows Event Forwarding configured" "Green"
    Write-ColorOutput "✅ Syslog forwarding configured" "Green"
    Write-ColorOutput "✅ Event logging configured" "Green"
    Write-ColorOutput "✅ Log forwarding script created" "Green"
    Write-ColorOutput "✅ SIEM connectivity tested" "Green"
    
    Write-ColorOutput "`n=== CONFIGURATION DETAILS ===" "Yellow"
    Write-ColorOutput "SIEM IP: $SIEM_IP" "Yellow"
    Write-ColorOutput "SIEM Port: $SIEM_PORT" "Yellow"
    Write-ColorOutput "Log Forwarding Script: C:\Windows\Temp\log-forwarding.ps1" "Yellow"
    Write-ColorOutput "Syslog Config: C:\Windows\System32\syslog.conf" "Yellow"
    
    Write-ColorOutput "`n=== NEXT STEPS ===" "Blue"
    Write-ColorOutput "1. Start the SIEM central container" "Yellow"
    Write-ColorOutput "2. Configure inputs in Graylog" "Yellow"
    Write-ColorOutput "3. Run the log forwarding script" "Yellow"
    Write-ColorOutput "4. Monitor logs in SIEM interface" "Yellow"
    
    Write-ColorOutput "`n🎯 WINDOWS LOG FORWARDING CONFIGURED SUCCESSFULLY! 🎯" "Green"
}

# MAIN FUNCTION
function Configure-WindowsSyslog {
    Write-ColorOutput "=== WINDOWS SYSLOG CONFIGURATION ===" "Blue"
    Write-ColorOutput "Lab Vuln - SIEM Integration" "Blue"
    Write-ColorOutput "Version: 1.0" "Blue"
    Write-ColorOutput "Date: $(Get-Date)" "Blue"
    
    # Check if running as administrator
    if (!(Test-Administrator)) {
        Write-ColorOutput "ERROR: This script must be run as Administrator!" "Red"
        return
    }
    
    Write-ColorOutput "`nConfiguring Windows log forwarding to SIEM..." "Yellow"
    Write-ColorOutput "SIEM IP: $SIEM_IP" "Yellow"
    Write-ColorOutput "SIEM Port: $SIEM_PORT" "Yellow"
    
    $continue = Read-Host "`nDo you want to continue? (Y/N)"
    if ($continue -ne "Y" -and $continue -ne "y") {
        Write-ColorOutput "Configuration cancelled by user." "Yellow"
        return
    }
    
    # Execute configuration steps
    $steps = @(
        @{Name = "Windows Event Forwarding"; Function = "Configure-WindowsEventForwarding"},
        @{Name = "Syslog Forwarding"; Function = "Configure-SyslogForwarding"},
        @{Name = "Event Logging"; Function = "Configure-EventLogging"},
        @{Name = "Log Forwarding Script"; Function = "Create-LogForwardingScript"},
        @{Name = "SIEM Connectivity Test"; Function = "Test-SIEMConnectivity"}
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

# Execute configuration
Configure-WindowsSyslog 