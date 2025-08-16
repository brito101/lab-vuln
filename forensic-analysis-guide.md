# Forensic Analysis Guide - Lab Vuln

## Overview

This guide provides instructions for analyzing forensic artifacts created by the Lab Vuln environment. The artifacts include memory dumps, event logs, disk images, and timeline data for comprehensive forensic analysis exercises.

## Artifacts Overview


- **Memory Dumps**: Process memory dumps (.dmp files)
- **Event Logs**: Windows Event Logs (.evtx files)
- **Registry Hives**: System registry files (.reg files)
- **Disk Images**: Logical copies of important directories
- **Network Artifacts**: ARP tables, routing tables, connections
- **Timeline**: File system timeline data

### Linux Artifacts (MAQ-3)
- **Memory Dumps**: Kernel and process memory dumps (.raw files)
- **System Logs**: Various system log files
- **Audit Logs**: Audit trail information
- **Network Artifacts**: Network connections, firewall rules
- **Process Information**: Process lists, open files
- **Timeline**: File system timeline data

## Analysis Tools

### Memory Analysis
```bash
# Volatility Framework
volatility -f memory-dump.raw imageinfo
volatility -f memory-dump.raw pslist
volatility -f memory-dump.raw pstree
volatility -f memory-dump.raw netscan
volatility -f memory-dump.raw filescan
volatility -f memory-dump.raw malfind

# Rekall Framework
rekall -f memory-dump.raw pslist
rekall -f memory-dump.raw netscan
rekall -f memory-dump.raw filescan
```

### Event Log Analysis
```bash
# Windows Event Logs
wevtutil qe Security /f:text /c:100
wevtutil qe Application /f:text /c:100
wevtutil qe System /f:text /c:100

# Linux Log Analysis
grep "authentication failure" /var/log/auth.log
grep "failed login" /var/log/auth.log
grep "sudo" /var/log/auth.log
```

### Registry Analysis
```bash
# Registry Explorer
regedit.exe

# RegRipper
rip.exe -r SYSTEM -p samparse
rip.exe -r SOFTWARE -p winver
rip.exe -r SYSTEM -p timezone
```

### Timeline Analysis
```bash
# Plaso (log2timeline)
log2timeline.py timeline.plaso /path/to/evidence
psort.py -o l2tcsv -w timeline.csv timeline.plaso

# The Sleuth Kit
fls -r -m /path/to/image > timeline.txt
mactime -b timeline.txt -d -m
```

### Network Analysis
```bash
# Wireshark
wireshark network-capture.pcap

# NetworkMiner
NetworkMiner.exe network-capture.pcap

# Netstat Analysis
grep "ESTABLISHED" netstat-output.txt
grep ":22" netstat-output.txt
```

## Analysis Scenarios

### Scenario 1: Brute Force Attack Detection

#### Windows Analysis
1. **Event Log Analysis**
   ```powershell
   # Check for failed logins
   wevtutil qe Security /q:"*[System[EventID=4625]]" /f:text
   
   # Check for successful logins
   wevtutil qe Security /q:"*[System[EventID=4624]]" /f:text
   ```

2. **Registry Analysis**
   ```bash
   # Check for persistence mechanisms
   rip.exe -r SOFTWARE -p run
   rip.exe -r SYSTEM -p winlogon
   ```

3. **Memory Analysis**
   ```bash
   # Look for suspicious processes
   volatility -f memory-dump.raw pslist
   volatility -f memory-dump.raw netscan
   ```

#### Linux Analysis
1. **Authentication Logs**
   ```bash
   # Check for failed SSH attempts
   grep "sshd.*Failed password" /var/log/auth.log
   
   # Check for successful logins
   grep "sshd.*Accepted password" /var/log/auth.log
   ```

2. **Process Analysis**
   ```bash
   # Look for suspicious processes
   ps aux | grep -E "(ssh|telnet|nc|netcat)"
   ```

3. **Network Analysis**
   ```bash
   # Check for unusual connections
   netstat -tuln | grep ":22"
   ```

### Scenario 2: Malware Detection

#### Windows Analysis
1. **Memory Analysis**
   ```bash
   # Check for injected code
   volatility -f memory-dump.raw malfind
   volatility -f memory-dump.raw hollowfind
   
   # Check for suspicious DLLs
   volatility -f memory-dump.raw dlllist
   ```

2. **Registry Analysis**
   ```bash
   # Check for persistence
   rip.exe -r SOFTWARE -p run
   rip.exe -r SYSTEM -p winlogon
   rip.exe -r SYSTEM -p services
   ```

3. **Event Log Analysis**
   ```powershell
   # Check for process creation
   wevtutil qe Security /q:"*[System[EventID=4688]]" /f:text
   ```

#### Linux Analysis
1. **Process Analysis**
   ```bash
   # Check for unusual processes
   ps aux | grep -v grep | grep -E "(nc|netcat|wget|curl)"
   
   # Check for hidden processes
   ls /proc | grep -E "^[0-9]+$" | while read pid; do
     if ! ps -p $pid >/dev/null 2>&1; then
       echo "Hidden process: $pid"
     fi
   done
   ```

2. **File System Analysis**
   ```bash
   # Check for recently modified files
   find /home /root /tmp -type f -mtime -1 -ls
   
   # Check for executable files
   find /home /root /tmp -type f -executable -ls
   ```

### Scenario 3: Data Exfiltration

#### Windows Analysis
1. **Network Analysis**
   ```bash
   # Check for unusual connections
   volatility -f memory-dump.raw netscan
   volatility -f memory-dump.raw connections
   ```

2. **File System Analysis**
   ```bash
   # Check for recently accessed files
   volatility -f memory-dump.raw filescan
   volatility -f memory-dump.raw mftparser
   ```

3. **Timeline Analysis**
   ```bash
   # Analyze file system timeline
   mactime -b timeline.txt -d -m | grep -E "(\.doc|\.pdf|\.xls)"
   ```

#### Linux Analysis
1. **Network Analysis**
   ```bash
   # Check for outgoing connections
   netstat -tuln | grep ESTABLISHED
   
   # Check for data transfer
   tcpdump -r network-capture.pcap -A | grep -E "(GET|POST)"
   ```

2. **File System Analysis**
   ```bash
   # Check for recently accessed files
   find /home /root -type f -atime -1 -ls
   
   # Check for large file transfers
   find /home /root -type f -size +10M -ls
   ```

## Analysis Workflow

### 1. Initial Assessment
```bash
# Check artifact integrity
md5sum *.raw *.evtx *.log
sha256sum *.raw *.evtx *.log

# Verify timestamps
stat *.raw *.evtx *.log
```

### 2. Memory Analysis
```bash
# Identify operating system
volatility -f memory-dump.raw imageinfo

# List running processes
volatility -f memory-dump.raw pslist

# Check network connections
volatility -f memory-dump.raw netscan

# Look for suspicious processes
volatility -f memory-dump.raw malfind
```

### 3. Log Analysis
```bash
# Windows Event Logs
wevtutil qe Security /f:text /c:1000 > security_events.txt
wevtutil qe Application /f:text /c:1000 > application_events.txt

# Linux Logs
grep -i "error\|fail\|denied" /var/log/*.log > errors.txt
grep -i "login\|auth\|ssh" /var/log/auth.log > auth_events.txt
```

### 4. Timeline Analysis
```bash
# Create timeline
log2timeline.py timeline.plaso /path/to/evidence

# Export timeline
psort.py -o l2tcsv -w timeline.csv timeline.plaso

# Analyze timeline
grep "2024-01-15" timeline.csv | head -100
```

### 5. Network Analysis
```bash
# Analyze network connections
grep "ESTABLISHED" netstat-output.txt

# Check for unusual ports
grep -E ":(22|23|80|443|3389)" netstat-output.txt

# Analyze firewall rules
cat firewall-rules.txt
```

## Reporting

### Report Template
```markdown
# Forensic Analysis Report

## Executive Summary
- Brief overview of findings
- Key indicators of compromise
- Timeline of events

## Technical Analysis
- Memory analysis results
- Log analysis findings
- Network analysis results
- Timeline analysis

## Indicators of Compromise
- IP addresses
- File hashes
- Registry keys
- Process names

## Recommendations
- Immediate actions
- Long-term improvements
- Security enhancements
```

### Evidence Documentation
```bash
# Create evidence log
echo "Evidence collected on $(date)" > evidence_log.txt
echo "Memory dump: $(md5sum memory-dump.raw)" >> evidence_log.txt
echo "Event logs: $(md5sum *.evtx)" >> evidence_log.txt
echo "System logs: $(md5sum *.log)" >> evidence_log.txt
```

## Tools Installation

### Windows Tools
```powershell
# Install Volatility
pip install volatility3

# Install RegRipper
# Download from https://github.com/keydet89/RegRipper3.0

# Install Plaso
pip install plaso
```

### Linux Tools
```bash
# Install Volatility
pip install volatility3

# Install Plaso
pip install plaso

# Install The Sleuth Kit
sudo apt install sleuthkit

# Install Autopsy
sudo apt install autopsy
```

## Best Practices

### Chain of Custody
1. Document all evidence collection
2. Maintain evidence integrity
3. Use write-blocking devices
4. Create hash values for all evidence

### Analysis Environment
1. Use isolated analysis environment
2. Keep original evidence intact
3. Document all analysis steps
4. Use validated forensic tools

### Documentation
1. Record all analysis steps
2. Document findings with evidence
3. Create detailed timeline
4. Maintain analysis notes

## Troubleshooting

### Common Issues
```bash
# Memory dump too large
split -b 2G memory-dump.raw memory-dump-part-

# Corrupted event logs
wevtutil qe Security /f:text /c:10

# Timeline analysis errors
log2timeline.py --debug timeline.plaso /path/to/evidence
```

### Performance Optimization
```bash
# Use RAM disk for large files
sudo mount -t tmpfs -o size=4G tmpfs /mnt/ramdisk

# Parallel processing
parallel -j 4 volatility -f {} pslist ::: memory-dumps/*.raw
```

## Resources

### Documentation
- [Volatility Documentation](https://volatility3.readthedocs.io/)
- [Plaso Documentation](https://plaso.readthedocs.io/)
- [The Sleuth Kit Documentation](https://www.sleuthkit.org/)

### Training Materials
- [SANS FOR508](https://www.sans.org/courses/advanced-incident-response-threat-hunting-training/)
- [GCFE Certification](https://www.giac.org/certifications/computer-forensics-essentials-gcfe/)

### Tools
- [Volatility Framework](https://www.volatilityfoundation.org/)
- [Plaso](https://github.com/log2timeline/plaso)
- [The Sleuth Kit](https://www.sleuthkit.org/)
- [Autopsy](https://www.autopsy.com/) 