<?php

namespace App\Filament\Resources\RouterResource\Pages;

use App\Filament\Resources\RouterResource;
use App\Jobs\TestRouterConnectionJob;
use Filament\Actions;
use Filament\Resources\Pages\CreateRecord;

class CreateRouter extends CreateRecord
{
    protected static string $resource = RouterResource::class;

    protected function afterCreate(): void
    {
        // Ejecutar job inmediatamente de forma síncrona
        TestRouterConnectionJob::dispatchSync($this->record);
    }
}
