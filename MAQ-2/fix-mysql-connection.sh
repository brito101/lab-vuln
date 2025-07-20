#!/bin/bash

# Fix MySQL Connection Issues Script
# This script helps resolve common MySQL connection problems in Docker/Sail

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

echo "🔧 Fixing MySQL connection issues..."

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

# Step 1: Stop all containers
print_status "Stopping all containers..."
./vendor/bin/sail down
sleep 5

# Step 2: Remove MySQL container and volume
print_status "Removing MySQL container and volumes..."
docker volume ls | grep laravel_sail | awk '{print $2}' | xargs -r docker volume rm
sleep 3

# Step 3: Start containers fresh
print_status "Starting containers fresh..."
./vendor/bin/sail up -d
sleep 20

# Step 4: Wait for MySQL to be ready
print_status "Waiting for MySQL to be fully ready..."
sleep 30

# Step 5: Test database connection
print_status "Testing database connection..."
for i in {1..10}; do
    if ./vendor/bin/sail artisan tinker --execute="echo 'DB connection test successful';" 2>/dev/null; then
        print_success "Database connection successful on attempt $i"
        break
    else
        print_warning "Database connection attempt $i failed, retrying..."
        sleep 10
        if [ $i -eq 10 ]; then
            print_error "Database connection failed after 10 attempts"
            print_status "Showing container logs for debugging..."
            ./vendor/bin/sail logs mysql
            exit 1
        fi
    fi
done

# Step 6: Run migrations
print_status "Running database migrations..."
./vendor/bin/sail artisan migrate:fresh --seed
print_success "Database migrations completed successfully"

print_success "🎉 MySQL connection issues resolved!"
print_status "The application should now be working properly." 