<?php

namespace App\Providers;

use App\Filament\Admin\Resources\AttendanceResource;
use Filament\Facades\Filament;
use Filament\Navigation\NavigationBuilder;
use Filament\Navigation\NavigationItem;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
//        Filament::serving(function () {
//            Filament::registerNavigationItems([
//                NavigationItem::make('Analytics')
//                    ->url('https://filament.pirsch.io', shouldOpenInNewTab: true)
//                    ->icon('heroicon-o-presentation-chart-line')
//                    ->activeIcon('heroicon-s-presentation-chart-line')
//                    ->group('Undian')
//                    ->sort(3),
//            ]);
//        });
    }
}
