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