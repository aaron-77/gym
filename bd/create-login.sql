-- ============================================================================
-- SEGURIDAD DE LA APLICACIÓN - fitnessgymlogin / fitnessgymuser
-- ============================================================================
--
-- El respaldo (.bak) trae únicamente el USER de base de datos. Los logins nunca
-- viajan en un respaldo porque pertenecen al servidor y no a la base.
--
-- Este script cierra ese hueco creando el login, creando el user si el respaldo
-- no lo trae, y religando los dos. Es idempotente: se puede ejecutar más de una
-- vez sin producir errores, y se ejecuta SIEMPRE después del restore porque el
-- restore.sql usa IF NOT EXISTS y en un volumen ya poblado no restaura nada.
--
-- Se usa ALTER USER ... WITH LOGIN y no DROP USER + CREATE USER cuando el user
-- ya existe, porque el religado solo cambia la ligadura; un DROP USER borraría
-- los permisos que el respaldo trae adentro y habría que volver a concederlos.
--
-- El nombre del login es deliberadamente distinto al del user
-- (fitnessgymlogin vs fitnessgymuser), de modo que al inspeccionar
-- sys.server_principals y sys.database_principals se pueda distinguir de un
-- vistazo cuál es el login y cuál es el user.
--
-- La contraseña va como literal: el DDL de SQL Server no admite variables ni
-- siquiera dentro de sp_executesql ("CREATE LOGIN x WITH PASSWORD = @pwd"
-- revienta con "Incorrect syntax near '@pwd'"). Se escapan las comillas simples
-- duplicándolas, que es la única regla de una literal T-SQL.
--
-- PENDIENTE: la contraseña está escrita acá a propósito para que coincida con
-- la que declaran las connection strings de la aplicación. Es el mismo hueco de
-- secretos en claro que arrastran los docker-compose y los appsettings; cuando
-- se ataque ese tema, este script tiene que recibir el valor por variable de
-- entorno en lugar de literal.
-- ============================================================================


-- ============================================================================
-- PASO 1 - LOGIN (ámbito servidor)
-- ============================================================================
PRINT '[1/4] Creando login fitnessgymlogin (ámbito servidor)...';

IF EXISTS (SELECT 1 FROM sys.server_principals WHERE name = N'fitnessgymlogin')
BEGIN
    ALTER LOGIN [fitnessgymlogin] WITH PASSWORD = N'Terrabreak13';
    PRINT '       El login ya existía  -> contraseña actualizada.';
END
ELSE
BEGIN
    CREATE LOGIN [fitnessgymlogin]
        WITH PASSWORD           = N'Terrabreak13',
             DEFAULT_DATABASE    = [FitnessCenterDB],
             DEFAULT_LANGUAGE    = [Español],
             CHECK_POLICY        = OFF,
             CHECK_EXPIRATION    = OFF;
    PRINT '       Login creado nuevo.';
END

IF EXISTS (SELECT 1 FROM sys.server_principals WHERE name = N'fitnessgymlogin')
    PRINT '       [OK] fitnessgymlogin presente en sys.server_principals.';
ELSE
    PRINT '       [ERROR] fitnessgymlogin NO aparece tras el CREATE LOGIN.';


-- ============================================================================
-- PASO 2 - BASE DE DATOS
-- ============================================================================
PRINT '[2/4] Validando base FitnessCenterDB...';

-- Severidad 16 con sqlcmd -b aborta la ejecución y sale con código de error,
-- así que el bash captura el código y corta con exit 1. Sin esto el script
-- seguiría a ciegas contra master, intentando crear el user en el lugar
-- equivocado.
IF DB_ID(N'FitnessCenterDB') IS NULL
    RAISERROR('La base FitnessCenterDB no existe. El restore no corrió o falló.', 16, 1);
ELSE
BEGIN
    USE [FitnessCenterDB];
    PRINT '       Base FitnessCenterDB disponible.';


    -- ========================================================================
    -- PASO 3 - USER (ámbito base de datos) + religado
    -- ========================================================================
    PRINT '[3/4] Creando o religando user fitnessgymuser...';

    IF EXISTS (SELECT 1 FROM sys.database_principals
               WHERE name = N'fitnessgymuser' AND type = 'S')
    BEGIN
        -- El respaldo lo trajo: solo religar. No se tocan los permisos que trae
        -- adentro; se les respeta el estado que definieron en origen.
        ALTER USER [fitnessgymuser] WITH LOGIN = [fitnessgymlogin];
        PRINT '       El user ya existía  -> solo se religó al login.';
    END
    ELSE
    BEGIN
        -- El respaldo no lo trajo: crear ya ligado al login y conceder los
        -- mismos permisos mínimos que la aplicación necesita. Son los mismos
        -- que trae el respaldo actual y que declara fitnessgymuser.sql:
        -- SELECT/INSERT/UPDATE/DELETE/EXECUTE a nivel del esquema, no de la
        -- base, para no alcanzar esquemas ajenos.
        -- CONNECT no se declara acá: CREATE USER lo concede automáticamente.
        CREATE USER [fitnessgymuser] FOR LOGIN [fitnessgymlogin];
        GRANT CONNECT TO [fitnessgymuser];
        GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::[dbo] TO [fitnessgymuser];
        GRANT EXECUTE ON SCHEMA::[dbo] TO [fitnessgymuser];
        PRINT '       User creado, religado y con permisos concedidos.';
    END

    -- El cruce es por sid: un user no guarda el nombre del login, guarda su
    -- security identifier. Se chequea el estado resultante, no el comando:
    -- CREATE USER puede ejecutarse sin error y aun así no quedar religado.
    IF EXISTS (SELECT 1 FROM sys.database_principals dp
               JOIN sys.server_principals sp ON dp.sid = sp.sid
               WHERE dp.name = N'fitnessgymuser' AND sp.name = N'fitnessgymlogin')
        PRINT '       [OK] fitnessgymuser ligado a fitnessgymlogin.';
    ELSE
        PRINT '       [ERROR] fitnessgymuser NO quedó ligado a fitnessgymlogin.';


    -- ========================================================================
    -- PASO 4 - PERMISOS
    -- ========================================================================
    PRINT '[4/4] Verificando permisos sobre schema dbo...';

    -- major_id = 1 es el esquema dbo; major_id = 0 sería a nivel base.
    IF EXISTS (SELECT 1 FROM sys.database_permissions
               WHERE grantee_principal_id = DATABASE_PRINCIPAL_ID('fitnessgymuser')
                 AND permission_name = 'SELECT'
                 AND major_id = 1)
        PRINT '       [OK] fitnessgymuser con SELECT sobre schema dbo.';
    ELSE
        PRINT '       [ERROR] fitnessgymuser NO tiene SELECT sobre schema dbo.';

END
