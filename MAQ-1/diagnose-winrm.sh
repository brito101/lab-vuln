#!/bin/bash

# Diagnóstico WinRM para Laboratório de Vulnerabilidades
# Script para identificar e resolver problemas de conectividade WinRM

echo "🔍 DIAGNÓSTICO WinRM - Laboratório de Vulnerabilidades"
echo "=================================================="
echo ""

# 1. Verificar container Windows
echo "1️⃣  Verificando status do container Windows..."
if docker ps | grep -q "dockurr/windows"; then
    echo "✅ Container Windows está EXECUTANDO"
    container_id=$(docker ps --format "{{.ID}}" --filter "ancestor=dockurr/windows" | head -n1)
    echo "   Container ID: $container_id"
    
    # Verificar tempo de execução
    uptime=$(docker ps --format "{{.Status}}" --filter "id=$container_id")
    echo "   Status: $uptime"
    
    # Verificar recursos
    echo "   Verificando recursos do container..."
    docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}" $container_id
else
    echo "❌ Container Windows NÃO está em execução"
    echo ""
    echo "🛠️  Para iniciar o Windows:"
    echo "   cd MAQ-1 && docker-compose up -d windows"
    exit 1
fi

echo ""

# 2. Verificar conectividade de rede
echo "2️⃣  Verificando conectividade de rede..."

# Ping básico
echo "   Testando ping para localhost:5985..."
if timeout 5 bash -c "</dev/tcp/localhost/5985" &>/dev/null; then
    echo "✅ Porta 5985 está ACESSÍVEL"
else
    echo "❌ Porta 5985 NÃO está acessível"
fi

# Verificar mapeamento de portas
echo "   Mapeamento de portas:"
docker port $container_id 2>/dev/null || echo "   Nenhum mapeamento encontrado"

echo ""

# 3. Testar WinRM
echo "3️⃣  Testando conectividade WinRM..."

# Instalar python3-winrm se necessário
if ! python3 -c "import winrm" &>/dev/null; then
    echo "   ⚠️  Biblioteca python3-winrm não encontrada"
    echo "   💡 Para instalar: sudo apt update && sudo apt install -y python3-winrm"
fi

# Teste básico de conectividade WinRM
echo "   Executando teste WinRM..."
python3 << 'EOF'
try:
    import winrm
    import sys
    import socket
    from urllib3.exceptions import InsecureRequestWarning
    import urllib3
    
    # Suprimir warnings SSL
    urllib3.disable_warnings(InsecureRequestWarning)
    
    # Configurar sessão WinRM com timeout menor
    session = winrm.Session(
        'http://localhost:5985/wsman',
        auth=('Docker', 'admin'),
        transport='basic',
        server_cert_validation='ignore',
        read_timeout_sec=15,
        operation_timeout_sec=10
    )
    
    # Teste simples com comando CMD primeiro
    print("   Tentando executar comando CMD...")
    try:
        result = session.run_cmd('echo WinRM_OK')
        if result.status_code == 0:
            print("✅ WinRM CMD está FUNCIONANDO!")
            print(f"   Resposta: {result.std_out.decode().strip()}")
        else:
            print("❌ Erro na execução do comando CMD")
            print(f"   Código: {result.status_code}")
    except Exception as cmd_error:
        print(f"❌ Erro CMD: {cmd_error}")
        
        # Tentar PowerShell se CMD falhar
        print("   Tentando PowerShell...")
        try:
            result = session.run_ps('Write-Output "WinRM_PS_OK"')
            if result.status_code == 0:
                print("✅ WinRM PowerShell está FUNCIONANDO!")
                print(f"   Resposta: {result.std_out.decode().strip()}")
            else:
                print("❌ Erro na execução PowerShell")
                print(f"   Código: {result.status_code}")
        except Exception as ps_error:
            print(f"❌ Erro PowerShell: {ps_error}")
        
except ImportError:
    print("❌ Biblioteca winrm não instalada")
    print("   Para instalar: sudo apt update && sudo apt install -y python3-winrm")
except Exception as e:
    error_msg = str(e)
    if "Read timed out" in error_msg:
        print("❌ Timeout na conexão WinRM")
        print("   💡 WinRM pode não estar configurado ou Windows ainda iniciando")
        print("   💡 Acesse http://localhost:8006 e execute o script de configuração")
    elif "Connection refused" in error_msg:
        print("❌ Conexão recusada - WinRM não está rodando")
        print("   💡 Configure WinRM no Windows")
    else:
        print(f"❌ Erro: {error_msg}")
        print("   💡 Verifique configuração do WinRM")
EOF

echo ""

# 4. Verificar arquivos de configuração
echo "4️⃣  Verificando arquivos de configuração..."

if [ -f "artefatos/configure-winrm.ps1" ]; then
    echo "✅ Script de configuração WinRM encontrado"
else
    echo "❌ Script de configuração WinRM NÃO encontrado"
    echo "   💡 Execute: ./setup-winrm.sh para criar os scripts"
fi

echo ""

# 5. Verificar acesso ao Windows
echo "5️⃣  Verificando acesso ao Windows..."

echo "   🌐 Web (VNC): http://localhost:8006"
echo "   🖥️  RDP: localhost:3389 (usuário: Docker, senha: admin)"

# Verificar se as portas estão acessíveis
if timeout 2 bash -c "</dev/tcp/localhost/8006" &>/dev/null; then
    echo "✅ Porta 8006 (Web) está acessível"
else
    echo "❌ Porta 8006 (Web) não está acessível"
fi

if timeout 2 bash -c "</dev/tcp/localhost/3389" &>/dev/null; then
    echo "✅ Porta 3389 (RDP) está acessível"
else
    echo "❌ Porta 3389 (RDP) não está acessível"
fi

echo ""

# 6. Resumo e próximos passos
echo "📋 RESUMO E PRÓXIMOS PASSOS"
echo "========================="
echo ""

if timeout 5 bash -c "</dev/tcp/localhost/5985" &>/dev/null; then
    echo "🔧 WinRM está acessível mas pode não estar configurado."
    echo ""
    echo "📝 PRÓXIMOS PASSOS:"
    echo "1. 🌐 Acesse http://localhost:8006"
    echo "2. 🔧 Execute no Windows: PowerShell -ExecutionPolicy Bypass -File \"\\host.lan\Data\configure-winrm.ps1\""
    echo "3. ✅ Teste com: ./setup-winrm.sh test"
else
    echo "⚠️  WinRM não está acessível."
    echo ""
    echo "📝 PRÓXIMOS PASSOS:"
    echo "1. ⏰ Aguarde 5-10 minutos (Windows pode estar inicializando)"
    echo "2. 🌐 Acesse http://localhost:8006 para verificar o Windows"
    echo "3. 🔧 Configure WinRM manualmente se necessário"
fi

echo ""
echo "💡 Para configuração automática: ./setup-winrm.sh"
echo "🧪 Para testar após configuração: ./setup-winrm.sh test"