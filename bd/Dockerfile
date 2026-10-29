# 1. Utilizar la imagen oficial de SQL Server 2022 de Microsoft
FROM mcr.microsoft.com/mssql/server:2022-latest

# 2. Cambiar temporalmente a usuario root para crear directorios y dar permisos
USER root

# 3. Crear los directorios internos necesarios dentro del contenedor
RUN mkdir -p /usr/config /var/opt/mssql/backups /var/opt/mssql/data /var/opt/mssql/log

# 4. Copiar los scripts de orquestación y el respaldo distribuible de la base.
#    Las contraseñas no se hornean: llegan al arrancar por variables de entorno.
COPY restore.sql /usr/config/restore.sql
COPY entrypoint.sh /usr/config/entrypoint.sh
COPY configure-db.sh /usr/config/configure-db.sh
COPY FitnessGymDB.bak /var/opt/mssql/backups/FitnessGymDB.bak

# 5. Otorgar permisos de ejecución a TODOS los scripts de Bash y ajustar propiedad de carpetas
RUN chmod +x /usr/config/entrypoint.sh /usr/config/configure-db.sh && \
    chown -R mssql:root /var/opt/mssql /usr/config

# 6. Regresar al usuario por defecto 'mssql' por seguridad
USER mssql

# 7. Healthcheck: FitnessCenterDB responde solo cuando termina su recovery.
#    Queda embebido en la imagen; los tests esperan UntilContainerIsHealthy().
#    -C: confía el certificado self-signed; -b: exit != 0 en error (lo exige el healthcheck).
HEALTHCHECK --interval=5s --timeout=5s --start-period=30s --retries=12 \
    CMD /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -C -b -d FitnessCenterDB -Q "SELECT 1" || exit 1

# 8. Definir el punto de entrada que coordinará la ejecución al arrancar el contenedor
ENTRYPOINT ["/usr/config/entrypoint.sh"]
