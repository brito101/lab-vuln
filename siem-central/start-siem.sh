#!/bin/bash
# Start SIEM Central
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

print_status "STARTING SIEM CENTRAL"
echo "Lab Vuln - SIEM Integration"
echo "Version: 1.0"
echo "Date: $(date)"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Check available disk space
print_status "CHECKING DISK SPACE"

DISK_SPACE=$(df . | awk 'NR==2 {print $4}')
DISK_SPACE_GB=$((DISK_SPACE / 1024 / 1024))

if [ $DISK_SPACE_GB -lt 10 ]; then
    print_warning "Low disk space: ${DISK_SPACE_GB}GB available"
    print_warning "SIEM requires at least 10GB free space"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_error "Insufficient disk space. Exiting."
        exit 1
    fi
else
    print_success "Disk space OK: ${DISK_SPACE_GB}GB available"
fi

# Check available memory
print_status "CHECKING MEMORY"

MEMORY_KB=$(grep MemTotal /proc/meminfo | awk '{print $2}')
MEMORY_GB=$((MEMORY_KB / 1024 / 1024))

if [ $MEMORY_GB -lt 4 ]; then
    print_warning "Low memory: ${MEMORY_GB}GB available"
    print_warning "SIEM requires at least 4GB RAM"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_error "Insufficient memory. Exiting."
        exit 1
    fi
else
    print_success "Memory OK: ${MEMORY_GB}GB available"
fi

# Start SIEM containers
print_status "STARTING SIEM CONTAINERS"

# Pull latest images
print_warning "Pulling latest Docker images..."
docker-compose pull

# Start containers
print_warning "Starting SIEM containers..."
docker-compose up -d

# Wait for services to start
print_status "WAITING FOR SERVICES TO START"

echo "Waiting for Graylog to start..."
for i in {1..60}; do
    if curl -s http://localhost:9000 > /dev/null 2>&1; then
        print_success "Graylog is ready!"
        break
    fi
    echo -n "."
    sleep 5
done

echo "Waiting for Elasticsearch to start..."
for i in {1..60}; do
    if curl -s http://localhost:9200 > /dev/null 2>&1; then
        print_success "Elasticsearch is ready!"
        break
    fi
    echo -n "."
    sleep 5
done

# Show container status
print_status "CONTAINER STATUS"

docker-compose ps

# Show service URLs
print_status "SIEM SERVICE URLs"

echo "Graylog Web Interface: http://localhost:9000"
echo "  - Username: admin"
echo "  - Password: admin"
echo ""
echo "Elasticsearch: http://localhost:9200"
echo "Logstash: http://localhost:9600"
echo "Wazuh: http://localhost:1515 (if configured)"

# Create configuration script for Graylog
print_status "CREATING GRAYLOG CONFIGURATION SCRIPT"

cat > configure-graylog.sh << 'EOF'
#!/bin/bash
# Configure Graylog Inputs
# This script configures Graylog inputs for receiving logs

GRAYLOG_URL="http://localhost:9000"
USERNAME="admin"
PASSWORD="admin"

# Wait for Graylog to be ready
echo "Waiting for Graylog to be ready..."
for i in {1..60}; do
    if curl -s "$GRAYLOG_URL" > /dev/null 2>&1; then
        echo "Graylog is ready!"
        break
    fi
    echo -n "."
    sleep 5
done

# Get session token
echo "Getting session token..."
SESSION_TOKEN=$(curl -s -X POST "$GRAYLOG_URL/api/system/sessions" \
    -H "Content-Type: application/json" \
    -d "{\"username\":\"$USERNAME\",\"password\":\"$PASSWORD\"}" | \
    jq -r '.session_id')

if [ "$SESSION_TOKEN" = "null" ] || [ -z "$SESSION_TOKEN" ]; then
    echo "Failed to get session token"
    exit 1
fi

echo "Session token obtained"

# Create Syslog UDP Input
echo "Creating Syslog UDP Input..."
curl -s -X POST "$GRAYLOG_URL/api/system/inputs" \
    -H "Content-Type: application/json" \
    -H "X-Requested-By: cli" \
    -H "Authorization: Basic $(echo -n $USERNAME:$PASSWORD | base64)" \
    -d '{
        "title": "Syslog UDP Input",
        "type": "org.graylog2.inputs.syslog.udp.SyslogUDPInput",
        "global": true,
        "configuration": {
            "bind_address": "0.0.0.0",
            "port": 1514
        }
    }'

# Create GELF UDP Input
echo "Creating GELF UDP Input..."
curl -s -X POST "$GRAYLOG_URL/api/system/inputs" \
    -H "Content-Type: application/json" \
    -H "X-Requested-By: cli" \
    -H "Authorization: Basic $(echo -n $USERNAME:$PASSWORD | base64)" \
    -d '{
        "title": "GELF UDP Input",
        "type": "org.graylog2.inputs.gelf.udp.GELFUDPInput",
        "global": true,
        "configuration": {
            "bind_address": "0.0.0.0",
            "port": 12201
        }
    }'

# Create Syslog TCP Input
echo "Creating Syslog TCP Input..."
curl -s -X POST "$GRAYLOG_URL/api/system/inputs" \
    -H "Content-Type: application/json" \
    -H "X-Requested-By: cli" \
    -H "Authorization: Basic $(echo -n $USERNAME:$PASSWORD | base64)" \
    -d '{
        "title": "Syslog TCP Input",
        "type": "org.graylog2.inputs.syslog.tcp.SyslogTCPInput",
        "global": true,
        "configuration": {
            "bind_address": "0.0.0.0",
            "port": 1514
        }
    }'

echo "Graylog inputs configured successfully!"
echo "You can now access Graylog at: http://localhost:9000"
EOF

chmod +x configure-graylog.sh
print_success "Graylog configuration script created"

# Create test log sender
print_status "CREATING TEST LOG SENDER"

cat > test-log-sender.sh << 'EOF'
#!/bin/bash
# Test Log Sender
# Sends test logs to SIEM

SIEM_IP="localhost"
SIEM_PORT="1514"

echo "Sending test logs to SIEM..."

# Test syslog messages
echo "<134>$(date '+%b %d %H:%M:%S') $(hostname) test: This is a test message from $(hostname)" | nc -u $SIEM_IP $SIEM_PORT

echo "<130>$(date '+%b %d %H:%M:%S') $(hostname) security: Authentication failure for user admin" | nc -u $SIEM_IP $SIEM_PORT

echo "<131>$(date '+%b %d %H:%M:%S') $(hostname) sshd: Failed password for invalid user test from 192.168.1.100" | nc -u $SIEM_IP $SIEM_PORT

echo "<132>$(date '+%b %d %H:%M:%S') $(hostname) laravel: Unauthorized access attempt to /admin/users" | nc -u $SIEM_IP $SIEM_PORT

echo "Test logs sent to SIEM!"
echo "Check Graylog interface to see the logs."
EOF

chmod +x test-log-sender.sh
print_success "Test log sender created"

# Create monitoring script
print_status "CREATING MONITORING SCRIPT"

cat > monitor-siem.sh << 'EOF'
#!/bin/bash
# SIEM Monitoring Script
# Monitors SIEM services and logs

echo "=== SIEM STATUS ==="
docker-compose ps

echo ""
echo "=== GRAYLOG LOGS ==="
docker-compose logs --tail=20 graylog

echo ""
echo "=== ELASTICSEARCH LOGS ==="
docker-compose logs --tail=20 elasticsearch

echo ""
echo "=== LOGSTASH LOGS ==="
docker-compose logs --tail=20 logstash

echo ""
echo "=== CONTAINER RESOURCE USAGE ==="
docker stats --no-stream

echo ""
echo "=== DISK USAGE ==="
df -h

echo ""
echo "=== MEMORY USAGE ==="
free -h
EOF

chmod +x monitor-siem.sh
print_success "Monitoring script created"

# Show summary
echo ""
print_status "SIEM STARTUP SUMMARY"
print_success "SIEM containers started"
print_success "Graylog configuration script created"
print_success "Test log sender created"
print_success "Monitoring script created"

echo ""
print_status "NEXT STEPS"
echo "1. Wait 2-3 minutes for all services to fully start"
echo "2. Run: ./configure-graylog.sh (to configure inputs)"
echo "3. Access Graylog at: http://localhost:9000"
echo "4. Run: ./test-log-sender.sh (to send test logs)"
echo "5. Run: ./monitor-siem.sh (to monitor services)"

echo ""
print_status "USEFUL COMMANDS"
echo "View logs: docker-compose logs -f"
echo "Stop SIEM: docker-compose down"
echo "Restart SIEM: docker-compose restart"
echo "Update SIEM: docker-compose pull && docker-compose up -d"

echo ""
print_success "SIEM CENTRAL STARTED SUCCESSFULLY!"
print_success "🎯 Ready for log collection and analysis! 🎯" 