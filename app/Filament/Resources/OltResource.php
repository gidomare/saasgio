<?php

namespace App\Filament\Resources;

use App\Filament\Resources\OltResource\Pages;
use App\Filament\Resources\OltResource\RelationManagers;
use App\Models\Olt;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\SoftDeletingScope;

class OltResource extends Resource
{
    protected static ?string $model = Olt::class;

    protected static ?string $navigationIcon = 'heroicon-o-server-stack';
    protected static ?string $navigationGroup = 'Red';
    protected static ?int $navigationSort = 1;
    
    protected static ?string $navigationLabel = 'OLTs';
    
    protected static ?string $modelLabel = 'OLT';
    
    protected static ?string $pluralModelLabel = 'OLTs';

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Tabs::make('Configuración OLT')
                    ->tabs([
                        Forms\Components\Tabs\Tab::make('General')
                            ->icon('heroicon-o-information-circle')
                            ->schema([
                                Forms\Components\TextInput::make('name')
                                    ->label('Nombre')
                                    ->required()
                                    ->maxLength(255)
                                    ->placeholder('OLT Principal - Zona Norte'),
                                
                                Forms\Components\Grid::make(2)
                                    ->schema([
                                        Forms\Components\TextInput::make('ip_admin')
                                            ->label('IP Administración')
                                            ->required()
                                            ->ip()
                                            ->placeholder('192.168.1.100'),
                                        
                                        Forms\Components\TextInput::make('ip_private')
                                            ->label('IP Privada')
                                            ->ip()
                                            ->placeholder('10.0.0.1'),
                                    ]),
                                
                                Forms\Components\Grid::make(2)
                                    ->schema([
                                        Forms\Components\Select::make('model')
                                            ->label('Modelo')
                                            ->options([
                                                'VSOL-V1600' => 'VSOL V1600',
                                                'VSOL-V1600D' => 'VSOL V1600D',
                                                'VSOL-V1600G' => 'VSOL V1600G',
                                                'VSOL-V2800' => 'VSOL V2800',
                                                'VSOL-V2800G' => 'VSOL V2800G',
                                            ])
                                            ->default('VSOL-V1600')
                                            ->required(),
                                        
                                        Forms\Components\Select::make('pon_type')
                                            ->label('Tipo PON')
                                            ->options([
                                                'GPON' => 'GPON',
                                                'EPON' => 'EPON',
                                                'XPON' => 'XPON',
                                            ])
                                            ->default('GPON')
                                            ->required(),
                                    ]),
                            ]),
                        
                        Forms\Components\Tabs\Tab::make('Conexión')
                            ->icon('heroicon-o-link')
                            ->schema([
                                Forms\Components\Grid::make(3)
                                    ->schema([
                                        Forms\Components\TextInput::make('ssh_port')
                                            ->label('Puerto SSH')
                                            ->numeric()
                                            ->default(22)
                                            ->required(),
                                        
                                        Forms\Components\TextInput::make('telnet_port')
                                            ->label('Puerto Telnet')
                                            ->numeric()
                                            ->default(23)
                                            ->required(),
                                        
                                        Forms\Components\TextInput::make('snmp_port')
                                            ->label('Puerto SNMP')
                                            ->numeric()
                                            ->default(161)
                                            ->required(),
                                    ]),
                                
                                Forms\Components\Grid::make(2)
                                    ->schema([
                                        Forms\Components\TextInput::make('username')
                                            ->label('Usuario')
                                            ->placeholder('admin')
                                            ->required(),
                                        
                                        Forms\Components\TextInput::make('password')
                                            ->label('Contraseña')
                                            ->password()
                                            ->revealable()
                                            ->dehydrated(fn ($state) => filled($state))
                                            ->required(fn (string $context): bool => $context === 'create'),
                                    ]),
                            ]),
                        
                        Forms\Components\Tabs\Tab::make('SNMP')
                            ->icon('heroicon-o-signal')
                            ->schema([
                                Forms\Components\Placeholder::make('snmp_info')
                                    ->label('')
                                    ->content('Configuración SNMP v2c para monitoreo y gestión'),
                                
                                Forms\Components\Grid::make(2)
                                    ->schema([
                                        Forms\Components\TextInput::make('snmp_community_read')
                                            ->label('Comunidad Lectura')
                                            ->default('public')
                                            ->required()
                                            ->helperText('Mínimo 8 caracteres, incluir números'),
                                        
                                        Forms\Components\TextInput::make('snmp_community_write')
                                            ->label('Comunidad Escritura')
                                            ->default('private')
                                            ->required()
                                            ->helperText('Mínimo 8 caracteres, incluir números'),
                                    ]),
                            ]),
                        
                        Forms\Components\Tabs\Tab::make('Script')
                            ->icon('heroicon-o-code-bracket')
                            ->schema([
                                Forms\Components\Textarea::make('admin_olt_script')
                                    ->label('Script de Conexión (AdminOLT)')
                                    ->rows(6)
                                    ->placeholder('Script para conexión via Mikrotik (opcional)')
                                    ->helperText('Utilizado cuando la OLT no es accesible directamente'),
                            ]),
                    ])
                    ->columnSpanFull(),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->poll('30s')
            ->deferLoading()
            ->persistFiltersInSession()
            ->persistSearchInSession()
            ->persistSortInSession()
            ->columns([
                // Nombre + IP Admin (combined)
                Tables\Columns\TextColumn::make('name')
                    ->label('OLT')
                    ->description(fn ($record) => $record->ip_admin)
                    ->searchable()
                    ->sortable()
                    ->weight('bold'),
                
                // Modelo + Tipo PON (combined)
                Tables\Columns\TextColumn::make('model')
                    ->label('Modelo / Tipo')
                    ->description(fn ($record) => $record->pon_type)
                    ->searchable()
                    ->badge()
                    ->color('info'),
                
                // Estado
                Tables\Columns\TextColumn::make('status')
                    ->label('Estado')
                    ->badge()
                    ->color(fn (string $state): string => match ($state) {
                        'online' => 'success',
                        'offline' => 'danger',
                        'testing' => 'warning',
                        default => 'gray',
                    })
                    ->formatStateUsing(fn (string $state): string => match ($state) {
                        'online' => 'En Línea',
                        'offline' => 'Fuera de Línea',
                        'testing' => 'Probando',
                        'error' => 'Error',
                        default => 'Desconocido',
                    }),
                
                // Última Verificación
                Tables\Columns\TextColumn::make('last_check_at')
                    ->label('Última Verificación')
                    ->dateTime('d/m/Y H:i')
                    ->sortable(),
            ])
            ->filters([
                Tables\Filters\SelectFilter::make('status')
                    ->label('Estado')
                    ->options([
                        'online' => 'En Línea',
                        'offline' => 'Fuera de Línea',
                        'testing' => 'Probando',
                        'error' => 'Error',
                        'unknown' => 'Desconocido',
                    ]),
                
                Tables\Filters\SelectFilter::make('pon_type')
                    ->label('Tipo PON')
                    ->options([
                        'GPON' => 'GPON',
                        'EPON' => 'EPON',
                        'XPON' => 'XPON',
                    ]),
            ])
            ->actions([
                Tables\Actions\Action::make('read_config')
                    ->label('')
                    ->tooltip('Configuraciones')
                    ->icon('heroicon-o-document-magnifying-glass')
                    ->color('success')
                    ->modalHeading('Configuración de la OLT')
                    ->modalWidth('7xl')
                    ->modalContent(function (Olt $record) {
                        $service = new \App\Services\OltService($record);
                        $config = $service->getConfigurationSummary();
                        
                        return view('filament.modals.olt-config', [
                            'olt' => $record,
                            'config' => $config,
                        ]);
                    })
                    ->modalSubmitAction(false)
                    ->modalCancelActionLabel('Cerrar'),
                
                Tables\Actions\Action::make('configure_snmp')
                    ->label('')
                    ->tooltip('SNMP')
                    ->icon('heroicon-o-cog-6-tooth')
                    ->color('warning')
                    ->requiresConfirmation()
                    ->modalHeading('Configurar SNMP en OLT')
                    ->modalDescription('Esto configurará la OLT para enviar traps SNMP a 10.150.1.4')
                    ->action(function (Olt $record) {
                        // Dispatch async job
                        \App\Jobs\ConfigureOltSnmpJob::dispatch($record, '10.150.1.4');
                        
                        \Filament\Notifications\Notification::make()
                            ->title('Configuración SNMP iniciada')
                            ->body('La configuración está en progreso. Revisa los logs en unos momentos.')
                            ->success()
                            ->send();
                    }),
                
                Tables\Actions\Action::make('test_connection')
                    ->label('')
                    ->tooltip('Test')
                    ->icon('heroicon-o-signal')
                    ->color('info')
                    ->action(function (Olt $record) {
                        // Dispatch test job
                        $record->update(['status' => 'testing']);
                        \App\Jobs\TestOltConnectionJob::dispatch($record);
                        
                        \Filament\Notifications\Notification::make()
                            ->title('Prueba iniciada')
                            ->body('La verificación de conexión está en progreso...')
                            ->success()
                            ->send();
                    }),
                
                Tables\Actions\Action::make('view_logs')
                    ->label('')
                    ->tooltip('Logs')
                    ->icon('heroicon-o-document-text')
                    ->color('gray')
                    ->modalHeading('Logs de Conexión')
                    ->modalContent(fn (Olt $record) => view('filament.modals.olt-logs', ['olt' => $record]))
                    ->modalSubmitAction(false)
                    ->modalCancelActionLabel('Cerrar'),
                
                Tables\Actions\EditAction::make()
                    ->label('')
                    ->tooltip('Editar')
                    ->slideOver(),
                Tables\Actions\DeleteAction::make()
                    ->label('')
                    ->tooltip('Eliminar'),
            ])
            ->bulkActions([
                Tables\Actions\BulkActionGroup::make([
                    Tables\Actions\DeleteBulkAction::make(),
                ]),
            ])
            ->poll('10s');
    }

    public static function getRelations(): array
    {
        return [
            //
        ];
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListOlts::route('/'),
            'create' => Pages\CreateOlt::route('/create'),
            'edit' => Pages\EditOlt::route('/{record}/edit'),
        ];
    }
}
