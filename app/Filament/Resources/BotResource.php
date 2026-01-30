<?php

namespace App\Filament\Resources;

use App\Filament\Resources\BotResource\Pages;
use App\Filament\Resources\BotResource\RelationManagers;
use App\Models\Bot;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\SoftDeletingScope;

class BotResource extends Resource
{
    protected static ?string $model = Bot::class;

    protected static ?string $navigationIcon = 'heroicon-o-rectangle-stack';

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Tabs::make('Bot Configuration')
                    ->tabs([
                        Forms\Components\Tabs\Tab::make('General')
                            ->icon('heroicon-o-cog')
                            ->schema([
                                Forms\Components\TextInput::make('name')
                                    ->required()
                                    ->maxLength(255),
                                Forms\Components\Textarea::make('description')
                                    ->rows(3),
                                Forms\Components\Grid::make(3)
                                    ->schema([
                                        Forms\Components\Toggle::make('is_active')
                                            ->label('Activo')
                                            ->default(true),
                                        Forms\Components\Toggle::make('test_mode')
                                            ->label('Modo Prueba')
                                            ->helperText('Solo responde a números en whitelist'),
                                    ]),
                                Forms\Components\TagsInput::make('whitelist')
                                    ->label('Whitelist de Números')
                                    ->placeholder('Escribe un número y presiona Enter')
                                    ->helperText('Formato internacional: 521234567890'),
                            ]),
                        
                        Forms\Components\Tabs\Tab::make('Horarios')
                            ->icon('heroicon-o-clock')
                            ->schema([
                                Forms\Components\Repeater::make('schedules')
                                    ->label('Horarios de Atención')
                                    ->schema([
                                        Forms\Components\Select::make('day')
                                            ->options([
                                                'monday' => 'Lunes',
                                                'tuesday' => 'Martes',
                                                'wednesday' => 'Miércoles',
                                                'thursday' => 'Jueves',
                                                'friday' => 'Viernes',
                                                'saturday' => 'Sábado',
                                                'sunday' => 'Domingo',
                                            ])
                                            ->required(),
                                        Forms\Components\TimePicker::make('start_time')
                                            ->required(),
                                        Forms\Components\TimePicker::make('end_time')
                                            ->required(),
                                    ])
                                    ->columns(3)
                                    ->itemLabel(fn (array $state): ?string => $state['day'] ?? null),
                            ]),

                        Forms\Components\Tabs\Tab::make('IA Config (Fallback)')
                            ->icon('heroicon-o-cpu-chip')
                            ->schema([
                                Forms\Components\Toggle::make('ai_enabled')
                                    ->label('Activar IA como Fallback')
                                    ->live(),
                                Forms\Components\Grid::make(2)
                                    ->visible(fn (Forms\Get $get) => $get('ai_enabled'))
                                    ->schema([
                                        Forms\Components\Select::make('ai_provider')
                                            ->options(['openai' => 'OpenAI'])
                                            ->default('openai')
                                            ->required(),
                                        Forms\Components\Select::make('ai_model')
                                            ->options([
                                                'gpt-3.5-turbo' => 'GPT-3.5 Turbo (Económico)',
                                                'gpt-4o' => 'GPT-4o (Avanzado)',
                                                'gpt-4o-mini' => 'GPT-4o Mini (Ultra-Económico)',
                                            ])
                                            ->default('gpt-3.5-turbo')
                                            ->required(),
                                        Forms\Components\TextInput::make('ai_api_key')
                                            ->label('API Key')
                                            ->password()
                                            ->dehydrated(fn ($state) => filled($state))
                                            ->columnSpanFull(),
                                        Forms\Components\TextInput::make('ai_max_tokens')
                                            ->label('Tokens Máximos por Respuesta')
                                            ->numeric()
                                            ->default(150),
                                        Forms\Components\TextInput::make('ai_daily_token_limit')
                                            ->label('Límite Diario de Tokens')
                                            ->numeric()
                                            ->default(10000),
                                    ]),
                            ]),

                        Forms\Components\Tabs\Tab::make('Chatwoot')
                            ->icon('heroicon-o-chat-bubble-bottom-center-text')
                            ->schema([
                                Forms\Components\Toggle::make('chatwoot_enabled')
                                    ->label('Activar Integración con Chatwoot')
                                    ->helperText('Permite que las conversaciones se transfieran a Chatwoot para atención humana.')
                                    ->live(),
                                
                                Forms\Components\Placeholder::make('webhook_url')
                                    ->label('URL del Webhook (Configurar en Chatwoot)')
                                    ->visible(fn (Forms\Get $get) => $get('chatwoot_enabled'))
                                    ->content(fn () => url('/api/chatwoot/webhook')),

                                Forms\Components\Grid::make(2)
                                    ->visible(fn (Forms\Get $get) => $get('chatwoot_enabled'))
                                    ->schema([
                                        Forms\Components\TextInput::make('chatwoot_url')
                                            ->label('URL de Chatwoot')
                                            ->placeholder('https://chatwoot.tu-dominio.com')
                                            ->required(),
                                        Forms\Components\TextInput::make('chatwoot_account_id')
                                            ->label('ID de Cuenta')
                                            ->required(),
                                        Forms\Components\TextInput::make('chatwoot_token')
                                            ->label('Token de API (Platform/User)')
                                            ->password()
                                            ->dehydrated(fn ($state) => filled($state))
                                            ->required(),
                                        Forms\Components\TextInput::make('chatwoot_inbox_id')
                                            ->label('ID de Inbox (WhatsApp/API)')
                                            ->placeholder('Opcional si solo usas uno')
                                            ->required(),
                                    ]),
                                
                                Forms\Components\Actions::make([
                                    Forms\Components\Actions\Action::make('test_chatwoot')
                                        ->label('Validar Conexión con Chatwoot')
                                        ->icon('heroicon-o-check-circle')
                                        ->color('success')
                                        ->visible(fn (Forms\Get $get) => $get('chatwoot_enabled'))
                                        ->action(function (Forms\Get $get, Forms\Set $set) {
                                            $url = $get('chatwoot_url');
                                            $token = $get('chatwoot_token');
                                            $accountId = $get('chatwoot_account_id');

                                            if (!$url || !$token || !$accountId) {
                                                \Filament\Notifications\Notification::make()
                                                    ->title('Faltan datos de configuración')
                                                    ->danger()
                                                    ->send();
                                                return;
                                            }

                                            try {
                                                $response = \Illuminate\Support\Facades\Http::withHeaders([
                                                    'api_access_token' => $token,
                                                ])->get("{$url}/api/v1/accounts/{$accountId}/inboxes");

                                                if ($response->successful()) {
                                                    \Filament\Notifications\Notification::make()
                                                        ->title('Conexión Exitosa con Chatwoot')
                                                        ->success()
                                                        ->send();
                                                } else {
                                                    \Filament\Notifications\Notification::make()
                                                        ->title('Error de Conexión: ' . $response->status())
                                                        ->danger()
                                                        ->send();
                                                }
                                            } catch (\Exception $e) {
                                                \Filament\Notifications\Notification::make()
                                                    ->title('Fallo la conexión: ' . $e->getMessage())
                                                    ->danger()
                                                    ->send();
                                            }
                                        }),
                                ]),
                            ]),
                    ])->columnSpanFull(),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('name')
                    ->searchable(),
                Tables\Columns\IconColumn::make('is_active')
                    ->boolean(),
                Tables\Columns\IconColumn::make('test_mode')
                    ->boolean(),
                Tables\Columns\IconColumn::make('ai_enabled')
                    ->boolean(),
                Tables\Columns\TextColumn::make('ai_provider')
                    ->searchable(),
                Tables\Columns\TextColumn::make('ai_model')
                    ->searchable(),
                Tables\Columns\TextColumn::make('ai_max_tokens')
                    ->numeric()
                    ->sortable(),
                Tables\Columns\TextColumn::make('ai_daily_token_limit')
                    ->numeric()
                    ->sortable(),
                Tables\Columns\TextColumn::make('created_at')
                    ->dateTime()
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
                Tables\Columns\TextColumn::make('updated_at')
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
            RelationManagers\StepsRelationManager::class,
        ];
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListBots::route('/'),
            'create' => Pages\CreateBot::route('/create'),
            'edit' => Pages\EditBot::route('/{record}/edit'),
        ];
    }
}
