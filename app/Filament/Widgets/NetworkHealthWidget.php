<?php

namespace App\Filament\Widgets;

use App\Models\Router;
use App\Models\Olt;
use Filament\Widgets\StatsOverviewWidget as BaseWidget;
use Filament\Widgets\StatsOverviewWidget\Stat;

class NetworkHealthWidget extends BaseWidget
{
    protected static ?int $sort = 3;
    
    protected int | string | array $columnSpan = 'full';
    
    protected function getStats(): array
    {
        $totalRouters = Router::count();
        $onlineRouters = Router::where('is_online', true)->count();
        $totalOlts = Olt::count();
        $activeOlts = Olt::where('status', 'active')->count();

        return [
            Stat::make('Routers Online', $onlineRouters . ' / ' . $totalRouters)
                ->description('Estado de routers')
                ->descriptionIcon('heroicon-m-globe-alt')
                ->color($onlineRouters === $totalRouters ? 'success' : 'warning'),
                
            Stat::make('OLTs Activas', $activeOlts . ' / ' . $totalOlts)
                ->description('OLTs en operación')
                ->descriptionIcon('heroicon-m-server-stack')
                ->color($activeOlts === $totalOlts ? 'success' : 'warning'),
        ];
    }
}
