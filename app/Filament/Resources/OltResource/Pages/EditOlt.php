<?php

namespace App\Filament\Resources\OltResource\Pages;

use App\Filament\Resources\OltResource;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditOlt extends EditRecord
{
    protected static string $resource = OltResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\DeleteAction::make(),
        ];
    }
}
