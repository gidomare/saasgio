# Configuración Manual de SNMP en OLT VSOL

## Problema
La configuración automática de SNMP via SSH no funciona de manera confiable debido a que la CLI de VSOL V1600G-1B requiere una sesión interactiva verdadera que no puede ser automatizada fácilmente con phpseclib.

## Solución: Configuración Manual

### Paso 1: Conectarse a la OLT via SSH

```bash
ssh admin@192.168.8.200
```

### Paso 2: Entrar en modo privilegiado

```
enable
# Ingresa la contraseña si se solicita
```

### Paso 3: Configurar SNMP

```
configure terminal
snmp enable
snmp community ro public
snmp community rw private
snmp host 10.150.1.4 version 2c community public
write
exit
exit
```

### Paso 4: Verificar Configuración

```
show snmp
```

## Qué hace esta configuración

- **snmp enable**: Habilita el servicio SNMP en la OLT
- **snmp community ro public**: Configura comunidad de solo lectura
- **snmp community rw private**: Configura comunidad de escritura
- **snmp host 10.150.1.4**: Configura el servidor que recibirá los traps SNMP
- **version 2c**: Usa SNMP versión 2c
- **write**: Guarda la configuración

## Sistema de Traps Funcionando

Una vez configurado, la OLT enviará automáticamente traps SNMP a `10.150.1.4:162` cuando ocurran eventos como:

- 🟢 **ONU Register**: Nueva ONU conectada
- 🔴 **ONU Deregister**: ONU desconectada  
- ⚠️ **ONU LOS**: Pérdida de señal

Estos eventos se capturarán automáticamente en:
- Contenedor: `wms-snmp` (escuchando UDP 162)
- API: `/api/webhooks/olt-trap`
- Base de datos: tabla `olt_events`

## Alternativas Futuras

1. **Expect Script**: Crear script con expect para automatizar la sesión interactiva
2. **AdminOLT API**: Si la OLT tiene AdminOLT instalado, usar su API
3. **NETCONF/RESTCONF**: Si la OLT soporta estos protocolos
