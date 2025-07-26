#!/bin/bash

run_initialization() {
  # Wait for 30 seconds for SQL Server to start
  echo "Waiting for SQL Server to start..."
  sleep 30

  echo "Running database initialization scripts..."
  # Run the init and seed scripts
  /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -d master -i /db_scripts/Init.sql
  /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -d master -i /db_scripts/SeedData.sql
  echo "Database initialization complete."
}

# Run the initialization in the background
run_initialization &

# Start the SQL Server process
exec /opt/mssql/bin/sqlservr