# Scripts Directory

This directory contains utility scripts for development, debugging, and OLT management.

## Directory Structure

### `/debug`
Development and debugging utilities:
- `analyze_vsol_status.php` - Analyze VSOL OLT status output
- `debug_keys.php` - Debug key normalization issues
- `debug_onu_parser.php` - Test ONU parser regex patterns
- `extract_onu_lines.php` - Extract ONU data from raw output

### `/setup`
One-time setup and configuration scripts:
- `build_vsol_catalog.php` - Build VSOL command catalog via discovery
- `configure_vsol_snmp.php` - Configure SNMP on VSOL OLT
- `step1_fix_snmp.php` - Fix SNMP configuration issues
- `step1_verify_ping.php` - Verify OLT network connectivity
- `step2_verify_snmp.php` - Verify SNMP connectivity

### `/discovery`
OLT command discovery utilities:
- `discover_console.php` - Discover console/terminal commands
- `vsol_smart_discovery.php` - Smart discovery of VSOL commands

## Usage

All scripts should be run from the project root:

```bash
# Example: Run debug script
docker exec wms-app php scripts/debug/analyze_vsol_status.php

# Example: Run setup script
docker exec wms-app php scripts/setup/configure_vsol_snmp.php
```

## Notes

- These scripts are for development/maintenance only
- They are not part of the production application
- Some scripts require OLT connectivity to function
- Always test in development environment first
