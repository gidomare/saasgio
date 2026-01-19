<?php

namespace App\Filament\Resources\RouterResource\Pages;

use App\Filament\Resources\RouterResource;
use App\Jobs\TestRouterConnectionJob;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditRouter extends EditRecord
{
    protected static string $resource = RouterResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\DeleteAction::make(),
        ];
    }

    protected function afterSave(): void
    {
        // Ejecutar job inmediatamente de forma síncrona
        TestRouterConnectionJob::dispatchSync($this->record);
    }

    protected function getRedirectUrl(): string
    {
        return $this->getResource()::getUrl('index');
    }
}
