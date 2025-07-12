#!/bin/bash

# Script de teste para as rotas API vulneráveis
# Laboratório de Segurança - MAQ-2

echo "=== Teste das Rotas API Vulneráveis ==="
echo ""

# Configurações
BASE_URL="http://localhost:8000/api"
EMAIL="admin@example.com"  # Altere para um email válido do sistema
PASSWORD="password"        # Altere para a senha correta

echo "1. Fazendo login para obter token..."
echo "Email: $EMAIL"
echo ""

# Login
LOGIN_RESPONSE=$(curl -s -X POST "$BASE_URL/login" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d "{
    \"email\": \"$EMAIL\",
    \"password\": \"$PASSWORD\"
  }")

echo "Resposta do login:"
echo "$LOGIN_RESPONSE" | jq '.' 2>/dev/null || echo "$LOGIN_RESPONSE"
echo ""

# Extrair token
TOKEN=$(echo "$LOGIN_RESPONSE" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)

if [ -z "$TOKEN" ]; then
    echo "❌ Erro: Não foi possível obter o token. Verifique as credenciais."
    exit 1
fi

echo "✅ Token obtido com sucesso!"
echo "Token: ${TOKEN:0:20}..."
echo ""

echo "2. Testando rota /api/me (informações do usuário autenticado)..."
echo ""

ME_RESPONSE=$(curl -s -X GET "$BASE_URL/me" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Accept: application/json")

echo "Resposta do /me:"
echo "$ME_RESPONSE" | jq '.' 2>/dev/null || echo "$ME_RESPONSE"
echo ""

echo "3. Testando rota vulnerável /api/users (lista todos os usuários)..."
echo "⚠️  VULNERABILIDADE: Esta rota expõe informações sensíveis de todos os usuários!"
echo ""

USERS_RESPONSE=$(curl -s -X GET "$BASE_URL/users" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Accept: application/json")

echo "Resposta do /users:"
echo "$USERS_RESPONSE" | jq '.' 2>/dev/null || echo "$USERS_RESPONSE"
echo ""

echo "4. Testando rota vulnerável /api/users/1 (busca usuário específico)..."
echo "⚠️  VULNERABILIDADE: Esta rota expõe informações sensíveis de usuário específico!"
echo ""

USER_RESPONSE=$(curl -s -X GET "$BASE_URL/users/1" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Accept: application/json")

echo "Resposta do /users/1:"
echo "$USER_RESPONSE" | jq '.' 2>/dev/null || echo "$USER_RESPONSE"
echo ""

echo "5. Fazendo logout..."
echo ""

LOGOUT_RESPONSE=$(curl -s -X POST "$BASE_URL/logout" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Accept: application/json")

echo "Resposta do logout:"
echo "$LOGOUT_RESPONSE" | jq '.' 2>/dev/null || echo "$LOGOUT_RESPONSE"
echo ""

echo "=== Análise das Vulnerabilidades ==="
echo ""
echo "🔍 Vulnerabilidades identificadas:"
echo "1. Exposição de informações pessoais (telefone, cidade, estado)"
echo "2. Exposição de roles/perfis de usuários"
echo "3. Falta de controle de acesso (qualquer usuário pode ver dados de outros)"
echo "4. Exposição de relacionamentos com empresas e afiliações"
echo ""
echo "🎯 Cenários de ataque possíveis:"
echo "1. Enumeração de usuários administrativos"
echo "2. Coleta de dados para engenharia social"
echo "3. Mapeamento da estrutura organizacional"
echo "4. Identificação de alvos para ataques direcionados"
echo ""
echo "✅ Teste concluído!"
echo ""
echo "📝 Para mais detalhes, consulte o arquivo API_VULNERABLE_ROUTES.md" 