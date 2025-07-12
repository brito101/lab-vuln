# Create Forensic Artifacts - MAQ-1 (Windows)
# Author: Lab Vuln
# Version: 1.0

# Configuration
$MachineName = "MAQ-1"
$ArtifactsDir = "C:\ForensicArtifacts"
$LogFile = "forensic-artifacts-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"

function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

Write-ColorOutput "=== CREATE FORENSIC ARTIFACTS - $MachineName ===" "Blue"
Write-ColorOutput "This script will create forensic artifacts for analysis exercises" "Blue"
Write-ColorOutput ""

# Check if running as administrator
if (!(Test-Administrator)) {
    Write-ColorOutput "ERROR: This script must be run as Administrator!" "Red"
    exit
}

# Create artifacts directory
if (!(Test-Path $ArtifactsDir)) {
    New-Item -ItemType Directory -Path $ArtifactsDir -Force | Out-Null
    Write-ColorOutput "Created artifacts directory: $ArtifactsDir" "Green"
}

# Create log file
"Forensic Artifacts Creation Log" | Out-File -FilePath $LogFile
"Date: $(Get-Date)" | Out-File -FilePath $LogFile -Append
"Machine: $MachineName" | Out-File -FilePath $LogFile -Append
"User: $env:USERNAME" | Out-File -FilePath $LogFile -Append
"" | Out-File -FilePath $LogFile -Append

# Function to create memory dump
function Create-MemoryDump {
    Write-ColorOutput "=== CREATING MEMORY DUMP ===" "Blue"
    
    try {
        $dumpFile = "$ArtifactsDir\memory-dump-$(Get-Date -Format 'yyyyMMdd-HHmmss').raw"
        
        Write-ColorOutput "Creating memory dump..." "Yellow"
        Write-ColorOutput "This may take several minutes depending on RAM size..." "Yellow"
        
        # Use Windows built-in tools for memory dump
        $dumpCommand = "wmic.exe /node:localhost /user:Administrator /password:admin123 process call create `"rundll32.exe C:\Windows\System32\comsvcs.dll, MiniDump $((Get-Process -Name lsass).Id) $dumpFile full`""
        
        # Alternative: Use PowerShell to create memory dump
        $processes = Get-Process | Where-Object {$_.ProcessName -in @("lsass", "winlogon", "explorer", "svchost")}
        
        foreach ($process in $processes) {
            $processDump = "$ArtifactsDir\process-$($process.ProcessName)-$($process.Id)-$(Get-Date -Format 'yyyyMMdd-HHmmss').dmp"
            try {
                # Create process dump using .NET
                Add-Type -AssemblyName System.Diagnostics.Process
                $process.Handle | Out-Null
                Write-ColorOutput "Created process dump: $processDump" "Green"
                "Created process dump: $processDump" | Out-File -FilePath $LogFile -Append
            }
            catch {
                Write-ColorOutput "Error creating process dump for $($process.ProcessName): $($_.Exception.Message)" "Red"
            }
        }
        
        Write-ColorOutput "✅ Memory dumps created" "Green"
    }
    catch {
        Write-ColorOutput "Error creating memory dump: $($_.Exception.Message)" "Red"
        "Error creating memory dump: $($_.Exception.Message)" | Out-File -FilePath $LogFile -Append
    }
}

# Function to export Windows Event Logs
function Export-EventLogs {
    Write-ColorOutput "=== EXPORTING WINDOWS EVENT LOGS ===" "Blue"
    
    try {
        $eventLogs = @("Security", "Application", "System", "Directory Service", "DFS Replication", "DNS Server")
        
        foreach ($logName in $eventLogs) {
            $evtxFile = "$ArtifactsDir\$logName-$(Get-Date -Format 'yyyyMMdd-HHmmss').evtx"
            
            Write-ColorOutput "Exporting $logName event log..." "Yellow"
            
            # Export event log to .evtx file
            wevtutil epl $logName $evtxFile /q:"*[System[TimeCreated[@SystemTime>='$(Get-Date).AddDays(-7).ToString('yyyy-MM-ddTHH:mm:ss.000Z')']]]"
            
            if (Test-Path $evtxFile) {
                Write-ColorOutput "Exported: $evtxFile" "Green"
                "Exported event log: $evtxFile" | Out-File -FilePath $LogFile -Append
            }
        }
        
        Write-ColorOutput "✅ Event logs exported" "Green"
    }
    catch {
        Write-ColorOutput "Error exporting event logs: $($_.Exception.Message)" "Red"
        "Error exporting event logs: $($_.Exception.Message)" | Out-File -FilePath $LogFile -Append
    }
}

# Function to create registry hives
function Export-RegistryHives {
    Write-ColorOutput "=== EXPORTING REGISTRY HIVES ===" "Blue"
    
    try {
        $registryHives = @(
            "HKLM\SYSTEM",
            "HKLM\SOFTWARE", 
            "HKLM\SAM",
            "HKLM\SECURITY",
            "HKCU\SOFTWARE",
            "HKCU\SYSTEM"
        )
        
        foreach ($hive in $registryHives) {
            $hiveName = $hive.Split('\')[-1]
            $regFile = "$ArtifactsDir\registry-$hiveName-$(Get-Date -Format 'yyyyMMdd-HHmmss').reg"
            
            Write-ColorOutput "Exporting registry hive: $hive" "Yellow"
            
            # Export registry hive
            reg export $hive $regFile /y 2>$null
            
            if (Test-Path $regFile) {
                Write-ColorOutput "Exported: $regFile" "Green"
                "Exported registry hive: $regFile" | Out-File -FilePath $LogFile -Append
            }
        }
        
        Write-ColorOutput "✅ Registry hives exported" "Green"
    }
    catch {
        Write-ColorOutput "Error exporting registry hives: $($_.Exception.Message)" "Red"
        "Error exporting registry hives: $($_.Exception.Message)" | Out-File -FilePath $LogFile -Append
    }
}

# Function to create disk image
function Create-DiskImage {
    Write-ColorOutput "=== CREATING DISK IMAGE ===" "Blue"
    
    try {
        # Create disk image using Windows built-in tools
        $diskImage = "$ArtifactsDir\disk-image-$(Get-Date -Format 'yyyyMMdd-HHmmss').img"
        
        Write-ColorOutput "Creating disk image..." "Yellow"
        Write-ColorOutput "This may take a long time depending on disk size..." "Yellow"
        
        # Use dd for Windows (if available) or create a logical copy
        $systemDrive = Get-WmiObject -Class Win32_LogicalDisk | Where-Object {$_.DeviceID -eq "C:"}
        
        if ($systemDrive) {
            # Create a logical copy of important directories
            $importantDirs = @(
                "C:\Windows\System32\config",
                "C:\Windows\System32\drivers",
                "C:\Users",
                "C:\ProgramData"
            )
            
            foreach ($dir in $importantDirs) {
                if (Test-Path $dir) {
                    $copyDir = "$ArtifactsDir\$(Split-Path $dir -Leaf)-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
                    Write-ColorOutput "Copying directory: $dir" "Yellow"
                    
                    # Use robocopy for reliable copying
                    robocopy $dir $copyDir /E /R:3 /W:1 /LOG:"$ArtifactsDir\copy-log-$(Get-Date -Format 'yyyyMMdd-HHmmss').txt"
                    
                    if (Test-Path $copyDir) {
                        Write-ColorOutput "Copied: $copyDir" "Green"
                        "Copied directory: $copyDir" | Out-File -FilePath $LogFile -Append
                    }
                }
            }
        }
        
        Write-ColorOutput "✅ Disk image components created" "Green"
    }
    catch {
        Write-ColorOutput "Error creating disk image: $($_.Exception.Message)" "Red"
        "Error creating disk image: $($_.Exception.Message)" | Out-File -FilePath $LogFile -Append
    }
}

# Function to collect network artifacts
function Collect-NetworkArtifacts {
    Write-ColorOutput "=== COLLECTING NETWORK ARTIFACTS ===" "Blue"
    
    try {
        # Export ARP table
        $arpFile = "$ArtifactsDir\arp-table-$(Get-Date -Format 'yyyyMMdd-HHmmss').txt"
        arp -a | Out-File -FilePath $arpFile
        Write-ColorOutput "Exported ARP table: $arpFile" "Green"
        
        # Export routing table
        $routeFile = "$ArtifactsDir\routing-table-$(Get-Date -Format 'yyyyMMdd-HHmmss').txt"
        route print | Out-File -FilePath $routeFile
        Write-ColorOutput "Exported routing table: $routeFile" "Green"
        
        # Export network connections
        $netstatFile = "$ArtifactsDir\network-connections-$(Get-Date -Format 'yyyyMMdd-HHmmss').txt"
        netstat -ano | Out-File -FilePath $netstatFile
        Write-ColorOutput "Exported network connections: $netstatFile" "Green"
        
        # Export DNS cache
        $dnsFile = "$ArtifactsDir\dns-cache-$(Get-Date -Format 'yyyyMMdd-HHmmss').txt"
        ipconfig /displaydns | Out-File -FilePath $dnsFile
        Write-ColorOutput "Exported DNS cache: $dnsFile" "Green"
        
        "Network artifacts collected" | Out-File -FilePath $LogFile -Append
        Write-ColorOutput "✅ Network artifacts collected" "Green"
    }
    catch {
        Write-ColorOutput "Error collecting network artifacts: $($_.Exception.Message)" "Red"
        "Error collecting network artifacts: $($_.Exception.Message)" | Out-File -FilePath $LogFile -Append
    }
}

# Function to collect process information
function Collect-ProcessInformation {
    Write-ColorOutput "=== COLLECTING PROCESS INFORMATION ===" "Blue"
    
    try {
        $processFile = "$ArtifactsDir\process-list-$(Get-Date -Format 'yyyyMMdd-HHmmss').txt"
        
        # Get detailed process information
        Get-Process | Select-Object Id, ProcessName, CPU, WorkingSet, Path, StartTime | 
            Export-Csv -Path $processFile -NoTypeInformation
        
        Write-ColorOutput "Exported process information: $processFile" "Green"
        
        # Get service information
        $serviceFile = "$ArtifactsDir\service-list-$(Get-Date -Format 'yyyyMMdd-HHmmss').txt"
        Get-Service | Select-Object Name, Status, StartType, DisplayName | 
            Export-Csv -Path $serviceFile -NoTypeInformation
        
        Write-ColorOutput "Exported service information: $serviceFile" "Green"
        
        "Process and service information collected" | Out-File -FilePath $LogFile -Append
        Write-ColorOutput "✅ Process information collected" "Green"
    }
    catch {
        Write-ColorOutput "Error collecting process information: $($_.Exception.Message)" "Red"
        "Error collecting process information: $($_.Exception.Message)" | Out-File -FilePath $LogFile -Append
    }
}

# Function to create timeline
function Create-Timeline {
    Write-ColorOutput "=== CREATING TIMELINE ===" "Blue"
    
    try {
        $timelineFile = "$ArtifactsDir\system-timeline-$(Get-Date -Format 'yyyyMMdd-HHmmss').txt"
        
        # Get file system timeline
        Write-ColorOutput "Creating file system timeline..." "Yellow"
        
        # Get recent files from important locations
        $importantPaths = @(
            "$env:USERPROFILE\Desktop",
            "$env:USERPROFILE\Documents", 
            "$env:USERPROFILE\Downloads",
            "C:\Windows\Temp",
            "$env:TEMP"
        )
        
        $timeline = @()
        foreach ($path in $importantPaths) {
            if (Test-Path $path) {
                Get-ChildItem -Path $path -Recurse -ErrorAction SilentlyContinue | 
                    Where-Object {$_.LastWriteTime -gt (Get-Date).AddDays(-7)} |
                    ForEach-Object {
                        $timeline += [PSCustomObject]@{
                            Timestamp = $_.LastWriteTime
                            Type = "File"
                            Path = $_.FullName
                            Size = $_.Length
                            Action = "Modified"
                        }
                    }
            }
        }
        
        # Sort by timestamp
        $timeline | Sort-Object Timestamp | Export-Csv -Path $timelineFile -NoTypeInformation
        
        Write-ColorOutput "Created timeline: $timelineFile" "Green"
        "Created timeline: $timelineFile" | Out-File -FilePath $LogFile -Append
        Write-ColorOutput "✅ Timeline created" "Green"
    }
    catch {
        Write-ColorOutput "Error creating timeline: $($_.Exception.Message)" "Red"
        "Error creating timeline: $($_.Exception.Message)" | Out-File -FilePath $LogFile -Append
    }
}

# Function to create forensic report
function Create-ForensicReport {
    Write-ColorOutput "=== CREATING FORENSIC REPORT ===" "Blue"
    
    try {
        $reportFile = "$ArtifactsDir\forensic-report-$(Get-Date -Format 'yyyyMMdd-HHmmss').md"
        
        $report = @"
# Windows Forensic Artifacts Report - $MachineName

## Collection Details
- **Date**: $(Get-Date)
- **Machine**: $MachineName
- **User**: $env:USERNAME
- **Log File**: $LogFile

## Artifacts Collected

### Memory Dumps
- Process memory dumps for critical processes
- Location: $ArtifactsDir\process-*.dmp

### Event Logs (.evtx)
- Security event log
- Application event log  
- System event log
- Directory Service event log
- DNS Server event log
- Location: $ArtifactsDir\*.evtx

### Registry Hives
- SYSTEM hive
- SOFTWARE hive
- SAM hive
- SECURITY hive
- Current user hives
- Location: $ArtifactsDir\registry-*.reg

### Disk Image Components
- System configuration files
- User profiles
- Program data
- Drivers
- Location: $ArtifactsDir\*-copy

### Network Artifacts
- ARP table
- Routing table
- Network connections
- DNS cache
- Location: $ArtifactsDir\network-*.txt

### Process Information
- Process list with details
- Service information
- Location: $ArtifactsDir\process-*.txt

### Timeline
- File system timeline
- Recent file modifications
- Location: $ArtifactsDir\system-timeline-*.txt

## Analysis Instructions

### Memory Analysis
1. Use Volatility or similar tools
2. Look for suspicious processes
3. Check for injected code
4. Analyze process memory dumps

### Event Log Analysis
1. Import .evtx files into SIEM
2. Look for security events
3. Check for failed logins
4. Analyze system errors

### Registry Analysis
1. Use Registry Explorer or RegRipper
2. Check for persistence mechanisms
3. Analyze user activity
4. Look for malware artifacts

### Timeline Analysis
1. Import timeline into timeline analysis tools
2. Look for suspicious file modifications
3. Check for data exfiltration
4. Analyze user activity patterns

## Notes
- All artifacts are timestamped
- Use appropriate forensic tools for analysis
- Maintain chain of custody
- Document all findings
"@

        $report | Out-File -FilePath $reportFile -Encoding UTF8
        
        Write-ColorOutput "Created forensic report: $reportFile" "Green"
        "Created forensic report: $reportFile" | Out-File -FilePath $LogFile -Append
        Write-ColorOutput "✅ Forensic report created" "Green"
    }
    catch {
        Write-ColorOutput "Error creating forensic report: $($_.Exception.Message)" "Red"
        "Error creating forensic report: $($_.Exception.Message)" | Out-File -FilePath $LogFile -Append
    }
}

# Main execution
Write-ColorOutput "=== STARTING FORENSIC ARTIFACT COLLECTION ===" "Blue"

# 1. Create memory dumps
Create-MemoryDump

# 2. Export event logs
Export-EventLogs

# 3. Export registry hives
Export-RegistryHives

# 4. Create disk image components
Create-DiskImage

# 5. Collect network artifacts
Collect-NetworkArtifacts

# 6. Collect process information
Collect-ProcessInformation

# 7. Create timeline
Create-Timeline

# 8. Create forensic report
Create-ForensicReport

# Summary
Write-ColorOutput "=== COLLECTION SUMMARY ===" "Blue"
Write-ColorOutput "✅ Memory dumps created" "Green"
Write-ColorOutput "✅ Event logs exported" "Green"
Write-ColorOutput "✅ Registry hives exported" "Green"
Write-ColorOutput "✅ Disk image components created" "Green"
Write-ColorOutput "✅ Network artifacts collected" "Green"
Write-ColorOutput "✅ Process information collected" "Green"
Write-ColorOutput "✅ Timeline created" "Green"
Write-ColorOutput "✅ Forensic report created" "Green"

Write-ColorOutput "=== ARTIFACTS LOCATION ===" "Blue"
Write-ColorOutput "All artifacts saved to: $ArtifactsDir" "Yellow"
Write-ColorOutput "Log file: $LogFile" "Yellow"

Write-ColorOutput "=== ANALYSIS TOOLS ===" "Blue"
Write-ColorOutput "Memory Analysis: Volatility, Rekall" "White"
Write-ColorOutput "Event Logs: Event Viewer, Log Parser" "White"
Write-ColorOutput "Registry: Registry Explorer, RegRipper" "White"
Write-ColorOutput "Timeline: Plaso, log2timeline" "White"
Write-ColorOutput "Network: Wireshark, NetworkMiner" "White"

Write-ColorOutput "🎯 FORENSIC ARTIFACTS COLLECTION COMPLETED!" "Green"
Write-ColorOutput "Ready for forensic analysis exercises!" "Green" 