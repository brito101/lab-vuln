#!/bin/bash

# MAQ-2 Prepare Deploy Package Script
# This script creates a clean package for deployment without vendor, node_modules, etc.

set -e

echo "📦 Preparing MAQ-2 deployment package..."

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

# Check if we're in the right directory
if [ ! -f "deploy.sh" ]; then
    print_error "Please run this script from the MAQ-2 directory"
    exit 1
fi

# Create temporary directory for clean package
TEMP_DIR="maq2-deploy-$(date +%Y%m%d-%H%M%S)"
print_status "Creating temporary directory: $TEMP_DIR"
mkdir -p "$TEMP_DIR"

# Copy Laravel application files (excluding vendor, node_modules, etc.)
print_status "Copying Laravel application files..."

# Essential Laravel directories and files
LARAVEL_FILES=(
    "app/"
    "bootstrap/"
    "config/"
    "database/"
    "lang/"
    "public/"
    "resources/"
    "routes/"
    "storage/"
    "tests/"
    "artisan"
    "composer.json"
    "composer.lock"
    "package.json"
    "package-lock.json"
    "webpack.mix.js"
    "phpunit.xml"
    ".editorconfig"
    ".gitattributes"
    ".gitignore"
    ".styleci.yml"
    "Dockerfile"
    "docker-compose.yml"
    "server.php"
)

# Copy each file/directory
for item in "${LARAVEL_FILES[@]}"; do
    if [ -e "trainees/$item" ]; then
        print_status "Copying $item..."
        cp -r "trainees/$item" "$TEMP_DIR/"
    else
        print_warning "File/directory $item not found, skipping..."
    fi
done

# Copy deployment script
print_status "Copying deployment script..."
cp "deploy.sh" "$TEMP_DIR/"

# Make deploy script executable
chmod +x "$TEMP_DIR/deploy.sh"

# Copy other MAQ-2 specific files
print_status "Copying MAQ-2 specific files..."
MAQ2_FILES=(
    "README.md"
    "default-credentials.md"
    "configure-syslog.sh"
    "reset-laravel.sh"
    "setup.sh"
    "VULNERABILITIES_SUMMARY.md"
    "LFI_CORRECTIONS.md"
    "test_lfi_manual.md"
    "test_lfi.sh"
    "lfi_exploit_examples.md"
)

for file in "${MAQ2_FILES[@]}"; do
    if [ -f "$file" ]; then
        cp "$file" "$TEMP_DIR/"
    fi
done

# Create .env.example if it doesn't exist
if [ ! -f "$TEMP_DIR/.env.example" ]; then
    print_status "Creating .env.example file..."
    cat > "$TEMP_DIR/.env.example" << 'EOF'
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

# Sail Configuration
WWWGROUP=1000
WWWUSER=1000
SAIL_XDEBUG_MODE=off
SAIL_XDEBUG_CONFIG=client_host=host.docker.internal
APP_PORT=80
VITE_PORT=5173
HTTP_PORT=8000
SSL_PORT=443
FORWARD_DB_PORT=3306
FORWARD_REDIS_PORT=6379
FORWARD_MEILISEARCH_PORT=7700
FORWARD_MAILPIT_PORT=1025
FORWARD_MAILPIT_DASHBOARD_PORT=8025
EOF
fi

# Create deployment instructions
print_status "Creating deployment instructions..."
cat > "$TEMP_DIR/DEPLOYMENT_INSTRUCTIONS.md" << 'EOF'
# MAQ-2 Deployment Instructions

## Quick Deploy

1. **Extract the package:**
   ```bash
   tar -xzf maq2-deploy.tar.gz
   cd maq2-deploy-*
   ```

2. **Run the deployment script:**
   ```bash
   chmod +x deploy.sh
   ./deploy.sh
   ```

## Manual Deploy (if needed)

1. **Navigate to the Laravel directory:**
   ```bash
   cd trainees
   ```

2. **Set up environment:**
   ```bash
   cp .env.example .env
   ```

3. **Install dependencies:**
   ```bash
   composer install
   npm install
   ```

4. **Start containers:**
   ```bash
   ./vendor/bin/sail up -d
   ```

5. **Configure Laravel:**
   ```bash
   ./vendor/bin/sail artisan key:generate
   ./vendor/bin/sail artisan storage:link
   ./vendor/bin/sail artisan migrate --seed
   ```

## Access Information

- **Application:** http://localhost:80
- **Database:** localhost:3306
- **Mailpit:** http://localhost:8025
- **Redis:** localhost:6379

## Default Credentials

- **Admin:** admin/admin123
- **User:** user/password123

## Vulnerabilities (Intentional)

- `.env` file exposed at http://localhost:80/.env
- Debug mode enabled
- Storage permissions set to 777

## Troubleshooting

### Docker Issues:
- Ensure Docker and Docker Compose are installed
- Check if containers are running: `docker compose ps`
- View logs: `docker compose logs`

### Network Issues:
- Ensure the machine has internet access for Docker images
- Check firewall settings if containers can't start
EOF

# Create a .gitignore for the deployment package
cat > "$TEMP_DIR/.gitignore" << 'EOF'
# Laravel
/node_modules
/public/hot
/public/storage
/storage/*.key
/vendor
.env
.env.backup
.phpunit.result.cache
docker-compose.override.yml
Homestead.json
Homestead.yaml
npm-debug.log
yarn-error.log
/.idea
/.vscode
credentials.txt

# Deployment specific
*.log
*.tmp
.DS_Store
Thumbs.db
EOF

# Create the final package
PACKAGE_NAME="maq2.tar.gz"
print_status "Creating deployment package: $PACKAGE_NAME"
tar -czf "$PACKAGE_NAME" "$TEMP_DIR"

# Clean up temporary directory
print_status "Cleaning up temporary directory..."
rm -rf "$TEMP_DIR"

# Display package information
PACKAGE_SIZE=$(du -h "$PACKAGE_NAME" | cut -f1)
print_success "🎉 Deployment package created successfully!"

echo ""
echo "📦 Package Information:"
echo "   • Package: $PACKAGE_NAME"
echo "   • Size: $PACKAGE_SIZE"
echo "   • Location: $(pwd)/$PACKAGE_NAME"
echo ""
echo "📋 Package Contents:"
echo "   • Laravel application (without vendor/node_modules)"
echo "   • Docker configuration"
echo "   • Deployment script (deploy.sh)"
echo "   • Documentation and instructions"
echo "   • MAQ-2 specific files"
echo ""
echo "🚀 Next Steps:"
echo "   1. Transfer $PACKAGE_NAME to your target server"
echo "   2. Extract: tar -xzf $PACKAGE_NAME"
echo "   3. Run: ./deploy.sh"
echo ""
echo "💡 Benefits of this approach:"
echo "   • Lightweight package (~10-50MB vs ~500MB+ with vendor)"
echo "   • Clean dependencies (installed fresh on target)"
echo "   • No broken symlinks"
echo "   • Compatible with different environments"
echo ""

print_status "Package is ready for deployment!" 