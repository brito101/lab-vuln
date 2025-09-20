#!/bin/bash

echo "🔧 Configurando WinRM no Windows Server..."

# Verificar se container está rodando
if ! docker ps | grep -q "maq1-windows"; then
    echo "❌ Container maq1-windows não está rodando!"
    exit 1
fi

echo ""
echo "📋 INSTRUÇÕES PARA CONFIGURAR WINRM:"
echo "=================================="
echo ""
echo "1. 🌐 Acesse o Windows:"
echo "   - Web: http://localhost:8006"
echo "   - RDP: localhost:3389 (usuário: Docker, senha: admin)"
echo ""
echo "2. 🔧 Execute o comando abaixo no Windows:"
echo ""
echo "PowerShell (como Administrador):"
echo "PowerShell -ExecutionPolicy Bypass -File \"\\\\host.lan\\Data\\configure-winrm.ps1\""
echo ""
echo "✅ O script irá:"
echo "   • Habilitar WinRM"
echo "   • Configurar autenticação básica"
echo "   • Permitir conexões não criptografadas (lab)"
echo "   • Configurar regras de firewall"
echo "   • Testar a configuração"
echo ""
echo "3. 🧪 Após executar, teste aqui no Linux:"
echo "./setup-winrm.sh test"
echo ""

# Se argumento for "test", testar WinRM
if [[ "$1" == "test" ]]; then
    echo "🧪 TESTANDO WINRM..."
    python3 -c "
import winrm
import sys

try:
    session = winrm.Session('http://localhost:5985/wsman', 
                           auth=('Docker', 'admin'), 
                           transport='basic',
                           operation_timeout_sec=10,
                           read_timeout_sec=15)
    
    result = session.run_ps('echo \"WinRM funcionando!\"')
    print('✅ WinRM configurado e funcionando!')
    print(f'Saída: {result.std_out.decode().strip()}')
    print('')
    print('🎉 Agora você pode executar: ./attack-test.sh')
    sys.exit(0)
    
except Exception as e:
    print(f'❌ WinRM ainda não configurado: {e}')
    print('Execute um dos scripts no Windows primeiro.')
    sys.exit(1)
"
fi