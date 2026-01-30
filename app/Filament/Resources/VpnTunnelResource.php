<?php

namespace App\Filament\Resources;

use App\Filament\Resources\VpnTunnelResource\Pages;
use App\Filament\Resources\VpnTunnelResource\RelationManagers;
use App\Models\VpnTunnel;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\SoftDeletingScope;

class VpnTunnelResource extends Resource
{
    protected static ?string $model = VpnTunnel::class;

    protected static ?string $navigationIcon = 'heroicon-o-shield-check';
    protected static ?string $navigationGroup = 'Red';
    protected static ?int $navigationSort = 4;

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Section::make('Configuración de Túnel')
                    ->schema([
                        Forms\Components\TextInput::make('name')
                            ->label('Nombre de Interfaz (ej. wg0)')
                            ->required()
                            ->unique(ignoreRecord: true)
                            ->helperText('Solo caracteres alfanuméricos. Se usará como nombre de archivo.')
                            ->regex('/^[a-zA-Z0-9_]+$/'),
                            
                        Forms\Components\Toggle::make('is_active')
                            ->label('Activo')
                            ->default(true),

                        Forms\Components\Textarea::make('config_content')
                            ->label('Contenido del Archivo de Configuración (.conf)')
                            ->required()
                            ->rows(15)
                            ->columnSpanFull()
                            ->helperText('Pegue aquí el contenido completo. Al guardar, se reiniciará la VPN y se probará la conexión automáticamente pingueando al Gateway (.1).'),
                    ])->columns(2),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->persistFiltersInSession()
            ->persistSearchInSession()
            ->persistSortInSession()
            ->columns([
                Tables\Columns\TextColumn::make('name')
                    ->label('Interfaz')
                    ->searchable()
                    ->sortable(),
                    
                Tables\Columns\TextColumn::make('status')
                    ->label('Estado')
                    ->badge()
                    ->color(fn (string $state): string => match ($state) {
                        'connected' => 'success',
                        'disconnected' => 'danger',
                        'testing' => 'warning',
                        'pending' => 'gray',
                        default => 'gray',
                    }),

                Tables\Columns\TextColumn::make('last_latency')
                    ->label('Latencia')
                    ->suffix(' ms'),

                Tables\Columns\TextColumn::make('last_packet_loss')
                    ->label('Pérdida')
                    ->suffix('%')
                    ->color(fn (string $state): string => intval($state) > 0 ? 'danger' : 'success'),

                Tables\Columns\IconColumn::make('is_active')
                    ->label('Activo')
                    ->boolean(),
            ])
            ->actions([
                Tables\Actions\Action::make('test_connection')
                    ->label('')
                    ->tooltip('Probar Conexión')
                    ->icon('heroicon-o-arrow-path')
                    ->action(function (VpnTunnel $record) {
                        \App\Jobs\TestVpnConnectionJob::dispatch($record);
                        \Filament\Notifications\Notification::make()
                            ->title('Prueba iniciada')
                            ->body('Reiniciando VPN... espere unos segundos.')
                            ->success()
                            ->send();
                    }),
                Tables\Actions\Action::make('view_logs')
                    ->label('')
                    ->tooltip('Logs')
                    ->icon('heroicon-o-document-text')
                    ->modalHeading('Logs de Última Prueba')
                    ->modalContent(fn (VpnTunnel $record) => new \Illuminate\Support\HtmlString('<pre style="white-space: pre-wrap;">' . ($record->last_test_output ?? 'Sin logs') . '</pre>'))
                    ->modalSubmitAction(false)
                    ->modalCancelActionLabel('Cerrar'),
                Tables\Actions\EditAction::make()
                    ->label('')
                    ->tooltip('Editar')
                    ->slideOver(),
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
            'index' => Pages\ListVpnTunnels::route('/'),
            'create' => Pages\CreateVpnTunnel::route('/create'),
            'edit' => Pages\EditVpnTunnel::route('/{record}/edit'),
        ];
    }
}
