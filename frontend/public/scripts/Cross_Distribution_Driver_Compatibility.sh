#!/bin/bash
# Cross-Distribution Driver Compatibility Script
# Description: Ensures driver compatibility across different Linux distributions

echo "========== Cross-Distribution Driver Compatibility Tool =========="
echo "This tool helps ensure hardware driver compatibility across Linux distributions."
echo -e "================================================================\n"

# Check for root permissions
if [ "$(id -u)" -ne 0 ]; then
    echo "❌ This script requires root privileges to manage drivers."
    echo "Please run with sudo or as root."
    exit 1
fi

# Function to detect the Linux distribution
detect_distribution() {
    echo "[1/7] Detecting Linux distribution..."
    
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO_NAME=$NAME
        DISTRO_VERSION=$VERSION_ID
        DISTRO_ID=$ID
        echo "✅ Detected: $DISTRO_NAME $DISTRO_VERSION ($ID)"
    elif [ -f /etc/lsb-release ]; then
        . /etc/lsb-release
        DISTRO_NAME=$DISTRIB_DESCRIPTION
        DISTRO_VERSION=$DISTRIB_RELEASE
        DISTRO_ID=$DISTRIB_ID
        echo "✅ Detected: $DISTRO_NAME $DISTRO_VERSION ($DISTRIB_ID)"
    elif [ -f /etc/redhat-release ]; then
        DISTRO_NAME=$(cat /etc/redhat-release)
        DISTRO_ID="rhel"
        echo "✅ Detected: $DISTRO_NAME"
    else
        echo "❌ Unable to determine distribution. Continuing with generic methods."
        DISTRO_NAME="Unknown"
        DISTRO_ID="unknown"
    fi
    
    # Detect kernel version
    KERNEL_VERSION=$(uname -r)
    echo "Kernel version: $KERNEL_VERSION"
    
    # Detect architecture
    ARCH=$(uname -m)
    echo "System architecture: $ARCH"
}

# Function to scan for hardware devices
scan_hardware() {
    echo -e "\n[2/7] Scanning hardware devices..."
    
    # Create temporary directory for scan results
    WORK_DIR=$(mktemp -d)
    echo "Working directory: $WORK_DIR"
    
    # Scan PCI devices
    echo "Scanning PCI devices..."
    lspci -vnn > "$WORK_DIR/pci_devices.txt"
    PCI_DEVICES=$(lspci | wc -l)
    echo "Found $PCI_DEVICES PCI device(s)"
    
    # Scan USB devices
    echo "Scanning USB devices..."
    lsusb > "$WORK_DIR/usb_devices.txt"
    USB_DEVICES=$(lsusb | wc -l)
    echo "Found $USB_DEVICES USB device(s)"
    
    # Create list of critical hardware that needs drivers
    echo "Identifying critical hardware components..."
    
    # 1. Network controllers
    echo "Network controllers:" > "$WORK_DIR/critical_hardware.txt"
    lspci | grep -i "network\|ethernet\|wireless" >> "$WORK_DIR/critical_hardware.txt"
    
    # 2. Graphics cards
    echo -e "\nGraphics controllers:" >> "$WORK_DIR/critical_hardware.txt"
    lspci | grep -i "vga\|3d\|display" >> "$WORK_DIR/critical_hardware.txt"
    
    # 3. Storage controllers
    echo -e "\nStorage controllers:" >> "$WORK_DIR/critical_hardware.txt"
    lspci | grep -i "raid\|storage\|sata\|scsi\|nvme" >> "$WORK_DIR/critical_hardware.txt"
    
    # 4. Audio devices
    echo -e "\nAudio controllers:" >> "$WORK_DIR/critical_hardware.txt"
    lspci | grep -i "audio\|sound" >> "$WORK_DIR/critical_hardware.txt"
    
    # Extract hardware IDs for driver matching
    grep -o -E '\[[0-9a-f]{4}:[0-9a-f]{4}\]' "$WORK_DIR/pci_devices.txt" | tr -d '[]' > "$WORK_DIR/hardware_ids.txt"
    
    echo "✅ Hardware scan complete."
    echo "Detailed hardware information saved to $WORK_DIR"
}

# Function to check currently loaded drivers
check_current_drivers() {
    echo -e "\n[3/7] Checking currently loaded drivers..."
    
    # List all loaded kernel modules
    lsmod > "$WORK_DIR/loaded_modules.txt"
    MODULE_COUNT=$(wc -l < "$WORK_DIR/loaded_modules.txt")
    echo "Currently loaded kernel modules: $((MODULE_COUNT - 1))"
    
    # Match drivers with hardware
    echo "Matching drivers with hardware devices..."
    echo -e "Device\t\t\t\tDriver" > "$WORK_DIR/device_driver_map.txt"
    
    while read -r device; do
        if [[ "$device" =~ ([0-9a-f]{4}):([0-9a-f]{4}) ]]; then
            vendor=${BASH_REMATCH[1]}
            device_id=${BASH_REMATCH[2]}
            
            # Try to find the driver for this device
            driver=$(lspci -vmmks *:${vendor}:${device_id}:* 2>/dev/null | grep "Driver:" | cut -f2)
            
            if [ -z "$driver" ]; then
                driver="No driver found"
            fi
            
            echo -e "${vendor}:${device_id}\t\t$driver" >> "$WORK_DIR/device_driver_map.txt"
        fi
    done < <(grep -o -E '[0-9a-f]{4}:[0-9a-f]{4}' "$WORK_DIR/pci_devices.txt")
    
    # Identify missing drivers
    grep -i "no driver found" "$WORK_DIR/device_driver_map.txt" > "$WORK_DIR/missing_drivers.txt"
    MISSING_COUNT=$(wc -l < "$WORK_DIR/missing_drivers.txt")
    
    if [ "$MISSING_COUNT" -gt 0 ]; then
        echo "⚠️ Found $MISSING_COUNT device(s) without drivers:"
        cat "$WORK_DIR/missing_drivers.txt"
    else
        echo "✅ All detected hardware devices have drivers loaded."
    fi
}

# Function to build driver compatibility database
build_driver_database() {
    echo -e "\n[4/7] Building driver compatibility database..."
    
    # Create a database of known drivers across distributions
    cat > "$WORK_DIR/driver_compatibility.json" <<EOF
{
  "network": {
    "intel": {
      "8086:1533": {
        "ubuntu": "e1000e",
        "fedora": "e1000e",
        "debian": "e1000e",
        "arch": "e1000e",
        "opensuse": "e1000e",
        "centos": "e1000e"
      },
      "8086:15be": {
        "ubuntu": "e1000e",
        "fedora": "e1000e",
        "debian": "e1000e",
        "arch": "e1000e",
        "opensuse": "e1000e",
        "centos": "e1000e"
      },
      "8086:2526": {
        "ubuntu": "iwlwifi",
        "fedora": "iwlwifi",
        "debian": "iwlwifi",
        "arch": "iwlwifi",
        "opensuse": "iwlwifi",
        "centos": "iwlwifi"
      }
    },
    "realtek": {
      "10ec:8168": {
        "ubuntu": "r8169",
        "fedora": "r8169",
        "debian": "r8169",
        "arch": "r8169",
        "opensuse": "r8169",
        "centos": "r8169"
      },
      "10ec:8169": {
        "ubuntu": "r8169",
        "fedora": "r8169",
        "debian": "r8169",
        "arch": "r8169",
        "opensuse": "r8169",
        "centos": "r8169"
      },
      "10ec:c821": {
        "ubuntu": "rtw88_8821ce",
        "fedora": "rtw88_8821ce",
        "debian": "rtw88_8821ce",
        "arch": "rtw88_8821ce",
        "opensuse": "rtw88_8821ce",
        "centos": "rtw88_8821ce"
      }
    },
    "broadcom": {
      "14e4:43b1": {
        "ubuntu": "bcma-pci-bridge",
        "fedora": "wl",
        "debian": "broadcom-sta-dkms",
        "arch": "broadcom-wl",
        "opensuse": "broadcom-wl",
        "centos": "wl"
      },
      "14e4:4727": {
        "ubuntu": "bcma-pci-bridge",
        "fedora": "wl",
        "debian": "broadcom-sta-dkms",
        "arch": "broadcom-wl",
        "opensuse": "broadcom-wl",
        "centos": "wl"
      }
    }
  },
  "graphics": {
    "nvidia": {
      "10de:1180": {
        "ubuntu": "nvidia-driver-470",
        "fedora": "akmod-nvidia",
        "debian": "nvidia-driver",
        "arch": "nvidia",
        "opensuse": "nvidia-compute",
        "centos": "nvidia-driver"
      },
      "10de:1c03": {
        "ubuntu": "nvidia-driver-470",
        "fedora": "akmod-nvidia",
        "debian": "nvidia-driver",
        "arch": "nvidia",
        "opensuse": "nvidia-compute",
        "centos": "nvidia-driver"
      }
    },
    "amd": {
      "1002:67df": {
        "ubuntu": "amdgpu",
        "fedora": "amdgpu",
        "debian": "amdgpu",
        "arch": "amdgpu",
        "opensuse": "amdgpu",
        "centos": "amdgpu"
      },
      "1002:731f": {
        "ubuntu": "amdgpu",
        "fedora": "amdgpu",
        "debian": "amdgpu",
        "arch": "amdgpu",
        "opensuse": "amdgpu",
        "centos": "amdgpu"
      }
    },
    "intel": {
      "8086:3e9b": {
        "ubuntu": "i915",
        "fedora": "i915",
        "debian": "i915",
        "arch": "i915",
        "opensuse": "i915",
        "centos": "i915"
      },
      "8086:9bc8": {
        "ubuntu": "i915",
        "fedora": "i915",
        "debian": "i915",
        "arch": "i915",
        "opensuse": "i915",
        "centos": "i915"
      }
    }
  },
  "storage": {
    "intel": {
      "8086:2822": {
        "ubuntu": "ahci",
        "fedora": "ahci",
        "debian": "ahci",
        "arch": "ahci",
        "opensuse": "ahci",
        "centos": "ahci"
      },
      "8086:282a": {
        "ubuntu": "ahci",
        "fedora": "ahci",
        "debian": "ahci",
        "arch": "ahci",
        "opensuse": "ahci",
        "centos": "ahci"
      }
    },
    "lsi": {
      "1000:0097": {
        "ubuntu": "mpt3sas",
        "fedora": "mpt3sas",
        "debian": "mpt3sas",
        "arch": "mpt3sas",
        "opensuse": "mpt3sas",
        "centos": "mpt3sas"
      }
    }
  },
  "audio": {
    "intel": {
      "8086:02c8": {
        "ubuntu": "snd_hda_intel",
        "fedora": "snd_hda_intel",
        "debian": "snd_hda_intel",
        "arch": "snd_hda_intel",
        "opensuse": "snd_hda_intel",
        "centos": "snd_hda_intel"
      }
    },
    "realtek": {
      "10ec:0255": {
        "ubuntu": "snd_hda_intel",
        "fedora": "snd_hda_intel",
        "debian": "snd_hda_intel",
        "arch": "snd_hda_intel",
        "opensuse": "snd_hda_intel",
        "centos": "snd_hda_intel"
      }
    }
  }
}
EOF
    
    echo "✅ Driver compatibility database created."
}

# Function to match and install missing drivers
install_missing_drivers() {
    echo -e "\n[5/7] Matching and installing missing drivers..."
    
    # Check if we have missing drivers to deal with
    if [ ! -s "$WORK_DIR/missing_drivers.txt" ]; then
        echo "✅ No missing drivers to install."
        return 0
    fi
    
    # For each missing driver, try to find it in our database
    while read -r line; do
        if [[ "$line" =~ ([0-9a-f]{4}:[0-9a-f]{4}) ]]; then
            hw_id=${BASH_REMATCH[1]}
            vendor_id=${hw_id%:*}
            device_id=${hw_id#*:}
            
            echo "Looking for driver for device $hw_id..."
            
            # Try to find the hardware in our database
            if grep -q "$hw_id" "$WORK_DIR/driver_compatibility.json"; then
                echo "Device found in compatibility database."
                
                # This is a simplified version - in a real script, you'd parse the JSON properly
                # For simplicity, we're just searching for the ID and checking patterns
                
                driver_candidates=()
                
                if grep -q "nvidia" "$WORK_DIR/driver_compatibility.json" && [[ "$vendor_id" == "10de" ]]; then
                    driver_candidates+=("nvidia" "nouveau")
                    
                    if [[ "$DISTRO_ID" == "ubuntu" || "$DISTRO_ID" == "debian" ]]; then
                        echo "Installing NVIDIA drivers for $DISTRO_NAME..."
                        apt-get update
                        apt-get install -y nvidia-driver-470
                    elif [[ "$DISTRO_ID" == "fedora" ]]; then
                        echo "Installing NVIDIA drivers for $DISTRO_NAME..."
                        dnf install -y akmod-nvidia
                    elif [[ "$DISTRO_ID" == "centos" || "$DISTRO_ID" == "rhel" ]]; then
                        echo "Installing NVIDIA drivers for $DISTRO_NAME..."
                        dnf install -y nvidia-driver
                    elif [[ "$DISTRO_ID" == "arch" ]]; then
                        echo "Installing NVIDIA drivers for $DISTRO_NAME..."
                        pacman -S --noconfirm nvidia
                    elif [[ "$DISTRO_ID" == "opensuse" ]]; then
                        echo "Installing NVIDIA drivers for $DISTRO_NAME..."
                        zypper install -y nvidia-compute
                    else
                        echo "❌ Unsupported distribution for NVIDIA driver installation."
                    fi
                    
                elif grep -q "amd" "$WORK_DIR/driver_compatibility.json" && [[ "$vendor_id" == "1002" ]]; then
                    driver_candidates+=("amdgpu" "radeon")
                    
                    if [[ "$DISTRO_ID" == "ubuntu" || "$DISTRO_ID" == "debian" ]]; then
                        echo "Installing AMD GPU drivers for $DISTRO_NAME..."
                        apt-get update
                        apt-get install -y xserver-xorg-video-amdgpu
                    elif [[ "$DISTRO_ID" == "fedora" || "$DISTRO_ID" == "centos" || "$DISTRO_ID" == "rhel" ]]; then
                        echo "Installing AMD GPU drivers for $DISTRO_NAME..."
                        dnf install -y xorg-x11-drv-amdgpu
                    elif [[ "$DISTRO_ID" == "arch" ]]; then
                        echo "Installing AMD GPU drivers for $DISTRO_NAME..."
                        pacman -S --noconfirm xf86-video-amdgpu
                    elif [[ "$DISTRO_ID" == "opensuse" ]]; then
                        echo "Installing AMD GPU drivers for $DISTRO_NAME..."
                        zypper install -y xf86-video-amdgpu
                    else
                        echo "❌ Unsupported distribution for AMD driver installation."
                    fi
                    
                elif grep -q "intel.*e1000e" "$WORK_DIR/driver_compatibility.json" && [[ "$vendor_id" == "8086" ]] && grep -q "Network controller" "$WORK_DIR/critical_hardware.txt"; then
                    driver_candidates+=("e1000e" "igb")
                    
                    if [[ "$DISTRO_ID" == "ubuntu" || "$DISTRO_ID" == "debian" ]]; then
                        echo "Installing Intel network drivers for $DISTRO_NAME..."
                        apt-get update
                        apt-get install -y linux-modules-extra-$(uname -r)
                    elif [[ "$DISTRO_ID" == "fedora" || "$DISTRO_ID" == "centos" || "$DISTRO_ID" == "rhel" ]]; then
                        echo "Intel network driver should be included in the kernel."
                    else
                        echo "Intel network driver should be included in the kernel."
                    fi
                    
                elif grep -q "realtek.*r8" "$WORK_DIR/driver_compatibility.json" && [[ "$vendor_id" == "10ec" ]]; then
                    driver_candidates+=("r8169" "r8168")
                    
                    if [[ "$DISTRO_ID" == "ubuntu" || "$DISTRO_ID" == "debian" ]]; then
                        echo "Installing Realtek network drivers for $DISTRO_NAME..."
                        apt-get update
                        apt-get install -y linux-modules-extra-$(uname -r)
                    elif [[ "$DISTRO_ID" == "fedora" ]]; then
                        echo "Installing Realtek network drivers for $DISTRO_NAME..."
                        dnf install -y kmod-r8168
                    elif [[ "$DISTRO_ID" == "centos" || "$DISTRO_ID" == "rhel" ]]; then
                        echo "Installing Realtek network drivers for $DISTRO_NAME..."
                        dnf install -y kmod-r8168
                    elif [[ "$DISTRO_ID" == "arch" ]]; then
                        echo "Installing Realtek network drivers for $DISTRO_NAME..."
                        pacman -S --noconfirm r8168
                    else
                        echo "Realtek network driver should be included in the kernel."
                    fi
                    
                elif grep -q "broadcom" "$WORK_DIR/driver_compatibility.json" && [[ "$vendor_id" == "14e4" ]]; then
                    driver_candidates+=("wl" "brcmfmac" "brcmsmac")
                    
                    if [[ "$DISTRO_ID" == "ubuntu" || "$DISTRO_ID" == "debian" ]]; then
                        echo "Installing Broadcom drivers for $DISTRO_NAME..."
                        apt-get update
                        apt-get install -y broadcom-sta-dkms
                    elif [[ "$DISTRO_ID" == "fedora" ]]; then
                        echo "Installing Broadcom drivers for $DISTRO_NAME..."
                        dnf install -y broadcom-wl
                    elif [[ "$DISTRO_ID" == "centos" || "$DISTRO_ID" == "rhel" ]]; then
                        echo "Installing Broadcom drivers for $DISTRO_NAME..."
                        dnf install -y kmod-wl
                    elif [[ "$DISTRO_ID" == "arch" ]]; then
                        echo "Installing Broadcom drivers for $DISTRO_NAME..."
                        pacman -S --noconfirm broadcom-wl-dkms
                    else
                        echo "❌ Unsupported distribution for Broadcom driver installation."
                    fi
                    
                else
                    echo "⚠️ No specific match found for device $hw_id in our database."
                fi
                
            else
                echo "⚠️ Device $hw_id not found in compatibility database."
                
                # Generic approach based on the vendor ID
                case $vendor_id in
                    "10de") # NVIDIA
                        echo "Detected NVIDIA device. Installing generic NVIDIA drivers..."
                        install_generic_driver "nvidia"
                        ;;
                    "1002") # AMD
                        echo "Detected AMD device. Installing generic AMD drivers..."
                        install_generic_driver "amd"
                        ;;
                    "8086") # Intel
                        echo "Detected Intel device. Installing generic Intel drivers..."
                        install_generic_driver "intel"
                        ;;
                    "10ec") # Realtek
                        echo "Detected Realtek device. Installing generic Realtek drivers..."
                        install_generic_driver "realtek"
                        ;;
                    "14e4") # Broadcom
                        echo "Detected Broadcom device. Installing generic Broadcom drivers..."
                        install_generic_driver "broadcom"
                        ;;
                    *)
                        echo "❌ Unknown vendor ID: $vendor_id. Cannot determine appropriate driver."
                        ;;
                esac
            fi
        fi
    done < "$WORK_DIR/missing_drivers.txt"
    
    echo "✅ Driver installation attempts completed."
}

# Function to install generic drivers based on vendor
install_generic_driver() {
    vendor=$1
    
    case $vendor in
        "nvidia")
            if [[ "$DISTRO_ID" == "ubuntu" || "$DISTRO_ID" == "debian" ]]; then
                apt-get update
                apt-get install -y nvidia-driver-470
            elif [[ "$DISTRO_ID" == "fedora" ]]; then
                dnf install -y akmod-nvidia
            elif [[ "$DISTRO_ID" == "centos" || "$DISTRO_ID" == "rhel" ]]; then
                dnf install -y nvidia-driver
            elif [[ "$DISTRO_ID" == "arch" ]]; then
                pacman -S --noconfirm nvidia
            elif [[ "$DISTRO_ID" == "opensuse" ]]; then
                zypper install -y nvidia-compute
            else
                echo "❌ Unsupported distribution for NVIDIA driver installation."
            fi
            ;;
            
        "amd")
            if [[ "$DISTRO_ID" == "ubuntu" || "$DISTRO_ID" == "debian" ]]; then
                apt-get update
                apt-get install -y xserver-xorg-video-amdgpu
            elif [[ "$DISTRO_ID" == "fedora" || "$DISTRO_ID" == "centos" || "$DISTRO_ID" == "rhel" ]]; then
                dnf install -y xorg-x11-drv-amdgpu
            elif [[ "$DISTRO_ID" == "arch" ]]; then
                pacman -S --noconfirm xf86-video-amdgpu
            elif [[ "$DISTRO_ID" == "opensuse" ]]; then
                zypper install -y xf86-video-amdgpu
            else
                echo "❌ Unsupported distribution for AMD driver installation."
            fi
            ;;
            
        "intel")
            if [[ "$DISTRO_ID" == "ubuntu" || "$DISTRO_ID" == "debian" ]]; then
                apt-get update
                apt-get install -y intel-microcode
            elif [[ "$DISTRO_ID" == "fedora" || "$DISTRO_ID" == "centos" || "$DISTRO_ID" == "rhel" ]]; then
                dnf install -y intel-microcode
            elif [[ "$DISTRO_ID" == "arch" ]]; then
                pacman -S --noconfirm intel-ucode
            elif [[ "$DISTRO_ID" == "opensuse" ]]; then
                zypper install -y intel-microcode
            else
                echo "❌ Unsupported distribution for Intel driver installation."
            fi
            ;;
            
        "realtek")
            if [[ "$DISTRO_ID" == "ubuntu" || "$DISTRO_ID" == "debian" ]]; then
                apt-get update
                apt-get install -y linux-modules-extra-$(uname -r)
            elif [[ "$DISTRO_ID" == "fedora" ]]; then
                dnf install -y kmod-r8168
            elif [[ "$DISTRO_ID" == "centos" || "$DISTRO_ID" == "rhel" ]]; then
                dnf install -y kmod-r8168
            elif [[ "$DISTRO_ID" == "arch" ]]; then
                pacman -S --noconfirm r8168
            else
                echo "Realtek drivers should be included in the kernel."
            fi
            ;;
            
        "broadcom")
            if [[ "$DISTRO_ID" == "ubuntu" || "$DISTRO_ID" == "debian" ]]; then
                apt-get update
                apt-get install -y broadcom-sta-dkms
            elif [[ "$DISTRO_ID" == "fedora" ]]; then
                dnf install -y broadcom-wl
            elif [[ "$DISTRO_ID" == "centos" || "$DISTRO_ID" == "rhel" ]]; then
                dnf install -y kmod-wl
            elif [[ "$DISTRO_ID" == "arch" ]]; then
                pacman -S --noconfirm broadcom-wl-dkms
            else
                echo "❌ Unsupported distribution for Broadcom driver installation."
            fi
            ;;
            
        *)
            echo "❌ Unknown vendor: $vendor"
            ;;
    esac
}

# Function to create universal driver loader
create_universal_driver_loader() {
    echo -e "\n[6/7] Creating universal driver loader..."
    
    # Create directory for universal driver loader
    mkdir -p /usr/local/bin/unidriver
    
    # Create the universal driver loader script
    cat > /usr/local/bin/unidriver/universal_driver_loader.sh <<'EOF'
#!/bin/bash
# Universal Driver Loader
# This script attempts to load appropriate drivers for hardware
# regardless of Linux distribution

function log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> /var/log/unidriver.log
}

function find_and_load_driver() {
    local device_id=$1
    local vendor_id=${device_id%%:*}
    local product_id=${device_id##*:}
    
    log "Finding driver for device $device_id (vendor: $vendor_id, product: $product_id)"
    
    # Check if the device already has a driver
    if lspci -k -s "$device_id" 2>/dev/null | grep -q "Kernel driver in use"; then
        driver=$(lspci -k -s "$device_id" | grep "Kernel driver in use" | cut -d ":" -f2 | tr -d " ")
        log "Device $device_id already uses driver: $driver"
        return 0
    fi
    
    # Try to find an appropriate driver
    case $vendor_id in
        # NVIDIA
        "10de")
            log "NVIDIA device detected"
            if modprobe nvidia_drm 2>/dev/null; then
                log "Loaded NVIDIA proprietary driver"
            elif modprobe nouveau 2>/dev/null; then
                log "Loaded Nouveau driver (open source NVIDIA driver)"
            else
                log "Failed to load any NVIDIA driver"
            fi
            ;;
        
        # AMD
        "1002")
            log "AMD device detected"
            if modprobe amdgpu 2>/dev/null; then
                log "Loaded AMDGPU driver"
            elif modprobe radeon 2>/dev/null; then
                log "Loaded Radeon driver"
            else
                log "Failed to load any AMD driver"
            fi
            ;;
        
        # Intel
        "8086")
            log "Intel device detected"
            if lspci -k -s "$device_id" | grep -q "VGA compatible controller"; then
                # Intel graphics
                modprobe i915 2>/dev/null && log "Loaded Intel graphics driver (i915)"
            elif lspci -k -s "$device_id" | grep -q "Network controller"; then
                # Intel networking
                if modprobe iwlwifi 2>/dev/null; then
                    log "Loaded Intel wireless driver (iwlwifi)"
                elif modprobe e1000e 2>/dev/null; then
                    log "Loaded Intel ethernet driver (e1000e)"
                elif modprobe igb 2>/dev/null; then
                    log "Loaded Intel ethernet driver (igb)"
                else
                    log "Failed to load any Intel network driver"
                fi
            elif lspci -k -s "$device_id" | grep -q "Audio device"; then
                # Intel audio
                modprobe snd_hda_intel 2>/dev/null && log "Loaded Intel audio driver (snd_hda_intel)"
            else
                log "Unknown Intel device type"
            fi
            ;;
        
        # Realtek
        "10ec")
            log "Realtek device detected"
            if lspci -k -s "$device_id" | grep -q "Network controller" || lspci -k -s "$device_id" | grep -q "Ethernet controller"; then
                # Realtek networking
                if modprobe r8169 2>/dev/null; then
                    log "Loaded Realtek network driver (r8169)"
                elif modprobe r8168 2>/dev/null; then
                    log "Loaded Realtek network driver (r8168)"
                elif modprobe rtl8xxxu 2>/dev/null; then
                    log "Loaded Realtek wireless driver (rtl8xxxu)"
                else
                    log "Failed to load any Realtek driver"
                fi
            elif lspci -k -s "$device_id" | grep -q "Audio device"; then
                # Realtek audio
                modprobe snd_hda_intel 2>/dev/null && log "Loaded Audio driver (snd_hda_intel)"
            else
                log "Unknown Realtek device type"
            fi
            ;;
        
        # Broadcom
        "14e4")
            log "Broadcom device detected"
            if lspci -k -s "$device_id" | grep -q "Network controller"; then
                # Broadcom networking
                if modprobe wl 2>/dev/null; then
                    log "Loaded Broadcom wireless driver (wl)"
                elif modprobe brcmfmac 2>/dev/null; then
                    log "Loaded Broadcom wireless driver (brcmfmac)"
                elif modprobe brcmsmac 2>/dev/null; then
                    log "Loaded Broadcom wireless driver (brcmsmac)"
                else
                    log "Failed to load any Broadcom wireless driver"
                fi
            else
                log "Unknown Broadcom device type"
            fi
            ;;
            
        *)
            log "Unknown vendor ID: $vendor_id"
            ;;
    esac
}

log "Starting universal driver loader"

# Scan for all PCI devices
for device in $(lspci | cut -d' ' -f1); do
    find_and_load_driver "$device"
done

log "Universal driver loader completed"
EOF

    # Make the script executable
    chmod +x /usr/local/bin/unidriver/universal_driver_loader.sh
    
    # Create systemd service
    cat > /etc/systemd/system/universal-driver-loader.service <<EOF
[Unit]
Description=Universal Driver Loader
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/unidriver/universal_driver_loader.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

    # Enable and start the service
    systemctl daemon-reload
    systemctl enable universal-driver-loader.service
    systemctl start universal-driver-loader.service
    
    echo "✅ Universal driver loader has been installed and configured."
}

# Function to verify and test installed drivers
verify_drivers() {
    echo -e "\n[7/7] Verifying installed drivers..."
    
    # Re-scan loaded modules
    echo "Checking newly loaded kernel modules..."
    lsmod > "$WORK_DIR/loaded_modules_after.txt"
    
    # Check for differences
    echo "Comparing before and after driver states..."
    diff "$WORK_DIR/loaded_modules.txt" "$WORK_DIR/loaded_modules_after.txt" > "$WORK_DIR/module_changes.txt"
    
    if [ -s "$WORK_DIR/module_changes.txt" ]; then
        echo "New drivers loaded:"
        grep ">" "$WORK_DIR/module_changes.txt" | cut -c 3-
    else
        echo "No new drivers were loaded."
    fi
    
    # Check for remaining missing drivers
    echo -e "\nVerifying if all hardware now has drivers..."
    
    missing_after=0
    while read -r device; do
        if [[ "$device" =~ ([0-9a-f]{4}):([0-9a-f]{4}) ]]; then
            vendor=${BASH_REMATCH[1]}
            device_id=${BASH_REMATCH[2]}
            
            driver=$(lspci -vmmks *:${vendor}:${device_id}:* 2>/dev/null | grep "Driver:" | cut -f2)
            
            if [ -z "$driver" ]; then
                echo "⚠️ Device ${vendor}:${device_id} still has no driver."
                missing_after=$((missing_after + 1))
            fi
        fi
    done < <(grep -o -E '[0-9a-f]{4}:[0-9a-f]{4}' "$WORK_DIR/pci_devices.txt")
    
    if [ "$missing_after" -eq 0 ]; then
        echo "✅ All hardware devices now have drivers."
    else
        echo "⚠️ $missing_after device(s) still missing drivers."
        echo "Some hardware may require proprietary drivers or specific distribution packages."
        echo "Check the output above for specific device IDs."
    fi
    
    # Perform basic hardware tests
    echo -e "\nPerforming basic hardware functionality tests..."
    
    # Test network connectivity
    echo "Testing network connectivity..."
    if ping -c 1 -W 2 8.8.8.8 &>/dev/null; then
        echo "✅ Network connectivity: OK"
    else
        echo "⚠️ Network connectivity: Failed"
    fi
    
    # Test graphics subsystem (very basic)
    echo "Testing graphics subsystem..."
    if command -v glxinfo &>/dev/null; then
        if glxinfo | grep -q "direct rendering: Yes"; then
            echo "✅ Graphics (GLX): OK - Direct rendering enabled"
        else
            echo "⚠️ Graphics (GLX): Limited - No direct rendering"
        fi
    else
        echo "⚠️ Graphics: Cannot test (glxinfo not installed)"
    fi
    
    # Test audio (very basic)
    echo "Testing audio subsystem..."
    if command -v aplay &>/dev/null && [ -e /dev/snd ]; then
        echo "✅ Audio subsystem: Available"
    else
        echo "⚠️ Audio subsystem: May not be available"
    fi
}

# Main function
main() {
    echo "Starting Cross-Distribution Driver Compatibility Tool..."
    
    detect_distribution
    scan_hardware
    check_current_drivers
    build_driver_database
    install_missing_drivers
    create_universal_driver_loader
    verify_drivers
    
    echo -e "\n========== Driver Compatibility Tool Complete =========="
    echo "Summary of actions:"
    echo "1. Detected distribution: $DISTRO_NAME $DISTRO_VERSION"
    echo "2. Scanned hardware and identified critical components"
    echo "3. Checked currently loaded drivers"
    echo "4. Built cross-distribution driver compatibility database"
    echo "5. Attempted to install missing drivers"
    echo "6. Created universal driver loader"
    echo "7. Verified driver functionality"
    
    echo -e "\nAll diagnostic information is saved in: $WORK_DIR"
    echo -e "\nRecommendations:"
    echo "1. Reboot the system to fully activate all drivers"
    echo "2. If hardware issues persist, check specific device support for your distribution"
    echo "3. For proprietary graphics drivers, additional configuration may be required"
    echo "4. The universal driver loader service will help maintain driver compatibility"
}

# Execute the main function
main