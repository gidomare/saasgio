<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Olt;
use App\Models\OltEvent;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class OltTrapController extends Controller
{
    /**
     * Receive SNMP trap from OLT
     */
    public function receiveTrap(Request $request)
    {
        try {
            $trapData = $request->input('trap_data', '');
            $receivedAt = $request->input('received_at', now());

            Log::info('SNMP Trap Received', [
                'trap_data' => $trapData,
                'source_ip' => $request->ip(),
            ]);

            // Parse trap data
            $parsed = $this->parseTrapData($trapData);

            if (!$parsed) {
                return response()->json([
                    'success' => false,
                    'message' => 'Could not parse trap data',
                ], 400);
            }

            // Find OLT by IP (extract from trap or use source IP)
            $olt = Olt::where('ip_admin', $parsed['olt_ip'] ?? $request->ip())->first();

            if (!$olt) {
                Log::warning('Trap received from unknown OLT', [
                    'ip' => $parsed['olt_ip'] ?? $request->ip(),
                ]);
                
                return response()->json([
                    'success' => false,
                    'message' => 'Unknown OLT',
                ], 404);
            }

            // Store event
            $event = OltEvent::create([
                'olt_id' => $olt->id,
                'event_type' => $parsed['event_type'],
                'onu_sn' => $parsed['onu_sn'] ?? null,
                'port' => $parsed['port'] ?? null,
                'onu_id' => $parsed['onu_id'] ?? null,
                'severity' => $parsed['severity'] ?? 'info',
                'trap_data' => ['raw' => $trapData, 'parsed' => $parsed],
                'message' => $parsed['message'] ?? 'SNMP trap received',
                'received_at' => $receivedAt,
            ]);

            Log::info('OLT Event Stored', [
                'event_id' => $event->id,
                'olt' => $olt->name,
                'type' => $parsed['event_type'],
            ]);

            return response()->json([
                'success' => true,
                'event_id' => $event->id,
            ]);

        } catch (\Exception $e) {
            Log::error('Trap Processing Failed', [
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString(),
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Internal server error',
            ], 500);
        }
    }

    /**
     * Parse SNMP trap data
     */
    protected function parseTrapData(string $trapData): ?array
    {
        // Basic parsing - will need to be enhanced based on actual VSOL trap format
        $lines = explode("\n", $trapData);
        
        $parsed = [
            'event_type' => 'unknown',
            'severity' => 'info',
            'message' => 'SNMP trap received',
        ];

        foreach ($lines as $line) {
            $line = trim($line);
            
            // Extract OID and value
            if (preg_match('/^([\d\.]+)\s+(.+)$/', $line, $matches)) {
                $oid = $matches[1];
                $value = trim($matches[2]);

                // VSOL ONU Register OID
                if (strpos($oid, '1.3.6.1.4.1.37950.1.1.5.12.1.1.1') !== false) {
                    $parsed['event_type'] = 'onu_register';
                    $parsed['severity'] = 'info';
                    $parsed['message'] = 'ONU registered';
                }
                // VSOL ONU Deregister OID
                elseif (strpos($oid, '1.3.6.1.4.1.37950.1.1.5.12.1.1.2') !== false) {
                    $parsed['event_type'] = 'onu_deregister';
                    $parsed['severity'] = 'warning';
                    $parsed['message'] = 'ONU deregistered';
                }
                // VSOL ONU LOS (Loss of Signal) OID
                elseif (strpos($oid, '1.3.6.1.4.1.37950.1.1.5.12.1.1.3') !== false) {
                    $parsed['event_type'] = 'onu_los';
                    $parsed['severity'] = 'critical';
                    $parsed['message'] = 'ONU Loss of Signal';
                }

                // Extract ONU Serial Number (common pattern in traps)
                if (preg_match('/FHTT[0-9a-fA-F]{8}|HWTC[0-9a-fA-F]{8}/', $value, $snMatch)) {
                    $parsed['onu_sn'] = $snMatch[0];
                }

                // Extract port information
                if (preg_match('/gpon-olt_[\d\/]+/', $value, $portMatch)) {
                    $parsed['port'] = $portMatch[0];
                }
            }
        }

        return $parsed;
    }
}
