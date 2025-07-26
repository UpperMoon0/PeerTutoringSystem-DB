#!/bin/bash

# Start the SQL Server process in the background
gosu mssql /opt/mssql/bin/sqlservr &

# Wait for SQL Server to start
echo "Waiting for SQL Server to start..."
sleep 30

# Run the initialization scripts
echo "Running database initialization scripts..."
gosu mssql /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -i /db_scripts/Init.sql
gosu mssql /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -i /db_scripts/SeedData.sql
echo "Database initialization complete."

# Keep the container running
wait