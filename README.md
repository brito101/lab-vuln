# Lab Vuln - SOC Training Environment

## Overview

Lab Vuln is a comprehensive Security Operations Center (SOC) training environment designed for cybersecurity education and hands-on practice. The lab includes vulnerable machines, centralized logging, incident response scenarios, attack simulations, forensic artifacts, and SIEM integrations for complete SOC training experiences.

## Architecture

The lab environment consists of:

- **MAQ-1**: Windows Active Directory with vulnerabilities
- **MAQ-2**: Laravel web application with security flaws
- **MAQ-3**: Linux infrastructure with misconfigurations
- **SIEM Central**: Centralized logging and monitoring (Graylog, Elasticsearch, Wazuh)
- **Attack Simulations**: Automated attack scenarios for training
- **Forensic Artifacts**: Memory dumps, event logs, and disk images for analysis
- **SIEM Integrations**: Support for Wazuh, ELK Stack, Splunk, Graylog, QRadar

## Quick Start

### 1. Prerequisites
```bash
# Install Docker and Docker Compose
sudo apt update
sudo apt install docker.io docker-compose

# Add user to docker group
sudo usermod -aG docker $USER
```

### 2. Start SIEM Central
```bash
cd siem-central
docker-compose up -d
./configure-graylog.sh
```

### 3. Configure Machines
```bash
# Configure all machines for SIEM forwarding
./configure-all-syslog.sh
```

### 4. Verify Setup
```bash
# Verify SIEM configuration
./verify-siem-config.sh
```

### 5. Run Attack Simulations
```bash
cd attack-simulations
./brute-force-simulation.sh
./lfi-simulation.sh
./ransomware-simulation.ps1
```

### 6. Create Forensic Artifacts
```bash
# Windows artifacts (run as Administrator)
cd MAQ-1 && ./create-forensic-artifacts.ps1

# Linux artifacts (run as root)
cd MAQ-3 && sudo ./create-forensic-artifacts.sh
```

### 7. Setup Additional SIEM Platforms
```bash
# Quick setup for different SIEM platforms
sudo ./siem-quick-setup.sh
```

## Environment Reset

For multiple training sessions, use the reset scripts to restore the environment to its initial state:

### Complete Environment Reset
```bash
./reset-environment.sh
```

### Individual Machine Reset
```bash
# Windows machine
cd MAQ-1 && ./reset-windows.ps1

# Laravel machine
cd MAQ-2 && sudo ./reset-laravel.sh

# Linux machine
cd MAQ-3 && sudo ./reset-linux.sh

# SIEM central
cd siem-central && sudo ./reset-siem.sh

# Attack simulations
cd attack-simulations && ./reset-attacks.sh
```

For detailed information about reset scripts, see [README-reset-scripts.md](README-reset-scripts.md).

## Components

### MAQ-1 (Windows Active Directory)
- Windows Server with Active Directory
- Vulnerable configurations
- Ransomware simulation capabilities
- SIEM log forwarding
- **Forensic Artifacts**: Memory dumps, .evtx files, registry hives

**Default Credentials:**
- Administrator: `admin/admin123`
- User: `user/password123`

### MAQ-2 (Laravel Web Application)
- Laravel application with vulnerabilities
- API endpoints with authentication bypass
- LFI vulnerabilities
- SIEM integration

**Default Credentials:**
- Admin: `admin/admin123`
- User: `user/password123`

### MAQ-3 (Linux Infrastructure)
- Linux server with misconfigurations
- SSH, FTP, and Samba services
- Weak password policies
- Security monitoring
- **Forensic Artifacts**: Memory dumps, system logs, disk images

**Default Credentials:**
- Root: `root/root123`
- User: `user/password123`

### SIEM Central
- Graylog for log aggregation
- Elasticsearch for data storage
- Wazuh for security monitoring
- Logstash for data processing

**Access:**
- Graylog: http://192.168.1.102:9000 (admin/admin123)
- Wazuh: http://192.168.1.102:5601 (admin/admin123)

## Training Scenarios

### Incident Response Scenarios
See [scenarios.md](scenarios.md) for detailed incident response scenarios:

- **Beginner**: Brute force detection, simple malware alerts
- **Intermediate**: Advanced persistent threats, data exfiltration
- **Advanced**: Sophisticated attacks, incident coordination

### Attack Simulations
Automated attack simulations for training:

- **Brute Force**: SSH, FTP, and web application attacks
- **LFI**: Local File Inclusion vulnerabilities
- **Ransomware**: File encryption simulation

See [attack-simulations/README.md](attack-simulations/README.md) for details.

### Forensic Analysis
Comprehensive forensic artifacts for analysis exercises:

- **Memory Analysis**: Process dumps, kernel memory
- **Event Logs**: Windows .evtx files, Linux system logs
- **Disk Images**: Logical copies of important directories
- **Timeline Analysis**: File system timelines
- **Network Artifacts**: Connection logs, firewall rules

See [forensic-analysis-guide.md](forensic-analysis-guide.md) for detailed analysis instructions.

### SIEM Integrations
Multiple SIEM platform integrations for comprehensive training:

- **Wazuh**: Open-source SIEM with agent-based monitoring
- **ELK Stack**: Elasticsearch, Logstash, Kibana for big data analysis
- **Splunk**: Enterprise SIEM with advanced analytics
- **Graylog**: Open-source log management platform
- **QRadar**: IBM enterprise SIEM with AI capabilities

See [siem-integration-examples.md](siem-integration-examples.md) for detailed integration instructions and [siem-comparison-guide.md](siem-comparison-guide.md) for platform comparisons.

## Documentation

- [README-reset-scripts.md](README-reset-scripts.md) - Reset scripts documentation
- [scenarios.md](scenarios.md) - Incident response scenarios
- [attack-simulations/README.md](attack-simulations/README.md) - Attack simulation guide
- [siem-integration-guide.md](siem-integration-guide.md) - SIEM setup and configuration
- [siem-integration-examples.md](siem-integration-examples.md) - SIEM integration examples
- [siem-comparison-guide.md](siem-comparison-guide.md) - SIEM platform comparison
- [forensic-analysis-guide.md](forensic-analysis-guide.md) - Forensic analysis guide
- [default-credentials.md](default-credentials.md) - Default credentials for all machines

## Network Configuration

### IP Addresses
- **SIEM Central**: 192.168.1.102
- **MAQ-1 (Windows)**: 192.168.1.10
- **MAQ-2 (Laravel)**: 192.168.1.20
- **MAQ-3 (Linux)**: 192.168.1.30

### Ports
- **Graylog**: 9000 (Web), 12201 (Syslog)
- **Wazuh**: 5601 (Web), 1514 (Agent)
- **Elasticsearch**: 9200 (HTTP), 9300 (Transport)
- **Kibana**: 5601 (Web)
- **Splunk**: 8000 (Web), 8089 (Management)
- **SSH**: 22
- **FTP**: 21
- **Samba**: 445, 139

## Forensic Artifacts

### Windows Artifacts (MAQ-1)
- **Memory Dumps**: Process memory dumps (.dmp files)
- **Event Logs**: Security, Application, System (.evtx files)
- **Registry Hives**: SYSTEM, SOFTWARE, SAM, SECURITY
- **Network Artifacts**: ARP tables, routing tables, connections
- **Timeline**: File system timeline data

### Linux Artifacts (MAQ-3)
- **Memory Dumps**: Kernel and process memory dumps (.raw files)
- **System Logs**: Authentication, system, service logs
- **Audit Logs**: Audit trail information
- **Network Artifacts**: Network connections, firewall rules
- **Process Information**: Process lists, open files, loaded modules
- **Timeline**: File system timeline data

### Analysis Tools
- **Memory Analysis**: Volatility, Rekall
- **Event Logs**: Event Viewer, Log Parser
- **Registry**: Registry Explorer, RegRipper
- **Timeline**: Plaso, log2timeline
- **Network**: Wireshark, NetworkMiner
- **File System**: The Sleuth Kit, Autopsy

## SIEM Platform Support

### Supported Platforms
- **Wazuh**: Open-source SIEM with comprehensive monitoring
- **ELK Stack**: Big data analytics and visualization
- **Splunk**: Enterprise-grade SIEM with advanced features
- **Graylog**: Open-source log management
- **QRadar**: IBM enterprise SIEM with AI capabilities

### Platform Features
- **Real-time Monitoring**: All platforms support real-time log analysis
- **Alert Management**: Customizable alerting and notification systems
- **Threat Intelligence**: Integration with threat intelligence feeds
- **Compliance**: Built-in compliance monitoring and reporting
- **Forensic Analysis**: Advanced search and correlation capabilities

### Quick Setup
```bash
# Setup any SIEM platform
sudo ./siem-quick-setup.sh

# Choose from menu:
# 1. Wazuh
# 2. ELK Stack
# 3. Graylog
# 4. Splunk
# 5. Multi-SIEM Environment
```

## Security Considerations

⚠️ **IMPORTANT**: This is a training environment with intentional vulnerabilities. Do not deploy in production environments.

### Safety Measures
- Isolated network environment
- No internet access for vulnerable machines
- Controlled attack simulations
- Reset capabilities for clean state
- Forensic artifacts for analysis training
- Multi-SIEM support for comprehensive monitoring

### Best Practices
- Use dedicated training network
- Regular environment resets
- Monitor for unauthorized access
- Backup important data before resets
- Maintain chain of custody for forensic artifacts
- Test SIEM integrations thoroughly

## Troubleshooting

### Common Issues

#### Docker Issues
```bash
# Check Docker status
sudo systemctl status docker

# Restart Docker
sudo systemctl restart docker
```

#### Network Issues
```bash
# Check network connectivity
ping 192.168.1.102

# Check Docker network
docker network ls
```

#### SIEM Issues
```bash
# Check SIEM containers
cd siem-central && docker-compose ps

# Check SIEM logs
docker-compose logs

# Test SIEM connectivity
./siem-tests/test-wazuh.sh
./siem-tests/test-elk.sh
./siem-tests/test-graylog.sh
```

#### Forensic Artifacts Issues
```bash
# Check artifact creation
ls -la MAQ-1/ForensicArtifacts/
ls -la MAQ-3/forensic-artifacts/

# Verify artifact integrity
md5sum MAQ-1/ForensicArtifacts/*.raw
md5sum MAQ-3/forensic-artifacts/*.raw
```

### Reset Environment
If the environment becomes unstable:

```bash
# Complete reset
./reset-environment.sh

# Restart services
cd siem-central && docker-compose up -d
./configure-all-syslog.sh
```

## Contributing

To contribute to Lab Vuln:

1. Follow security best practices
2. Test all changes in isolated environment
3. Update documentation
4. Include reset capabilities for new components
5. Add forensic artifacts for new machines
6. Support additional SIEM platforms

## License

This project is for educational purposes only. Use responsibly and only in controlled training environments.

## Support

For issues and questions:

1. Check the troubleshooting section
2. Review log files
3. Consult documentation
4. Use reset scripts if needed
5. Refer to forensic analysis guide for artifact analysis
6. Check SIEM integration guides for platform-specific issues

---

**Lab Vuln** - Comprehensive SOC Training Environment with Forensic Analysis and Multi-SIEM Capabilities 