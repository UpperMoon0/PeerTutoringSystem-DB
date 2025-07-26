#!/bin/bash

# Start the SQL Server process in the background
/opt/mssql/bin/sqlservr &
SQL_SERVER_PID=$!

# Wait for SQL Server to be ready
echo "Waiting for SQL Server to start..."
for i in {1..50};
do
    /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -Q "SELECT 1" > /dev/null 2>&1
    if [ $? -eq 0 ]
    then
        echo "SQL Server is up"
        # Run the initialization scripts
        echo "Running database initialization scripts..."
        /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -i /db_scripts/Init.sql
        /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -i /db_scripts/SeedData.sql
        echo "Database initialization complete."
        break
    else
        echo "Not ready yet..."
        sleep 2
    fi
done

# Wait for the SQL Server process to exit
wait $SQL_SERVER_PID