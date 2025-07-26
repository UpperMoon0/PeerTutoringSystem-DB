#!/bin/bash
set -e

# Start SQL Server
/opt/mssql/bin/sqlservr &

# Wait for SQL Server to start
sleep 15

# Run the initialization and seeding scripts only if they haven't been run before
if [ ! -f /var/opt/mssql/data/initialized.flag ]; then
    /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "Password123!" -i /db_scripts/Init.sql -N -C
    /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "Password123!" -i /db_scripts/SeedData.sql -N -C
    touch /var/opt/mssql/data/initialized.flag
fi

# Keep the container running
wait