# Vulnerable Trainees Lab Environment (MAQ-2)

This environment is intentionally vulnerable for incident response and security training. **Do not use in production!**

## Services
- **Web Server:** Nginx (default) or Apache (optional)
- **Database:** MySQL
- **Application:** Trainees (Laravel-based, debug mode enabled)

## Vulnerabilities
- **Unrestricted File Upload:** No validation on file uploads.
- **Exposed `.env` file:** Sensitive environment variables are accessible.
- **Incorrect Permissions:** `/storage` directory is world-writable.
- **Debug Mode:** Laravel debug is enabled.
- **Local File Inclusion (LFI):** System file viewer allows reading any file on the server.
- **Role Escalation:** Users can change their role to "Administrador" or "Programador" in profile editing.

## Noise & Attack Simulation
- **C2 Agent:** Simulate a C2 agent in `/tmp` (see below).
- **Reconnaissance:** Use `nmap` and `gobuster` against the web server.
- **Detectable Logs:** Laravel and Nginx/Apache logs will capture attack payloads.

## Quick Start

### Automated Deployment
```bash
# Extract the deployment package
tar -xzf maq2.tar.gz
cd maq2-deploy-*

# Run the deployment script
./deploy.sh
```

### Manual Setup
```bash
cd MAQ-2
bash setup.sh
```

- Access the app at: [http://localhost:80](http://localhost:80)
- MySQL runs on port 3306 (default credentials in `.env`)

## Deployment

### Automated Deployment Package
The `maq2.tar.gz` package contains:
- Complete Trainees application (without vendor/node_modules)
- Docker configuration (Sail)
- Automated deployment script
- All necessary documentation

### Deployment Script Features
- ✅ Automatic dependency installation
- ✅ Docker container management
- ✅ Database setup and seeding
- ✅ Permission fixes
- ✅ Vulnerability creation for lab purposes
- ✅ Final verification and testing

### Default Credentials
- **Programador:** `programador@estagio.com` / `12345678`
- **Administrator:** `admin@estagio.com` / `12345678`
- **Franquiado 1:** `franquia1@estagio.com` / `12345678`
- **Franquiado 2:** `franquia2@estagio.com` / `12345678`
- **Franquiado 3:** `franquia3@estagio.com` / `12345678`
- **Estagiário:** `estagiario@estagio.com` / `12345678`

## Simulating Vulnerabilities

### 1. Unrestricted File Upload
- Locate the file upload feature in the app.
- Upload any file type (e.g., PHP webshell, image, etc.).
- No validation is enforced.

### 2. Exposed `.env`
- Access: [http://localhost:8000/.env](http://localhost:8000/.env)
- Sensitive data (DB credentials, APP_KEY, etc.) is exposed.

### 3. Incorrect Permissions
- The `/storage` directory is world-writable (`chmod 777`).
- Attackers can write arbitrary files.

### 4. Debug Mode
- Laravel debug is enabled in `.env` (`APP_DEBUG=true`).
- Detailed error messages are shown.

### 5. Local File Inclusion (LFI)
- Access the System menu in the admin panel.
- Use "Visualizador de Arquivos" to read any file on the server.
- Try reading Trainees logs, system files, or configuration files.
- The endpoint is: `http://localhost:80/admin/system/file?file=/var/www/html/storage/logs/laravel.log`
- API endpoint: `http://localhost:80/admin/system/log?file=/var/www/html/storage/logs/laravel.log`

### 6. Role Escalation
- Edit your user profile and change the role to "Administrador" or "Programador".
- This grants access to the vulnerable system endpoints.

## Simulating Noise & Attacks

### C2 Agent in `/tmp`
```bash
echo "while true; do curl http://malicious-c2-server/ping; sleep 60; done" > /tmp/c2.sh
chmod +x /tmp/c2.sh
nohup bash /tmp/c2.sh &
```

### Reconnaissance
- **Nmap:** `nmap -A localhost -p 80,3306`
- **Gobuster:** `gobuster dir -u http://localhost:80 -w /usr/share/wordlists/dirb/common.txt`

## Logs
- **Trainees logs:** `MAQ-2/trainees/storage/logs/`
- **Web server logs:** Inside the running container (e.g., `/var/log/nginx/`)
- Payloads and attacks will be visible in these logs.

## Notes
- This environment is for educational use only.
- All vulnerabilities are intentional and should not be remediated.
- For questions, contact the lab instructor. 