#!/bin/bash

# SNMP Trap Handler Script
# This script receives SNMP trap data from snmptrapd and forwards it to Laravel API

# Read trap data from stdin
TRAP_DATA=$(cat)

# Laravel API endpoint (using app container name)
API_URL="http://app:9000/api/webhooks/olt-trap"

# Send trap data to Laravel API
curl -X POST "$API_URL" \
  -H "Content-Type: application/json" \
  -H "X-Trap-Source: snmptrapd" \
  -d "{\"trap_data\": \"$TRAP_DATA\", \"received_at\": \"$(date -Iseconds)\"}" \
  --max-time 5 \
  --silent \
  --show-error

# Log to stdout for debugging
echo "[$(date)] Trap forwarded to API: $API_URL"
