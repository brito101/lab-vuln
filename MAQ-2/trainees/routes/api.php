<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\UserApiController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

// Rotas de autenticação (públicas)
Route::post('/login', [AuthController::class, 'login'])->name('api.login');
Route::post('/logout', [AuthController::class, 'logout'])->name('api.logout');

// Rota padrão do Laravel Sanctum
Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

// Rota de teste de autenticação (sem middleware para debug)
Route::get('/test-auth', [UserApiController::class, 'testAuth'])->name('api.test.auth');

// Rotas vulneráveis mas autenticadas para simulação de laboratório
// Aceita tanto autenticação de sessão quanto tokens Sanctum
Route::middleware('api.auth')->group(function () {
    // Informações do usuário autenticado
    Route::get('/me', [AuthController::class, 'me'])->name('api.me');
    
    // Lista todos os usuários com suas roles (vulnerável - expõe informações sensíveis)
    Route::get('/users', [UserApiController::class, 'listUsers'])->name('api.users.list');
    
    // Busca usuário específico por ID (vulnerável - expõe informações sensíveis)
    Route::get('/users/{id}', [UserApiController::class, 'getUserById'])->name('api.users.show');
});
