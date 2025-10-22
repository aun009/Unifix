#!/bin/bash
# All Database Script
# Description: Run the database of your choice using Docker

echo "========== Database Management Tool =========="

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker not found. Installing Docker..."
    
    # Update package index
    sudo apt-get update
    
    # Install prerequisites
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    
    # Add Docker's official GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    
    # Add Docker repository
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    
    # Update package index again
    sudo apt-get update
    
    # Install Docker CE
    sudo apt-get install -y docker-ce
    
    # Start and enable Docker service
    sudo systemctl start docker
    sudo systemctl enable docker
    
    # Add current user to docker group to avoid using sudo
    sudo usermod -aG docker $USER
    
    echo "Docker installation complete!"
    echo "NOTE: You may need to log out and log back in for group changes to take effect."
    echo "For now, we'll continue using sudo for docker commands."
    echo "-----------------------------------------------"
else
    echo "Docker is already installed."
fi

# Check if Docker service is running
if ! sudo docker info &> /dev/null; then
    echo "Starting Docker service..."
    sudo systemctl start docker
    
    # Double-check if Docker service started successfully
    if ! sudo docker info &> /dev/null; then
        echo "❌ Failed to start Docker service. Please check Docker installation."
        exit 1
    fi
fi

echo -e "\nSelect a database to start:"
echo "1. MySQL"
echo "2. PostgreSQL"
echo "3. MongoDB"
echo "4. Redis"
echo "5. MariaDB"
echo "6. SQLite"
echo "7. Cassandra"
echo "8. Elasticsearch"
echo -e "=======================================\n"

read -p "Enter your choice (1-8): " db_choice

case $db_choice in
    1)
        echo -e "\n[MySQL] Starting MySQL database container..."
        read -p "Enter MySQL root password: " mysql_password
        read -p "Enter port for MySQL (default: 3306): " mysql_port
        mysql_port=${mysql_port:-3306}
        
        # Check if a container is already running on the specified port
        if sudo docker ps -a | grep "0.0.0.0:${mysql_port}->3306" &> /dev/null; then
            echo "Warning: There appears to be a container already using port ${mysql_port}."
            read -p "Do you want to stop it and continue? (y/n): " stop_container
            if [ "$stop_container" == "y" ]; then
                sudo docker stop $(sudo docker ps -a | grep "0.0.0.0:${mysql_port}->3306" | awk '{print $1}')
            else
                echo "Operation cancelled."
                exit 0
            fi
        fi
        
        # Run MySQL container
        sudo docker run --name mysql-db -e MYSQL_ROOT_PASSWORD=${mysql_password} -p ${mysql_port}:3306 -d mysql:latest
        
        # Wait for container to start
        sleep 5
        
        # Check if container is running
        if [ $(sudo docker ps -q -f name=mysql-db) ]; then
            echo "✅ MySQL container started successfully!"
            echo -e "\nConnection information:"
            echo "Host: localhost"
            echo "Port: ${mysql_port}"
            echo "Username: root"
            echo "Password: ${mysql_password}"
            echo -e "\nTo connect using MySQL client (if installed):"
            echo "mysql -h localhost -P ${mysql_port} -u root -p"
            echo -e "\nTo connect using Docker:"
            echo "sudo docker exec -it mysql-db mysql -uroot -p${mysql_password}"
            echo -e "\nTo stop the container:"
            echo "sudo docker stop mysql-db"
        else
            echo "❌ Failed to start MySQL container."
        fi
        ;;
    
    2)
        echo -e "\n[PostgreSQL] Starting PostgreSQL database container..."
        read -p "Enter PostgreSQL password: " pg_password
        read -p "Enter port for PostgreSQL (default: 5432): " pg_port
        pg_port=${pg_port:-5432}
        
        # Check if a container is already running on the specified port
        if sudo docker ps -a | grep "0.0.0.0:${pg_port}->5432" &> /dev/null; then
            echo "Warning: There appears to be a container already using port ${pg_port}."
            read -p "Do you want to stop it and continue? (y/n): " stop_container
            if [ "$stop_container" == "y" ]; then
                sudo docker stop $(sudo docker ps -a | grep "0.0.0.0:${pg_port}->5432" | awk '{print $1}')
            else
                echo "Operation cancelled."
                exit 0
            fi
        fi
        
        # Run PostgreSQL container
        sudo docker run --name postgres-db -e POSTGRES_PASSWORD=${pg_password} -p ${pg_port}:5432 -d postgres:latest
        
        # Wait for container to start
        sleep 5
        
        # Check if container is running
        if [ $(sudo docker ps -q -f name=postgres-db) ]; then
            echo "✅ PostgreSQL container started successfully!"
            echo -e "\nConnection information:"
            echo "Host: localhost"
            echo "Port: ${pg_port}"
            echo "Username: postgres"
            echo "Password: ${pg_password}"
            echo -e "\nTo connect using PostgreSQL client (if installed):"
            echo "psql -h localhost -p ${pg_port} -U postgres"
            echo -e "\nTo connect using Docker:"
            echo "sudo docker exec -it postgres-db psql -U postgres"
            echo -e "\nTo stop the container:"
            echo "sudo docker stop postgres-db"
        else
            echo "❌ Failed to start PostgreSQL container."
        fi
        ;;
    
    3)
        echo -e "\n[MongoDB] Starting MongoDB database container..."
        read -p "Enter port for MongoDB (default: 27017): " mongo_port
        mongo_port=${mongo_port:-27017}
        
        # Check if a container is already running on the specified port
        if sudo docker ps -a | grep "0.0.0.0:${mongo_port}->27017" &> /dev/null; then
            echo "Warning: There appears to be a container already using port ${mongo_port}."
            read -p "Do you want to stop it and continue? (y/n): " stop_container
            if [ "$stop_container" == "y" ]; then
                sudo docker stop $(sudo docker ps -a | grep "0.0.0.0:${mongo_port}->27017" | awk '{print $1}')
            else
                echo "Operation cancelled."
                exit 0
            fi
        fi
        
        # Run MongoDB container
        sudo docker run --name mongodb-db -p ${mongo_port}:27017 -d mongo:latest
        
        # Wait for container to start
        sleep 5
        
        # Check if container is running
        if [ $(sudo docker ps -q -f name=mongodb-db) ]; then
            echo "✅ MongoDB container started successfully!"
            echo -e "\nConnection information:"
            echo "Host: localhost"
            echo "Port: ${mongo_port}"
            echo -e "\nTo connect using MongoDB client (if installed):"
            echo "mongosh mongodb://localhost:${mongo_port}"
            echo "Or with older client: mongo mongodb://localhost:${mongo_port}"
            echo -e "\nTo connect using Docker:"
            echo "sudo docker exec -it mongodb-db mongosh"
            echo -e "\nTo stop the container:"
            echo "sudo docker stop mongodb-db"
        else
            echo "❌ Failed to start MongoDB container."
        fi
        ;;
    
    4)
        echo -e "\n[Redis] Starting Redis database container..."
        read -p "Enter port for Redis (default: 6379): " redis_port
        redis_port=${redis_port:-6379}
        
        # Check if a container is already running on the specified port
        if sudo docker ps -a | grep "0.0.0.0:${redis_port}->6379" &> /dev/null; then
            echo "Warning: There appears to be a container already using port ${redis_port}."
            read -p "Do you want to stop it and continue? (y/n): " stop_container
            if [ "$stop_container" == "y" ]; then
                sudo docker stop $(sudo docker ps -a | grep "0.0.0.0:${redis_port}->6379" | awk '{print $1}')
            else
                echo "Operation cancelled."
                exit 0
            fi
        fi
        
        # Run Redis container
        sudo docker run --name redis-db -p ${redis_port}:6379 -d redis:latest
        
        # Wait for container to start
        sleep 5
        
        # Check if container is running
        if [ $(sudo docker ps -q -f name=redis-db) ]; then
            echo "✅ Redis container started successfully!"
            echo -e "\nConnection information:"
            echo "Host: localhost"
            echo "Port: ${redis_port}"
            echo -e "\nTo connect using Redis client (if installed):"
            echo "redis-cli -h localhost -p ${redis_port}"
            echo -e "\nTo connect using Docker:"
            echo "sudo docker exec -it redis-db redis-cli"
            echo -e "\nTo stop the container:"
            echo "sudo docker stop redis-db"
        else
            echo "❌ Failed to start Redis container."
        fi
        ;;
        
    5)
        echo -e "\n[MariaDB] Starting MariaDB database container..."
        read -p "Enter MariaDB root password: " mariadb_password
        read -p "Enter port for MariaDB (default: 3306): " mariadb_port
        mariadb_port=${mariadb_port:-3306}
        
        # Check if a container is already running on the specified port
        if sudo docker ps -a | grep "0.0.0.0:${mariadb_port}->3306" &> /dev/null; then
            echo "Warning: There appears to be a container already using port ${mariadb_port}."
            read -p "Do you want to stop it and continue? (y/n): " stop_container
            if [ "$stop_container" == "y" ]; then
                sudo docker stop $(sudo docker ps -a | grep "0.0.0.0:${mariadb_port}->3306" | awk '{print $1}')
            else
                echo "Operation cancelled."
                exit 0
            fi
        fi
        
        # Run MariaDB container
        sudo docker run --name mariadb-db -e MYSQL_ROOT_PASSWORD=${mariadb_password} -p ${mariadb_port}:3306 -d mariadb:latest
        
        # Wait for container to start
        sleep 5
        
        # Check if container is running
        if [ $(sudo docker ps -q -f name=mariadb-db) ]; then
            echo "✅ MariaDB container started successfully!"
            echo -e "\nConnection information:"
            echo "Host: localhost"
            echo "Port: ${mariadb_port}"
            echo "Username: root"
            echo "Password: ${mariadb_password}"
            echo -e "\nTo connect using MariaDB/MySQL client (if installed):"
            echo "mysql -h localhost -P ${mariadb_port} -u root -p"
            echo -e "\nTo connect using Docker:"
            echo "sudo docker exec -it mariadb-db mysql -uroot -p${mariadb_password}"
            echo -e "\nTo stop the container:"
            echo "sudo docker stop mariadb-db"
        else
            echo "❌ Failed to start MariaDB container."
        fi
        ;;
        
    6)
        echo -e "\n[SQLite] Starting SQLite container with persistent storage..."
        
        # Create a directory for SQLite database files if it doesn't exist
        mkdir -p ~/sqlite-data
        
        echo -e "\nSQLite database files will be stored in ~/sqlite-data/"
        
        # Run a container with SQLite and mount the local directory
        sudo docker run --name sqlite-db -v ~/sqlite-data:/data -it --rm alpine sh -c "apk add --no-cache sqlite && echo 'SQLite version:' && sqlite3 --version && echo '' && cd /data && /bin/sh"
        
        echo -e "\nSQLite container session ended."
        echo "Your SQLite database files are saved in ~/sqlite-data/"
        ;;
        
    7)
        echo -e "\n[Cassandra] Starting Cassandra database container..."
        read -p "Enter port for Cassandra (default: 9042): " cassandra_port
        cassandra_port=${cassandra_port:-9042}
        
        # Check if a container is already running on the specified port
        if sudo docker ps -a | grep "0.0.0.0:${cassandra_port}->9042" &> /dev/null; then
            echo "Warning: There appears to be a container already using port ${cassandra_port}."
            read -p "Do you want to stop it and continue? (y/n): " stop_container
            if [ "$stop_container" == "y" ]; then
                sudo docker stop $(sudo docker ps -a | grep "0.0.0.0:${cassandra_port}->9042" | awk '{print $1}')
            else
                echo "Operation cancelled."
                exit 0
            fi
        fi
        
        echo "Starting Cassandra container (this may take a while)..."
        # Run Cassandra container
        sudo docker run --name cassandra-db -p ${cassandra_port}:9042 -d cassandra:latest
        
        echo "Waiting for Cassandra to start (this typically takes 60-90 seconds)..."
        sleep 60
        
        # Check if container is running
        if [ $(sudo docker ps -q -f name=cassandra-db) ]; then
            echo "✅ Cassandra container started successfully!"
            echo -e "\nConnection information:"
            echo "Host: localhost"
            echo "Port: ${cassandra_port}"
            echo -e "\nTo connect using cqlsh client (if installed):"
            echo "cqlsh localhost ${cassandra_port}"
            echo -e "\nTo connect using Docker:"
            echo "sudo docker exec -it cassandra-db cqlsh"
            echo -e "\nTo stop the container:"
            echo "sudo docker stop cassandra-db"
        else
            echo "❌ Failed to start Cassandra container."
        fi
        ;;
        
    8)
        echo -e "\n[Elasticsearch] Starting Elasticsearch database container..."
        read -p "Enter port for Elasticsearch HTTP (default: 9200): " es_port
        es_port=${es_port:-9200}
        
        # Check if a container is already running on the specified port
        if sudo docker ps -a | grep "0.0.0.0:${es_port}->9200" &> /dev/null; then
            echo "Warning: There appears to be a container already using port ${es_port}."
            read -p "Do you want to stop it and continue? (y/n): " stop_container
            if [ "$stop_container" == "y" ]; then
                sudo docker stop $(sudo docker ps -a | grep "0.0.0.0:${es_port}->9200" | awk '{print $1}')
            else
                echo "Operation cancelled."
                exit 0
            fi
        fi
        
        echo "Starting Elasticsearch container with development configuration..."
        # Run Elasticsearch container with development settings
        sudo docker run --name elasticsearch-db -p ${es_port}:9200 -p 9300:9300 -e "discovery.type=single-node" -e "xpack.security.enabled=false" -d elasticsearch:8.7.0
        
        echo "Waiting for Elasticsearch to start (this may take 30-60 seconds)..."
        sleep 30
        
        # Check if container is running
        if [ $(sudo docker ps -q -f name=elasticsearch-db) ]; then
            echo "✅ Elasticsearch container started successfully!"
            echo -e "\nConnection information:"
            echo "HTTP API: http://localhost:${es_port}"
            echo -e "\nTo test the connection:"
            echo "curl http://localhost:${es_port}"
            echo -e "\nTo stop the container:"
            echo "sudo docker stop elasticsearch-db"
        else
            echo "❌ Failed to start Elasticsearch container."
        fi
        ;;
        
    *)
        echo "Invalid option. Please run the script again and select a valid option (1-8)."
        exit 1
        ;;
esac

echo -e "\n========== Database Setup Complete =========="
echo "To view all running Docker containers: sudo docker ps"
echo "To view all Docker containers: sudo docker ps -a"
echo "To stop a container: sudo docker stop [container-name]"
echo "To remove a container: sudo docker rm [container-name]"