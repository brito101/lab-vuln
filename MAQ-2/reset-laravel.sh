#!/bin/bash
# Reset Laravel Machine - MAQ-2
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

print_status "RESET LARAVEL MACHINE - MAQ-2"
echo "This script will reset the Laravel machine to initial state"
echo ""

print_warning "⚠️  WARNING: This will reset Laravel machine to initial state!"
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
if [[ $EUID -ne 0 ]]; then
   print_error "This script must be run as root"
   exit 1
fi

# Create log file
LOG_FILE="laravel-reset-$(date +%Y%m%d-%H%M%S).log"
echo "Laravel Reset Log" > $LOG_FILE
echo "Date: $(date)" >> $LOG_FILE
echo "Machine: MAQ-2 (Laravel)" >> $LOG_FILE
echo "User: $(whoami)" >> $LOG_FILE
echo "" >> $LOG_FILE

print_status "RESET CONFIGURATION"
echo "Target: Laravel Web Application (MAQ-2)"
echo "Actions: Reset logs, configurations, and data"
echo ""

# Function to reset Docker containers
function reset_docker_containers() {
    print_status "RESETTING DOCKER CONTAINERS"
    
    if [[ -f "docker-compose.yml" ]]; then
        print_warning "Stopping Laravel containers..."
        docker-compose down --volumes --remove-orphans 2>/dev/null || true
        docker-compose rm -f 2>/dev/null || true
        print_success "Docker containers reset"
        echo "Docker containers reset" >> $LOG_FILE
    else
        print_warning "Docker compose file not found"
    fi
}

# Function to reset Laravel application
function reset_laravel_app() {
    print_status "RESETTING LARAVEL APPLICATION"
    
    # Remove Laravel logs
    print_warning "Removing Laravel logs..."
    rm -rf storage/logs/*.log 2>/dev/null || true
    rm -rf storage/logs/laravel-siem.conf 2>/dev/null || true
    echo "Removed Laravel logs" >> $LOG_FILE
    
    # Clear Laravel cache
    print_warning "Clearing Laravel cache..."
    rm -rf bootstrap/cache/* 2>/dev/null || true
    rm -rf storage/framework/cache/* 2>/dev/null || true
    rm -rf storage/framework/sessions/* 2>/dev/null || true
    rm -rf storage/framework/views/* 2>/dev/null || true
    echo "Cleared Laravel cache" >> $LOG_FILE
    
    # Reset Laravel configuration
    print_warning "Resetting Laravel configuration..."
    if [[ -f ".env.backup" ]]; then
        cp .env.backup .env 2>/dev/null || true
        echo "Restored .env from backup" >> $LOG_FILE
    fi
    
    # Remove uploaded files
    print_warning "Removing uploaded files..."
    rm -rf storage/app/public/uploads/* 2>/dev/null || true
    rm -rf public/uploads/* 2>/dev/null || true
    echo "Removed uploaded files" >> $LOG_FILE
    
    print_success "Laravel application reset"
}

# Function to reset database
function reset_database() {
    print_status "RESETTING DATABASE"
    
    # Reset MySQL data
    print_warning "Resetting MySQL data..."
    docker-compose down --volumes 2>/dev/null || true
    docker volume rm $(docker volume ls -q | grep mysql) 2>/dev/null || true
    echo "Reset MySQL data" >> $LOG_FILE
    
    # Reset database migrations
    print_warning "Resetting database migrations..."
    rm -f database/migrations/*_create_users_table.php 2>/dev/null || true
    rm -f database/migrations/*_create_password_resets_table.php 2>/dev/null || true
    echo "Reset database migrations" >> $LOG_FILE
    
    print_success "Database reset"
}

# Function to reset web server
function reset_web_server() {
    print_status "RESETTING WEB SERVER"
    
    # Reset Nginx configuration
    print_warning "Resetting Nginx configuration..."
    if [[ -f "/etc/nginx/sites-available/laravel" ]]; then
        rm -f /etc/nginx/sites-available/laravel 2>/dev/null || true
        rm -f /etc/nginx/sites-enabled/laravel 2>/dev/null || true
        echo "Reset Nginx configuration" >> $LOG_FILE
    fi
    
    # Reset Apache configuration
    print_warning "Resetting Apache configuration..."
    if [[ -f "/etc/apache2/sites-available/laravel.conf" ]]; then
        rm -f /etc/apache2/sites-available/laravel.conf 2>/dev/null || true
        rm -f /etc/apache2/sites-enabled/laravel.conf 2>/dev/null || true
        echo "Reset Apache configuration" >> $LOG_FILE
    fi
    
    # Restart web servers
    print_warning "Restarting web servers..."
    systemctl restart nginx 2>/dev/null || true
    systemctl restart apache2 2>/dev/null || true
    echo "Restarted web servers" >> $LOG_FILE
    
    print_success "Web server reset"
}

# Function to reset SIEM configurations
function reset_siem_configurations() {
    print_status "RESETTING SIEM CONFIGURATIONS"
    
    # Remove rsyslog configuration
    print_warning "Removing rsyslog configuration..."
    rm -f /etc/rsyslog.d/30-laravel.conf 2>/dev/null || true
    systemctl restart rsyslog 2>/dev/null || true
    echo "Removed rsyslog configuration" >> $LOG_FILE
    
    # Remove log forwarding service
    print_warning "Removing log forwarding service..."
    systemctl stop laravel-log-forwarder.service 2>/dev/null || true
    systemctl disable laravel-log-forwarder.service 2>/dev/null || true
    rm -f /etc/systemd/system/laravel-log-forwarder.service 2>/dev/null || true
    rm -f /usr/local/bin/laravel-log-forwarder.sh 2>/dev/null || true
    systemctl daemon-reload 2>/dev/null || true
    echo "Removed log forwarding service" >> $LOG_FILE
    
    # Remove log monitoring script
    print_warning "Removing log monitoring script..."
    rm -f /usr/local/bin/monitor-laravel-logs.sh 2>/dev/null || true
    echo "Removed log monitoring script" >> $LOG_FILE
    
    print_success "SIEM configurations reset"
}

# Function to reset PHP configurations
function reset_php_configurations() {
    print_status "RESETTING PHP CONFIGURATIONS"
    
    # Reset PHP error logs
    print_warning "Resetting PHP error logs..."
    rm -f /var/log/php*.log 2>/dev/null || true
    rm -f /var/log/php-fpm*.log 2>/dev/null || true
    echo "Reset PHP error logs" >> $LOG_FILE
    
    # Reset PHP sessions
    print_warning "Resetting PHP sessions..."
    rm -rf /var/lib/php/sessions/* 2>/dev/null || true
    echo "Reset PHP sessions" >> $LOG_FILE
    
    # Restart PHP services
    print_warning "Restarting PHP services..."
    systemctl restart php*-fpm 2>/dev/null || true
    echo "Restarted PHP services" >> $LOG_FILE
    
    print_success "PHP configurations reset"
}

# Function to clean temporary files
function clean_temporary_files() {
    print_status "CLEANING TEMPORARY FILES"
    
    # Remove temporary files
    print_warning "Removing temporary files..."
    rm -f *.log 2>/dev/null || true
    rm -f *.tmp 2>/dev/null || true
    rm -f *.cache 2>/dev/null || true
    echo "Removed temporary files" >> $LOG_FILE
    
    # Remove backup files
    print_warning "Removing backup files..."
    rm -f *.backup 2>/dev/null || true
    rm -f *.bak 2>/dev/null || true
    echo "Removed backup files" >> $LOG_FILE
    
    # Clean Composer cache
    print_warning "Cleaning Composer cache..."
    composer clear-cache 2>/dev/null || true
    echo "Cleaned Composer cache" >> $LOG_FILE
    
    print_success "Temporary files cleaned"
}

# Function to create reset verification
function create_reset_verification() {
    print_status "CREATING RESET VERIFICATION"
    
    # Create reset verification file
    cat > laravel-reset-verification-$(date +%Y%m%d-%H%M%S).md << EOF
# Laravel Reset Verification - MAQ-2

## Reset Details
- **Date**: $(date)
- **Machine**: MAQ-2 (Laravel)
- **User**: $(whoami)
- **Log File**: $LOG_FILE

## Reset Actions Performed
- [x] Docker containers stopped and removed
- [x] Laravel application reset
- [x] Database reset
- [x] Web server configurations reset
- [x] SIEM configurations removed
- [x] PHP configurations reset
- [x] Temporary files cleaned

## Verification Steps
1. **Check Docker**: \`docker ps -a\`
2. **Check Laravel**: \`php artisan --version\`
3. **Check Web Server**: \`systemctl status nginx\` or \`systemctl status apache2\`
4. **Check PHP**: \`php -v\`
5. **Check Logs**: \`ls -la storage/logs/\`

## Next Steps
1. Restart containers: \`docker-compose up -d\`
2. Reconfigure SIEM forwarding
3. Run Laravel setup scripts
4. Begin new training session

## Notes
- Laravel machine reset to initial state
- Ready for new training session
- Backup any important data before reset
EOF

    print_success "Reset verification file created"
}

# Main reset process
print_status "STARTING LARAVEL RESET"

# 1. Reset Docker containers
reset_docker_containers

# 2. Reset Laravel application
reset_laravel_app

# 3. Reset database
reset_database

# 4. Reset web server
reset_web_server

# 5. Reset SIEM configurations
reset_siem_configurations

# 6. Reset PHP configurations
reset_php_configurations

# 7. Clean temporary files
clean_temporary_files

# 8. Create reset verification
create_reset_verification

# Summary
echo ""
print_status "RESET SUMMARY"
print_success "✅ Docker containers reset"
print_success "✅ Laravel application reset"
print_success "✅ Database reset"
print_success "✅ Web server reset"
print_success "✅ SIEM configurations reset"
print_success "✅ PHP configurations reset"
print_success "✅ Temporary files cleaned"
print_success "✅ Reset verification created"

echo ""
print_status "NEXT STEPS"
echo "1. Restart containers: docker-compose up -d"
echo "2. Reconfigure SIEM forwarding"
echo "3. Run Laravel setup scripts"
echo "4. Begin new training session"

echo ""
print_status "VERIFICATION COMMANDS"
echo "Check Docker: docker ps -a"
echo "Check Laravel: php artisan --version"
echo "Check Web Server: systemctl status nginx"
echo "Check PHP: php -v"
echo "Check Logs: ls -la storage/logs/"

echo ""
print_success "🎯 LARAVEL MACHINE RESET COMPLETED SUCCESSFULLY!"
print_success "Ready for new training session!" 