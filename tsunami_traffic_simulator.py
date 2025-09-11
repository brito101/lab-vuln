import warnings
from urllib3.exceptions import InsecureRequestWarning
warnings.filterwarnings("ignore", category=InsecureRequestWarning)
import requests
#!/usr/bin/env python3
"""
Tsunami Traffic Simulator - Simulador de Tráfego para Laboratórios de Segurança
Simula tráfego de diferentes IPs para ocultar o IP do atacante nos laboratórios MAQ-1, 2, 3 e 4
"""

import os
import random
import time
import argparse
import sys
import socket
from urllib.parse import urlparse
from ipaddress import IPv4Address, IPv4Network, AddressValueError
from scapy.layers.inet import IP, TCP, UDP
from scapy.sendrecv import send
from scapy.packet import Raw
from scapy.error import Scapy_Exception
import signal

# Configuração dos laboratórios
LAB_CONFIGS = {
    'MAQ-1': {
        'name': 'Windows Server 2022 Domain Controller',
        'network': '192.168.101.0/24',
        'services': [
            {'name': 'RDP', 'port': 3389, 'protocol': 'TCP'},
            {'name': 'DNS', 'port': 53, 'protocol': 'UDP'},
            {'name': 'LDAP', 'port': 389, 'protocol': 'TCP'},
            {'name': 'SMB', 'port': 445, 'protocol': 'TCP'},
            {'name': 'SMB-NetBIOS', 'port': 139, 'protocol': 'TCP'},
            {'name': 'Kerberos', 'port': 88, 'protocol': 'TCP'},
            {'name': 'Web-Viewer', 'port': 8006, 'protocol': 'TCP'}
        ]
    },
    'MAQ-2': {
        'name': 'Laravel Web Application',
        'network': '192.168.201.0/24',
        'services': [
            {'name': 'HTTP', 'port': 80, 'protocol': 'TCP'},
            {'name': 'MySQL', 'port': 3306, 'protocol': 'TCP'},
            {'name': 'Redis', 'port': 6379, 'protocol': 'TCP'},
            {'name': 'SSH', 'port': 22, 'protocol': 'TCP'}
        ]
    },
    'MAQ-3': {
        'name': 'Linux Infrastructure',
        'network': '192.168.200.0/24',
        'services': [
            {'name': 'SSH', 'port': 2222, 'protocol': 'TCP'},
            {'name': 'FTP', 'port': 2121, 'protocol': 'TCP'},
            {'name': 'SMB', 'port': 139, 'protocol': 'TCP'},
            {'name': 'SMB', 'port': 445, 'protocol': 'TCP'},
            {'name': 'HTTP', 'port': 8080, 'protocol': 'TCP'}
        ]
    },
    'MAQ-4': {
        'name': 'Zimbra CVE-2024-45519',
        'network': '192.168.104.0/24',
        'services': [
            {'name': 'SMTP', 'port': 25, 'protocol': 'TCP'},
            {'name': 'HTTP', 'port': 80, 'protocol': 'TCP'},
            {'name': 'HTTPS', 'port': 443, 'protocol': 'TCP'},
            {'name': 'SSH', 'port': 22, 'protocol': 'TCP'},
            {'name': 'Admin-Console', 'port': 7071, 'protocol': 'TCP'},
            {'name': 'IMAP', 'port': 143, 'protocol': 'TCP'},
            {'name': 'POP3', 'port': 110, 'protocol': 'TCP'}
        ]
    }
}

class TrafficSimulator:
    def __init__(self, targets, duration, packet_count, lab_type=None):
        """
        targets: list of dicts { 'ip': str, 'host': str }
        - 'ip'   is the destination IPv4 address to send traffic to
        - 'host' is the original input (domain or IP) used as HTTP Host header
        """
        self.targets = targets
        self.duration = duration
        self.packet_count = packet_count
        self.lab_type = lab_type
        self.running = True
        self.stats = {
            'packets_sent': 0,
            'packets_per_service': {},
            'start_time': time.time()
        }
        
        # Configurar handler para Ctrl+C
        signal.signal(signal.SIGINT, self.signal_handler)
        
    def signal_handler(self, *_args):
        """Handler para interrupção com Ctrl+C"""
        print("\n[!] Interrompendo simulação...")
        self.running = False
        
    def generate_spoofed_ip(self, target_network):
        """Gera um IP spoofed aleatório dentro da rede alvo"""
        try:
            network = IPv4Network(target_network, strict=False)
            # Gera IP aleatório dentro da rede, evitando broadcast e network
            host_bits = 32 - network.prefixlen
            if host_bits <= 0:
                return str(network.network_address + 1)
            
            # Gera IP aleatório
            random_host = random.randint(1, (2**host_bits) - 2)
            spoofed_ip = str(network.network_address + random_host)
            return spoofed_ip
        except ValueError:
            # Fallback para IPs aleatórios em redes privadas
            return f"192.168.{random.randint(1,254)}.{random.randint(1,254)}"
    
    def create_tcp_packet(self, src_ip, dst_ip, dst_port, flags="S"):
        """Cria um pacote TCP"""
        sport = random.randint(1024, 65535)
        seq = random.randint(1, 4294967295)
        pkt = IP(src=src_ip, dst=dst_ip) / \
            TCP(sport=sport, dport=dst_port, flags=flags, seq=seq)
        return pkt
    
    def create_udp_packet(self, src_ip, dst_ip, dst_port):
        """Cria um pacote UDP"""
        sport = random.randint(1024, 65535)
        pkt = IP(src=src_ip, dst=dst_ip) / \
            UDP(sport=sport, dport=dst_port)
        return pkt
    
    def create_http_request(self, src_ip, dst_ip, dst_port, host_header=None):
        """Cria uma requisição HTTP realista"""
        user_agents = [
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
            "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36",
            "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36",
            "curl/7.68.0",
            "Wget/1.20.3"
        ]
        
        paths = ["/", "/admin", "/login", "/api", "/status", "/health"]
        method = random.choice(["GET", "POST", "HEAD"])
        path = random.choice(paths)
        ua = random.choice(user_agents)
        
        http_request = f"{method} {path} HTTP/1.1\r\n"
        host_value = host_header or dst_ip
        http_request += f"Host: {host_value}\r\n"
        http_request += f"User-Agent: {ua}\r\n"
        http_request += "Accept: */*\r\n"
        http_request += "Connection: close\r\n\r\n"
        pkt = IP(src=src_ip, dst=dst_ip) / \
            TCP(sport=random.randint(1024, 65535), dport=dst_port) / \
            Raw(load=http_request.encode())
        return pkt
    
    def simulate_service_traffic(self, target, service, lab_network):
        """Simula tráfego para um serviço específico"""
        service_name = service['name']
        port = service['port']
        protocol = service['protocol']
        target_ip = target['ip']
        target_host = target.get('host') or target_ip
        is_domain = False
        # Se o host não é igual ao IP, é domínio
        try:
            IPv4Address(target_host)
        except AddressValueError:
            is_domain = True
        
        if service_name not in self.stats['packets_per_service']:
            self.stats['packets_per_service'][service_name] = 0
        
        # Gera IP spoofed
        spoofed_ip = self.generate_spoofed_ip(lab_network)
        
        try:
            if is_domain and service_name in ['HTTP', 'HTTPS'] and port in [80, 8080, 443]:
                # Envia requisição HTTP/HTTPS real
                scheme = 'https' if service_name == 'HTTPS' or port == 443 else 'http'
                url = f"{scheme}://{target_host}:{port}/"
                try:
                    resp = requests.get(url, headers={"User-Agent": "TsunamiSimulator/1.0"}, timeout=5, verify=False if scheme=='https' else True)
                    self.stats['packets_sent'] += 1
                    self.stats['packets_per_service'][service_name] += 1
                    print(f"[HTTP-REAL] {scheme.upper()} {target_host} -> {target_ip}:{port} | Status: {resp.status_code}")
                except Exception as err:
                    print(f"[!] Erro HTTP real para {target_host}: {err}")
                return
            # Scapy para IPs ou outros serviços
            if protocol == 'TCP':
                if service_name == 'HTTP' and port in [80, 8080]:
                    pkt = self.create_http_request(spoofed_ip, target_ip, port, host_header=target_host)
                else:
                    pkt = self.create_tcp_packet(spoofed_ip, target_ip, port)
            else:
                pkt = self.create_udp_packet(spoofed_ip, target_ip, port)
            send(pkt, verbose=False)
            self.stats['packets_sent'] += 1
            self.stats['packets_per_service'][service_name] += 1
            print(f"[{self.stats['packets_sent']:04d}] {service_name:12} | "
                  f"{spoofed_ip:15} -> {target_ip:15}:{port:5} | "
                  f"Protocol: {protocol}")
        except (Scapy_Exception, OSError) as err:
            print(f"[!] Erro ao enviar pacote para {service_name}: {err}")
    
    def run_simulation(self):
        """Executa a simulação de tráfego priorizando o número de pacotes"""
        print("\n" + ('='*80))
        print("🌊 TSUNAMI TRAFFIC SIMULATOR - Simulador de Tráfego para Laboratórios")
        print(('='*80))
        display_targets = [t.get('host') or t['ip'] for t in self.targets]
        print(f"🎯 Alvos: {', '.join(display_targets)}")
        print(f"📦 Pacotes por serviço: {self.packet_count}")
        if self.lab_type:
            print(f"🏭 Laboratório: {self.lab_type} - {LAB_CONFIGS[self.lab_type]['name']}")
        print(('='*80) + "\n")

        # Determina os serviços baseado no laboratório ou usa todos
        if self.lab_type and self.lab_type in LAB_CONFIGS:
            services = LAB_CONFIGS[self.lab_type]['services']
            lab_network = LAB_CONFIGS[self.lab_type]['network']
        else:
            services = []
            for lab in LAB_CONFIGS.values():
                services.extend(lab['services'])
            lab_network = "192.168.0.0/16"

        try:
            while self.running and self.stats['packets_sent'] < self.packet_count:
                target = random.choice(self.targets)
                service = random.choice(services)
                self.simulate_service_traffic(target, service, lab_network)
                time.sleep(random.uniform(0.1, 2.0))
        except KeyboardInterrupt:
            print("\n[!] Simulação interrompida pelo usuário")
        self.print_final_stats()
    
    def print_final_stats(self):
        """Imprime estatísticas finais da simulação"""
        duration = time.time() - self.stats['start_time']

        print("\n" + ('='*80))
        print("📊 ESTATÍSTICAS FINAIS")
        print(('='*80))
        print(f"⏱️  Duração total: {duration:.2f} segundos")
        print(f"📦 Total de pacotes enviados: {self.stats['packets_sent']}")
        print(f"📈 Taxa média: {self.stats['packets_sent']/duration:.2f} pacotes/segundo")
        print("\n📋 Pacotes por serviço:")

        for service, count in sorted(self.stats['packets_per_service'].items()):
            percentage = (count / self.stats['packets_sent']) * 100 if self.stats['packets_sent'] > 0 else 0
            print(f"   {service:15}: {count:4d} pacotes ({percentage:5.1f}%)")

        print(f"{'='*80}")

def resolve_targets(ips_or_domains):
    """Resolve a lista de entradas (IPs ou domínios) para uma lista de targets.
    Retorna lista de dicts: { 'ip': str, 'host': str }
    """
    targets = []
    for item in ips_or_domains:
        entry = item.strip()
        if not entry:
            continue
        # Se for URL com esquema (http/https), extrai o hostname
        parsed = urlparse(entry)
        if parsed.scheme and parsed.netloc:
            entry = parsed.hostname or parsed.netloc
        # Remoção simples de barras finais ou caminhos
        if '/' in entry:
            entry = entry.split('/')[0]
        # Tenta tratar como IPv4
        try:
            IPv4Address(entry)
            targets.append({'ip': entry, 'host': entry})
            continue
        except AddressValueError:
            pass

        # Resolve domínio para IPv4
        try:
            infos = socket.getaddrinfo(entry, None, family=socket.AF_INET, type=socket.SOCK_STREAM)
            seen = set()
            for info in infos:
                ip = info[4][0]
                if ip not in seen:
                    seen.add(ip)
                    targets.append({'ip': ip, 'host': entry})
        except socket.gaierror:
            print(f"Erro: Não foi possível resolver o domínio: {entry}")
            sys.exit(1)

    if not targets:
        print("Erro: Nenhum alvo válido informado")
        sys.exit(1)
    return targets


def main():
    parser = argparse.ArgumentParser(
        description="Tsunami Traffic Simulator - Simula tráfego para ocultar IP do atacante",
        formatter_class=argparse.RawDescriptionHelpFormatter,
                epilog="""
Exemplos de uso:
    python3 tsunami_traffic_simulator.py -i 192.168.1.100 -d 60 -p 100
    python3 tsunami_traffic_simulator.py -i 192.168.1.100,192.168.1.101 -d 120 -p 50 -l MAQ-1
    python3 tsunami_traffic_simulator.py -i exemplo.com,192.168.1.100 -d 300 -p 200 -l MAQ-4

Laboratórios disponíveis:
    MAQ-1: Windows Server 2022 Domain Controller
    MAQ-2: Laravel Web Application  
    MAQ-3: Linux Infrastructure
    MAQ-4: Zimbra CVE-2024-45519
                """
    )
    
    parser.add_argument('-i', '--ips', required=True,
                       help='IP(s) ou domínio(s) alvo (separados por vírgula)')
    parser.add_argument('-d', '--duration', type=int, required=True,
                       help='Duração da simulação em segundos')
    parser.add_argument('-p', '--packets', type=int, default=100,
                       help='Número de pacotes por serviço (padrão: 100)')
    parser.add_argument('-l', '--lab', choices=LAB_CONFIGS.keys(),
                       help='Tipo de laboratório (MAQ-1, MAQ-2, MAQ-3, MAQ-4)')
    parser.add_argument('--service', type=str, help='Serviço único (ex: HTTP, HTTPS, FTP, SSH, SMTP)')
    parser.add_argument('--port', type=int, help='Porta única para o serviço definido')
    
    args = parser.parse_args()
    
    # Parse e resolução de IPs/Domínios
    inputs = [x.strip() for x in args.ips.split(',')]
    targets = resolve_targets(inputs)
    
    # Verificação de privilégios (Scapy precisa de root)
    if os.geteuid() != 0:
        print("Erro: Este script precisa ser executado com privilégios de root")
        print("Use: sudo python3 tsunami_traffic_simulator.py ...")
        sys.exit(1)
    
    # Cria e executa o simulador
    # Se --service e --port definidos, ignora LAB_CONFIGS e simula só esse serviço
    if args.service and args.port:
        custom_service = {'name': args.service.upper(), 'port': args.port, 'protocol': 'TCP' if args.service.upper() in ['HTTP', 'HTTPS', 'FTP', 'SSH', 'SMTP'] else 'UDP'}
        class CustomTrafficSimulator(TrafficSimulator):
            def run_simulation(self):
                print("\n" + ('='*80))
                print("🌊 TSUNAMI TRAFFIC SIMULATOR - Simulador de Tráfego para Laboratórios")
                print(('='*80))
                display_targets = [t.get('host') or t['ip'] for t in self.targets]
                print(f"🎯 Alvos: {', '.join(display_targets)}")
                print(f"📦 Pacotes por serviço: {self.packet_count}")
                print(f"🔗 Serviço único: {custom_service['name']}:{custom_service['port']}")
                print(('='*80) + "\n")
                try:
                    while self.running and self.stats['packets_sent'] < self.packet_count:
                        target = random.choice(self.targets)
                        self.simulate_service_traffic(target, custom_service, "0.0.0.0/0")
                        time.sleep(random.uniform(0.1, 2.0))
                except KeyboardInterrupt:
                    print("\n[!] Simulação interrompida pelo usuário")
                self.print_final_stats()
        simulator = CustomTrafficSimulator(
            targets=targets,
            duration=args.duration,
            packet_count=args.packets,
            lab_type=None
        )
        simulator.run_simulation()
    else:
        simulator = TrafficSimulator(
            targets=targets,
            duration=args.duration,
            packet_count=args.packets,
            lab_type=args.lab
        )
        simulator.run_simulation()

if __name__ == "__main__":
    main()
