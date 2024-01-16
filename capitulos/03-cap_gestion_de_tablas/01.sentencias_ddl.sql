/***************************************************************************************************
Sentencias DDL para la gesti�n de tablas
***************************************************************************************************/

/* Creaci�n de una tabla
******************************************************/
USE db_sales
GO

IF OBJECT_ID('clients') IS NOT NULL
	DROP TABLE clients
GO

CREATE TABLE clients(
	code CHAR(5),
	phone CHAR(9),
	ruc CHAR(11),
	address VARCHAR(100),
	create_at DATE,
	type VARCHAR(10)
)
GO

-- Comprobando la existencia de la tabla
SP_TABLES 
GO

-- Visualizar las columnas de la tabla
SP_COLUMNS clients
GO

/* Modificaci�n de una tabla
******************************************************/
-- Modificaci�n de la estructura
ALTER TABLE clients
ALTER COLUMN phone CHAR(15)
GO

-- Agregar un campo
ALTER TABLE clients
ADD birthday DATE
GO

-- Eliminar un campo
ALTER TABLE clients
DROP COLUMN birthday
GO

/* Eliminaci�n de una tabla
******************************************************/
-- Eliminar la tabla de forma b�sica
DROP TABLE clients
GO

-- Eliminar la tabla validando su existencia
IF OBJECT_ID('clients') IS NOT NULL
	DROP TABLE clients
GO

-- Verificando la existencia de las tablas
SP_TABLES
GO