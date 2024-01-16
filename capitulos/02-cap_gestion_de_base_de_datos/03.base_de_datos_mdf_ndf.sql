/*************************************************************************************************
CASO 3: Base de datos con especificación de archivos secundarios
***************************************************************************************************
Cree la base de datos db_sales en la carpeta M:\MAGADIFLO. Tenga en cuenta:
- Archivo primario con un tamaño inicial de 50MB, máximo 150MB y una tasa de crecimiento de 20%
- Archivo secundario con tamaño inicial de 10MB, máximo 50MB y tasa de crecimiento de 2MB
*/
USE master
GO

IF DB_ID('db_sales') IS NOT NULL
	DROP DATABASE db_sales
GO

CREATE DATABASE db_sales
ON PRIMARY(
	name		= 'db_sales_pri',
	filename	= 'M:\MAGADIFLO\db_sales.mdf',
	size		= 50MB,
	maxsize		= 150MB,
	filegrowth	= 20%
),(
	name		= 'db_sales_sec',
	filename	= 'M:\MAGADIFLO\db_sales.ndf',
	size		= 10MB,
	maxsize		= 50MB,
	filegrowth	= 2MB
)
GO

--Visualizando la base de datos mediante un listado
SELECT * 
FROM SYS.sysdatabases
GO

--Mostrar los archivos que componen la base de datos
SP_HELPDB 'db_sales'
GO