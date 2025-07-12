# Vulnerable API Routes - Security Laboratory

This document describes the vulnerable API routes created for security laboratory simulation.

## Overview

The routes below were created to simulate security vulnerabilities in authenticated APIs. They expose sensitive user information, including their roles/profiles, even though they are protected by authentication.

## Available Routes

### 1. Authentication
**Endpoint:** `POST /api/login`  
**Authentication:** Not required  
**Function:** Login and token generation

**Parameters:**
```json
{
    "email": "your@email.com",
    "password": "your_password"
}
```

**Example Response:**
```json
{
    "success": true,
    "message": "Login successful",
    "data": {
        "user": {
            "id": 1,
            "name": "John Silva",
            "email": "john@example.com",
            "role": "admin"
        },
        "token": "1|abc123...",
        "token_type": "Bearer",
        "expires_at": null
    }
}
```

### 2. Logout
**Endpoint:** `POST /api/logout`  
**Authentication:** Required (Sanctum)  
**Function:** Revokes current token

### 3. Authenticated User Information
**Endpoint:** `GET /api/me`  
**Authentication:** Required (Sanctum)  
**Function:** Returns authenticated user information

### 4. List All Users
**Endpoint:** `GET /api/users`  
**Authentication:** Required (Sanctum)  
**Vulnerability:** Exposes sensitive information from all users

**Example Response:**
```json
{
    "success": true,
    "message": "User list retrieved successfully",
    "data": {
        "users": [
            {
                "id": 1,
                "name": "John Silva",
                "email": "john@example.com",
                "role": "admin",
                "role_id": 1,
                "created_at": "2024-01-01T00:00:00.000000Z",
                "updated_at": "2024-01-01T00:00:00.000000Z",
                "telephone": "(11) 9999-9999",
                "cell": "(11) 8888-8888",
                "city": "São Paulo",
                "state": "SP",
                "company_id": 1,
                "affiliation_id": null
            }
        ],
        "total_users": 1,
        "timestamp": "2024-01-01T12:00:00.000000Z"
    }
}
```

### 5. Search User by ID
**Endpoint:** `GET /api/users/{id}`  
**Authentication:** Required (Sanctum)  
**Vulnerability:** Exposes sensitive information from specific user

**Example Response:**
```json
{
    "success": true,
    "message": "User found successfully",
    "data": {
        "id": 1,
        "name": "John Silva",
        "email": "john@example.com",
        "role": "admin",
        "role_id": 1,
        "created_at": "2024-01-01T00:00:00.000000Z",
        "updated_at": "2024-01-01T00:00:00.000000Z",
        "telephone": "(11) 9999-9999",
        "cell": "(11) 8888-8888",
        "city": "São Paulo",
        "state": "SP",
        "company_id": 1,
        "affiliation_id": null
    }
}
```

## How to Use

### 1. Authentication Methods

#### Option A: Token Authentication (API)
First, authenticate to get a token:

```bash
curl -X POST http://localhost:8000/api/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "your@email.com",
    "password": "your_password"
  }'
```

#### Option B: Session Authentication (Browser)
Simply login through the web interface and then access the API routes directly in your browser.

### 2. Access Routes

#### Using Token (API/curl)
```bash
# Check authenticated user information
curl -X GET http://localhost:8000/api/me \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -H "Accept: application/json"

# List all users
curl -X GET http://localhost:8000/api/users \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -H "Accept: application/json"

# Search specific user
curl -X GET http://localhost:8000/api/users/1 \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -H "Accept: application/json"

# Logout
curl -X POST http://localhost:8000/api/logout \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -H "Accept: application/json"
```

#### Using Session (Browser)
After logging in through the web interface, simply visit these URLs in your browser:

- `http://localhost:8000/api/me` - User information
- `http://localhost:8000/api/users` - All users (vulnerable)
- `http://localhost:8000/api/users/1` - Specific user (vulnerable)

The browser will display the JSON response, which you can view or copy.

## Simulated Vulnerabilities

### 1. Sensitive Information Exposure
- **Problem:** Routes expose personal information such as phone, city, state
- **Impact:** Privacy violation and potential malicious use of data

### 2. Role/Profile Exposure
- **Problem:** Reveals the profile type of each user (admin, user, etc.)
- **Impact:** Possible privilege escalation and targeted attacks

### 3. Lack of Access Control
- **Problem:** Any authenticated user can access other users' data
- **Impact:** Violation of the principle of least privilege

### 4. Business Information Exposure
- **Problem:** Exposes relationships with companies and affiliations
- **Impact:** Possible use for social engineering attacks

## Test Scenarios

### Scenario 1: User Enumeration
1. Login with a common account
2. Access `/api/users` to list all users
3. Identify users with administrative roles
4. Use this information for targeted attacks

### Scenario 2: Information Collection
1. Use `/api/users/{id}` to collect specific data
2. Combine information to create detailed profiles
3. Use data for social engineering attacks

### Scenario 3: Organizational Structure Analysis
1. Analyze `company_id` and `affiliation_id` fields
2. Map organizational structure
3. Identify entry points for attacks

## Recommended Protection Measures

1. **Implement Role-Based Access Control (RBAC)**
2. **Apply Principle of Least Privilege**
3. **Sanitize Response Data**
4. **Implement Rate Limiting**
5. **Audit Access and Logs**
6. **Use Tokens with Limited Scope**

## Related Files

- `app/Http/Controllers/Api/UserApiController.php` - Controller with vulnerable functions
- `routes/api.php` - Route definitions
- `app/Models/User.php` - User model with relationships

## Security Notice

⚠️ **WARNING:** These routes were created specifically for laboratory purposes and vulnerability demonstration. **NEVER** implement similar code in production environment. 