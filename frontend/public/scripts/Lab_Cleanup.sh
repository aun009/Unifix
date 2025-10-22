#!/bin/bash
# Lab Cleanup Script
# Description: Cleans up the lab environment

echo "========== Lab Cleanup Tool =========="
echo "This script will clean up your lab environment."
echo "WARNING: This will stop and remove Docker containers, virtual machines, and other lab resources."
echo -e "=======================================\n"

read -p "Are you sure you want to proceed? (y/n): " confirm

if [ "$confirm" != "y" ]; then
    echo "Operation cancelled."
    exit 0
fi

echo -e "\n[1/7] Cleaning up Docker resources..."
if command -v docker &> /dev/null; then
    echo "Stopping all Docker containers..."
    if [ "$(sudo docker ps -q)" ]; then
        sudo docker stop $(sudo docker ps -q)
        echo "✅ All Docker containers stopped."
    else
        echo "No running Docker containers found."
    fi
    
    read -p "Remove all Docker containers? (y/n): " remove_containers
    if [ "$remove_containers" == "y" ]; then
        if [ "$(sudo docker ps -a -q)" ]; then
            sudo docker rm $(sudo docker ps -a -q)
            echo "✅ All Docker containers removed."
        else
            echo "No Docker containers found."
        fi
    fi
    
    read -p "Remove unused Docker volumes? (y/n): " remove_volumes
    if [ "$remove_volumes" == "y" ]; then
        sudo docker volume prune -f
        echo "✅ Unused Docker volumes removed."
    fi
    
    read -p "Remove unused Docker networks? (y/n): " remove_networks
    if [ "$remove_networks" == "y" ]; then
        sudo docker network prune -f
        echo "✅ Unused Docker networks removed."
    fi
    
    read -p "Remove unused Docker images? (y/n): " remove_images
    if [ "$remove_images" == "y" ]; then
        sudo docker image prune -a -f
        echo "✅ Unused Docker images removed."
    fi
    
    read -p "Run full Docker system prune? (WARNING: This removes all unused data) (y/n): " full_prune
    if [ "$full_prune" == "y" ]; then
        sudo docker system prune -a -f --volumes
        echo "✅ Full Docker system prune completed."
    fi
else
    echo "Docker not installed. Skipping Docker cleanup."
fi

echo -e "\n[2/7] Cleaning up temporary files..."
read -p "Remove temporary files from /tmp? (y/n): " clean_tmp
if [ "$clean_tmp" == "y" ]; then
    sudo rm -rf /tmp/* 2>/dev/null
    echo "✅ Temporary files removed."
fi

echo -e "\n[3/7] Cleaning up log files..."
read -p "Clean up log files? (y/n): " clean_logs
if [ "$clean_logs" == "y" ]; then
    sudo find /var/log -type f -name "*.gz" -delete 2>/dev/null
    sudo find /var/log -type f -name "*.old" -delete 2>/dev/null
    sudo find /var/log -type f -name "*.1" -delete 2>/dev/null
    echo "✅ Old log files removed."
fi

echo -e "\n[4/7] Checking for Virtual Machines..."
if command -v virsh &> /dev/null; then
    echo "KVM/QEMU virtual machines found:"
    sudo virsh list --all
    
    read -p "Stop all running VMs? (y/n): " stop_vms
    if [ "$stop_vms" == "y" ]; then
        vm_ids=$(sudo virsh list --state-running --name)
        for vm in $vm_ids; do
            sudo virsh shutdown "$vm"
            echo "Shutting down VM: $vm"
        done
        echo "✅ VMs shutdown initiated."
    fi
elif command -v vboxmanage &> /dev/null; then
    echo "VirtualBox virtual machines found:"
    vboxmanage list vms
    
    read -p "Stop all running VirtualBox VMs? (y/n): " stop_vbox
    if [ "$stop_vbox" == "y" ]; then
        vm_list=$(vboxmanage list runningvms | awk '{print $1}' | tr -d '"')
        for vm in $vm_list; do
            vboxmanage controlvm "$vm" acpipowerbutton
            echo "Shutting down VM: $vm"
        done
        echo "✅ VMs shutdown initiated."
    fi
else
    echo "No VM management tools found. Skipping VM cleanup."
fi

echo -e "\n[5/7] Checking for active database services..."
services=("mysql" "mariadb" "postgresql" "mongodb" "redis-server" "cassandra" "elasticsearch")
active_services=()

for service in "${services[@]}"; do
    if systemctl is-active --quiet "$service"; then
        active_services+=("$service")
    fi
done

if [ ${#active_services[@]} -gt 0 ]; then
    echo "Active database services found: ${active_services[*]}"
    read -p "Stop all active database services? (y/n): " stop_services
    if [ "$stop_services" == "y" ]; then
        for service in "${active_services[@]}"; do
            sudo systemctl stop "$service"
            echo "Stopped service: $service"
        done
        echo "✅ Database services stopped."
    fi
else
    echo "No active database services found."
fi

echo -e "\n[6/7] Cleaning up user cache..."
read -p "Clean user cache directories? (y/n): " clean_user_cache
if [ "$clean_user_cache" == "y" ]; then
    rm -rf ~/.cache/* 2>/dev/null
    echo "✅ User cache cleaned."
fi

echo -e "\n[7/7] Running system cleanup..."
if command -v apt &> /dev/null; then
    read -p "Clean up package manager cache? (y/n): " clean_apt
    if [ "$clean_apt" == "y" ]; then
        sudo apt clean
        sudo apt autoremove -y
        echo "✅ Package manager cache cleaned."
    fi
fi

echo -e "\n========== Lab Cleanup Complete =========="
echo "The following cleanup tasks were performed:"

if [ "$remove_containers" == "y" ]; then echo "✅ Docker containers removed"; fi
if [ "$remove_volumes" == "y" ]; then echo "✅ Docker volumes cleaned"; fi
if [ "$remove_networks" == "y" ]; then echo "✅ Docker networks cleaned"; fi
if [ "$remove_images" == "y" ]; then echo "✅ Docker images cleaned"; fi
if [ "$full_prune" == "y" ]; then echo "✅ Full Docker system prune completed"; fi
if [ "$clean_tmp" == "y" ]; then echo "✅ Temporary files removed"; fi
if [ "$clean_logs" == "y" ]; then echo "✅ Log files cleaned"; fi
if [ "$stop_vms" == "y" ]; then echo "✅ Virtual machines stopped"; fi
if [ "$stop_services" == "y" ]; then echo "✅ Database services stopped"; fi
if [ "$clean_user_cache" == "y" ]; then echo "✅ User cache cleaned"; fi
if [ "$clean_apt" == "y" ]; then echo "✅ Package manager cache cleaned"; fi

echo -e "\nYour lab environment has been cleaned up successfully!"