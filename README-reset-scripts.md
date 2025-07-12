# Reset Scripts Documentation - Lab Vuln

## Overview

This document describes the reset scripts available for the Lab Vuln environment. These scripts allow you to reset each machine and component to its initial state, making it ready for new training sessions.

## Available Reset Scripts

### 1. Main Reset Script
- **File**: `reset-environment.sh`
- **Purpose**: Reset the entire environment to initial state
- **Scope**: All machines and components

### 2. Machine-Specific Reset Scripts

#### Windows Machine (MAQ-1)
- **File**: `MAQ-1/reset-windows.ps1`
- **Purpose**: Reset Windows Active Directory machine
- **Requirements**: Administrator privileges

#### Laravel Machine (MAQ-2)
- **File**: `MAQ-2/reset-laravel.sh`
- **Purpose**: Reset Laravel web application machine
- **Requirements**: Root privileges

#### Linux Machine (MAQ-3)
- **File**: `MAQ-3/reset-linux.sh`
- **Purpose**: Reset Linux infrastructure machine
- **Requirements**: Root privileges

#### SIEM Central
- **File**: `siem-central/reset-siem.sh`
- **Purpose**: Reset SIEM central environment
- **Requirements**: Root privileges

#### Attack Simulations
- **File**: `attack-simulations/reset-attacks.sh`
- **Purpose**: Reset attack simulation logs and data
- **Requirements**: Standard user privileges

## Usage Instructions

### Complete Environment Reset

```bash
# Reset entire environment
./reset-environment.sh
```

### Individual Machine Reset

```bash
# Reset Windows machine (run as Administrator)
cd MAQ-1
./reset-windows.ps1

# Reset Laravel machine (run as root)
cd MAQ-2
sudo ./reset-laravel.sh

# Reset Linux machine (run as root)
cd MAQ-3
sudo ./reset-linux.sh

# Reset SIEM central (run as root)
cd siem-central
sudo ./reset-siem.sh

# Reset attack simulations
cd attack-simulations
./reset-attacks.sh
```

## What Each Script Resets

### Main Reset Script (`reset-environment.sh`)
- Docker containers and volumes
- SIEM data and configurations
- Attack simulation logs
- Machine-specific data
- Configuration files
- Network configurations
- Temporary files

### Windows Reset (`reset-windows.ps1`)
- Windows Event Logs
- Active Directory configurations
- SIEM forwarding configurations
- Ransomware simulation data
- Network configurations
- System services
- Temporary files

### Laravel Reset (`reset-laravel.sh`)
- Docker containers
- Laravel application data
- Database data
- Web server configurations
- SIEM configurations
- PHP configurations
- Temporary files

### Linux Reset (`reset-linux.sh`)
- Docker containers
- System logs
- SSH configurations
- FTP configurations
- Samba configurations
- SIEM configurations
- Network configurations
- User accounts
- Temporary files

### SIEM Reset (`reset-siem.sh`)
- SIEM containers
- SIEM volumes
- SIEM configurations
- SIEM logs
- Network configurations
- System services
- Temporary files

### Attack Simulations Reset (`reset-attacks.sh`)
- Brute force simulation logs
- LFI simulation logs
- Ransomware simulation logs
- General attack logs
- SIEM detection logs
- Incident response logs
- Forensic artifacts
- Temporary files

## Safety Features

### Confirmation Prompts
All scripts include confirmation prompts to prevent accidental execution:

```
⚠️  WARNING: This will reset [component] to initial state!
⚠️  All data, logs, and configurations will be reset!
⚠️  This action cannot be undone!

Do you want to continue? (y/N):
```

### Logging
Each script creates detailed logs of all actions performed:

- Log files are created with timestamps
- All actions are recorded
- Error messages are captured
- Verification files are generated

### Verification Files
After each reset, a verification file is created with:

- Reset details (date, user, machine)
- List of actions performed
- Verification steps
- Next steps for setup
- Important notes

## Prerequisites

### System Requirements
- Docker and Docker Compose installed
- Root/Administrator privileges for most scripts
- PowerShell for Windows scripts
- Bash for Linux scripts

### Network Requirements
- Internet connection for Docker image pulls
- Network access to SIEM central (192.168.1.102)

## Post-Reset Setup

After running reset scripts, follow these steps to restore functionality:

### 1. Start SIEM Central
```bash
cd siem-central
docker-compose up -d
./configure-graylog.sh
```

### 2. Configure Machines
```bash
# Configure all machines for SIEM forwarding
./configure-all-syslog.sh
```

### 3. Verify Setup
```bash
# Verify SIEM configuration
./verify-siem-config.sh
```

### 4. Run Attack Simulations
```bash
cd attack-simulations
./brute-force-simulation.sh
./lfi-simulation.sh
./ransomware-simulation.ps1
```

## Troubleshooting

### Common Issues

#### Permission Denied
```bash
# Make scripts executable
chmod +x *.sh
chmod +x *.ps1
```

#### Docker Not Running
```bash
# Start Docker service
sudo systemctl start docker
```

#### Network Issues
```bash
# Check network connectivity
ping 192.168.1.102
```

### Reset Verification

After each reset, verify the environment:

```bash
# Check Docker containers
docker ps -a

# Check SIEM status
cd siem-central && docker-compose ps

# Check machine status
cd MAQ-X && docker-compose ps

# Check log files
find . -name "*.log" -type f
```

## Best Practices

### Before Reset
1. **Backup Important Data**: Save any important logs or configurations
2. **Stop All Services**: Ensure all containers and services are stopped
3. **Check Disk Space**: Ensure sufficient space for reset operations
4. **Notify Users**: Inform all users about the reset

### During Reset
1. **Monitor Progress**: Watch the script output for any errors
2. **Check Logs**: Review the generated log files
3. **Verify Actions**: Confirm all expected actions were performed

### After Reset
1. **Verify Reset**: Run verification commands
2. **Restore Services**: Start necessary services
3. **Test Functionality**: Ensure everything works correctly
4. **Document Changes**: Update any relevant documentation

## Automation

### Batch Reset Script
For multiple environments, you can create a batch script:

```bash
#!/bin/bash
# Batch reset script

echo "Starting batch reset..."

# Reset all components
./reset-environment.sh
cd MAQ-1 && ./reset-windows.ps1
cd ../MAQ-2 && sudo ./reset-laravel.sh
cd ../MAQ-3 && sudo ./reset-linux.sh
cd ../siem-central && sudo ./reset-siem.sh
cd ../attack-simulations && ./reset-attacks.sh

echo "Batch reset completed!"
```

### Scheduled Reset
For regular resets, you can schedule scripts using cron:

```bash
# Add to crontab for weekly reset
0 2 * * 0 /path/to/reset-environment.sh
```

## Security Considerations

### Data Protection
- Reset scripts do not permanently delete data
- Use secure deletion tools for sensitive data
- Consider encryption for backup files

### Access Control
- Limit script execution to authorized users
- Use sudo/Administrator privileges appropriately
- Monitor script execution logs

### Network Security
- Ensure network isolation during reset
- Verify firewall rules after reset
- Check for any unauthorized access attempts

## Support

For issues with reset scripts:

1. Check the log files generated by the scripts
2. Review the verification files for details
3. Consult the main README.md for environment setup
4. Check the troubleshooting section above

## Version History

- **v1.0**: Initial release with basic reset functionality
- All scripts include comprehensive logging and verification
- Support for all Lab Vuln components
- Safety features and confirmation prompts 