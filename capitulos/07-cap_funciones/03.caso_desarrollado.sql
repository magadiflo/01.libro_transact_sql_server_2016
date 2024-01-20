/***************************************************************************************************
Caso desarrollado
****************************************************************************************************/

/* Creando Base de datos para trabajar casos
*******************************************************/
USE master
GO

IF DB_ID('db_alquiler') IS NOT NULL
	DROP DATABASE db_alquiler
GO

CREATE DATABASE db_alquiler
GO

USE db_alquiler
GO

CREATE TABLE distrito(
	ide_dis CHAR(3) PRIMARY KEY,
	des_dis VARCHAR(40)
)
GO

CREATE TABLE alquiler(
	num_alq INT PRIMARY KEY,
	fec_alq DATE,
	mon_alq MONEY
)
GO

CREATE TABLE automovil(
	mat_aut CHAR(10) PRIMARY KEY,
	col_aut VARCHAR(30),
	mod_aut VARCHAR(30)
)
GO

CREATE TABLE cliente(
	ide_cli CHAR(5) PRIMARY KEY,
	ape_cli VARCHAR(30),
	nom_cli VARCHAR(30),
	dni_cli CHAR(8),
	tel_cli VARCHAR(25),
	cor_cli VARCHAR(50),
	ide_dis CHAR(3) NOT NULL,
	CONSTRAINT fk_distrito_cliente FOREIGN KEY(ide_dis) REFERENCES distrito(ide_dis)
)
GO

CREATE TABLE detalle_alquiler(
	num_alq INT NOT NULL,
	ide_cli CHAR(5) NOT NULL,
	mat_auto CHAR(10),
	CONSTRAINT fk_alquiler_det_alq FOREIGN KEY(num_alq) REFERENCES alquiler(num_alq),
	CONSTRAINT fk_cliente_det_alq FOREIGN KEY(ide_cli) REFERENCES cliente(ide_cli),
	CONSTRAINT pk_detalle_alquiler PRIMARY KEY(num_alq, ide_cli)
)
GO

INSERT INTO distrito
VALUES('L01', 'LIMA'),
('L02', 'LINCE'),
('L03', 'BREÑA'),
('L04', 'LOS OLIVOS'),
('L05', 'RIMAC'),
('L06', 'SAN MARTÍN DE PORRES'),
('L07', 'SAN LUIS'),
('L08', 'SAN BORJA')
GO

INSERT INTO automovil
VALUES('AF-456', 'ROJO', 'SEDAN'),
('D4-243', 'NEGRO', 'SEDAN'),
('FD-463', 'PLATA', 'STATION WAGON'),
('FG-654', 'PLATA', 'L10'),
('GG-654', 'ROJO', 'CAMIONETA'),
('GT-532', 'ROJO', 'SEDAN'),
('H5-455', 'ROJO', 'STATION WAGON'),
('HY-345', 'PLATA', 'CHERY'),
('SF-112', 'ROJO', 'LI'),
('YT-457', 'NEGRO', 'STATION WAGON')
GO

INSERT INTO alquiler
VALUES (1, '2010-03-12', 185),
(2, '2011-01-02', 100),
(3, '2011-05-01', 54),
(4, '2012-08-11', 85),
(5, '2012-06-22', 18),
(6, '2012-01-30', 15),
(7, '2012-04-16', 165),
(8, '2012-05-23', 135),
(9, '2012-03-21', 225)
GO

INSERT INTO cliente
VALUES('CL001', 'LOPEZ', 'MARÍA', '14785236', '123-5254', NULL, 'L03'),
('CL002', 'GOMEZ', 'JOSE', '02589658', '585-8558', NULL, 'L02'),
('CL003', 'ACOSTA', 'JESUS', '07415482', '485-1598', NULL, 'L01'),
('CL004', 'ARIAS', 'GUADALUPE', '07415269', '258-8569', NULL, 'L04'),
('CL005', 'CARLOS', 'MANUEL', '10415825', '296-9685', NULL, 'L08'),
('CL006', 'GERZ', 'BRIGITTE', '10952155', '585-1254', NULL, 'L06'),
('CL007', 'BARBOSA', 'MARISOL', '78514855', '584-5869', NULL, 'L04')
GO

INSERT INTO detalle_alquiler
VALUES(1, 'CL002', 'GG-654'),
(2, 'CL002', 'GT-532'),
(3, 'CL006', 'FD-463'),
(3, 'CL007', 'GT-532'),
(4, 'CL005', 'H5-455'),
(5, 'CL004', 'SF-112'),
(6, 'CL004', 'YT-457'),
(7, 'CL003', 'GT-532')
GO

SELECT * FROM distrito
SELECT * FROM automovil
SELECT * FROM alquiler
SELECT * FROM cliente
SELECT * FROM detalle_alquiler
GO

/* EJERCICO 01
******************************************************
Función que devuelva el promedio del monto de alquiler por el año que se le pase
como parámetro.
*/

IF OBJECT_ID('fn_monto_promedio_por_anio') IS NOT NULL
	DROP FUNCTION fn_monto_promedio_por_anio
GO
CREATE FUNCTION fn_monto_promedio_por_anio(@year SMALLINT)
RETURNS MONEY
AS
	BEGIN
		DECLARE @amount MONEY

		SELECT @amount = AVG(mon_alq)
		FROM alquiler
		WHERE YEAR(fec_alq) = @year

		RETURN @amount;
	END
GO

-- Probando
SELECT DISTINCT YEAR(a.fec_alq) AS 'Año de alquiler',
	   dbo.fn_monto_promedio_por_anio(YEAR(a.fec_alq)) AS 'Promedio por año'
FROM alquiler a
GO

/* EJERCICO 02
******************************************************
Función que permita mostrar el menor monto de alquiler en un determinado año.
*/
IF OBJECT_ID('fn_monto_minimo') IS NOT NULL
	DROP FUNCTION fn_monto_minimo
GO

CREATE FUNCTION fn_monto_minimo(@year SMALLINT)
RETURNS MONEY
AS
	BEGIN
		DECLARE @amount MONEY
		SET @amount = (SELECT MIN(mon_alq)
						FROM alquiler
						WHERE YEAR(fec_alq) = @year)
		RETURN @amount		
	END
GO

-- Probando
SELECT dbo.fn_monto_minimo(2011)
GO

SELECT DISTINCT YEAR(fec_alq), dbo.fn_monto_minimo(YEAR(fec_alq))
FROM alquiler
GO

/* EJERCICO 03
******************************************************
Función que permita mostrar el monto acumulado de alquiler en un determinado año
*/
IF OBJECT_ID('fn_monto_acumulado') IS NOT NULL
	DROP FUNCTION fn_monto_acumulado
GO

CREATE FUNCTION fn_monto_acumulado(@year SMALLINT)
RETURNS MONEY
AS
	BEGIN
		DECLARE @amount MONEY
		SET @amount = (SELECT SUM(mon_alq)
						FROM alquiler
						WHERE YEAR(fec_alq) = @year)
		RETURN @amount		
	END
GO

-- Probando
SELECT dbo.fn_monto_acumulado(2011)
GO

SELECT DISTINCT YEAR(fec_alq), dbo.fn_monto_acumulado(YEAR(fec_alq))
FROM alquiler
GO

/* EJERCICO 04
******************************************************
Función que permita mostrar la diferencia de años entre la fecha de alquiler
y el año actual
*/
IF OBJECT_ID('fn_diferencia_por_anios') IS NOT NULL
	DROP FUNCTION fn_diferencia_por_anios
GO

CREATE FUNCTION fn_diferencia_por_anios(@fechaAlquiler DATE)
RETURNS INT
AS
	BEGIN
		RETURN DATEDIFF(YEAR, @fechaAlquiler, GETDATE())
	END
GO

-- Probando
SELECT dbo.fn_diferencia_por_anios(CONVERT(DATE, '01-05-2014'))
GO

SELECT num_alq,
	   mon_alq, 
	   fec_alq,
	   FORMAT(fec_alq, 'd', 'es-ES') AS formato, 
	   FORMAT(fec_alq, 'D', 'es-ES') AS formato_texto, 
	   dbo.fn_diferencia_por_anios(fec_alq) AS [Años hasta la actualidad]
FROM alquiler
GO

/* EJERCICO 05
******************************************************
Implemente una función tabla en línea que permita mostrar todos los 
registros de los clientes. Luego, muestre a los clientes de un 
determinado distrito.
*/
IF OBJECT_ID('fn_clientes') IS NOT NULL
	DROP FUNCTION fn_clientes
GO

CREATE FUNCTION fn_clientes()
RETURNS TABLE
AS
	RETURN (SELECT c.ide_cli AS codigo,
				   c.nom_cli + SPACE(1) + c.ape_cli AS cliente,
				   c.tel_cli AS telefono,
				   c.cor_cli AS correo,
				   d.des_dis AS distrito
			FROM cliente AS c
				INNER JOIN distrito AS d ON(c.ide_dis = d.ide_dis))
GO

SELECT * 
FROM dbo.fn_clientes()
WHERE distrito = 'lima'
GO

/* EJERCICO 06
******************************************************
Implemente una función multisentencia que permita mostrar todos los registros
de los automóviles
*/
IF OBJECT_ID('fn_automoviles') IS NOT NULL
	DROP FUNCTION fn_automoviles
GO

CREATE FUNCTION fn_automoviles()
RETURNS @table TABLE(matricula CHAR(10), color VARCHAR(30), modelo VARCHAR(30))
AS
	BEGIN
		INSERT INTO @table(matricula, color, modelo)
		SELECT mat_aut, col_aut, mod_aut
		FROM automovil

		RETURN
	END
GO

SELECT * 
FROM dbo.fn_automoviles()
GO

/* EJERCICO 07
******************************************************
Implemente una función multisentencia que permita mostrar todos los registros
de los detalles de alquileres
*/
IF OBJECT_ID('fn_detalles_alquileres') IS NOT NULL
	DROP FUNCTION fn_detalles_alquileres
GO

CREATE FUNCTION fn_detalles_alquileres()
RETURNS @table TABLE(numero_alquiler INT, fecha_alquiler DATE, monto MONEY,
					cliente VARCHAR(100), dni VARCHAR(8), matricula CHAR(6),
					color VARCHAR(30), modelo VARCHAR(30))
AS
	BEGIN
		INSERT INTO @table(numero_alquiler, fecha_alquiler, monto, cliente, dni,
							matricula, color, modelo)
		SELECT da.num_alq, 
			   a.fec_alq,
			   a.mon_alq,
			   c.nom_cli + SPACE(1) + c.ape_cli AS cliente,
			   c.dni_cli, 
			   au.mat_aut,
			   au.col_aut,
			   au.mod_aut
		FROM detalle_alquiler AS da
			INNER JOIN alquiler AS a ON(da.num_alq = a.num_alq)
			INNER JOIN cliente AS c ON(da.ide_cli = c.ide_cli)
			INNER JOIN automovil AS au ON(da.mat_auto = au.mat_aut)

		RETURN
	END
GO

-- Probando
SELECT *
FROM dbo.fn_detalles_alquileres()
GO