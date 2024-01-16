/***************************************************************************************************
Manejo de datos masivos en SQL Server
***************************************************************************************************/

/* Instrucción Bulk Insert
******************************************************
La instrucción BULK INSERT importa un archivo de datos en una tabla con un formato definido por el usuario.
*/
IF OBJECT_ID('productos') IS NOT NULL
	DROP TABLE productos
GO

CREATE TABLE productos(
	cod_pro CHAR(5)		NOT NULL PRIMARY KEY,
	des_pro VARCHAR(50) NOT NULL,
	pre_pro MONEY		NOT NULL CHECK(pre_pro BETWEEN 1 AND 100),
	sac_pro INT			NOT NULL CHECK(sac_pro > 0),
	smi_pro INT			NOT NULL,
	uni_pro VARCHAR(30) NOT NULL CHECK(uni_pro IN('BOLSA', 'CAJA', 'PAQUETE')),
	lin_pro VARCHAR(30) NOT NULL,
	imp_pro VARCHAR(10) NOT NULL
)
GO

SELECT *
FROM productos
GO

/*
El siguiente archivo M:\MAGADIFLO\productos.csv contiene la
siguiente información:

COD, DES, PRE, SAC, SMI, UNI, LIN, IMP
P002, CUADERNO JUSTUS, 5.50, 100, 150, CAJA, 2, V
P003, CUADERNO ATLAS, 7.00, 100, 150, PAQUETE, 2, V
P004, LAPICERO 035, 5.50, 100, 150, BOLSA, 2, V
P005, LAPICERO 050, 5.50, 100, 150, BOLSA, 2, F
P006, LAPICERO 075, 5.50, 100, 150, BOLSA, 2, V
P007, REGLA 20CM, 5.50, 100, 150, CAJA, 2, F
P008, REGLA 30CM, 5.50, 100, 150, CAJA, 2, V
P009, CARTUCHERA BÁSICA, 5.50, 100, 150, PAQUETE, 2, V
P010, CARTUCHERA MARCA, 5.50, 100, 150, PAQUETE, 2, F
P011, PLUMÓN INDELEBLE, 5.50, 100, 150, PAQUETE, 2, F
P012, PLUMÓN NORMAL, 5.50, 100, 150, PAQUETE, 2, F


Usando la instrucción BULK INSERT, importaremos los
datos de dicho archivo en la tabla productos:
*/
BULK INSERT productos
FROM 'M:\MAGADIFLO\productos.csv'
WITH(
	FIELDTERMINATOR = ',',
	ROWTERMINATOR	= '\n',
	FIRSTROW		= 2
)
GO

SELECT *
FROM productos
GO