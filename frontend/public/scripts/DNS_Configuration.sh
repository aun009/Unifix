#!/bin/bash
# filepath: frontend/public/scripts/DNS_Configuration.sh

echo "DNS configuration..."

cat /etc/resolv.conf
echo "To change DNS, edit /etc/resolv.conf or use 'nmcli' for NetworkManager."