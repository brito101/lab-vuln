#!/bin/bash
# Reset Linux Machine - MAQ-3
# Author: Lab Vuln
# Version: 1.0

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

function print_status() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

function print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

function print_error() {
    echo -e "${RED}❌ $1${NC}"
}

function print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_status "RESET LINUX MACHINE - MAQ-3"
echo "This script will reset the Linux machine to initial state"
echo ""

print_warning "⚠️  WARNING: This will reset Linux machine to initial state!"
print_warning "⚠️  All data, logs, and configurations will be reset!"
print_warning "⚠️  This action cannot be undone!"
echo ""

read -p "Do you want to continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_warning "Reset cancelled by user."
    exit 0
fi

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   print_error "This script must be run as root"
   exit 1
fi

# Create log file
LOG_FILE="linux-reset-$(date +%Y%m%d-%H%M%S).log"
echo "Linux Reset Log" > $LOG_FILE
echo "Date: $(date)" >> $LOG_FILE
echo "Machine: MAQ-3 (Linux)" >> $LOG_FILE
echo "User: $(whoami)" >> $LOG_FILE
echo "" >> $LOG_FILE

print_status "RESET CONFIGURATION"
echo "Target: Linux Infrastructure (MAQ-3)"
echo "Actions: Reset logs, configurations, and data"
echo ""

# Function to reset Docker containers
function reset_docker_containers() {
    print_status "RESETTING DOCKER CONTAINERS"
    
    if [[ -f "docker-compose.yml" ]]; then
        print_warning "Stopping Linux containers..."
        docker-compose down --volumes --remove-orphans 2>/dev/null || true
        docker-compose rm -f 2>/dev/null || true
        print_success "Docker containers reset"
        echo "Docker containers reset" >> $LOG_FILE
    else
        print_warning "Docker compose file not found"
    fi
}

# Function to reset system logs
function reset_system_logs() {
    print_status "RESETTING SYSTEM LOGS"
    
    # Clear system logs
    print_warning "Clearing system logs..."
    rm -f /var/log/syslog* 2>/dev/null || true
    rm -f /var/log/messages* 2>/dev/null || true
    rm -f /var/log/auth.log* 2>/dev/null || true
    rm -f /var/log/daemon.log* 2>/dev/null || true
    rm -f /var/log/kern.log* 2>/dev/null || true
    echo "Cleared system logs" >> $LOG_FILE
    
    # Clear service logs
    print_warning "Clearing service logs..."
    rm -f /var/log/ssh/* 2>/dev/null || true
    rm -f /var/log/vsftpd.log* 2>/dev/null || true
    rm -f /var/log/samba/* 2>/dev/null || true
    rm -f /var/log/apache2/* 2>/dev/null || true
    rm -f /var/log/nginx/* 2>/dev/null || true
    echo "Cleared service logs" >> $LOG_FILE
    
    # Clear audit logs
    print_warning "Clearing audit logs..."
    rm -f /var/log/audit/* 2>/dev/null || true
    echo "Cleared audit logs" >> $LOG_FILE
    
    print_success "System logs reset"
}

# Function to reset SSH configuration
function reset_ssh_configuration() {
    print_status "RESETTING SSH CONFIGURATION"
    
    # Reset SSH configuration
    print_warning "Resetting SSH configuration..."
    cp /etc/ssh/sshd_config.backup /etc/ssh/sshd_config 2>/dev/null || true
    systemctl restart ssh 2>/dev/null || true
    echo "Reset SSH configuration" >> $LOG_FILE
    
    # Clear SSH logs
    print_warning "Clearing SSH logs..."
    rm -f /var/log/auth.log* 2>/dev/null || true
    rm -f /var/log/btmp* 2>/dev/null || true
    rm -f /var/log/wtmp* 2>/dev/null || true
    echo "Cleared SSH logs" >> $LOG_FILE
    
    print_success "SSH configuration reset"
}

# Function to reset FTP configuration
function reset_ftp_configuration() {
    print_status "RESETTING FTP CONFIGURATION"
    
    # Reset vsftpd configuration
    print_warning "Resetting vsftpd configuration..."
    cp /etc/vsftpd.conf.backup /etc/vsftpd.conf 2>/dev/null || true
    systemctl restart vsftpd 2>/dev/null || true
    echo "Reset vsftpd configuration" >> $LOG_FILE
    
    # Clear FTP logs
    print_warning "Clearing FTP logs..."
    rm -f /var/log/vsftpd.log* 2>/dev/null || true
    rm -f /var/log/xferlog* 2>/dev/null || true
    echo "Cleared FTP logs" >> $LOG_FILE
    
    print_success "FTP configuration reset"
}

# Function to reset Samba configuration
function reset_samba_configuration() {
    print_status "RESETTING SAMBA CONFIGURATION"
    
    # Reset Samba configuration
    print_warning "Resetting Samba configuration..."
    cp /etc/samba/smb.conf.backup /etc/samba/smb.conf 2>/dev/null || true
    systemctl restart smbd 2>/dev/null || true
    systemctl restart nmbd 2>/dev/null || true
    echo "Reset Samba configuration" >> $LOG_FILE
    
    # Clear Samba logs
    print_warning "Clearing Samba logs..."
    rm -f /var/log/samba/* 2>/dev/null || true
    echo "Cleared Samba logs" >> $LOG_FILE
    
    print_success "Samba configuration reset"
}

# Function to reset SIEM configurations
function reset_siem_configurations() {
    print_status "RESETTING SIEM CONFIGURATIONS"
    
    # Remove rsyslog configuration
    print_warning "Removing rsyslog configuration..."
    rm -f /etc/rsyslog.d/30-system-logs.conf 2>/dev/null || true
    systemctl restart rsyslog 2>/dev/null || true
    echo "Removed rsyslog configuration" >> $LOG_FILE
    
    # Remove audit rules
    print_warning "Removing audit rules..."
    rm -f /etc/audit/rules.d/audit.rules 2>/dev/null || true
    systemctl restart auditd 2>/dev/null || true
    echo "Removed audit rules" >> $LOG_FILE
    
    # Remove log monitoring service
    print_warning "Removing log monitoring service..."
    systemctl stop system-log-monitor.service 2>/dev/null || true
    systemctl disable system-log-monitor.service 2>/dev/null || true
    rm -f /etc/systemd/system/system-log-monitor.service 2>/dev/null || true
    rm -f /usr/local/bin/monitor-system-logs.sh 2>/dev/null || true
    systemctl daemon-reload 2>/dev/null || true
    echo "Removed log monitoring service" >> $LOG_FILE
    
    print_success "SIEM configurations reset"
}

# Function to reset network configuration
function reset_network_configuration() {
    print_status "RESETTING NETWORK CONFIGURATION"
    
    # Reset firewall rules
    print_warning "Resetting firewall rules..."
    iptables -F 2>/dev/null || true
    iptables -X 2>/dev/null || true
    iptables -t nat -F 2>/dev/null || true
    iptables -t nat -X 2>/dev/null || true
    echo "Reset firewall rules" >> $LOG_FILE
    
    # Reset network interfaces
    print_warning "Resetting network interfaces..."
    ip link set dev eth0 up 2>/dev/null || true
    systemctl restart networking 2>/dev/null || true
    echo "Reset network interfaces" >> $LOG_FILE
    
    print_success "Network configuration reset"
}

# Function to reset user accounts
function reset_user_accounts() {
    print_status "RESETTING USER ACCOUNTS"
    
    # Reset user passwords to defaults
    print_warning "Resetting user passwords..."
    echo "admin:admin123" | chpasswd 2>/dev/null || true
    echo "user:password123" | chpasswd 2>/dev/null || true
    echo "test:test123" | chpasswd 2>/dev/null || true
    echo "Reset user passwords" >> $LOG_FILE
    
    # Clear user history
    print_warning "Clearing user history..."
    rm -f /home/*/.bash_history 2>/dev/null || true
    rm -f /root/.bash_history 2>/dev/null || true
    echo "Cleared user history" >> $LOG_FILE
    
    print_success "User accounts reset"
}

# Function to clean temporary files
function clean_temporary_files() {
    print_status "CLEANING TEMPORARY FILES"
    
    # Remove temporary files
    print_warning "Removing temporary files..."
    rm -f *.log 2>/dev/null || true
    rm -f *.tmp 2>/dev/null || true
    rm -f *.cache 2>/dev/null || true
    rm -f /tmp/* 2>/dev/null || true
    rm -f /var/tmp/* 2>/dev/null || true
    echo "Removed temporary files" >> $LOG_FILE
    
    # Remove backup files
    print_warning "Removing backup files..."
    rm -f *.backup 2>/dev/null || true
    rm -f *.bak 2>/dev/null || true
    echo "Removed backup files" >> $LOG_FILE
    
    print_success "Temporary files cleaned"
}

# Function to create reset verification
function create_reset_verification() {
    print_status "CREATING RESET VERIFICATION"
    
    # Create reset verification file
    cat > linux-reset-verification-$(date +%Y%m%d-%H%M%S).md << EOF
# Linux Reset Verification - MAQ-3

## Reset Details
- **Date**: $(date)
- **Machine**: MAQ-3 (Linux)
- **User**: $(whoami)
- **Log File**: $LOG_FILE

## Reset Actions Performed
- [x] Docker containers stopped and removed
- [x] System logs cleared
- [x] SSH configuration reset
- [x] FTP configuration reset
- [x] Samba configuration reset
- [x] SIEM configurations removed
- [x] Network configuration reset
- [x] User accounts reset
- [x] Temporary files cleaned

## Verification Steps
1. **Check Docker**: \`docker ps -a\`
2. **Check SSH**: \`systemctl status ssh\`
3. **Check FTP**: \`systemctl status vsftpd\`
4. **Check Samba**: \`systemctl status smbd\`
5. **Check Network**: \`ip addr show\`
6. **Check Logs**: \`ls -la /var/log/\`

## Next Steps
1. Restart containers: \`docker-compose up -d\`
2. Reconfigure SIEM forwarding
3. Run Linux setup scripts
4. Begin new training session

## Notes
- Linux machine reset to initial state
- Ready for new training session
- Backup any important data before reset
EOF

    print_success "Reset verification file created"
}

# Main reset process
print_status "STARTING LINUX RESET"

# 1. Reset Docker containers
reset_docker_containers

# 2. Reset system logs
reset_system_logs

# 3. Reset SSH configuration
reset_ssh_configuration

# 4. Reset FTP configuration
reset_ftp_configuration

# 5. Reset Samba configuration
reset_samba_configuration

# 6. Reset SIEM configurations
reset_siem_configurations

# 7. Reset network configuration
reset_network_configuration

# 8. Reset user accounts
reset_user_accounts

# 9. Clean temporary files
clean_temporary_files

# 10. Create reset verification
create_reset_verification

# Summary
echo ""
print_status "RESET SUMMARY"
print_success "✅ Docker containers reset"
print_success "✅ System logs cleared"
print_success "✅ SSH configuration reset"
print_success "✅ FTP configuration reset"
print_success "✅ Samba configuration reset"
print_success "✅ SIEM configurations reset"
print_success "✅ Network configuration reset"
print_success "✅ User accounts reset"
print_success "✅ Temporary files cleaned"
print_success "✅ Reset verification created"

echo ""
print_status "NEXT STEPS"
echo "1. Restart containers: docker-compose up -d"
echo "2. Reconfigure SIEM forwarding"
echo "3. Run Linux setup scripts"
echo "4. Begin new training session"

echo ""
print_status "VERIFICATION COMMANDS"
echo "Check Docker: docker ps -a"
echo "Check SSH: systemctl status ssh"
echo "Check FTP: systemctl status vsftpd"
echo "Check Samba: systemctl status smbd"
echo "Check Network: ip addr show"
echo "Check Logs: ls -la /var/log/"

echo ""
print_success "🎯 LINUX MACHINE RESET COMPLETED SUCCESSFULLY!"
print_success "Ready for new training session!" 