#!/bin/bash
# Backup MySQL Database

echo "Enter MySQL database name:"
read db_name

echo "Enter MySQL username:"
read db_user

echo "Enter MySQL password:"
read -s db_pass

# Backup the database
mysqldump -u $db_user -p$db_pass $db_name > $db_name-backup.sql

echo "Database backup complete!"
