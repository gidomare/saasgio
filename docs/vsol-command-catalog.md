# VSOL V1600G-1B Command Catalog & Reference

## Overview
Complete command reference for VSOL V1600G-1B OLT with ready-to-use PHP functions in `OltService`.

## Important Note
⚠️ **VSOL CLI requires interactive session** - Commands cannot be executed via SSH `exec()`. All `OltService` methods return command references for manual execution or future expect-based automation.

## Available OltService Methods

### Connection & Status
```php
$service = new OltService($olt);

// Test SSH connection
$result = $service->testConnection();
// Returns: ['success' => true/false, 'message' => '...']

// Get OLT info
$info = $service->getOltInfo();
// Returns: connection_status, ip_address, model, pon_type, last_check
```

### Command Reference
```php
// Get all commands organized by category
$commands = $service->getCommandReference();
```

**Categories:**
- `system_info`: version, system, cpu, memory, temperature, running_config
- `profiles`: onu_profiles, line_profiles, service_profiles, dba_profiles
- `pon_ports`: gpon_status, olt_ports, all_onus, unconfigured_onus, onu_state
- `onu_management`: onu_config, onu_mac, optical_info
- `vlan`: vlan_list, vlan_brief, vlan_detail
- `interfaces`: all_interfaces, interface_brief, interface_status, ip_interfaces
- `snmp`: snmp_status, snmp_community, snmp_hosts
- `diagnostics`: logs, alarms

### ONU Management
```php
// Get ONUs from specific PON port
$onus = $service->getOnusFromPort('1/1/1');
// Returns: manual command steps

// Get unconfigured ONUs (auto-discovery)
$uncfg = $service->getUnconfiguredOnus();
// Returns: command "show gpon onu uncfg"

// Provision new ONU
$result = $service->provisionOnu([
    'port' => '1/1/1',
    'onu_id' => 1,
    'serial' => 'FHTT12345678',
    'type' => 'default',
    'name' => 'Cliente-001',
    'dba_profile' => 'default',
    'vlan' => 100,
]);
// Returns: array of commands to execute manually

// Delete ONU
$result = $service->deleteOnu('1/1/1', 1);

// Get ONU optical info
$info = $service->getOnuOpticalInfo('1/1/1', 1);

// Reboot ONU
$result = $service->rebootOnu('1/1/1', 1);
```

### VLAN Management
```php
// Get all VLANs
$vlans = $service->getVlans();

// Create VLAN
$result = $service->createVlan(100, 'Internet');
```

### SNMP Configuration
```php
// Get SNMP configuration commands
$result = $service->configureSnmp('10.150.1.4');
// Returns: manual_commands array

// Or use async job (recommended)
ConfigureOltSnmpJob::dispatch($olt, '10.150.1.4');
```

## Command Syntax Reference

### System Information
```bash
show version              # OLT software version
show system               # System status
show cpu                  # CPU usage
show memory               # Memory usage
show temperature          # Temperature sensors
show running-config       # Current configuration
```

### Profile Management
```bash
show onu profile          # ONU profiles list
show line-profile         # Line profiles
show service-profile      # Service profiles
show traffic-table        # DBA/Traffic profiles
```

### PON/GPON Operations
```bash
show gpon                 # GPON general status
show gpon olt             # OLT ports status
show gpon onu             # All ONUs
show gpon onu uncfg       # Unconfigured ONUs (auto-discovery)
show gpon onu state       # ONU states
show gpon onu state gpon-olt_1/1/1  # ONUs on specific port
```

### ONU Configuration
```bash
# View ONU config
show onu running config gpon-onu_1/1/1:1

# Provision ONU
configure terminal
interface gpon-olt_1/1/1
onu 1 type default sn FHTT12345678
exit
interface gpon-onu_1/1/1:1
name Cliente-001
sn-bind enable sn
tcont 1 profile default
gemport 1 tcont 1
switchport mode hybrid vport 1
service-port 1 vport 1 user-vlan 100 vlan 100
exit
write

# Delete ONU
configure terminal
interface gpon-olt_1/1/1
no onu 1
exit
write

# Reboot ONU
enable
onu reboot gpon-onu_1/1/1:1
```

### VLAN Management
```bash
show vlan                 # All VLANs
show vlan brief           # VLAN summary
show vlan id 100          # Specific VLAN

# Create VLAN
configure terminal
vlan 100
name Internet
exit
write
```

### Interface Management
```bash
show interface            # All interfaces
show interface brief      # Interface summary
show interface status     # Interface status
show ip interface brief   # IP interfaces
```

### SNMP Configuration
```bash
show snmp                 # SNMP status
show snmp community       # Community strings
show snmp host            # Trap hosts

# Configure SNMP
enable
configure terminal
snmp enable
snmp community ro public
snmp community rw private
snmp host 10.150.1.4 version 2c community public
write
```

### Diagnostics
```bash
show log                  # System logs
show alarm                # Active alarms
show optical-module-info gpon-olt_1/1/1  # Optical power info
show optical-module-info gpon-onu_1/1/1:1  # ONU optical info
```

## ONU Provisioning Workflow

### 1. Discover Unconfigured ONU
```bash
enable
show gpon onu uncfg
```
Output will show: Port, SN, Password, Loid, State

### 2. Provision ONU
```bash
configure terminal
interface gpon-olt_1/1/1
onu 1 type default sn FHTT12345678
exit
```

### 3. Configure ONU Services
```bash
interface gpon-onu_1/1/1:1
name Cliente-001
sn-bind enable sn
tcont 1 profile default
gemport 1 tcont 1
switchport mode hybrid vport 1
service-port 1 vport 1 user-vlan 100 vlan 100
exit
write
```

### 4. Verify
```bash
show gpon onu state gpon-olt_1/1/1
show optical-module-info gpon-onu_1/1/1:1
```

## Port Naming Convention
- **OLT Port**: `gpon-olt_1/1/1` (chassis/slot/port)
- **ONU**: `gpon-onu_1/1/1:1` (chassis/slot/port:onu_id)

## Common Tasks

### Check ONU Status
```bash
show gpon onu state gpon-olt_1/1/1
```

### Check ONU Signal
```bash
show optical-module-info gpon-onu_1/1/1:1
```

### Find Unconfigured ONUs
```bash
show gpon onu uncfg
```

### Reboot ONU
```bash
onu reboot gpon-onu_1/1/1:1
```

### Delete ONU
```bash
configure terminal
interface gpon-olt_1/1/1
no onu 1
exit
write
```

## Integration with Laravel

All methods in `OltService` return structured arrays with:
- `success`: boolean
- `note`: explanation
- `command` or `commands`: CLI commands to execute
- `manual_steps`: step-by-step instructions

Example usage:
```php
$service = new OltService($olt);
$result = $service->provisionOnu([...]);

if (!$result['success']) {
    // Show manual steps to user
    foreach ($result['manual_steps'] as $step) {
        echo $step . "\n";
    }
}
```

## Future Enhancements
- [ ] Expect-based automation for interactive CLI
- [ ] AdminOLT API integration
- [ ] NETCONF/RESTCONF support
- [ ] Web scraping OLT web interface
