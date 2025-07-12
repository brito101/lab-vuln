# SIEM Central - Default Credentials

## 🔐 **Graylog**

### **Web Interface**
- **URL**: http://localhost:9000
- **Username**: admin
- **Password**: admin

### **API Access**
- **Username**: admin
- **Password**: admin
- **Session Token**: Obtained via API call

## 🔐 **Elasticsearch**

### **HTTP API**
- **URL**: http://localhost:9200
- **Authentication**: None (default)
- **Security**: Disabled for lab environment

### **Cluster Info**
- **Cluster Name**: elasticsearch
- **Node Name**: lab-siem-elasticsearch

## 🔐 **Wazuh Manager**

### **Web Interface** (if configured)
- **URL**: http://localhost:1515
- **Username**: admin
- **Password**: admin

### **API Access**
- **Username**: admin
- **Password**: admin

## 🔐 **Logstash**

### **HTTP API**
- **URL**: http://localhost:9600
- **Authentication**: None (default)

### **Pipeline API**
- **URL**: http://localhost:9600/_node/pipeline
- **Authentication**: None (default)

## 🔐 **MongoDB**

### **Database Access**
- **Host**: localhost
- **Port**: 27017
- **Database**: graylog
- **Authentication**: None (default for lab)

## 📊 **Default Ports**

| Service | Port | Protocol | Description |
|---------|------|----------|-------------|
| Graylog Web | 9000 | HTTP | Web interface |
| Graylog API | 9000 | HTTP | REST API |
| Elasticsearch | 9200 | HTTP | REST API |
| Logstash | 9600 | HTTP | API |
| Logstash Beats | 5044 | TCP | Filebeat input |
| Logstash TCP | 5000 | TCP | TCP input |
| Logstash UDP | 5000 | UDP | UDP input |
| Wazuh | 1515 | HTTP | Web interface |
| Syslog UDP | 1514 | UDP | Syslog input |
| Syslog TCP | 1514 | TCP | Syslog input |
| GELF UDP | 12201 | UDP | GELF input |

## 🔧 **Configuration Files**

### **Graylog Configuration**
- **File**: Environment variables in docker-compose.yml
- **Password Secret**: somepasswordpepper
- **Root Password Hash**: 8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918

### **Elasticsearch Configuration**
- **File**: Environment variables in docker-compose.yml
- **Memory**: 512MB (configurable)
- **Security**: Disabled for lab

### **Logstash Configuration**
- **File**: ./logstash/config/logstash.yml
- **Pipeline**: ./logstash/pipeline/
- **Memory**: 256MB (configurable)

## 🚨 **Security Notes**

⚠️ **IMPORTANT**: These credentials are for the lab environment only!

- **Never** use these credentials in production
- **Never** expose the SIEM to the internet
- **Always** change default passwords in production
- **Always** enable authentication and encryption in production
- **Always** use strong, unique passwords
- **Always** implement proper access controls

## 🔄 **Changing Default Credentials**

### **Graylog**
```bash
# Stop containers
docker-compose down

# Edit docker-compose.yml
# Change GRAYLOG_ROOT_PASSWORD_SHA2 to new hash

# Restart containers
docker-compose up -d
```

### **Elasticsearch**
```bash
# Add security configuration
# Enable X-Pack security
# Configure authentication
```

### **Wazuh**
```bash
# Change admin password via web interface
# Or modify configuration files
```

## 📝 **Usage Examples**

### **Access Graylog API**
```bash
curl -u admin:admin http://localhost:9000/api/system/inputs
```

### **Check Elasticsearch**
```bash
curl http://localhost:9200/_cluster/health
```

### **Test Logstash**
```bash
curl http://localhost:9600/_node/pipeline
```

### **Send Test Logs**
```bash
echo "<134>$(date '+%b %d %H:%M:%S') $(hostname) test: Test message" | nc -u localhost 1514
```

---

**Remember**: This is a lab environment. In production, always use strong authentication and encryption! 