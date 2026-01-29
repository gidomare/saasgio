<?php

namespace App\Filament\Resources\RouterResource\RelationManagers;

use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\RelationManagers\RelationManager;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\SoftDeletingScope;

class ApiEventsRelationManager extends RelationManager
{
    protected static string $relationship = 'apiEvents';

    public function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\TextInput::make('event_name')
                    ->label('Nombre del Evento')
                    ->required()
                    ->maxLength(255),
                Forms\Components\Select::make('event_type')
                    ->label('Tipo de Evento')
                    ->options([
                        'connect' => 'Conectar',
                        'disconnect' => 'Desconectar',
                        'suspend' => 'Suspender',
                        'activate' => 'Activar',
                    ])
                    ->required(),
                Forms\Components\Select::make('http_method')
                    ->label('Método HTTP')
                    ->options([
                        'GET' => 'GET',
                        'POST' => 'POST',
                        'PUT' => 'PUT',
                        'PATCH' => 'PATCH',
                    ])
                    ->default('POST')
                    ->required(),
                Forms\Components\TextInput::make('endpoint_url')
                    ->label('URL del Endpoint')
                    ->url()
                    ->required()
                    ->columnSpanFull(),
                Forms\Components\KeyValue::make('headers')
                    ->label('Encabezados (Headers)')
                    ->keyLabel('Header')
                    ->valueLabel('Valor'),
                Forms\Components\Textarea::make('payload_template')
                    ->label('Plantilla de Payload (JSON)')
                    ->rows(5)
                    ->columnSpanFull(),
            ]);
    }

    public function table(Table $table): Table
    {
        return $table
            ->recordTitleAttribute('event_name')
            ->columns([
                Tables\Columns\TextColumn::make('event_name')->label('Nombre'),
                Tables\Columns\TextColumn::make('event_type')
                    ->label('Tipo')
                    ->badge()
                    ->color(fn (string $state): string => match ($state) {
                        'connect' => 'success',
                        'disconnect' => 'danger',
                        'suspend' => 'warning',
                        'activate' => 'success',
                    }),
                Tables\Columns\TextColumn::make('http_method')->label('Método'),
                Tables\Columns\TextColumn::make('endpoint_url')
                    ->label('URL')
                    ->limit(30),
            ])
            ->filters([
                //
            ])
            ->headerActions([
                Tables\Actions\CreateAction::make(),
            ])
            ->actions([
                Tables\Actions\EditAction::make(),
                Tables\Actions\DeleteAction::make(),
            ])
            ->bulkActions([
                Tables\Actions\BulkActionGroup::make([
                    Tables\Actions\DeleteBulkAction::make(),
                ]),
            ]);
    }
}
