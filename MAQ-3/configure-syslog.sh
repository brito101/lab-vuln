#!/bin/bash
# Configure Linux Log Forwarding to SIEM
# Author: Lab Vuln
# Version: 1.0

# Configuration
SIEM_IP="192.168.1.100"  # Change to your SIEM IP
SIEM_PORT="1514"

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

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   print_error "This script must be run as root"
   exit 1
fi

print_status "CONFIGURING LINUX LOG FORWARDING TO SIEM"
echo "Lab Vuln - SIEM Integration"
echo "Version: 1.0"
echo "Date: $(date)"

echo ""
print_warning "Configuring Linux log forwarding to SIEM..."
echo "SIEM IP: $SIEM_IP"
echo "SIEM Port: $SIEM_PORT"

read -p "Do you want to continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_warning "Configuration cancelled by user."
    exit 0
fi

# Install required packages
print_status "INSTALLING REQUIRED PACKAGES"

# Update package list
apt-get update

# Install rsyslog and netcat
apt-get install -y rsyslog netcat-openbsd

print_success "Required packages installed"

# Configure rsyslog for system logs
print_status "CONFIGURING RSYSLOG FOR SYSTEM LOGS"

# Create rsyslog configuration for system logs
cat > /etc/rsyslog.d/30-system-logs.conf << EOF
# System log forwarding configuration
# Forward system logs to SIEM

# Authentication logs
auth,authpriv.* @$SIEM_IP:$SIEM_PORT

# SSH logs
:programname, contains, "sshd" @$SIEM_IP:$SIEM_PORT

# FTP logs
:programname, contains, "vsftpd" @$SIEM_IP:$SIEM_PORT
:programname, contains, "proftpd" @$SIEM_IP:$SIEM_PORT

# Samba logs
:programname, contains, "smbd" @$SIEM_IP:$SIEM_PORT
:programname, contains, "nmbd" @$SIEM_IP:$SIEM_PORT

# System messages
*.info @$SIEM_IP:$SIEM_PORT

# Kernel messages
kern.* @$SIEM_IP:$SIEM_PORT

# Mail logs
mail.* @$SIEM_IP:$SIEM_PORT

# Cron logs
cron.* @$SIEM_IP:$SIEM_PORT

# All logs (fallback)
*.* @$SIEM_IP:$SIEM_PORT
EOF

print_success "rsyslog configuration created"

# Configure audit logging
print_status "CONFIGURING AUDIT LOGGING"

# Install auditd if not present
if ! command -v auditd &> /dev/null; then
    apt-get install -y auditd
fi

# Configure audit rules
cat > /etc/audit/rules.d/audit.rules << EOF
# Audit rules for security monitoring
# File access monitoring
-w /etc/passwd -p wa -k identity
-w /etc/group -p wa -k identity
-w /etc/shadow -p wa -k identity
-w /etc/sudoers -p wa -k identity

# Process monitoring
-w /bin/su -p x -k privilege-escalation
-w /usr/bin/sudo -p x -k privilege-escalation

# Network monitoring
-w /etc/hosts -p wa -k network-config
-w /etc/network/ -p wa -k network-config

# Login monitoring
-w /var/log/faillog -p wa -k logins
-w /var/log/lastlog -p wa -k logins
-w /var/log/tallylog -p wa -k logins

# System configuration monitoring
-w /etc/ssh/sshd_config -p wa -k ssh-config
-w /etc/ssh/ssh_config -p wa -k ssh-config

# Web server monitoring
-w /var/www/ -p wa -k web-content
-w /etc/apache2/ -p wa -k web-config
-w /etc/nginx/ -p wa -k web-config

# Database monitoring
-w /etc/mysql/ -p wa -k database-config
-w /var/lib/mysql/ -p wa -k database-data

# Samba monitoring
-w /etc/samba/ -p wa -k samba-config
-w /var/log/samba/ -p wa -k samba-logs
EOF

print_success "Audit rules configured"

# Configure log monitoring
print_status "CONFIGURING LOG MONITORING"

# Create log monitoring script
cat > /usr/local/bin/monitor-system-logs.sh << 'EOF'
#!/bin/bash
# System Log Monitoring Script
# Monitors system logs for security events

SIEM_IP="192.168.1.100"
SIEM_PORT="1514"

# Security event patterns
SECURITY_PATTERNS=(
    "authentication failure"
    "failed login"
    "invalid user"
    "unauthorized access"
    "privilege escalation"
    "suspicious activity"
    "brute force"
    "port scan"
    "malware"
    "root login"
)

# Log files to monitor
LOG_FILES=(
    "/var/log/auth.log"
    "/var/log/syslog"
    "/var/log/secure"
    "/var/log/messages"
    "/var/log/faillog"
    "/var/log/btmp"
    "/var/log/wtmp"
)

function send_alert_to_siem() {
    local alert_message="$1"
    local severity="$2"
    
    # Create syslog message with appropriate facility and severity
    local priority
    case $severity in
        "emergency") priority="<0>" ;;
        "alert") priority="<1>" ;;
        "critical") priority="<2>" ;;
        "error") priority="<3>" ;;
        "warning") priority="<4>" ;;
        "notice") priority="<5>" ;;
        "info") priority="<6>" ;;
        "debug") priority="<7>" ;;
        *) priority="<6>" ;;
    esac
    
    local syslog_message="${priority}$(date '+%b %d %H:%M:%S') $(hostname) security-monitor: $alert_message"
    
    # Send to SIEM
    echo "$syslog_message" | nc -u $SIEM_IP $SIEM_PORT 2>/dev/null
    
    # Log locally for debugging
    echo "$(date): $alert_message" >> /var/log/security-monitor.log
}

function check_security_events() {
    local log_file="$1"
    
    if [[ ! -f "$log_file" ]]; then
        return
    fi
    
    for pattern in "${SECURITY_PATTERNS[@]}"; do
        if grep -i "$pattern" "$log_file" > /dev/null; then
            local alert_message="SECURITY ALERT: $pattern detected in $log_file"
            send_alert_to_siem "$alert_message" "warning"
        fi
    done
}

function monitor_failed_logins() {
    # Monitor failed login attempts
    local failed_count=$(grep -c "authentication failure\|failed login\|invalid user" /var/log/auth.log 2>/dev/null || echo "0")
    
    if [[ $failed_count -gt 10 ]]; then
        local alert_message="HIGH ALERT: $failed_count failed login attempts detected"
        send_alert_to_siem "$alert_message" "alert"
    fi
}

function monitor_suspicious_processes() {
    # Monitor for suspicious processes
    local suspicious_processes=(
        "nc "
        "netcat"
        "nmap"
        "masscan"
        "hydra"
        "john"
        "hashcat"
        "metasploit"
        "msfconsole"
    )
    
    for process in "${suspicious_processes[@]}"; do
        if pgrep -f "$process" > /dev/null; then
            local alert_message="SUSPICIOUS PROCESS: $process is running"
            send_alert_to_siem "$alert_message" "warning"
        fi
    done
}

function monitor_network_connections() {
    # Monitor for unusual network connections
    local established_connections=$(netstat -tuln | grep -c "ESTABLISHED" 2>/dev/null || echo "0")
    
    if [[ $established_connections -gt 100 ]]; then
        local alert_message="NETWORK ALERT: High number of connections ($established_connections)"
        send_alert_to_siem "$alert_message" "notice"
    fi
}

# Main monitoring loop
echo "Starting system log monitoring..."
echo "SIEM IP: $SIEM_IP"
echo "SIEM Port: $SIEM_PORT"

while true; do
    # Check security events in log files
    for log_file in "${LOG_FILES[@]}"; do
        check_security_events "$log_file"
    done
    
    # Monitor failed logins
    monitor_failed_logins
    
    # Monitor suspicious processes
    monitor_suspicious_processes
    
    # Monitor network connections
    monitor_network_connections
    
    # Wait before next check
    sleep 60
done
EOF

chmod +x /usr/local/bin/monitor-system-logs.sh
print_success "Log monitoring script created"

# Create systemd service for log monitoring
print_status "CREATING SYSTEMD SERVICE"

cat > /etc/systemd/system/system-log-monitor.service << EOF
[Unit]
Description=System Log Monitor
After=network.target

[Service]
Type=simple
User=root
ExecStart=/usr/local/bin/monitor-system-logs.sh
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable system-log-monitor.service
print_success "Systemd service created"

# Configure log forwarding for specific services
print_status "CONFIGURING SERVICE-SPECIFIC LOGGING"

# SSH logging
if command -v sshd &> /dev/null; then
    echo "LogLevel VERBOSE" >> /etc/ssh/sshd_config
    echo "SyslogFacility AUTH" >> /etc/ssh/sshd_config
    print_success "SSH logging configured"
fi

# FTP logging
if command -v vsftpd &> /dev/null; then
    echo "log_ftp_protocol=YES" >> /etc/vsftpd.conf
    echo "xferlog_enable=YES" >> /etc/vsftpd.conf
    print_success "FTP logging configured"
fi

# Samba logging
if command -v smbd &> /dev/null; then
    echo "log level = 2" >> /etc/samba/smb.conf
    echo "log file = /var/log/samba/log.%m" >> /etc/samba/smb.conf
    print_success "Samba logging configured"
fi

# Web server logging
if command -v apache2 &> /dev/null; then
    echo "LogLevel warn" >> /etc/apache2/apache2.conf
    print_success "Apache logging configured"
fi

if command -v nginx &> /dev/null; then
    echo "error_log /var/log/nginx/error.log warn;" >> /etc/nginx/nginx.conf
    print_success "Nginx logging configured"
fi

# Test SIEM connectivity
print_status "TESTING SIEM CONNECTIVITY"

# Test basic connectivity
if ping -c 1 $SIEM_IP > /dev/null 2>&1; then
    print_success "Connectivity to SIEM OK"
else
    print_error "Cannot reach SIEM at $SIEM_IP"
fi

# Test port connectivity
if nc -z $SIEM_IP $SIEM_PORT 2>/dev/null; then
    print_success "Port $SIEM_PORT is accessible"
else
    print_error "Port $SIEM_PORT is not accessible"
fi

# Restart services
print_status "RESTARTING SERVICES"

# Restart rsyslog
systemctl restart rsyslog
print_success "rsyslog restarted"

# Restart auditd
systemctl restart auditd
print_success "auditd restarted"

# Start log monitoring service
systemctl start system-log-monitor.service
print_success "Log monitoring service started"

# Show summary
echo ""
print_status "SYSLOG CONFIGURATION SUMMARY"
print_success "rsyslog configured for system logs"
print_success "Audit logging configured"
print_success "Log monitoring script created"
print_success "Systemd service created"
print_success "Service-specific logging configured"
print_success "SIEM connectivity tested"
print_success "Services restarted"
print_success "Log monitoring service started"

echo ""
print_status "CONFIGURATION DETAILS"
echo "SIEM IP: $SIEM_IP"
echo "SIEM Port: $SIEM_PORT"
echo "Log Monitoring Script: /usr/local/bin/monitor-system-logs.sh"
echo "rsyslog Config: /etc/rsyslog.d/30-system-logs.conf"
echo "Audit Rules: /etc/audit/rules.d/audit.rules"

echo ""
print_status "MONITORED SERVICES"
echo "✅ SSH authentication and access"
echo "✅ FTP file transfers"
echo "✅ Samba file sharing"
echo "✅ Web server access"
echo "✅ System authentication"
echo "✅ Process creation"
echo "✅ File access"
echo "✅ Network connections"

echo ""
print_status "NEXT STEPS"
echo "1. Start the SIEM central container"
echo "2. Configure inputs in Graylog"
echo "3. Monitor logs in SIEM interface"
echo "4. Check log monitoring status: systemctl status system-log-monitor.service"

echo ""
print_success "LINUX LOG FORWARDING CONFIGURED SUCCESSFULLY!" 