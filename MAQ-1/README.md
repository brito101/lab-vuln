# 🎯 VULNERABLE AD LAB - Vuln Lab

## 📋 Overview

This laboratory creates an intentionally vulnerable Active Directory environment for security training and penetration testing. The environment includes users with weak passwords, misconfigured services, and known vulnerabilities.

## 🖥️ Virtual Machine Recommendations

### Option 1: Windows Server 2019/2022 (Recommended)
- **Operating System**: Windows Server 2019 Standard or 2022 Standard
- **Minimum Resources**:
  - CPU: 2 vCPUs
  - RAM: 4 GB
  - Disk: 50 GB
  - Network: NAT or Bridge
- **Advantages**: More realistic environment, native Windows tools
- **Disadvantages**: Requires license (can use 180-day trial)

### Option 2: Windows Server 2016
- **Operating System**: Windows Server 2016 Standard
- **Minimum Resources**:
  - CPU: 2 vCPUs
  - RAM: 4 GB
  - Disk: 40 GB
- **Advantages**: Lighter, compatible with older tools
- **Disadvantages**: Less updated

### Option 3: Windows 10/11 Pro
- **Operating System**: Windows 10 Pro or 11 Pro
- **Minimum Resources**:
  - CPU: 2 vCPUs
  - RAM: 4 GB
  - Disk: 40 GB
- **Advantages**: Easier to obtain, familiar
- **Disadvantages**: AD limitations (requires Windows Server)

## 🚀 Quick Installation

### Step 1: Prepare the VM
1. Download Windows Server 2019/2022 from Microsoft website
2. Create a new VM with recommended resources
3. Install Windows Server
4. Configure static IP (e.g., 192.168.1.10)
5. Activate Windows (180-day trial)

### Step 2: Run Installation Script
```powershell
# Open PowerShell as Administrator
Set-ExecutionPolicy Bypass -Scope Process -Force

# Run installation script (use the corrected version)
.\install-ad-lab-fixed.ps1
```

**⚠️ Note**: If you encounter color output errors with any script, all scripts have been updated with robust color handling to prevent installation errors.

### Step 3: Configure Attacker Machine
```powershell
# On a second VM (Windows 10/11)
.\setup-attacker.ps1
```

## 📁 File Structure

```
MAQ-1/
├── install-ad-lab.ps1          # Installation script (updated with color fixes)
├── install-ad-lab-fixed.ps1    # Alternative installation script
├── setup-attacker.ps1          # Attacker machine script (updated)
├── setup-compromised-station.ps1  # Compromised workstation script (updated)
├── verify-lab.ps1              # Lab verification script (updated)
├── simulate-ransomware.ps1     # Ransomware simulation (updated)
├── recover-from-ransomware.ps1 # Recovery script (updated)
├── create-forensic-artifacts.ps1 # Forensic artifacts (updated)
├── reset-windows.ps1           # Reset script (updated)
├── configure-syslog.ps1        # Syslog configuration (updated)
├── README.md                   # This file
└── docs/
    ├── attack-scenarios.md     # Attack scenarios
    └── troubleshooting.md      # Troubleshooting guide
```

## 🔧 Environment Configuration

### Active Directory
- **Domain**: vulnlab.local
- **NetBIOS**: VULNLAB
- **Safe Mode Password**: P@ssw0rd123!
- **Admin Password**: P@ssw0rd123!

### Created Users
| User | Password | Description |
|------|----------|-------------|
| admin | admin123 | Administrator with weak password |
| user1 | password | User with common password |
| test | test123 | Test user |
| guest | guest | Guest user |
| admin2 | admin | Second admin with weak password |
| service | service123 | Service account |
| backup | backup | Backup account |
| webadmin | web123 | Web admin |

### Implemented Vulnerabilities
1. ✅ Weak and predictable passwords
2. ✅ SMB1 enabled
3. ✅ Security auditing disabled
4. ✅ Weak password policies
5. ✅ Account lockout disabled
6. ✅ Kerberos with weak encryption
7. ✅ IIS with default settings
8. ✅ Telnet enabled

## 🖥️ Machine 1 - Compromised Windows Workstation

### A) Vulnerabilities
- **Office Macro Execution**: Enabled macros in Word/Excel documents
- **Vulnerable RPC**: RPC endpoints exposed and misconfigured
- **Misconfigured UAC**: User Account Control bypassed or disabled

### B) Noise Generation
- **C2 Agent Loop**: Continuous C2 beaconing to external servers
- **PowerShell Scripts**: Hidden .ps1 scripts running in background
- **Scheduled Tasks**: Hidden commands in Task Scheduler

### C) Log Generation
- **Event 4688**: Process creation events (continuous)
- **Event 4624**: Successful logon events (frequent)
- **Task Scheduler Changes**: Continuous task modifications

### Implementation Details

#### Office Macro Vulnerabilities
```powershell
# Enable macros in Office
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Office\16.0\Word\Security" -Name "VBAWarnings" -Value 1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Office\16.0\Excel\Security" -Name "VBAWarnings" -Value 1
```

#### RPC Vulnerabilities
```powershell
# Enable vulnerable RPC settings
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\RpcSs" -Name "Start" -Value 2
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\RpcEptMapper" -Name "Start" -Value 2
```

#### UAC Misconfiguration
```powershell
# Disable UAC
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 0
```

#### C2 Agent Simulation
```powershell
# Create C2 beacon script
$C2Script = @"
while ($true) {
    try {
        $response = Invoke-WebRequest -Uri "http://192.168.1.100/beacon" -UseBasicParsing
        Start-Sleep -Seconds 30
    }
    catch {
        Start-Sleep -Seconds 60
    }
}
"@
Set-Content -Path "C:\Windows\Temp\c2agent.ps1" -Value $C2Script
```

#### Hidden PowerShell Scripts
```powershell
# Create hidden PowerShell scripts
$HiddenScript = @"
# Hidden data exfiltration script
$data = Get-Process | Select-Object Name, Id, CPU
$data | Out-File -FilePath "C:\Windows\Temp\data.txt" -Append
"@
Set-Content -Path "C:\Windows\Temp\hidden.ps1" -Value $HiddenScript
```

#### Scheduled Tasks with Hidden Commands
```powershell
# Create scheduled tasks with hidden commands
$taskAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-WindowStyle Hidden -ExecutionPolicy Bypass -File C:\Windows\Temp\hidden.ps1"
$taskTrigger = New-ScheduledTaskTrigger -AtStartup
Register-ScheduledTask -TaskName "SystemUpdate" -Action $taskAction -Trigger $taskTrigger -User "SYSTEM" -RunLevel Highest
```

#### Continuous Log Generation
```powershell
# Generate continuous Event 4688 (Process Creation)
$processes = @("notepad.exe", "calc.exe", "mspaint.exe", "cmd.exe")
while ($true) {
    $randomProcess = $processes | Get-Random
    Start-Process -FilePath $randomProcess -WindowStyle Hidden
    Start-Sleep -Seconds 5
}

# Generate Event 4624 (Successful Logon)
# This requires actual authentication attempts
```

## 🎯 Attack Scenarios

### 1. Basic Enumeration
```powershell
# List users
net user /domain

# List groups
net group /domain

# List computers
net view /domain
```

### 2. Brute Force
```powershell
# Run brute force script
.\bruteforce.ps1
```

### 3. Kerberoasting
```powershell
# Extract TGS tickets
.\kerberoasting.ps1
```

### 4. Pass-the-Hash
```powershell
# Use Mimikatz
mimikatz.exe
privilege::debug
sekurlsa::logonpasswords
```

### 5. Golden Ticket
```powershell
# Create Golden Ticket
kerberos::golden /user:fake /domain:vulnlab.local /sid:S-1-5-21-... /krbtgt:hash /ticket:golden.kirbi
```

### 6. Office Macro Exploitation
```powershell
# Create malicious macro document
# This would be done through Office automation
```

### 7. RPC Exploitation
```powershell
# Exploit RPC vulnerabilities
# Use tools like rpcdump, rpcclient
```

### 8. UAC Bypass
```powershell
# Various UAC bypass techniques
# Registry modifications, DLL hijacking, etc.
```

### 9. Ransomware Simulation
```powershell
# Run ransomware simulation (SAFE - Educational purposes only)
.\simulate-ransomware.ps1

# Recover from simulation
.\recover-from-ransomware.ps1
```

## 🛠️ Recommended Tools

### For Manual Download
- **Mimikatz**: https://github.com/gentilkiwi/mimikatz
- **PowerSploit**: https://github.com/PowerShellMafia/PowerSploit
- **BloodHound**: https://github.com/BloodHoundAD/BloodHound
- **CrackMapExec**: https://github.com/byt3bl33d3r/CrackMapExec
- **Responder**: https://github.com/SpiderLabs/Responder

## 🦠 Ransomware Simulation

### ⚠️ **SAFE SIMULATION FOR TRAINING PURPOSES ONLY**

The MAQ-1 includes a controlled ransomware simulation that demonstrates:
- File encryption simulation (no real encryption)
- Ransom note creation
- Registry modifications
- Network activity simulation
- Security event generation
- Incident response training

### **Simulation Features:**
- ✅ **Safe Environment**: Only affects test directories
- ✅ **No Real Encryption**: Files are modified but not encrypted
- ✅ **Backup Creation**: Automatic backup before simulation
- ✅ **Recovery Tool**: Complete recovery script included
- ✅ **Educational Focus**: Designed for incident response training

### **How to Use:**
```powershell
# Run simulation (requires Administrator)
.\simulate-ransomware.ps1

# Recover from simulation
.\recover-from-ransomware.ps1
```

### **What the Simulation Does:**
1. **Creates test files** in safe directories
2. **Simulates file encryption** by adding headers to files
3. **Creates ransom notes** in multiple locations
4. **Modifies registry** with simulation entries
5. **Generates security events** (4688, 4624)
6. **Simulates network activity** (C2 communication)
7. **Creates incident reports** for training

### **Recovery Process:**
1. **Restores files** from backup
2. **Removes encrypted files**
3. **Deletes ransom notes**
4. **Cleans registry entries**
5. **Removes temporary files**
6. **Verifies recovery** success
7. **Creates recovery report**

### **Training Scenarios:**
- **Incident Detection**: Identify ransomware indicators
- **Response Procedures**: Follow incident response steps
- **Recovery Planning**: Execute recovery procedures
- **Documentation**: Create incident reports
- **Lessons Learned**: Analyze response effectiveness

### Automatically Installed
- Nmap (port enumeration)
- Wireshark (traffic analysis)
- PuTTY (SSH/Telnet connections)
- WinPcap (packet capture)

## 🔍 Useful Commands

### Enumeration
```powershell
# Domain users
net user /domain

# Domain groups
net group /domain

# Domain computers
net view /domain

# Domain trusts
nltest /domain_trusts

# LDAP queries
dsquery user -domain vulnlab.local
dsquery group -domain vulnlab.local
dsquery computer -domain vulnlab.local
```

### Connectivity Tests
```powershell
# Test important ports
Test-NetConnection -ComputerName 192.168.1.10 -Port 389  # LDAP
Test-NetConnection -ComputerName 192.168.1.10 -Port 445  # SMB
Test-NetConnection -ComputerName 192.168.1.10 -Port 88   # Kerberos
```

### Security Analysis
```powershell
# Check password policies
net accounts

# Check auditing
auditpol /get /category:*

# Check SMB settings
Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"
```

### Machine 1 Specific Commands
```powershell
# Check Office macro settings
Get-ItemProperty -Path "HKCU:\Software\Microsoft\Office\16.0\Word\Security"

# Check UAC settings
Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"

# Check RPC services
Get-Service -Name RpcSs, RpcEptMapper

# Check scheduled tasks
Get-ScheduledTask | Where-Object {$_.TaskName -like "*System*"}

# Check for hidden PowerShell processes
Get-Process | Where-Object {$_.ProcessName -eq "powershell"}

# Monitor Event Logs
Get-WinEvent -FilterHashtable @{LogName='Security'; ID=4688} -MaxEvents 10
Get-WinEvent -FilterHashtable @{LogName='Security'; ID=4624} -MaxEvents 10
```

## ⚠️ Security and Isolation

### IMPORTANT
- ⚠️ This environment is **INTENTIONALLY VULNERABLE**
- 🔒 Use **ONLY** in isolated environment
- 🌐 **DO NOT** connect to internet
- 🔑 **DO NOT** use real credentials
- 🗑️ **DESTROY** after use

### Security Recommendations
1. Use NAT or isolated network
2. Disable unnecessary network adapters
3. Don't share folders with host
4. Use snapshots for backup
5. Document all activities

## 🚨 Troubleshooting

### Problem: Script doesn't execute
```powershell
# Check execution policy
Get-ExecutionPolicy

# Change policy temporarily
Set-ExecutionPolicy Bypass -Scope Process -Force
```

### Problem: AD doesn't install
```powershell
# Check if already DC
(Get-WmiObject -Class Win32_ComputerSystem).DomainRole

# Check installed features
Get-WindowsFeature -Name AD-Domain-Services
```

### Problem: Users not created
```powershell
# Check if AD is working
Test-ADAuthentication -Identity Administrator

# Check existing users
Get-ADUser -Filter *
```

### Problem: Connectivity
```powershell
# Test basic connectivity
ping 192.168.1.10

# Check network settings
ipconfig /all

# Check DNS
nslookup vulnlab.local
```

### Problem: Machine 1 not generating noise
```powershell
# Check C2 agent status
Get-Process | Where-Object {$_.ProcessName -like "*powershell*"}

# Check scheduled tasks
Get-ScheduledTask | Where-Object {$_.State -eq "Running"}

# Check event logs
Get-WinEvent -LogName Security -MaxEvents 5
```

### Problem: Color output errors during installation
```powershell
# All scripts now include robust color handling
.\install-ad-lab.ps1

# If you still encounter issues, try:
$env:TERM = "dumb"
.\install-ad-lab.ps1
```

**Solution**: All scripts have been updated with robust color handling that prevents errors related to console color support. The scripts now include fallback mechanisms for different terminal types.

## 📚 Next Steps

1. **Configure Attacker Machine**
   - Install Kali Linux or Windows with tools
   - Configure network for communication
   - Download pentest tools

2. **Execute Attack Scenarios**
   - User and group enumeration
   - Password brute force
   - Kerberoasting
   - Pass-the-Hash
   - Privilege escalation

3. **Document Findings**
   - Record discovered vulnerabilities
   - Document used techniques
   - Create pentest report

4. **Advanced Scenarios**
   - Lateral movement
   - Persistence
   - Domain compromise
   - Golden/Silver tickets

## 📞 Support

For questions or issues:
- Check documentation in `C:\AD-Lab-Info.txt`
- Consult attack guide in `C:\PentestTools\attack-guide.txt`
- Run troubleshooting scripts

## 📄 License

This laboratory is provided "as is" for educational purposes. Use at your own risk.

---

**Vuln Lab** - Security Training Environment
*Version: 1.0 | Date: 2025* 