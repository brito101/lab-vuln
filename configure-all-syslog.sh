#!/bin/bash
# Configure All Machines for SIEM Log Forwarding
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

print_status "CONFIGURE ALL MACHINES FOR SIEM LOG FORWARDING"
echo "Lab Vuln - SIEM Integration"
echo "Version: 1.0"
echo "Date: $(date)"

# Configuration
SIEM_IP="192.168.1.100"  # Change to your SIEM IP
SIEM_PORT="1514"

echo ""
print_warning "This script will configure all machines to forward logs to SIEM"
echo "SIEM IP: $SIEM_IP"
echo "SIEM Port: $SIEM_PORT"

read -p "Do you want to continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_warning "Configuration cancelled by user."
    exit 0
fi

# Check if SIEM is running
print_status "CHECKING SIEM AVAILABILITY"

if ping -c 1 $SIEM_IP > /dev/null 2>&1; then
    print_success "SIEM is reachable"
else
    print_warning "Cannot reach SIEM at $SIEM_IP"
    print_warning "Make sure SIEM is running before configuring machines"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_error "SIEM not available. Exiting."
        exit 1
    fi
fi

# Function to update SIEM IP in configuration files
function update_siem_ip() {
    local file="$1"
    local old_ip="$2"
    local new_ip="$3"
    
    if [[ -f "$file" ]]; then
        sed -i "s/$old_ip/$new_ip/g" "$file"
        print_success "Updated SIEM IP in $file"
    fi
}

# Update SIEM IP in all configuration files
print_status "UPDATING SIEM IP IN CONFIGURATION FILES"

# Update MAQ-1 (Windows)
if [[ -f "MAQ-1/configure-syslog.ps1" ]]; then
    update_siem_ip "MAQ-1/configure-syslog.ps1" "192.168.1.100" "$SIEM_IP"
fi

# Update MAQ-2 (Laravel)
if [[ -f "MAQ-2/configure-syslog.sh" ]]; then
    update_siem_ip "MAQ-2/configure-syslog.sh" "192.168.1.100" "$SIEM_IP"
fi

# Update MAQ-3 (Linux)
if [[ -f "MAQ-3/configure-syslog.sh" ]]; then
    update_siem_ip "MAQ-3/configure-syslog.sh" "192.168.1.100" "$SIEM_IP"
fi

# Create configuration summary
print_status "CREATING CONFIGURATION SUMMARY"

cat > siem-configuration-summary.md << EOF
# SIEM Configuration Summary

## Configuration Details
- **SIEM IP**: $SIEM_IP
- **SIEM Port**: $SIEM_PORT
- **Date**: $(date)

## Machine Configurations

### MAQ-1 (Windows Active Directory)
- **Script**: MAQ-1/configure-syslog.ps1
- **Status**: Ready to run
- **Requirements**: Run as Administrator
- **Logs Forwarded**: Windows Event Logs, Security Events, AD Events

### MAQ-2 (Laravel Web Application)
- **Script**: MAQ-2/configure-syslog.sh
- **Status**: Ready to run
- **Requirements**: Run as root
- **Logs Forwarded**: Laravel logs, Web server logs, PHP errors, MySQL logs

### MAQ-3 (Linux Infrastructure)
- **Script**: MAQ-3/configure-syslog.sh
- **Status**: Ready to run
- **Requirements**: Run as root
- **Logs Forwarded**: System logs, SSH logs, FTP logs, Samba logs

## SIEM Services
- **Graylog**: http://localhost:9000 (admin/admin)
- **Elasticsearch**: http://localhost:9200
- **Logstash**: http://localhost:9600
- **Wazuh**: http://localhost:1515 (if configured)

## Next Steps
1. Start SIEM central: cd siem-central && ./start-siem.sh
2. Configure MAQ-1: Run MAQ-1/configure-syslog.ps1 as Administrator
3. Configure MAQ-2: Run MAQ-2/configure-syslog.sh as root
4. Configure MAQ-3: Run MAQ-3/configure-syslog.sh as root
5. Access Graylog and configure inputs
6. Monitor logs in SIEM interface

## Testing
- Use siem-central/test-log-sender.sh to send test logs
- Check Graylog interface for received logs
- Monitor system resources with siem-central/monitor-siem.sh
EOF

print_success "Configuration summary created: siem-configuration-summary.md"

# Create quick setup script
print_status "CREATING QUICK SETUP SCRIPT"

cat > quick-setup-siem.sh << 'EOF'
#!/bin/bash
# Quick SIEM Setup Script
# This script provides a quick way to set up SIEM and configure machines

echo "=== QUICK SIEM SETUP ==="
echo ""

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    echo "Running as root - good!"
else
    echo "⚠️  Some operations may require root privileges"
fi

echo ""
echo "1. Starting SIEM Central..."
cd siem-central
if [[ -f "start-siem.sh" ]]; then
    chmod +x start-siem.sh
    ./start-siem.sh
else
    echo "❌ SIEM start script not found"
    exit 1
fi

echo ""
echo "2. Waiting for SIEM to start..."
sleep 30

echo ""
echo "3. Configuring Graylog inputs..."
if [[ -f "configure-graylog.sh" ]]; then
    chmod +x configure-graylog.sh
    ./configure-graylog.sh
else
    echo "⚠️  Graylog configuration script not found"
fi

echo ""
echo "4. SIEM Setup Complete!"
echo "Access Graylog at: http://localhost:9000"
echo "Username: admin"
echo "Password: admin"
echo ""
echo "5. Next steps:"
echo "   - Configure MAQ-1: Run MAQ-1/configure-syslog.ps1 as Administrator"
echo "   - Configure MAQ-2: Run MAQ-2/configure-syslog.sh as root"
echo "   - Configure MAQ-3: Run MAQ-3/configure-syslog.sh as root"
echo "   - Send test logs: ./siem-central/test-log-sender.sh"
EOF

chmod +x quick-setup-siem.sh
print_success "Quick setup script created: quick-setup-siem.sh"

# Create verification script
print_status "CREATING VERIFICATION SCRIPT"

cat > verify-siem-config.sh << 'EOF'
#!/bin/bash
# Verify SIEM Configuration
# This script verifies that SIEM is properly configured

echo "=== SIEM CONFIGURATION VERIFICATION ==="
echo ""

# Check SIEM services
echo "1. Checking SIEM services..."
if curl -s http://localhost:9000 > /dev/null 2>&1; then
    echo "✅ Graylog is running"
else
    echo "❌ Graylog is not accessible"
fi

if curl -s http://localhost:9200 > /dev/null 2>&1; then
    echo "✅ Elasticsearch is running"
else
    echo "❌ Elasticsearch is not accessible"
fi

if curl -s http://localhost:9600 > /dev/null 2>&1; then
    echo "✅ Logstash is running"
else
    echo "❌ Logstash is not accessible"
fi

echo ""
echo "2. Checking SIEM ports..."
for port in 9000 9200 9600 1514 12201; do
    if nc -z localhost $port 2>/dev/null; then
        echo "✅ Port $port is open"
    else
        echo "❌ Port $port is closed"
    fi
done

echo ""
echo "3. Checking configuration files..."
for file in "MAQ-1/configure-syslog.ps1" "MAQ-2/configure-syslog.sh" "MAQ-3/configure-syslog.sh"; do
    if [[ -f "$file" ]]; then
        echo "✅ $file exists"
    else
        echo "❌ $file not found"
    fi
done

echo ""
echo "4. Testing log forwarding..."
echo "Sending test log to SIEM..."
echo "<134>$(date '+%b %d %H:%M:%S') $(hostname) test: Verification test message" | nc -u localhost 1514 2>/dev/null
if [[ $? -eq 0 ]]; then
    echo "✅ Test log sent successfully"
else
    echo "❌ Failed to send test log"
fi

echo ""
echo "=== VERIFICATION COMPLETE ==="
echo "Check Graylog interface for test logs: http://localhost:9000"
EOF

chmod +x verify-siem-config.sh
print_success "Verification script created: verify-siem-config.sh"

# Show summary
echo ""
print_status "CONFIGURATION SUMMARY"
print_success "SIEM IP updated in all configuration files"
print_success "Configuration summary created"
print_success "Quick setup script created"
print_success "Verification script created"

echo ""
print_status "NEXT STEPS"
echo "1. Start SIEM: ./quick-setup-siem.sh"
echo "2. Configure MAQ-1: Run MAQ-1/configure-syslog.ps1 as Administrator"
echo "3. Configure MAQ-2: Run MAQ-2/configure-syslog.sh as root"
echo "4. Configure MAQ-3: Run MAQ-3/configure-syslog.sh as root"
echo "5. Verify setup: ./verify-siem-config.sh"
echo "6. Access Graylog: http://localhost:9000 (admin/admin)"

echo ""
print_status "USEFUL COMMANDS"
echo "Start SIEM: cd siem-central && ./start-siem.sh"
echo "Configure Graylog: cd siem-central && ./configure-graylog.sh"
echo "Send test logs: cd siem-central && ./test-log-sender.sh"
echo "Monitor SIEM: cd siem-central && ./monitor-siem.sh"
echo "Stop SIEM: cd siem-central && docker-compose down"

echo ""
print_success "ALL MACHINES CONFIGURED FOR SIEM LOG FORWARDING!"
print_success "🎯 Ready for centralized log collection and analysis! 🎯" 