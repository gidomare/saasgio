<?php

namespace App\Filament\Resources;

use App\Filament\Resources\BotKnowledgeBaseResource\Pages;
use App\Filament\Resources\BotKnowledgeBaseResource\RelationManagers;
use App\Models\BotKnowledgeBase;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\SoftDeletingScope;

class BotKnowledgeBaseResource extends Resource
{
    protected static ?string $model = BotKnowledgeBase::class;

    protected static ?string $navigationIcon = 'heroicon-o-academic-cap';

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Select::make('bot_id')
                    ->relationship('bot', 'name')
                    ->required(),
                Forms\Components\TextInput::make('question_normalized')
                    ->label('Pregunta (Normalizada)')
                    ->required()
                    ->helperText('Formato sugerido: minúsculas y sin acentos para mejor coincidencia.'),
                Forms\Components\Textarea::make('answer')
                    ->label('Respuesta')
                    ->required()
                    ->rows(5)
                    ->columnSpanFull(),
                Forms\Components\TextInput::make('usage_count')
                    ->label('Veces Utilizada')
                    ->numeric()
                    ->default(0)
                    ->disabled(),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('bot.name')
                    ->label('Bot')
                    ->sortable(),
                Tables\Columns\TextColumn::make('question_normalized')
                    ->label('Pregunta')
                    ->searchable(),
                Tables\Columns\TextColumn::make('usage_count')
                    ->label('Usos')
                    ->numeric()
                    ->sortable(),
                Tables\Columns\TextColumn::make('created_at')
                    ->label('Fecha')
                    ->dateTime()
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
            ])
            ->filters([
                //
            ])
            ->actions([
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
            'index' => Pages\ListBotKnowledgeBases::route('/'),
            'create' => Pages\CreateBotKnowledgeBase::route('/create'),
            'edit' => Pages\EditBotKnowledgeBase::route('/{record}/edit'),
        ];
    }
}
