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

    protected static ?string $navigationIcon = 'heroicon-o-server';

    public static function getModelLabel(): string
    {
        return 'Router / OLT';
    }

    public static function getPluralModelLabel(): string
    {
        return 'Routers y OLTs';
    }

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\TextInput::make('name')
                    ->label('Nombre del Nodo')
                    ->required()
                    ->maxLength(255),
                Forms\Components\TextInput::make('ip_address')
                    ->label('Dirección IP')
                    ->required()
                    ->ip()
                    ->maxLength(255),
                Forms\Components\TextInput::make('api_user')
                    ->label('Usuario API')
                    ->maxLength(255),
                Forms\Components\TextInput::make('api_password')
                    ->label('Contraseña API')
                    ->password()
                    ->maxLength(255),
                Forms\Components\TextInput::make('api_port')
                    ->label('Puerto API')
                    ->required()
                    ->numeric()
                    ->default(8728),
                Forms\Components\Hidden::make('type')
                    ->default('mikrotik'),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
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
                Tables\Columns\TextColumn::make('created_at')
                    ->label('Registrado')
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
            'index' => Pages\ListRouters::route('/'),
            'create' => Pages\CreateRouter::route('/create'),
            'edit' => Pages\EditRouter::route('/{record}/edit'),
        ];
    }
}
