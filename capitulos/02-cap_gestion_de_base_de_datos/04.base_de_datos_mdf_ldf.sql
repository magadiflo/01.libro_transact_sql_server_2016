/*************************************************************************************************
CASO 4: Base de datos con especificación de archivos de transacciones
***************************************************************************************************
Cree la base de datos db_sales en la carpeta M:\MAGADIFLO. Tenga en cuenta:
- Archivo primario con un tamaño inicial de 50MB, máximo 150MB y una tasa de crecimiento de 20%
- Archivo de transacciones con un tamaño inicial de 5MB, máximo 50MB y una tasa de crecimiento de 10%
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
)
LOG ON(
	name		= 'db_sales_log',
	filename	= 'M:\MAGADIFLO\db_sales.ldf',
	size		= 5MB,
	maxsize		= 50MB,
	filegrowth	= 10%
)
GO

--Visualizando la base de datos mediante un listado
SELECT * 
FROM SYS.sysdatabases
GO

--Mostrar los archivos que componen la base de datos
SP_HELPDB 'db_sales'
GO