#!/bin/bash

echo "=== Instalando enum4linux ==="

# Verificar se enum4linux já está instalado
if command -v enum4linux &> /dev/null; then
    echo "enum4linux já está instalado"
    exit 0
fi

# Tentar instalar via apt primeiro
if apt-get install -y enum4linux 2>/dev/null; then
    echo "enum4linux instalado via apt"
    exit 0
fi

# Se não estiver disponível via apt, instalar manualmente
echo "Instalando enum4linux manualmente..."

# Instalar dependências
apt-get update
apt-get install -y git perl

# Clonar e instalar enum4linux
cd /tmp
git clone https://github.com/CiscoCXSecurity/enum4linux.git
cd enum4linux
chmod +x enum4linux.pl
cp enum4linux.pl /usr/local/bin/enum4linux
cp enum4linux-ng.py /usr/local/bin/enum4linux-ng

echo "enum4linux instalado manualmente" 