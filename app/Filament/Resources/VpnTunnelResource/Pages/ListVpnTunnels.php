<?php

namespace App\Filament\Resources\VpnTunnelResource\Pages;

use App\Filament\Resources\VpnTunnelResource;
use Filament\Actions;
use Filament\Resources\Pages\ListRecords;

class ListVpnTunnels extends ListRecords
{
    protected static string $resource = VpnTunnelResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make(),
        ];
    }
}
