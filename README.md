# Lab - Vulnerable Machines Laboratory

A comprehensive laboratory environment for cybersecurity training, incident response, and SOC (Security Operations Center) exercises.

## ⚠️ **IMPORTANT WARNING**

**THIS LABORATORY CONTAINS INTENTIONALLY VULNERABLE SYSTEMS!**

- 🚫 **NEVER** use in production environments
- 🚫 **NEVER** connect to public internet
- 🚫 **NEVER** use with real sensitive data
- ✅ **ONLY** use in isolated, controlled environments for educational purposes

## 🎯 **Purpose**

This laboratory is designed for:
- **Cybersecurity Training**: Hands-on experience with real vulnerabilities
- **Incident Response Practice**: Detection and remediation exercises
- **SOC Analyst Training**: Log analysis and threat hunting
- **Penetration Testing**: Ethical hacking and security assessment
- **Red Team/Blue Team Exercises**: Attack simulation and defense practice

## 🏗️ **Laboratory Structure**

```
rsquad-lab/
├── MAQ-1/          # Machine 1 - [Description]
├── MAQ-2/          # Machine 2 - [Description]  
├── MAQ-3/          # Machine 3 - Linux Debian (Infrastructure/File Server)
├── MAQ-Windows/    # Windows Machine - [Description]
└── docs/           # Documentation and guides
```

## 🖥️ **Available Machines**

### **MAQ-3 - Linux Debian (Infrastructure/File Server)**
- **Services**: SSH, FTP (vsftpd), Samba, Syslog
- **Vulnerabilities**: Weak SSH keys, anonymous FTP, misconfigured Samba, credential leakage
- **Attack Scenarios**: File enumeration, credential harvesting, privilege escalation
- **Detection Points**: Authentication logs, file access patterns, network traffic

### **MAQ-2 - [Coming Soon]**
- **Description**: [To be defined]
- **Vulnerabilities**: [To be defined]
- **Attack Scenarios**: [To be defined]

### **MAQ-1 - [Coming Soon]**
- **Description**: [To be defined]
- **Vulnerabilities**: [To be defined]
- **Attack Scenarios**: [To be defined]

### **MAQ-Windows - [Coming Soon]**
- **Description**: Windows-based vulnerable system
- **Vulnerabilities**: [To be defined]
- **Attack Scenarios**: [To be defined]

## 🚀 **Quick Start**

### Prerequisites
- Docker and Docker Compose installed
- At least 4GB RAM available
- Isolated network environment

### Getting Started
```bash
# Clone or download this repository
git clone <repository-url>
cd rsquad-lab

# Start a specific machine
cd MAQ-3
docker-compose up -d

# Access the machine
docker exec -it maquina3-soc bash
```

## 🔧 **Machine Management**

Each machine directory contains:
- `Dockerfile` - Container configuration
- `docker-compose.yml` - Orchestration file
- `deploy.sh` - Deployment script
- `README.md` - Machine-specific documentation
- Configuration scripts for vulnerabilities

### Common Commands
```bash
# Start machine
docker-compose up -d

# View logs
docker-compose logs -f

# Stop machine
docker-compose down

# Rebuild machine
docker-compose up -d --build
```

## 🎓 **Training Scenarios**

### **Blue Team Exercises**
1. **Log Analysis**: Monitor authentication attempts, file access, network connections
2. **Incident Detection**: Identify suspicious activities and potential breaches
3. **Threat Hunting**: Search for indicators of compromise (IoCs)
4. **Response Procedures**: Document and respond to security incidents

### **Red Team Exercises**
1. **Reconnaissance**: Network scanning, service enumeration
2. **Initial Access**: Exploit vulnerabilities to gain entry
3. **Persistence**: Maintain access across system restarts
4. **Lateral Movement**: Navigate through the network
5. **Data Exfiltration**: Extract sensitive information

### **Purple Team Exercises**
1. **Attack Simulation**: Red team executes attacks while blue team defends
2. **Gap Analysis**: Identify detection and response weaknesses
3. **Tool Validation**: Test security tools and procedures
4. **Process Improvement**: Refine incident response workflows

## 📊 **Monitoring and Detection**

### **Key Log Files**
- Authentication logs (`/var/log/auth.log`)
- System logs (`/var/log/syslog`)
- Service-specific logs (SSH, FTP, Samba)
- Network traffic logs
- Application logs

### **Detection Tools**
- SIEM systems (ELK Stack, Splunk, etc.)
- Network monitoring (Wireshark, tcpdump)
- Host-based monitoring (auditd, OSSEC)
- Endpoint detection and response (EDR) tools

## 🛡️ **Security Considerations**

### **Lab Environment**
- Use isolated network segments
- Implement proper access controls
- Regular snapshot/backup procedures
- Clear documentation of configurations

### **Student Guidelines**
- Never use real credentials or data
- Follow ethical hacking principles
- Document all activities
- Report any unintended vulnerabilities

## 📚 **Learning Resources**

### **Prerequisites**
- Basic Linux/Windows administration
- Network fundamentals
- Cybersecurity concepts
- Docker basics

### **Recommended Tools**
- **Network Analysis**: Wireshark, Nmap, Netcat
- **Vulnerability Assessment**: Nessus, OpenVAS, Nmap scripts
- **Exploitation**: Metasploit, Burp Suite, OWASP ZAP
- **Forensics**: Autopsy, Volatility, Sleuth Kit

### **Certifications**
This lab supports preparation for:
- CompTIA Security+
- CEH (Certified Ethical Hacker)
- OSCP (Offensive Security Certified Professional)
- SANS courses (SEC504, SEC511, etc.)

## 🤝 **Contributing**

### **Adding New Machines**
1. Create a new directory (e.g., `MAQ-4/`)
2. Include all necessary configuration files
3. Document vulnerabilities and attack scenarios
4. Update this README with machine details

### **Improving Documentation**
- Add detailed attack scenarios
- Include detection and response procedures
- Provide step-by-step guides
- Share lessons learned

## 📞 **Support**

For issues or questions:
- Check machine-specific README files
- Review Docker logs for troubleshooting
- Consult cybersecurity documentation
- Contact lab administrators

## 📄 **License**

This laboratory is for educational purposes only. Users are responsible for:
- Using the lab in appropriate environments
- Following ethical guidelines
- Not using for malicious purposes
- Respecting intellectual property rights

---

**Remember**: This is a learning environment. Always practice responsible disclosure and ethical hacking principles. 