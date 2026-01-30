<?php

namespace App\Filament\Resources;

use App\Filament\Resources\BotUsageLogResource\Pages;
use App\Filament\Resources\BotUsageLogResource\RelationManagers;
use App\Models\BotUsageLog;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\SoftDeletingScope;

class BotUsageLogResource extends Resource
{
    protected static ?string $model = BotUsageLog::class;

    protected static ?string $navigationIcon = 'heroicon-o-chat-bubble-left-right';

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Grid::make(3)
                    ->schema([
                        Forms\Components\Select::make('bot_id')
                            ->relationship('bot', 'name')
                            ->disabled(),
                        \Filament\Forms\Components\TextInput::make('phone_number')
                            ->label('Teléfono')
                            ->disabled(),
                        \Filament\Forms\Components\TextInput::make('interaction_type')
                            ->label('Tipo de Respuesta')
                            ->disabled(),
                    ]),
                Forms\Components\Grid::make(2)
                    ->schema([
                        Forms\Components\TextInput::make('tokens_used')
                            ->label('Tokens')
                            ->numeric()
                            ->disabled(),
                        Forms\Components\TextInput::make('cost')
                            ->label('Costo (Est.)')
                            ->numeric()
                            ->prefix('$')
                            ->disabled(),
                    ]),
                \Filament\Forms\Components\KeyValue::make('metadata')
                    ->label('Detalles de la Interacción')
                    ->columnSpanFull(),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('bot.name')
                    ->label('Bot')
                    ->sortable(),
                Tables\Columns\TextColumn::make('phone_number')
                    ->label('Usuario')
                    ->searchable(),
                Tables\Columns\TextColumn::make('interaction_type')
                    ->label('Origen')
                    ->badge()
                    ->color(fn (string $state): string => match ($state) {
                        'ia' => 'primary',
                        'memory' => 'success',
                        'flow' => 'gray',
                    }),
                Tables\Columns\TextColumn::make('tokens_used')
                    ->label('Tokens')
                    ->numeric()
                    ->sortable(),
                Tables\Columns\TextColumn::make('cost')
                    ->label('Costo')
                    ->formatStateUsing(fn ($state) => '$' . number_format($state, 6))
                    ->sortable(),
                Tables\Columns\TextColumn::make('created_at')
                    ->label('Fecha')
                    ->dateTime()
                    ->sortable(),
            ])
            ->defaultSort('created_at', 'desc')
            ->filters([
                //
            ])
            ->actions([
                Tables\Actions\ViewAction::make()
                    ->label('')
                    ->tooltip('Ver'),
                Tables\Actions\EditAction::make()
                    ->label('')
                    ->tooltip('Editar'),
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
            'index' => Pages\ListBotUsageLogs::route('/'),
            'create' => Pages\CreateBotUsageLog::route('/create'),
            'view' => Pages\ViewBotUsageLog::route('/{record}'),
            'edit' => Pages\EditBotUsageLog::route('/{record}/edit'),
        ];
    }
}
