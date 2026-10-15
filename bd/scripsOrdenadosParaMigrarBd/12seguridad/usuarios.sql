/* ============================================================
   USUARIOS - aaronlogin (ÁMBITO: BASE DE DATOS / FitnessCenterDB)
   ------------------------------------------------------------
   Orden de ejecución:
     1. restore.sql          (crea la BD y los users del .bak)
     2. login.sql            (crea el login en master)
     3. ESTE SCRIPT          (elimina user, lo recrea ligado,
                              da permisos acotados)

   REQUIERE que login.sql ya corrió. Si no, el
   CREATE USER ... FOR LOGIN falla porque el login no existe.
   ============================================================ */

USE [FitnessCenterDB];
GO

/* ------------------------------------------------------------
   1. DESPOJAR privilegios heredados
   ------------------------------------------------------------
   Si el .bak se tomó de una BD donde aaronlogin tenía
   db_owner / db_datareader / db_datawriter, esas membresías
   viajan DENTRO del respaldo. Sin este paso, el usuario
   hereda permisos que no pediste y tus GRANT no restringen
   nada (db_owner tiene CONTROL sobre todo).

   Se hace ANTES del DROP USER por claridad; DROP USER ya
   las borra, pero esto deja la intención explícita y sirve
   si algún día el script corre sin el DROP.
   ------------------------------------------------------------ */
IF EXISTS (SELECT 1 FROM sys.database_role_members drm
           JOIN sys.database_principals r ON drm.role_principal_id = r.principal_id
           JOIN sys.database_principals m ON drm.member_principal_id  = m.principal_id
           WHERE r.name = N'db_owner' AND m.name = N'aaronlogin')
    ALTER ROLE [db_owner] DROP MEMBER [aaronlogin];
GO

IF EXISTS (SELECT 1 FROM sys.database_role_members drm
           JOIN sys.database_principals r ON drm.role_principal_id = r.principal_id
           JOIN sys.database_principals m ON drm.member_principal_id  = m.principal_id
           WHERE r.name = N'db_datareader' AND m.name = N'aaronlogin')
    ALTER ROLE [db_datareader] DROP MEMBER [aaronlogin];
GO

IF EXISTS (SELECT 1 FROM sys.database_role_members drm
           JOIN sys.database_principals r ON drm.role_principal_id = r.principal_id
           JOIN sys.database_principals m ON drm.member_principal_id  = m.principal_id
           WHERE r.name = N'db_datawriter' AND m.name = N'aaronlogin')
    ALTER ROLE [db_datawriter] DROP MEMBER [aaronlogin];
GO

/* ------------------------------------------------------------
   2. TRANSFERIR PROPIEDAD de esquemas al dbo
   ------------------------------------------------------------
   DROP USER FALLA con "The user owns schema X" si el usuario
   es dueño de algún esquema. Este paso lo previene.
   ------------------------------------------------------------ */
DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql = @sql + N'ALTER AUTHORIZATION ON SCHEMA::[' + s.name + N'] TO [dbo];'
FROM sys.schemas s
JOIN sys.database_principals p ON s.principal_id = p.principal_id
WHERE p.name = N'aaronlogin' AND s.name <> N'dbo';

IF @sql <> N''
    EXEC sp_executesql @sql;
GO

/* ------------------------------------------------------------
   3. TRANSFERIR PROPIEDAD de objetos al dbo
   ------------------------------------------------------------
   DROP USER también falla si el usuario es dueño de tablas,
   vistas, procedures o funciones. En tu schema actual todo es
   de dbo (57 tablas, 0 triggers), pero este paso lo hace
   a prueba de futuras respaldos.
   ------------------------------------------------------------ */
DECLARE @sqlObj NVARCHAR(MAX) = N'';

SELECT @sqlObj = @sqlObj +
    N'ALTER AUTHORIZATION ON ' +
    CASE o.type
        WHEN 'U'  THEN N'OBJECT::'
        WHEN 'V'  THEN N'VIEW::'
        WHEN 'P'  THEN N'OBJECT::'
        WHEN 'FN' THEN N'OBJECT::'
        WHEN 'IF' THEN N'OBJECT::'
        WHEN 'TF' THEN N'OBJECT::'
        ELSE N'OBJECT::'
    END + N'[' + SCHEMA_NAME(o.schema_id) + N'].[' + o.name + N'] TO [dbo];'
FROM sys.objects o
JOIN sys.database_principals p ON o.principal_id = p.principal_id
WHERE p.name = N'aaronlogin'
  AND o.type IN ('U','V','P','FN','IF','TF')
  AND o.is_ms_shipped = 0;

IF @sqlObj <> N''
    EXEC sp_executesql @sqlObj;
GO

/* ------------------------------------------------------------
   4. ELIMINAR USER ACTUAL
   ------------------------------------------------------------
   Esto es lo que pediste: borrar el usuario existente para
   recrearlo limpio. Si no existe, no hace nada.
   ------------------------------------------------------------ */
IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'aaronlogin' AND type = N'U')
BEGIN
    DROP USER [aaronlogin];
END
GO

/* ------------------------------------------------------------
   5. CREAR USER LIGADO AL LOGIN
   ------------------------------------------------------------
   "FOR LOGIN" es la ligadura. Si el login trae un SID
   distinto al que traía el .bak, este paso alinea el user
   al SID nuevo. Sin esto, el user queda huérfano.
   ------------------------------------------------------------ */
CREATE USER [aaronlogin] FOR LOGIN [aaronlogin]
WITH DEFAULT_SCHEMA = [dbo];
GO

/* ------------------------------------------------------------
   6. PERMISOS ACOTADOS
   ------------------------------------------------------------
   SELECT/INSERT/UPDATE/DELETE a nivel esquema [dbo]:
   cubre las 57 tablas y vistas actuales Y las futuras, sin
   tocar este script de nuevo.

   EXECUTE a nivel base de datos:
   cubre los 34 procedimientos almacenados + funciones,
   actuales y futuros.
   ------------------------------------------------------------ */
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::[dbo] TO [aaronlogin];
GO
GRANT EXECUTE TO [aaronlogin];
GO

/* ------------------------------------------------------------
   7. VERIFICACIÓN (reporte, no error)
   ------------------------------------------------------------
   Esperado: 1 user, 0 membresías de rol, permisos acotados.
   ------------------------------------------------------------ */
SELECT
    seccion     = 'USER',
    nombre      = dp.name,
    tipo        = dp.type_desc,
    esquema_def = dp.default_schema_name
FROM sys.database_principals dp
WHERE dp.name = N'aaronlogin'
UNION ALL
SELECT
    'ROLE_MEMBERSHIP',
    r.name,
    'MEMBER',
    ''
FROM sys.database_role_members drm
JOIN sys.database_principals r ON drm.role_principal_id = r.principal_id
JOIN sys.database_principals m ON drm.member_principal_id  = m.principal_id
WHERE m.name = N'aaronlogin';
GO

SELECT
    seccion = 'PERMISO',
    objeto  = CASE WHEN dp.permission_name IS NULL THEN '(database)'
                   ELSE OBJECT_SCHEMA_NAME(dp.major_id) + '.' + OBJECT_NAME(dp.major_id) END,
    permiso = dp.permission_name,
    estado  = dp.state_desc
FROM sys.database_permissions dp
JOIN sys.database_principals prin ON dp.grantee_principal_id = prin.principal_id
WHERE prin.name = N'aaronlogin';
GO
