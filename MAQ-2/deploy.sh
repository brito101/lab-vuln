#!/bin/bash

# MAQ-2 Trainees Application Deploy Script
# This script deploys the vulnerable Trainees application using Docker/Sail

set -e

echo "🚀 Starting MAQ-2 Trainees Application Deployment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
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

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed (support both docker-compose and docker compose)
DOCKER_COMPOSE_AVAILABLE=false

# Check for docker-compose (legacy)
if command -v docker-compose &> /dev/null; then
    DOCKER_COMPOSE_AVAILABLE=true
    print_status "Found docker-compose (legacy)"
fi

# Check for docker compose (new format)
if docker compose version &> /dev/null; then
    DOCKER_COMPOSE_AVAILABLE=true
    print_status "Found docker compose (new format)"
fi

if [ "$DOCKER_COMPOSE_AVAILABLE" = false ]; then
    print_error "Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Navigate to the Trainees application directory
print_status "Navigating to Trainees application directory..."

# Check if we're already in the Trainees directory
if [ -f "composer.json" ]; then
    print_status "Already in Trainees application directory"
elif [ -d "trainees" ] && [ -f "trainees/composer.json" ]; then
    print_status "Navigating to trainees directory..."
    cd trainees
else
    print_error "Trainees application not found. Please run this script from MAQ-2 directory or Trainees application directory"
    exit 1
fi

print_success "Found Trainees application"

# Step 1: Copy environment file
print_status "Setting up environment configuration..."
if [ -f ".env.example" ]; then
    cp .env.example .env
    print_success "Environment file created from .env.example"
else
    print_warning ".env.example not found, creating basic .env file"
    cat > .env << 'EOF'
APP_NAME=Laravel
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_URL=http://localhost

LOG_CHANNEL=stack
LOG_DEPRECATIONS_CHANNEL=null
LOG_LEVEL=debug

DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=sail
DB_PASSWORD=password

BROADCAST_DRIVER=log
CACHE_DRIVER=file
FILESYSTEM_DISK=local
QUEUE_CONNECTION=sync
SESSION_DRIVER=file
SESSION_LIFETIME=120

MEMCACHED_HOST=memcached

REDIS_HOST=redis
REDIS_PASSWORD=null
REDIS_PORT=6379

MAIL_MAILER=smtp
MAIL_HOST=mailpit
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS="hello@example.com"
MAIL_FROM_NAME="${APP_NAME}"

AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_DEFAULT_REGION=us-east-1
AWS_BUCKET=
AWS_USE_PATH_STYLE_ENDPOINT=false

PUSHER_APP_ID=
PUSHER_APP_KEY=
PUSHER_APP_SECRET=
PUSHER_HOST=
PUSHER_PORT=443
PUSHER_SCHEME=https
PUSHER_APP_CLUSTER=mt1

VITE_APP_NAME="${APP_NAME}"
VITE_PUSHER_APP_KEY="${PUSHER_APP_KEY}"
VITE_PUSHER_HOST="${PUSHER_HOST}"
VITE_PUSHER_PORT="${PUSHER_PORT}"
VITE_PUSHER_SCHEME="${PUSHER_SCHEME}"
VITE_PUSHER_APP_CLUSTER="${PUSHER_APP_CLUSTER}"
EOF
fi

# Step 2: Install Composer dependencies
print_status "Installing Composer dependencies..."
if command -v composer &> /dev/null; then
    composer install --no-interaction --prefer-dist --optimize-autoloader --dev
    print_success "Composer dependencies installed"
else
    print_warning "Composer not found locally, installing via Docker with PHP extensions"
    # Use Docker with PHP extensions to install dependencies
    docker run --rm -v $(pwd):/var/www/html -w /var/www/html \
        -e COMPOSER_ALLOW_SUPERUSER=1 \
        php:8.2-cli bash -c "
        apt-get update
        apt-get install -y git unzip libzip-dev libpng-dev libjpeg-dev libfreetype6-dev libonig-dev libxml2-dev libcurl4-openssl-dev libssl-dev
        docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd zip
        curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
        composer install --no-interaction --prefer-dist --optimize-autoloader --dev
        "
    print_success "Composer dependencies installed via Docker"
fi

# Step 3: Start Sail containers
print_status "Starting Docker containers with Sail..."
if [ -f "./vendor/bin/sail" ]; then
    ./vendor/bin/sail up -d
    print_success "Containers started"
else
    print_error "Sail not found. Please ensure composer install completed successfully."
    exit 1
fi

# Wait for containers to be ready
print_status "Waiting for containers to be ready..."
sleep 20

# Step 3.1: Ensure MySQL is running
print_status "Ensuring MySQL container is running..."
if ! ./vendor/bin/sail ps | grep -q mysql; then
    print_status "MySQL container not found, starting it..."
    ./vendor/bin/sail up -d mysql
    sleep 15
fi

# Step 3.2: Wait for MySQL to be fully ready
print_status "Waiting for MySQL to be fully ready..."
sleep 30

# Step 3.3: Fix MySQL permissions and restart if needed
print_status "Checking MySQL container status..."
if ! ./vendor/bin/sail ps | grep -q mysql; then
    print_status "MySQL container not running, starting it..."
    ./vendor/bin/sail up -d mysql
    sleep 20
fi

# Step 3.4: Restart MySQL container to fix connection issues
print_status "Restarting MySQL container to fix connection issues..."
./vendor/bin/sail restart mysql
sleep 15

# Step 3.5: Verify all containers are running
print_status "Verifying all containers are running..."
if ./vendor/bin/sail ps | grep -q "Up"; then
    print_success "All containers are running"
else
    print_warning "Some containers may not be running. Checking..."
    ./vendor/bin/sail ps
fi

# Wait for containers to be ready
print_status "Waiting for containers to be ready..."
sleep 10

# Step 4: Fix permissions before generating key
print_status "Fixing file permissions..."
./vendor/bin/sail exec laravel.test chown -R sail:sail /var/www/html
./vendor/bin/sail exec laravel.test chmod -R 755 /var/www/html
./vendor/bin/sail exec laravel.test chmod 666 .env
print_success "Permissions fixed"

# Step 5: Generate application key
print_status "Generating application key..."
./vendor/bin/sail artisan key:generate
print_success "Application key generated"

# Step 6: Create storage link
print_status "Creating storage link..."
./vendor/bin/sail artisan storage:link
print_success "Storage link created"

# Step 7: Wait for MySQL to be fully ready before migrations
print_status "Waiting for MySQL to be fully ready for migrations..."
sleep 15

# Step 8: Test database connection before migrations
print_status "Testing database connection..."
for i in {1..5}; do
    if ./vendor/bin/sail artisan tinker --execute="echo 'DB connection test successful';" 2>/dev/null; then
        print_success "Database connection successful"
        break
    else
        print_warning "Database connection attempt $i failed, retrying..."
        sleep 10
        if [ $i -eq 5 ]; then
            print_error "Database connection failed after 5 attempts"
            print_status "Trying to restart MySQL container..."
            ./vendor/bin/sail restart mysql
            sleep 20
        fi
    fi
done

# Step 9: Add missing environment variables for seeder
print_status "Adding missing environment variables for seeder..."
if [ -f ".env" ]; then
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
fi

# Step 10: Clear cache before migrations
print_status "Clearing Laravel cache..."
./vendor/bin/sail artisan config:clear
./vendor/bin/sail artisan cache:clear
print_success "Cache cleared"

# Step 11: Run database migrations and seed
print_status "Running database migrations and seeding..."
./vendor/bin/sail artisan migrate:fresh --seed
print_success "Database migrations and seeding completed"

# Step 12: Set vulnerable permissions (for lab purposes)
print_status "Setting vulnerable permissions for lab purposes..."
./vendor/bin/sail exec laravel.test chmod -R 777 storage
./vendor/bin/sail exec laravel.test chmod -R 777 bootstrap/cache
print_success "Vulnerable permissions set"

# Step 13: Copy .env to public directory (vulnerability for lab)
print_status "Creating vulnerability: copying .env to public directory..."
./vendor/bin/sail exec laravel.test cp .env public/.env
print_success ".env file exposed for lab purposes"

# Step 14: Install NPM dependencies (if package.json exists)
if [ -f "package.json" ]; then
    print_status "Installing NPM dependencies..."
    ./vendor/bin/sail npm install
    print_success "NPM dependencies installed"
fi

# Step 15: Build assets (if needed)
if [ -f "webpack.mix.js" ] || [ -f "vite.config.js" ]; then
    print_status "Building assets..."
    ./vendor/bin/sail npm run dev
    print_success "Assets built"
fi
fi

# Step 11: Display application information
print_success "🎉 MAQ-2 Laravel Application deployed successfully!"

echo ""
echo "📋 Application Information:"
echo "   • Application URL: http://localhost:80"
echo "   • Database: MySQL (localhost:3306)"
echo "   • Redis: localhost:6379"
echo "   • Mailpit: http://localhost:8025"
echo "   • Meilisearch: http://localhost:7700"
echo ""
echo "🔧 Useful Commands:"
echo "   • View logs: ./vendor/bin/sail logs"
echo "   • Access container: ./vendor/bin/sail shell"
echo "   • Stop containers: ./vendor/bin/sail down"
echo "   • Restart containers: ./vendor/bin/sail restart"
echo ""
echo "⚠️  VULNERABILITIES INTENTIONALLY PRESENT FOR LAB PURPOSES:"
echo "   • .env file exposed at http://localhost:80/.env"
echo "   • Debug mode enabled (APP_DEBUG=true)"
echo "   • Storage directory has 777 permissions"
echo ""
echo "🔐 Default Credentials:"
echo "   • Admin: admin/admin123"
echo "   • User: user/password123"
echo ""

# Step 16: Final verification
print_status "Performing final verification..."
sleep 5

# Check if containers are running
if ./vendor/bin/sail ps | grep -q "Up"; then
    print_success "All containers are running successfully!"
else
    print_warning "Some containers may not be running. Check with: ./vendor/bin/sail ps"
fi

# Test application access
print_status "Testing application access..."
if curl -s http://localhost:80 > /dev/null; then
    print_success "Application is accessible at http://localhost:80"
else
    print_warning "Application may not be accessible yet. Please wait a moment and try again."
fi

# Test database connection
print_status "Testing database connection..."
if ./vendor/bin/sail artisan tinker --execute="echo 'Database connection successful';" 2>/dev/null; then
    print_success "Database connection is working"
else
    print_warning "Database connection may need more time to establish"
fi

print_success "🎉 Deployment completed! The vulnerable Trainees application is ready for lab use." 