#!/bin/bash
# Security Scanner Script
# Description: Comprehensive system security scanning and vulnerability assessment

echo "========== Security Scanner =========="
echo "Starting security scan. This may take several minutes..."

echo -e "\n[1/7] Checking for rootkits..."
if command -v rkhunter &> /dev/null; then
    sudo rkhunter --check --skip-keypress
else
    echo "rkhunter not installed. To install: sudo apt install rkhunter"
fi

echo -e "\n[2/7] Checking for open ports..."
sudo netstat -tulpn

echo -e "\n[3/7] Checking for failed login attempts..."
sudo grep "Failed password" /var/log/auth.log | tail -n 10

echo -e "\n[4/7] Checking system update status..."
if command -v apt &> /dev/null; then
    sudo apt update -qq
    echo "Updates available:"
    apt list --upgradable
fi

echo -e "\n[5/7] Checking user accounts and privileges..."
echo "Users with login capability:"
grep -E "sh$" /etc/passwd

echo "Users with sudo privileges:"
grep -Po '^sudo.+:\K.*$' /etc/group

echo -e "\n[6/7] Checking SSH configuration..."
if [ -f /etc/ssh/sshd_config ]; then
    echo "SSH key login: $(grep -i "PubkeyAuthentication" /etc/ssh/sshd_config)"
    echo "Password authentication: $(grep -i "PasswordAuthentication" /etc/ssh/sshd_config)"
    echo "Root login: $(grep -i "PermitRootLogin" /etc/ssh/sshd_config)"
fi

echo -e "\n[7/7] Checking for unusual SUID binaries..."
find / -type f -perm -4000 -ls 2>/dev/null

echo -e "\n========== Security Scan Complete =========="
echo "Security suggestions:"
echo "1. Install and run rkhunter or ClamAV for malware detection."
echo "2. Keep your system updated regularly."
echo "3. Disable root SSH login and use key-based authentication."
echo "4. Review and minimize open network ports."
echo "5. Use a firewall like UFW or firewalld."
echo "6. Consider implementing intrusion detection with fail2ban."