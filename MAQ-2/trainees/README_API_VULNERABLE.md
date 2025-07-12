# Vulnerable API Routes - Implementation

## Implementation Summary

A system of vulnerable but authenticated API routes has been created for security laboratory simulation. The system allows any registered user to access sensitive information from all system users, including their roles/profiles.

## Created/Modified Files

### 1. API Controllers

#### `app/Http/Controllers/Api/UserApiController.php`
- **Function:** Main controller with vulnerable routes
- **Methods:**
  - `listUsers()`: Lists all users with their roles
  - `getUserById()`: Searches for specific user by ID
- **Vulnerabilities:** Exposes sensitive information such as phone, city, state, roles

#### `app/Http/Controllers/Api/AuthController.php`
- **Function:** API authentication controller
- **Methods:**
  - `login()`: Authentication and token generation
  - `logout()`: Revokes current token
  - `me()`: Authenticated user information

### 2. API Routes

#### `routes/api.php`
- **Authentication Routes:**
  - `POST /api/login`: Login and token generation
  - `POST /api/logout`: Logout and token revocation
  - `GET /api/me`: Authenticated user information

- **Vulnerable Routes:**
  - `GET /api/users`: Lists all users (vulnerable)
  - `GET /api/users/{id}`: Searches for specific user (vulnerable)

### 3. Documentation

#### `API_VULNERABLE_ROUTES.md`
- Complete route documentation
- Usage examples with curl
- Vulnerability analysis
- Test scenarios

#### `test_api_vulnerable.sh`
- Automated test script
- Practical vulnerability demonstration
- Security analysis

## Implemented Vulnerabilities

### 1. Sensitive Information Exposure
- **Problem:** Routes return personal data such as phone, city, state
- **Impact:** Privacy violation and potential malicious use

### 2. Role/Profile Exposure
- **Problem:** Reveals the profile type of each user (admin, user, etc.)
- **Impact:** Possible privilege escalation and targeted attacks

### 3. Lack of Access Control
- **Problem:** Any authenticated user can access other users' data
- **Impact:** Violation of the principle of least privilege

### 4. Business Information Exposure
- **Problem:** Exposes relationships with companies and affiliations
- **Impact:** Possible use for social engineering attacks

## How to Test

### 1. Using the Automated Script
```bash
cd MAQ-2/trainees
./test_api_vulnerable.sh
```

### 2. Manual Testing

#### Option A: Token Authentication (API/curl)

##### Login
```bash
curl -X POST http://localhost:8000/api/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "your@email.com",
    "password": "your_password"
  }'
```

##### List All Users (Vulnerable)
```bash
curl -X GET http://localhost:8000/api/users \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -H "Accept: application/json"
```

##### Search Specific User (Vulnerable)
```bash
curl -X GET http://localhost:8000/api/users/1 \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -H "Accept: application/json"
```

#### Option B: Session Authentication (Browser)
1. Login through the web interface (`/login`)
2. Visit these URLs directly in your browser:
   - `http://localhost:8000/api/users` - All users (vulnerable)
   - `http://localhost:8000/api/users/1` - Specific user (vulnerable)
   - `http://localhost:8000/api/me` - Your user information

The browser will display the JSON response, which you can view or copy.

## Exposed Data Structure

### Sensitive Information Exposed:
- User ID
- Full name
- Email
- User role/profile
- Phone
- Mobile
- City
- State
- Company ID
- Affiliation ID
- Creation and update dates

### Example of Vulnerable Response:
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

## Simulated Attack Scenarios

### 1. Administrative User Enumeration
1. Login with common account
2. Access `/api/users` to list all users
3. Identify users with "admin" role
4. Use this information for targeted attacks

### 2. Data Collection for Social Engineering
1. Use `/api/users/{id}` to collect specific data
2. Combine information to create detailed profiles
3. Use data for social engineering attacks

### 3. Organizational Structure Mapping
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

## Security Notice

⚠️ **WARNING:** These routes were created specifically for laboratory purposes and vulnerability demonstration. **NEVER** implement similar code in production environment.

## Next Steps

1. Test the routes using the provided script
2. Analyze the exposed vulnerabilities
3. Implement protection measures
4. Document lessons learned 