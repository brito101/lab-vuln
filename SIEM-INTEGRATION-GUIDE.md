# SIEM Integration Guide - Lab Vuln

## 🎯 **Overview**

This guide provides complete instructions for setting up centralized log collection and analysis using a SIEM (Security Information and Event Management) system for all machines in the Lab Vuln environment.

## 🏗️ **Architecture**

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   MAQ-2     │    │   MAQ-3     │
│  (Windows)  │    │  (Laravel)  │    │   (Linux)   │
│             │    │             │    │             │
│ • Windows   │    │ • Laravel   │    │ • SSH       │
│   Events    │    │ • Web Logs  │    │ • FTP       │
│ • AD Logs   │    │ • PHP Logs  │    │ • Samba     │
│ • Security  │    │ • MySQL     │    │ • System    │
└─────────────┘    └─────────────┘    └─────────────┘
       │                   │                   │
       └───────────────────┼───────────────────┘
                           │
                    ┌─────────────┐
                    │   SIEM      │
                    │  Central    │
                    │             │
                    │ • Graylog   │
                    │ • Elastic   │
                    │ • Logstash  │
                    │ • Wazuh     │
                    └─────────────┘
```

## 🚀 **Quick Start**

### **Option 1: Automated Setup**
```bash
# 1. Configure all machines for SIEM
./configure-all-syslog.sh

# 2. Start SIEM and configure inputs
./quick-setup-siem.sh

# 3. Verify configuration
./verify-siem-config.sh
```

### **Option 2: Manual Setup**
```bash
# 1. Start SIEM Central
cd siem-central
./start-siem.sh

# 2. Configure each machine individually

./configure-syslog.ps1  # Run as Administrator

# Laravel (MAQ-2)
cd MAQ-2
./configure-syslog.sh   # Run as root

# Linux (MAQ-3)
cd MAQ-3
./configure-syslog.sh   # Run as root
```

## 📊 **SIEM Services**

### **Graylog** - Primary Log Management
- **URL**: http://localhost:9000
- **Credentials**: admin/admin
- **Features**: Log collection, search, dashboards, alerts
- **Inputs**: Syslog UDP/TCP, GELF UDP

### **Elasticsearch** - Search Engine
- **URL**: http://localhost:9200
- **Features**: Log indexing and search
- **Security**: Disabled for lab environment

### **Logstash** - Log Processing
- **URL**: http://localhost:9600
- **Features**: Log transformation and filtering
- **Inputs**: Beats, TCP, UDP

### **Wazuh** - Security Monitoring
- **URL**: http://localhost:1515 (if configured)
- **Features**: Intrusion detection, file integrity monitoring

## 🔧 **Configuration Details**



### **MAQ-2 (Laravel)**
- **Script**: `MAQ-2/configure-syslog.sh`
- **Requirements**: Run as root
- **Logs Forwarded**:
  - Laravel application logs
  - Nginx/Apache access logs
  - PHP error logs
  - MySQL database logs
  - LFI attempt logs
  - Role escalation logs

### **MAQ-3 (Linux)**
- **Script**: `MAQ-3/configure-syslog.sh`
- **Requirements**: Run as root
- **Logs Forwarded**:
  - SSH authentication logs
  - FTP access logs
  - Samba file access logs
  - System logs (syslog)
  - Audit logs (auditd)
  - Security events

## 📈 **Dashboards and Alerts**

### **Security Dashboard**
- Failed login attempts
- Unauthorized access attempts
- Suspicious file uploads
- LFI/RFI attempts
- Privilege escalation events
- Ransomware indicators

### **Performance Dashboard**
- System resource usage
- Network traffic patterns
- Application performance
- Service availability

### **Attack Dashboard**
- Brute force attempts
- Exploitation attempts
- Lateral movement
- Data exfiltration
- C2 communication

## 🔍 **Log Analysis Examples**

### **Detecting Brute Force Attacks**
```sql
# Graylog Search
source:MAQ-3 AND message:"authentication failure"
```

### **Finding LFI Attempts**
```sql
# Graylog Search
source:MAQ-2 AND message:"../" OR message:"..\\"
```



### **Detecting Ransomware**
```sql
# Graylog Search
message:"encrypted" OR message:"ransom" OR message:"bitcoin"
```

## 🛠️ **Troubleshooting**

### **Common Issues**

#### **1. Logs Not Appearing in SIEM**
```bash
# Check SIEM connectivity
./verify-siem-config.sh

# Test log forwarding
echo "<134>$(date '+%b %d %H:%M:%S') test: Test message" | nc -u localhost 1514

# Check Graylog inputs
curl -u admin:admin http://localhost:9000/api/system/inputs
```

#### **2. SIEM Not Starting**
```bash
# Check disk space
df -h

# Check memory
free -h

# Check Docker
docker-compose ps

# View logs
docker-compose logs -f
```

#### **3. Machine Configuration Issues**
```bash


# Linux (MAQ-2, MAQ-3)
# Check rsyslog status
systemctl status rsyslog

# Check auditd status
systemctl status auditd
```

### **Useful Commands**

#### **SIEM Management**
```bash
# Start SIEM
cd siem-central && ./start-siem.sh

# Stop SIEM
cd siem-central && docker-compose down

# Restart SIEM
cd siem-central && docker-compose restart

# View SIEM logs
cd siem-central && docker-compose logs -f

# Monitor SIEM
cd siem-central && ./monitor-siem.sh
```

#### **Log Forwarding**
```bash
# Test log sending
cd siem-central && ./test-log-sender.sh

# Check log forwarding status
systemctl status laravel-log-forwarder.service  # MAQ-2
systemctl status system-log-monitor.service     # MAQ-3
```

## 📚 **Training Scenarios**

### **Scenario 1: Brute Force Detection**
1. Configure all machines for SIEM
2. Start SIEM and create dashboards
3. Execute brute force attacks on SSH/FTP/Web
4. Monitor logs in Graylog
5. Create alerts for failed attempts

### **Scenario 2: Web Application Attack**
1. Configure MAQ-2 for SIEM
2. Execute LFI attacks on Laravel
3. Monitor logs for attack patterns
4. Create alerts for suspicious requests



### **Scenario 4: Ransomware Simulation**
1. Configure all machines for SIEM
2. Run ransomware simulation script
3. Monitor for encryption events
4. Create incident response procedures

## 🔐 **Security Considerations**

### **Lab Environment**
- SIEM is configured for lab use only
- Authentication is minimal for ease of use
- No encryption between machines and SIEM
- Default credentials for all services

### **Production Considerations**
- Enable authentication and encryption
- Use strong, unique passwords
- Implement proper access controls
- Regular security updates
- Network segmentation
- Backup and recovery procedures

## 📋 **Checklist**

### **Pre-Setup**
- [ ] Docker and Docker Compose installed
- [ ] At least 4GB RAM available
- [ ] At least 10GB disk space
- [ ] Isolated network environment
- [ ] All machines running

### **SIEM Setup**
- [ ] SIEM containers started
- [ ] Graylog accessible at http://localhost:9000
- [ ] Inputs configured in Graylog
- [ ] Test logs received

### **Machine Configuration**
- [ ] MAQ-2 (Laravel) configured
- [ ] MAQ-3 (Linux) configured
- [ ] Log forwarding working
- [ ] Security monitoring active

### **Verification**
- [ ] All services running
- [ ] Logs appearing in SIEM
- [ ] Dashboards created
- [ ] Alerts configured
- [ ] Training scenarios working

## 📞 **Support**

### **Documentation**
- SIEM Central: `siem-central/README.md`
- Machine-specific: `MAQ-X/README.md`
- Credentials: `siem-central/default-credentials.md`

### **Scripts**
- Quick Setup: `./quick-setup-siem.sh`
- Configuration: `./configure-all-syslog.sh`
- Verification: `./verify-siem-config.sh`

### **Logs**
- SIEM Logs: `siem-central/docker-compose logs`
- Machine Logs: Check individual machine directories
- Configuration Logs: `/var/log/` on Linux machines

---

**Remember**: This SIEM setup is for educational purposes. In production, always implement proper security measures! 