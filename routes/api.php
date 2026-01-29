<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::post('/chatwoot/webhook', [\App\Http\Controllers\Bot\ChatwootWebhookController::class, 'handle']);
