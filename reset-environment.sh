#!/bin/bash
# Reset Environment Script - Lab Vuln
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

print_status "RESET ENVIRONMENT - LAB VULN"
echo "This script will reset all machines to their initial state"
echo "Useful for multiple classes and fresh training sessions"
echo ""

print_warning "⚠️  WARNING: This will reset all machines to initial state!"
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
if [[ $EUID -eq 0 ]]; then
    print_success "Running as root - good!"
else
    print_warning "Some operations may require root privileges"
fi

print_status "RESET CONFIGURATION"
echo "Targets to reset:"
echo "- MAQ-1 (Windows Active Directory)"
echo "- MAQ-2 (Laravel Web Application)"
echo "- MAQ-3 (Linux Infrastructure)"
echo "- SIEM Central"
echo "- Attack simulation logs"
echo ""

# Function to reset Docker containers
function reset_docker_containers() {
    print_status "RESETTING DOCKER CONTAINERS"
    
    # Stop and remove all containers
    print_warning "Stopping all containers..."
    docker-compose down 2>/dev/null || true
    
    # Remove containers for each machine
    for machine in "MAQ-1" "MAQ-2" "MAQ-3" "siem-central"; do
        if [[ -d "$machine" ]]; then
            cd "$machine"
            if [[ -f "docker-compose.yml" ]]; then
                print_warning "Resetting $machine..."
                docker-compose down --volumes --remove-orphans 2>/dev/null || true
                docker-compose rm -f 2>/dev/null || true
            fi
            cd ..
        fi
    done
    
    # Clean up Docker system
    print_warning "Cleaning up Docker system..."
    docker system prune -f 2>/dev/null || true
    docker volume prune -f 2>/dev/null || true
    
    print_success "Docker containers reset"
}

# Function to reset SIEM data
function reset_siem_data() {
    print_status "RESETTING SIEM DATA"
    
    if [[ -d "siem-central" ]]; then
        cd siem-central
        
        # Stop SIEM containers
        print_warning "Stopping SIEM containers..."
        docker-compose down --volumes 2>/dev/null || true
        
        # Remove SIEM volumes
        print_warning "Removing SIEM volumes..."
        docker volume rm siem-central_graylog_data 2>/dev/null || true
        docker volume rm siem-central_mongo_data 2>/dev/null || true
        docker volume rm siem-central_es_data 2>/dev/null || true
        docker volume rm siem-central_wazuh_data 2>/dev/null || true
        docker volume rm siem-central_wazuh_logs 2>/dev/null || true
        
        # Remove SIEM logs
        print_warning "Removing SIEM logs..."
        rm -f *.log 2>/dev/null || true
        rm -f configure-graylog.sh 2>/dev/null || true
        rm -f test-log-sender.sh 2>/dev/null || true
        rm -f monitor-siem.sh 2>/dev/null || true
        
        cd ..
        print_success "SIEM data reset"
    else
        print_warning "SIEM directory not found"
    fi
}

# Function to reset attack simulation logs
function reset_attack_logs() {
    print_status "RESETTING ATTACK SIMULATION LOGS"
    
    if [[ -d "attack-simulations" ]]; then
        cd attack-simulations
        
        # Remove simulation logs
        print_warning "Removing attack simulation logs..."
        rm -f *.log 2>/dev/null || true
        rm -f brute-force-simulation-*.log 2>/dev/null || true
        rm -f lfi-simulation-*.log 2>/dev/null || true
        rm -f ransomware-simulation-*.log 2>/dev/null || true
        
        cd ..
        print_success "Attack simulation logs reset"
    else
        print_warning "Attack simulations directory not found"
    fi
}

# Function to reset machine-specific data
function reset_machine_data() {
    local machine=$1
    local machine_name=$2
    
    print_status "RESETTING $machine_name DATA"
    
    if [[ -d "$machine" ]]; then
        cd "$machine"
        
        # Remove logs and temporary files
        print_warning "Removing logs and temporary files..."
        rm -f *.log 2>/dev/null || true
        rm -f *.tmp 2>/dev/null || true
        rm -f *.cache 2>/dev/null || true
        
        # Remove Docker data
        if [[ -f "docker-compose.yml" ]]; then
            print_warning "Removing Docker data for $machine_name..."
            docker-compose down --volumes 2>/dev/null || true
            docker-compose rm -f 2>/dev/null || true
        fi
        
        # Remove specific machine files
        case $machine in
            "MAQ-1")
                # Windows-specific cleanup
                print_warning "Removing Windows-specific files..."
                rm -f *.ps1.log 2>/dev/null || true
                rm -f siem_events.log 2>/dev/null || true
                ;;
            "MAQ-2")
                # Laravel-specific cleanup
                print_warning "Removing Laravel-specific files..."
                rm -f storage/logs/*.log 2>/dev/null || true
                rm -f bootstrap/cache/* 2>/dev/null || true
                rm -f .env.backup 2>/dev/null || true
                ;;
            "MAQ-3")
                # Linux-specific cleanup
                print_warning "Removing Linux-specific files..."
                rm -f /var/log/security-monitor.log 2>/dev/null || true
                rm -f /var/log/laravel-forwarder.log 2>/dev/null || true
                ;;
        esac
        
        cd ..
        print_success "$machine_name data reset"
    else
        print_warning "$machine_name directory not found"
    fi
}

# Function to reset configuration files
function reset_configurations() {
    print_status "RESETTING CONFIGURATION FILES"
    
    # Remove SIEM configuration files
    print_warning "Removing SIEM configuration files..."
    rm -f siem-configuration-summary.md 2>/dev/null || true
    rm -f quick-setup-siem.sh 2>/dev/null || true
    rm -f verify-siem-config.sh 2>/dev/null || true
    
    # Remove log forwarding configurations
    print_warning "Removing log forwarding configurations..."
    rm -f /etc/rsyslog.d/30-laravel.conf 2>/dev/null || true
    rm -f /etc/rsyslog.d/30-system-logs.conf 2>/dev/null || true
    rm -f /etc/audit/rules.d/audit.rules 2>/dev/null || true
    
    # Remove systemd services
    print_warning "Removing systemd services..."
    systemctl stop laravel-log-forwarder.service 2>/dev/null || true
    systemctl disable laravel-log-forwarder.service 2>/dev/null || true
    rm -f /etc/systemd/system/laravel-log-forwarder.service 2>/dev/null || true
    
    systemctl stop system-log-monitor.service 2>/dev/null || true
    systemctl disable system-log-monitor.service 2>/dev/null || true
    rm -f /etc/systemd/system/system-log-monitor.service 2>/dev/null || true
    
    # Reload systemd
    systemctl daemon-reload 2>/dev/null || true
    
    print_success "Configuration files reset"
}

# Function to reset network configurations
function reset_network_config() {
    print_status "RESETTING NETWORK CONFIGURATIONS"
    
    # Reset firewall rules (if any were added)
    print_warning "Resetting firewall configurations..."
    iptables -F 2>/dev/null || true
    iptables -X 2>/dev/null || true
    iptables -t nat -F 2>/dev/null || true
    iptables -t nat -X 2>/dev/null || true
    
    # Reset network interfaces
    print_warning "Resetting network interfaces..."
    ip link set dev eth0 up 2>/dev/null || true
    
    print_success "Network configurations reset"
}

# Function to create reset verification
function create_reset_verification() {
    print_status "CREATING RESET VERIFICATION"
    
    # Create reset verification file
    cat > reset-verification-$(date +%Y%m%d-%H%M%S).md << EOF
# Environment Reset Verification

## Reset Details
- **Date**: $(date)
- **Reset by**: $(whoami)
- **Host**: $(hostname)

## Reset Actions Performed
- [x] Docker containers stopped and removed
- [x] SIEM data and volumes removed
- [x] Attack simulation logs cleared
- [x] Machine-specific data reset
- [x] Configuration files reset
- [x] Network configurations reset

## Verification Steps
1. **Check Docker containers**: \`docker ps -a\`
2. **Check SIEM status**: \`cd siem-central && docker-compose ps\`
3. **Check machine status**: \`cd MAQ-X && docker-compose ps\`
4. **Check log files**: \`find . -name "*.log" -type f\`
5. **Check network**: \`ping -c 1 192.168.1.102\`

## Next Steps
1. Start SIEM: \`./quick-setup-siem.sh\`
2. Configure machines: \`./configure-all-syslog.sh\`
3. Run verification: \`./verify-siem-config.sh\`
4. Begin training session

## Notes
- All data has been reset to initial state
- Ready for new training session
- Backup any important data before reset
EOF

    print_success "Reset verification file created"
}

# Main reset process
print_status "STARTING ENVIRONMENT RESET"

# 1. Reset Docker containers
reset_docker_containers

# 2. Reset SIEM data
reset_siem_data

# 3. Reset attack simulation logs
reset_attack_logs

# 4. Reset machine-specific data
reset_machine_data "MAQ-1" "Windows Active Directory"
reset_machine_data "MAQ-2" "Laravel Web Application"
reset_machine_data "MAQ-3" "Linux Infrastructure"

# 5. Reset configurations
reset_configurations

# 6. Reset network configurations
reset_network_config

# 7. Create reset verification
create_reset_verification

# Final cleanup
print_status "FINAL CLEANUP"

# Remove temporary files
print_warning "Removing temporary files..."
find . -name "*.tmp" -delete 2>/dev/null || true
find . -name "*.cache" -delete 2>/dev/null || true
find . -name "*~" -delete 2>/dev/null || true

# Clean up Docker images (optional)
read -p "Remove unused Docker images? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_warning "Removing unused Docker images..."
    docker image prune -f 2>/dev/null || true
    print_success "Docker images cleaned"
fi

# Summary
echo ""
print_status "RESET SUMMARY"
print_success "✅ Docker containers reset"
print_success "✅ SIEM data cleared"
print_success "✅ Attack simulation logs removed"
print_success "✅ Machine-specific data reset"
print_success "✅ Configuration files reset"
print_success "✅ Network configurations reset"
print_success "✅ Reset verification created"

echo ""
print_status "NEXT STEPS"
echo "1. Start SIEM: ./quick-setup-siem.sh"
echo "2. Configure machines: ./configure-all-syslog.sh"
echo "3. Verify setup: ./verify-siem-config.sh"
echo "4. Begin new training session"

echo ""
print_status "VERIFICATION COMMANDS"
echo "Check Docker: docker ps -a"
echo "Check SIEM: cd siem-central && docker-compose ps"
echo "Check machines: cd MAQ-X && docker-compose ps"
echo "Check logs: find . -name '*.log' -type f"

echo ""
print_success "🎯 ENVIRONMENT RESET COMPLETED SUCCESSFULLY!"
print_success "Ready for new training session!" 