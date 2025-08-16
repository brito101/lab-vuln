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

echo "   - Configure MAQ-2: Run MAQ-2/configure-syslog.sh as root"
echo "   - Configure MAQ-3: Run MAQ-3/configure-syslog.sh as root"
echo "   - Send test logs: ./siem-central/test-log-sender.sh" 