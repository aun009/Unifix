#!/bin/bash
# filepath: /scripts/LabSetup.sh

echo "=============================="
echo "   Lab Database Setup Menu"
echo "=============================="
echo "Select a database to run:"
echo "1) MongoDB"
echo "2) MariaDB"
echo "3) MySQL"
echo "4) PostgreSQL"
echo "5) Redis"
echo "6) Neo4j"
echo "7) Exit"
echo "------------------------------"
read -p "Enter your choice [1-7]: " choice

case $choice in
  1)
    # MongoDB
    CONTAINER_NAME="lab_mongodb"
    if ! docker ps -a --format '{{.Names}}' | grep -q "^$CONTAINER_NAME$"; then
      echo "Starting MongoDB container..."
      docker run -d --name $CONTAINER_NAME -p 27017:27017 mongo
    else
      echo "MongoDB container already exists. Starting..."
      docker start $CONTAINER_NAME
    fi
    echo "Entering MongoDB shell..."
    docker exec -it $CONTAINER_NAME mongosh
    ;;
  2)
    # MariaDB
    CONTAINER_NAME="lab_mariadb"
    if ! docker ps -a --format '{{.Names}}' | grep -q "^$CONTAINER_NAME$"; then
      echo "Starting MariaDB container..."
      docker run -d --name $CONTAINER_NAME -e MYSQL_ROOT_PASSWORD=labpass -p 3307:3306 mariadb
    else
      echo "MariaDB container already exists. Starting..."
      docker start $CONTAINER_NAME
    fi
    echo "Waiting for MariaDB to be ready..."
    until docker exec $CONTAINER_NAME mariadb -uroot -plabpass -e "SELECT 1" &>/dev/null; do
      sleep 1
    done
    echo "Entering MariaDB shell..."
    docker exec -it $CONTAINER_NAME mariadb -uroot -plabpass
    ;;
  3)
    # MySQL
    CONTAINER_NAME="lab_mysql"
    if ! docker ps -a --format '{{.Names}}' | grep -q "^$CONTAINER_NAME$"; then
      echo "Starting MySQL container..."
      docker run -d --name $CONTAINER_NAME -e MYSQL_ROOT_PASSWORD=labpass -p 3308:3306 mysql
    else
      echo "MySQL container already exists. Starting..."
      docker start $CONTAINER_NAME
    fi
    echo "Waiting for MySQL to be ready..."
    until docker exec $CONTAINER_NAME mysql -uroot -plabpass -e "SELECT 1" &>/dev/null; do
      sleep 1
    done
    echo "Entering MySQL shell..."
    docker exec -it $CONTAINER_NAME mysql -uroot -plabpass
    ;;
  4)
    # PostgreSQL
    CONTAINER_NAME="lab_postgres"
    if ! docker ps -a --format '{{.Names}}' | grep -q "^$CONTAINER_NAME$"; then
      echo "Starting PostgreSQL container..."
      docker run -d --name $CONTAINER_NAME -e POSTGRES_PASSWORD=labpass -p 5432:5432 postgres
    else
      echo "PostgreSQL container already exists. Starting..."
      docker start $CONTAINER_NAME
    fi
    echo "Waiting for PostgreSQL to be ready..."
    until docker exec $CONTAINER_NAME pg_isready -U postgres &>/dev/null; do
      sleep 1
    done
    echo "Entering PostgreSQL shell..."
    docker exec -it $CONTAINER_NAME psql -U postgres
    ;;
  5)
    # Redis
    CONTAINER_NAME="lab_redis"
    if ! docker ps -a --format '{{.Names}}' | grep -q "^$CONTAINER_NAME$"; then
      echo "Starting Redis container..."
      docker run -d --name $CONTAINER_NAME -p 6379:6379 redis
    else
      echo "Redis container already exists. Starting..."
      docker start $CONTAINER_NAME
    fi
    echo "Entering Redis CLI..."
    docker exec -it $CONTAINER_NAME redis-cli
    ;;
  6)
    # Neo4j
    CONTAINER_NAME="lab_neo4j"
    if ! docker ps -a --format '{{.Names}}' | grep -q "^$CONTAINER_NAME$"; then
      echo "Starting Neo4j container..."
      docker run -d --name $CONTAINER_NAME -e NEO4J_AUTH=neo4j/labpass -p 7474:7474 -p 7687:7687 neo4j
    else
      echo "Neo4j container already exists. Starting..."
      docker start $CONTAINER_NAME
    fi
    echo "Entering Neo4j Cypher shell..."
    docker exec -it $CONTAINER_NAME cypher-shell -u neo4j -p labpass
    ;;
  7)
    echo "Exiting."
    exit 0
    ;;
  *)
    echo "Invalid choice."
    exit 1
    ;;
esac