# SIEM Integration Examples - Lab Vuln

## Overview

This document provides examples and instructions for integrating the Lab Vuln environment with popular SIEM platforms including Wazuh, ELK Stack, Splunk, Graylog, and others. These integrations enhance the training environment with enterprise-grade security monitoring capabilities.

## Wazuh Integration

### Installation and Setup

#### Docker-based Wazuh
```bash
# Create Wazuh directory
mkdir wazuh-lab && cd wazuh-lab

# Create docker-compose.yml
cat > docker-compose.yml << 'EOF'
version: '3.7'
services:
  wazuh-manager:
    image: wazuh/wazuh-manager:4.7.0
    hostname: wazuh-manager
    restart: always
    ports:
      - "1514:1514"
      - "1515:1515"
      - "514:514/udp"
      - "514:514/tcp"
      - "55000:55000"
    volumes:
      - wazuh_api_configuration:/var/ossec/api/configuration
      - wazuh_etc:/var/ossec/etc
      - wazuh_logs:/var/ossec/logs
      - wazuh_queue:/var/ossec/queue
      - wazuh_var_multigroups:/var/ossec/var/multigroups
      - wazuh_integrations:/var/ossec/integrations
      - wazuh_active_response:/var/ossec/active-response/bin
      - filebeat_etc:/etc/filebeat
      - filebeat_var:/var/lib/filebeat
    environment:
      - INDEXER_URL=https://wazuh-indexer:9200
      - INDEXER_USERNAME=admin
      - INDEXER_PASSWORD=SecretPassword
      - FILEBEAT_SSL_VERIFY=false

  wazuh-indexer:
    image: wazuh/wazuh-indexer:4.7.0
    hostname: wazuh-indexer
    restart: always
    ports:
      - "9200:9200"
    environment:
      - node.name=wazuh-indexer
      - cluster.initial_master_nodes=wazuh-indexer
      - cluster.name=wazuh-cluster
      - bootstrap.memory_lock=true
      - "OPENSEARCH_JAVA_OPTS=-Xms512m -Xmx512m"
    ulimits:
      memlock:
        soft: -1
        hard: -1
      nofile:
        soft: 65536
        hard: 65536
    volumes:
      - wazuh-indexer-data:/var/lib/wazuh-indexer
      - wazuh-indexer-config:/usr/share/wazuh-indexer/config/wazuh-indexer

  wazuh-dashboard:
    image: wazuh/wazuh-dashboard:4.7.0
    hostname: wazuh-dashboard
    restart: always
    ports:
      - "443:5601"
    environment:
      - INDEXER_USERNAME=admin
      - INDEXER_PASSWORD=SecretPassword
      - WAZUH_API_URL=https://wazuh-manager
      - API_USERNAME=wazuh-wui
      - API_PASSWORD=MyS3cr3tP4ssw0rd
    volumes:
      - wazuh-dashboard-config:/var/lib/wazuh-dashboard
      - wazuh-dashboard-configuration:/usr/share/wazuh-dashboard/config/wazuh-dashboard
    depends_on:
      - wazuh-indexer
      - wazuh-manager

volumes:
  wazuh_api_configuration:
  wazuh_etc:
  wazuh_logs:
  wazuh_queue:
  wazuh_var_multigroups:
  wazuh_integrations:
  wazuh_active_response:
  filebeat_etc:
  filebeat_var:
  wazuh-indexer-data:
  wazuh-indexer-config:
  wazuh-dashboard-config:
  wazuh-dashboard-configuration:
EOF

# Start Wazuh
docker-compose up -d
```

#### Agent Installation

##### Windows Agent
```powershell
# Download Wazuh agent for Windows
Invoke-WebRequest -Uri "https://packages.wazuh.com/4.7/windows/wazuh-agent-4.7.0-1.msi" -OutFile "wazuh-agent.msi"

# Install agent
msiexec /i wazuh-agent.msi /qn WAZUH_MANAGER=192.168.1.102 WAZUH_REGISTRATION_SERVER=192.168.1.102

# Start service
net start WazuhSvc
```

##### Linux Agent
```bash
# Add Wazuh repository
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | sudo apt-key add -
echo "deb https://packages.wazuh.com/4.7/apt/ stable main" | sudo tee /etc/apt/sources.list.d/wazuh.list

# Install agent
sudo apt update
sudo apt install wazuh-agent

# Configure agent
sudo sed -i 's/MANAGER_IP/192.168.1.102/g' /var/ossec/etc/ossec.conf

# Start agent
sudo systemctl start wazuh-agent
sudo systemctl enable wazuh-agent
```

### Configuration Examples

#### Custom Rules
```xml
<!-- /var/ossec/etc/rules/local_rules.xml -->
<group name="lab_vuln,">
  <rule id="100001" level="0">
    <if_sid>0</if_sid>
    <description>Lab Vuln - Brute Force Detection</description>
  </rule>

  <rule id="100002" level="10">
    <if_sid>100001</if_sid>
    <match>Failed password</match>
    <description>SSH Brute Force Attempt</description>
  </rule>

  <rule id="100003" level="12">
    <if_sid>100002</if_sid>
    <frequency>5</frequency>
    <timeframe>60</timeframe>
    <description>Multiple SSH Brute Force Attempts</description>
  </rule>

  <rule id="100004" level="10">
    <if_sid>0</if_sid>
    <match>LFI</match>
    <description>Local File Inclusion Attempt</description>
  </rule>

  <rule id="100005" level="15">
    <if_sid>0</if_sid>
    <match>Ransomware</match>
    <description>Ransomware Activity Detected</description>
  </rule>
</group>
```

#### Active Response
```xml
<!-- /var/ossec/etc/ossec.conf -->
<active-response>
  <command>firewall-drop</command>
  <location>local</location>
  <level>12</level>
  <timeout>600</timeout>
</active-response>
```

## ELK Stack Integration

### Installation

#### Docker-based ELK
```bash
# Create ELK directory
mkdir elk-lab && cd elk-lab

# Create docker-compose.yml
cat > docker-compose.yml << 'EOF'
version: '3.7'
services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.8.0
    container_name: elasticsearch
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=false
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
    ulimits:
      memlock:
        soft: -1
        hard: -1
    volumes:
      - elasticsearch-data:/usr/share/elasticsearch/data
    ports:
      - "9200:9200"
      - "9300:9300"

  logstash:
    image: docker.elastic.co/logstash/logstash:8.8.0
    container_name: logstash
    volumes:
      - ./logstash/config/logstash.yml:/usr/share/logstash/config/logstash.yml:ro
      - ./logstash/pipeline:/usr/share/logstash/pipeline:ro
    ports:
      - "5044:5044"
      - "5000:5000/tcp"
      - "5000:5000/udp"
      - "9600:9600"
    environment:
      LS_JAVA_OPTS: "-Xmx256m -Xms256m"
    depends_on:
      - elasticsearch

  kibana:
    image: docker.elastic.co/kibana/kibana:8.8.0
    container_name: kibana
    ports:
      - "5601:5601"
    environment:
      ELASTICSEARCH_URL: http://elasticsearch:9200
      ELASTICSEARCH_HOSTS: http://elasticsearch:9200
    depends_on:
      - elasticsearch

volumes:
  elasticsearch-data:
EOF

# Create Logstash configuration
mkdir -p logstash/config logstash/pipeline

# Logstash configuration
cat > logstash/config/logstash.yml << 'EOF'
http.host: "0.0.0.0"
xpack.monitoring.elasticsearch.hosts: [ "http://elasticsearch:9200" ]
EOF

# Logstash pipeline
cat > logstash/pipeline/logstash.conf << 'EOF'
input {
  syslog {
    port => 514
    type => "syslog"
  }
  beats {
    port => 5044
    type => "beats"
  }
  tcp {
    port => 5000
    type => "tcp"
  }
}

filter {
  if [type] == "syslog" {
    grok {
      match => { "message" => "%{SYSLOGTIMESTAMP:syslog_timestamp} %{SYSLOGHOST:syslog_hostname} %{DATA:syslog_program}(?:\[%{POSINT:syslog_pid}\])?: %{GREEDYDATA:syslog_message}" }
    }
    date {
      match => [ "syslog_timestamp", "MMM  d HH:mm:ss", "MMM dd HH:mm:ss" ]
    }
  }
  
  if [type] == "beats" {
    if [fields][service] == "ssh" {
      grok {
        match => { "message" => "%{SYSLOGTIMESTAMP:timestamp} %{SYSLOGHOST:hostname} sshd\[%{POSINT:pid}\]: %{GREEDYDATA:ssh_message}" }
      }
    }
  }
}

output {
  elasticsearch {
    hosts => ["elasticsearch:9200"]
    index => "lab-vuln-%{+YYYY.MM.dd}"
  }
}
EOF

# Start ELK
docker-compose up -d
```

### Filebeat Configuration

#### Linux Filebeat
```yaml
# /etc/filebeat/filebeat.yml
filebeat.inputs:
- type: log
  enabled: true
  paths:
    - /var/log/syslog
    - /var/log/auth.log
    - /var/log/ssh/*.log
  fields:
    service: linux
    environment: lab-vuln

- type: log
  enabled: true
  paths:
    - /var/log/apache2/*.log
    - /var/log/nginx/*.log
  fields:
    service: web
    environment: lab-vuln

output.elasticsearch:
  hosts: ["192.168.1.102:9200"]
  index: "lab-vuln-%{+YYYY.MM.dd}"

setup.kibana:
  host: "192.168.1.102:5601"
```

#### Windows Filebeat
```yaml
# C:\Program Files\Filebeat\filebeat.yml
filebeat.inputs:
- type: log
  enabled: true
  paths:
    - C:\Windows\System32\winevt\Logs\Security.evtx
    - C:\Windows\System32\winevt\Logs\Application.evtx
    - C:\Windows\System32\winevt\Logs\System.evtx
  fields:
    service: windows
    environment: lab-vuln

output.elasticsearch:
  hosts: ["192.168.1.102:9200"]
  index: "lab-vuln-%{+YYYY.MM.dd}"

setup.kibana:
  host: "192.168.1.102:5601"
```

### Kibana Dashboards

#### Security Dashboard
```json
{
  "dashboard": {
    "title": "Lab Vuln Security Dashboard",
    "panels": [
      {
        "title": "Failed Login Attempts",
        "type": "visualization",
        "visState": {
          "type": "line",
          "params": {
            "type": "line",
            "grid": {"categoryLines": false},
            "categoryAxes": [{"id": "CategoryAxis-1"}],
            "valueAxes": [{"id": "ValueAxis-1"}],
            "seriesParams": [{"type": "line"}]
          }
        }
      },
      {
        "title": "Top Attack Sources",
        "type": "visualization",
        "visState": {
          "type": "pie",
          "params": {
            "type": "pie",
            "addTooltip": true,
            "addLegend": true
          }
        }
      }
    ]
  }
}
```

## Splunk Integration

### Installation

#### Docker-based Splunk
```bash
# Create Splunk directory
mkdir splunk-lab && cd splunk-lab

# Create docker-compose.yml
cat > docker-compose.yml << 'EOF'
version: '3.7'
services:
  splunk:
    image: splunk/splunk:latest
    container_name: splunk
    environment:
      - SPLUNK_START_ARGS=--accept-license
      - SPLUNK_PASSWORD=admin123
    ports:
      - "8000:8000"
      - "8089:8089"
      - "9997:9997"
      - "514:514/udp"
      - "514:514/tcp"
    volumes:
      - splunk-data:/opt/splunk/var
      - splunk-etc:/opt/splunk/etc

volumes:
  splunk-data:
  splunk-etc:
EOF

# Start Splunk
docker-compose up -d
```

### Universal Forwarder Configuration

#### Linux Universal Forwarder
```bash
# Install Splunk Universal Forwarder
wget -O splunkforwarder-9.0.4-de405f4a7979-linux-2.6-amd64.deb "https://download.splunk.com/products/universalforwarder/releases/9.0.4/linux/splunkforwarder-9.0.4-de405f4a7979-linux-2.6-amd64.deb"
sudo dpkg -i splunkforwarder-9.0.4-de405f4a7979-linux-2.6-amd64.deb

# Configure forwarder
sudo /opt/splunkforwarder/bin/splunk start --accept-license --answer-yes --auto-ports --no-prompt

# Add monitoring inputs
sudo /opt/splunkforwarder/bin/splunk add monitor /var/log/syslog -index lab-vuln
sudo /opt/splunkforwarder/bin/splunk add monitor /var/log/auth.log -index lab-vuln
sudo /opt/splunkforwarder/bin/splunk add monitor /var/log/ssh/ -index lab-vuln

# Configure outputs
sudo /opt/splunkforwarder/bin/splunk add forward-server 192.168.1.102:9997

# Restart forwarder
sudo /opt/splunkforwarder/bin/splunk restart
```

#### Windows Universal Forwarder
```powershell
# Download Splunk Universal Forwarder
Invoke-WebRequest -Uri "https://download.splunk.com/products/universalforwarder/releases/9.0.4/windows/splunkforwarder-9.0.4-de405f4a7979-x64-release.msi" -OutFile "splunkforwarder.msi"

# Install forwarder
msiexec /i splunkforwarder.msi /qn AGREETOLICENSE=Yes

# Configure forwarder
& "C:\Program Files\SplunkUniversalForwarder\bin\splunk.exe" start --accept-license --answer-yes --auto-ports --no-prompt

# Add monitoring inputs
& "C:\Program Files\SplunkUniversalForwarder\bin\splunk.exe" add monitor "C:\Windows\System32\winevt\Logs\Security.evtx" -index lab-vuln
& "C:\Program Files\SplunkUniversalForwarder\bin\splunk.exe" add monitor "C:\Windows\System32\winevt\Logs\Application.evtx" -index lab-vuln

# Configure outputs
& "C:\Program Files\SplunkUniversalForwarder\bin\splunk.exe" add forward-server 192.168.1.102:9997

# Restart forwarder
& "C:\Program Files\SplunkUniversalForwarder\bin\splunk.exe" restart
```

### Splunk Configuration

#### Inputs Configuration
```ini
# $SPLUNK_HOME/etc/system/local/inputs.conf
[monitor:///var/log/syslog]
index = lab-vuln
sourcetype = syslog

[monitor:///var/log/auth.log]
index = lab-vuln
sourcetype = auth_log

[monitor:///var/log/ssh/]
index = lab-vuln
sourcetype = ssh_log

[udp://514]
index = lab-vuln
sourcetype = syslog
```

#### Props Configuration
```ini
# $SPLUNK_HOME/etc/system/local/props.conf
[ssh_log]
EXTRACT-ip = (?i)from\s+(?P<ip>\d+\.\d+\.\d+\.\d+)
EXTRACT-user = (?i)for\s+(?P<user>\w+)

[auth_log]
EXTRACT-failed_user = (?i)Failed password for (?P<user>\w+)
EXTRACT-successful_user = (?i)Accepted password for (?P<user>\w+)

[syslog]
EXTRACT-priority = <(?P<priority>\d+)>
```

#### Transforms Configuration
```ini
# $SPLUNK_HOME/etc/system/local/transforms.conf
[ip_to_geo]
filename = ip_to_geo.csv

[threat_intel]
filename = threat_intel.csv
```

### Splunk Searches

#### Security Searches
```splunk
# Failed login attempts
index=lab-vuln "Failed password" | stats count by host, user

# Brute force detection
index=lab-vuln "Failed password" | stats count by host, user | where count > 5

# Successful logins
index=lab-vuln "Accepted password" | stats count by host, user

# LFI attempts
index=lab-vuln "LFI" OR "Local File Inclusion" | stats count by host, uri

# Ransomware activity
index=lab-vuln "Ransomware" OR "encrypted" | stats count by host, process
```

## Graylog Integration

### Installation

#### Docker-based Graylog
```bash
# Create Graylog directory
mkdir graylog-lab && cd graylog-lab

# Create docker-compose.yml
cat > docker-compose.yml << 'EOF'
version: '3.7'
services:
  mongo:
    image: mongo:4.2
    volumes:
      - mongo_data:/data/db

  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch-oss:7.10.2
    volumes:
      - es_data:/usr/share/elasticsearch/data
    environment:
      - http.host=0.0.0.0
      - transport.host=localhost
      - network.host=0.0.0.0
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
    ulimits:
      memlock:
        soft: -1
        hard: -1

  graylog:
    image: graylog/graylog:4.3
    volumes:
      - graylog_data:/usr/share/graylog/data
    environment:
      - GRAYLOG_PASSWORD_SECRET=somepasswordpepper
      - GRAYLOG_ROOT_PASSWORD_SHA2=8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918
      - GRAYLOG_HTTP_EXTERNAL_URI=http://127.0.0.1:9000/
    ports:
      - "9000:9000"
      - "12201:12201/udp"
      - "1514:1514"
    depends_on:
      - mongo
      - elasticsearch

volumes:
  mongo_data:
  es_data:
  graylog_data:
EOF

# Start Graylog
docker-compose up -d
```

### Input Configuration

#### Syslog Input
```json
{
  "title": "Lab Vuln Syslog",
  "type": "org.graylog2.inputs.syslog.udp.SyslogUDPInput",
  "global": true,
  "extractors": [],
  "configuration": {
    "bind_address": "0.0.0.0",
    "port": 514
  }
}
```

#### GELF Input
```json
{
  "title": "Lab Vuln GELF",
  "type": "org.graylog2.inputs.gelf.udp.GELFUDPInput",
  "global": true,
  "extractors": [],
  "configuration": {
    "bind_address": "0.0.0.0",
    "port": 12201
  }
}
```

### Extractors Configuration

#### SSH Extractor
```json
{
  "title": "SSH IP Extractor",
  "type": "REGEX",
  "source_field": "message",
  "target_field": "source_ip",
  "extractor_config": {
    "regex_value": "from\\s+(\\d+\\.\\d+\\.\\d+\\.\\d+)"
  }
}
```

#### User Extractor
```json
{
  "title": "SSH User Extractor",
  "type": "REGEX",
  "source_field": "message",
  "target_field": "user",
  "extractor_config": {
    "regex_value": "for\\s+(\\w+)"
  }
}
```

### Streams Configuration

#### Security Stream
```json
{
  "title": "Security Events",
  "description": "Security-related events from Lab Vuln",
  "rules": [
    {
      "type": "REGEX",
      "field": "message",
      "value": "(Failed password|Accepted password|LFI|Ransomware)"
    }
  ],
  "outputs": [],
  "matching_type": "OR"
}
```

### Alerts Configuration

#### Brute Force Alert
```json
{
  "title": "SSH Brute Force Alert",
  "description": "Alert on multiple failed SSH attempts",
  "condition_parameters": {
    "threshold": 5,
    "time": 300,
    "field": "source_ip"
  },
  "stream_id": "security-stream-id",
  "type": "field_content_value"
}
```

## QRadar Integration

### Installation

#### Docker-based QRadar
```bash
# Create QRadar directory
mkdir qradar-lab && cd qradar-lab

# Note: QRadar Community Edition is limited
# For full features, use IBM QRadar

# Create docker-compose.yml for QRadar CE
cat > docker-compose.yml << 'EOF'
version: '3.7'
services:
  qradar:
    image: ibmcom/qradar-ce:latest
    container_name: qradar
    ports:
      - "443:443"
      - "514:514/udp"
      - "514:514/tcp"
    environment:
      - QRADAR_CE_TOKEN=your_token_here
    volumes:
      - qradar-data:/store

volumes:
  qradar-data:
EOF

# Start QRadar
docker-compose up -d
```

### Log Source Configuration

#### Linux Log Source
```bash
# Configure rsyslog to forward to QRadar
echo "*.* @192.168.1.102:514" >> /etc/rsyslog.conf
systemctl restart rsyslog
```

#### Windows Log Source
```powershell
# Configure Windows Event Forwarding to QRadar
wecutil qc /q
wecutil ss "QRadar" /cm:custom /cf:"http://192.168.1.102:514"
```

## Integration Scripts

### Multi-SIEM Forwarder
```bash
#!/bin/bash
# Multi-SIEM Log Forwarder
# Forwards logs to multiple SIEM platforms

SIEM_CONFIG="/etc/multi-siem/config.json"
LOG_SOURCE="/var/log/syslog"

# Load configuration
if [[ -f $SIEM_CONFIG ]]; then
    WAZUH_HOST=$(jq -r '.wazuh.host' $SIEM_CONFIG)
    ELK_HOST=$(jq -r '.elk.host' $SIEM_CONFIG)
    SPLUNK_HOST=$(jq -r '.splunk.host' $SIEM_CONFIG)
    GRAYLOG_HOST=$(jq -r '.graylog.host' $SIEM_CONFIG)
fi

# Forward to Wazuh
if [[ -n $WAZUH_HOST ]]; then
    logger -n $WAZUH_HOST -P 514 -t lab-vuln "$(cat $LOG_SOURCE)"
fi

# Forward to ELK
if [[ -n $ELK_HOST ]]; then
    curl -X POST "http://$ELK_HOST:9200/lab-vuln/_doc" \
         -H "Content-Type: application/json" \
         -d "{\"message\":\"$(cat $LOG_SOURCE)\",\"timestamp\":\"$(date -Iseconds)\"}"
fi

# Forward to Splunk
if [[ -n $SPLUNK_HOST ]]; then
    curl -k -u admin:admin123 "https://$SPLUNK_HOST:8089/services/receivers/simple" \
         -d "sourcetype=syslog&index=lab-vuln&source=lab-vuln" \
         -d "$(cat $LOG_SOURCE)"
fi

# Forward to Graylog
if [[ -n $GRAYLOG_HOST ]]; then
    echo "$(cat $LOG_SOURCE)" | nc -w 1 $GRAYLOG_HOST 12201
fi
```

### Configuration File
```json
{
  "wazuh": {
    "host": "192.168.1.102",
    "port": 514,
    "enabled": true
  },
  "elk": {
    "host": "192.168.1.102",
    "port": 9200,
    "enabled": true
  },
  "splunk": {
    "host": "192.168.1.102",
    "port": 8089,
    "enabled": true
  },
  "graylog": {
    "host": "192.168.1.102",
    "port": 12201,
    "enabled": true
  }
}
```

## Best Practices

### Security Considerations
1. **Network Isolation**: Use dedicated network for SIEM communication
2. **Encryption**: Enable TLS/SSL for all SIEM communications
3. **Authentication**: Use strong passwords and API keys
4. **Access Control**: Limit access to SIEM interfaces
5. **Monitoring**: Monitor SIEM health and performance

### Performance Optimization
1. **Index Management**: Implement proper index rotation
2. **Resource Allocation**: Allocate sufficient CPU and memory
3. **Network Bandwidth**: Ensure adequate network capacity
4. **Storage**: Use fast storage for SIEM data
5. **Backup**: Regular backups of SIEM configurations

### Maintenance
1. **Updates**: Keep SIEM platforms updated
2. **Patches**: Apply security patches promptly
3. **Monitoring**: Monitor SIEM performance and logs
4. **Documentation**: Maintain configuration documentation
5. **Testing**: Regular testing of SIEM functionality

## Troubleshooting

### Common Issues
```bash
# Check SIEM connectivity
telnet 192.168.1.102 514
telnet 192.168.1.102 9200
telnet 192.168.1.102 5601

# Check log forwarding
tcpdump -i any port 514
tcpdump -i any port 9200

# Check SIEM logs
docker logs wazuh-manager
docker logs elasticsearch
docker logs splunk
docker logs graylog
```

### Performance Monitoring
```bash
# Check resource usage
docker stats

# Check disk usage
df -h

# Check memory usage
free -h

# Check network usage
iftop -i eth0
```

## Conclusion

This guide provides comprehensive examples for integrating the Lab Vuln environment with popular SIEM platforms. Each integration offers unique capabilities and can be customized based on specific training requirements. The modular approach allows for easy switching between different SIEM platforms or running multiple platforms simultaneously for comparison and training purposes. 