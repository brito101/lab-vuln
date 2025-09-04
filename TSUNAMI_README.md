# 🌊 Tsunami Traffic Simulator

Simulador de tráfego avançado para laboratórios de segurança, projetado para ocultar o IP do atacante gerando tráfego de diferentes IPs spoofed que consomem serviços nos laboratórios MAQ-1, MAQ-2, MAQ-3 e MAQ-4.

## 🎯 Características

- **Spoofing de IP**: Gera tráfego de IPs aleatórios para ocultar o atacante
- **Múltiplos Protocolos**: Suporte a TCP, UDP e requisições HTTP realistas
- **Laboratórios Integrados**: Configurações específicas para MAQ-1, MAQ-2, MAQ-3 e MAQ-4
- **Tráfego Realista**: Simula comportamento humano com intervalos aleatórios
- **Estatísticas Detalhadas**: Monitoramento em tempo real e relatórios finais
- **Interface Amigável**: Script bash wrapper com cores e formatação

## 🚀 Instalação

### Pré-requisitos

- Ubuntu/Debian (ou distribuição compatível)
- Python 3.6+
- Privilégios de root (para envio de pacotes raw)

### Instalação Automática

```bash
# Clone o repositório (se necessário)
cd /home/brito/lab-vuln

# Instale dependências
sudo ./tsunami.sh --install
```

### Instalação Manual

```bash
# Instalar Python3 e pip
sudo apt update
sudo apt install python3 python3-pip

# Instalar Scapy
pip3 install scapy

# Instalar dependências adicionais
sudo apt install python3-netifaces python3-psutil
```

## 📖 Uso

### Sintaxe Básica

```bash
sudo ./tsunami.sh -i <IPs> -d <duração> [-p <pacotes>] [-l <laboratório>]
```

### Parâmetros

- `-i, --ips`: IP(s) alvo (separados por vírgula) - **Obrigatório**
- `-d, --duration`: Duração da simulação em segundos - **Obrigatório**
- `-p, --packets`: Número de pacotes por serviço (padrão: 100)
- `-l, --lab`: Tipo de laboratório (MAQ-1, MAQ-2, MAQ-3, MAQ-4)
- `-h, --help`: Mostra ajuda
- `--install`: Instala dependências
- `--status`: Mostra status dos laboratórios

### Exemplos de Uso

#### 1. Simulação Básica

```bash
# Simula tráfego para um IP por 60 segundos
sudo ./tsunami.sh -i 192.168.1.100 -d 60
```

#### 2. Múltiplos IPs

```bash
# Simula tráfego para múltiplos IPs
sudo ./tsunami.sh -i 192.168.1.100,192.168.1.101,192.168.1.102 -d 120
```

#### 3. Laboratório Específico

```bash
# Simula tráfego específico para MAQ-1 (Windows Server)
sudo ./tsunami.sh -i 192.168.101.10 -d 300 -p 200 -l MAQ-1
```

#### 4. Laboratório Zimbra (MAQ-4)

```bash
# Simula tráfego para Zimbra com foco em SMTP
sudo ./tsunami.sh -i 192.168.104.10 -d 180 -p 150 -l MAQ-4
```

#### 5. Simulação Intensiva

```bash
# Simulação com muitos pacotes
sudo ./tsunami.sh -i 192.168.1.100 -d 600 -p 500
```

## 🏭 Laboratórios Suportados

### MAQ-1: Windows Server 2022 Domain Controller

- **Rede**: 192.168.101.0/24
- **Serviços**: RDP (3389), DNS (53), LDAP (389), SMB (445), Kerberos (88), Web-Viewer (8006)

### MAQ-2: Laravel Web Application

- **Rede**: 192.168.201.0/24
- **Serviços**: HTTP (80), MySQL (3306), Redis (6379), SSH (22)

### MAQ-3: Linux Infrastructure

- **Rede**: 192.168.200.0/24
- **Serviços**: SSH (2222), FTP (2121), SMB (139/445), HTTP (8080)

### MAQ-4: Zimbra CVE-2024-45519

- **Rede**: 192.168.104.0/24
- **Serviços**: SMTP (25), HTTP (80), HTTPS (443), SSH (22), Admin-Console (7071), IMAP (143), POP3 (110)

## 🔧 Funcionalidades Técnicas

### Spoofing de IP

- Gera IPs aleatórios dentro da rede alvo
- Evita IPs de broadcast e network
- Suporte a múltiplas redes privadas

### Tipos de Tráfego

- **TCP**: Conexões SYN para serviços
- **UDP**: Pacotes UDP para serviços compatíveis
- **HTTP**: Requisições HTTP realistas com User-Agents variados

### Ocultação do Atacante

- Múltiplos IPs spoofed simultaneamente
- Intervalos aleatórios entre pacotes (0.1-2s)
- Padrões de tráfego realistas

## 📊 Monitoramento

### Saída em Tempo Real

```
[0001] RDP           | 192.168.101.45  -> 192.168.101.10:3389  | Protocol: TCP
[0002] HTTP          | 192.168.201.23  -> 192.168.201.10:80    | Protocol: TCP
[0003] SMTP          | 192.168.104.67  -> 192.168.104.10:25    | Protocol: TCP
```

### Estatísticas Finais

```
================================================================================
📊 ESTATÍSTICAS FINAIS
================================================================================
⏱️  Duração total: 60.00 segundos
📦 Total de pacotes enviados: 245
📈 Taxa média: 4.08 pacotes/segundo

📋 Pacotes por serviço:
   HTTP            :   45 pacotes ( 18.4%)
   RDP             :   38 pacotes ( 15.5%)
   SMTP            :   42 pacotes ( 17.1%)
   SSH             :   35 pacotes ( 14.3%)
   ...
```

## 🛠️ Comandos Úteis

### Verificar Status dos Laboratórios

```bash
sudo ./tsunami.sh --status
```

### Instalar/Atualizar Dependências

```bash
sudo ./tsunami.sh --install
```

### Executar Diretamente com Python

```bash
sudo python3 tsunami_traffic_simulator.py -i 192.168.1.100 -d 60 -p 100 -l MAQ-1
```

## ⚠️ Considerações de Segurança

### Uso Responsável

- **APENAS para ambientes de treinamento controlados**
- **NÃO use em redes de produção**
- **Respeite as leis locais sobre spoofing de IP**

### Requisitos de Rede

- Execute em rede isolada de treinamento
- Configure firewalls adequadamente
- Monitore o tráfego gerado

### Privilégios

- Script requer privilégios de root para envio de pacotes raw
- Use apenas em ambientes controlados
- Revogue privilégios após o uso

## 🔍 Solução de Problemas

### Erro: "Permission denied"

```bash
# Execute com sudo
sudo ./tsunami.sh -i 192.168.1.100 -d 60
```

### Erro: "Scapy not found"

```bash
# Instale o Scapy
sudo ./tsunami.sh --install
```

### Erro: "IP inválido"

```bash
# Verifique o formato do IP
sudo ./tsunami.sh -i 192.168.1.100 -d 60  # ✓ Correto
sudo ./tsunami.sh -i 192.168.1.1000 -d 60 # ✗ Erro
```

### Laboratórios não encontrados

```bash
# Verifique o status dos laboratórios
sudo ./tsunami.sh --status

# Use sem especificar laboratório para usar todos os serviços
sudo ./tsunami.sh -i 192.168.1.100 -d 60
```

## 📝 Logs e Debugging

### Habilitar Logs Detalhados

```bash
# Execute com verbose do Python
sudo python3 -v tsunami_traffic_simulator.py -i 192.168.1.100 -d 60
```

### Monitorar Tráfego

```bash
# Em outro terminal, monitore o tráfego
sudo tcpdump -i any host 192.168.1.100

# Ou use Wireshark
sudo wireshark
```

## 🤝 Contribuição

Para contribuir com melhorias:

1. Teste em ambiente isolado
2. Documente mudanças
3. Mantenha compatibilidade com laboratórios existentes
4. Siga boas práticas de segurança

## 📄 Licença

Este projeto é apenas para fins educacionais. Use de forma responsável e apenas em ambientes de treinamento controlados.

---

**🌊 Tsunami Traffic Simulator** - Ocultando atacantes através de tráfego realista
