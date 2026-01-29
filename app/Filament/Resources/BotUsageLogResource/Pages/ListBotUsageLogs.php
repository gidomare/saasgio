<?php

namespace App\Filament\Resources\BotUsageLogResource\Pages;

use App\Filament\Resources\BotUsageLogResource;
use Filament\Actions;
use Filament\Resources\Pages\ListRecords;

class ListBotUsageLogs extends ListRecords
{
    protected static string $resource = BotUsageLogResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make(),
        ];
    }
}
