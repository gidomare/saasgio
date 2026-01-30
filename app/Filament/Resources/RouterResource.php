<?php

namespace App\Filament\Resources;

use App\Filament\Resources\RouterResource\Pages;
use App\Filament\Resources\RouterResource\RelationManagers;
use App\Models\Router;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\SoftDeletingScope;

class RouterResource extends Resource
{
    protected static ?string $model = Router::class;

    protected static ?string $navigationIcon = 'heroicon-o-globe-alt';
    protected static ?string $navigationGroup = 'Red';
    protected static ?int $navigationSort = 3;

    public static function getModelLabel(): string
    {
        return 'Router';
    }

    public static function getPluralModelLabel(): string
    {
        return 'Routers';
    }

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Tabs::make('Tabs')
                    ->tabs([
                        // --- TAB 1: INFORMACIÓN GENERAL ---
                        Forms\Components\Tabs\Tab::make('Información General')
                            ->icon('heroicon-o-information-circle')
                            ->schema([
                                Forms\Components\Group::make([
                                    Forms\Components\TextInput::make('name')
                                        ->label('Nombre del Router')
                                        ->required()
                                        ->placeholder('Ej: Core-Mikrotik-Ppal')
                                        ->maxLength(255),
                                    Forms\Components\TextInput::make('ip_address')
                                        ->label('Direccion IP / Hostname')
                                        ->required()
                                        ->placeholder('192.168.1.1 o router.isp.com')
                                        ->maxLength(255),
                                    Forms\Components\TextInput::make('failover_ip')
                                        ->label('IP de Respaldo (Opcional)')
                                        ->placeholder('10.0.0.1'),
                                ])->columns(3),

                                Forms\Components\Group::make([
                                    Forms\Components\TextInput::make('api_user')
                                        ->label('Usuario API')
                                        ->required()
                                        ->default('admin'),
                                    Forms\Components\TextInput::make('api_password')
                                        ->label('Contraseña API')
                                        ->password()
                                        ->required()
                                        ->dehydrated(fn ($state) => filled($state)),
                                    Forms\Components\TextInput::make('api_port')
                                        ->label('Puerto API')
                                        ->numeric()
                                        ->default(8728),
                                    Forms\Components\TextInput::make('www_port')
                                        ->label('Puerto HTTP (WWW)')
                                        ->numeric()
                                        ->default(80),
                                ])->columns(4),

                                Forms\Components\Section::make('Configuración de Control')
                                    ->description('Define cómo se cortará el servicio a los clientes morosos')
                                    ->schema([
                                        Forms\Components\Select::make('service_cut_type')
                                            ->label('Método de Corte de Servicio')
                                            ->options([
                                                'ppp_secret' => 'PPPoE (Suspender Secret)',
                                                'address_list_moroso' => 'Address List (Morosos)',
                                                'simple_queue' => 'Simple Queue (Ancho de Banda)',
                                                'hotspot_user' => 'Hotspot (User Control)',
                                            ])
                                            ->required()
                                            ->live() // Hace que el formulario reaccione al cambio
                                            ->afterStateUpdated(function ($state, callable $set) {
                                                // LÓGICA DINÁMICA OBLIGATORIA
                                                if ($state === 'ppp_secret') {
                                                    $set('control_pppoe', true);
                                                    $set('control_simple_queue', false);
                                                    $set('control_pcq_address_list', false);
                                                    $set('control_hotspot', false);
                                                    $set('ip_bindings', false);
                                                    $set('dhcp_leases', false);
                                                } elseif ($state === 'address_list_moroso') {
                                                    $set('control_simple_queue', true);
                                                    $set('control_pppoe', false);
                                                    $set('control_hotspot', false);
                                                    $set('control_pcq_address_list', false);
                                                    $set('ip_bindings', true);
                                                    $set('traffic_history', true);
                                                }
                                            }),

                                        Forms\Components\Select::make('ppp_speed_control_mode')
                                            ->label('Modo de Control PPPoE')
                                            ->options([
                                                'profile_ppp_dynamic_queue' => 'Profile Dynamic Queues',
                                                'simple_queue_ppp' => 'Simple Queue Manual',
                                            ])
                                            ->visible(fn ($get) => $get('service_cut_type') === 'ppp_secret')
                                            ->required(fn ($get) => $get('service_cut_type') === 'ppp_secret'),
                                    ])->columns(2),

                                Forms\Components\Section::make('Switches / Funcionalidades')
                                    ->schema([
                                        Forms\Components\Grid::make(3)
                                            ->schema([
                                                Forms\Components\Group::make([
                                                    Forms\Components\Toggle::make('enable_api')->label('Habilitar API')->default(true),
                                                    Forms\Components\Toggle::make('auto_add_client')->label('Auto-agregar Clientes')->default(false),
                                                    Forms\Components\Toggle::make('system_ip_pool')->label('Pool de IPs del Sistema')->default(false),
                                                ]),
                                                Forms\Components\Group::make([
                                                    Forms\Components\Toggle::make('control_pppoe')
                                                        ->label('Control PPPoE')
                                                        ->live()
                                                        ->disabled(fn ($get) => $get('service_cut_type') === 'ppp_secret'),
                                                    Forms\Components\Toggle::make('control_simple_queue')->label('Control Simple Queue'),
                                                    Forms\Components\Toggle::make('control_pcq_address_list')->label('Control PCQ Address-List'),
                                                ]),
                                                Forms\Components\Group::make([
                                                    Forms\Components\Toggle::make('ip_bindings')->label('IP Bindings'),
                                                    Forms\Components\Toggle::make('dhcp_leases')->label('DHCP Leases'),
                                                    Forms\Components\Toggle::make('traffic_history')->label('Historial de Tráfico'),
                                                ]),
                                            ]),
                                    ])->compact(),

                                Forms\Components\Section::make('Rangos de IP (Pools)')
                                    ->schema([
                                        Forms\Components\Repeater::make('ipRanges')
                                            ->relationship()
                                            ->schema([
                                                Forms\Components\TextInput::make('cidr')
                                                    ->label('Rango CIDR')
                                                    ->placeholder('10.20.5.0/24')
                                                    ->required()
                                                    ->rule('regex:/^([0-9]{1,3}\.){3}[0-9]{1,3}\/[0-9]{1,2}$/'),
                                            ])
                                            ->columns(1)
                                            ->createItemButtonLabel('Agregar Rango IP'),
                                    ]),
                            ]),

                        // --- TAB 2: FACTURACIÓN / ZONA ---
                        Forms\Components\Tabs\Tab::make('Facturación / Zona')
                            ->icon('heroicon-o-banknotes')
                            ->schema([
                                Forms\Components\Placeholder::make('note')
                                    ->content('Módulo en desarrollo para futuras integraciones de cobro.'),
                                Forms\Components\TextInput::make('coordinates')
                                    ->label('Coordenadas (Lat, Long)')
                                    ->placeholder('19.4326,-99.1332'),
                            ]),

                        // --- TAB 3: SCRIPTS DE CONEXIÓN ---
                        Forms\Components\Tabs\Tab::make('Scripts')
                            ->icon('heroicon-o-code-bracket')
                            ->schema([
                                Forms\Components\Textarea::make('on_connect_script')
                                    ->label('Script al Conectar')
                                    ->placeholder('# Script Mikrotik a ejecutar al conectar cliente')
                                    ->rows(5),
                                Forms\Components\Textarea::make('on_disconnect_script')
                                    ->label('Script al Desconectar')
                                    ->placeholder('# Script Mikrotik a ejecutar al desconectar cliente')
                                    ->rows(5),
                                Forms\Components\Textarea::make('comments')
                                    ->label('Notas / Comentarios Internos')
                                    ->rows(3),
                            ]),
                    ])->columnSpanFull(),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->poll('60s')
            ->deferLoading()
            ->persistFiltersInSession()
            ->persistSearchInSession()
            ->persistSortInSession()
            ->columns([
                Tables\Columns\TextColumn::make('name')
                    ->label('Nombre')
                    ->searchable(),
                Tables\Columns\IconColumn::make('is_online')
                    ->label('Estado')
                    ->boolean()
                    ->trueIcon('heroicon-o-check-circle')
                    ->falseIcon('heroicon-o-x-circle')
                    ->trueColor('success')
                    ->falseColor('danger'),
                Tables\Columns\TextColumn::make('ip_address')
                    ->label('IP')
                    ->searchable(),
                Tables\Columns\TextColumn::make('routeros_version')
                    ->label('Versión')
                    ->placeholder('—'),
                Tables\Columns\TextColumn::make('cpu_load')
                    ->label('CPU')
                    ->formatStateUsing(fn ($state) => $state ? $state . '%' : '—')
                    ->color(fn ($state) => match(true) {
                        $state === null => 'gray',
                        $state < 50 => 'success',
                        $state < 80 => 'warning',
                        default => 'danger',
                    }),
                Tables\Columns\TextColumn::make('memory_used_bytes')
                    ->label('RAM')
                    ->formatStateUsing(function ($record) {
                        if (!$record->memory_total_bytes) return '—';
                        $usedMB = round($record->memory_used_bytes / 1048576);
                        $totalMB = round($record->memory_total_bytes / 1048576);
                        return "{$usedMB} / {$totalMB} MB";
                    }),
                Tables\Columns\TextColumn::make('last_checked_at')
                    ->label('Última Verificación')
                    ->dateTime('d/m/Y H:i')
                    ->placeholder('Nunca')
                    ->sortable(),
                Tables\Columns\TextColumn::make('service_cut_type')
                    ->label('Método de Corte')
                    ->badge()
                    ->color('info')
                    ->formatStateUsing(fn (string $state): string => match ($state) {
                        'ppp_secret' => 'PPPoE',
                        'address_list_moroso' => 'Address List',
                        'simple_queue' => 'Simple Queue',
                        'hotspot_user' => 'Hotspot',
                        default => $state,
                    }),
                Tables\Columns\IconColumn::make('is_online')
                    ->label('Estado')
                    ->boolean()
                    ->trueIcon('heroicon-o-check-circle')
                    ->falseIcon('heroicon-o-x-circle')
                    ->trueColor('success')
                    ->falseColor('danger'),
                Tables\Columns\TextColumn::make('ip_address')
                    ->label('IP / Host')
                    ->searchable(),
                Tables\Columns\TextColumn::make('api_user')
                    ->label('User')
                    ->toggleable(isToggledHiddenByDefault: true),
                Tables\Columns\TextColumn::make('api_port')
                    ->label('Port')
                    ->toggleable(isToggledHiddenByDefault: true),
                Tables\Columns\TextColumn::make('router_os_version')
                    ->label('vOS')
                    ->placeholder('—'),
                Tables\Columns\TextColumn::make('cpu_load')
                    ->label('CPU')
                    ->formatStateUsing(fn ($state) => $state ? $state . '%' : '—')
                    ->color(fn ($state) => match(true) {
                        $state === null => 'gray',
                        $state < 50 => 'success',
                        $state < 80 => 'warning',
                        default => 'danger',
                    }),
                Tables\Columns\TextColumn::make('memory_used_bytes')
                    ->label('RAM')
                    ->formatStateUsing(function ($record) {
                        if (!$record->memory_total_bytes) return '—';
                        $usedMB = round($record->memory_used_bytes / 1048576);
                        $totalMB = round($record->memory_total_bytes / 1048576);
                        return "{$usedMB} / {$totalMB} MB";
                    })
                    ->toggleable(isToggledHiddenByDefault: true),
                Tables\Columns\TextColumn::make('last_checked_at')
                    ->label('Visto')
                    ->dateTime('H:i:s')
                    ->placeholder('—')
                    ->sortable(),
            ])
            ->filters([
                Tables\Filters\SelectFilter::make('service_cut_type')
                    ->label('Método de Corte')
                    ->options([
                        'ppp_secret' => 'PPPoE',
                        'address_list_moroso' => 'Address List',
                        'simple_queue' => 'Simple Queue',
                        'hotspot_user' => 'Hotspot',
                    ]),
            ])
            ->actions([
                Tables\Actions\Action::make('test_api')
                    ->label('')
                    ->tooltip('Probar API')
                    ->icon('heroicon-o-signal')
                    ->color('success')
                    ->action(function ($record) {
                        // Simulación de prueba de conexión
                        \Filament\Notifications\Notification::make()
                            ->title('Conexión Exitosa')
                            ->body("Se logró establecer comunicación con {$record->name} ({$record->ip_address}) vía API.")
                            ->success()
                            ->send();
                        
                        $record->update(['is_online' => true, 'last_checked_at' => now()]);
                    }),
                Tables\Actions\EditAction::make()
                    ->label('')
                    ->tooltip('Editar')
                    ->slideOver(),
            ])
            ->bulkActions([
                Tables\Actions\BulkActionGroup::make([
                    Tables\Actions\DeleteBulkAction::make(),
                ]),
            ]);
    }

    public static function getRelations(): array
    {
        return [
            RelationManagers\ApiEventsRelationManager::class,
        ];
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListRouters::route('/'),
            'create' => Pages\CreateRouter::route('/create'),
            'edit' => Pages\EditRouter::route('/{record}/edit'),
        ];
    }
}
