<?php

namespace App\Filament\Pages;

use Filament\Pages\Page;
use Filament\Forms\Concerns\InteractsWithForms;
use Filament\Forms\Contracts\HasForms;
use Filament\Forms\Form;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\FileUpload;
use Filament\Forms\Components\ColorPicker;
use Filament\Forms\Components\Section;
use Filament\Forms\Components\Actions\Action;
use Filament\Notifications\Notification;
use App\Models\AppSetting;

class GeneralSettings extends Page implements HasForms
{
    use InteractsWithForms;

    protected static ?string $navigationIcon = 'heroicon-o-cog-6-tooth';
    protected static ?string $navigationLabel = 'Ajustes Generales';
    protected static ?string $title = 'Configuración de la Plataforma';

    protected static string $view = 'filament.pages.general-settings';

    public ?array $data = [];

    public function mount(): void
    {
        $this->form->fill([
            'site_name' => AppSetting::get('site_name', 'Wisphub Sync'),
            'site_logo' => AppSetting::get('site_logo'),
            'site_logo_dark' => AppSetting::get('site_logo_dark'),
            'primary_color' => AppSetting::get('primary_color', '#fbbf24'), // Amber-400 default
        ]);
    }

    public function form(Form $form): Form
    {
        return $form
            ->schema([
                Section::make('Identidad Visual')
                    ->description('Configura el nombre y los logos de tu plataforma SaaS.')
                    ->schema([
                        TextInput::make('site_name')
                            ->label('Nombre del Sitio')
                            ->required(),
                        FileUpload::make('site_logo')
                            ->label('Logo Modo Claro')
                            ->image()
                            ->directory('brand')
                            ->visibility('public'),
                        FileUpload::make('site_logo_dark')
                            ->label('Logo Modo Oscuro (Opcional)')
                            ->image()
                            ->directory('brand')
                            ->visibility('public'),
                    ])->columns(3),

                Section::make('Personalización de Tema')
                    ->description('Define los colores y el estilo visual de la plataforma.')
                    ->schema([
                        ColorPicker::make('primary_color')
                            ->label('Color Primario')
                            ->required(),
                    ]),
            ])
            ->statePath('data');
    }

    public function save(): void
    {
        $data = $this->form->getState();

        foreach ($data as $key => $value) {
            AppSetting::set($key, $value);
        }

        Notification::make()
            ->success()
            ->title('Configuración guardada')
            ->body('Los cambios se aplicarán al recargar la página.')
            ->send();
            
        // Forzar actualización del panel (opcional, pero ayuda)
        $this->redirect(request()->header('Referer'));
    }
}
