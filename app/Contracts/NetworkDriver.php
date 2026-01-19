<?php

namespace App\Contracts;

interface NetworkDriver
{
    /**
     * Connect to the device.
     */
    public function connect(array $credentials): bool;

    /**
     * Disconnect from the device.
     */
    public function disconnect(): void;

    /**
     * Execute a command on the device.
     */
    public function executeCommand(string $command): mixed;

    /**
     * Provision a service (e.g. PPPoE Secret, Hotspot User, ONT).
     */
    public function provisionService(array $data): bool;

    /**
     * Suspend a service (e.g. disable secret, block MAC).
     */
    public function suspendService(string $identifier): bool;

    /**
     * Restore a service.
     */
    public function restoreService(string $identifier): bool;
    
    /**
     * Get health stats (e.g. Optical Power, Signal).
     */
    public function getHealthStats(string $identifier): array;
}
