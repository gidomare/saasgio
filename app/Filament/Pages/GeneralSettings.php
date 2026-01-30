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
use Filament\Forms\Components\Toggle;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\TimePicker;
use Filament\Notifications\Notification;
use App\Models\AppSetting;
use App\Models\Backup;
use App\Jobs\CreateBackupJob;
use App\Services\BackupService;
use Filament\Tables\Concerns\InteractsWithTable;
use Filament\Tables\Contracts\HasTable;
use Filament\Tables\Table;
use Filament\Tables;
use Illuminate\Support\Facades\Storage;

class GeneralSettings extends Page implements HasForms, HasTable
{
    use InteractsWithForms, InteractsWithTable;

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
            'primary_color' => AppSetting::get('primary_color', '#fbbf24'),
            'backup_enabled' => AppSetting::get('backup_enabled', false),
            'backup_frequency' => AppSetting::get('backup_frequency', 'daily'),
            'backup_time' => AppSetting::get('backup_time', '02:00'),
            'backup_retention_days' => AppSetting::get('backup_retention_days', 7),
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

                Section::make('Backup y Restauración')
                    ->description('Configura backups automáticos y gestiona copias de seguridad del sistema.')
                    ->schema([
                        Toggle::make('backup_enabled')
                            ->label('Activar Backups Automáticos')
                            ->helperText('Los backups se ejecutarán automáticamente según la configuración.')
                            ->reactive(),
                        
                        Select::make('backup_frequency')
                            ->label('Frecuencia')
                            ->options([
                                'daily' => 'Diario',
                                'weekly' => 'Semanal',
                                'monthly' => 'Mensual',
                            ])
                            ->default('daily')
                            ->visible(fn ($get) => $get('backup_enabled')),
                        
                        TimePicker::make('backup_time')
                            ->label('Hora de Ejecución')
                            ->default('02:00')
                            ->seconds(false)
                            ->visible(fn ($get) => $get('backup_enabled')),
                        
                        TextInput::make('backup_retention_days')
                            ->label('Días de Retención')
                            ->helperText('Backups más antiguos se eliminarán automáticamente.')
                            ->numeric()
                            ->default(7)
                            ->minValue(1)
                            ->maxValue(90)
                            ->visible(fn ($get) => $get('backup_enabled')),
                    ])->columns(2),
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
            
        $this->redirect(request()->header('Referer'));
    }

    /**
     * Table for backups list
     */
    public function table(Table $table): Table
    {
        return $table
            ->query(Backup::query()->latest())
            ->columns([
                Tables\Columns\TextColumn::make('name')
                    ->label('Archivo')
                    ->searchable()
                    ->limit(30),
                
                Tables\Columns\TextColumn::make('formatted_size')
                    ->label('Tamaño'),
                
                Tables\Columns\BadgeColumn::make('type')
                    ->label('Tipo')
                    ->colors([
                        'success' => 'automatic',
                        'primary' => 'manual',
                    ])
                    ->formatStateUsing(fn (string $state): string => match ($state) {
                        'automatic' => 'Automático',
                        'manual' => 'Manual',
                        default => $state,
                    }),
                
                Tables\Columns\BadgeColumn::make('status')
                    ->label('Estado')
                    ->colors([
                        'success' => 'completed',
                        'danger' => 'failed',
                        'warning' => 'pending',
                    ])
                    ->formatStateUsing(fn (string $state): string => match ($state) {
                        'completed' => 'Completado',
                        'failed' => 'Fallido',
                        'pending' => 'Pendiente',
                        default => $state,
                    }),
                
                Tables\Columns\TextColumn::make('created_at')
                    ->label('Fecha')
                    ->dateTime('d/m/Y H:i')
                    ->sortable(),
            ])
            ->actions([
                Tables\Actions\Action::make('download')
                    ->label('')
                    ->icon('heroicon-o-arrow-down-tray')
                    ->color('success')
                    ->action(fn (Backup $record) => $this->downloadBackup($record)),
                
                Tables\Actions\Action::make('restore')
                    ->label('')
                    ->icon('heroicon-o-arrow-path')
                    ->color('warning')
                    ->requiresConfirmation()
                    ->modalHeading('Restaurar Backup')
                    ->modalDescription('¿Estás seguro? Esta acción sobrescribirá todos los datos actuales con el backup seleccionado.')
                    ->action(fn (Backup $record) => $this->restoreBackup($record)),
                
                Tables\Actions\DeleteAction::make()
                    ->label('')
                    ->tooltip('Eliminar')
                    ->action(fn (Backup $record) => $this->deleteBackup($record)),
            ])
            ->headerActions([
                Tables\Actions\Action::make('create_backup')
                    ->label('Crear Backup Ahora')
                    ->icon('heroicon-o-circle-stack')
                    ->color('primary')
                    ->action(fn () => $this->createBackup()),
            ]);
    }

    /**
     * Get header actions for the page
     */
    protected function getHeaderActions(): array
    {
        return [
            \Filament\Actions\Action::make('save')
                ->label('Guardar Configuración')
                ->action('save'),
        ];
    }

    /**
     * Create a new backup
     */
    public function createBackup(): void
    {
        CreateBackupJob::dispatch('manual', auth()->id());

        Notification::make()
            ->title('Backup Iniciado')
            ->body('El backup se está creando en segundo plano. Recibirás una notificación cuando termine.')
            ->success()
            ->send();
    }

    /**
     * Download a backup
     */
    public function downloadBackup(Backup $backup)
    {
        if (!$backup->exists()) {
            Notification::make()
                ->title('Error')
                ->body('El archivo de backup no existe.')
                ->danger()
                ->send();
            
            return;
        }

        return Storage::disk($backup->disk)->download($backup->path, $backup->name);
    }

    /**
     * Restore from backup
     */
    public function restoreBackup(Backup $backup): void
    {
        try {
            $backupService = app(BackupService::class);
            $backupService->restoreBackup($backup);

            Notification::make()
                ->title('Backup Restaurado')
                ->body('El sistema ha sido restaurado exitosamente.')
                ->success()
                ->send();

        } catch (\Exception $e) {
            Notification::make()
                ->title('Error al Restaurar')
                ->body($e->getMessage())
                ->danger()
                ->send();
        }
    }

    /**
     * Delete a backup
     */
    public function deleteBackup(Backup $backup): void
    {
        $backup->deleteFile();
        $backup->delete();

        Notification::make()
            ->title('Backup Eliminado')
            ->success()
            ->send();
    }
}
