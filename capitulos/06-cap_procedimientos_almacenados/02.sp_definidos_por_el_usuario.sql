/***************************************************************************************************
Procedimientos almacenados del sistema
***************************************************************************************************
Formato:

CREATE PROCEDURE <NOMBRE_DEL_PROCEDIMIENTO> <(@PARAMETRO TIPO_DATO)>
AS
BEGIN
	CUERPO DEL PROCEDIMIENTO
END
*/
USE Northwind
GO


/* EJEMPLO 05
*****************************************************
Procedimiento almacenado que permita devolver los 5 productos con más altos precios registrados en 
la tabla producto.
*/
IF OBJECT_ID('sp_top_5_precios') IS NOT NULL
	DROP PROCEDURE sp_top_5_precios
GO

CREATE PROCEDURE sp_top_5_precios
AS
BEGIN
	SELECT TOP(5) *
	FROM Products
	ORDER BY UnitPrice DESC
END
GO

-- Ejecutando SP
EXECUTE sp_top_5_precios
GO

/* EJEMPLO 06
*****************************************************
Procedimiento almacenado que permita mostrar información de un determinado producto
*/
IF OBJECT_ID('sp_produc_details') IS NOT NULL
	DROP PROCEDURE sp_product_details
GO

CREATE PROCEDURE sp_product_details(@id INT)
AS
BEGIN
	SELECT * 
	FROM products
	WHERE ProductID = @id
END
GO

-- Ejecutando SP
EXECUTE sp_product_details 2
GO

/* EJEMPLO 07
*****************************************************
Procedimiento almacenado que permita mostrar cuántas órdenes se han registrado en un determinado año.
*/
IF OBJECT_ID('sp_order_total_by_year') IS NOT NULL
	DROP PROCEDURE sp_order_total_by_year
GO

CREATE PROCEDURE sp_order_total_by_year(@year INT)
AS
BEGIN
	SELECT YEAR(OrderDate) AS 'año', COUNT(*) AS 'Total de facturas'
	FROM Orders
	GROUP BY YEAR(OrderDate)
	HAVING YEAR(OrderDate) = @year
END
GO

-- Ejecutando SP
EXECUTE sp_order_total_by_year 1996
EXECUTE sp_order_total_by_year 1997
EXECUTE sp_order_total_by_year 1998
GO

SELECT *
FROM Orders
GO


/* EJEMPLO 08
*****************************************************
Listar todos los procedimientos almacenados de una base de datos
*/
SELECT o.name, o.id, o.crdate, o.type
FROM SYS.SYSOBJECTS AS o
WHERE o.xtype = 'P'
GO