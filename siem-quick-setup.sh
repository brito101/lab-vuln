#!/bin/bash
# SIEM Quick Setup Script - Lab Vuln
# Author: Lab Vuln
# Version: 1.0

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

function print_status() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

function print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

function print_error() {
    echo -e "${RED}❌ $1${NC}"
}

function print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_status "SIEM QUICK SETUP - LAB VULN"
echo "This script provides quick setup for different SIEM platforms"
echo ""

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   print_error "This script must be run as root"
   exit 1
fi

# Function to setup Wazuh
function setup_wazuh() {
    print_status "SETTING UP WAZUH"
    
    # Create Wazuh directory
    mkdir -p wazuh-lab && cd wazuh-lab
    
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
    
    print_success "Wazuh setup completed"
    print_warning "Access Wazuh Dashboard: https://localhost:443"
    print_warning "Username: admin, Password: SecretPassword"
    
    cd ..
}

# Function to setup ELK Stack
function setup_elk() {
    print_status "SETTING UP ELK STACK"
    
    # Create ELK directory
    mkdir -p elk-lab && cd elk-lab
    
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
    
    print_success "ELK Stack setup completed"
    print_warning "Access Kibana: http://localhost:5601"
    print_warning "Elasticsearch: http://localhost:9200"
    
    cd ..
}

# Function to setup Graylog
function setup_graylog() {
    print_status "SETTING UP GRAYLOG"
    
    # Create Graylog directory
    mkdir -p graylog-lab && cd graylog-lab
    
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
    
    print_success "Graylog setup completed"
    print_warning "Access Graylog: http://localhost:9000"
    print_warning "Username: admin, Password: admin"
    
    cd ..
}

# Function to setup Splunk
function setup_splunk() {
    print_status "SETTING UP SPLUNK"
    
    # Create Splunk directory
    mkdir -p splunk-lab && cd splunk-lab
    
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
    
    print_success "Splunk setup completed"
    print_warning "Access Splunk: http://localhost:8000"
    print_warning "Username: admin, Password: admin123"
    
    cd ..
}

# Function to setup multi-SIEM
function setup_multi_siem() {
    print_status "SETTING UP MULTI-SIEM ENVIRONMENT"
    
    # Create multi-SIEM directory
    mkdir -p multi-siem-lab && cd multi-siem-lab
    
    # Create docker-compose.yml for multiple SIEMs
    cat > docker-compose.yml << 'EOF'
version: '3.7'
services:
  # Wazuh
  wazuh-manager:
    image: wazuh/wazuh-manager:4.7.0
    hostname: wazuh-manager
    restart: always
    ports:
      - "1514:1514"
      - "514:514/udp"
    environment:
      - INDEXER_URL=https://wazuh-indexer:9200
      - INDEXER_USERNAME=admin
      - INDEXER_PASSWORD=SecretPassword
    volumes:
      - wazuh_etc:/var/ossec/etc
      - wazuh_logs:/var/ossec/logs

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
      - "OPENSEARCH_JAVA_OPTS=-Xms256m -Xmx256m"
    volumes:
      - wazuh-indexer-data:/var/lib/wazuh-indexer

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
    depends_on:
      - wazuh-indexer
      - wazuh-manager

  # Graylog
  graylog-mongo:
    image: mongo:4.2
    volumes:
      - graylog_mongo_data:/data/db

  graylog-elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch-oss:7.10.2
    volumes:
      - graylog_es_data:/usr/share/elasticsearch/data
    environment:
      - http.host=0.0.0.0
      - transport.host=localhost
      - network.host=0.0.0.0
      - "ES_JAVA_OPTS=-Xms256m -Xmx256m"

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
    depends_on:
      - graylog-mongo
      - graylog-elasticsearch

  # ELK Stack
  elk-elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.8.0
    container_name: elk-elasticsearch
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=false
      - "ES_JAVA_OPTS=-Xms256m -Xmx256m"
    volumes:
      - elk-elasticsearch-data:/usr/share/elasticsearch/data
    ports:
      - "9201:9200"

  elk-kibana:
    image: docker.elastic.co/kibana/kibana:8.8.0
    container_name: elk-kibana
    ports:
      - "5602:5601"
    environment:
      ELASTICSEARCH_URL: http://elk-elasticsearch:9200
      ELASTICSEARCH_HOSTS: http://elk-elasticsearch:9200
    depends_on:
      - elk-elasticsearch

volumes:
  wazuh_etc:
  wazuh_logs:
  wazuh-indexer-data:
  graylog_mongo_data:
  graylog_es_data:
  graylog_data:
  elk-elasticsearch-data:
EOF

    # Start multi-SIEM
    docker-compose up -d
    
    print_success "Multi-SIEM setup completed"
    print_warning "Access Wazuh: https://localhost:443"
    print_warning "Access Graylog: http://localhost:9000"
    print_warning "Access Kibana: http://localhost:5602"
    
    cd ..
}

# Function to create log forwarder
function create_log_forwarder() {
    print_status "CREATING LOG FORWARDER"
    
    # Create log forwarder script
    cat > /usr/local/bin/multi-siem-forwarder.sh << 'EOF'
#!/bin/bash
# Multi-SIEM Log Forwarder
# Forwards logs to multiple SIEM platforms

LOG_SOURCE="/var/log/syslog"
WAZUH_HOST="localhost"
GRAYLOG_HOST="localhost"
ELK_HOST="localhost"

# Forward to Wazuh
logger -n $WAZUH_HOST -P 514 -t lab-vuln "$(tail -1 $LOG_SOURCE)"

# Forward to Graylog
echo "$(tail -1 $LOG_SOURCE)" | nc -w 1 $GRAYLOG_HOST 12201

# Forward to ELK
curl -X POST "http://$ELK_HOST:9201/lab-vuln/_doc" \
     -H "Content-Type: application/json" \
     -d "{\"message\":\"$(tail -1 $LOG_SOURCE)\",\"timestamp\":\"$(date -Iseconds)\"}" \
     -s > /dev/null
EOF

    chmod +x /usr/local/bin/multi-siem-forwarder.sh
    
    # Create systemd service
    cat > /etc/systemd/system/multi-siem-forwarder.service << 'EOF'
[Unit]
Description=Multi-SIEM Log Forwarder
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/multi-siem-forwarder.sh
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable multi-siem-forwarder.service
    systemctl start multi-siem-forwarder.service
    
    print_success "Log forwarder created and started"
}

# Function to create configuration files
function create_config_files() {
    print_status "CREATING CONFIGURATION FILES"
    
    # Create SIEM configuration directory
    mkdir -p /etc/lab-vuln/siem-configs
    
    # Wazuh agent configuration
    cat > /etc/lab-vuln/siem-configs/wazuh-agent.conf << 'EOF'
<ossec_config>
  <client>
    <server-ip>192.168.1.102</server-ip>
  </client>
  
  <localfile>
    <log_format>syslog</log_format>
    <location>/var/log/syslog</location>
  </localfile>
  
  <localfile>
    <log_format>syslog</log_format>
    <location>/var/log/auth.log</location>
  </localfile>
</ossec_config>
EOF

    # Filebeat configuration for ELK
    cat > /etc/lab-vuln/siem-configs/filebeat.yml << 'EOF'
filebeat.inputs:
- type: log
  enabled: true
  paths:
    - /var/log/syslog
    - /var/log/auth.log
  fields:
    service: linux
    environment: lab-vuln

output.elasticsearch:
  hosts: ["192.168.1.102:9200"]
  index: "lab-vuln-%{+YYYY.MM.dd}"

setup.kibana:
  host: "192.168.1.102:5601"
EOF

    # Graylog configuration
    cat > /etc/lab-vuln/siem-configs/graylog-input.json << 'EOF'
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
EOF

    print_success "Configuration files created"
}

# Function to create test scripts
function create_test_scripts() {
    print_status "CREATING TEST SCRIPTS"
    
    # Create test directory
    mkdir -p /usr/local/bin/siem-tests
    
    # Wazuh test script
    cat > /usr/local/bin/siem-tests/test-wazuh.sh << 'EOF'
#!/bin/bash
# Test Wazuh connectivity and log forwarding

echo "Testing Wazuh connectivity..."
curl -k -u admin:SecretPassword https://localhost:443/api/agents

echo "Sending test log to Wazuh..."
logger -n localhost -P 514 -t test "Test message from Lab Vuln"
EOF

    # ELK test script
    cat > /usr/local/bin/siem-tests/test-elk.sh << 'EOF'
#!/bin/bash
# Test ELK Stack connectivity

echo "Testing Elasticsearch..."
curl -X GET "http://localhost:9200/_cluster/health"

echo "Testing Kibana..."
curl -X GET "http://localhost:5601/api/status"

echo "Sending test log to ELK..."
curl -X POST "http://localhost:9200/lab-vuln/_doc" \
     -H "Content-Type: application/json" \
     -d "{\"message\":\"Test message from Lab Vuln\",\"timestamp\":\"$(date -Iseconds)\"}"
EOF

    # Graylog test script
    cat > /usr/local/bin/siem-tests/test-graylog.sh << 'EOF'
#!/bin/bash
# Test Graylog connectivity

echo "Testing Graylog API..."
curl -u admin:admin http://localhost:9000/api/system/overview

echo "Sending test log to Graylog..."
echo "Test message from Lab Vuln" | nc -w 1 localhost 12201
EOF

    chmod +x /usr/local/bin/siem-tests/*.sh
    
    print_success "Test scripts created"
}

# Main menu
function show_menu() {
    echo ""
    print_status "SIEM SETUP MENU"
    echo "1. Setup Wazuh"
    echo "2. Setup ELK Stack"
    echo "3. Setup Graylog"
    echo "4. Setup Splunk"
    echo "5. Setup Multi-SIEM Environment"
    echo "6. Create Log Forwarder"
    echo "7. Create Configuration Files"
    echo "8. Create Test Scripts"
    echo "9. Setup All (Complete Environment)"
    echo "0. Exit"
    echo ""
}

# Main execution
while true; do
    show_menu
    read -p "Select an option: " choice
    
    case $choice in
        1)
            setup_wazuh
            ;;
        2)
            setup_elk
            ;;
        3)
            setup_graylog
            ;;
        4)
            setup_splunk
            ;;
        5)
            setup_multi_siem
            ;;
        6)
            create_log_forwarder
            ;;
        7)
            create_config_files
            ;;
        8)
            create_test_scripts
            ;;
        9)
            print_status "SETTING UP COMPLETE ENVIRONMENT"
            setup_wazuh
            setup_elk
            setup_graylog
            setup_splunk
            setup_multi_siem
            create_log_forwarder
            create_config_files
            create_test_scripts
            print_success "Complete SIEM environment setup finished!"
            ;;
        0)
            print_success "Exiting..."
            exit 0
            ;;
        *)
            print_error "Invalid option"
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
done 