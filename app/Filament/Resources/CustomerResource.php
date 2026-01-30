<?php

namespace App\Filament\Resources;

use App\Filament\Resources\CustomerResource\Pages;
use App\Filament\Resources\CustomerResource\RelationManagers;
use App\Models\Customer;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\SoftDeletingScope;

class CustomerResource extends Resource
{
    protected static ?string $model = Customer::class;

    protected static ?string $navigationIcon = 'heroicon-o-users';
    
    public static function getModelLabel(): string
    {
        return 'Cliente';
    }

    public static function getPluralModelLabel(): string
    {
        return 'Clientes';
    }

    public static function getNavigationLabel(): string
    {
        return 'Clientes';
    }

    public function mount(): void
    {
        //
    }
    
    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\TextInput::make('name')
                    ->label('Nombre Completo')
                    ->required()
                    ->maxLength(255),
                Forms\Components\TextInput::make('email')
                    ->label('Correo Electrónico')
                    ->email()
                    ->maxLength(255),
                Forms\Components\TextInput::make('phone')
                    ->label('Teléfono / WhatsApp')
                    ->tel()
                    ->maxLength(255),
                Forms\Components\Textarea::make('address')
                    ->label('Dirección Física')
                    ->columnSpanFull(),
                Forms\Components\TextInput::make('coordinates')
                    ->label('Ubicación (GPS)')
                    ->maxLength(255),
                Forms\Components\TextInput::make('wisphub_id')
                    ->label('ID Wisphub')
                    ->numeric()
                    ->disabled(), // Solo lectura, viene de sync
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                // ID
                Tables\Columns\TextColumn::make('wisphub_id')
                    ->label('ID')
                    ->sortable()
                    ->alignCenter(),
                
                // Cliente + Teléfono (combined)
                Tables\Columns\TextColumn::make('name')
                    ->label('Cliente')
                    ->description(fn ($record) => $record->phone)
                    ->searchable()
                    ->sortable()
                    ->weight('bold')
                    ->wrap()
                    ->lineClamp(1),
                
                // Plan + IP (combined)
                Tables\Columns\TextColumn::make('services.plan.name')
                    ->label('Plan')
                    ->description(fn ($record) => $record->services->pluck('ip_address')->filter()->join(', '))
                    ->extraAttributes(['class' => 'text-xs'])
                    ->wrap()
                    ->lineClamp(1),
                
                // Estado
                Tables\Columns\TextColumn::make('services.status')
                    ->label('Estado')
                    ->badge()
                    ->formatStateUsing(fn (string $state): string => match ($state) {
                        'active' => 'ACTIVO',
                        'suspended' => 'SUSPENDIDO',
                        'cancelled' => 'RETIRADO',
                        default => $state,
                    })
                    ->color(fn (string $state): string => match ($state) {
                        'active' => 'success',
                        'suspended' => 'warning',
                        'cancelled' => 'danger',
                        default => 'gray',
                    }),
                
                // Router + Fecha Instalación (combined)
                Tables\Columns\TextColumn::make('services.router.name')
                    ->label('Router')
                    ->description(fn ($record) => $record->installation_date ?? null)
                    ->sortable()
                    ->extraAttributes(['class' => 'text-xs'])
                    ->wrap()
                    ->lineClamp(1),
                
                // Dirección
                Tables\Columns\TextColumn::make('address')
                    ->label('Dirección')
                    ->wrap()
                    ->lineClamp(2)
                    ->extraAttributes(['class' => 'text-xs'])
                    ->searchable()
                    ->sortable(),
            ])
            ->striped()
            ->deferFilters()
            ->defaultPaginationPageOption(25)
            ->filters([
                Tables\Filters\SelectFilter::make('router')
                    ->label('Filtrar por Router')
                    ->relationship('services.router', 'name')
                    ->searchable()
                    ->multiple()
                    ->preload(),
                Tables\Filters\SelectFilter::make('status')
                    ->label('Filtrar por Estado')
                    ->options([
                        'active' => 'Activos',
                        'suspended' => 'Suspendidos',
                        'cancelled' => 'Cancelados',
                    ])
                    ->query(function (Builder $query, array $data): Builder {
                        if (empty($data['values'])) {
                            return $query;
                        }

                        return $query->whereHas('services', fn (Builder $query) => $query->whereIn('status', $data['values']));
                    })
                    ->multiple(),
            ])
            ->actions([
                Tables\Actions\Action::make('toggleStatus')
                    ->label('')
                    ->tooltip(fn ($record) => $record->services->where('status', 'active')->count() > 0 ? 'Suspender' : 'Activar')
                    ->icon(fn ($record) => $record->services->where('status', 'active')->count() > 0 ? 'heroicon-o-pause-circle' : 'heroicon-o-play-circle')
                    ->color(fn ($record) => $record->services->where('status', 'active')->count() > 0 ? 'danger' : 'success')
                    ->requiresConfirmation()
                    ->action(function ($record) {
                        $hasActiveServices = $record->services->where('status', 'active')->count() > 0;
                        $newStatus = $hasActiveServices ? 'suspended' : 'active';
                        
                        $record->services()->update(['status' => $newStatus]);
                        
                        Notification::make()
                            ->title($hasActiveServices ? 'Servicios suspendidos' : 'Servicios activados')
                            ->success()
                            ->send();
                    }),
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
            ]);
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
            'index' => Pages\ListCustomers::route('/'),
            'create' => Pages\CreateCustomer::route('/create'),
            'edit' => Pages\EditCustomer::route('/{record}/edit'),
        ];
    }
}
