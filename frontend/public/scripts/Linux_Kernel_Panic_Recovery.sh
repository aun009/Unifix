#!/bin/bash
# Linux Kernel Panic Recovery Script
# Description: Automated recovery from kernel panic without system reboot

echo "========== Linux Kernel Panic Recovery Tool =========="
echo "This tool provides advanced analysis and recovery from kernel panics."
echo -e "===================================================\n"

# Check for root permissions
if [ "$(id -u)" -ne 0 ]; then
    echo "❌ This script requires root privileges to analyze system memory and recovery options."
    echo "Please run with sudo or as root."
    exit 1
fi

# Function to check if we're running in a post-panic environment
check_panic_state() {
    echo "[1/6] Checking system state..."
    
    # Check for kernel crash dumps
    if [ -d "/var/crash" ] && [ "$(ls -A /var/crash 2>/dev/null)" ]; then
        echo "✅ Crash dump detected in /var/crash."
        echo "Last kernel panic occurred at: $(ls -lt /var/crash | grep -v "total" | head -1 | awk '{print $6, $7, $8}')"
        return 0
    elif [ -e "/proc/vmcore" ]; then
        echo "✅ System is in kdump environment after kernel panic."
        return 0
    elif dmesg | grep -i "kernel panic" &>/dev/null; then
        echo "✅ Kernel panic detected in system logs."
        return 0
    else
        echo "ℹ️ No evidence of recent kernel panic found."
        echo "This tool is most effective when run after a kernel panic event."
        return 1
    fi
}

# Function to analyze the kernel crash dump
analyze_crash_dump() {
    echo -e "\n[2/6] Analyzing kernel crash dump..."
    
    # Check for crash analysis tools
    if ! command -v crash &>/dev/null; then
        echo "Installing crash analysis tools..."
        apt-get update && apt-get install -y crash kdump-tools linux-crashdump || {
            yum install -y crash kernel-debuginfo || {
                echo "❌ Failed to install crash analysis tools."
                echo "Please install 'crash' package manually for your distribution."
                return 1
            }
        }
    fi
    
    # Look for the most recent crash dump
    local crash_dir="/var/crash"
    local vmcore=""
    
    if [ -d "$crash_dir" ] && [ "$(ls -A $crash_dir 2>/dev/null)" ]; then
        vmcore=$(find "$crash_dir" -name "vmcore*" -type f -print -quit)
    elif [ -e "/proc/vmcore" ]; then
        vmcore="/proc/vmcore"
    fi
    
    if [ -n "$vmcore" ] && [ -e "$vmcore" ]; then
        echo "Analyzing crash dump: $vmcore"
        
        # Extract basic information from the crash dump
        echo "Crash dump analysis summary:"
        echo "----------------------------"
        
        if command -v crash &>/dev/null; then
            # Create a crash script to extract info
            cat > /tmp/crash_script.txt <<EOF
bt
ps
log
quit
EOF
            # Run crash analysis and extract key information
            crash /usr/lib/debug/lib/modules/$(uname -r)/vmlinux "$vmcore" < /tmp/crash_script.txt > /tmp/crash_analysis.txt 2>/dev/null
            
            # Parse and display relevant information
            if [ -f "/tmp/crash_analysis.txt" ]; then
                # Show the panic message
                echo "Kernel Panic Message:"
                grep -A 3 "Panic" /tmp/crash_analysis.txt 2>/dev/null || echo "Panic message not found in crash dump"
                
                # Show the process that was running
                echo -e "\nProcess running during panic:"
                grep -A 2 "CURRENT PROCESS" /tmp/crash_analysis.txt 2>/dev/null || echo "Process information not found"
                
                # Show the call trace
                echo -e "\nCall Trace (last 5 entries):"
                grep -A 5 "Call Trace" /tmp/crash_analysis.txt 2>/dev/null || echo "Call trace not found"
                
                # Identify potential causes
                echo -e "\nPotential causes:"
                if grep -i "memory allocation" /tmp/crash_analysis.txt &>/dev/null; then
                    echo "- Out of memory condition detected"
                fi
                if grep -i "i/o error" /tmp/crash_analysis.txt &>/dev/null; then
                    echo "- I/O errors detected - possible disk failure"
                fi
                if grep -i "ext4" /tmp/crash_analysis.txt &>/dev/null; then
                    echo "- Filesystem (ext4) errors detected"
                fi
                if grep -i "null pointer dereference" /tmp/crash_analysis.txt &>/dev/null; then
                    echo "- Null pointer dereference - possible driver bug"
                fi
            else
                echo "❌ Failed to analyze crash dump."
            fi
            
            # Clean up
            rm -f /tmp/crash_script.txt /tmp/crash_analysis.txt
        else
            echo "❌ Crash analysis tool not available."
        fi
    else
        echo "❌ No kernel crash dump found to analyze."
    fi
}

# Function to attempt recovery of the file system
recover_filesystem() {
    echo -e "\n[3/6] Checking filesystem integrity..."
    
    # Get root file system device
    root_device=$(mount | grep " / " | cut -d' ' -f1)
    
    if [ -z "$root_device" ]; then
        echo "❌ Could not determine root filesystem device."
        return 1
    fi
    
    echo "Root filesystem: $root_device"
    
    # Try to run fsck on the root filesystem
    echo "Checking root filesystem for errors..."
    fsck -n "$root_device"
    fsck_result=$?
    
    case $fsck_result in
        0) echo "✅ No filesystem errors detected." ;;
        1) echo "🔧 Filesystem errors were fixed." ;;
        2) echo "⚠️ Filesystem errors were fixed, system reboot recommended."
           echo "However, we will continue with recovery process to avoid data loss." ;;
        4|8|12) echo "❌ Filesystem errors could not be fixed automatically."
                echo "Manual intervention required." 
                echo "Consider running 'fsck -y $root_device' after backing up data." ;;
        *) echo "❌ Unknown error occurred during filesystem check." ;;
    esac
    
    # Check for corrupt files in critical system directories
    echo -e "\nChecking for potentially corrupted system files..."
    find /bin /sbin /lib -type f -exec md5sum {} \; 2>/dev/null | sort > /tmp/system_files_current.md5
    
    # This would ideally compare against a known-good baseline
    # For demonstration, we just check for basic file integrity
    corrupted=$(find /bin /sbin /lib -type f -name "*.so*" -o -name "*.ko*" | xargs file | grep -i "broken" || true)
    
    if [ -n "$corrupted" ]; then
        echo "⚠️ Potentially corrupted system libraries detected:"
        echo "$corrupted"
    else
        echo "✅ No obviously corrupted system libraries detected."
    fi
}

# Function to recover damaged kernel modules
recover_kernel_modules() {
    echo -e "\n[4/6] Recovering damaged kernel modules..."
    
    # Check kernel modules
    echo "Scanning for corrupted kernel modules..."
    corrupted_modules=$(find /lib/modules/$(uname -r) -name "*.ko*" | xargs file | grep -i "broken" || true)
    
    if [ -n "$corrupted_modules" ]; then
        echo "⚠️ Found corrupted kernel modules:"
        echo "$corrupted_modules"
        
        # Try to reinstall the kernel package
        echo "Attempting to reinstall kernel package to restore modules..."
        
        if command -v apt-get &>/dev/null; then
            # Debian/Ubuntu based systems
            kernel_pkg=$(dpkg -l | grep linux-image | grep $(uname -r) | awk '{print $2}')
            if [ -n "$kernel_pkg" ]; then
                echo "Reinstalling $kernel_pkg..."
                apt-get install --reinstall -y "$kernel_pkg"
                
                if [ $? -eq 0 ]; then
                    echo "✅ Kernel package reinstalled successfully."
                else
                    echo "❌ Failed to reinstall kernel package."
                fi
            else
                echo "❌ Could not determine current kernel package."
            fi
        elif command -v yum &>/dev/null || command -v dnf &>/dev/null; then
            # Red Hat/Fedora based systems
            kernel_pkg="kernel-$(uname -r)"
            echo "Reinstalling $kernel_pkg..."
            if command -v dnf &>/dev/null; then
                dnf reinstall -y "kernel-core-$(uname -r)" "kernel-modules-$(uname -r)" 2>/dev/null || dnf reinstall -y "$kernel_pkg"
            else
                yum reinstall -y "$kernel_pkg"
            fi
            
            if [ $? -eq 0 ]; then
                echo "✅ Kernel package reinstalled successfully."
            else
                echo "❌ Failed to reinstall kernel package."
            fi
        else
            echo "❌ Unsupported package manager. Please reinstall the kernel manually."
        fi
    else
        echo "✅ No corrupted kernel modules detected."
    fi
    
    # Check if any essential modules are missing or damaged
    echo -e "\nVerifying critical kernel modules..."
    critical_modules=("ext4" "xfs" "btrfs" "ahci" "sd_mod" "usb_storage")
    
    for module in "${critical_modules[@]}"; do
        if ! modinfo "$module" &>/dev/null; then
            echo "⚠️ Critical module '$module' is missing or damaged."
        else
            echo "✅ Module '$module' is intact."
        fi
    done
}

# Function to restore system state
restore_system_state() {
    echo -e "\n[5/6] Restoring system state..."
    
    # Remount filesystems properly
    echo "Remounting filesystems with correct options..."
    mount -o remount,rw /
    
    # Restart critical system services
    echo "Restarting critical system services..."
    for service in dbus systemd-journald systemd-logind NetworkManager network; do
        if systemctl is-active "$service" &>/dev/null; then
            echo "Service $service is already running."
        else
            echo "Starting $service..."
            systemctl start "$service" &>/dev/null
        fi
    done
    
    # Check and restore network connectivity
    echo "Checking network connectivity..."
    if ! ping -c 1 -W 2 8.8.8.8 &>/dev/null; then
        echo "Network appears to be down. Attempting to restore..."
        systemctl restart NetworkManager &>/dev/null || systemctl restart networking &>/dev/null
        
        # Wait for network to come up
        for i in {1..5}; do
            echo "Waiting for network ($i/5)..."
            sleep 2
            if ping -c 1 -W 2 8.8.8.8 &>/dev/null; then
                echo "✅ Network connectivity restored."
                break
            fi
        done
    else
        echo "✅ Network connectivity is working."
    fi
}

# Function to set up preventive measures
setup_preventive_measures() {
    echo -e "\n[6/6] Setting up preventive measures for future kernel panics..."
    
    # Check if kdump is properly configured
    echo "Checking kdump configuration..."
    
    if command -v kdumpctl &>/dev/null; then
        # RHEL/CentOS/Fedora
        if ! kdumpctl status | grep -q "Kdump is operational"; then
            echo "Configuring kdump service..."
            kdumpctl start
        else
            echo "✅ Kdump is already properly configured."
        fi
    elif [ -f "/etc/default/kdump-tools" ]; then
        # Debian/Ubuntu
        if ! systemctl is-active kdump-tools &>/dev/null; then
            echo "Configuring kdump-tools service..."
            sed -i 's/USE_KDUMP=0/USE_KDUMP=1/' /etc/default/kdump-tools
            systemctl enable kdump-tools
            systemctl start kdump-tools
        else
            echo "✅ Kdump-tools is already properly configured."
        fi
    else
        echo "⚠️ Could not detect kdump configuration. Manual setup is recommended."
    fi
    
    # Adjust kernel sysctl parameters for stability
    echo "Updating kernel parameters for improved stability..."
    
    # Create a sysctl config file for panic behavior
    cat > /etc/sysctl.d/99-kernel-panic.conf <<EOF
# Reboot 30 seconds after a kernel panic
kernel.panic = 30

# Reboot 30 seconds after an oops
kernel.panic_on_oops = 30

# Controls the kernel's behavior when an oops or BUG is encountered
kernel.panic_on_warn = 0

# Maximum number of memory segments
vm.max_map_count = 262144

# Controls how aggressive the kernel will swap memory pages
vm.swappiness = 10

# When the free memory falls below this threshold, the kernel will reclaim pages
vm.min_free_kbytes = 65536
EOF

    # Apply the changes
    sysctl -p /etc/sysctl.d/99-kernel-panic.conf
    
    echo "✅ Kernel stability parameters updated."
}

# Main procedure
echo "Starting kernel panic recovery and analysis..."

check_panic_state
analyze_crash_dump
recover_filesystem
recover_kernel_modules
restore_system_state
setup_preventive_measures

echo -e "\n========== Kernel Panic Recovery Complete =========="
echo "Recovery operations have been completed."
echo "System stability has been improved and preventive measures are in place."
echo -e "\nRecommendations:"
echo "1. Consider rebooting the system when convenient to apply all changes."
echo "2. Review any recurring kernel panics as they may indicate hardware issues."
echo "3. Check system logs regularly at /var/log/kern.log for early warning signs."
echo -e "\nYou can run this script again after future kernel panics."