<x-filament-panels::page>
    <form wire:submit="save">
        {{ $this->form }}

        <div class="mt-6">
            <x-filament::button type="submit">
                Guardar Cambios
            </x-filament::button>
        </div>
    </form>

    {{-- Backups List --}}
    <div class="mt-8">
        <x-filament::section>
            <x-slot name="heading">
                Backups Disponibles
            </x-slot>
            
            <x-slot name="description">
                Lista de todos los backups creados. Puedes descargar, restaurar o eliminar backups desde aquí.
            </x-slot>

            {{ $this->table }}
        </x-filament::section>
    </div>
</x-filament-panels::page>
