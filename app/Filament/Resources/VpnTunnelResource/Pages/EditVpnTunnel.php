<?php

namespace App\Filament\Resources\VpnTunnelResource\Pages;

use App\Filament\Resources\VpnTunnelResource;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditVpnTunnel extends EditRecord
{
    protected static string $resource = VpnTunnelResource::class;

    protected function getRedirectUrl(): string
    {
        return $this->getResource()::getUrl('index');
    }

    protected function getHeaderActions(): array
    {
        return [
            Actions\DeleteAction::make(),
        ];
    }
}
