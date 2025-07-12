<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Auth;

class UserApiController extends Controller
{
    /**
     * Teste de autenticação para debug
     * 
     * @param Request $request
     * @return JsonResponse
     */
    public function testAuth(Request $request): JsonResponse
    {
        $webAuth = Auth::guard('web')->check();
        $sanctumAuth = Auth::guard('sanctum')->check();
        $hasBearerToken = $request->bearerToken() ? true : false;
        
        $webUser = Auth::guard('web')->user();
        $sanctumUser = Auth::guard('sanctum')->user();
        
        return response()->json([
            'success' => true,
            'message' => 'Authentication test',
            'data' => [
                'web_authenticated' => $webAuth,
                'sanctum_authenticated' => $sanctumAuth,
                'has_bearer_token' => $hasBearerToken,
                'user_agent' => $request->userAgent(),
                'session_id' => $request->session()->getId(),
                'web_user_id' => $webUser ? $webUser->id : null,
                'sanctum_user_id' => $sanctumUser ? $sanctumUser->id : null,
                'web_user_name' => $webUser ? $webUser->name : null,
                'sanctum_user_name' => $sanctumUser ? $sanctumUser->name : null,
                'session_has_user' => $request->session()->has('auth'),
                'session_user_id' => $request->session()->get('auth'),
            ]
        ], 200);
    }

    /**
     * Lista todos os usuários com suas roles
     * 
     * Esta função simula uma rota de API vulnerável mas autenticada,
     * acessível por qualquer usuário registrado no sistema.
     * Expõe informações sensíveis como o tipo de perfil (role) de cada usuário.
     * 
     * @param Request $request
     * @return JsonResponse
     */
    public function listUsers(Request $request): JsonResponse
    {
        try {
            // Busca todos os usuários com suas roles
            $users = User::with('roles')->get();
            
            // Formata os dados para retorno
            $formattedUsers = $users->map(function ($user) {
                return [
                    'id' => $user->id,
                    'name' => $user->name,
                    'email' => $user->email,
                    'role' => $user->roles->first() ? $user->roles->first()->name : 'Sem role',
                    'role_id' => $user->roles->first() ? $user->roles->first()->id : null,
                    'created_at' => $user->created_at,
                    'updated_at' => $user->updated_at,
                    // Informações adicionais que podem ser sensíveis
                    'telephone' => $user->telephone,
                    'cell' => $user->cell,
                    'city' => $user->city,
                    'state' => $user->state,
                    'company_id' => $user->company_id,
                    'affiliation_id' => $user->affiliation_id,
                ];
            });
            
            return response()->json([
                'success' => true,
                'message' => 'Lista de usuários recuperada com sucesso',
                'data' => [
                    'users' => $formattedUsers,
                    'total_users' => $users->count(),
                    'timestamp' => now()->toISOString(),
                ]
            ], 200);
            
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Erro ao recuperar lista de usuários',
                'error' => $e->getMessage()
            ], 500);
        }
    }
    
    /**
     * Busca usuário específico por ID com suas roles
     * 
     * @param Request $request
     * @param int $id
     * @return JsonResponse
     */
    public function getUserById(Request $request, int $id): JsonResponse
    {
        try {
            $user = User::with('roles')->find($id);
            
            if (!$user) {
                return response()->json([
                    'success' => false,
                    'message' => 'Usuário não encontrado'
                ], 404);
            }
            
            $formattedUser = [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'role' => $user->roles->first() ? $user->roles->first()->name : 'Sem role',
                'role_id' => $user->roles->first() ? $user->roles->first()->id : null,
                'created_at' => $user->created_at,
                'updated_at' => $user->updated_at,
                'telephone' => $user->telephone,
                'cell' => $user->cell,
                'city' => $user->city,
                'state' => $user->state,
                'company_id' => $user->company_id,
                'affiliation_id' => $user->affiliation_id,
            ];
            
            return response()->json([
                'success' => true,
                'message' => 'Usuário encontrado com sucesso',
                'data' => $formattedUser
            ], 200);
            
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Erro ao buscar usuário',
                'error' => $e->getMessage()
            ], 500);
        }
    }
} 