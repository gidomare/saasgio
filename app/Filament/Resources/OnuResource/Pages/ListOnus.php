<?php

namespace App\Filament\Resources\OnuResource\Pages;

use App\Filament\Resources\OnuResource;
use Filament\Actions;
use Filament\Resources\Pages\ListRecords;

class ListOnus extends ListRecords
{
    protected static string $resource = OnuResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make(),
        ];
    }
}
