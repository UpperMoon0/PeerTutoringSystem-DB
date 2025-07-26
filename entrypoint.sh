#!/bin/bash

# Start SQL Server in the background
/opt/mssql/bin/sqlservr &

# Wait for SQL Server to be ready
sleep 30

# Check if the database has already been seeded
if [ ! -f /var/opt/mssql/reseed_done.flag ]; then
    # Run the init and seed scripts
    /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -d master -i /db_scripts/Init.sql
    /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -d master -i /db_scripts/SeedData.sql

    # Create a flag file to indicate that seeding is done
    touch /var/opt/mssql/reseed_done.flag
fi

# Keep the container running
tail -f /dev/null