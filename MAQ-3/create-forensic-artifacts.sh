#!/bin/bash
# Create Forensic Artifacts - MAQ-3 (Linux)
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

# Configuration
MACHINE_NAME="MAQ-3"
ARTIFACTS_DIR="/forensic-artifacts"
LOG_FILE="forensic-artifacts-$(date +%Y%m%d-%H%M%S).log"

print_status "CREATE FORENSIC ARTIFACTS - $MACHINE_NAME"
echo "This script will create forensic artifacts for analysis exercises"
echo ""

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   print_error "This script must be run as root"
   exit 1
fi

# Create artifacts directory
mkdir -p $ARTIFACTS_DIR
print_success "Created artifacts directory: $ARTIFACTS_DIR"

# Create log file
echo "Linux Forensic Artifacts Creation Log" > $LOG_FILE
echo "Date: $(date)" >> $LOG_FILE
echo "Machine: $MACHINE_NAME" >> $LOG_FILE
echo "User: $(whoami)" >> $LOG_FILE
echo "" >> $LOG_FILE

# Function to create memory dump
function create_memory_dump() {
    print_status "CREATING MEMORY DUMP"
    
    print_warning "Creating memory dump..."
    print_warning "This may take several minutes depending on RAM size..."
    
    # Create memory dump using dd
    MEMORY_DUMP="$ARTIFACTS_DIR/memory-dump-$(date +%Y%m%d-%H%M%S).raw"
    
    # Use /proc/kcore for kernel memory (if available)
    if [[ -r /proc/kcore ]]; then
        if dd if=/proc/kcore of="$MEMORY_DUMP" bs=1M count=1024 2>/dev/null; then
            print_success "Created kernel memory dump: $MEMORY_DUMP"
            echo "Created kernel memory dump: $MEMORY_DUMP" >> $LOG_FILE
        else
            print_error "Failed to create kernel memory dump"
            echo "Failed to create kernel memory dump" >> $LOG_FILE
        fi
    fi
    
    # Create process memory dumps for critical processes
    CRITICAL_PROCESSES=("sshd" "vsftpd" "smbd" "apache2" "nginx" "systemd")
    
    for process in "${CRITICAL_PROCESSES[@]}"; do
        PID=$(pgrep $process 2>/dev/null | head -1)
        if [[ -n $PID ]]; then
            PROCESS_DUMP="$ARTIFACTS_DIR/process-$process-$PID-$(date +%Y%m%d-%H%M%S).dump"
            
            # Create process memory dump using gcore
            if command -v gcore &> /dev/null; then
                if gcore -o "$ARTIFACTS_DIR/process-$process-$PID" $PID 2>/dev/null; then
                    print_success "Created process dump for $process (PID: $PID)"
                    echo "Created process dump for $process (PID: $PID)" >> $LOG_FILE
                else
                    print_error "Failed to create process dump for $process (PID: $PID)"
                    echo "Failed to create process dump for $process (PID: $PID)" >> $LOG_FILE
                fi
            fi
        fi
    done
    
    print_success "Memory dumps created"
}

# Function to collect system logs
function collect_system_logs() {
    print_status "COLLECTING SYSTEM LOGS"
    
    # Copy system logs
    print_warning "Copying system logs..."
    
    LOG_SOURCES=(
        "/var/log/syslog"
        "/var/log/messages"
        "/var/log/auth.log"
        "/var/log/daemon.log"
        "/var/log/kern.log"
        "/var/log/dpkg.log"
        "/var/log/apt/history.log"
    )
    
    for log_file in "${LOG_SOURCES[@]}"; do
        if [[ -f $log_file ]]; then
            if cp "$log_file" "$ARTIFACTS_DIR/$(basename $log_file)-$(date +%Y%m%d-%H%M%S).log"; then
                print_success "Copied: $log_file"
                echo "Copied log file: $log_file" >> $LOG_FILE
            else
                print_error "Failed to copy: $log_file"
                echo "Failed to copy log file: $log_file" >> $LOG_FILE
            fi
        fi
    done
    
    # Collect service-specific logs
    SERVICE_LOGS=(
        "/var/log/ssh/*"
        "/var/log/vsftpd.log*"
        "/var/log/samba/*"
        "/var/log/apache2/*"
        "/var/log/nginx/*"
    )
    
    for log_pattern in "${SERVICE_LOGS[@]}"; do
        if ls $log_pattern 1> /dev/null 2>&1; then
            if cp $log_pattern "$ARTIFACTS_DIR/" 2>/dev/null; then
                print_success "Copied service logs: $log_pattern"
                echo "Copied service logs: $log_pattern" >> $LOG_FILE
            else
                print_error "Failed to copy service logs: $log_pattern"
                echo "Failed to copy service logs: $log_pattern" >> $LOG_FILE
            fi
        fi
    done
    
    print_success "System logs collected"
}

# Function to collect audit logs
function collect_audit_logs() {
    print_status "COLLECTING AUDIT LOGS"
    
    # Check if auditd is running
    if systemctl is-active --quiet auditd; then
        print_warning "Collecting audit logs..."
        
        # Copy audit logs
        if [[ -d /var/log/audit ]]; then
            if cp -r /var/log/audit/* "$ARTIFACTS_DIR/" 2>/dev/null; then
                print_success "Copied audit logs"
                echo "Copied audit logs" >> $LOG_FILE
            else
                print_error "Failed to copy audit logs"
                echo "Failed to copy audit logs" >> $LOG_FILE
            fi
        fi
        
        # Export current audit rules
        AUDIT_RULES="$ARTIFACTS_DIR/audit-rules-$(date +%Y%m%d-%H%M%S).txt"
        if auditctl -l > "$AUDIT_RULES" 2>/dev/null; then
            print_success "Exported audit rules: $AUDIT_RULES"
            echo "Exported audit rules: $AUDIT_RULES" >> $LOG_FILE
        else
            print_error "Failed to export audit rules"
            echo "Failed to export audit rules" >> $LOG_FILE
        fi
    else
        print_warning "Audit daemon not running"
    fi
    
    print_success "Audit logs collected"
}

# Function to collect network artifacts
function collect_network_artifacts() {
    print_status "COLLECTING NETWORK ARTIFACTS"
    
    # Network connections
    NETSTAT_FILE="$ARTIFACTS_DIR/netstat-$(date +%Y%m%d-%H%M%S).txt"
    if netstat -tuln > "$NETSTAT_FILE"; then
        print_success "Exported network connections: $NETSTAT_FILE"
    else
        print_error "Failed to export network connections"
    fi
    
    # ARP table
    ARP_FILE="$ARTIFACTS_DIR/arp-table-$(date +%Y%m%d-%H%M%S).txt"
    if arp -a > "$ARP_FILE"; then
        print_success "Exported ARP table: $ARP_FILE"
    else
        print_error "Failed to export ARP table"
    fi
    
    # Routing table
    ROUTE_FILE="$ARTIFACTS_DIR/routing-table-$(date +%Y%m%d-%H%M%S).txt"
    if route -n > "$ROUTE_FILE"; then
        print_success "Exported routing table: $ROUTE_FILE"
    else
        print_error "Failed to export routing table"
    fi
    
    # DNS cache
    DNS_FILE="$ARTIFACTS_DIR/dns-cache-$(date +%Y%m%d-%H%M%S).txt"
    if cat /etc/resolv.conf > "$DNS_FILE"; then
        print_success "Exported DNS configuration: $DNS_FILE"
    else
        print_error "Failed to export DNS configuration"
    fi
    
    # Network interfaces
    IFACE_FILE="$ARTIFACTS_DIR/network-interfaces-$(date +%Y%m%d-%H%M%S).txt"
    if ip addr show > "$IFACE_FILE"; then
        print_success "Exported network interfaces: $IFACE_FILE"
    else
        print_error "Failed to export network interfaces"
    fi
    
    # Firewall rules
    FIREWALL_FILE="$ARTIFACTS_DIR/firewall-rules-$(date +%Y%m%d-%H%M%S).txt"
    if iptables -L -n -v > "$FIREWALL_FILE" 2>/dev/null; then
        print_success "Exported firewall rules: $FIREWALL_FILE"
    else
        print_error "Failed to export firewall rules"
    fi
    
    echo "Network artifacts collected" >> $LOG_FILE
    print_success "Network artifacts collected"
}

# Function to collect process information
function collect_process_information() {
    print_status "COLLECTING PROCESS INFORMATION"
    
    # Process list
    PROCESS_FILE="$ARTIFACTS_DIR/process-list-$(date +%Y%m%d-%H%M%S).txt"
    if ps aux > "$PROCESS_FILE"; then
        print_success "Exported process list: $PROCESS_FILE"
    else
        print_error "Failed to export process list"
    fi
    
    # Service status
    SERVICE_FILE="$ARTIFACTS_DIR/service-status-$(date +%Y%m%d-%H%M%S).txt"
    if systemctl list-units --type=service --state=running > "$SERVICE_FILE"; then
        print_success "Exported service status: $SERVICE_FILE"
    else
        print_error "Failed to export service status"
    fi
    
    # Open files
    LSOF_FILE="$ARTIFACTS_DIR/open-files-$(date +%Y%m%d-%H%M%S).txt"
    if lsof > "$LSOF_FILE" 2>/dev/null; then
        print_success "Exported open files: $LSOF_FILE"
    else
        print_error "Failed to export open files"
    fi
    
    # Loaded modules
    MODULES_FILE="$ARTIFACTS_DIR/loaded-modules-$(date +%Y%m%d-%H%M%S).txt"
    if lsmod > "$MODULES_FILE"; then
        print_success "Exported loaded modules: $MODULES_FILE"
    else
        print_error "Failed to export loaded modules"
    fi
    
    echo "Process information collected" >> $LOG_FILE
    print_success "Process information collected"
}

# Function to create disk image
function create_disk_image() {
    print_status "CREATING DISK IMAGE"
    
    print_warning "Creating disk image components..."
    print_warning "This may take a long time depending on disk size..."
    
    # Create logical copy of important directories
    IMPORTANT_DIRS=(
        "/etc"
        "/var/log"
        "/home"
        "/root"
        "/tmp"
        "/var/spool"
        "/var/cache"
    )
    
    for dir in "${IMPORTANT_DIRS[@]}"; do
        if [[ -d $dir ]]; then
            COPY_DIR="$ARTIFACTS_DIR/$(basename $dir)-copy-$(date +%Y%m%d-%H%M%S)"
            print_warning "Copying directory: $dir"
            
            # Use rsync for reliable copying
            if rsync -av --exclude='*.tmp' --exclude='*.cache' "$dir/" "$COPY_DIR/" 2>/dev/null; then
                print_success "Copied: $COPY_DIR"
                echo "Copied directory: $COPY_DIR" >> $LOG_FILE
            else
                print_error "Failed to copy directory: $dir"
                echo "Failed to copy directory: $dir" >> $LOG_FILE
            fi
        fi
    done
    
    # Create file system information
    FS_INFO="$ARTIFACTS_DIR/filesystem-info-$(date +%Y%m%d-%H%M%S).txt"
    if df -h > "$FS_INFO"; then
        print_success "Exported filesystem information: $FS_INFO"
    else
        print_error "Failed to export filesystem information"
    fi
    if mount > "$FS_INFO.tmp"; then
        cat "$FS_INFO.tmp" >> "$FS_INFO"
        rm "$FS_INFO.tmp"
    else
        print_error "Failed to export mount information"
        echo "Failed to export mount information" >> $LOG_FILE
    fi
    
    print_success "Disk image components created"
}

# Function to collect timeline
function create_timeline() {
    print_status "CREATING TIMELINE"
    
    print_warning "Creating file system timeline..."
    
    TIMELINE_FILE="$ARTIFACTS_DIR/system-timeline-$(date +%Y%m%d-%H%M%S).txt"
    
    # Create timeline using find command
    if find /home /root /tmp /var/log /etc -type f -printf "%T@ %p %s %M\n" 2>/dev/null | \
        sort -n | \
        while read timestamp path size mode; do
            date -d "@$timestamp" "+%Y-%m-%d %H:%M:%S" | tr '\n' ' '
            echo "$path $size $mode"
        done > "$TIMELINE_FILE"; then
        print_success "Created timeline: $TIMELINE_FILE"
        echo "Created timeline: $TIMELINE_FILE" >> $LOG_FILE
        print_success "Timeline created"
    else
        print_error "Failed to create timeline"
        echo "Failed to create timeline" >> $LOG_FILE
    fi
}

# Function to collect volatile data
function collect_volatile_data() {
    print_status "COLLECTING VOLATILE DATA"
    
    # Memory information
    MEMORY_FILE="$ARTIFACTS_DIR/memory-info-$(date +%Y%m%d-%H%M%S).txt"
    if cat /proc/meminfo > "$MEMORY_FILE"; then
        print_success "Exported memory information: $MEMORY_FILE"
    else
        print_error "Failed to export memory information"
    fi
    
    # CPU information
    CPU_FILE="$ARTIFACTS_DIR/cpu-info-$(date +%Y%m%d-%H%M%S).txt"
    if cat /proc/cpuinfo > "$CPU_FILE"; then
        print_success "Exported CPU information: $CPU_FILE"
    else
        print_error "Failed to export CPU information"
    fi
    
    # System information
    SYSTEM_FILE="$ARTIFACTS_DIR/system-info-$(date +%Y%m%d-%H%M%S).txt"
    if uname -a > "$SYSTEM_FILE"; then
        print_success "Exported system information: $SYSTEM_FILE"
    else
        print_error "Failed to export system information"
    fi
    if cat /proc/version >> "$SYSTEM_FILE"; then
        print_success "Exported system information: $SYSTEM_FILE"
    else
        print_error "Failed to export system information"
    fi
    
    # Kernel modules
    KERNEL_FILE="$ARTIFACTS_DIR/kernel-modules-$(date +%Y%m%d-%H%M%S).txt"
    if lsmod > "$KERNEL_FILE"; then
        print_success "Exported kernel modules: $KERNEL_FILE"
    else
        print_error "Failed to export kernel modules"
    fi
    
    # Environment variables
    ENV_FILE="$ARTIFACTS_DIR/environment-$(date +%Y%m%d-%H%M%S).txt"
    if env > "$ENV_FILE"; then
        print_success "Exported environment variables: $ENV_FILE"
    else
        print_error "Failed to export environment variables"
    fi
    
    echo "Volatile data collected" >> $LOG_FILE
    print_success "Volatile data collected"
}

# Function to create forensic report
function create_forensic_report() {
    print_status "CREATING FORENSIC REPORT"
    
    REPORT_FILE="$ARTIFACTS_DIR/forensic-report-$(date +%Y%m%d-%H%M%S).md"
    
    cat > "$REPORT_FILE" << EOF
# Linux Forensic Artifacts Report - $MACHINE_NAME

## Collection Details
- **Date**: $(date)
- **Machine**: $MACHINE_NAME
- **User**: $(whoami)
- **Log File**: $LOG_FILE

## Artifacts Collected

### Memory Dumps
- Kernel memory dump (if available)
- Process memory dumps for critical services
- Location: $ARTIFACTS_DIR/memory-dump-*.raw
- Location: $ARTIFACTS_DIR/process-*.dump

### System Logs
- System log files
- Authentication logs
- Service-specific logs
- Location: $ARTIFACTS_DIR/*.log

### Audit Logs
- Audit trail information
- Audit rules configuration
- Location: $ARTIFACTS_DIR/audit-*

### Network Artifacts
- Network connections
- ARP table
- Routing table
- DNS configuration
- Network interfaces
- Firewall rules
- Location: $ARTIFACTS_DIR/network-*.txt

### Process Information
- Process list with details
- Service status
- Open files
- Loaded kernel modules
- Location: $ARTIFACTS_DIR/process-*.txt

### Disk Image Components
- System configuration files
- User directories
- Log directories
- Temporary files
- Location: $ARTIFACTS_DIR/*-copy

### Timeline
- File system timeline
- File modification times
- Location: $ARTIFACTS_DIR/system-timeline-*.txt

### Volatile Data
- Memory information
- CPU information
- System information
- Kernel modules
- Environment variables
- Location: $ARTIFACTS_DIR/*-info-*.txt

## Analysis Instructions

### Memory Analysis
1. Use Volatility or similar tools
2. Analyze kernel memory dump
3. Check for suspicious processes
4. Look for injected code

### Log Analysis
1. Import logs into SIEM
2. Look for security events
3. Check for failed logins
4. Analyze system errors

### Timeline Analysis
1. Import timeline into analysis tools
2. Look for suspicious file modifications
3. Check for data exfiltration
4. Analyze user activity patterns

### Network Analysis
1. Analyze network connections
2. Check for unauthorized access
3. Review firewall rules
4. Analyze DNS queries

### Process Analysis
1. Review process list
2. Check for suspicious processes
3. Analyze open files
4. Review loaded modules

## Notes
- All artifacts are timestamped
- Use appropriate forensic tools for analysis
- Maintain chain of custody
- Document all findings
EOF

    print_success "Created forensic report: $REPORT_FILE"
    echo "Created forensic report: $REPORT_FILE" >> $LOG_FILE
    print_success "Forensic report created"
}

# Main execution
print_status "STARTING FORENSIC ARTIFACT COLLECTION"

# 1. Create memory dump
create_memory_dump

# 2. Collect system logs
collect_system_logs

# 3. Collect audit logs
collect_audit_logs

# 4. Collect network artifacts
collect_network_artifacts

# 5. Collect process information
collect_process_information

# 6. Create disk image components
create_disk_image

# 7. Create timeline
create_timeline

# 8. Collect volatile data
collect_volatile_data

# 9. Create forensic report
create_forensic_report

# Summary
print_status "COLLECTION SUMMARY"
print_success "✅ Memory dumps created"
print_success "✅ System logs collected"
print_success "✅ Audit logs collected"
print_success "✅ Network artifacts collected"
print_success "✅ Process information collected"
print_success "✅ Disk image components created"
print_success "✅ Timeline created"
print_success "✅ Volatile data collected"
print_success "✅ Forensic report created"

print_status "ARTIFACTS LOCATION"
print_warning "All artifacts saved to: $ARTIFACTS_DIR"
print_warning "Log file: $LOG_FILE"

print_status "ANALYSIS TOOLS"
echo "Memory Analysis: Volatility, Rekall" | sed 's/^/  /'
echo "Log Analysis: Log Parser, SIEM tools" | sed 's/^/  /'
echo "Timeline: Plaso, log2timeline" | sed 's/^/  /'
echo "Network: Wireshark, NetworkMiner" | sed 's/^/  /'
echo "File System: The Sleuth Kit, Autopsy" | sed 's/^/  /'

print_success "🎯 FORENSIC ARTIFACTS COLLECTION COMPLETED!"
print_success "Ready for forensic analysis exercises!" 