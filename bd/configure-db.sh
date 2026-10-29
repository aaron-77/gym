#!/bin/bash

# Activar modo de depuración para ver cada paso en 'docker logs'
set -x

DBSTATUS=1
ERRCODE=1
i=0

echo "Iniciando verificación de SQL Server..."

# Esperar mientras: no haya agotado el tiempo Y (sqlcmd falle O alguna BD siga sin ONLINE)
# Salir solo cuando ERRCODE=0 (conectó) Y DBSTATUS=0 (todas las BDs online), o al timeout.
while [[ $i -lt 60 ]] && [[ $DBSTATUS -ne 0 || $ERRCODE -ne 0 ]]; do
	i=$((i+1))
	# Se agregan comillas a $SA_PASSWORD y la bandera -C
	DBSTATUS=$(/opt/mssql-tools18/bin/sqlcmd -h -1 -t 1 -U sa -P "$MSSQL_SA_PASSWORD" -C -Q "SET NOCOUNT ON; SELECT SUM(state) FROM sys.databases")
	ERRCODE=$?
	echo "loop $i"
	# Si DBSTATUS devuelve vacío durante el arranque, forzamos un valor numérico
	if [ -z "$DBSTATUS" ]; then
		echo "revisando db status vacio"
		DBSTATUS=1
	fi
	
	sleep 1
done

echo "Validando estatus de sql server despues de loop de verificacion de estados de bases de datos del sistema"
if [ "$DBSTATUS" -ne 0 ] || [ "$ERRCODE" -ne 0 ]; then 
	echo "ERROR: SQL Server tardó más de 60 segundos en iniciar o alguna base de datos no está ONLINE."
	exit 1
fi

echo "SQL Server está ONLINE. Ejecutando script de restauración..."

# Ejecutar el script de restauración si el respaldo incluido en la imagen existe.
# Si no está, el volumen ya está poblado o es un arranque sin datos: no es un error.
if [ -s /var/opt/mssql/backups/FitnessGymDB.bak ]; then
	/opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -C -d master -i /usr/config/restore.sql -b

	if [ $? -eq 0 ]; then
		echo "Restauración de la base de datos completada exitosamente."
	else
		echo "ERROR al ejecutar restore.sql."
		exit 1
	fi
else
	echo "Sin respaldo en /var/opt/mssql/backups/ - saltando restore (volumen ya poblado o arranque limpio)."
fi

# Esperar a que la base responda antes de tocarla. El loop de arriba valida
# SUM(state) FROM sys.databases, que devuelve 0 (todas ONLINE) pero NO
# garantiza que el servidor terminó su inicialización. Si se ejecuta un USE
# dentro de esa ventana, SQL Server responde con el error 904 "Database cannot
# be autostarted during server shutdown or startup". Abrir la base desde acá,
# con reintento, evita correr el script de login contra un servidor a medio
# arrancar.
echo "Esperando a que FitnessCenterDB responda..."

i=0
while [[ $i -lt 60 ]]; do
	if /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -C -d FitnessCenterDB -Q "SET NOCOUNT ON; SELECT 1" >/dev/null 2>&1; then
		break
	fi
	i=$((i+1))
	sleep 1
done

if [[ $i -ge 60 ]]; then
	echo "ERROR: FitnessCenterDB no respondió después de 60 segundos."
	exit 1
fi

echo "FitnessCenterDB responde. Ejecutando script de login..."

# La password del login de aplicación llega por env var (inyectada por compose
# como MSSQL_APP_LOGIN_PASSWORD, ver bd/docker-compose.template.yml). sqlcmd
# sustituye $(APP_LOGIN_PASSWORD) ANTES de parsear el T-SQL, por lo que la
# limitación del DDL con SQL dinámico no aplica.
# Fallo temprano y explícito si el compose no la inyecta.
if [ -z "$MSSQL_APP_LOGIN_PASSWORD" ]; then
	echo "ERROR: MSSQL_APP_LOGIN_PASSWORD no está definida (el compose debe inyectarla)."
	exit 1
fi

# Crear el login de aplicación y religar el user que el respaldo trae.
# Se ejecuta SIEMPRE, sin condicionarse a que el restore haya ocurrido: el
# restore.sql usa IF NOT EXISTS y en un volumen ya poblado no restaura nada,
# pero el login puede seguir sin existir.
# La invocación corre con set +x: este script arranca con set -x y docker logs
# imprimiría la password si viajara en la línea de comando visible del xtrace.
# RET guarda el exit code porque $? se pierde al reactivar set -x.
{ set +x
	/opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$MSSQL_SA_PASSWORD" \
		-C -d master \
		-v APP_LOGIN_PASSWORD="$MSSQL_APP_LOGIN_PASSWORD" \
		-i /usr/config/create-login.sql -b
	RET=$?
	set -x
}

if [ "$RET" -eq 0 ]; then
	echo "Login de aplicación creado y religado correctamente."
else
	echo "ERROR al ejecutar create-login.sql."
	exit 1
fi
