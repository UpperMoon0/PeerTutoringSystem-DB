FROM mcr.microsoft.com/mssql/server:2022-latest

USER root

ENV SA_PASSWORD=yourStrong(!)Password
ENV ACCEPT_EULA=Y

# Install prerequisites and mssql-tools
RUN apt-get update && apt-get install -y curl gnupg ca-certificates && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y mssql-tools18 unixodbc-dev

COPY db_scripts/ /db_scripts/
COPY --chmod=755 entrypoint.sh /entrypoint.sh

# The mssql user needs ownership of the scripts to run them
RUN chown -R mssql:mssql /db_scripts /entrypoint.sh

USER mssql

EXPOSE 1433

CMD ["/bin/bash", "/entrypoint.sh"]