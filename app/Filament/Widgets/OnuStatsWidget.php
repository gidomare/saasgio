<?php

namespace App\Filament\Widgets;

use App\Models\Onu;
use Filament\Widgets\StatsOverviewWidget as BaseWidget;
use Filament\Widgets\StatsOverviewWidget\Stat;

class OnuStatsWidget extends BaseWidget
{
    protected static ?int $sort = 2;
    
    protected int | string | array $columnSpan = 'full';
    
    protected function getStats(): array
    {
        $totalOnus = Onu::count();
        $onlineOnus = Onu::where('status', 'online')->count();
        $offlineOnus = Onu::where('status', 'offline')->count();
        $onlinePercentage = $totalOnus > 0 ? round(($onlineOnus / $totalOnus) * 100, 1) : 0;

        return [
            Stat::make('Total ONUs', $totalOnus)
                ->description('ONUs registradas')
                ->descriptionIcon('heroicon-m-cpu-chip')
                ->color('primary'),
                
            Stat::make('ONUs Online', $onlineOnus)
                ->description($onlinePercentage . '% del total')
                ->descriptionIcon('heroicon-m-signal')
                ->color('success')
                ->chart([45, 50, 48, 52, 49, 51, $onlineOnus]),
                
            Stat::make('ONUs Offline', $offlineOnus)
                ->description('Requieren revisión')
                ->descriptionIcon('heroicon-m-x-circle')
                ->color('danger')
                ->chart([8, 6, 7, 5, 6, 7, $offlineOnus]),
        ];
    }
}
