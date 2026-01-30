<?php

namespace App\Filament\Resources;

use App\Filament\Resources\OnuResource\Pages;
use App\Models\Onu;
use App\Models\Olt;
use App\Jobs\ImportOnusFromOltJob;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;

class OnuResource extends Resource
{
    protected static ?string $model = Onu::class;

    protected static ?string $navigationIcon = 'heroicon-o-wifi';
    
    protected static ?string $navigationLabel = 'ONUs';
    
    protected static ?string $modelLabel = 'ONU';
    
    protected static ?string $pluralModelLabel = 'ONUs';
    
    protected static ?string $navigationGroup = 'OLT Management';

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Tabs::make('ONU Configuration')
                    ->tabs([
                        Forms\Components\Tabs\Tab::make('General')
                            ->icon('heroicon-o-information-circle')
                            ->schema([
                                Forms\Components\Select::make('olt_id')
                                    ->label('OLT')
                                    ->relationship('olt', 'name')
                                    ->required()
                                    ->searchable(),
                                
                                Forms\Components\Grid::make(3)
                                    ->schema([
                                        Forms\Components\TextInput::make('serial_number')
                                            ->label('Serial Number')
                                            ->required()
                                            ->maxLength(255)
                                            ->placeholder('FHTT12345678'),
                                        
                                        Forms\Components\TextInput::make('port')
                                            ->label('PON Port')
                                            ->required()
                                            ->placeholder('1/1/1'),
                                        
                                        Forms\Components\TextInput::make('onu_id')
                                            ->label('ONU ID')
                                            ->required()
                                            ->numeric()
                                            ->minValue(1)
                                            ->maxValue(128),
                                    ]),
                                
                                Forms\Components\TextInput::make('name')
                                    ->label('Name')
                                    ->maxLength(255)
                                    ->placeholder('Cliente-001'),
                                
                                Forms\Components\Grid::make(2)
                                    ->schema([
                                        Forms\Components\Select::make('status')
                                            ->label('Status')
                                            ->options([
                                                'online' => 'Online',
                                                'offline' => 'Offline',
                                                'los' => 'LOS',
                                                'unknown' => 'Unknown',
                                            ])
                                            ->default('unknown')
                                            ->required(),
                                        
                                        Forms\Components\TextInput::make('auth_state')
                                            ->label('Auth State')
                                            ->maxLength(255),
                                    ]),
                            ]),
                        
                        Forms\Components\Tabs\Tab::make('Service Config')
                            ->icon('heroicon-o-cog-6-tooth')
                            ->schema([
                                Forms\Components\Grid::make(2)
                                    ->schema([
                                        Forms\Components\TextInput::make('vlan')
                                            ->label('VLAN ID')
                                            ->numeric()
                                            ->minValue(1)
                                            ->maxValue(4094),
                                        
                                        Forms\Components\TextInput::make('onu_type')
                                            ->label('ONU Type')
                                            ->default('default')
                                            ->maxLength(255),
                                    ]),
                                
                                Forms\Components\Grid::make(3)
                                    ->schema([
                                        Forms\Components\TextInput::make('line_profile')
                                            ->label('Line Profile')
                                            ->maxLength(255),
                                        
                                        Forms\Components\TextInput::make('service_profile')
                                            ->label('Service Profile')
                                            ->maxLength(255),
                                        
                                        Forms\Components\TextInput::make('dba_profile')
                                            ->label('DBA Profile')
                                            ->maxLength(255),
                                    ]),
                            ]),
                        
                        Forms\Components\Tabs\Tab::make('Optical Info')
                            ->icon('heroicon-o-signal')
                            ->schema([
                                Forms\Components\Grid::make(3)
                                    ->schema([
                                        Forms\Components\TextInput::make('rx_power')
                                            ->label('RX Power (dBm)')
                                            ->numeric()
                                            ->suffix('dBm'),
                                        
                                        Forms\Components\TextInput::make('tx_power')
                                            ->label('TX Power (dBm)')
                                            ->numeric()
                                            ->suffix('dBm'),
                                        
                                        Forms\Components\TextInput::make('olt_rx_power')
                                            ->label('OLT RX Power (dBm)')
                                            ->numeric()
                                            ->suffix('dBm'),
                                    ]),
                                
                                Forms\Components\Grid::make(4)
                                    ->schema([
                                        Forms\Components\TextInput::make('temperature')
                                            ->label('Temperature (°C)')
                                            ->numeric()
                                            ->suffix('°C'),
                                        
                                        Forms\Components\TextInput::make('voltage')
                                            ->label('Voltage (V)')
                                            ->numeric()
                                            ->suffix('V'),
                                        
                                        Forms\Components\TextInput::make('bias_current')
                                            ->label('Bias Current (mA)')
                                            ->numeric()
                                            ->suffix('mA'),
                                        
                                        Forms\Components\TextInput::make('distance')
                                            ->label('Distance (km)')
                                            ->numeric()
                                            ->suffix('km'),
                                    ]),
                            ]),
                        
                        Forms\Components\Tabs\Tab::make('Customer')
                            ->icon('heroicon-o-user')
                            ->schema([
                                Forms\Components\Select::make('customer_id')
                                    ->label('Customer')
                                    ->relationship('customer', 'name')
                                    ->searchable()
                                    ->preload(),
                                
                                Forms\Components\Select::make('service_id')
                                    ->label('Service')
                                    ->relationship('service', 'id')
                                    ->searchable(),
                                
                                Forms\Components\Textarea::make('notes')
                                    ->label('Notes')
                                    ->rows(4)
                                    ->columnSpanFull(),
                            ]),
                    ])
                    ->columnSpanFull(),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                // OLT + Port (combined)
                Tables\Columns\TextColumn::make('olt.name')
                    ->label('OLT')
                    ->description(fn ($record) => "Port {$record->port}")
                    ->searchable()
                    ->sortable(),
                
                // Serial + Name (combined)
                Tables\Columns\TextColumn::make('serial_number')
                    ->label('Serial')
                    ->description(fn ($record) => $record->name ? \Illuminate\Support\Str::limit($record->name, 22) : null)
                    ->searchable()
                    ->copyable()
                    ->weight('medium')
                    ->limit(15),
                
                // ONU ID
                Tables\Columns\TextColumn::make('onu_id')
                    ->label('ID')
                    ->sortable()
                    ->alignCenter(),
                
                // Status
                Tables\Columns\TextColumn::make('status')
                    ->label('Status')
                    ->badge()
                    ->color(fn (string $state): string => match ($state) {
                        'online' => 'success',
                        'offline' => 'danger',
                        'los' => 'warning',
                        default => 'gray',
                    })
                    ->formatStateUsing(fn (string $state): string => ucfirst($state)),
                
                // Optical Power (RX + TX combined)
                Tables\Columns\TextColumn::make('rx_power')
                    ->label('Optical')
                    ->description(fn ($record) => $record->tx_power ? "TX: {$record->tx_power} dBm" : null)
                    ->formatStateUsing(fn ($state) => $state ? "RX: {$state} dBm" : '-')
                    ->sortable()
                    ->color(function ($state): string {
                        if ($state === null) return 'gray';
                        if ($state >= -15) return 'success';
                        if ($state >= -23) return 'success';
                        if ($state >= -27) return 'warning';
                        return 'danger';
                    }),
                
                // Distance + VLAN (combined)
                Tables\Columns\TextColumn::make('distance')
                    ->label('Dst/VLAN')
                    ->description(fn ($record) => $record->vlan ? "VLAN {$record->vlan}" : null)
                    ->formatStateUsing(fn ($state) => $state ? number_format($state, 1) . ' m' : '-')
                    ->sortable(),
                
                // Customer
                Tables\Columns\TextColumn::make('customer.name')
                    ->label('Cli')
                    ->searchable()
                    ->sortable()
                    ->wrap()
                    ->placeholder('n/a'),
                
                Tables\Columns\TextColumn::make('last_online_at')
                    ->label('Last Online')
                    ->dateTime('d/m/Y H:i')
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
                
                Tables\Columns\TextColumn::make('created_at')
                    ->label('Created')
                    ->dateTime('d/m/Y H:i')
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
            ])
            ->filters([
                Tables\Filters\SelectFilter::make('olt_id')
                    ->label('OLT')
                    ->relationship('olt', 'name'),
                
                Tables\Filters\SelectFilter::make('status')
                    ->label('Status')
                    ->options([
                        'online' => 'Online',
                        'offline' => 'Offline',
                        'los' => 'LOS',
                        'unknown' => 'Unknown',
                    ]),
                
                Tables\Filters\Filter::make('has_customer')
                    ->label('Has Customer')
                    ->query(fn ($query) => $query->whereNotNull('customer_id')),
            ])
            ->actions([
                Tables\Actions\EditAction::make()
                    ->label('')
                    ->tooltip('Editar'),
                Tables\Actions\DeleteAction::make()
                    ->label('')
                    ->tooltip('Eliminar'),
            ])
            ->bulkActions([
                Tables\Actions\BulkActionGroup::make([
                    Tables\Actions\DeleteBulkAction::make(),
                ]),
            ])
            ->headerActions([
                Tables\Actions\Action::make('import_onus')
                    ->label('Import from OLT')
                    ->icon('heroicon-o-arrow-down-tray')
                    ->color('success')
                    ->form([
                        Forms\Components\Select::make('olt_id')
                            ->label('Select OLT')
                            ->options(Olt::pluck('name', 'id'))
                            ->required()
                            ->searchable(),
                    ])
                    ->action(function (array $data) {
                        $olt = Olt::find($data['olt_id']);
                        
                        // Dispatch to queue (async)
                        ImportOnusFromOltJob::dispatch($olt)->onQueue('default');
                        
                        \Filament\Notifications\Notification::make()
                            ->title('Import Started')
                            ->body("Importing ONUs from {$olt->name} in background. Check logs for progress.")
                            ->success()
                            ->send();
                    }),
            ])
            ->poll('30s');
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
            'index' => Pages\ListOnus::route('/'),
            'create' => Pages\CreateOnu::route('/create'),
            'edit' => Pages\EditOnu::route('/{record}/edit'),
        ];
    }
}
