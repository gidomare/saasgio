<div class="space-y-4">
    <div class="bg-gray-50 dark:bg-gray-800 rounded-lg p-4">
        <h3 class="text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            Última Verificación: {{ $olt->last_check_at?->format('d/m/Y H:i:s') ?? 'Nunca' }}
        </h3>
        
        @if($olt->hardware_info)
        <div class="mb-4">
            <h4 class="text-xs font-semibold text-gray-600 dark:text-gray-400 mb-2">Información del Hardware:</h4>
            <pre class="text-xs bg-white dark:bg-gray-900 p-2 rounded border border-gray-200 dark:border-gray-700 overflow-x-auto">{{ json_encode($olt->hardware_info, JSON_PRETTY_PRINT) }}</pre>
        </div>
        @endif
        
        <div>
            <h4 class="text-xs font-semibold text-gray-600 dark:text-gray-400 mb-2">Log de Conexión:</h4>
            <pre class="text-xs bg-white dark:bg-gray-900 p-3 rounded border border-gray-200 dark:border-gray-700 overflow-x-auto max-h-96">{{ $olt->last_check_output ?? 'No hay logs disponibles' }}</pre>
        </div>
    </div>
</div>
