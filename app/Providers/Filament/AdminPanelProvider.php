<?php

namespace App\Providers\Filament;

use Filament\Http\Middleware\Authenticate;
use Filament\Http\Middleware\AuthenticateSession;
use Filament\Http\Middleware\DisableBladeIconComponents;
use Filament\Http\Middleware\DispatchServingFilamentEvent;
use Filament\Pages;
use Filament\Panel;
use Filament\PanelProvider;
use Filament\Support\Colors\Color;
use Filament\Widgets;
use Filament\Support\Enums\MaxWidth;
use Illuminate\Support\Facades\Storage;
use App\Models\AppSetting;
use Illuminate\Support\HtmlString;
use Filament\Support\Facades\FilamentView;
use Illuminate\Cookie\Middleware\AddQueuedCookiesToResponse;
use Illuminate\Cookie\Middleware\EncryptCookies;
use Illuminate\Foundation\Http\Middleware\VerifyCsrfToken;
use Illuminate\Routing\Middleware\SubstituteBindings;
use Illuminate\Session\Middleware\StartSession;
use Illuminate\View\Middleware\ShareErrorsFromSession;

class AdminPanelProvider extends PanelProvider
{
    public function panel(Panel $panel): Panel
    {
        $primaryColor = AppSetting::get('primary_color', '#fbbf24');
        $siteName = AppSetting::get('site_name', 'Wisphub Sync');
        
        // Logos
        $logoPath = AppSetting::get('site_logo');
        $logoUrl = $logoPath ? Storage::url($logoPath) : null;
        $darkLogoPath = AppSetting::get('site_logo_dark');
        $darkLogoUrl = $darkLogoPath ? Storage::url($darkLogoPath) : $logoUrl;

        return $panel
            ->default()
            ->id('admin')
            ->path('admin')
            ->login()
            ->brandName($siteName)
            ->brandLogo($logoUrl)
            ->darkModeBrandLogo($darkLogoUrl)
            ->brandLogoHeight('2rem')
            ->favicon($logoUrl)
            ->font('Inter')
            ->colors([
                'primary' => $primaryColor,
                'gray' => Color::Slate, // Zinc/Slate es más profesional para SaaS
            ])
            ->sidebarCollapsibleOnDesktop()
            ->sidebarWidth('240px')
            ->darkMode(true)
            ->maxContentWidth(MaxWidth::Full)
            ->globalSearch(true)
            ->globalSearchKeyBindings(['command+k', 'ctrl+k'])
            ->globalSearchFieldKeyBindingSuffix()
            /* --- RE-DISEÑO RADICAL DE CABECERA Y TOGGLE --- */
            ->renderHook(
                'panels::user-menu.before',
                fn (): string => '
                    <div x-data="{ 
                        isDark: localStorage.getItem(\'theme\') === \'dark\',
                        toggle() {
                            this.isDark = !this.isDark;
                            localStorage.setItem(\'theme\', this.isDark ? \'dark\' : \'light\');
                            if (this.isDark) {
                                document.documentElement.classList.add(\'dark\');
                                document.documentElement.style.colorScheme = \'dark\';
                            } else {
                                document.documentElement.classList.remove(\'dark\');
                                document.documentElement.style.colorScheme = \'light\';
                            }
                        }
                    }" x-init="if(isDark) { document.documentElement.classList.add(\'dark\'); document.documentElement.style.colorScheme = \'dark\'; }" class="flex items-center mr-4">
                        <button @click="toggle()" class="group flex items-center justify-center p-2 rounded-xl border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800 hover:border-primary-500 dark:hover:border-primary-400 transition-all shadow-sm">
                            <span x-show="!isDark" class="text-gray-500 group-hover:text-primary-600">
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z"></path></svg>
                            </span>
                            <span x-show="isDark" class="text-gray-400 group-hover:text-amber-400">
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364-6.364l-.707.707M6.343 17.657l-.707.707m12.728 0l-.707-.707M6.343 6.343l-.707-.707M12 8a4 4 0 100 8 4 4 0 000-8z"></path></svg>
                            </span>
                        </button>
                    </div>
                '
            )
            ->renderHook(
                'panels::head.done',
                fn () => new HtmlString('
                    <style>
                        /* --- ULTRA-DENSE PREMIUM SAAS DESIGN --- */
                        :root { 
                            --sidebar-width: 190px; 
                            --collapsed-sidebar-width: 54px;
                        }
                        
                        /* Fix Spinning Logo */
                        .fi-logo img { 
                            height: 22px !important; 
                            width: auto !important; 
                            object-fit: contain !important;
                            display: block !important;
                            animation: none !important;
                        }

                        /* Advanced Aesthetics & Ultra-Density */
                        body { background-color: #f8fafc !important; letter-spacing: -0.015em; font-size: 13px; }
                        .dark body { background-color: #0c0c0e !important; }
                        
                        .fi-main { padding: 0.5rem 0.5rem !important; }
                        
                        /* Extreme Table Density */
                        .fi-ta-ctn { 
                            border-radius: 6px !important; 
                            border: 1px solid #e2e8f0 !important;
                            background-color: white !important;
                        }
                        .dark .fi-ta-ctn { border-color: #1f1f23 !important; background-color: #141417 !important; }

                        .fi-ta-header-cell { 
                            background-color: #f1f5f9 !important; 
                            padding: 4px 6px !important;
                            font-weight: 700;
                            font-size: 9px;
                            text-transform: uppercase;
                            color: #64748b;
                        }
                        .dark .fi-ta-header-cell { background-color: #18181b !important; }
                        
                        .fi-ta-cell { 
                            padding: 3px 6px !important; 
                            font-size: 12px !important; 
                        }

                        /* Sidebar - Minimalist Refinement */
                        .fi-sidebar { 
                            width: var(--sidebar-width) !important; 
                            border-right: 1px solid #e2e8f0 !important;
                            transition: width 0.2s cubic-bezier(0.4, 0, 0.2, 1) !important;
                        }
                        .fi-sidebar.fi-sidebar-collapsed {
                            width: var(--collapsed-sidebar-width) !important;
                        }
                        
                        .dark .fi-sidebar { 
                            border-right-color: #1f1f23 !important;
                            background-color: #0c0c0e !important;
                        }
                        
                        .fi-sidebar-item-button { 
                            margin: 1px 4px !important; 
                            padding: 4px 6px !important; 
                            font-size: 11.5px !important;
                            border-radius: 4px !important;
                        }
                        
                        .fi-sidebar-item-icon {
                            width: 18px !important;
                            height: 18px !important;
                        }
                        
                        .fi-sidebar-item-active {
                            background-color: rgba(var(--primary-500), 0.08) !important;
                        }

                        /* Compact Badges */
                        .fi-badge {
                            padding: 0px 4px !important;
                            font-size: 8.5px !important;
                            font-weight: 800 !important;
                        }
                        
                        /* Optimized Topbar */
                        .fi-topbar { height: 3.5rem !important; }
                        
                        /* Filter Lag UX Fix */
                        .fi-ta-filter-indicators { margin-bottom: 0.5rem !important; }
                        .fi-loading-indicator { opacity: 0.5 !important; }
                    </style>
                ')
            )
            ->discoverResources(in: app_path('Filament/Resources'), for: 'App\\Filament\\Resources')
            ->discoverPages(in: app_path('Filament/Pages'), for: 'App\\Filament\\Pages')
            ->pages([
                Pages\Dashboard::class,
            ])
            ->discoverWidgets(in: app_path('Filament/Widgets'), for: 'App\\Filament\\Widgets')
            ->middleware([
                \Illuminate\Cookie\Middleware\EncryptCookies::class,
                \Illuminate\Cookie\Middleware\AddQueuedCookiesToResponse::class,
                \Illuminate\Session\Middleware\StartSession::class,
                \Illuminate\Session\Middleware\AuthenticateSession::class,
                \Illuminate\View\Middleware\ShareErrorsFromSession::class,
                \Illuminate\Foundation\Http\Middleware\VerifyCsrfToken::class,
                \Illuminate\Routing\Middleware\SubstituteBindings::class,
                \Filament\Http\Middleware\DisableBladeIconComponents::class,
                \Filament\Http\Middleware\DispatchServingFilamentEvent::class,
            ])
            ->authMiddleware([
                \Filament\Http\Middleware\Authenticate::class,
            ]);
    }
}
