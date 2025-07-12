# Attack Simulation Scripts - Lab Vuln

## 🎯 **Overview**

This directory contains automated attack simulation scripts for the Lab Vuln environment. These scripts are designed to generate realistic attack patterns for SOC analyst training and SIEM detection testing.

## ⚠️ **Important Warnings**

- **All scripts are for educational purposes only**
- **Never use these scripts in production environments**
- **Always run in isolated lab environments**
- **Follow ethical hacking principles**
- **Document all activities**

## 📋 **Available Simulations**

### **🟢 Beginner Scenarios**

#### **1. Brute Force Attack (`brute-force-simulation.sh`)**
- **Target**: MAQ-3 (SSH Service)
- **Duration**: 5 minutes
- **Technique**: SSH brute force with common credentials
- **Detection**: Monitor SSH authentication failures
- **Response**: Block source IP, implement rate limiting

**Usage:**
```bash
cd attack-simulations
./brute-force-simulation.sh
```

**SIEM Detection:**
```sql
source:MAQ-3 AND message:"authentication failure"
source:MAQ-3 AND message:"Failed password"
```

#### **2. LFI Attack (`lfi-simulation.sh`)**
- **Target**: MAQ-2 (Laravel Web Application)
- **Duration**: 10 minutes
- **Technique**: Local File Inclusion via path traversal
- **Detection**: Monitor web server logs for path traversal
- **Response**: Block IP, patch vulnerabilities, add WAF rules

**Usage:**
```bash
cd attack-simulations
./lfi-simulation.sh
```

**SIEM Detection:**
```sql
source:MAQ-2 AND message:"../" OR message:"..\\"
source:MAQ-2 AND message:"file_get_contents" AND message:"error"
```

### **🔴 Advanced Scenarios**

#### **3. Ransomware Simulation (`ransomware-simulation.ps1`)**
- **Target**: MAQ-1 (Windows Machines)
- **Duration**: 5 minutes
- **Technique**: File modification, registry changes, C2 communication
- **Detection**: Monitor file changes, process creation, network connections
- **Response**: Isolate systems, alert IR team, restore from backups

**Usage:**
```powershell
cd attack-simulations
.\ransomware-simulation.ps1
```

**SIEM Detection:**
```sql
source:MAQ-1 AND message:"encrypted" OR message:"ransom"
source:MAQ-1 AND event_id:4688 AND message:"ransomware"
source:MAQ-1 AND event_id:4657 AND message:"RansomwareSim"
```

## 🚀 **Quick Start**

### **Prerequisites**
1. SIEM configured and running
2. All machines configured for log forwarding
3. Network connectivity between machines
4. Appropriate permissions (admin/root)

### **Setup Instructions**
```bash
# 1. Configure SIEM and machines
./configure-all-syslog.sh
./quick-setup-siem.sh

# 2. Verify setup
./verify-siem-config.sh

# 3. Run simulations
cd attack-simulations
./brute-force-simulation.sh
./lfi-simulation.sh
# For Windows: .\ransomware-simulation.ps1
```

### **Execution Order**
1. **Start SIEM** and verify it's working
2. **Configure dashboards** in Graylog
3. **Run simulation** in one terminal
4. **Monitor SIEM** in another terminal
5. **Document findings** and response procedures

## 📊 **Monitoring and Detection**

### **SIEM Dashboards**
Create these dashboards in Graylog for effective monitoring:

#### **Security Events Dashboard**
- Failed authentication attempts
- Suspicious file access
- Process creation events
- Network connections

#### **Attack Detection Dashboard**
- Brute force patterns
- LFI/RFI attempts
- Ransomware indicators
- C2 communication

#### **System Performance Dashboard**
- Resource usage
- Service availability
- Network traffic
- Error rates

### **Alert Rules**
Configure these alert rules in Graylog:

#### **Brute Force Alert**
```javascript
// Alert when multiple failed SSH attempts detected
{
  "condition": "count > 10",
  "field": "source_ip",
  "time": "5 minutes",
  "message": "Possible brute force attack detected"
}
```

#### **LFI Alert**
```javascript
// Alert when path traversal detected
{
  "condition": "message contains '../'",
  "field": "source",
  "time": "1 minute",
  "message": "LFI attack attempt detected"
}
```

#### **Ransomware Alert**
```javascript
// Alert when encryption indicators detected
{
  "condition": "message contains 'encrypted'",
  "field": "source",
  "time": "1 minute",
  "message": "Ransomware activity detected"
}
```

## 📝 **Documentation and Logging**

### **Log Files**
Each simulation creates detailed log files:
- `brute-force-simulation-YYYYMMDD-HHMMSS.log`
- `lfi-simulation-YYYYMMDD-HHMMSS.log`
- `ransomware-simulation-YYYYMMDD-HHMMSS.log`

### **Log Content**
- Attack parameters and configuration
- Attempt details and results
- Success/failure statistics
- Timestamps and durations
- SIEM detection instructions

### **Analysis Reports**
After each simulation, create:
1. **Detection Report**: What was detected and when
2. **Response Report**: Actions taken and their effectiveness
3. **Lessons Learned**: Improvements for next time
4. **Recommendations**: Security enhancements

## 🛠️ **Customization**

### **Modifying Attack Parameters**
Edit the configuration variables in each script:

#### **Brute Force Script**
```bash
TARGET_IP="192.168.1.103"  # Change target IP
ATTACK_DURATION=300         # Change duration
DELAY_BETWEEN_ATTEMPTS=2    # Change delay
```

#### **LFI Script**
```bash
TARGET_URL="http://192.168.1.102:8000"  # Change target URL
ATTACK_DURATION=600                      # Change duration
```

#### **Ransomware Script**
```powershell
$SimulationDuration = 300  # Change duration
$TargetDirectories = @("C:\Users\Public\Documents")  # Change targets
```

### **Adding New Simulations**
To create a new simulation:

1. **Create script** with proper headers and warnings
2. **Add configuration** variables at the top
3. **Include logging** functionality
4. **Add SIEM detection** instructions
5. **Document response** procedures
6. **Test thoroughly** in lab environment

## 🔧 **Troubleshooting**

### **Common Issues**

#### **Scripts Not Working**
- Check target accessibility
- Verify network connectivity
- Ensure proper permissions
- Check log files for errors

#### **SIEM Not Detecting**
- Verify log forwarding is working
- Check SIEM inputs are configured
- Test with manual log sending
- Review search queries

#### **False Positives**
- Adjust detection thresholds
- Fine-tune search queries
- Update alert rules
- Document false positive patterns

### **Debugging Commands**
```bash
# Test target connectivity
ping <target_ip>
nc -z <target_ip> <port>

# Test SIEM connectivity
echo "<134>$(date '+%b %d %H:%M:%S') test: Test message" | nc -u localhost 1514

# Check log forwarding
systemctl status laravel-log-forwarder.service  # MAQ-2
systemctl status system-log-monitor.service     # MAQ-3

# View simulation logs
tail -f *.log
```

## 📚 **Learning Objectives**

### **Technical Skills**
- Log analysis and correlation
- Attack pattern recognition
- Incident response procedures
- SIEM configuration and monitoring

### **Soft Skills**
- Communication under pressure
- Team coordination
- Decision making
- Documentation

### **Security Knowledge**
- Attack methodologies
- Detection techniques
- Response strategies
- Prevention measures

## 🚨 **Safety Guidelines**

### **Before Running Simulations**
1. **Verify lab isolation**
2. **Check all systems are lab-only**
3. **Ensure proper permissions**
4. **Document start time**
5. **Prepare monitoring tools**

### **During Simulations**
1. **Monitor SIEM continuously**
2. **Document all activities**
3. **Follow response procedures**
4. **Communicate with team**
5. **Preserve evidence**

### **After Simulations**
1. **Complete incident reports**
2. **Analyze detection effectiveness**
3. **Identify improvements**
4. **Update procedures**
5. **Share lessons learned**

## 📞 **Support**

### **Documentation**
- **Scenarios**: `../scenarios.md`
- **SIEM Integration**: `../SIEM-INTEGRATION-GUIDE.md`
- **Machine Configs**: `../MAQ-X/README.md`

### **Scripts**
- **Configuration**: `../configure-all-syslog.sh`
- **SIEM Setup**: `../quick-setup-siem.sh`
- **Verification**: `../verify-siem-config.sh`

### **Emergency Procedures**
- **Stop all activities** if something goes wrong
- **Document what happened**
- **Notify instructor/supervisor**
- **Follow incident response procedures**
- **Preserve evidence for analysis**

---

**Remember**: These simulations are for learning. Always practice responsible disclosure and ethical hacking principles! 