/***************************************************************************************************
Manejo de esquemas
****************************************************************************************************
ESQUEMA				TABLAS
-----------------------------------------------------
compras				productos
					proveedor
					orden de compra
					detalle de la orden de compra
					abastecimiento
-----------------------------------------------------
ventas				cliente
					factura
					detalle de la factura
-----------------------------------------------------
rrhh				vendedor
					distrito
*/
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

CREATE SCHEMA compras AUTHORIZATION dbo
GO

CREATE SCHEMA ventas AUTHORIZATION dbo
GO

CREATE SCHEMA rrhh AUTHORIZATION dbo
GO

CREATE TABLE rrhh.distrito(
	cod_dis CHAR(5)		NOT NULL PRIMARY KEY,
	nom_dis VARCHAR(50) NOT NULL
)
GO

CREATE TABLE rrhh.vendedor(
	cod_ven CHAR(3)		NOT NULL PRIMARY KEY,
	cod_dis CHAR(5)		NOT NULL,
	nom_ven VARCHAR(20) NOT NULL,
	ape_ven VARCHAR(20) NOT NULL,
	sue_ven MONEY		NOT NULL,
	fin_ven DATE		NOT NULL,
	tip_ven VARCHAR(10) NOT NULL,
	FOREIGN KEY(cod_dis) REFERENCES rrhh.distrito(cod_dis)
)
GO

CREATE TABLE ventas.cliente(
	cod_cli CHAR(5)			NOT NULL PRIMARY KEY,
	cod_dis CHAR(5)			NOT NULL,
	rso_cli CHAR(30)		NOT NULL,
	dir_cli VARCHAR(100)	NOT NULL,
	tlf_cli CHAR(9)			NOT NULL,
	ruc_cli CHAR(11)		NULL,
	fec_reg DATE			NOT NULL,
	tip_cli VARCHAR(10)		NOT NULL,
	con_cli VARCHAR(30)		NOT NULL,
	FOREIGN KEY(cod_dis) REFERENCES rrhh.distrito(cod_dis)
)
GO

CREATE TABLE compras.proveedor(
	cod_prv CHAR(5)			NOT NULL PRIMARY KEY,
	cod_dis CHAR(5)			NOT NULL, 
	rso_prv VARCHAR(80)		NOT NULL,
	dir_prv VARCHAR(100)	NOT NULL,
	tel_prv CHAR(15)		NULL,
	rep_prv VARCHAR(80)		NOT NULL,
	FOREIGN KEY(cod_dis) REFERENCES rrhh.distrito(cod_dis)
)
GO

CREATE TABLE ventas.factura(
	num_fac VARCHAR(12)	NOT NULL PRIMARY KEY,
	cod_cli CHAR(5)		NOT NULL,
	cod_ven CHAR(3)		NOT NULL,
	fec_fac DATE		NOT NULL,
	fec_can	DATE		NOT NULL,
	est_fac VARCHAR(10) NOT NULL,
	por_igv DECIMAL		NOT NULL,
	FOREIGN KEY(cod_cli) REFERENCES ventas.cliente(cod_cli),
	FOREIGN KEY(cod_ven) REFERENCES rrhh.vendedor(cod_ven)
)
GO

CREATE TABLE compras.orden_compra(
	num_oco CHAR(5)	NOT NULL PRIMARY KEY,
	cod_prv CHAR(5) NOT NULL,
	fec_oco DATE	NOT NULL,
	fat_oco DATE	NOT NULL,
	est_oco CHAR(1)	NOT NULL,
	FOREIGN KEY(cod_prv) REFERENCES compras.proveedor(cod_prv)
)
GO

CREATE TABLE compras.producto(
	cod_pro CHAR(5)		NOT NULL PRIMARY KEY,
	des_pro VARCHAR(50)	NOT NULL,
	pre_pro MONEY		NOT NULL,
	sac_pro INT			NOT NULL,
	smi_pro INT			NOT NULL,
	uni_pro VARCHAR(30)	NOT NULL,
	lin_pro VARCHAR(30)	NOT NULL,
	imp_pro	VARCHAR(10)	NOT NULL
)
GO

CREATE TABLE ventas.detalle_factura(
	num_fac VARCHAR(12) NOT NULL,
	cod_pro CHAR(5)		NOT NULL,
	can_ven INT			NOT NULL,
	pre_ven MONEY		NOT NULL,
	FOREIGN KEY(num_fac) REFERENCES ventas.factura(num_fac),
	FOREIGN KEY(cod_pro) REFERENCES compras.producto(cod_pro),
	PRIMARY KEY(num_fac, cod_pro)
)
GO

CREATE TABLE compras.detalle_compra(
	num_oco CHAR(5)	NOT NULL,
	cod_pro CHAR(5) NOT NULL,
	can_det INT		NOT NULL,
	FOREIGN KEY(num_oco) REFERENCES compras.orden_compra(num_oco),
	FOREIGN KEY(cod_pro) REFERENCES compras.producto(cod_pro),
	PRIMARY KEY(num_oco, cod_pro)
)
GO

CREATE TABLE compras.abastecimiento(
	cod_prv CHAR(5)	NOT NULL,
	cod_pro	CHAR(5) NOT NULL,
	pre_aba MONEY	NOT NULL,
	FOREIGN KEY(cod_prv) REFERENCES compras.proveedor(cod_prv),
	FOREIGN KEY(cod_pro) REFERENCES compras.producto(cod_pro),
	PRIMARY KEY(cod_prv, cod_pro)
)
GO
