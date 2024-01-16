/*
Se utilizan tres tipos de archivos para almacenar una base de datos:

- Archivo MDF, también llamado archivo principal o master. Por cada base de datos solo se tiene
un archivo MDF y este puede contener toda la información referente a la base de datos; dicha 
información se almacena en tablas.

- Archivo NDF, también llamado archivo secundario. Estos archivos contienen todos los datos que
no caben en el archivo MDF. No es necesario que las bases de datos tengan archivos de datos 
secundarios si el archivo principal es lo suficientemente grande como para contener todos los datos.

- Archivo LDF, también llamado archivo de transacción. Contiene la información interna como la
fecha de creación y otras características propias de la base de datos.

***************************************************************************************************/
--El comando GO, permite finalizar un lote de sentencias.

--Listar Tipos de datos incluyendo los definidos por el usuario
SELECT *
FROM SYS.SYSTYPES
GO

--Agregar el tipo de dato DNI de 8 caracteres con restricción de campo obligatorio
SP_ADDTYPE dni, 'CHAR(8)', 'NOT NULL'
GO

CREATE TYPE dni 
FROM CHAR(8) NOT NULL
GO

--Eliminar el tipo de dato definido por el usuario
SP_DROPTYPE 'DNI'
GO

DROP TYPE dni
GO


/***************************************************************************************************
CASO 1: Base de datos básica
***************************************************************************************************/
--Activamos la BD MASTER: Cuando se crea una base de datos, siempre se inicia con la activación de la BD MASTER.
USE master
GO

--Validando la exitencia de la base de datos
IF DB_ID('db_sales') IS NOT NULL
	DROP DATABASE db_sales
GO

--Creando la BD
CREATE DATABASE db_sales
GO

--Visualizar la bd mediante un listado
SELECT * 
FROM SYS.sysdatabases
GO

--Mostrar los archivos que componen la base de datos
SP_HELPDB db_sales
GO

