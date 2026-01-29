<?php

namespace App\Filament\Resources\BotUsageLogResource\Pages;

use App\Filament\Resources\BotUsageLogResource;
use Filament\Actions;
use Filament\Resources\Pages\ViewRecord;

class ViewBotUsageLog extends ViewRecord
{
    protected static string $resource = BotUsageLogResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\EditAction::make(),
        ];
    }
}
