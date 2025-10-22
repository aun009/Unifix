#!/bin/bash
# Pull and Run Database Containers

echo "Available Databases:"
echo "1. MySQL"
echo "2. PostgreSQL"
echo "3. MongoDB"
echo "4. SQLite"
echo "5. Redis"

echo "Enter the number of the database you want to run:"
read db_choice

case $db_choice in
  1)
    docker pull mysql:latest
    docker run --name mysql-container -e MYSQL_ROOT_PASSWORD=root -d mysql:latest
    echo "MySQL container is running!"
    ;;
  2)
    docker pull postgres:latest
    docker run --name postgres-container -e POSTGRES_PASSWORD=root -d postgres:latest
    echo "PostgreSQL container is running!"
    ;;
  3)
    docker pull mongo:latest
    docker run --name mongo-container -d mongo:latest
    echo "MongoDB container is running!"
    ;;
  4)
    docker pull nouchka/sqlite3:latest
    docker run --name sqlite-container -v sqlite-db:/db -d nouchka/sqlite3
    echo "SQLite container is running!"
    ;;
  5)
    docker pull redis:latest
    docker run --name redis-container -d redis:latest
    echo "Redis container is running!"
    ;;
  *)
    echo "Invalid choice!"
    ;;
esac
