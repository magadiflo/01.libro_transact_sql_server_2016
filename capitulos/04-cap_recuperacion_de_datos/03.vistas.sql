/***************************************************************************************************
Vistas
***************************************************************************************************
Es un mecanismo que permite almacenar, de forma permanente, una consulta en SQL Server; asímismo,
genera un resultado a partir de una consulta almacenada en la vista, para finalmente ejecutar
nuevos resultados como si fueran una nueva tabla.

Es considerado una tabla virtual, cuyo contenido se compone de columnas y filas provenientes 
de una consulta; esta consulta puede provenir de una o más tablas dentro de la misma base de datos.

CREATE VIEW NOMBRE_VISTA
AS	
	SENTENCIAS
GO
*/
USE Northwind
GO


/* Ejercicio 01
******************************************************/
-- Validando la vista
IF OBJECT_ID('v_list_employees') IS NOT NULL
	DROP VIEW v_list_employees
GO

-- Creando la vista
CREATE VIEW v_list_employees
AS
	SELECT e.EmployeeID AS id,
		e.FirstName + SPACE(1) + e.LastName AS 'nombre',
		e.HireDate AS 'fecha_contrato',
		t.TerritoryDescription AS 'territorio'
			
	FROM employees AS e
		INNER JOIN EmployeeTerritories AS et ON(e.EmployeeID = et.EmployeeID)
		INNER JOIN Territories AS t ON(et.TerritoryID = t.TerritoryID)
		INNER JOIN Region AS r ON(t.RegionID = r.RegionID)
GO

-- Probando vista
SELECT * 
FROM v_list_employees
GO

/*
NOTA: A partir de una vista, se pueden realizar muchas consultas de los datos contenidos en ella,
como si fuera una tabla. Algunos ejemplos de consultas sobre la vista:
*/
SELECT *
FROM v_list_employees
WHERE YEAR(fecha_contrato) BETWEEN 1993 AND 1994
GO


/* Ejercicio 02
******************************************************/
IF OBJECT_ID('v_order_details') IS NOT NULL
	DROP VIEW v_order_details
GO

CREATE VIEW v_order_details
AS
	SELECT o.OrderID AS id,
			c.CompanyName AS cliente,
			p.ProductName AS producto,
			od.Quantity AS cantidad,
			od.UnitPrice AS precio_unitario,
			od.Quantity * od.UnitPrice AS subtotal
	FROM Orders AS o
		INNER JOIN Customers AS c ON(o.CustomerID = c.CustomerID)
		INNER JOIN [Order Details] AS od ON(o.OrderID = od.OrderID)
		INNER JOIN Products AS p ON(od.ProductID = p.ProductID)
GO

-- Probando
SELECT * 
FROM v_order_details
ORDER BY subtotal
GO

-- Trabajando con la vista v_order_details
SELECT * 
FROM v_order_details
WHERE subtotal BETWEEN 100 AND 300
ORDER BY subtotal
GO