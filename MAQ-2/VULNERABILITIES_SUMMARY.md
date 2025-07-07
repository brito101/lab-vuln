# Vulnerabilities Summary - MAQ-2 Lab Environment

This document summarizes all intentionally implemented vulnerabilities in the Laravel lab environment.

## 🚨 Intentionally Vulnerable Features

### 1. **Local File Inclusion (LFI)**
- **Location**: Admin panel → Sistema → Visualizador de Arquivos
- **Endpoint**: `http://localhost:8000/admin/system/file`
- **API Endpoint**: `http://localhost:8000/admin/system/log`
- **Vulnerability**: Allows reading any file on the server
- **Exploitation**: 
  - Change role to "Administrador" or "Programador"
  - Access `/admin/system/file?file=/etc/passwd`
  - Read system files, logs, configurations

### 2. **Role Escalation**
- **Location**: User profile editing
- **Vulnerability**: Users can change their role to "Administrador" or "Programador"
- **Impact**: Grants access to admin-only features including LFI

### 3. **Exposed .env File**
- **Location**: `http://localhost:8000/.env`
- **Vulnerability**: Environment variables are accessible
- **Exposed Data**: Database credentials, APP_KEY, mail settings

### 4. **Unrestricted File Upload**
- **Location**: Document upload functionality
- **Vulnerability**: No file type validation
- **Impact**: Can upload malicious files (PHP webshells, etc.)

### 5. **Incorrect Permissions**
- **Location**: `/storage` directory
- **Vulnerability**: World-writable permissions (chmod 777)
- **Impact**: Attackers can write arbitrary files

### 6. **Debug Mode Enabled**
- **Location**: `.env` file
- **Setting**: `APP_DEBUG=true`
- **Impact**: Detailed error messages expose system information

## 🔍 Attack Vectors

### Phase 1: Initial Access
1. Register/login as regular user
2. Exploit role escalation to gain admin privileges

### Phase 2: Reconnaissance
1. Use LFI to read system files
2. Access logs for information gathering
3. Read configuration files

### Phase 3: Exploitation
1. Upload malicious files via unrestricted upload
2. Use LFI to read sensitive files
3. Exploit incorrect permissions in `/storage`

## 📊 Detection Points

### Log Files to Monitor
- **Laravel Logs**: `storage/logs/laravel.log`
- **Web Server Logs**: `/var/log/apache2/access.log`
- **System Logs**: `/var/log/auth.log`

### Indicators of Compromise
- Access to `/admin/system/file` endpoint
- File read attempts via LFI
- Role changes in user profiles
- Unusual file uploads
- Access to sensitive system files

## 🎯 Lab Objectives

### For Students
1. **Identify Vulnerabilities**: Find and understand each vulnerability
2. **Exploit LFI**: Read system files like `/etc/passwd`
3. **Role Escalation**: Change user role to gain privileges
4. **File Upload**: Upload and execute malicious files
5. **Log Analysis**: Detect attack attempts in logs

### For Instructors
1. **Demonstrate Attack Chains**: Show how vulnerabilities combine
2. **Incident Response**: Practice detecting and responding to attacks
3. **Forensic Analysis**: Analyze logs and system artifacts
4. **Remediation**: Discuss how to fix each vulnerability

## 🛡️ Security Lessons

### What Not to Do (Lab Demonstrations)
- Never use `file_get_contents()` with user input
- Never allow role changes without proper validation
- Never expose environment files
- Never use world-writable permissions
- Never enable debug mode in production
- Never skip file upload validation

### Best Practices (Real World)
- Implement proper input validation
- Use role-based access control (RBAC)
- Secure environment configuration
- Apply principle of least privilege
- Validate all file uploads
- Disable debug mode in production

## 📝 Notes

- **Educational Purpose**: All vulnerabilities are intentional for learning
- **Controlled Environment**: Only use in isolated lab environments
- **Legal Compliance**: Ensure proper authorization for testing
- **Documentation**: Keep detailed logs of all testing activities

---

**⚠️ WARNING**: This environment contains intentionally vulnerable code. Do not deploy in production or expose to the internet. 