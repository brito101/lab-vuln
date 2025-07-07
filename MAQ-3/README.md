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

### Build and start the container:
```bash
docker-compose up -d --build
```
- This will build the image (if needed) and start the container with all vulnerable services.

---

## 3. Managing the Machine

- **Check if it's running:**
  ```bash
  docker ps
  ```
- **Access the container shell:**
  ```bash
  docker exec -it maquina3-soc bash
  ```
- **View logs:**
  ```bash
  docker-compose logs -f
  ```
- **Stop the lab machine:**
  ```bash
  docker-compose down
  ```
- **Reset the environment (clean volumes and rebuild):**
  ```bash
  docker-compose down -v
  docker-compose up -d --build
  ```

---

## 4. Student Access (Service Ports)

- **SSH:**
  - `ssh -p 2222 root@<LAB_SERVER_IP>` (password: `toor`)
- **FTP:**
  - `ftp <LAB_SERVER_IP> 2121` (user: anonymous)
- **Samba:**
  - `smbclient -L <LAB_SERVER_IP> -p 2445` (user: smbuser, password: password123)
- **Syslog:**
  - SIEM tools can collect logs from port 2514

---

## 5. Services and Vulnerabilities

- **SSH:** Weak RSA key (1024 bits), root login enabled
- **FTP:** Anonymous access enabled, upload/download allowed
- **Samba:** Public share, weak permissions
- **Syslog:** Misconfigured, leaks credentials
- **Sensitive files:** Dumps, scripts, and backups in public locations

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
- If a port is already in use, change the external port in `docker-compose.yml`
- If the container keeps restarting, check logs:
  ```bash
  docker logs maquina3-soc
  ```
- If you need to update scripts/configurations, rebuild the container:
  ```bash
  docker-compose up -d --build
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