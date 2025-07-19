# MAQ-3 - Linux Debian (Infrastructure/File Server) - Vulnerable Machine

This machine is part of the Lab and is intentionally vulnerable for cybersecurity training, incident response, and SOC exercises.

---

## ⚠️ IMPORTANT WARNING
**This container is intentionally vulnerable!**
- Do **NOT** use in production environments
- Do **NOT** expose to the public internet
- Use **ONLY** in isolated, controlled lab environments

---

## 1. Prerequisites
- Docker and Docker Compose installed
- At least 4GB RAM available
- Isolated network environment (lab network)
- Clone or copy the directory to your lab server

---

## 2. How to Start the Vulnerable Machine

### Access the machine directory:
```bash
cd MAQ-3
```

### Option 1: Using the optimized deploy script (Recommended)
```bash
# Build the Docker image with all vulnerabilities configured
./deploy.sh build

# Start the container with automatic port detection
./deploy.sh run

# Check status and logs
./deploy.sh status
./deploy.sh logs

# Stop the container
./deploy.sh stop

# Clean everything (containers, images, networks)
./deploy.sh clean

# Full cleanup including Docker system prune
./deploy.sh clean full
```

### Option 2: Using Docker Compose (Legacy)
```bash
docker-compose up -d --build
```
- This will build the image (if needed) and start the container with all vulnerable services.

---

## 3. Managing the Machine

### Using the deploy script (Recommended):
- **Check if it's running:**
  ```bash
  ./deploy.sh status
  ```
- **Access the container shell:**
  ```bash
  docker exec -it maquina3 bash
  ```
- **View logs:**
  ```bash
  ./deploy.sh logs
  ```
- **Stop the lab machine:**
  ```bash
  ./deploy.sh stop
  ```
- **Restart the container:**
  ```bash
  ./deploy.sh restart
  ```
- **Reset the environment (clean everything and rebuild):**
  ```bash
  ./deploy.sh clean full
  ./deploy.sh build
  ./deploy.sh run
  ```

### Using Docker commands directly:
- **Check if it's running:**
  ```bash
  docker ps
  ```
- **Access the container shell:**
  ```bash
  docker exec -it maquina3 bash
  ```
- **View logs:**
  ```bash
  docker logs -f maquina3
  ```
- **Stop the lab machine:**
  ```bash
  docker stop maquina3
  docker rm maquina3
  ```

---

## 4. Student Access (Service Ports)

The deploy script automatically detects port conflicts and uses alternative ports if needed.

### Default Ports (if available):
- **SSH:**
  - `ssh -p 22 root@<LAB_SERVER_IP>` (password: `toor`)
  - `ssh -p 22 ftpuser@<LAB_SERVER_IP>` (password: `password123`)
- **FTP:**
  - `ftp <LAB_SERVER_IP> -p 21` (user: anonymous)
- **Samba:**
  - `smbclient -L //<LAB_SERVER_IP> -U anonymous`
  - `smbclient -L //<LAB_SERVER_IP> -U smbuser` (password: password123)
- **Syslog:**
  - SIEM tools can collect logs from port 514

### Alternative Ports (if default ports are in use):
- **SSH:** Port 2222
- **FTP:** Port 2121

### Check actual ports in use:
```bash
./deploy.sh status
```

---

## 5. Services and Vulnerabilities

### Configured Vulnerabilities:
- **SSH:** Weak RSA key (1024 bits), root login enabled, weak passwords
- **FTP:** Anonymous access enabled, upload/download allowed, public directory
- **Samba:** Public share, weak permissions, guest access enabled
- **Syslog:** Misconfigured, leaks credentials in logs
- **Sensitive files:** Dumps, scripts, and backups in public locations

### Vulnerable Files and Directories:
- `/opt/vulnerable_files/dumps/` - Password dumps, database configs
- `/var/ftp/pub/` - Public FTP directory with sensitive files
- `/var/samba/public/` - Public Samba share with dumps
- `/var/log/ssh_credentials.log` - Logs with leaked credentials
- `/var/log/commands.log` - Command execution logs
- `/var/log/debug.log` - Debug logs with sensitive information

### Attack Vectors:
- **SSH Brute Force:** Weak passwords and RSA key
- **FTP Anonymous Access:** File upload/download capabilities
- **Samba Enumeration:** Public shares with sensitive data
- **Log Analysis:** Credential leakage in syslog
- **File Exfiltration:** Sensitive files accessible via multiple protocols

---

## 6. Security Recommendations
- **Never** expose these ports to the internet
- Use only in a controlled lab network
- After each class/session, run `docker-compose down` to reset
- To restore to the initial state, use:
  ```bash
  docker-compose down -v
  docker-compose up -d --build
  ```

---

## 7. Troubleshooting

### Port Conflicts:
- The deploy script automatically detects port conflicts and uses alternative ports
- If you get port binding errors, run:
  ```bash
  ./deploy.sh clean full
  ./deploy.sh run
  ```

### Container Issues:
- If the container keeps restarting, check logs:
  ```bash
  ./deploy.sh logs
  ```
- If you need to update scripts/configurations, rebuild the container:
  ```bash
  ./deploy.sh clean
  ./deploy.sh build
  ./deploy.sh run
  ```

### Build Issues:
- If build fails due to missing packages, ensure you have internet access
- If SSH key generation fails, the script will retry automatically
- If user creation fails, the script handles existing users gracefully

### Network Issues:
- If container can't connect to network, check Docker network:
  ```bash
  docker network ls
  docker network inspect soc-network
  ```

---

## 8. Customization & Replication
- To create more machines, copy this directory and adapt scripts/configurations as needed
- Each machine can have its own `docker-compose.yml` and scripts
- You can orchestrate multiple machines with a root-level `docker-compose.yml` if desired

---

## 9. Default Users & Passwords
- **root:** toor
- **ftpuser:** password123
- **smbuser:** password123

---

## 10. For Instructors
- Provide students with the correct IP and port mapping
- Monitor logs and network activity for detection exercises
- Reset the environment between classes for a clean start

---

**This machine is for educational purposes only. Use responsibly!** 