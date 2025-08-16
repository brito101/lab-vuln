# Incident Response Scenarios - Lab Vuln

## 🎯 **Overview**

This document contains detailed incident response scenarios for SOC analyst training. Each scenario includes indicators of compromise (IoCs), detection methods, response procedures, and learning objectives.

## ⚠️ **Important Notes**

- **All scenarios are for educational purposes only**
- **Never use these techniques in production without authorization**
- **Always follow ethical hacking principles**
- **Document all activities and findings**

## 📋 **Scenario Categories**

### **🟢 Beginner Scenarios**
- Basic log analysis
- Simple attack detection
- Initial response procedures

### **🟡 Intermediate Scenarios**
- Multi-step attack analysis
- Correlation of events
- Advanced detection techniques

### **🔴 Advanced Scenarios**
- Complex attack chains
- APT simulation
- Incident containment and eradication

---

## 🟢 **SCENARIO 1: Brute Force Attack Detection**

### **🎯 Objective**
Detect and respond to a brute force attack against SSH services on MAQ-3.

### **📊 Scenario Details**
- **Target**: MAQ-3 (Linux SSH)
- **Attack Type**: Brute force with common credentials
- **Duration**: 15-30 minutes
- **Difficulty**: Beginner

### **🔍 Indicators of Compromise (IoCs)**
```
# Log Patterns to Look For
- Multiple failed SSH login attempts
- Source IP: 192.168.1.100
- Usernames: admin, root, user, test
- Time pattern: Rapid successive attempts
- Event IDs: SSH authentication failures
```

### **📝 Detection Steps**
1. **Monitor SSH logs in Graylog**
   ```sql
   source:MAQ-3 AND message:"authentication failure"
   ```

2. **Identify attack pattern**
   - Count failed attempts per source IP
   - Note time intervals between attempts
   - Identify targeted usernames

3. **Check for successful login**
   ```sql
   source:MAQ-3 AND message:"Accepted password"
   ```

### **🚨 Response Procedures**
1. **Immediate Actions**
   - Block source IP in firewall
   - Alert security team
   - Document incident details

2. **Investigation**
   - Check if any account was compromised
   - Review SSH configuration
   - Analyze attack timeline

3. **Containment**
   - Implement rate limiting
   - Enable key-based authentication
   - Disable password authentication

### **📚 Learning Objectives**
- Log analysis techniques
- Pattern recognition
- Incident documentation
- Basic containment procedures

---

## 🟢 **SCENARIO 2: Web Application LFI Attack**

### **🎯 Objective**
Detect and respond to Local File Inclusion (LFI) attacks against the Laravel application on MAQ-2.

### **📊 Scenario Details**
- **Target**: MAQ-2 (Laravel Web Application)
- **Attack Type**: LFI via file parameter
- **Duration**: 20-40 minutes
- **Difficulty**: Beginner

### **🔍 Indicators of Compromise (IoCs)**
```
# Attack Patterns
- URL patterns: /file?path=../../../etc/passwd
- File access attempts: /etc/passwd, /etc/shadow, /proc/version
- Laravel error logs with file path traversal
- Access to sensitive system files
```

### **📝 Detection Steps**
1. **Monitor web server logs**
   ```sql
   source:MAQ-2 AND message:"../" OR message:"..\\"
   ```

2. **Check Laravel application logs**
   ```sql
   source:MAQ-2 AND message:"file_get_contents" AND message:"error"
   ```

3. **Identify suspicious requests**
   - Look for path traversal patterns
   - Monitor access to sensitive files
   - Check for successful file reads

### **🚨 Response Procedures**
1. **Immediate Actions**
   - Block suspicious IP addresses
   - Review web application logs
   - Check for data exfiltration

2. **Investigation**
   - Analyze attack vectors
   - Identify vulnerable endpoints
   - Check for successful file access

3. **Remediation**
   - Patch LFI vulnerabilities
   - Implement input validation
   - Add WAF rules

### **📚 Learning Objectives**
- Web application security
- Log correlation
- Vulnerability assessment
- Patch management

---

## 🟡 **SCENARIO 3: Active Directory Enumeration**

### **🎯 Objective**
Detect and respond to Active Directory enumeration attacks on Windows machines.

### **📊 Scenario Details**
- **Target**: Windows Environment
- **Attack Type**: AD enumeration and reconnaissance
- **Duration**: 30-60 minutes
- **Difficulty**: Intermediate

### **🔍 Indicators of Compromise (IoCs)**
```
# Event Log Patterns
- Event ID 4624: Successful logons
- Event ID 4625: Failed logons
- Event ID 4661: Object access
- Event ID 4662: Object access (successful)
- Multiple LDAP queries
- User enumeration attempts
```

### **📝 Detection Steps**
1. **Monitor AD authentication events**
   ```sql
   source:Windows AND event_id:4625
   ```

2. **Check for enumeration patterns**
   - Multiple failed logons with different usernames
   - LDAP query patterns
   - Unusual access times

3. **Identify reconnaissance tools**
   - Look for tools like BloodHound, PowerView
   - Check for PowerShell execution
   - Monitor for unusual commands

### **🚨 Response Procedures**
1. **Immediate Actions**
   - Block source IP
   - Alert AD administrators
   - Review AD security logs

2. **Investigation**
   - Analyze enumeration scope
   - Check for successful compromises
   - Review AD security configuration

3. **Hardening**
   - Implement account lockout policies
   - Enable advanced auditing
   - Review AD permissions

### **📚 Learning Objectives**
- Windows Event Log analysis
- AD security monitoring
- Threat hunting techniques
- Security policy implementation

---

## 🟡 **SCENARIO 4: Credential Harvesting via Samba**

### **🎯 Objective**
Detect and respond to credential harvesting attacks via Samba file sharing on MAQ-3.

### **📊 Scenario Details**
- **Target**: MAQ-3 (Linux Samba Server)
- **Attack Type**: Credential harvesting and lateral movement
- **Duration**: 25-45 minutes
- **Difficulty**: Intermediate

### **🔍 Indicators of Compromise (IoCs)**
```
# Samba Log Patterns
- Multiple authentication failures
- Access to sensitive directories
- File enumeration attempts
- Credential dumping tools
- Lateral movement indicators
```

### **📝 Detection Steps**
1. **Monitor Samba access logs**
   ```sql
   source:MAQ-3 AND message:"smbd" AND message:"authentication"
   ```

2. **Check for file access patterns**
   - Access to user directories
   - Attempts to read sensitive files
   - Unusual file operations

3. **Identify attack tools**
   - Look for tools like Responder
   - Check for NTLM hash capture
   - Monitor for credential dumping

### **🚨 Response Procedures**
1. **Immediate Actions**
   - Disconnect affected shares
   - Block suspicious IPs
   - Review Samba configuration

2. **Investigation**
   - Analyze compromised accounts
   - Check for lateral movement
   - Review network traffic

3. **Remediation**
   - Reset compromised credentials
   - Implement SMB signing
   - Disable legacy protocols

### **📚 Learning Objectives**
- Network protocol analysis
- Credential protection
- Lateral movement detection
- Security configuration

---

## 🔴 **SCENARIO 5: Ransomware Attack Simulation**

### **🎯 Objective**
Detect and respond to a simulated ransomware attack across multiple machines.

### **📊 Scenario Details**
- **Target**: All machines (MAQ-2, MAQ-3)
- **Attack Type**: Ransomware simulation with encryption
- **Duration**: 45-90 minutes
- **Difficulty**: Advanced

### **🔍 Indicators of Compromise (IoCs)**
```
# Ransomware Indicators
- File encryption events
- Ransom note creation
- Registry modifications
- Process creation (encryption tools)
- Network communication to C2
- File extension changes (.encrypted)
```

### **📝 Detection Steps**
1. **Monitor file system changes**
   ```sql
   message:"encrypted" OR message:"ransom" OR message:"bitcoin"
   ```

2. **Check for encryption processes**
   - Monitor process creation
   - Look for encryption tools
   - Check for file modifications

3. **Identify C2 communication**
   - Monitor network connections
   - Check for unusual outbound traffic
   - Look for command execution

### **🚨 Response Procedures**
1. **Immediate Actions**
   - Isolate affected systems
   - Disconnect from network
   - Alert incident response team
   - Document ransom demands

2. **Investigation**
   - Determine attack scope
   - Identify initial access vector
   - Check for data exfiltration
   - Analyze encryption methods

3. **Containment and Recovery**
   - Implement network segmentation
   - Restore from backups
   - Patch vulnerabilities
   - Update security controls

### **📚 Learning Objectives**
- Incident response procedures
- Business continuity planning
- Forensic analysis
- Crisis management

---

## 🔴 **SCENARIO 6: Advanced Persistent Threat (APT) Simulation**

### **🎯 Objective**
Detect and respond to a complex APT attack involving multiple stages and techniques.

### **📊 Scenario Details**
- **Target**: All machines in the environment
- **Attack Type**: Multi-stage APT with persistence
- **Duration**: 60-120 minutes
- **Difficulty**: Advanced

### **🔍 Indicators of Compromise (IoCs)**
```
# APT Indicators
- Initial access via phishing
- Privilege escalation
- Lateral movement
- Data exfiltration
- Persistence mechanisms
- C2 communication
- Living-off-the-land techniques
```

### **📝 Detection Steps**
1. **Monitor for initial access**
   - Check for suspicious emails
   - Monitor file downloads
   - Look for macro execution

2. **Detect privilege escalation**
   - Monitor for UAC bypass
   - Check for token manipulation
   - Look for credential dumping

3. **Identify lateral movement**
   - Monitor for remote connections
   - Check for service creation
   - Look for scheduled tasks

4. **Detect data exfiltration**
   - Monitor for large data transfers
   - Check for unusual network traffic
   - Look for file compression

### **🚨 Response Procedures**
1. **Immediate Actions**
   - Activate incident response plan
   - Isolate affected systems
   - Preserve evidence
   - Notify stakeholders

2. **Investigation**
   - Conduct threat hunting
   - Analyze attack timeline
   - Identify all compromised systems
   - Determine data impact

3. **Eradication and Recovery**
   - Remove all persistence mechanisms
   - Patch all vulnerabilities
   - Implement additional security controls
   - Conduct post-incident review

### **📚 Learning Objectives**
- Advanced threat hunting
- Incident response coordination
- Evidence preservation
- Threat intelligence integration

---

## 📊 **Scenario Execution Guide**

### **🔄 Setup Instructions**

#### **Pre-Scenario Setup**
```bash
# 1. Start SIEM and configure all machines
./configure-all-syslog.sh
./quick-setup-siem.sh

# 2. Verify SIEM is working
./verify-siem-config.sh

# 3. Create dashboards in Graylog
# - Security Events Dashboard
# - Attack Detection Dashboard
# - System Performance Dashboard
```

#### **Scenario Execution**
```bash
# For each scenario:
# 1. Brief students on objectives
# 2. Execute attack simulation
# 3. Monitor SIEM for detection
# 4. Guide response procedures
# 5. Document findings
```

### **📋 Assessment Criteria**

#### **Detection (40%)**
- [ ] Identified attack indicators
- [ ] Correlated events properly
- [ ] Used appropriate search queries
- [ ] Timely detection

#### **Response (30%)**
- [ ] Followed incident response procedures
- [ ] Implemented appropriate containment
- [ ] Documented actions taken
- [ ] Communicated effectively

#### **Analysis (20%)**
- [ ] Root cause analysis
- [ ] Impact assessment
- [ ] Lessons learned
- [ ] Recommendations

#### **Documentation (10%)**
- [ ] Complete incident report
- [ ] Evidence preservation
- [ ] Timeline documentation
- [ ] Action items

### **🎯 Learning Outcomes**

#### **Technical Skills**
- Log analysis and correlation
- Threat hunting techniques
- Incident response procedures
- Security tool utilization

#### **Soft Skills**
- Communication under pressure
- Team coordination
- Decision making
- Documentation

#### **Security Knowledge**
- Attack methodologies
- Defense strategies
- Compliance requirements
- Best practices

---

## 📚 **Additional Resources**

### **Tools and References**
- **SIEM Documentation**: `siem-central/README.md`
- **Machine Configurations**: `MAQ-X/README.md`
- **Default Credentials**: `default-credentials.md`
- **SIEM Integration**: `SIEM-INTEGRATION-GUIDE.md`

### **Training Materials**
- **Attack Simulation Scripts**: Available in each machine directory
- **Detection Rules**: Graylog search queries provided
- **Response Playbooks**: Step-by-step procedures included
- **Assessment Templates**: Evaluation criteria provided

### **Advanced Scenarios**
- **Custom Attack Chains**: Combine multiple scenarios
- **Red Team vs Blue Team**: Competitive exercises
- **Purple Team**: Collaborative attack/defense
- **Capture the Flag**: CTF-style challenges

---

## 🚨 **Emergency Procedures**

### **If Something Goes Wrong**
1. **Stop all activities immediately**
2. **Document what happened**
3. **Notify instructor/supervisor**
4. **Follow incident response procedures**
5. **Preserve evidence for analysis**

### **Safety Guidelines**
- **Never use real credentials**
- **Never attack production systems**
- **Always follow ethical guidelines**
- **Document everything**
- **Ask for help when needed**

---

**Remember**: These scenarios are designed for learning. Always practice responsible disclosure and ethical hacking principles! 