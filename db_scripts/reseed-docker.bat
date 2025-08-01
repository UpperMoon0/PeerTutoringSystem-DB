@echo off
setlocal

REM Configuration
set CONTAINER_NAME=mssql-server
set DB_SERVER=localhost
set DB_USER=sa
set DB_PASSWORD=Password123!
set SCRIPT_DIR=%~dp0
set INIT_SCRIPT=Init.sql
set SEED_SCRIPT=SeedData.sql
set INIT_SCRIPT_PATH="%SCRIPT_DIR%%INIT_SCRIPT%"
set SEED_SCRIPT_PATH="%SCRIPT_DIR%%SEED_SCRIPT%"

REM Check if reseed has already been done
docker exec %CONTAINER_NAME% test -f /var/opt/mssql/reseed_done.flag
if %ERRORLEVEL% equ 0 (
    echo Reseed has already been performed. Skipping.
    goto :eof
)

REM Create scripts directory in container
docker exec -i %CONTAINER_NAME% mkdir -p /var/opt/mssql/scripts

REM Copy scripts to container
docker cp %INIT_SCRIPT_PATH% "%CONTAINER_NAME%:/var/opt/mssql/scripts/%INIT_SCRIPT%"
docker cp %SEED_SCRIPT_PATH% "%CONTAINER_NAME%:/var/opt/mssql/scripts/%SEED_SCRIPT%"

REM Clear caches
echo Clearing SQL Server caches...
docker exec -i %CONTAINER_NAME% /opt/mssql-tools18/bin/sqlcmd -U %DB_USER% -P %DB_PASSWORD% -Q "DBCC DROPCLEANBUFFERS;" -C -N
docker exec -i %CONTAINER_NAME% /opt/mssql-tools18/bin/sqlcmd -U %DB_USER% -P %DB_PASSWORD% -Q "DBCC FREEPROCCACHE;" -C -N

REM Execute scripts
docker exec -i %CONTAINER_NAME% /opt/mssql-tools18/bin/sqlcmd -U %DB_USER% -P %DB_PASSWORD% -i "/var/opt/mssql/scripts/%INIT_SCRIPT%" -C -N
docker exec -i %CONTAINER_NAME% /opt/mssql-tools18/bin/sqlcmd -U %DB_USER% -P %DB_PASSWORD% -i "/var/opt/mssql/scripts/%SEED_SCRIPT%" -C -N

REM Create a flag file to indicate that reseed is done
docker exec -i %CONTAINER_NAME% touch /var/opt/mssql/reseed_done.flag

echo Database reseeding complete.

:eof
endlocal