<?php

namespace App\Filament\Resources;

use App\Filament\Resources\PlanResource\Pages;
use App\Filament\Resources\PlanResource\RelationManagers;
use App\Models\Plan;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\SoftDeletingScope;

class PlanResource extends Resource
{
    protected static ?string $model = Plan::class;

    protected static ?string $navigationIcon = 'heroicon-o-currency-dollar';

    public static function getModelLabel(): string
    {
        return 'Plan de Internet';
    }

    public static function getPluralModelLabel(): string
    {
        return 'Planes de Internet';
    }

    public static function getNavigationLabel(): string
    {
        return 'Planes';
    }

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\TextInput::make('name')
                    ->label('Nombre del Plan')
                    ->required()
                    ->maxLength(255),
                Forms\Components\TextInput::make('download_speed_mbps')
                    ->label('Bajada (Mbps)')
                    ->required()
                    ->numeric()
                    ->default(0)
                    ->dehydrateStateUsing(fn ($state) => intval(floatval($state) * 1000))
                    ->afterStateHydrated(function ($component, $state) {
                        $component->state($state ? round($state / 1000, 2) : 0);
                    }),
                Forms\Components\TextInput::make('upload_speed_mbps')
                    ->label('Subida (Mbps)')
                    ->required()
                    ->numeric()
                    ->default(0)
                    ->dehydrateStateUsing(fn ($state) => intval(floatval($state) * 1000))
                    ->afterStateHydrated(function ($component, $state) {
                        $component->state($state ? round($state / 1000, 2) : 0);
                    }),
                Forms\Components\TextInput::make('price')
                    ->label('Precio Mensual')
                    ->required()
                    ->numeric()
                    ->prefix('$')
                    ->step(0.01),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('name')
                    ->label('Nombre')
                    ->searchable(),
                Tables\Columns\TextColumn::make('download_speed_kbps')
                    ->label('Bajada')
                    ->formatStateUsing(fn ($state) => round($state / 1000, 2) . ' Mbps')
                    ->sortable(),
                Tables\Columns\TextColumn::make('upload_speed_kbps')
                    ->label('Subida')
                    ->formatStateUsing(fn ($state) => round($state / 1000, 2) . ' Mbps')
                    ->sortable(),
                Tables\Columns\TextColumn::make('price')
                    ->label('Precio')
                    ->money('MXN')
                    ->sortable(),
                Tables\Columns\TextColumn::make('created_at')
                    ->label('Creado')
                    ->dateTime()
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
            ])
            ->filters([
                //
            ])
            ->actions([
                Tables\Actions\EditAction::make(),
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
            'index' => Pages\ListPlans::route('/'),
            'create' => Pages\CreatePlan::route('/create'),
            'edit' => Pages\EditPlan::route('/{record}/edit'),
        ];
    }
}
