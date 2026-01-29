<?php

namespace App\Filament\Resources\BotStepResource\Pages;

use App\Filament\Resources\BotStepResource;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditBotStep extends EditRecord
{
    protected static string $resource = BotStepResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\DeleteAction::make(),
        ];
    }
}
