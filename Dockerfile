FROM mcr.microsoft.com/mssql/server:2022-latest

USER root

ENV SA_PASSWORD=yourStrong(!)Password
ENV ACCEPT_EULA=Y

# Install prerequisites and mssql-tools
# The base image already contains the microsoft prod repo, so we don't need to add it again.
RUN apt-get update && apt-get install -y curl gnupg ca-certificates gosu dos2unix && \
    ACCEPT_EULA=Y apt-get install -y mssql-tools18 unixodbc-dev

COPY db_scripts/ /db_scripts/
# The mssql user needs ownership of the database scripts to run them
RUN chown -R mssql:mssql /db_scripts

# Add execute permission to the sqlservr binary
RUN chown -R mssql:mssql /opt/mssql && chmod -R 750 /opt/mssql

USER mssql

EXPOSE 1433

CMD ["/opt/mssql/bin/sqlservr"]