<?php

namespace App\Filament\Resources\BotStepResource\Pages;

use App\Filament\Resources\BotStepResource;
use Filament\Actions;
use Filament\Resources\Pages\ListRecords;

class ListBotSteps extends ListRecords
{
    protected static string $resource = BotStepResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make(),
        ];
    }
}
