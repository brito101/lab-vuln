#!/bin/bash

echo "🔍 Testing LFI Vulnerability in MAQ-2 Lab Environment"
echo "=================================================="

# Check if containers are running
echo "📦 Checking container status..."
cd "$(dirname "$0")/trainees"
if docker-compose ps | grep -q "Up"; then
    echo "✅ Containers are running"
else
    echo "❌ Containers are not running. Please run: bash setup.sh"
    exit 1
fi

# Test basic connectivity
echo "🌐 Testing application connectivity..."
if curl -s -o /dev/null -w "%{http_code}" http://localhost:8000/ | grep -q "200"; then
    echo "✅ Application is accessible at http://localhost:8000"
else
    echo "❌ Application is not accessible"
    exit 1
fi

# Test routes
echo "🛣️  Testing vulnerable routes..."
echo "   - System File Viewer: http://localhost:8000/admin/system/file"
echo "   - System Log API: http://localhost:8000/admin/system/log"

# Check if routes exist
cd trainees
if ./vendor/bin/sail artisan route:list | grep -q "admin.system.file"; then
    echo "✅ LFI routes are registered"
else
    echo "❌ LFI routes are not found"
fi

echo ""
echo "🎯 LFI Vulnerability Test Instructions:"
echo "======================================"
echo ""
echo "1. Access the application: http://localhost:8000"
echo "2. Login with any user account"
echo "3. Edit your profile and change role to 'Administrador' or 'Programador'"
echo "4. Navigate to: Sistema → Visualizador de Arquivos"
echo "5. Test with these files:"
echo "   - /etc/passwd"
echo "   - /proc/version"
echo "   - /var/log/apache2/access.log"
echo ""
echo "🔗 Direct API testing:"
echo "curl 'http://localhost:8000/admin/system/log?file=/etc/passwd'"
echo ""
echo "📊 Log files to monitor:"
echo "- Laravel logs: storage/logs/laravel.log"
echo "- Web server logs: /var/log/apache2/access.log"
echo ""
echo "✅ LFI vulnerability is ready for lab use!" 