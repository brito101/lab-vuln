#!/bin/bash
# Configure Laravel Log Forwarding to SIEM
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

print_status "CONFIGURING LARAVEL LOG FORWARDING TO SIEM"
echo "Lab Vuln - SIEM Integration"
echo "Version: 1.0"
echo "Date: $(date)"

echo ""
print_warning "Configuring Laravel log forwarding to SIEM..."
echo "SIEM IP: $SIEM_IP"
echo "SIEM Port: $SIEM_PORT"

read -p "Do you want to continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_warning "Configuration cancelled by user."
    exit 0
fi

# Configure rsyslog for Laravel logs
print_status "CONFIGURING RSYSLOG FOR LARAVEL LOGS"

# Install rsyslog if not present
if ! command -v rsyslogd &> /dev/null; then
    print_warning "Installing rsyslog..."
    apt-get update
    apt-get install -y rsyslog
fi

# Create rsyslog configuration for Laravel
print_status "Creating rsyslog configuration for Laravel..."

cat > /etc/rsyslog.d/30-laravel.conf << EOF
# Laravel log forwarding configuration
# Forward Laravel logs to SIEM

# Laravel application logs
:programname, contains, "laravel" @$SIEM_IP:$SIEM_PORT

# Nginx/Apache access logs
:programname, contains, "nginx" @$SIEM_IP:$SIEM_PORT
:programname, contains, "apache2" @$SIEM_IP:$SIEM_PORT

# PHP error logs
:programname, contains, "php" @$SIEM_IP:$SIEM_PORT

# MySQL logs
:programname, contains, "mysql" @$SIEM_IP:$SIEM_PORT

# System logs
*.* @$SIEM_IP:$SIEM_PORT
EOF

print_success "rsyslog configuration created"

# Configure Laravel logging
print_status "CONFIGURING LARAVEL LOGGING"

# Create Laravel log configuration
cat > /var/www/html/storage/logs/laravel-siem.conf << EOF
# Laravel SIEM logging configuration
# This file configures Laravel to send logs to SIEM

# Log level for SIEM
LOG_LEVEL=debug

# Log channels for SIEM
LOG_CHANNELS=stack,syslog

# Syslog configuration
SYSLOG_HOST=$SIEM_IP
SYSLOG_PORT=$SIEM_PORT
SYSLOG_PROTOCOL=udp
EOF

print_success "Laravel logging configured"

# Configure log rotation
print_status "CONFIGURING LOG ROTATION"

cat > /etc/logrotate.d/laravel << EOF
/var/www/html/storage/logs/*.log {
    daily
    missingok
    rotate 7
    compress
    delaycompress
    notifempty
    create 644 www-data www-data
    postrotate
        systemctl reload rsyslog
    endscript
}
EOF

print_success "Log rotation configured"

# Create log forwarding script
print_status "CREATING LOG FORWARDING SCRIPT"

cat > /usr/local/bin/laravel-log-forwarder.sh << 'EOF'
#!/bin/bash
# Laravel Log Forwarding Script
# Forwards Laravel logs to SIEM

SIEM_IP="192.168.1.100"
SIEM_PORT="1514"
LARAVEL_LOG_DIR="/var/www/html/storage/logs"

function send_log_to_siem() {
    local log_file="$1"
    local log_entry="$2"
    
    # Create syslog message
    local syslog_message="<134>$(date '+%b %d %H:%M:%S') $(hostname) laravel: $log_entry"
    
    # Send to SIEM
    echo "$syslog_message" | nc -u $SIEM_IP $SIEM_PORT 2>/dev/null
    
    # Log locally for debugging
    echo "$(date): Forwarded log entry to SIEM" >> /var/log/laravel-forwarder.log
}

# Monitor Laravel log files
echo "Starting Laravel log forwarding to SIEM..."
echo "SIEM IP: $SIEM_IP"
echo "SIEM Port: $SIEM_PORT"

# Monitor laravel.log file
tail -f "$LARAVEL_LOG_DIR/laravel.log" | while read line; do
    send_log_to_siem "laravel.log" "$line"
done
EOF

chmod +x /usr/local/bin/laravel-log-forwarder.sh
print_success "Log forwarding script created"

# Create systemd service for log forwarding
print_status "CREATING SYSTEMD SERVICE"

cat > /etc/systemd/system/laravel-log-forwarder.service << EOF
[Unit]
Description=Laravel Log Forwarder
After=network.target

[Service]
Type=simple
User=root
ExecStart=/usr/local/bin/laravel-log-forwarder.sh
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable laravel-log-forwarder.service
print_success "Systemd service created"

# Configure log monitoring
print_status "CONFIGURING LOG MONITORING"

# Create log monitoring script
cat > /usr/local/bin/monitor-laravel-logs.sh << 'EOF'
#!/bin/bash
# Laravel Log Monitoring Script
# Monitors Laravel logs for security events

LARAVEL_LOG_DIR="/var/www/html/storage/logs"
SIEM_IP="192.168.1.100"
SIEM_PORT="1514"

# Security event patterns
SECURITY_PATTERNS=(
    "SQL injection"
    "XSS"
    "CSRF"
    "LFI"
    "file upload"
    "authentication failed"
    "unauthorized access"
    "privilege escalation"
)

function check_security_events() {
    local log_file="$1"
    
    for pattern in "${SECURITY_PATTERNS[@]}"; do
        if grep -i "$pattern" "$log_file" > /dev/null; then
            local alert_message="SECURITY ALERT: $pattern detected in $log_file"
            echo "$alert_message" | nc -u $SIEM_IP $SIEM_PORT 2>/dev/null
            echo "$(date): $alert_message" >> /var/log/security-alerts.log
        fi
    done
}

# Monitor all Laravel log files
while true; do
    for log_file in "$LARAVEL_LOG_DIR"/*.log; do
        if [[ -f "$log_file" ]]; then
            check_security_events "$log_file"
        fi
    done
    sleep 30
done
EOF

chmod +x /usr/local/bin/monitor-laravel-logs.sh
print_success "Log monitoring script created"

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

# Restart rsyslog
print_status "RESTARTING RSYSLOG"

systemctl restart rsyslog
print_success "rsyslog restarted"

# Start log forwarding service
print_status "STARTING LOG FORWARDING SERVICE"

systemctl start laravel-log-forwarder.service
print_success "Log forwarding service started"

# Show summary
echo ""
print_status "SYSLOG CONFIGURATION SUMMARY"
print_success "rsyslog configured for Laravel"
print_success "Laravel logging configured"
print_success "Log rotation configured"
print_success "Log forwarding script created"
print_success "Systemd service created"
print_success "Log monitoring script created"
print_success "SIEM connectivity tested"
print_success "rsyslog restarted"
print_success "Log forwarding service started"

echo ""
print_status "CONFIGURATION DETAILS"
echo "SIEM IP: $SIEM_IP"
echo "SIEM Port: $SIEM_PORT"
echo "Log Forwarding Script: /usr/local/bin/laravel-log-forwarder.sh"
echo "Log Monitoring Script: /usr/local/bin/monitor-laravel-logs.sh"
echo "rsyslog Config: /etc/rsyslog.d/30-laravel.conf"
echo "Laravel Config: /var/www/html/storage/logs/laravel-siem.conf"

echo ""
print_status "NEXT STEPS"
echo "1. Start the SIEM central container"
echo "2. Configure inputs in Graylog"
echo "3. Monitor logs in SIEM interface"
echo "4. Check log forwarding status: systemctl status laravel-log-forwarder.service"

echo ""
print_success "LARAVEL LOG FORWARDING CONFIGURED SUCCESSFULLY!" 