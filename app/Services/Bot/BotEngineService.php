<?php

namespace App\Services\Bot;

use App\Models\Bot;
use App\Models\BotStep;
use App\Models\BotSession;
use App\Models\BotUsageLog;
use App\Models\Customer;
use App\Services\Bot\ChatwootService;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;
use Carbon\Carbon;

class BotEngineService
{
    /**
     * Procesa un mensaje entrante
     */
    public function handleMessage(Bot $bot, string $phone, string $message, bool $skipChatwoot = false): ?string
    {
        // 1. Validar si el bot está activo
        if (!$bot->is_active) return null;

        // 2. Normalizar Teléfono y Buscar Cliente
        $phone = $this->normalizePhone($phone);
        $customer = Customer::where('phone', 'like', "%{$phone}")->first();

        // 3. Enviar a Chatwoot si está habilitado y no se solicitó omitir (Seguimiento en espejo)
        if ($bot->chatwoot_enabled && !$skipChatwoot) {
            app(ChatwootService::class)->sendMessage($bot, $phone, $message, $customer, 'incoming');
        }

        // 4. Validar Modo Prueba (Whitelist)
        if ($bot->test_mode) {
            $whitelist = $bot->whitelist ?? [];
            if (!in_array($phone, $whitelist)) {
                return "Disculpa, el bot se encuentra en mantenimiento (Modo Prueba).";
            }
        }

        // 3. Validar Horarios (Simplificado)
        if (!$this->isInSchedule($bot)) {
            // Podríamos retornar un mensaje de "fuera de horario" si se desea
            // return "Estamos fuera de horario de atención.";
        }

        // 4. Obtener o crear sesión
        $session = BotSession::firstOrCreate(
            ['bot_id' => $bot->id, 'phone_number' => $phone],
            ['current_step_id' => $this->getInitialStepId($bot, $customer)]
        );

        // 5. PRIORIDAD: Buscar en Memoria o IA antes de procesar el paso (Interrupciones Inteligentes)
        $fallbackResponse = $this->fallbackLogic($bot, $phone, $message, $session, $customer);
        if ($fallbackResponse) {
            $session->update(['last_interaction_at' => now()]);
            return $fallbackResponse;
        }

        // 6. Procesar lógica según el paso actual del flujo
        $response = $this->processStep($session, $message, $customer);

        Log::info("BotEngine: Respuesta generada para {$phone}: " . ($response ?? 'NULL'));

        $session->update(['last_interaction_at' => now()]);

        return $response;
    }

    /**
     * Determina el paso inicial según si es cliente o no
     */
    protected function getInitialStepId(Bot $bot, ?Customer $customer): ?int
    {
        $stepName = $customer ? 'Bienvenida Cliente' : 'Bienvenida No Cliente';
        $step = $bot->steps()->where('name', $stepName)->first();
        
        // Fallback al primer paso por orden si no existen nombres específicos
        return $step ? $step->id : $bot->steps()->where('order', 0)->first()?->id;
    }

    /**
     * Lógica de procesamiento de pasos del flujo
     */
    protected function processStep(BotSession $session, string $input, ?Customer $customer = null, int $depth = 0): ?string
    {
        if ($depth > 5) return "Error: Bucle de flujo detectado.";

        $currentStep = $session->currentStep;
        if (!$currentStep) return null;

        $response = null;

        switch ($currentStep->type) {
            case 'menu':
                $options = $currentStep->content['options'] ?? [];
                $targetId = null;
                
                // Buscar coincidencia en opciones
                foreach ($options as $opt) {
                    if (strtolower(trim($input)) == strtolower(trim($opt['label']))) {
                        $targetId = $opt['target_step_id'];
                        break;
                    }
                }

                if ($targetId) {
                    $nextStep = BotStep::find($targetId);
                    $session->update(['current_step_id' => $nextStep->id]);
                    // Al avanzar desde un menú por elección del usuario, procesamos el nuevo paso
                    return $this->processStep($session, "", $customer, $depth + 1);
                }
                
                // Si es la primera vez que llegamos al menú (vía Welcome), solo lo renderizamos
                if ($input === "" || $depth > 0) {
                    return $this->renderStep($currentStep, $customer);
                }
                
                // Si no coincide, repetir menú
                return "Opción no válida. \n" . $this->renderStep($currentStep, $customer);

            case 'input':
                // Guardar variable
                $variableName = $currentStep->content['variable'] ?? 'temp';
                $variables = $session->variables ?? [];
                $variables[$variableName] = $input;
                
                $nextStep = BotStep::find($currentStep->next_step_id);
                if ($nextStep) {
                    $session->update([
                        'variables' => $variables,
                        'current_step_id' => $nextStep->id
                    ]);
                    $session->refresh();
                    return $this->processStep($session, "", $customer, $depth + 1);
                }
                
                return null;

            case 'message':
            case 'redirect':
                $nextStep = BotStep::find($currentStep->next_step_id);
                if ($nextStep) {
                    $session->update(['current_step_id' => $nextStep->id]);
                    $session->refresh();
                    // Concatenar el mensaje actual y procesar el siguiente (sin el input original)
                    $currentText = $this->renderStep($currentStep, $customer);
                    $nextText = $this->processStep($session, "", $customer, $depth + 1);
                    return $currentText . ($nextText ? "\n\n" . $nextText : "");
                }
                return $this->renderStep($currentStep, $customer);
        }

        return null;
    }

    /**
     * Renderiza el contenido de un paso (reemplaza variables y datos de cliente)
     */
    protected function renderStep(BotStep $step, ?Customer $customer = null): string
    {
        $text = $step->content['text'] ?? '';
        
        // Reemplazar datos del cliente si existen
        if ($customer) {
            $text = str_replace('{{nombre}}', $customer->name, $text);
            $text = str_replace('{{cliente_id}}', $customer->id, $text);
        } else {
            // Si no es cliente, limpiar placeholders
            $text = str_replace('{{nombre}}', 'amigo', $text);
        }
        
        if ($step->type == 'menu') {
            $text .= "\n";
            foreach ($step->content['options'] ?? [] as $opt) {
                $text .= "\n• " . $opt['label'];
            }
        }

        return $text;
    }

    /**
     * Lógica de respaldo: Memoria -> IA
     */
    protected function fallbackLogic(Bot $bot, string $phone, string $message, BotSession $session, ?Customer $customer = null): ?string
    {
        // 1. Consultar Base de Conocimiento Local
        $memory = $this->consultMemory($bot, $message);
        if ($memory) {
            // Personalizar respuesta de memoria si tiene placeholders
            if ($customer) {
                $memory = str_replace('{{nombre}}', $customer->name, $memory);
            } else {
                $memory = str_replace('{{nombre}}', 'amigo', $memory);
            }

            $this->logUsage($bot, $phone, 'memory', 0, 0, ['q' => $message, 'a' => $memory]);
            return $memory;
        }

        // 2. Consultar IA (Si está activada)
        if ($bot->ai_enabled) {
            return $this->consultIA($bot, $phone, $message, $session, $customer);
        }

        return null;
    }

    protected function normalizePhone(string $phone): string
    {
        // Eliminar caracteres no numéricos
        $clean = preg_replace('/[^0-9]/', '', $phone);
        
        // Formato México (521 + 10 dígitos o 52 + 10 dígitos)
        if (strlen($clean) >= 12 && str_starts_with($clean, '52')) {
            return substr($clean, -10);
        }

        // Si ya tiene 10 dígitos, dejarlo así
        if (strlen($clean) == 10) return $clean;

        // Retornar al menos los últimos 10 dígitos si es posible
        return strlen($clean) > 10 ? substr($clean, -10) : $clean;
    }

    /**
     * Busca en la base de conocimiento local
     */
    protected function consultMemory(Bot $bot, string $message): ?string
    {
        $normalized = $this->normalizeText($message);
        
        $item = $bot->knowledgeItems()
            ->where('question_normalized', 'like', "%{$normalized}%")
            ->first();

        if ($item) {
            $item->increment('usage_count');
            return $item->answer;
        }

        return null;
    }

    /**
     * Consulta a OpenAI
     */
    protected function consultIA(Bot $bot, string $phone, string $message, BotSession $session, ?Customer $customer = null): ?string
    {
        // Verificar límites (Sencillo por ahora)
        $todayTokens = $bot->usageLogs()
            ->whereDate('created_at', today())
            ->sum('tokens_used');

        if ($todayTokens >= $bot->ai_daily_token_limit) {
            Log::warning("Bot {$bot->id} alcanzó límite diario de tokens.");
            return null;
        }

        try {
            $response = Http::withHeaders([
                'Authorization' => 'Bearer ' . $bot->ai_api_key,
            ])->post('https://api.openai.com/v1/chat/completions', [
                'model' => $bot->ai_model,
                'messages' => [
                    ['role' => 'system', 'content' => "Eres un asistente útil y amable de una empresa de telecomunicaciones. El usuario actual se llama: " . ($customer ? $customer->name : 'un potencial cliente') . ". Responde de forma corta y profesional."],
                    ['role' => 'user', 'content' => $message],
                ],
                'max_tokens' => $bot->ai_max_tokens,
            ]);

            if ($response->successful()) {
                $data = $response->json();
                $answer = $data['choices'][0]['message']['content'];
                $tokens = $data['usage']['total_tokens'];

                // Guardar en log
                $this->logUsage($bot, $phone, 'ia', $tokens, ($tokens * 0.000002), ['q' => $message, 'a' => $answer]);

                // Opcional: Aprender (Guardar en memoria para la próxima)
                $bot->knowledgeItems()->create([
                    'question_normalized' => $this->normalizeText($message),
                    'answer' => $answer,
                ]);

                return $answer;
            }
        } catch (\Exception $e) {
            Log::error("Error IA Bot: " . $e->getMessage());
        }

        return null;
    }

    protected function logUsage(Bot $bot, string $phone, string $type, int $tokens, float $cost, array $metadata)
    {
        $bot->usageLogs()->create([
            'phone_number' => $phone,
            'interaction_type' => $type,
            'tokens_used' => $tokens,
            'cost' => $cost,
            'metadata' => $metadata,
        ]);
    }

    protected function normalizeText(string $text): string
    {
        $text = strtolower(trim($text));
        $text = preg_replace('/[áàäâ]/u', 'a', $text);
        $text = preg_replace('/[éèëê]/u', 'e', $text);
        $text = preg_replace('/[íìïî]/u', 'i', $text);
        $text = preg_replace('/[óòöô]/u', 'o', $text);
        $text = preg_replace('/[úùüû]/u', 'u', $text);
        return $text;
    }

    protected function isInSchedule(Bot $bot): bool
    {
        if (empty($bot->schedules)) return true;

        $now = now();
        $dayName = strtolower($now->englishDayOfWeek);
        $time = $now->format('H:i:s');

        foreach ($bot->schedules as $s) {
            if ($s['day'] == $dayName) {
                if ($time >= $s['start_time'] && $time <= $s['end_time']) {
                    return true;
                }
            }
        }

        return false;
    }
}
