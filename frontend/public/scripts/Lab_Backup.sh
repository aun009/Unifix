#!/bin/bash
# Lab Backup Script
# Description: Creates a backup of the lab environment

echo "========== Lab Backup Tool =========="
echo "This script will create a backup of your lab environment."
echo -e "=======================================\n"

# Create backup directory
BACKUP_DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_DIR="$HOME/lab_backup_$BACKUP_DATE"
mkdir -p "$BACKUP_DIR"

echo "Creating backup in: $BACKUP_DIR"

# Function to backup Docker resources
backup_docker() {
    echo -e "\n[1/6] Backing up Docker resources..."
    
    # Create docker directory
    mkdir -p "$BACKUP_DIR/docker"
    
    # Check if Docker is installed and running
    if command -v docker &> /dev/null && sudo docker info &>/dev/null; then
        # Save list of containers
        echo "Backing up container list..."
        sudo docker ps -a > "$BACKUP_DIR/docker/containers.txt"
        
        # Save list of images
        echo "Backing up image list..."
        sudo docker images > "$BACKUP_DIR/docker/images.txt"
        
        # Ask to save actual images
        read -p "Save Docker images? This may take significant disk space (y/n): " save_images
        if [ "$save_images" == "y" ]; then
            echo "This may take a while for large images..."
            mkdir -p "$BACKUP_DIR/docker/images"
            
            # Get list of image IDs
            image_ids=$(sudo docker images --format "{{.Repository}}:{{.Tag}}" | grep -v "<none>")
            
            for image in $image_ids; do
                # Replace / with _ in image names for filenames
                filename=$(echo "$image" | sed 's/\//_/g' | sed 's/:/_/g')
                echo "Saving image: $image"
                sudo docker save -o "$BACKUP_DIR/docker/images/$filename.tar" "$image"
            done
            echo "✅ Docker images saved."
        fi
        
        # Backup container volumes
        echo "Backing up container volumes (configuration only)..."
        mkdir -p "$BACKUP_DIR/docker/volumes"
        sudo docker volume ls -q > "$BACKUP_DIR/docker/volumes/volume_list.txt"
        
        # Inspect each volume for details
        while read volume; do
            sudo docker volume inspect "$volume" > "$BACKUP_DIR/docker/volumes/${volume}_info.json"
        done < "$BACKUP_DIR/docker/volumes/volume_list.txt"
        
        # Save docker-compose files if found
        find $HOME -name "docker-compose*.yml" -type f -exec cp {} "$BACKUP_DIR/docker/" \; 2>/dev/null
        
        echo "✅ Docker backup completed."
    else
        echo "Docker not installed or not running. Skipping Docker backup."
    fi
}

# Function to backup database dumps
backup_databases() {
    echo -e "\n[2/6] Backing up database data..."
    
    # Create database backup directory
    mkdir -p "$BACKUP_DIR/databases"
    
    # MySQL/MariaDB
    if command -v mysqldump &> /dev/null; then
        read -p "Backup MySQL/MariaDB databases? (y/n): " backup_mysql
        if [ "$backup_mysql" == "y" ]; then
            echo "Enter MySQL root password (input will be hidden):"
            read -s mysql_password
            
            echo "Creating MySQL database list..."
            mysql -u root -p"$mysql_password" -e "SHOW DATABASES;" > "$BACKUP_DIR/databases/mysql_databases.txt" 2>/dev/null
            
            if [ $? -eq 0 ]; then
                mkdir -p "$BACKUP_DIR/databases/mysql"
                # Skip system databases
                databases=$(grep -v "Database\|information_schema\|performance_schema\|mysql\|sys" "$BACKUP_DIR/databases/mysql_databases.txt")
                
                for db in $databases; do
                    echo "Backing up MySQL database: $db"
                    mysqldump -u root -p"$mysql_password" --databases "$db" > "$BACKUP_DIR/databases/mysql/${db}.sql" 2>/dev/null
                done
                echo "✅ MySQL/MariaDB databases backed up."
            else
                echo "❌ MySQL/MariaDB authentication failed. Skipping MySQL backup."
            fi
        fi
    fi
    
    # PostgreSQL
    if command -v pg_dump &> /dev/null; then
        read -p "Backup PostgreSQL databases? (y/n): " backup_postgres
        if [ "$backup_postgres" == "y" ]; then
            mkdir -p "$BACKUP_DIR/databases/postgresql"
            
            echo "Creating PostgreSQL database list..."
            sudo -u postgres psql -c "\l" > "$BACKUP_DIR/databases/postgresql_databases.txt" 2>/dev/null
            
            if [ $? -eq 0 ]; then
                # Extract database names
                databases=$(grep -v "template0\|template1\|postgres\|List of" "$BACKUP_DIR/databases/postgresql_databases.txt" | awk '{print $1}' | grep -v "^$" | grep -v "^\|")
                
                for db in $databases; do
                    if [ ! -z "$db" ]; then
                        echo "Backing up PostgreSQL database: $db"
                        sudo -u postgres pg_dump "$db" > "$BACKUP_DIR/databases/postgresql/${db}.sql" 2>/dev/null
                    fi
                done
                echo "✅ PostgreSQL databases backed up."
            else
                echo "❌ PostgreSQL access failed. Skipping PostgreSQL backup."
            fi
        fi
    fi
    
    # MongoDB
    if command -v mongodump &> /dev/null; then
        read -p "Backup MongoDB databases? (y/n): " backup_mongo
        if [ "$backup_mongo" == "y" ]; then
            echo "Creating MongoDB backup..."
            mkdir -p "$BACKUP_DIR/databases/mongodb"
            mongodump --out "$BACKUP_DIR/databases/mongodb" 2>/dev/null
            
            if [ $? -eq 0 ]; then
                echo "✅ MongoDB databases backed up."
            else
                echo "❌ MongoDB backup failed. Skipping MongoDB backup."
            fi
        fi
    fi
    
    # Redis
    if command -v redis-cli &> /dev/null; then
        read -p "Backup Redis data? (y/n): " backup_redis
        if [ "$backup_redis" == "y" ]; then
            echo "Creating Redis backup..."
            mkdir -p "$BACKUP_DIR/databases/redis"
            redis-cli save 2>/dev/null
            
            if [ -f /var/lib/redis/dump.rdb ]; then
                sudo cp /var/lib/redis/dump.rdb "$BACKUP_DIR/databases/redis/"
                echo "✅ Redis data backed up."
            else
                echo "❌ Redis dump file not found. Skipping Redis backup."
            fi
        fi
    fi
}

# Function to backup configuration files
backup_configs() {
    echo -e "\n[3/6] Backing up configuration files..."
    
    # Create config directories
    mkdir -p "$BACKUP_DIR/configs/system"
    mkdir -p "$BACKUP_DIR/configs/user"
    
    # System configs
    echo "Backing up system configurations..."
    sudo cp -r /etc/hosts "$BACKUP_DIR/configs/system/" 2>/dev/null
    sudo cp -r /etc/fstab "$BACKUP_DIR/configs/system/" 2>/dev/null
    sudo cp -r /etc/ssh "$BACKUP_DIR/configs/system/" 2>/dev/null
    
    # Database configs
    sudo cp -r /etc/mysql "$BACKUP_DIR/configs/system/" 2>/dev/null
    sudo cp -r /etc/postgresql "$BACKUP_DIR/configs/system/" 2>/dev/null
    sudo cp -r /etc/mongodb "$BACKUP_DIR/configs/system/" 2>/dev/null
    sudo cp -r /etc/redis "$BACKUP_DIR/configs/system/" 2>/dev/null
    
    # Web server configs
    sudo cp -r /etc/apache2 "$BACKUP_DIR/configs/system/" 2>/dev/null
    sudo cp -r /etc/nginx "$BACKUP_DIR/configs/system/" 2>/dev/null
    
    # User configs
    echo "Backing up user configurations..."
    cp -r ~/.bashrc "$BACKUP_DIR/configs/user/" 2>/dev/null
    cp -r ~/.profile "$BACKUP_DIR/configs/user/" 2>/dev/null
    cp -r ~/.ssh "$BACKUP_DIR/configs/user/" 2>/dev/null
    cp -r ~/.vimrc "$BACKUP_DIR/configs/user/" 2>/dev/null
    cp -r ~/.gitconfig "$BACKUP_DIR/configs/user/" 2>/dev/null
    
    echo "✅ Configuration files backed up."
}

# Function to backup VM information
backup_vms() {
    echo -e "\n[4/6] Backing up Virtual Machine information..."
    mkdir -p "$BACKUP_DIR/vms"
    
    # KVM/QEMU VMs
    if command -v virsh &> /dev/null; then
        echo "Backing up KVM/QEMU VM information..."
        sudo virsh list --all > "$BACKUP_DIR/vms/kvm_vm_list.txt" 2>/dev/null
        
        # Export VM definitions
        vm_names=$(sudo virsh list --all --name)
        for vm in $vm_names; do
            if [ ! -z "$vm" ]; then
                echo "Saving definition for VM: $vm"
                sudo virsh dumpxml "$vm" > "$BACKUP_DIR/vms/kvm_${vm}.xml" 2>/dev/null
            fi
        done
        
        echo "KVM VM storage pools:"
        sudo virsh pool-list --all > "$BACKUP_DIR/vms/kvm_storage_pools.txt" 2>/dev/null
        
        echo "✅ KVM/QEMU VM information backed up."
    fi
    
    # VirtualBox VMs
    if command -v vboxmanage &> /dev/null; then
        echo "Backing up VirtualBox VM information..."
        vboxmanage list vms > "$BACKUP_DIR/vms/virtualbox_vm_list.txt" 2>/dev/null
        
        # Export detailed info for each VM
        vm_list=$(vboxmanage list vms | awk '{print $1}' | tr -d '"')
        for vm in $vm_list; do
            if [ ! -z "$vm" ]; then
                echo "Saving information for VM: $vm"
                vboxmanage showvminfo "$vm" --machinereadable > "$BACKUP_DIR/vms/virtualbox_${vm}_info.txt" 2>/dev/null
            fi
        done
        
        echo "✅ VirtualBox VM information backed up."
    fi
    
    if [ ! -f "$BACKUP_DIR/vms/kvm_vm_list.txt" ] && [ ! -f "$BACKUP_DIR/vms/virtualbox_vm_list.txt" ]; then
        echo "No virtualization systems found. Skipping VM backup."
    fi
}

# Function to backup project files
backup_projects() {
    echo -e "\n[5/6] Backing up project files..."
    
    read -p "Do you want to backup specific project directories? (y/n): " backup_projects
    if [ "$backup_projects" == "y" ]; then
        mkdir -p "$BACKUP_DIR/projects"
        
        # Ask for directories to backup
        echo "Enter the paths to project directories (one per line). Press Ctrl+D when finished:"
        project_dirs=()
        while read -r line; do
            project_dirs+=("$line")
        done
        
        # Backup each directory
        for dir in "${project_dirs[@]}"; do
            if [ -d "$dir" ]; then
                dir_name=$(basename "$dir")
                echo "Backing up project: $dir_name"
                cp -r "$dir" "$BACKUP_DIR/projects/"
            else
                echo "Directory not found: $dir"
            fi
        done
        
        echo "✅ Project files backed up."
    fi
}

# Function to create archive
create_archive() {
    echo -e "\n[6/6] Creating final backup archive..."
    
    cd "$(dirname "$BACKUP_DIR")"
    archive_name="$(basename "$BACKUP_DIR").tar.gz"
    
    echo "Compressing backup directory..."
    tar -czf "$archive_name" "$(basename "$BACKUP_DIR")"
    
    if [ $? -eq 0 ]; then
        echo "✅ Backup archive created: $(pwd)/$archive_name"
        
        read -p "Remove uncompressed backup directory? (y/n): " remove_dir
        if [ "$remove_dir" == "y" ]; then
            rm -rf "$BACKUP_DIR"
            echo "Uncompressed backup directory removed."
        fi
    else
        echo "❌ Failed to create backup archive."
        echo "Uncompressed backup is still available at: $BACKUP_DIR"
    fi
}

# Execute backup functions
backup_docker
backup_databases
backup_configs
backup_vms
backup_projects
create_archive

echo -e "\n========== Lab Backup Complete =========="
echo "Your lab environment has been successfully backed up!"
echo "Backup location: $HOME/$(basename "$BACKUP_DIR").tar.gz"
echo -e "\nTo restore from this backup:"
echo "1. Extract the archive: tar -xzf $(basename "$BACKUP_DIR").tar.gz"
echo "2. For Docker images: docker load -i [image-file.tar]"
echo "3. For databases: Use the appropriate import tools (mysql, pg_restore, mongorestore)"
echo "4. Copy configuration files back to their original locations"