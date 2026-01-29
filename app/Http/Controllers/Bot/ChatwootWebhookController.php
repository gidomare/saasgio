<?php

namespace App\Http\Controllers\Bot;

use App\Http\Controllers\Controller;
use App\Models\Bot;
use App\Services\Bot\BotEngineService;
use App\Services\Bot\ChatwootService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class ChatwootWebhookController extends Controller
{
    /**
     * Recibe webhooks de Chatwoot
     */
    public function handle(Request $request)
    {
        Log::info("Chatwoot Webhook RECIBIDO: " . json_encode($request->all()));
        $data = $request->all();
        $event = $data['event'] ?? '';
        $accountId = $data['account_id'] ?? null;
        $inboxId = $data['inbox']['id'] ?? ($data['conversation']['inbox_id'] ?? null);
        Log::info("Chatwoot Webhook Búsqueda: AccountID: {$accountId}, InboxID: {$inboxId}");

        // Buscar el bot configurado para esta cuenta e inbox
        $bot = Bot::where('chatwoot_account_id', $accountId)
                  ->where(function($query) use ($inboxId) {
                      $query->where('chatwoot_inbox_id', $inboxId)
                            ->orWhere('chatwoot_inbox_id', 'like', "%{$inboxId}%");
                  })
                  ->first();

        if (!$bot) {
            Log::warning("Chatwoot Webhook: No se encontró bot para AccountId: {$accountId}, InboxId: {$inboxId}. Bots disponibles: " . Bot::pluck('chatwoot_inbox_id', 'chatwoot_account_id'));
            return response()->json(['status' => 'bot_not_found']);
        }

        // 1. Mensaje de CLIENTE (Entrante) -> Bot debe responder
        if ($event === 'message_created' && ($data['message_type'] ?? '') === 'incoming') {
            $content = $data['content'] ?? '';
            $phone = $data['sender']['phone_number'] ?? ($data['sender']['source_id'] ?? '');
            
            // Limpiar "+" del teléfono si existe
            $phone = ltrim($phone, '+');

            Log::info("Chatwoot Webhook: Mensaje entrante de {$phone}: {$content}");

            // Procesar con el motor, saltando el espejo (porque el mensaje ya está en Chatwoot)
            $response = app(BotEngineService::class)->handleMessage($bot, $phone, $content, true);

            if ($response) {
                // Enviar respuesta DE VUELTA a Chatwoot como respuesta del BOT (outgoing)
                app(ChatwootService::class)->sendMessage($bot, $phone, $response, null, 'outgoing');
            }
        }

        // 2. Mensaje de AGENTE (Saliente) -> Loguear o reenviar a WhatsApp
        if ($event === 'message_created' && ($data['message_type'] ?? '') === 'outgoing') {
            $content = $data['content'] ?? '';
            $phone = $data['conversation']['contact_inbox']['source_id'] ?? '';
            
            Log::info("Chatwoot Webhook: Respuesta de agente para {$phone}: {$content}");

            // Aquí se integraría con el servicio de envío de WhatsApp real
        }

        return response()->json(['status' => 'ok']);
    }
}
