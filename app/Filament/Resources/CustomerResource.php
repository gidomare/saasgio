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
                Tables\Columns\TextColumn::make('wisphub_id')
                    ->label('ID')
                    ->sortable(),
                Tables\Columns\TextColumn::make('name')
                    ->label('Cliente')
                    ->searchable()
                    ->sortable()
                    ->description(fn ($record) => $record->phone)
                    ->weight('bold'),
                Tables\Columns\TextColumn::make('services.plan.name')
                    ->label('Plan / IP')
                    ->description(fn ($record) => $record->services->pluck('ip_address')->filter()->join(', '))
                    ->extraAttributes(['class' => 'text-xs']),
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
                Tables\Columns\TextColumn::make('services.router.name')
                    ->label('Router')
                    ->listWithLineBreaks()
                    ->sortable()
                    ->extraAttributes(['class' => 'text-xs'])
                    ->toggleable(),
                Tables\Columns\TextColumn::make('installation_date')
                    ->label('Instalado')
                    ->date('d/m/y')
                    ->sortable(),
                Tables\Columns\TextColumn::make('address')
                    ->label('Dirección')
                    ->wrap()
                    ->lineClamp(2)
                    ->extraAttributes(['class' => 'text-[11px] leading-tight'])
                    ->searchable()
                    ->sortable()
                    ->toggleable(),
                Tables\Columns\TextColumn::make('phone')
                    ->label('Teléfono')
                    ->searchable()
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
                Tables\Columns\TextColumn::make('created_at')
                    ->label('Alta')
                    ->date('d/m/y')
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
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
                    ->label(fn ($record) => $record->services->where('status', 'active')->count() > 0 ? 'Suspender' : 'Activar')
                    ->icon(fn ($record) => $record->services->where('status', 'active')->count() > 0 ? 'heroicon-o-pause-circle' : 'heroicon-o-play-circle')
                    ->color(fn ($record) => $record->services->where('status', 'active')->count() > 0 ? 'danger' : 'success')
                    ->requiresConfirmation()
                    ->modalHeading(fn ($record) => ($record->services->where('status', 'active')->count() > 0 ? 'Suspender' : 'Activar') . ' servicios de ' . $record->name)
                    ->modalDescription('¿Seguro que deseas cambiar el estado de conexión de este cliente?')
                    ->action(function ($record) {
                        $newStatus = $record->services->where('status', 'active')->count() > 0 ? 'suspended' : 'active';
                        $record->services()->update(['status' => $newStatus]);
                        
                        \Filament\Notifications\Notification::make()
                            ->title('Estado actualizado')
                            ->body("El cliente {$record->name} ahora está " . ($newStatus === 'active' ? 'ACTIVO' : 'SUSPENDIDO'))
                            ->success()
                            ->send();
                    }),
                Tables\Actions\ActionGroup::make([
                    Tables\Actions\EditAction::make(),
                    Tables\Actions\DeleteAction::make(),
                ])->icon('heroicon-m-ellipsis-vertical'),
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
