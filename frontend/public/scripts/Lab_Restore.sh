#!/bin/bash
# Lab Restore Script
# Description: Restores the lab environment from a backup

echo "========== Lab Restore Tool =========="
echo "This script will restore your lab environment from a backup."
echo -e "=======================================\n"

# Function to select and validate backup archive
select_backup() {
    # Check for backup archives in the home directory
    backup_archives=($(find $HOME -maxdepth 1 -name "lab_backup_*.tar.gz" | sort -r))
    
    if [ ${#backup_archives[@]} -eq 0 ]; then
        echo "No backup archives found in $HOME directory."
        read -p "Enter the full path to your backup archive: " custom_backup
        
        if [ -f "$custom_backup" ] && [[ "$custom_backup" == *.tar.gz ]]; then
            selected_backup="$custom_backup"
            echo "Selected backup: $selected_backup"
        else
            echo "Invalid backup file. Please ensure it's a .tar.gz file."
            exit 1
        fi
    else
        echo "Found backup archives:"
        for i in "${!backup_archives[@]}"; do
            echo "[$i] ${backup_archives[$i]##*/} ($(date -r ${backup_archives[$i]} "+%Y-%m-%d %H:%M:%S"))"
        done
        
        read -p "Select backup to restore [0-$((${#backup_archives[@]}-1))] or enter custom path: " backup_choice
        
        if [[ "$backup_choice" =~ ^[0-9]+$ ]] && [ "$backup_choice" -lt ${#backup_archives[@]} ]; then
            selected_backup="${backup_archives[$backup_choice]}"
            echo "Selected backup: $selected_backup"
        elif [ -f "$backup_choice" ] && [[ "$backup_choice" == *.tar.gz ]]; then
            selected_backup="$backup_choice"
            echo "Selected backup: $selected_backup"
        else
            echo "Invalid selection. Please run the script again."
            exit 1
        fi
    fi
}

# Function to extract the backup archive
extract_backup() {
    echo -e "\n[1/7] Extracting backup archive..."
    
    # Create temporary directory for extraction
    temp_dir=$(mktemp -d)
    
    # Extract to temporary directory
    echo "Extracting to $temp_dir..."
    tar -xzf "$selected_backup" -C "$temp_dir"
    
    if [ $? -eq 0 ]; then
        echo "✅ Backup archive extracted successfully."
        
        # Find the actual backup directory (should be only one)
        backup_dir=$(find "$temp_dir" -maxdepth 1 -type d -name "lab_backup_*" | head -1)
        
        if [ -z "$backup_dir" ]; then
            echo "❌ Could not find backup directory in the archive."
            exit 1
        fi
        
        echo "Backup directory: $backup_dir"
    else
        echo "❌ Failed to extract backup archive."
        exit 1
    fi
}

# Function to restore Docker resources
restore_docker() {
    echo -e "\n[2/7] Restoring Docker resources..."
    
    docker_dir="$backup_dir/docker"
    
    if [ ! -d "$docker_dir" ]; then
        echo "No Docker backup found. Skipping Docker restore."
        return
    fi
    
    # Check if Docker is installed
    if ! command -v docker &> /dev/null; then
        echo "Docker is not installed. Install Docker first to restore Docker resources."
        return
    fi
    
    # Restore Docker images
    if [ -d "$docker_dir/images" ]; then
        echo "Docker images found in backup. Restoring..."
        
        image_files=$(find "$docker_dir/images" -name "*.tar")
        
        if [ ${#image_files[@]} -gt 0 ]; then
            read -p "Restore Docker images? This may take some time. (y/n): " restore_images
            
            if [ "$restore_images" == "y" ]; then
                for image_file in $image_files; do
                    echo "Loading image: $(basename "$image_file")"
                    sudo docker load -i "$image_file"
                done
                echo "✅ Docker images restored."
            fi
        else
            echo "No Docker image archives found."
        fi
    fi
    
    # Show container information from backup
    if [ -f "$docker_dir/containers.txt" ]; then
        echo -e "\nContainer information from backup:"
        cat "$docker_dir/containers.txt"
        echo -e "\nNote: You'll need to recreate containers manually using the above information."
        echo "If you used docker-compose, check for docker-compose files in the backup."
    fi
    
    # Check for docker-compose files
    compose_files=$(find "$docker_dir" -name "docker-compose*.yml")
    if [ ! -z "$compose_files" ]; then
        echo -e "\nDocker Compose files found in backup:"
        for compose_file in $compose_files; do
            echo "- $(basename "$compose_file")"
        done
        
        read -p "Copy docker-compose files to current directory? (y/n): " copy_compose
        if [ "$copy_compose" == "y" ]; then
            cp $compose_files ./
            echo "✅ Docker Compose files copied to current directory."
            echo "Run 'docker-compose up -d' with the appropriate file to restore services."
        fi
    fi
}

# Function to restore database dumps
restore_databases() {
    echo -e "\n[3/7] Restoring database dumps..."
    
    db_dir="$backup_dir/databases"
    
    if [ ! -d "$db_dir" ]; then
        echo "No database backups found. Skipping database restore."
        return
    fi
    
    # MySQL/MariaDB
    if [ -d "$db_dir/mysql" ]; then
        if command -v mysql &> /dev/null; then
            read -p "Restore MySQL/MariaDB databases? (y/n): " restore_mysql
            
            if [ "$restore_mysql" == "y" ]; then
                echo "Enter MySQL root password (input will be hidden):"
                read -s mysql_password
                
                for sql_file in "$db_dir/mysql"/*.sql; do
                    db_name=$(basename "$sql_file" .sql)
                    echo "Restoring MySQL database: $db_name"
                    
                    # Create database if it doesn't exist
                    mysql -u root -p"$mysql_password" -e "CREATE DATABASE IF NOT EXISTS \`$db_name\`;" 2>/dev/null
                    
                    # Restore the database
                    mysql -u root -p"$mysql_password" < "$sql_file" 2>/dev/null
                    
                    if [ $? -eq 0 ]; then
                        echo "✅ Database $db_name restored successfully."
                    else
                        echo "❌ Failed to restore database $db_name."
                    fi
                done
            fi
        else
            echo "MySQL/MariaDB client not installed. Cannot restore MySQL/MariaDB databases."
        fi
    fi
    
    # PostgreSQL
    if [ -d "$db_dir/postgresql" ]; then
        if command -v psql &> /dev/null; then
            read -p "Restore PostgreSQL databases? (y/n): " restore_postgres
            
            if [ "$restore_postgres" == "y" ]; then
                for sql_file in "$db_dir/postgresql"/*.sql; do
                    db_name=$(basename "$sql_file" .sql)
                    echo "Restoring PostgreSQL database: $db_name"
                    
                    # Create database if it doesn't exist
                    sudo -u postgres psql -c "CREATE DATABASE $db_name;" 2>/dev/null
                    
                    # Restore the database
                    sudo -u postgres psql -d "$db_name" -f "$sql_file" 2>/dev/null
                    
                    if [ $? -eq 0 ]; then
                        echo "✅ Database $db_name restored successfully."
                    else
                        echo "❌ Failed to restore database $db_name."
                    fi
                done
            fi
        else
            echo "PostgreSQL client not installed. Cannot restore PostgreSQL databases."
        fi
    fi
    
    # MongoDB
    if [ -d "$db_dir/mongodb" ]; then
        if command -v mongorestore &> /dev/null; then
            read -p "Restore MongoDB databases? (y/n): " restore_mongo
            
            if [ "$restore_mongo" == "y" ]; then
                echo "Restoring MongoDB databases..."
                mongorestore "$db_dir/mongodb" 2>/dev/null
                
                if [ $? -eq 0 ]; then
                    echo "✅ MongoDB databases restored successfully."
                else
                    echo "❌ Failed to restore MongoDB databases."
                fi
            fi
        else
            echo "MongoDB tools not installed. Cannot restore MongoDB databases."
        fi
    fi
    
    # Redis
    if [ -d "$db_dir/redis" ] && [ -f "$db_dir/redis/dump.rdb" ]; then
        if command -v redis-cli &> /dev/null; then
            read -p "Restore Redis data? (y/n): " restore_redis
            
            if [ "$restore_redis" == "y" ]; then
                echo "Stopping Redis service..."
                sudo systemctl stop redis-server 2>/dev/null || sudo service redis-server stop 2>/dev/null
                
                echo "Copying Redis dump file..."
                sudo cp "$db_dir/redis/dump.rdb" /var/lib/redis/ 2>/dev/null
                
                echo "Starting Redis service..."
                sudo systemctl start redis-server 2>/dev/null || sudo service redis-server start 2>/dev/null
                
                echo "✅ Redis data restored."
            fi
        else
            echo "Redis client not installed. Cannot restore Redis data."
        fi
    fi
}

# Function to restore configuration files
restore_configs() {
    echo -e "\n[4/7] Restoring configuration files..."
    
    config_dir="$backup_dir/configs"
    
    if [ ! -d "$config_dir" ]; then
        echo "No configuration backups found. Skipping configuration restore."
        return
    fi
    
    # System configs
    if [ -d "$config_dir/system" ]; then
        echo "System configuration files found in backup:"
        find "$config_dir/system" -type f | sort
        
        read -p "Do you want to restore system configuration files? This requires sudo access. (y/n): " restore_sys_config
        
        if [ "$restore_sys_config" == "y" ]; then
            # Hosts file
            if [ -f "$config_dir/system/hosts" ]; then
                read -p "Restore /etc/hosts file? (y/n): " restore_hosts
                if [ "$restore_hosts" == "y" ]; then
                    sudo cp "$config_dir/system/hosts" /etc/hosts
                    echo "✅ Hosts file restored."
                fi
            fi
            
            # SSH config
            if [ -d "$config_dir/system/ssh" ]; then
                read -p "Restore SSH configuration? (y/n): " restore_ssh
                if [ "$restore_ssh" == "y" ]; then
                    sudo cp -r "$config_dir/system/ssh/"* /etc/ssh/
                    sudo systemctl restart ssh 2>/dev/null || sudo service ssh restart 2>/dev/null
                    echo "✅ SSH configuration restored."
                fi
            fi
            
            # Database configs
            for db_config in mysql postgresql mongodb redis; do
                if [ -d "$config_dir/system/$db_config" ]; then
                    read -p "Restore $db_config configuration? (y/n): " restore_db_config
                    if [ "$restore_db_config" == "y" ]; then
                        sudo cp -r "$config_dir/system/$db_config/"* /etc/$db_config/
                        sudo systemctl restart $db_config 2>/dev/null || sudo service $db_config restart 2>/dev/null
                        echo "✅ $db_config configuration restored."
                    fi
                fi
            done
            
            # Web server configs
            for web_config in apache2 nginx; do
                if [ -d "$config_dir/system/$web_config" ]; then
                    read -p "Restore $web_config configuration? (y/n): " restore_web_config
                    if [ "$restore_web_config" == "y" ]; then
                        sudo cp -r "$config_dir/system/$web_config/"* /etc/$web_config/
                        sudo systemctl restart $web_config 2>/dev/null || sudo service $web_config restart 2>/dev/null
                        echo "✅ $web_config configuration restored."
                    fi
                fi
            done
        fi
    fi
    
    # User configs
    if [ -d "$config_dir/user" ]; then
        echo -e "\nUser configuration files found in backup:"
        find "$config_dir/user" -type f -maxdepth 1 | sort
        
        read -p "Restore user configuration files? (y/n): " restore_user_config
        
        if [ "$restore_user_config" == "y" ]; then
            # Backup current configs first
            mkdir -p "$HOME/config_backup_$(date +%Y%m%d)"
            
            for config in .bashrc .profile .vimrc .gitconfig; do
                if [ -f "$config_dir/user/$config" ]; then
                    if [ -f "$HOME/$config" ]; then
                        cp "$HOME/$config" "$HOME/config_backup_$(date +%Y%m%d)/"
                    fi
                    cp "$config_dir/user/$config" "$HOME/"
                    echo "✅ $config restored."
                fi
            done
            
            # SSH keys require special handling
            if [ -d "$config_dir/user/.ssh" ]; then
                read -p "Restore SSH keys? This will replace your current SSH keys. (y/n): " restore_ssh_keys
                if [ "$restore_ssh_keys" == "y" ]; then
                    if [ -d "$HOME/.ssh" ]; then
                        cp -r "$HOME/.ssh" "$HOME/config_backup_$(date +%Y%m%d)/"
                    else
                        mkdir -p "$HOME/.ssh"
                    fi
                    cp -r "$config_dir/user/.ssh/"* "$HOME/.ssh/"
                    chmod 600 "$HOME/.ssh/id_"*
                    chmod 644 "$HOME/.ssh/id_"*.pub
                    echo "✅ SSH keys restored."
                fi
            fi
        fi
    fi
}

# Function to restore VM definitions
restore_vms() {
    echo -e "\n[5/7] Restoring Virtual Machine information..."
    
    vm_dir="$backup_dir/vms"
    
    if [ ! -d "$vm_dir" ]; then
        echo "No VM backups found. Skipping VM restore."
        return
    fi
    
    # KVM/QEMU VMs
    if [ -f "$vm_dir/kvm_vm_list.txt" ] && command -v virsh &> /dev/null; then
        echo "KVM/QEMU VM definitions found in backup."
        
        # Show VM list from backup
        echo -e "\nVM list from backup:"
        cat "$vm_dir/kvm_vm_list.txt"
        
        read -p "Restore KVM/QEMU VM definitions? Note: This only restores definitions, not VM disk images. (y/n): " restore_kvm
        
        if [ "$restore_kvm" == "y" ]; then
            # Find all VM XML files
            for xml_file in "$vm_dir"/kvm_*.xml; do
                vm_name=$(basename "$xml_file" .xml | sed 's/^kvm_//')
                
                echo "Restoring VM definition: $vm_name"
                
                # Check if VM already exists
                if sudo virsh dominfo "$vm_name" &>/dev/null; then
                    read -p "VM '$vm_name' already exists. Overwrite? (y/n): " overwrite_vm
                    if [ "$overwrite_vm" == "y" ]; then
                        sudo virsh undefine "$vm_name"
                    else
                        continue
                    fi
                fi
                
                # Define VM from XML
                sudo virsh define "$xml_file"
                
                if [ $? -eq 0 ]; then
                    echo "✅ VM definition for $vm_name restored."
                else
                    echo "❌ Failed to restore VM definition for $vm_name."
                    echo "This usually happens when VM disk images are not in the expected location."
                    echo "You may need to edit the XML file to point to the correct disk image paths."
                fi
            done
        fi
    fi
    
    # VirtualBox VMs
    if [ -f "$vm_dir/virtualbox_vm_list.txt" ] && command -v vboxmanage &> /dev/null; then
        echo -e "\nVirtualBox VM information found in backup."
        
        # Show VM list from backup
        echo -e "\nVM list from backup:"
        cat "$vm_dir/virtualbox_vm_list.txt"
        
        echo -e "\nNote: VirtualBox VM restoration requires you to manually recreate VMs with the same settings."
        echo "The backed-up information files can be used as reference."
        echo "VM info files are available in the backup directory: $vm_dir/virtualbox_*_info.txt"
    fi
}

# Function to restore project files
restore_projects() {
    echo -e "\n[6/7] Restoring project files..."
    
    project_dir="$backup_dir/projects"
    
    if [ ! -d "$project_dir" ]; then
        echo "No project backups found. Skipping project restore."
        return
    fi
    
    # List available projects
    echo "Projects found in backup:"
    find "$project_dir" -maxdepth 1 -type d | grep -v "^$project_dir$" | sort
    
    read -p "Restore project files? (y/n): " restore_projects
    
    if [ "$restore_projects" == "y" ]; then
        read -p "Enter directory to restore projects to (default: $HOME/restored_projects): " project_restore_dir
        project_restore_dir=${project_restore_dir:-$HOME/restored_projects}
        
        # Create restore directory if it doesn't exist
        mkdir -p "$project_restore_dir"
        
        # Copy all projects
        cp -r "$project_dir"/* "$project_restore_dir/"
        
        echo "✅ Project files restored to $project_restore_dir"
    fi
}

# Function to clean up
cleanup() {
    echo -e "\n[7/7] Cleaning up..."
    
    read -p "Remove temporary extraction directory? (y/n): " remove_temp
    
    if [ "$remove_temp" == "y" ]; then
        rm -rf "$temp_dir"
        echo "✅ Temporary extraction directory removed."
    else
        echo "Temporary extraction directory kept: $temp_dir"
    fi
}

# Main execution
select_backup
extract_backup
restore_docker
restore_databases
restore_configs
restore_vms
restore_projects
cleanup

echo -e "\n========== Lab Restore Complete =========="
echo "Your lab environment has been restored from backup!"
echo "If you experienced any issues during restoration, check the error messages above."
echo "Some services may need to be restarted to apply the restored configurations."