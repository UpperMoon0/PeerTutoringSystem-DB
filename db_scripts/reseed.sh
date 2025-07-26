#!/bin/bash

# Configuration
DB_USER="sa"
DB_PASSWORD="12345"
DB_SERVER="localhost"
SCRIPT_DIR=$(dirname "$0")
INIT_SCRIPT="Init.sql"
SEED_SCRIPT="SeedData.sql"
INIT_SCRIPT_PATH="$SCRIPT_DIR/$INIT_SCRIPT"
SEED_SCRIPT_PATH="$SCRIPT_DIR/$SEED_SCRIPT"

# Check if SQL scripts exist
if [ ! -f "$INIT_SCRIPT_PATH" ]; then
    echo "ERROR: $INIT_SCRIPT not found in $SCRIPT_DIR"
    exit 1
fi
if [ ! -f "$SEED_SCRIPT_PATH" ]; then
    echo "ERROR: $SEED_SCRIPT not found in $SCRIPT_DIR"
    exit 1
fi

# Clear caches
echo "Clearing SQL Server caches..."
/opt/mssql-tools18/bin/sqlcmd -S $DB_SERVER -U $DB_USER -P $DB_PASSWORD -Q "DBCC DROPCLEANBUFFERS;" -C -N
/opt/mssql-tools18/bin/sqlcmd -S $DB_SERVER -U $DB_USER -P $DB_PASSWORD -Q "DBCC FREEPROCCACHE;" -C -N

# Execute scripts
echo "Executing initialization script: $INIT_SCRIPT"
/opt/mssql-tools18/bin/sqlcmd -S $DB_SERVER -U $DB_USER -P $DB_PASSWORD -i "$INIT_SCRIPT_PATH" -C -N

if [ $? -ne 0 ]; then
    echo "ERROR: Failed to execute $INIT_SCRIPT"
    exit 1
fi

echo "Executing data seeding script: $SEED_SCRIPT"
/opt/mssql-tools18/bin/sqlcmd -S $DB_SERVER -U $DB_USER -P $DB_PASSWORD -i "$SEED_SCRIPT_PATH" -C -N

if [ $? -ne 0 ]; then
    echo "ERROR: Failed to execute $SEED_SCRIPT"
    exit 1
fi

echo "Database reseeding complete."