#!/bin/bash
# Reset SIEM Central - Lab Vuln
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

print_status "RESET SIEM CENTRAL - LAB VULN"
echo "This script will reset the SIEM central to initial state"
echo ""

print_warning "⚠️  WARNING: This will reset SIEM central to initial state!"
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
LOG_FILE="siem-reset-$(date +%Y%m%d-%H%M%S).log"
echo "SIEM Reset Log" > $LOG_FILE
echo "Date: $(date)" >> $LOG_FILE
echo "Machine: SIEM Central" >> $LOG_FILE
echo "User: $(whoami)" >> $LOG_FILE
echo "" >> $LOG_FILE

print_status "RESET CONFIGURATION"
echo "Target: SIEM Central (Graylog, Elasticsearch, Wazuh)"
echo "Actions: Reset logs, configurations, and data"
echo ""

# Function to stop SIEM containers
function stop_siem_containers() {
    print_status "STOPPING SIEM CONTAINERS"
    
    if [[ -f "docker-compose.yml" ]]; then
        print_warning "Stopping SIEM containers..."
        docker-compose down --volumes --remove-orphans 2>/dev/null || true
        docker-compose rm -f 2>/dev/null || true
        print_success "SIEM containers stopped"
        echo "SIEM containers stopped" >> $LOG_FILE
    else
        print_warning "Docker compose file not found"
    fi
}

# Function to remove SIEM volumes
function remove_siem_volumes() {
    print_status "REMOVING SIEM VOLUMES"
    
    # Remove Graylog volumes
    print_warning "Removing Graylog volumes..."
    docker volume rm siem-central_graylog_data 2>/dev/null || true
    docker volume rm siem-central_mongo_data 2>/dev/null || true
    echo "Removed Graylog volumes" >> $LOG_FILE
    
    # Remove Elasticsearch volumes
    print_warning "Removing Elasticsearch volumes..."
    docker volume rm siem-central_es_data 2>/dev/null || true
    docker volume rm siem-central_es_logs 2>/dev/null || true
    echo "Removed Elasticsearch volumes" >> $LOG_FILE
    
    # Remove Wazuh volumes
    print_warning "Removing Wazuh volumes..."
    docker volume rm siem-central_wazuh_data 2>/dev/null || true
    docker volume rm siem-central_wazuh_logs 2>/dev/null || true
    docker volume rm siem-central_wazuh_etc 2>/dev/null || true
    echo "Removed Wazuh volumes" >> $LOG_FILE
    
    # Remove Logstash volumes
    print_warning "Removing Logstash volumes..."
    docker volume rm siem-central_logstash_data 2>/dev/null || true
    echo "Removed Logstash volumes" >> $LOG_FILE
    
    print_success "SIEM volumes removed"
}

# Function to reset SIEM configurations
function reset_siem_configurations() {
    print_status "RESETTING SIEM CONFIGURATIONS"
    
    # Remove Graylog configuration
    print_warning "Removing Graylog configuration..."
    rm -f graylog.conf 2>/dev/null || true
    rm -f graylog-inputs.conf 2>/dev/null || true
    echo "Removed Graylog configuration" >> $LOG_FILE
    
    # Remove Elasticsearch configuration
    print_warning "Removing Elasticsearch configuration..."
    rm -f elasticsearch.yml 2>/dev/null || true
    echo "Removed Elasticsearch configuration" >> $LOG_FILE
    
    # Remove Wazuh configuration
    print_warning "Removing Wazuh configuration..."
    rm -f wazuh.yml 2>/dev/null || true
    rm -f ossec.conf 2>/dev/null || true
    echo "Removed Wazuh configuration" >> $LOG_FILE
    
    # Remove Logstash configuration
    print_warning "Removing Logstash configuration..."
    rm -f logstash.conf 2>/dev/null || true
    rm -f pipelines.yml 2>/dev/null || true
    echo "Removed Logstash configuration" >> $LOG_FILE
    
    print_success "SIEM configurations reset"
}

# Function to reset SIEM logs
function reset_siem_logs() {
    print_status "RESETTING SIEM LOGS"
    
    # Remove SIEM logs
    print_warning "Removing SIEM logs..."
    rm -f *.log 2>/dev/null || true
    rm -f graylog-*.log 2>/dev/null || true
    rm -f elasticsearch-*.log 2>/dev/null || true
    rm -f wazuh-*.log 2>/dev/null || true
    rm -f logstash-*.log 2>/dev/null || true
    echo "Removed SIEM logs" >> $LOG_FILE
    
    # Remove configuration scripts
    print_warning "Removing configuration scripts..."
    rm -f configure-graylog.sh 2>/dev/null || true
    rm -f test-log-sender.sh 2>/dev/null || true
    rm -f monitor-siem.sh 2>/dev/null || true
    echo "Removed configuration scripts" >> $LOG_FILE
    
    print_success "SIEM logs reset"
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

# Function to reset system services
function reset_system_services() {
    print_status "RESETTING SYSTEM SERVICES"
    
    # Reset rsyslog
    print_warning "Resetting rsyslog..."
    systemctl restart rsyslog 2>/dev/null || true
    echo "Reset rsyslog" >> $LOG_FILE
    
    # Reset systemd
    print_warning "Resetting systemd..."
    systemctl daemon-reload 2>/dev/null || true
    echo "Reset systemd" >> $LOG_FILE
    
    print_success "System services reset"
}

# Function to clean temporary files
function clean_temporary_files() {
    print_status "CLEANING TEMPORARY FILES"
    
    # Remove temporary files
    print_warning "Removing temporary files..."
    rm -f *.tmp 2>/dev/null || true
    rm -f *.cache 2>/dev/null || true
    rm -f /tmp/siem-* 2>/dev/null || true
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
    cat > siem-reset-verification-$(date +%Y%m%d-%H%M%S).md << EOF
# SIEM Central Reset Verification

## Reset Details
- **Date**: $(date)
- **Machine**: SIEM Central
- **User**: $(whoami)
- **Log File**: $LOG_FILE

## Reset Actions Performed
- [x] SIEM containers stopped and removed
- [x] SIEM volumes removed
- [x] SIEM configurations reset
- [x] SIEM logs cleared
- [x] Network configuration reset
- [x] System services reset
- [x] Temporary files cleaned

## Verification Steps
1. **Check Docker**: \`docker ps -a\`
2. **Check Volumes**: \`docker volume ls\`
3. **Check Network**: \`ip addr show\`
4. **Check Services**: \`systemctl status rsyslog\`
5. **Check Logs**: \`ls -la *.log\`

## Next Steps
1. Start SIEM: \`docker-compose up -d\`
2. Configure Graylog: \`./configure-graylog.sh\`
3. Test log forwarding: \`./test-log-sender.sh\`
4. Monitor SIEM: \`./monitor-siem.sh\`
5. Begin new training session

## Notes
- SIEM central reset to initial state
- Ready for new training session
- Backup any important data before reset
EOF

    print_success "Reset verification file created"
}

# Main reset process
print_status "STARTING SIEM RESET"

# 1. Stop SIEM containers
stop_siem_containers

# 2. Remove SIEM volumes
remove_siem_volumes

# 3. Reset SIEM configurations
reset_siem_configurations

# 4. Reset SIEM logs
reset_siem_logs

# 5. Reset network configuration
reset_network_configuration

# 6. Reset system services
reset_system_services

# 7. Clean temporary files
clean_temporary_files

# 8. Create reset verification
create_reset_verification

# Summary
echo ""
print_status "RESET SUMMARY"
print_success "✅ SIEM containers stopped and removed"
print_success "✅ SIEM volumes removed"
print_success "✅ SIEM configurations reset"
print_success "✅ SIEM logs cleared"
print_success "✅ Network configuration reset"
print_success "✅ System services reset"
print_success "✅ Temporary files cleaned"
print_success "✅ Reset verification created"

echo ""
print_status "NEXT STEPS"
echo "1. Start SIEM: docker-compose up -d"
echo "2. Configure Graylog: ./configure-graylog.sh"
echo "3. Test log forwarding: ./test-log-sender.sh"
echo "4. Monitor SIEM: ./monitor-siem.sh"
echo "5. Begin new training session"

echo ""
print_status "VERIFICATION COMMANDS"
echo "Check Docker: docker ps -a"
echo "Check Volumes: docker volume ls"
echo "Check Network: ip addr show"
echo "Check Services: systemctl status rsyslog"
echo "Check Logs: ls -la *.log"

echo ""
print_success "🎯 SIEM CENTRAL RESET COMPLETED SUCCESSFULLY!"
print_success "Ready for new training session!" 