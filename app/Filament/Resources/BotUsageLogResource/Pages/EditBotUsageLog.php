<?php

namespace App\Filament\Resources\BotUsageLogResource\Pages;

use App\Filament\Resources\BotUsageLogResource;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditBotUsageLog extends EditRecord
{
    protected static string $resource = BotUsageLogResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\ViewAction::make(),
            Actions\DeleteAction::make(),
        ];
    }
}
