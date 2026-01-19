<?php

namespace App\Filament\Pages;

use Filament\Pages\Page;
use Filament\Forms\Concerns\InteractsWithForms;
use Filament\Forms\Contracts\HasForms;
use Filament\Forms\Form;
use Filament\Forms;
use Filament\Actions\Action;
use Filament\Notifications\Notification;
use App\Services\Integrations\WisphubService;
use Exception;

class WisphubSettings extends Page implements HasForms
{
    use InteractsWithForms;

    protected static ?string $navigationIcon = 'heroicon-o-cog-6-tooth';
    protected static ?string $navigationLabel = 'Integración Wisphub';
    protected static ?string $title = 'Configuración Wisphub';
    protected static string $view = 'filament.pages.wisphub-settings';

    // Propiedades del formulario
    public ?array $data = [];

    public function mount(): void
    {
        $service = new WisphubService();
        $integration = $service->getIntegration(); // Need to expose this or get data array
        if ($integration) {
            $this->form->fill(array_merge(
                $integration->settings ?? [],
                [
                    'auto_sync' => $integration->auto_sync,
                    'sync_interval_minutes' => $integration->sync_interval_minutes,
                ]
            ));
        }
    }

    public function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Section::make('Credenciales de Conexión')
                    ->description('Ingrese los datos proporcionados por Wisphub.')
                    ->schema([
                        Forms\Components\TextInput::make('url')
                            ->label('Endpoint URL')
                            ->placeholder('https://api.wisphub.net/...')
                            ->required()
                            ->url(),
                        Forms\Components\TextInput::make('api_key')
                            ->label('API Key')
                            ->password()
                            ->revealable()
                            ->required(),
                    ])->columns(2),
                
                Forms\Components\Section::make('Automatización')
                    ->description('Configure la sincronización automática de datos.')
                    ->schema([
                        Forms\Components\Toggle::make('auto_sync')
                            ->label('Sincronización Automática')
                            ->helperText('Activar la descarga periodica de datos en segundo plano.')
                            ->live(),
                        Forms\Components\TextInput::make('sync_interval_minutes')
                            ->label('Intervalo (Minutos)')
                            ->numeric()
                            ->default(60)
                            ->minValue(5)
                            ->required()
                            ->visible(fn (Forms\Get $get) => $get('auto_sync')),
                    ])->columns(2),
            ])
            ->statePath('data');
    }

    public function save(): void
    {
        try {
            $data = $this->form->getState();
            $service = new WisphubService();
            // Separamos settings de columnas directas
            $settings = [
                'url' => $data['url'],
                'api_key' => $data['api_key'],
            ];
            $attributes = [
                'auto_sync' => $data['auto_sync'] ?? false,
                'sync_interval_minutes' => $data['sync_interval_minutes'] ?? 60,
            ];
            
            $service->updateSettings($settings, $attributes);
            
            Notification::make() 
                ->success()
                ->title('Guardado')
                ->body('Las configuraciones se han actualizado correctamente.')
                ->send();
        } catch (Exception $exception) {
             // ...
             // Re-throw to see error if debugging
             Notification::make() 
                ->danger()
                ->title('Error')
                ->body('No se pudo guardar la configuración: ' . $exception->getMessage())
                ->send();
        }
    }

    protected function getHeaderActions(): array
    {
        return [
            Action::make('test_connection')
                ->label('Probar Conexión')
                ->color('info')
                ->action(function () {
                    $this->save(); // Guardar primero para probar con lo actual
                    $service = new WisphubService();
                    $result = $service->testConnection();

                    if ($result['success']) {
                        Notification::make()->success()->title('Conexión Exitosa')->body($result['message'])->send();
                    } else {
                        Notification::make()->danger()->title('Error de Conexión')->body($result['message'])->send();
                    }
                }),
                
            Action::make('sync')
                ->label('Sincronizar')
                ->color('success')
                ->requiresConfirmation()
                ->action(function () {
                    $service = new WisphubService();
                    $result = $service->sync();
                    
                    Notification::make()
                        ->success()
                        ->title('Sincronización Completada')
                        ->body($result['message'])
                        ->send();
                }),
        ];
    }
}
