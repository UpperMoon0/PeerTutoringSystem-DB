#!/bin/bash
set -e

# Start SQL Server
/opt/mssql/bin/sqlservr &
SQL_SERVER_PID=$!

# Wait for SQL Server to start
DB_UP=false
for i in {1..30};
do
    /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "Password123!" -Q "SELECT 1"
    if [ $? -eq 0 ]
    then
        echo "SQL Server is up"
        DB_UP=true
        break
    else
        echo "Waiting for SQL Server to start..."
        sleep 2
    fi
done

if [ "$DB_UP" = false ]; then
    echo "SQL Server failed to start. Exiting."
    exit 1
fi

# Run the initialization and seeding scripts only if they haven't been run before
if [ ! -f /var/opt/mssql/data/initialized.flag ]; then
    echo "Running initialization scripts..."
    /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "Password123!" -i /db_scripts/Init.sql -N -C
    /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "Password123!" -i /db_scripts/SeedData.sql -N -C
    touch /var/opt/mssql/data/initialized.flag
    echo "Initialization complete."
fi

# Keep the container running by waiting on the SQL Server process
wait $SQL_SERVER_PID