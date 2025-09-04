#!/usr/bin/env python3
"""
Tsunami Traffic Simulator - Simulador de Tráfego para Laboratórios de Segurança
Simula tráfego de diferentes IPs para ocultar o IP do atacante nos laboratórios MAQ-1, 2, 3 e 4
"""

import random
import time
import argparse
import sys
import threading
from ipaddress import IPv4Address, IPv4Network, AddressValueError
from scapy.all import *
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
    def __init__(self, target_ips, duration, packet_count, lab_type=None):
        self.target_ips = target_ips
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
        
    def signal_handler(self, signum, frame):
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
        except Exception as e:
            # Fallback para IPs aleatórios em redes privadas
            return f"192.168.{random.randint(1,254)}.{random.randint(1,254)}"
    
    def create_tcp_packet(self, src_ip, dst_ip, dst_port, flags="S"):
        """Cria um pacote TCP"""
        sport = random.randint(1024, 65535)
        seq = random.randint(1, 4294967295)
        
        packet = IP(src=src_ip, dst=dst_ip) / \
                TCP(sport=sport, dport=dst_port, flags=flags, seq=seq)
        return packet
    
    def create_udp_packet(self, src_ip, dst_ip, dst_port):
        """Cria um pacote UDP"""
        sport = random.randint(1024, 65535)
        
        packet = IP(src=src_ip, dst=dst_ip) / \
                UDP(sport=sport, dport=dst_port)
        return packet
    
    def create_http_request(self, src_ip, dst_ip, dst_port):
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
        http_request += f"Host: {dst_ip}\r\n"
        http_request += f"User-Agent: {ua}\r\n"
        http_request += "Accept: */*\r\n"
        http_request += "Connection: close\r\n\r\n"
        
        packet = IP(src=src_ip, dst=dst_ip) / \
                TCP(sport=random.randint(1024, 65535), dport=dst_port) / \
                Raw(load=http_request.encode())
        return packet
    
    def simulate_service_traffic(self, target_ip, service, lab_network):
        """Simula tráfego para um serviço específico"""
        service_name = service['name']
        port = service['port']
        protocol = service['protocol']
        
        if service_name not in self.stats['packets_per_service']:
            self.stats['packets_per_service'][service_name] = 0
        
        # Gera IP spoofed
        spoofed_ip = self.generate_spoofed_ip(lab_network)
        
        try:
            if protocol == 'TCP':
                if service_name == 'HTTP' and port in [80, 8080]:
                    # Requisições HTTP realistas
                    packet = self.create_http_request(spoofed_ip, target_ip, port)
                else:
                    # Conexões TCP normais
                    packet = self.create_tcp_packet(spoofed_ip, target_ip, port)
            else:  # UDP
                packet = self.create_udp_packet(spoofed_ip, target_ip, port)
            
            # Envia o pacote
            send(packet, verbose=False)
            
            self.stats['packets_sent'] += 1
            self.stats['packets_per_service'][service_name] += 1
            
            print(f"[{self.stats['packets_sent']:04d}] {service_name:12} | "
                  f"{spoofed_ip:15} -> {target_ip:15}:{port:5} | "
                  f"Protocol: {protocol}")
                  
        except Exception as e:
            print(f"[!] Erro ao enviar pacote para {service_name}: {e}")
    
    def run_simulation(self):
        """Executa a simulação de tráfego"""
        print(f"\n{'='*80}")
        print(f"🌊 TSUNAMI TRAFFIC SIMULATOR - Simulador de Tráfego para Laboratórios")
        print(f"{'='*80}")
        print(f"🎯 IPs Alvo: {', '.join(self.target_ips)}")
        print(f"⏱️  Duração: {self.duration} segundos")
        print(f"📦 Pacotes por serviço: {self.packet_count}")
        if self.lab_type:
            print(f"🏭 Laboratório: {self.lab_type} - {LAB_CONFIGS[self.lab_type]['name']}")
        print(f"{'='*80}\n")
        
        # Determina os serviços baseado no laboratório ou usa todos
        if self.lab_type and self.lab_type in LAB_CONFIGS:
            services = LAB_CONFIGS[self.lab_type]['services']
            lab_network = LAB_CONFIGS[self.lab_type]['network']
        else:
            # Combina todos os serviços de todos os laboratórios
            services = []
            for lab in LAB_CONFIGS.values():
                services.extend(lab['services'])
            lab_network = "192.168.0.0/16"  # Rede ampla para fallback
        
        start_time = time.time()
        end_time = start_time + self.duration
        
        try:
            while self.running and time.time() < end_time:
                # Seleciona IP alvo aleatório
                target_ip = random.choice(self.target_ips)
                
                # Seleciona serviço aleatório
                service = random.choice(services)
                
                # Simula tráfego para o serviço
                self.simulate_service_traffic(target_ip, service, lab_network)
                
                # Intervalo aleatório entre pacotes (0.1 a 2 segundos)
                time.sleep(random.uniform(0.1, 2.0))
                
        except KeyboardInterrupt:
            print("\n[!] Simulação interrompida pelo usuário")
        
        # Estatísticas finais
        self.print_final_stats()
    
    def print_final_stats(self):
        """Imprime estatísticas finais da simulação"""
        duration = time.time() - self.stats['start_time']
        
        print(f"\n{'='*80}")
        print(f"📊 ESTATÍSTICAS FINAIS")
        print(f"{'='*80}")
        print(f"⏱️  Duração total: {duration:.2f} segundos")
        print(f"📦 Total de pacotes enviados: {self.stats['packets_sent']}")
        print(f"📈 Taxa média: {self.stats['packets_sent']/duration:.2f} pacotes/segundo")
        print(f"\n📋 Pacotes por serviço:")
        
        for service, count in sorted(self.stats['packets_per_service'].items()):
            percentage = (count / self.stats['packets_sent']) * 100 if self.stats['packets_sent'] > 0 else 0
            print(f"   {service:15}: {count:4d} pacotes ({percentage:5.1f}%)")
        
        print(f"{'='*80}")

def main():
    parser = argparse.ArgumentParser(
        description="Tsunami Traffic Simulator - Simula tráfego para ocultar IP do atacante",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Exemplos de uso:
  python3 tsunami_traffic_simulator.py -i 192.168.1.100 -d 60 -p 100
  python3 tsunami_traffic_simulator.py -i 192.168.1.100,192.168.1.101 -d 120 -p 50 -l MAQ-1
  python3 tsunami_traffic_simulator.py -i 192.168.1.100 -d 300 -p 200 -l MAQ-4

Laboratórios disponíveis:
  MAQ-1: Windows Server 2022 Domain Controller
  MAQ-2: Laravel Web Application  
  MAQ-3: Linux Infrastructure
  MAQ-4: Zimbra CVE-2024-45519
        """
    )
    
    parser.add_argument('-i', '--ips', required=True,
                       help='IP(s) alvo (separados por vírgula)')
    parser.add_argument('-d', '--duration', type=int, required=True,
                       help='Duração da simulação em segundos')
    parser.add_argument('-p', '--packets', type=int, default=100,
                       help='Número de pacotes por serviço (padrão: 100)')
    parser.add_argument('-l', '--lab', choices=LAB_CONFIGS.keys(),
                       help='Tipo de laboratório (MAQ-1, MAQ-2, MAQ-3, MAQ-4)')
    
    args = parser.parse_args()
    
    # Parse dos IPs
    target_ips = [ip.strip() for ip in args.ips.split(',')]
    
    # Validação dos IPs
    for ip in target_ips:
        try:
            IPv4Address(ip)
        except AddressValueError:
            print(f"Erro: IP inválido: {ip}")
            sys.exit(1)
    
    # Verificação de privilégios (Scapy precisa de root)
    if os.geteuid() != 0:
        print("Erro: Este script precisa ser executado com privilégios de root")
        print("Use: sudo python3 tsunami_traffic_simulator.py ...")
        sys.exit(1)
    
    # Cria e executa o simulador
    simulator = TrafficSimulator(
        target_ips=target_ips,
        duration=args.duration,
        packet_count=args.packets,
        lab_type=args.lab
    )
    
    simulator.run_simulation()

if __name__ == "__main__":
    main()
