<?php

namespace App\Filament\Widgets;

use App\Models\Customer;
use App\Models\Service;
use Filament\Widgets\StatsOverviewWidget as BaseWidget;
use Filament\Widgets\StatsOverviewWidget\Stat;

class CustomerStatsWidget extends BaseWidget
{
    protected static ?int $sort = 1;
    
    protected int | string | array $columnSpan = 'full';
    
    protected function getStats(): array
    {
        $totalCustomers = Customer::count();
        $activeServices = Service::where('status', 'active')->count();
        $suspendedServices = Service::where('status', 'suspended')->count();
        $totalRevenue = Service::where('status', 'active')
            ->join('plans', 'services.plan_id', '=', 'plans.id')
            ->sum('plans.price');

        return [
            Stat::make('Total Clientes', $totalCustomers)
                ->description('Clientes registrados')
                ->descriptionIcon('heroicon-m-users')
                ->color('primary')
                ->chart([7, 12, 15, 18, 22, 25, $totalCustomers]),
                
            Stat::make('Servicios Activos', $activeServices)
                ->description('Servicios en operación')
                ->descriptionIcon('heroicon-m-check-circle')
                ->color('success')
                ->chart([10, 15, 20, 25, 30, 35, $activeServices]),
                
            Stat::make('Servicios Suspendidos', $suspendedServices)
                ->description('Requieren atención')
                ->descriptionIcon('heroicon-m-pause-circle')
                ->color('danger')
                ->chart([5, 4, 6, 3, 5, 4, $suspendedServices]),
                
            Stat::make('Ingresos Mensuales', '$' . number_format($totalRevenue, 2))
                ->description('Servicios activos')
                ->descriptionIcon('heroicon-m-currency-dollar')
                ->color('success'),
        ];
    }
}
