/***************************************************************************************************
Caso desarrollado 1
***************************************************************************************************
Cree la base de datos db_proyectos_industriales teniendo en cuenta los siguientes aspectos:

- Validar la base de datos y crear el siguiente modelo de datos.
- Aplicar las siguientes restricciones:
	- Aplicar la propiedad IDENTITY a la columna num_pro de la tabla proyecto con un inicio de uno.
	- En el correo del cliente, mostrar el mensaje 'No cuenta' si el usuario no registra dicho dato.
	- En el monto del proyecto, el valor debe ser superior a cero.
	- En la carrera del encargado, solo se podrán registrar valores como: "JEFE, CONTADOR, SUPERVISOR, VENDEDOR".
	- El número de RUC del cliente debe ser un valor único por cliente.
- Modificar la capacidad de caracteres a 100 de la descripción del detalle del proyecto.
- Agregar el campo teléfono "tel_cli" y número de hijos "hij_cli" a la tabla cliente.
- Eliminar el campo "hij_cli" de la tabla cliente.
- Listar las tablas implementadas en la base de datos.
- Listar los campos de cada tabla implementada.
- Realizar la inserción de registros a cada tabla de la base de datos db_proyectos_industriales.
- Realizar las siguientes actualizaciones:
	- Modificar el correo electrónico del cliente "María López" por maria_lopez@gmail.com.
	- Modificar los números de teléfonos de todos los clientes por '0000000'.
	- Disminuir en $5000 a todos los proyectos registrados en el primer semestre del año 2012.
- Implementar la sentencia MERGE para un distrito; en caso existiera, actualizar la información; 
caso contrario, insertarlo como un nuevo distrito.

SOLUCIÓN:
--------
Veamos a continuación la solución:
*/

-- Validar la base de datos, crearlo y dejarlo listo para su uso
USE master
GO

IF DB_ID('db_proyectos_industriales') IS NOT NULL
	DROP DATABASE db_proyectos_industriales
GO

CREATE DATABASE db_proyectos_industriales
GO

USE db_proyectos_industriales
GO

-- Crear las tablas aplicando las siguientes restricciones:
/*
	- Aplicar la propiedad IDENTITY a la columna num_pro de la tabla proyecto con un inicio de uno.
	- En el correo del cliente, mostrar el mensaje 'No cuenta' si el usuario no registra dicho dato.
	- En el monto del proyecto, el valor debe ser superior a cero.
	- En la carrera del encargado, solo se podrán registrar valores como: "JEFE, CONTADOR, SUPERVISOR, VENDEDOR".
	- El número de RUC del cliente debe ser un valor único por cliente.
*/

CREATE TABLE distrito(
	cod_dis CHAR(3) NOT NULL PRIMARY KEY,
	nom_dis VARCHAR(40) NOT NULL
)
GO

CREATE TABLE cliente(
	ide_cli CHAR(5) NOT NULL PRIMARY KEY,
	cod_dis CHAR(3) NOT NULL,
	nom_cli VARCHAR(50) NOT NULL,
	ruc_cli CHAR(11) NOT NULL UNIQUE,
	ema_cli VARCHAR(35) NOT NULL DEFAULT 'No cuenta',
	CONSTRAINT fk_distrito_cliente FOREIGN KEY(cod_dis) REFERENCES distrito(cod_dis)
)
GO

CREATE TABLE encargado(
	ide_enc CHAR(5) NOT NULL PRIMARY KEY,
	cod_dis CHAR(3) NOT NULL,
	ape_enc VARCHAR(30) NOT NULL,
	nom_enc VARCHAR(30) NOT NULL,
	car_enc VARCHAR(30) NOT NULL CHECK(car_enc IN('JEFE', 'CONTADOR', 'SUPERVISOR', 'VENDEDOR')),
	fin_enc DATE NOT NULL,
	CONSTRAINT fk_distrito_encargado FOREIGN KEY(cod_dis) REFERENCES distrito(cod_dis)
)
GO

CREATE TABLE proyecto(
	num_pro INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	fec_pro DATE NOT NULL,
	mon_pro MONEY NOT NULL CHECK(mon_pro > 0)
)
GO

CREATE TABLE detalle_proyecto(
	num_pro INT NOT NULL,
	ide_cli CHAR(5) NOT NULL,
	ide_enc CHAR(5) NOT NULL,
	des_det VARCHAR(40) NOT NULL,
	CONSTRAINT pk_detalle_proyecto PRIMARY KEY(num_pro, ide_cli),
	CONSTRAINT fk_proyecto_detalle_proyecto FOREIGN KEY(num_pro) REFERENCES proyecto(num_pro),
	CONSTRAINT fk_cliente_detalle_proyecto FOREIGN KEY(ide_cli) REFERENCES cliente(ide_cli),
	CONSTRAINT fk_encargado_detalle_proyecto FOREIGN KEY(ide_enc) REFERENCES encargado(ide_enc)
)
GO

-- Modificar la capacidad de caracteres a 100 de la descripción del detalle del proyecto.
ALTER TABLE detalle_proyecto
ALTER COLUMN des_det VARCHAR(100) NOT NULL
GO

-- Agregar el campo teléfono "tel_cli" y número de hijos "hij_cli" a la tabla cliente.
ALTER TABLE cliente
ADD tel_cli CHAR(7) NOT NULL
GO

ALTER TABLE cliente
ADD hij_cli INT NOT NULL
GO

-- Eliminar el campo "hij_cli" de la tabla cliente.
ALTER TABLE cliente
DROP COLUMN hij_cli
GO

-- Listar las tablas implementadas en la base de datos.
SELECT * 
FROM SYS.tables
GO

SP_TABLES
GO

-- Listar los campos de cada tabla implementada.
SP_COLUMNS cliente
GO

SP_COLUMNS detalle_proyecto
GO

-- Realizar la inserción de registros a cada tabla de la base de datos db_proyectos_industriales.
INSERT INTO distrito(cod_dis, nom_dis)
VALUES('D01', 'NUEVO CHIMBOTE'),
('D02', 'CHIMBOTE'),
('D03', 'COISHCO'),
('D04', 'SANTA');
GO

SELECT *
FROM distrito
GO

-- Implementar la sentencia MERGE para un distrito; en caso existiera, actualizar la información; caso contrario, insertarlo como un nuevo distrito.
DECLARE @cod CHAR(3), @nom VARCHAR(40)
SET @cod = 'D05'
SET @nom = 'CASMA'

MERGE distrito AS destino
USING(SELECT @cod, @nom) AS origen(cod, nom)
ON(destino.cod_dis = origen.cod)
WHEN MATCHED THEN
	UPDATE SET destino.nom_dis = origen.nom
WHEN NOT MATCHED BY target THEN
	INSERT(cod_dis, nom_dis)
	VALUES(origen.cod, origen.nom);
GO

SELECT *
FROM distrito
GO
