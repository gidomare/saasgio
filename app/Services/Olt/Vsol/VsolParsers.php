<?php

declare(strict_types=1);

namespace App\Services\Olt\Vsol;

final class VsolParsers
{
    /**
     * Parse ONUs from running-config (VSOL Estilo C)
     * Formato exacto encontrado:
     * interface gpon 0/4
     *  onu add 1 profile default sn HWTCed556b5e
     *  onu 1 desc Elizabeth_Mercedez
     *  onu 1 tcont 1 dba ADMINOLT_TCONT_1G_GPON
     *  onu 1 gemport 1 traffic-limit downstream ADMINOLT-100-MEGAS-DOWN
     *  onu 1 service INTERNET gemport 1 vlan 881
     */
    public static function parseOnusFromRunningConfig(string $raw): array
    {
        $lines = preg_split("/\n+/", str_replace("\r", "", $raw));
        $onus = [];
        $currentPon = null;

        foreach ($lines as $line) {
            $l = trim($line);

            // Detectar interface gpon (formato: "interface gpon 0/4")
            if (preg_match('/^interface\s+gpon\s+([\d\/]+)/i', $l, $m)) {
                $currentPon = $m[1];
                continue;
            }

            // Reset PON al salir del bloque
            if ($l === 'exit' || $l === '!') {
                $currentPon = null;
                continue;
            }

            // Formato principal: "onu add 1 profile default sn HWTCed556b5e"
            if ($currentPon && preg_match('/^onu\s+add\s+(\d+)\s+profile\s+(\S+)\s+sn\s+([A-Za-z0-9]+)/i', $l, $m)) {
                $onuId = (int)$m[1];
                $profile = $m[2];
                $sn = strtoupper($m[3]);

                $key = "{$currentPon}:{$onuId}";
                $onus[$key] = [
                    'pon'     => $currentPon,
                    'onu_id'  => $onuId,
                    'sn'      => $sn,
                    'profile' => $profile,
                    'line_profile' => $profile,
                    'name'    => null,
                    'vlan'    => null,
                    'dba_profile' => null,
                    'service_profile' => null,
                    'traffic_limit_downstream' => null,
                    'source'  => 'running-config',
                ];
                continue;
            }

            // Parsear descripción: "onu 1 desc Elizabeth_Mercedez"
            if ($currentPon && preg_match('/^onu\s+(\d+)\s+desc\s+(.+)/i', $l, $m)) {
                $onuId = (int)$m[1];
                $desc = trim($m[2]);
                $key = "{$currentPon}:{$onuId}";
                
                if (isset($onus[$key])) {
                    $onus[$key]['name'] = $desc;
                }
                continue;
            }

            // Parsear DBA Profile: "onu 3 tcont 1 dba ADMINOLT_TCONT_1G_GPON"
            if ($currentPon && preg_match('/^onu\s+(\d+)\s+tcont\s+\d+\s+dba\s+(\S+)/i', $l, $m)) {
                $onuId = (int)$m[1];
                $dbaProfile = $m[2];
                $key = "{$currentPon}:{$onuId}";
                
                if (isset($onus[$key])) {
                    $onus[$key]['dba_profile'] = $dbaProfile;
                }
                continue;
            }

            // Parsear Traffic Limit: "onu 3 gemport 1 traffic-limit downstream ADMINOLT-100-MEGAS-DOWN"
            if ($currentPon && preg_match('/^onu\s+(\d+)\s+gemport\s+\d+\s+traffic-limit\s+downstream\s+(\S+)/i', $l, $m)) {
                $onuId = (int)$m[1];
                $trafficLimit = $m[2];
                $key = "{$currentPon}:{$onuId}";
                
                if (isset($onus[$key])) {
                    $onus[$key]['traffic_limit_downstream'] = $trafficLimit;
                }
                continue;
            }

            // Parsear Service Profile: "onu 3 service INTERNET gemport 1 vlan 881"
            if ($currentPon && preg_match('/^onu\s+(\d+)\s+service\s+(\S+)\s+gemport/i', $l, $m)) {
                $onuId = (int)$m[1];
                $serviceProfile = $m[2];
                $key = "{$currentPon}:{$onuId}";
                
                if (isset($onus[$key])) {
                    $onus[$key]['service_profile'] = $serviceProfile;
                }
                // Continue to also parse VLAN from same line
            }

            // Parsear VLAN: "onu 1 service ser_1 gemport 1 vlan 881"
            if ($currentPon && preg_match('/^onu\s+(\d+)\s+service\s+.+vlan\s+(\d+)/i', $l, $m)) {
                $onuId = (int)$m[1];
                $vlan = (int)$m[2];
                $key = "{$currentPon}:{$onuId}";
                
                if (isset($onus[$key])) {
                    $onus[$key]['vlan'] = $vlan;
                }
            }
        }

        return array_values($onus);
    }

    /**
     * Legacy parser for "show gpon onu" style output (fallback)
     */
    public static function parseOnuList(string $raw, string $mode): array
    {
        $raw = str_replace("\r", "", $raw);
        $lines = preg_split("/\n+/", $raw);

        $rows = [];

        foreach ($lines as $line) {
            $l = trim($line);
            if ($l === '') continue;

            // Saltar headers típicos
            if (preg_match('/^(hello|copyright|user access|entering|escape character)/i', $l)) continue;
            if (preg_match('/^(login:|password:)/i', $l)) continue;
            if (preg_match('/^(onu|gpon|pon)\s+id/i', $l)) continue;
            if (preg_match('/^-{3,}$/', $l)) continue;

            $pon = null;
            $onuId = null;
            $sn = null;
            $state = null;

            // Intento #1: "gpon0/1:23"
            if (preg_match('/(?P<pon>gpon\d+\/\d+)\s*[:\/]\s*(?P<onu>\d+)/i', $l, $m)) {
                $pon = strtolower($m['pon']);
                $onuId = $m['onu'];
            }

            // Intento #2: "1/1 23" o "1/1/1 23" o "0/4 23"
            if ($pon === null && preg_match('/^(?P<pon>\d+\/\d+(?:\/\d+)?)\s+(?P<onu>\d+)\b/', $l, $m)) {
                $pon = $m['pon'];
                $onuId = $m['onu'];
            }

            // SN: "VSOLxxxx" o "SN:VSOLxxxx"
            if (preg_match('/\bSN[:\s]*([A-Z0-9]{8,})\b/i', $l, $m)) {
                $sn = strtoupper($m[1]);
            } else {
                // heurística: token largo alfanumérico típico de SN
                if (preg_match('/\b([A-Z]{3,}[A-Z0-9]{5,})\b/', $l, $m)) {
                    $sn = strtoupper($m[1]);
                }
            }

            // State: online/offline/LOS
            if (preg_match('/\b(online|offline|los|dying-gasp|register|authfail)\b/i', $l, $m)) {
                $state = strtolower($m[1]);
            }

            // Solo guardar si parece una fila ONU (pon + onuId)
            if ($pon !== null && $onuId !== null) {
                $rows[] = [
                    'mode'   => $mode,
                    'pon'    => $pon,
                    'onu_id' => is_numeric($onuId) ? (int)$onuId : (string)$onuId,
                    'sn'     => $sn,
                    'state'  => $state,
                    'raw'    => $l,
                ];
            }
        }

        return $rows;
    }

    /**
     * Parses output of 'show onu state'.
     * Handles severe line wrapping by treating output as a continuous stream.
     * Returns: ['0/X:Y' => 'status']
     */
    public static function parseOnuState(string $output): array
    {
        // 1. Clean headers and common noise
        // Header example: Interface AdminState RegisterState WorkingState SerialNumber
        $clean = preg_replace('/Interface\s+AdminState\s+RegisterState\s+WorkingState\s+SerialNumber/i', '', $output);
        
        // 2. Remove newlines to fix wrapping (e.g. "work\n ing", "dying\n gasp")
        $stream = str_replace(["\r", "\n"], '', $clean);
        
        // 3. Match pattern: Interface spaces Admin spaces Register spaces Working spaces Serial
        // Interface format: 1/1/6:102 (Slot/Port/Pon:ID)
        // Regex: (\d+\/\d+\/\d+:\d+) (iface), \s+\S+ (admin), \s+\S+ (reg), \s+(\S+) (work), \s+[A-Z0-9]+ (sn)
        $statuses = [];
        
        if (preg_match_all('/(\d+\/\d+\/\d+:\d+)\s+\S+\s+\S+\s+(\S+)\s+[A-Z0-9]+/i', $stream, $matches, PREG_SET_ORDER)) {
            foreach ($matches as $m) {
                // Map Interface 1/1/X:Y -> 0/X:Y (assuming single card/slot 0)
                $rawIface = $m[1];
                $status = strtolower($m[2]);
                
                if (preg_match('/^\d+\/\d+\/(\d+):(\d+)$/', $rawIface, $im)) {
                    $pon = $im[1];
                    $onu = $im[2];
                    $key = "0/{$pon}:{$onu}";
                    $statuses[$key] = $status;
                }
            }
        }
        
        return $statuses;
    }

    /**
     * Parses output of 'show onu 1-128 optical_info'
     */
    public static function parseOpticalInfo(string $output): array
    {
        $results = [];
        $chunks = preg_split('/ONU ID:\s*(\d+)/i', $output, -1, PREG_SPLIT_DELIM_CAPTURE | PREG_SPLIT_NO_EMPTY);
        
        for ($i = 0; $i < count($chunks); $i++) {
            if (is_numeric(trim($chunks[$i]))) {
                $id = (int)trim($chunks[$i]);
                $content = $chunks[$i+1] ?? '';
                $i++; 
                
                $data = [];
                if (preg_match('/Rx optical level:\s+([-\d\.]+)/i', $content, $m)) $data['rx_power'] = (float)$m[1];
                if (preg_match('/Tx optical level:\s+([-\d\.]+)/i', $content, $m)) $data['tx_power'] = (float)$m[1];
                if (preg_match('/Power feed voltage:\s+([-\d\.]+)/i', $content, $m)) $data['voltage'] = (float)$m[1];
                if (preg_match('/Laser bias current:\s+([-\d\.]+)/i', $content, $m)) $data['bias_current'] = (float)$m[1];
                if (preg_match('/Temperature:\s+([-\d\.]+)/i', $content, $m)) $data['temperature'] = (float)$m[1];
                
                if (!empty($data)) $results[$id] = $data;
            }
        }
        return $results;
    }

    /**
     * Parses output of 'show onu 1-128 distance'
     * Note: VSOL OLTs report distance in decimeters (0.1m), so we convert to meters
     */
    public static function parseDistance(string $output): array
    {
        $results = [];
        if (preg_match_all('/onu\s+(\d+)\s+Distance:\s+(\d+)m/i', $output, $matches, PREG_SET_ORDER)) {
            foreach ($matches as $m) {
                // Convert decimeters to meters
                $results[(int)$m[1]] = (int)$m[2] / 10;
            }
        }
        return $results;
    }
}
