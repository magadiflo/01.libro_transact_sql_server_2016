/***************************************************************************************************
Restricciones para datos
***************************************************************************************************/

/* Identity
******************************************************/
USE master
GO

SET DATEFORMAT YMD
GO

IF DB_ID('db_store') IS NOT NULL
	DROP DATABASE db_store
GO

CREATE DATABASE db_store
GO

USE db_store
GO

CREATE TABLE facturas(
	num_fac INT NOT NULL PRIMARY KEY IDENTITY(1000,1), --Donde 1000, punto de inicio y 1, incremento
	fec_fac DATE NOT NULL,
	fec_can DATE NOT NULL,
	est_fac VARCHAR(10) NOT NULL,
	por_igv DECIMAL NOT NULL
)
GO

INSERT INTO facturas(fec_fac, fec_can, est_fac, por_igv)
VALUES('06-07-2024', '05-08-2024', '2', '0.19')
INSERT INTO facturas(fec_fac, fec_can, est_fac, por_igv)
VALUES('06-07-2024', '05-08-2024', '3', '0.19')
INSERT INTO facturas(fec_fac, fec_can, est_fac, por_igv)
VALUES('01-09-2024', '03-10-2024', '2', '0.19')
INSERT INTO facturas(fec_fac, fec_can, est_fac, por_igv)
VALUES('06-09-2024', '05-10-2024', '2', '0.19')
INSERT INTO facturas(fec_fac, fec_can, est_fac, por_igv)
VALUES('01-10-2024', '12-10-2024', '2', '0.19')
GO

SELECT * 
FROM facturas
GO

/* Default
******************************************************/
CREATE TABLE proveedor(
	cod_prv CHAR(5) NOT NULL PRIMARY KEY,
	rso_prv VARCHAR(80) NOT NULL,
	dir_prv VARCHAR(100) NOT NULL DEFAULT 'NO REGISTRA',
	tel_prv CHAR(15) NULL DEFAULT '000-0000000',
	rep_prv VARCHAR(80) NOT NULL	
)
GO

INSERT INTO proveedor(cod_prv, rso_prv, dir_prv, tel_prv, rep_prv)
VALUES('PR03', '3M', DEFAULT, DEFAULT, 'Ramón Flores')
INSERT INTO proveedor(cod_prv, rso_prv, dir_prv, tel_prv, rep_prv)
VALUES('PR01', 'FABER CASTELL', DEFAULT, '4330895', 'Carlos Aguirre')
INSERT INTO proveedor(cod_prv, rso_prv, rep_prv)
VALUES('PR02', 'ATLAS', 'César Torres')
INSERT INTO proveedor(cod_prv, rso_prv, dir_prv, tel_prv, rep_prv)
VALUES('PR04', '3M', 'Av. Lima 471', '4780143', 'Julio Acuña')
GO


SELECT * 
FROM proveedor
GO

/* Check
******************************************************/
CREATE TABLE productos(
	cod_pro CHAR(5)		NOT NULL PRIMARY KEY,
	des_pro VARCHAR(50) NOT NULL,
	pre_pro MONEY		NOT NULL CHECK(pre_pro BETWEEN 1 AND 100),
	sac_pro INT			NOT NULL CHECK(sac_pro > 0),
	uni_pro VARCHAR(30) NOT NULL CHECK(uni_pro IN('BOLSA', 'CAJA', 'PAQUETE')),
	imp_pro VARCHAR(10) NOT NULL
)
GO

INSERT INTO productos(cod_pro, des_pro, pre_pro, sac_pro, uni_pro, imp_pro)
VALUES('P001', 'Papel bond', 35.50, 200, 'PAQUETE', 'V')
GO

SELECT *
FROM productos
GO

-- Ver restricciones aplicadas a la tabla productos
SP_HELPCONSTRAINT productos
GO

/* Unique
******************************************************/
IF OBJECT_ID('proveedor') IS NOT NULL
	DROP TABLE proveedor
GO

CREATE TABLE proveedor(
	cod_prv CHAR(5) NOT NULL PRIMARY KEY,
	rso_prv VARCHAR(80) NOT NULL,
	dir_prv VARCHAR(100) NOT NULL,
	tel_prv CHAR(15) NULL UNIQUE
)
GO

INSERT INTO proveedor(cod_prv, rso_prv, dir_prv, tel_prv)
VALUES('PRO01', 'Faber Castell SAC', 'Lima', '365214')
INSERT INTO proveedor(cod_prv, rso_prv, dir_prv, tel_prv)
VALUES('PRO02', 'Faber Plumón', 'Lima', '325418')
GO

SELECT * 
FROM proveedor
GO

-- Otra forma para ver restricciones de la tabla
SELECT * 
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'proveedor'
GO