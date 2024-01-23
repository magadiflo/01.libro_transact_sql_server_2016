/***************************************************************************************************
Instrucción OpenRowSet
****************************************************************************************************
Contiene toda la información de conexión necesaria para tener accesso a datos remotos desde un orgen
de datos OLE DB. Es un método alternativo para tener acceso a las tablas de un servidor vinculado y,
al mismo tiempo, es un método ad hoc para conectarse y tener acceso a datos remotos utlizando OLE DB.
*/

/* Ejemplo 01
******************************************************
Script que permita volcar el contenido de un archivo de tipo XML en una sola fila de SQL Server.
*/
-- Forma 1
DECLARE @ruta VARCHAR(200) = 'M:\PROGRAMACION\DESARROLLO_BASE_DE_DATOS\SQL_SERVER\01.libro_transact_sql_server_2016\assets\pasajeros.xml'
DECLARE @sql VARCHAR(500)

SET @sql = 'SELECT BULKCOLUMN 
			FROM OPENROWSET(BULK ''' + @ruta + ''', SINGLE_CLOB) AS DATOS_XML'
EXEC(@sql)
GO

-- Forma 2
DECLARE @ruta VARCHAR(200) = 'M:\PROGRAMACION\DESARROLLO_BASE_DE_DATOS\SQL_SERVER\01.libro_transact_sql_server_2016\assets\pasajeros.xml'
DECLARE @sql NVARCHAR(MAX)

SET @sql = 'SELECT BULKCOLUMN 
			FROM OPENROWSET(BULK ''' + @ruta + ''', SINGLE_CLOB) AS DATOS_XML'
EXEC SP_EXECUTESQL @sql
GO



/* Ejemplo 02
******************************************************
Script que permita volcar el contenido de un archivo de tipo TXT en una sola fila de SQL Server.
*/
DECLARE @ruta VARCHAR(200) = 'M:\PROGRAMACION\DESARROLLO_BASE_DE_DATOS\SQL_SERVER\01.libro_transact_sql_server_2016\assets\pasajeros.txt'
DECLARE @sql NVARCHAR(MAX)

SET @sql = 'SELECT BULKCOLUMN 
			FROM OPENROWSET(BULK ''' + @ruta + ''', SINGLE_CLOB) AS DATOS_TEXTO'
EXEC SP_EXECUTESQL @sql
GO


/* Ejemplo 03
******************************************************
Script que permita insertar archivos de tipo JPG dentro de la tabla FOTOPASAJERO con las columnas especificadas en la imagen
*/
USE db_store
GO

CREATE TABLE fotopasajeros(
	id CHAR(5) PRIMARY KEY,
	foto VARBINARY(MAX) NOT NULL
)
GO

INSERT INTO fotopasajeros(id, foto)
SELECT 'P0001', BULKCOLUMN
FROM OPENROWSET(BULK 'M:\PROGRAMACION\DESARROLLO_BASE_DE_DATOS\SQL_SERVER\01.libro_transact_sql_server_2016\assets\martin.jpg', SINGLE_BLOB) AS pasajeros

INSERT INTO fotopasajeros(id, foto)
SELECT 'P0002', BULKCOLUMN
FROM OPENROWSET(BULK 'M:\PROGRAMACION\DESARROLLO_BASE_DE_DATOS\SQL_SERVER\01.libro_transact_sql_server_2016\assets\uns.png', SINGLE_BLOB) AS pasajeros

SELECT * FROM fotopasajeros
GO