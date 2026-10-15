# 1. Utilizar la imagen oficial de SQL Server 2022 de Microsoft
FROM mcr.microsoft.com/mssql/server:2022-latest

# 2. Cambiar temporalmente a usuario root para crear directorios y dar permisos
USER root

# 3. Crear los directorios internos necesarios dentro del contenedor
RUN mkdir -p /usr/config /var/opt/mssql/backups /var/opt/mssql/data /var/opt/mssql/log

# 4. Copiar los scripts y el archivo de respaldo desde tu máquina local al contenedor
COPY restore.sql /usr/config/restore.sql
COPY create-login.sql /usr/config/create-login.sql
COPY entrypoint.sh /usr/config/entrypoint.sh
COPY configure-db.sh /usr/config/configure-db.sh
COPY FitnessGymDB.bak /var/opt/mssql/backups/FitnessGymDB.bak

# 5. Otorgar permisos de ejecución a TODOS los scripts de Bash y ajustar propiedad de carpetas
RUN chmod +x /usr/config/entrypoint.sh /usr/config/configure-db.sh && \
    chown -R mssql:root /var/opt/mssql /usr/config

# 6. Regresar al usuario por defecto 'mssql' por seguridad
USER mssql

# 7. Definir el punto de entrada que coordinará la ejecución al arrancar el contenedor
ENTRYPOINT ["/usr/config/entrypoint.sh"]