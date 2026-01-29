<?php

namespace App\Services\Bot;

use App\Models\Bot;
use App\Models\Customer;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class ChatwootService
{
    /**
     * Envía un mensaje a Chatwoot (y crea el contacto/conversación si no existe)
     */
    public function sendMessage(Bot $bot, string $phone, string $message, ?Customer $customer = null, string $messageType = 'outgoing')
    {
        if (!$bot->chatwoot_enabled) return null;

        $baseUrl = rtrim($bot->chatwoot_url, '/');
        $accountId = $bot->chatwoot_account_id;
        $token = $bot->chatwoot_token;

        try {
            Log::info("ChatwootService: Intentando enviar mensaje a {$phone}");
            // 1. Buscar o Crear Contacto
            $contactId = $this->getOrCreateContact($bot, $phone, $customer);
            Log::info("ChatwootService: ContactID obtenido: " . ($contactId ?? 'NULL'));
            if (!$contactId) return null;

            // 2. Buscar o Crear Conversación Activa
            $conversationId = $this->getOrCreateConversation($bot, $contactId);
            Log::info("ChatwootService: ConversationID obtenido: " . ($conversationId ?? 'NULL'));
            if (!$conversationId) return null;

            // 3. Enviar Mensaje
            $response = Http::withHeaders(['api_access_token' => $token])
                ->post("{$baseUrl}/api/v1/accounts/{$accountId}/conversations/{$conversationId}/messages", [
                    'content' => $message,
                    'message_type' => $messageType, 
                ]);

            Log::info("ChatwootService: Resultado envío: " . ($response->successful() ? 'EXITO' : 'FALLO - ' . $response->body()));
            return $response->successful();
        } catch (\Exception $e) {
            Log::error("Error ChatwootService: " . $e->getMessage());
            return null;
        }
    }

    protected function getOrCreateContact(Bot $bot, string $phone, ?Customer $customer)
    {
        $baseUrl = rtrim($bot->chatwoot_url, '/');
        $accountId = $bot->chatwoot_account_id;
        $token = $bot->chatwoot_token;
        $inboxId = $bot->chatwoot_inbox_id;

        // Buscar por teléfono
        $search = Http::withHeaders(['api_access_token' => $token])
            ->get("{$baseUrl}/api/v1/accounts/{$accountId}/contacts/search", ['q' => $phone]);

        if ($search->successful() && !empty($search->json()['payload'])) {
            return $search->json()['payload'][0]['id'];
        }

        // Crear si no existe
        $create = Http::withHeaders(['api_access_token' => $token])
            ->post("{$baseUrl}/api/v1/accounts/{$accountId}/contacts", [
                'name' => $customer ? $customer->name : "Cliente {$phone}",
                'phone_number' => "+{$phone}", // Asumiendo formato internacional sin el +
                'inbox_id' => $inboxId,
            ]);

        return $create->successful() ? $create->json()['payload']['contact']['id'] : null;
    }

    protected function getOrCreateConversation(Bot $bot, int $contactId)
    {
        $baseUrl = rtrim($bot->chatwoot_url, '/');
        $accountId = $bot->chatwoot_account_id;
        $token = $bot->chatwoot_token;
        $inboxId = $bot->chatwoot_inbox_id;

        // Buscar conversaciones abiertas
        $search = Http::withHeaders(['api_access_token' => $token])
            ->get("{$baseUrl}/api/v1/accounts/{$accountId}/contacts/{$contactId}/conversations");

        if ($search->successful()) {
            foreach ($search->json()['payload'] as $conv) {
                if ($conv['status'] === 'open' && $conv['inbox_id'] == $inboxId) {
                    return $conv['id'];
                }
            }
        }

        // Crear nueva conversación
        Log::info("ChatwootService: Intentando crear nueva conversación para ContactID: {$contactId} en InboxID: {$inboxId}");
        $create = Http::withHeaders(['api_access_token' => $token])
            ->post("{$baseUrl}/api/v1/accounts/{$accountId}/conversations", [
                'contact_id' => $contactId,
                'inbox_id' => $inboxId,
            ]);

        if ($create->successful()) {
            return $create->json()['id'];
        }

        Log::error("ChatwootService: Error al crear conversación: " . $create->body());
        return null;
    }
}
