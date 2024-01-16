/***************************************************************************************************
Restricciones para datos
***************************************************************************************************/

/* Insert
******************************************************/
-- Formato de inserción múltiple
INSERT INTO productos(cod_pro, des_pro, pre_pro, sac_pro, uni_pro, imp_pro)
VALUES('P002', 'Papel bond', 35.50, 200, 'PAQUETE', 'V'),
('P003', 'Arroz', 35.50, 200, 'BOLSA', 'V'),
('P004', 'Lapicero', 35.50, 200, 'CAJA', 'V'),
('P005', 'Cartulina', 35.50, 200, 'PAQUETE', 'V')
GO

SELECT *
FROM productos
GO

-- Formato de llenado por una tabla externa
CREATE TABLE productos_aux(
	cod_pro CHAR(5)		NOT NULL PRIMARY KEY,
	des_pro VARCHAR(50) NOT NULL,
	pre_pro MONEY		NOT NULL,
	sac_pro INT			NOT NULL,
	uni_pro VARCHAR(30) NOT NULL,
	imp_pro VARCHAR(10) NOT NULL
)
GO

SELECT *
FROM productos_aux
GO


INSERT INTO productos_aux
SELECT * FROM productos
GO

-- Formato de llenado en la creación de la tabla
SELECT cod_pro, des_pro, sac_pro 
INTO productos_aux_2
FROM productos
GO

SELECT *
FROM productos_aux_2
GO

-- Formato de llenado con variables

--Declarando variables locales
DECLARE @cod_pro CHAR(5), @des_pro VARCHAR(50), @sac_pro INT

--Asignando valores a la variables
SET @cod_pro = 'P006'
SET @des_pro = 'Cerveza'
SET @sac_pro = 50

--Enviando valores a la tabla
INSERT INTO productos_aux_2(cod_pro, des_pro, sac_pro)
VALUES(@cod_pro, @des_pro, @sac_pro)
GO

