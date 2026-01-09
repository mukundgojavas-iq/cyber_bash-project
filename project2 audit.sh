#!/bin/bash

# ---- REQUIRE ROOT ----
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

echo "======================================"
echo " 🖥️  SYSTEM NETWORK & PORT AUDIT"
echo "======================================"
echo "Date: $(date)"
echo "Hostname: $(hostname)"
echo

# 1️ Network interfaces
echo "🔹 NETWORK INTERFACES"
echo "--------------------------------------"
ip -brief addr
echo

# 2️ Routing table
echo "🔹 ROUTING TABLE / GATEWAYS"
echo "--------------------------------------"
ip route
echo

# 3️ DNS configuration
echo "🔹 DNS CONFIGURATION"
echo "--------------------------------------"
cat /etc/resolv.conf
echo

# 4️ Listening ports & services
echo "🔹 OPEN PORTS & LISTENING SERVICES"
echo "--------------------------------------"
ss -tulnp
echo

# 5️ Active network connections
echo "🔹 ACTIVE NETWORK CONNECTIONS"
echo "--------------------------------------"
ss -tunp | grep ESTAB || echo "No active connections"
echo

# 6️ External connections (unique IPs)
echo "🔹 CONNECTED REMOTE IP ADDRESSES"
echo "--------------------------------------"
ss -tun | awk '{print $5}' | grep ':' | cut -d: -f1 | sort -u
echo

# 7️ Firewall status
echo "🔹 FIREWALL STATUS"
echo "--------------------------------------"
if command -v ufw >/dev/null 2>&1; then
    ufw status verbose
elif command -v firewall-cmd >/dev/null 2>&1; then
    firewall-cmd --list-all
else
    echo "No common firewall detected"
fi

echo
echo "======================================"
echo " ✅ NETWORK AUDIT COMPLETE"
echo "======================================"
