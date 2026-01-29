<?php

namespace App\Filament\Resources\BotKnowledgeBaseResource\Pages;

use App\Filament\Resources\BotKnowledgeBaseResource;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditBotKnowledgeBase extends EditRecord
{
    protected static string $resource = BotKnowledgeBaseResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\DeleteAction::make(),
        ];
    }
}
