<div class="space-y-6">
    @if(isset($config['error']))
    <div class="bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-lg p-4">
        <div class="flex items-start">
            <svg class="w-5 h-5 text-red-600 dark:text-red-400 mr-2 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
            </svg>
            <div>
                <h4 class="text-sm font-semibold text-red-800 dark:text-red-300">Error al leer configuración</h4>
                <p class="text-xs text-red-700 dark:text-red-400 mt-1">{{ $config['error'] }}</p>
                <p class="text-xs text-red-600 dark:text-red-500 mt-2">Verifica que la OLT esté en línea y las credenciales sean correctas.</p>
            </div>
        </div>
    </div>
    @endif
    
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <!-- ONU Profiles -->
        <div class="bg-white dark:bg-gray-800 rounded-lg border border-gray-200 dark:border-gray-700 p-4">
            <h3 class="text-sm font-semibold text-gray-900 dark:text-white mb-3 flex items-center">
                <svg class="w-5 h-5 mr-2 text-blue-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
                </svg>
                Perfiles ONU ({{ count($config['onu_profiles'] ?? []) }})
            </h3>
            <div class="space-y-1 max-h-64 overflow-y-auto">
                @forelse($config['onu_profiles'] ?? [] as $profile)
                    <div class="text-xs bg-gray-50 dark:bg-gray-900 px-3 py-2 rounded border border-gray-100 dark:border-gray-700 font-mono">
                        {{ $profile['name'] }}
                    </div>
                @empty
                    <p class="text-xs text-gray-500 dark:text-gray-400 italic">No se encontraron perfiles</p>
                @endforelse
            </div>
        </div>

        <!-- DBA Profiles -->
        <div class="bg-white dark:bg-gray-800 rounded-lg border border-gray-200 dark:border-gray-700 p-4">
            <h3 class="text-sm font-semibold text-gray-900 dark:text-white mb-3 flex items-center">
                <svg class="w-5 h-5 mr-2 text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path>
                </svg>
                Perfiles DBA ({{ count($config['dba_profiles'] ?? []) }})
            </h3>
            <div class="space-y-1 max-h-64 overflow-y-auto">
                @forelse($config['dba_profiles'] ?? [] as $profile)
                    <div class="text-xs bg-gray-50 dark:bg-gray-900 px-3 py-2 rounded border border-gray-100 dark:border-gray-700 font-mono">
                        {{ $profile['name'] }}
                    </div>
                @empty
                    <p class="text-xs text-gray-500 dark:text-gray-400 italic">No se encontraron perfiles</p>
                @endforelse
            </div>
        </div>

        <!-- Line Profiles -->
        <div class="bg-white dark:bg-gray-800 rounded-lg border border-gray-200 dark:border-gray-700 p-4">
            <h3 class="text-sm font-semibold text-gray-900 dark:text-white mb-3 flex items-center">
                <svg class="w-5 h-5 mr-2 text-purple-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>
                </svg>
                Perfiles Line ({{ count($config['line_profiles'] ?? []) }})
            </h3>
            <div class="space-y-1 max-h-64 overflow-y-auto">
                @forelse($config['line_profiles'] ?? [] as $profile)
                    <div class="text-xs bg-gray-50 dark:bg-gray-900 px-3 py-2 rounded border border-gray-100 dark:border-gray-700 font-mono">
                        {{ $profile['name'] }}
                    </div>
                @empty
                    <p class="text-xs text-gray-500 dark:text-gray-400 italic">No se encontraron perfiles</p>
                @endforelse
            </div>
        </div>

        <!-- Service Profiles -->
        <div class="bg-white dark:bg-gray-800 rounded-lg border border-gray-200 dark:border-gray-700 p-4">
            <h3 class="text-sm font-semibold text-gray-900 dark:text-white mb-3 flex items-center">
                <svg class="w-5 h-5 mr-2 text-orange-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 12a9 9 0 01-9 9m9-9a9 9 0 00-9-9m9 9H3m9 9a9 9 0 01-9-9m9 9c1.657 0 3-4.03 3-9s-1.343-9-3-9m0 18c-1.657 0-3-4.03-3-9s1.343-9 3-9m-9 9a9 9 0 019-9"></path>
                </svg>
                Perfiles Service ({{ count($config['service_profiles'] ?? []) }})
            </h3>
            <div class="space-y-1 max-h-64 overflow-y-auto">
                @forelse($config['service_profiles'] ?? [] as $profile)
                    <div class="text-xs bg-gray-50 dark:bg-gray-900 px-3 py-2 rounded border border-gray-100 dark:border-gray-700 font-mono">
                        {{ $profile['name'] }}
                    </div>
                @empty
                    <p class="text-xs text-gray-500 dark:text-gray-400 italic">No se encontraron perfiles</p>
                @endforelse
            </div>
        </div>
    </div>

    <div class="bg-gray-50 dark:bg-gray-800 rounded-lg p-3 border border-gray-200 dark:border-gray-700">
        <p class="text-xs text-gray-600 dark:text-gray-400">
            <strong>Última lectura:</strong> {{ $config['timestamp'] ?? 'N/A' }}
        </p>
        <p class="text-xs text-gray-500 dark:text-gray-500 mt-1">
            Esta información se lee directamente de la OLT via SSH. Puedes copiar los nombres de los perfiles para usarlos en la configuración.
        </p>
    </div>
</div>
