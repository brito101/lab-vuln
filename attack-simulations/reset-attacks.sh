#!/bin/bash
# Reset Attack Simulations - Lab Vuln
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

print_status "RESET ATTACK SIMULATIONS - LAB VULN"
echo "This script will reset all attack simulation logs and data"
echo ""

print_warning "⚠️  WARNING: This will reset all attack simulation data!"
print_warning "⚠️  All logs, reports, and simulation data will be reset!"
print_warning "⚠️  This action cannot be undone!"
echo ""

read -p "Do you want to continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_warning "Reset cancelled by user."
    exit 0
fi

# Create log file
LOG_FILE="attack-reset-$(date +%Y%m%d-%H%M%S).log"
echo "Attack Simulation Reset Log" > $LOG_FILE
echo "Date: $(date)" >> $LOG_FILE
echo "User: $(whoami)" >> $LOG_FILE
echo "" >> $LOG_FILE

print_status "RESET CONFIGURATION"
echo "Target: Attack Simulation Logs and Data"
echo "Actions: Reset logs, reports, and simulation data"
echo ""

# Function to reset brute force simulation logs
function reset_brute_force_logs() {
    print_status "RESETTING BRUTE FORCE SIMULATION LOGS"
    
    # Remove brute force logs
    print_warning "Removing brute force simulation logs..."
    rm -f brute-force-simulation-*.log 2>/dev/null || true
    rm -f ssh-brute-force-*.log 2>/dev/null || true
    rm -f ftp-brute-force-*.log 2>/dev/null || true
    rm -f web-brute-force-*.log 2>/dev/null || true
    echo "Removed brute force simulation logs" >> $LOG_FILE
    
    # Remove brute force reports
    print_warning "Removing brute force reports..."
    rm -f brute-force-report-*.md 2>/dev/null || true
    rm -f ssh-attack-report-*.md 2>/dev/null || true
    echo "Removed brute force reports" >> $LOG_FILE
    
    print_success "Brute force simulation logs reset"
}

# Function to reset LFI simulation logs
function reset_lfi_logs() {
    print_status "RESETTING LFI SIMULATION LOGS"
    
    # Remove LFI logs
    print_warning "Removing LFI simulation logs..."
    rm -f lfi-simulation-*.log 2>/dev/null || true
    rm -f laravel-lfi-*.log 2>/dev/null || true
    rm -f web-lfi-*.log 2>/dev/null || true
    echo "Removed LFI simulation logs" >> $LOG_FILE
    
    # Remove LFI reports
    print_warning "Removing LFI reports..."
    rm -f lfi-report-*.md 2>/dev/null || true
    rm -f laravel-lfi-report-*.md 2>/dev/null || true
    echo "Removed LFI reports" >> $LOG_FILE
    
    print_success "LFI simulation logs reset"
}

# Function to reset ransomware simulation logs
function reset_ransomware_logs() {
    print_status "RESETTING RANSOMWARE SIMULATION LOGS"
    
    # Remove ransomware logs
    print_warning "Removing ransomware simulation logs..."
    rm -f ransomware-simulation-*.log 2>/dev/null || true
    rm -f windows-ransomware-*.log 2>/dev/null || true
    rm -f file-encryption-*.log 2>/dev/null || true
    echo "Removed ransomware simulation logs" >> $LOG_FILE
    
    # Remove ransomware reports
    print_warning "Removing ransomware reports..."
    rm -f ransomware-report-*.md 2>/dev/null || true
    rm -f encryption-report-*.md 2>/dev/null || true
    echo "Removed ransomware reports" >> $LOG_FILE
    
    print_success "Ransomware simulation logs reset"
}

# Function to reset general attack logs
function reset_general_attack_logs() {
    print_status "RESETTING GENERAL ATTACK LOGS"
    
    # Remove general attack logs
    print_warning "Removing general attack logs..."
    rm -f attack-simulation-*.log 2>/dev/null || true
    rm -f penetration-test-*.log 2>/dev/null || true
    rm -f security-test-*.log 2>/dev/null || true
    echo "Removed general attack logs" >> $LOG_FILE
    
    # Remove attack reports
    print_warning "Removing attack reports..."
    rm -f attack-report-*.md 2>/dev/null || true
    rm -f security-report-*.md 2>/dev/null || true
    echo "Removed attack reports" >> $LOG_FILE
    
    print_success "General attack logs reset"
}

# Function to reset SIEM detection logs
function reset_siem_detection_logs() {
    print_status "RESETTING SIEM DETECTION LOGS"
    
    # Remove SIEM detection logs
    print_warning "Removing SIEM detection logs..."
    rm -f siem-detection-*.log 2>/dev/null || true
    rm -f graylog-alerts-*.log 2>/dev/null || true
    rm -f wazuh-alerts-*.log 2>/dev/null || true
    echo "Removed SIEM detection logs" >> $LOG_FILE
    
    # Remove SIEM reports
    print_warning "Removing SIEM reports..."
    rm -f siem-report-*.md 2>/dev/null || true
    rm -f detection-report-*.md 2>/dev/null || true
    echo "Removed SIEM reports" >> $LOG_FILE
    
    print_success "SIEM detection logs reset"
}

# Function to reset incident response logs
function reset_incident_response_logs() {
    print_status "RESETTING INCIDENT RESPONSE LOGS"
    
    # Remove incident response logs
    print_warning "Removing incident response logs..."
    rm -f incident-response-*.log 2>/dev/null || true
    rm -f ir-timeline-*.log 2>/dev/null || true
    rm -f response-action-*.log 2>/dev/null || true
    echo "Removed incident response logs" >> $LOG_FILE
    
    # Remove incident reports
    print_warning "Removing incident reports..."
    rm -f incident-report-*.md 2>/dev/null || true
    rm -f response-report-*.md 2>/dev/null || true
    echo "Removed incident reports" >> $LOG_FILE
    
    print_success "Incident response logs reset"
}

# Function to reset forensic artifacts
function reset_forensic_artifacts() {
    print_status "RESETTING FORENSIC ARTIFACTS"
    
    # Remove forensic artifacts
    print_warning "Removing forensic artifacts..."
    rm -f forensic-*.log 2>/dev/null || true
    rm -f memory-dump-*.bin 2>/dev/null || true
    rm -f disk-image-*.img 2>/dev/null || true
    echo "Removed forensic artifacts" >> $LOG_FILE
    
    # Remove forensic reports
    print_warning "Removing forensic reports..."
    rm -f forensic-report-*.md 2>/dev/null || true
    rm -f analysis-report-*.md 2>/dev/null || true
    echo "Removed forensic reports" >> $LOG_FILE
    
    print_success "Forensic artifacts reset"
}

# Function to clean temporary files
function clean_temporary_files() {
    print_status "CLEANING TEMPORARY FILES"
    
    # Remove temporary files
    print_warning "Removing temporary files..."
    rm -f *.tmp 2>/dev/null || true
    rm -f *.cache 2>/dev/null || true
    rm -f *.bak 2>/dev/null || true
    echo "Removed temporary files" >> $LOG_FILE
    
    # Remove backup files
    print_warning "Removing backup files..."
    rm -f *.backup 2>/dev/null || true
    rm -f *.old 2>/dev/null || true
    echo "Removed backup files" >> $LOG_FILE
    
    print_success "Temporary files cleaned"
}

# Function to create reset verification
function create_reset_verification() {
    print_status "CREATING RESET VERIFICATION"
    
    # Create reset verification file
    cat > attack-reset-verification-$(date +%Y%m%d-%H%M%S).md << EOF
# Attack Simulation Reset Verification

## Reset Details
- **Date**: $(date)
- **User**: $(whoami)
- **Log File**: $LOG_FILE

## Reset Actions Performed
- [x] Brute force simulation logs cleared
- [x] LFI simulation logs cleared
- [x] Ransomware simulation logs cleared
- [x] General attack logs cleared
- [x] SIEM detection logs cleared
- [x] Incident response logs cleared
- [x] Forensic artifacts removed
- [x] Temporary files cleaned

## Verification Steps
1. **Check Logs**: \`ls -la *.log\`
2. **Check Reports**: \`ls -la *.md\`
3. **Check Scripts**: \`ls -la *.sh\`
4. **Check PowerShell**: \`ls -la *.ps1\`

## Next Steps
1. Run attack simulations: \`./brute-force-simulation.sh\`
2. Run LFI simulation: \`./lfi-simulation.sh\`
3. Run ransomware simulation: \`./ransomware-simulation.ps1\`
4. Monitor SIEM for detections
5. Begin new training session

## Notes
- Attack simulation data reset to initial state
- Ready for new training session
- Backup any important data before reset
EOF

    print_success "Reset verification file created"
}

# Main reset process
print_status "STARTING ATTACK SIMULATION RESET"

# 1. Reset brute force simulation logs
reset_brute_force_logs

# 2. Reset LFI simulation logs
reset_lfi_logs

# 3. Reset ransomware simulation logs
reset_ransomware_logs

# 4. Reset general attack logs
reset_general_attack_logs

# 5. Reset SIEM detection logs
reset_siem_detection_logs

# 6. Reset incident response logs
reset_incident_response_logs

# 7. Reset forensic artifacts
reset_forensic_artifacts

# 8. Clean temporary files
clean_temporary_files

# 9. Create reset verification
create_reset_verification

# Summary
echo ""
print_status "RESET SUMMARY"
print_success "✅ Brute force simulation logs cleared"
print_success "✅ LFI simulation logs cleared"
print_success "✅ Ransomware simulation logs cleared"
print_success "✅ General attack logs cleared"
print_success "✅ SIEM detection logs cleared"
print_success "✅ Incident response logs cleared"
print_success "✅ Forensic artifacts removed"
print_success "✅ Temporary files cleaned"
print_success "✅ Reset verification created"

echo ""
print_status "NEXT STEPS"
echo "1. Run attack simulations: ./brute-force-simulation.sh"
echo "2. Run LFI simulation: ./lfi-simulation.sh"
echo "3. Run ransomware simulation: ./ransomware-simulation.ps1"
echo "4. Monitor SIEM for detections"
echo "5. Begin new training session"

echo ""
print_status "VERIFICATION COMMANDS"
echo "Check Logs: ls -la *.log"
echo "Check Reports: ls -la *.md"
echo "Check Scripts: ls -la *.sh"
echo "Check PowerShell: ls -la *.ps1"

echo ""
print_success "🎯 ATTACK SIMULATION RESET COMPLETED SUCCESSFULLY!"
print_success "Ready for new training session!" 