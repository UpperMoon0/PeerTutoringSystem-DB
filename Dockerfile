FROM mcr.microsoft.com/mssql/server:2022-latest

ENV SA_PASSWORD=yourStrong(!)Password
ENV ACCEPT_EULA=Y

COPY db_scripts/ /db_scripts/
COPY entrypoint.sh /entrypoint.sh

EXPOSE 1433

RUN chmod +x /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]