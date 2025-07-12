<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Symfony\Component\HttpFoundation\Response;

class ApiAuth
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        // Verifica se o usuário está autenticado no guard web
        if (Auth::guard('web')->check()) {
            return $next($request);
        }

        // Se não está autenticado, retorna erro
        return response()->json([
            'success' => false,
            'message' => 'Unauthorized. Authentication required.',
            'error' => 'User not authenticated.',
            'debug' => [
                'auth_check' => auth()->check(),
                'web_auth_check' => Auth::guard('web')->check(),
                'session_id' => $request->session()->getId(),
                'user_agent' => $request->userAgent(),
            ]
        ], 401);
    }
} 