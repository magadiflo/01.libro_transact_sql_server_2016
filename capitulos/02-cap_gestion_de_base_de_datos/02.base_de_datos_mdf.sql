/*************************************************************************************************
CASO 2: Base de datos con especificación de archivo primario
***************************************************************************************************
Cree la base de datos db_sales en la carpeta M:\MAGADIFLO. Tenga en cuenta:
- Archivo primario con un tamaño inicial de 50MB, máximo 150MB y una tasa de crecimiento de 20%
- Visualizar la base de datos mediante un listado
- Mostrar los archivos que componen la base de datos
*/
USE master
GO

IF DB_ID('db_sales') IS NOT NULL
	DROP DATABASE db_sales
GO

CREATE DATABASE db_sales
ON PRIMARY(
	name		= 'db_sales',
	filename	= 'M:\MAGADIFLO\db_sales.mdf',
	size		= 50MB,
	maxsize		= 150MB,
	filegrowth	= 20%
)
GO

--Visualizando la base de datos mediante un listado
SELECT * 
FROM SYS.sysdatabases
GO

--Mostrar los archivos que componen la base de datos
SP_HELPDB 'db_sales'
GO