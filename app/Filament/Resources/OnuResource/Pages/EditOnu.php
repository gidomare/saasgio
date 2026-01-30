<?php

namespace App\Filament\Resources\OnuResource\Pages;

use App\Filament\Resources\OnuResource;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditOnu extends EditRecord
{
    protected static string $resource = OnuResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\DeleteAction::make(),
        ];
    }
}
