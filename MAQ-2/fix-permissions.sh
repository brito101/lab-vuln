#!/bin/bash

# Fix File Permissions Script
# This script fixes common permission issues in Laravel/Sail

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

echo "🔧 Fixing file permissions..."

# Check if we're in the right directory
if [ ! -f "deploy.sh" ]; then
    print_error "Please run this script from the MAQ-2 directory"
    exit 1
fi

# Check if Sail exists
if [ ! -f "./vendor/bin/sail" ]; then
    print_error "Sail not found. Please run composer install first."
    exit 1
fi

# Step 1: Fix ownership
print_status "Fixing file ownership..."
./vendor/bin/sail exec laravel.test chown -R sail:sail /var/www/html
print_success "Ownership fixed"

# Step 2: Fix directory permissions
print_status "Fixing directory permissions..."
./vendor/bin/sail exec laravel.test find /var/www/html -type d -exec chmod 755 {} \;
print_success "Directory permissions fixed"

# Step 3: Fix file permissions
print_status "Fixing file permissions..."
./vendor/bin/sail exec laravel.test find /var/www/html -type f -exec chmod 644 {} \;
print_success "File permissions fixed"

# Step 4: Fix specific Laravel directories
print_status "Fixing Laravel specific permissions..."
./vendor/bin/sail exec laravel.test chmod -R 775 storage
./vendor/bin/sail exec laravel.test chmod -R 775 bootstrap/cache
./vendor/bin/sail exec laravel.test chmod 666 .env
print_success "Laravel specific permissions fixed"

# Step 5: Make artisan executable
print_status "Making artisan executable..."
./vendor/bin/sail exec laravel.test chmod +x artisan
print_success "Artisan is now executable"

print_success "🎉 File permissions fixed!"
print_status "You can now run Laravel commands without permission issues." 