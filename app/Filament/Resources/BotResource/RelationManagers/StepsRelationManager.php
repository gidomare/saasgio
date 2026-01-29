<?php

namespace App\Filament\Resources\BotResource\RelationManagers;

use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\RelationManagers\RelationManager;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\SoftDeletingScope;

class StepsRelationManager extends RelationManager
{
    protected static string $relationship = 'steps';

    public function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Grid::make(2)
                    ->schema([
                        Forms\Components\TextInput::make('name')
                            ->label('Nombre del Paso (Interno)')
                            ->required()
                            ->maxLength(255),
                        Forms\Components\Select::make('type')
                            ->label('Tipo de Interacción')
                            ->options([
                                'message' => 'Mensaje Simple',
                                'menu' => 'Menú de Opciones',
                                'input' => 'Capturar Dato (Input)',
                                'action' => 'Acción de Sistema',
                                'redirect' => 'Redirigir a otro Paso',
                                'end' => 'Finalizar Conversación',
                            ])
                            ->live()
                            ->required(),
                    ]),

                Forms\Components\Section::make('Contenido y Lógica')
                    ->schema([
                        // Caso: Mensaje
                        Forms\Components\Textarea::make('content.text')
                            ->label('Texto del Mensaje')
                            ->visible(fn (Forms\Get $get) => in_array($get('type'), ['message', 'menu', 'input']))
                            ->required()
                            ->rows(4),
                        
                        // Caso: Menú (Repeater)
                        Forms\Components\Repeater::make('content.options')
                            ->label('Opciones del Menú')
                            ->schema([
                                Forms\Components\TextInput::make('label')
                                    ->label('Texto de la Opción (Botón/Texto)')
                                    ->required(),
                                Forms\Components\Select::make('target_step_id')
                                    ->label('Ir al Paso...')
                                    ->options(fn (RelationManager $livewire) => 
                                        $livewire->getOwnerRecord()->steps()
                                            ->where('id', '!=', $livewire->record?->id)
                                            ->pluck('name', 'id')
                                    )
                                    ->searchable(),
                            ])
                            ->visible(fn (Forms\Get $get) => $get('type') === 'menu')
                            ->columns(2)
                            ->itemLabel(fn (array $state): ?string => $state['label'] ?? null),

                        // Caso: Input (Variable)
                        Forms\Components\TextInput::make('content.variable')
                            ->label('Nombre de Variable (donde se guardará la respuesta)')
                            ->placeholder('ej: cliente_nombre')
                            ->visible(fn (Forms\Get $get) => $get('type') === 'input')
                            ->required(),

                        // Redirección por defecto
                        Forms\Components\Select::make('next_step_id')
                            ->label('Siguiente Paso (Por defecto)')
                            ->helperText('A dónde ir tras mostrar este mensaje o capturar el dato')
                            ->options(fn (RelationManager $livewire) => 
                                $livewire->getOwnerRecord()->steps()
                                    ->where('id', '!=', $livewire->record?->id)
                                    ->pluck('name', 'id')
                            )
                            ->visible(fn (Forms\Get $get) => in_array($get('type'), ['message', 'input', 'redirect']))
                            ->searchable(),
                    ]),

                Forms\Components\TextInput::make('order')
                    ->label('Orden')
                    ->numeric()
                    ->default(0),
            ]);
    }

    public function table(Table $table): Table
    {
        return $table
            ->recordTitleAttribute('name')
            ->columns([
                Tables\Columns\TextColumn::make('order')
                    ->label('#')
                    ->sortable(),
                Tables\Columns\TextColumn::make('name')
                    ->label('Nombre')
                    ->searchable(),
                Tables\Columns\TextColumn::make('type')
                    ->label('Tipo')
                    ->badge()
                    ->color(fn (string $state): string => match ($state) {
                        'message' => 'gray',
                        'menu' => 'warning',
                        'input' => 'info',
                        'action' => 'danger',
                        'redirect' => 'success',
                        'end' => 'gray',
                    }),
                Tables\Columns\TextColumn::make('nextStep.name')
                    ->label('Continúa a...')
                    ->placeholder('Fin del flujo'),
            ])
            ->defaultSort('order')
            ->reorderable('order')
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
