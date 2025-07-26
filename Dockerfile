FROM mcr.microsoft.com/mssql/server:2022-latest

ENV SA_PASSWORD=yourStrong(!)Password
ENV ACCEPT_EULA=Y

COPY db_scripts/ /db_scripts/
COPY --chmod=755 entrypoint.sh /entrypoint.sh

EXPOSE 1433

CMD ["/bin/bash", "/entrypoint.sh"]