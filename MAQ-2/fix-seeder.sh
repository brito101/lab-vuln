#!/bin/bash

# Fix Seeder Issues Script
# This script fixes seeder problems and adds missing environment variables

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

echo "🔧 Fixing seeder issues..."

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

# Step 1: Add missing environment variables to .env
print_status "Adding missing environment variables to .env..."
if [ -f ".env" ]; then
    # Check if variables already exist
    if ! grep -q "PROGRAMMER_EMAIL" .env; then
        echo "" >> .env
        echo "# User Seeder Variables" >> .env
        echo "PROGRAMMER_EMAIL=programador@estagio.com" >> .env
        echo "PROGRAMMER_PASSWD=12345678" >> .env
        echo "ADMIN_EMAIL=admin@estagio.com" >> .env
        echo "ADMIN_PASSWD=12345678" >> .env
        print_success "Environment variables added"
    else
        print_warning "Environment variables already exist"
    fi
else
    print_error ".env file not found"
    exit 1
fi

# Step 2: Clear cache
print_status "Clearing Laravel cache..."
./vendor/bin/sail artisan config:clear
./vendor/bin/sail artisan cache:clear
print_success "Cache cleared"

# Step 3: Run migrations and seed
print_status "Running migrations and seed..."
./vendor/bin/sail artisan migrate:fresh --seed
print_success "Database seeded successfully"

print_success "🎉 Seeder issues fixed!"
print_status "The application should now work without seeder errors." 