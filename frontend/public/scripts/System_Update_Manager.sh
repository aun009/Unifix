#!/bin/bash
# System Update Manager Script
# Description: Comprehensive system update and package management

echo "========== System Update Manager =========="
echo "Starting system update process..."

# Detect package manager
if command -v apt &> /dev/null; then
    PKG_MANAGER="apt"
elif command -v dnf &> /dev/null; then
    PKG_MANAGER="dnf"
elif command -v yum &> /dev/null; then
    PKG_MANAGER="yum"
elif command -v pacman &> /dev/null; then
    PKG_MANAGER="pacman"
else
    PKG_MANAGER="unknown"
fi

echo "Detected package manager: $PKG_MANAGER"

# Update system based on the package manager
update_system() {
    echo -e "\n[1/5] Updating package lists..."
    
    case $PKG_MANAGER in
        apt)
            sudo apt update
            echo -e "\n[2/5] Checking for upgradable packages..."
            apt list --upgradable
            
            echo -e "\n[3/5] Upgrading packages..."
            sudo apt upgrade -y
            
            echo -e "\n[4/5] Performing distribution upgrade..."
            sudo apt dist-upgrade -y
            
            echo -e "\n[5/5] Removing unnecessary packages..."
            sudo apt autoremove -y
            ;;
            
        dnf)
            sudo dnf check-update
            echo -e "\n[2/5] Upgrading packages..."
            sudo dnf upgrade -y
            echo -e "\n[3/5] Cleaning up DNF cache..."
            sudo dnf clean all
            echo -e "\n[4/5] Checking for distribution upgrades..."
            if command -v dnf-automatic &> /dev/null; then
                sudo dnf-automatic
            else
                echo "dnf-automatic not installed, skipping automated checks"
            fi
            echo -e "\n[5/5] Update complete"
            ;;
            
        yum)
            sudo yum check-update
            echo -e "\n[2/5] Upgrading packages..."
            sudo yum update -y
            echo -e "\n[3/5] Cleaning up YUM cache..."
            sudo yum clean all
            echo -e "\n[4/5] Update complete"
            echo -e "\n[5/5] No additional steps needed"
            ;;
            
        pacman)
            sudo pacman -Sy
            echo -e "\n[2/5] Upgrading packages..."
            sudo pacman -Syu --noconfirm
            echo -e "\n[3/5] Cleaning up package cache..."
            sudo pacman -Sc --noconfirm
            echo -e "\n[4/5] Update complete"
            echo -e "\n[5/5] No additional steps needed"
            ;;
            
        *)
            echo "Unsupported package manager. Please update your system manually."
            return 1
            ;;
    esac
    
    return 0
}

# Check for kernel updates
check_kernel() {
    echo -e "\nChecking current kernel version:"
    uname -r
    
    if [ "$PKG_MANAGER" = "apt" ]; then
        echo -e "\nAvailable kernel packages:"
        apt list --installed | grep linux-image
    elif [ "$PKG_MANAGER" = "dnf" ] || [ "$PKG_MANAGER" = "yum" ]; then
        echo -e "\nAvailable kernel packages:"
        rpm -q kernel
    elif [ "$PKG_MANAGER" = "pacman" ]; then
        echo -e "\nAvailable kernel packages:"
        pacman -Q linux
    fi
}

# Run update process
update_system
update_result=$?

if [ $update_result -eq 0 ]; then
    echo -e "\n========== Update Process Complete =========="
    check_kernel
    
    echo -e "\nSystem update summary:"
    echo "✅ Package repositories updated"
    echo "✅ System packages upgraded"
    if [ "$PKG_MANAGER" = "apt" ]; then
        echo "✅ Distribution packages upgraded"
        echo "✅ Unnecessary packages removed"
    elif [ "$PKG_MANAGER" = "dnf" ] || [ "$PKG_MANAGER" = "yum" ] || [ "$PKG_MANAGER" = "pacman" ]; then
        echo "✅ Package cache cleaned"
    fi
    
    echo -e "\nNext steps:"
    echo "1. Review any error messages above"
    echo "2. Restart your system if a kernel update was applied"
    echo "3. Run this script regularly to keep your system updated"
else
    echo -e "\n========== Update Process Failed =========="
    echo "Please check error messages above and try again."
fi