#!/bin/bash

echo "🔍 Monitor de Instalação do Windows - MAQ-1"
echo "=========================================="

check_installation_status() {
    echo "[$(date '+%H:%M:%S')] Verificando status..."
    
    # Verificar se o container está rodando
    if ! docker ps | grep -q "maq1-windows"; then
        echo "❌ Container não está rodando!"
        return 1
    fi
    
    # Verificar logs para status da instalação
    local logs=$(docker logs maq1-windows 2>/dev/null | tail -20)
    
    if echo "$logs" | grep -q "Downloading Windows Server"; then
        echo "📥 Windows Server 2022 sendo baixado..."
        if echo "$logs" | grep -q "100%"; then
            echo "✅ Download completo!"
        else
            # Extrair progresso se disponível
            local progress=$(echo "$logs" | grep -o "[0-9]\+%" | tail -1)
            if [[ -n "$progress" ]]; then
                echo "📊 Progresso: $progress"
            fi
        fi
    elif echo "$logs" | grep -q "Extracting Windows"; then
        echo "📦 Extraindo imagem do Windows..."
    elif echo "$logs" | grep -q "Building Windows"; then
        echo "🔧 Construindo imagem do Windows..."
    elif echo "$logs" | grep -q "Windows started succesfully"; then
        echo "🚀 Windows iniciou com sucesso!"
        echo "🌐 Interface web disponível em: http://localhost:8006"
        
        # Testar WinRM
        echo "🔧 Testando WinRM..."
        if timeout 5 bash -c 'cat < /dev/null > /dev/tcp/localhost/5985' 2>/dev/null; then
            echo "✅ Porta WinRM acessível"
            
            # Teste rápido do WinRM
            if python3 -c "
import winrm
try:
    session = winrm.Session('http://localhost:5985/wsman', 
                           auth=('Docker', 'admin'), 
                           transport='basic',
                           operation_timeout_sec=5,
                           read_timeout_sec=10)
    session.run_ps('echo test')
    print('✅ WinRM funcionando!')
    exit(0)
except:
    print('⏳ WinRM ainda não está pronto')
    exit(1)
" 2>/dev/null; then
                echo "🎉 LABORATÓRIO PRONTO PARA USO!"
                echo "💻 Execute: ./attack-test.sh"
                return 0
            else
                echo "⏳ WinRM configurando... (aguarde mais alguns minutos)"
            fi
        else
            echo "⏳ Porta WinRM ainda não está acessível"
        fi
    else
        echo "⏳ Windows ainda inicializando..."
    fi
    
    return 1
}

# Loop de monitoramento
echo "🔄 Iniciando monitoramento (Ctrl+C para parar)..."
echo ""

while true; do
    if check_installation_status; then
        echo ""
        echo "🏁 Instalação completa! O laboratório está pronto."
        break
    fi
    echo ""
    sleep 30
done