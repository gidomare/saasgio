<?php

namespace App\Filament\Resources\VpnTunnelResource\Pages;

use App\Filament\Resources\VpnTunnelResource;
use Filament\Actions;
use Filament\Resources\Pages\CreateRecord;

class CreateVpnTunnel extends CreateRecord
{
    protected static string $resource = VpnTunnelResource::class;

    protected function getRedirectUrl(): string
    {
        return $this->getResource()::getUrl('index');
    }
}
