#!/bin/bash
set -e
sudo apt update && sudo apt install -y postgresql-client
pg_dump -U postgres dbname > backup.sql
psql -U postgres newdb < backup.sql
