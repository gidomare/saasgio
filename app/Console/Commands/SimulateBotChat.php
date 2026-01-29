<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Bot;
use App\Services\Bot\BotEngineService;

class SimulateBotChat extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'bot:simulate {bot_id} {phone} {message}';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Simula el envío de un mensaje a un bot seleccionado';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $botId = $this->argument('bot_id');
        $phone = $this->argument('phone');
        $message = $this->argument('message');

        $bot = Bot::find($botId);

        if (!$bot) {
            $this->error("Bot no encontrado.");
            return;
        }

        $service = new BotEngineService();
        
        $this->info("Enviando mensaje de [$phone]: '$message' al Bot: {$bot->name}");
        $this->line("---------------------------------------------------------");

        $response = $service->handleMessage($bot, $phone, $message);

        if ($response) {
            $this->comment("Bot responde:");
            $this->info($response);
        } else {
            $this->warn("El bot no generó ninguna respuesta.");
        }
        
        $this->line("---------------------------------------------------------");
    }
}
