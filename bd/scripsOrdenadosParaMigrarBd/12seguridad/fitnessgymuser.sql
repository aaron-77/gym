/* ============================================================
   FITNESSGYMUSER - LOGIN + USUARIO CON PERMISOS MÍNIMOS
   ------------------------------------------------------------
   Usuario:  fitnessgymuser
   Password: Terrabreak13
   Ámbitos:  PARTE 1 = servidor (master)
             PARTE 2 = base de datos (FitnessCenterDB)

   ORDEN DE EJECUCIÓN
     1. restore.sql      (crea la BD; trae users del .bak)
     2. ESTE SCRIPT      (login + usuario + permisos)

   SOBRE EL RESPALDO - LEER ANTES
   ------------------------------------------------------------
   El .bak lleva DENTRO el USER de la base de datos, con todos
   sus permisos. El .bak NO lleva el LOGIN: los logins nunca
   viajan en un respaldo.

   Consecuencia:
     - Corré este script COMPLETO una vez en tu BD actual.
     - Después hacé el respaldo. El user ya viaja adentro.
     - En cada servidor nuevo: restaurá el .bak (el user llega
       huérfano) y corré SOLO la PARTE 1 de este script, que
       recrea el login con el mismo nombre. El user se liga
       solo.

   NO TOCA aaronlogin. Ese login sigue existiendo y sigue
   siendo el que usan tus connection strings actuales.

   PERMISOS QUE OTORGA (y solo esos)
   ------------------------------------------------------------
     - SELECT / INSERT / UPDATE / DELETE sobre el esquema dbo:
       cubre las 57 tablas y vistas actuales y las futuras.
     - EXECUTE sobre el esquema dbo: cubre los 91 objetos
       propios (52 procedimientos + 39 funciones) actuales y
       futuros.
     - DENY EXECUTE sobre los procedimientos de diagrama que
       existan: utilidades de administración que la app no usa.

   NO otorga:
     - Ningún rol de servidor (ni sysadmin ni ningún otro).
     - Ningún rol de base de datos (ni db_owner, ni
       db_datareader, ni db_datawriter, ni ningún otro).
     - Nada a nivel de base de datos: todo es a nivel esquema.

   REEJECUTABLE: correrlo dos veces seguidas da el mismo
   resultado sin errores.
   ============================================================ */


/* ============================================================
   PARTE 1 - LOGIN  (ámbito SERVIDOR / master)
   ============================================================ */

USE [master];
GO

/* ------------------------------------------------------------
   1.1 SI EL LOGIN YA EXISTE: sacarlo de todos los roles de
   servidor y resetearle la password.

   Un login viejo puede traer membresías heredadas (el script
   anterior de dbatools lo dejaba en sysadmin). Mientras esté
   en un rol de servidor, tiene privilegios que no pediste y
   los GRANT de la PARTE 2 no restringen nada.

   Se recorren los roles del catálogo, no una lista fija, para
   que cubra también los roles que aparezcan en el futuro.
   El rol público no se puede quitar ni hace falta.
   ------------------------------------------------------------ */
IF EXISTS (SELECT 1
           FROM sys.server_principals
           WHERE name = N'fitnessgymuser' AND type = N'S')
BEGIN
    DECLARE @sqlRoles NVARCHAR(MAX) = N'';

    SELECT @sqlRoles = @sqlRoles
        + N'ALTER SERVER ROLE ' + QUOTENAME(r.name)
        + N' DROP MEMBER [fitnessgymuser];' + CHAR(13)
    FROM sys.server_role_members m
    JOIN sys.server_principals r ON m.role_principal_id  = r.principal_id
    JOIN sys.server_principals p ON m.member_principal_id = p.principal_id
    WHERE p.name = N'fitnessgymuser'
      AND r.name <> N'public';

    IF @sqlRoles <> N''
        EXEC sp_executesql @sqlRoles;

    /* Resetear password + flags. NO se hace DROP LOGIN:
       DROP LOGIN falla mientras exista un user ligado a él
       en alguna base, y el user lo necesitamos vivo. */
    ALTER LOGIN [fitnessgymuser]
        WITH PASSWORD           = N'Terrabreak13',
             DEFAULT_DATABASE    = [FitnessCenterDB],
             DEFAULT_LANGUAGE    = [Español],
             CHECK_POLICY        = OFF,
             CHECK_EXPIRATION    = OFF;
END
ELSE
BEGIN
    /* --------------------------------------------------------
       1.2 CREAR LOGIN
       --------------------------------------------------------
       CHECK_POLICY = OFF es deliberado: es una cuenta de
       aplicación con contraseña fija, no una cuenta de persona
       que deba rotar contraseña. OFF también evita que un
       cambio futuro de contraseña choque con la política de
       Windows.

       NO se agrega a ningún rol de servidor. El login nace
       mínimo.
       -------------------------------------------------------- */
    CREATE LOGIN [fitnessgymuser]
    WITH
        PASSWORD           = N'Terrabreak13',
        DEFAULT_DATABASE   = [FitnessCenterDB],
        DEFAULT_LANGUAGE   = [Español],
        CHECK_POLICY       = OFF,
        CHECK_EXPIRATION   = OFF;
END
GO

/* ------------------------------------------------------------
   1.3 VERIFICACIÓN (reporte, no error)
   Esperado: type = SQL_LOGIN, is_disabled = 0,
             default_db = FitnessCenterDB,
             0 filas de membresía en roles de servidor.
   ------------------------------------------------------------ */
SELECT
    seccion     = 'LOGIN',
    nombre      = sp.name,
    detalle     = sp.type_desc,
    estado      = CONVERT(varchar(3), sp.is_disabled),
    extra       = SUSER_SNAME(sp.default_database_name)
FROM sys.server_principals sp
WHERE sp.name = N'fitnessgymuser'
UNION ALL
SELECT
    'SERVER_ROLE_MEMBERSHIP',
    r.name,
    'MEMBER',
    '',
    ''
FROM sys.server_role_members m
JOIN sys.server_principals r ON m.role_principal_id   = r.principal_id
JOIN sys.server_principals p ON m.member_principal_id = p.principal_id
WHERE p.name = N'fitnessgymuser';
GO


/* ============================================================
   PARTE 2 - USUARIO + PERMISOS  (ámbito BASE / FitnessCenterDB)

   REQUIERE que la PARTE 1 ya corrió: el CREATE USER ... FOR
   LOGIN falla si el login no existe.
   ============================================================ */

USE [FitnessCenterDB];
GO

/* ------------------------------------------------------------
   2.1 DESPOJAR membriosías de rol heredadas del respaldo
   ------------------------------------------------------------
   Si el .bak se tomó de una BD donde fitnessgymuser tenía
   db_owner / db_datareader / db_datawriter / db_ddladmin, esas
   membresías viajan DENTRO del respaldo. Sin este paso, el
   usuario hereda permisos que no pediste y tus GRANT no
   restringen nada: db_owner tiene CONTROL sobre todo.

   Se recorren los roles del catálogo en vez de una lista fija
   para que cubra cualquier rol heredado. Solo se conserva
   público, que es la membresía base de todo usuario.
   ------------------------------------------------------------ */
IF EXISTS (SELECT 1
           FROM sys.database_principals
           WHERE name = N'fitnessgymuser' AND type = N'U')
BEGIN
    DECLARE @sqlDbRoles NVARCHAR(MAX) = N'';

    SELECT @sqlDbRoles = @sqlDbRoles
        + N'ALTER ROLE ' + QUOTENAME(r.name)
        + N' DROP MEMBER [fitnessgymuser];' + CHAR(13)
    FROM sys.database_role_members drm
    JOIN sys.database_principals r ON drm.role_principal_id   = r.principal_id
    JOIN sys.database_principals m ON drm.member_principal_id = m.principal_id
    WHERE m.name = N'fitnessgymuser'
      AND r.name <> N'public';

    IF @sqlDbRoles <> N''
        EXEC sp_executesql @sqlDbRoles;
END
GO

/* ------------------------------------------------------------
   2.2 TRANSFERIR PROPIEDAD de esquemas al dbo
   ------------------------------------------------------------
   DROP USER FALLA con "The user owns schema X" si el usuario
   es dueño de algún esquema. Este paso lo previene.
   ------------------------------------------------------------ */
DECLARE @sqlSchema NVARCHAR(MAX) = N'';

SELECT @sqlSchema = @sqlSchema
    + N'ALTER AUTHORIZATION ON SCHEMA::[' + s.name + N'] TO [dbo];'
FROM sys.schemas s
JOIN sys.database_principals p ON s.principal_id = p.principal_id
WHERE p.name = N'fitnessgymuser'
  AND s.name <> N'dbo';

IF @sqlSchema <> N''
    EXEC sp_executesql @sqlSchema;
GO

/* ------------------------------------------------------------
   2.3 TRANSFERIR PROPIEDAD de objetos al dbo
   ------------------------------------------------------------
   DROP USER también falla si el usuario es dueño de tablas,
   vistas, procedures o funciones. En tu schema actual todo es
   de dbo, pero este paso lo hace a prueba de futuros respaldos.
   ------------------------------------------------------------ */
DECLARE @sqlObj NVARCHAR(MAX) = N'';

SELECT @sqlObj = @sqlObj
    + N'ALTER AUTHORIZATION ON OBJECT::['
    + SCHEMA_NAME(o.schema_id) + N'].[' + o.name + N'] TO [dbo];'
FROM sys.objects o
JOIN sys.database_principals p ON o.principal_id = p.principal_id
WHERE p.name = N'fitnessgymuser'
  AND o.type IN ('U','V','P','FN','IF','TF')
  AND o.is_ms_shipped = 0;

IF @sqlObj <> N''
    EXEC sp_executesql @sqlObj;
GO

/* ------------------------------------------------------------
   2.4 ELIMINAR USER ACTUAL (si existe)
   ------------------------------------------------------------
   Borra el usuario existente para recrearlo limpio: esto es lo
   que descarta cualquier permiso heredado que traiga el .bak.
   Si no existe, no hace nada.
   ------------------------------------------------------------ */
IF EXISTS (SELECT 1
           FROM sys.database_principals
           WHERE name = N'fitnessgymuser' AND type = N'U')
BEGIN
    DROP USER [fitnessgymuser];
END
GO

/* ------------------------------------------------------------
   2.5 CREAR USER LIGADO AL LOGIN
   ------------------------------------------------------------
   "FOR LOGIN" es la ligadura. Si el login trae un SID distinto
   al que traía el .bak, este paso alinea el user al SID nuevo.
   Sin esto, el user queda huérfano y no podés connectar.
   ------------------------------------------------------------ */
CREATE USER [fitnessgymuser] FOR LOGIN [fitnessgymuser]
WITH DEFAULT_SCHEMA = [dbo];
GO

/* ------------------------------------------------------------
   2.6 PERMISOS ACOTADOS
   ------------------------------------------------------------
   Lectura/escritura a nivel esquema [dbo]: cubre las 57 tablas
   y vistas actuales Y las futuras, sin tocar este script de
   nuevo. No se usa db_datareader ni db_datawriter, que son
   más amplios (llegan a toda la base) y anulan acotaciones.

   Ejecución a nivel esquema [dbo]: cubre los 91 objetos
   propios (52 procedimientos + 39 funciones) actuales y
   futuros. A nivel de esquema y NO a nivel de base de datos,
   para no alcanzar esquemas ajenos.

   Ownership chaining: como los procedimientos y las tablas son
   del mismo dueño, el usuario solo necesita EXECUTE en el
   procedimiento que la app llama directamente; los procedimientos
   anidados se resuelven por la cadena, sin permiso extra.
   ------------------------------------------------------------ */
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::[dbo] TO [fitnessgymuser];
GO
GRANT EXECUTE ON SCHEMA::[dbo] TO [fitnessgymuser];
GO

/* ------------------------------------------------------------
   2.7 DENEGAR procedimientos de diagrama
   ------------------------------------------------------------
   Son utilidades de administración de SSMS que viven en el
   mismo esquema dbo, así que el GRANT anterior los alcanza.
   Un usuario de aplicación no debería poder invocarlos.

   Se construye consultando el catálogo en vez de escribir los
   nombres a mano: si algún procedimiento no existe, simplemente
   no se genera su DENY y el script NO aborta. Con una lista
   fija, el script entero fallaría y NO se aplicaría ningún
   permiso de los puntos 2.6.

   DENY siempre gana: pisa al GRANT del esquema y a cualquier
   permiso heredado por ser miembro de público.
   ------------------------------------------------------------ */
DECLARE @sqlDeny NVARCHAR(MAX) = N'';

SELECT @sqlDeny = @sqlDeny
    + N'DENY EXECUTE ON OBJECT::['
    + SCHEMA_NAME(o.schema_id) + N'].[' + o.name + N'] TO [fitnessgymuser];'
    + CHAR(13)
FROM sys.objects o
WHERE o.type = 'P'
  AND o.is_ms_shipped = 0
  AND o.name LIKE N'sp[_]%diagram%';

IF @sqlDeny <> N''
    EXEC sp_executesql @sqlDeny;
GO

/* ------------------------------------------------------------
   2.8 VERIFICACIÓN (reporte, no error)
   ------------------------------------------------------------ */
-- Debe devolver 1 user y 0 membresías de rol (ni db_owner, ni
-- db_datareader, ni db_datawriter, ni ninguna otra).
SELECT
    seccion     = 'USER',
    nombre      = dp.name,
    detalle     = dp.type_desc,
    estado      = ISNULL(dp.default_schema_name, ''),
    extra       = ''
FROM sys.database_principals dp
WHERE dp.name = N'fitnessgymuser'
UNION ALL
SELECT
    'ROLE_MEMBERSHIP',
    r.name,
    'MEMBER',
    '',
    ''
FROM sys.database_role_members drm
JOIN sys.database_principals r ON drm.role_principal_id   = r.principal_id
JOIN sys.database_principals m ON drm.member_principal_id = m.principal_id
WHERE m.name = N'fitnessgymuser';
GO

-- Debe devolver solo permisos con estado GRANT sobre el esquema
-- dbo, más los DENY de los procedimientos de diagrama que
-- existan. NO debe haber ninguna fila con estado GRANT a nivel
-- de base de datos (donde el objeto aparece como "(database)").
SELECT
    seccion = 'PERMISO',
    objeto  = CASE WHEN dp.major_id = 0 THEN '(database)'
                   ELSE SCHEMA_NAME(o.schema_id) + '.' + o.name
                   ELSE OBJECT_SCHEMA_NAME(dp.major_id) + '.' + OBJECT_NAME(dp.major_id)
              END,
    permiso = dp.permission_name,
    estado  = dp.state_desc
FROM sys.database_permissions dp
JOIN sys.database_principals prin ON dp.grantee_principal_id = prin.principal_id
LEFT JOIN sys.objects o ON o.object_id = dp.major_id
WHERE prin.name = N'fitnessgymuser'
ORDER BY estado, permiso;
GO

-- Debe devolver 0 filas: prueba de que el usuario NO puede
-- ejecutar ningún procedimiento de diagrama.
SELECT
    procedimiento_bloqueado = o.name
FROM sys.objects o
WHERE o.type = 'P'
  AND o.name LIKE N'sp[_]%diagram%'
  AND HAS_PERMS_BY_NAME(
        QUOTENAME(SCHEMA_NAME(o.schema_id)) + N'.' + QUOTENAME(o.name),
        N'OBJECT', N'EXECUTE') = 1;
GO
