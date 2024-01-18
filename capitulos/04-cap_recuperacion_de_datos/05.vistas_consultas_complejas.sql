/***************************************************************************************************
Simplificación de consultas complejas mediante el uso de vistas
****************************************************************************************************
Clasificación de vistas:
- Vistas horizontales
- Vistas verticales
*/

/* Vistas horizontales
*****************************************************
Un uso común de las vistas es restringir el acceso de un usuario a únicamente filas seleccionadas en una tabla
(por eso se le llama vistas horizontales, por que solo se le mostrará al usuario unas determinadas FILAS).
A continuación, se observa cómo implementar tres vistas horizontales que permitan separar las orders por la 
columna shipVia
*/
use Northwind
GO

-- Vista 1
IF OBJECT_ID('v_orders_ship_1') IS NOT NULL
	DROP VIEW v_orders_ship_1
GO

CREATE VIEW v_orders_ship_1
AS
	SELECT *
	FROM Orders
	WHERE ShipVia = 1
GO

-- Vista 2
IF OBJECT_ID('v_orders_ship_2') IS NOT NULL
	DROP VIEW v_orders_ship_2
GO

CREATE VIEW v_orders_ship_2
AS
	SELECT *
	FROM Orders
	WHERE ShipVia = 2
GO

-- Vista 3
IF OBJECT_ID('v_orders_ship_3') IS NOT NULL
	DROP VIEW v_orders_ship_3
GO

CREATE VIEW v_orders_ship_3
AS
	SELECT *
	FROM Orders
	WHERE ShipVia = 3
GO

-- Prueba de vistas horizontales
SELECT * FROM v_orders_ship_1
SELECT * FROM v_orders_ship_2
SELECT * FROM v_orders_ship_3
GO

/* Vistas verticales
*****************************************************
Una vista vertical se caracteriza por mostrar ciertas columnas que el diseñador desea que visualice el usuario.

En el ejempo siguiente mostraremos los siguientes datos de los empleados:
id, nombre completo,  país, telefono
*/

IF OBJECT_ID('v_employees') IS NOT NULL	
	DROP VIEW v_employees
GO

CREATE VIEW v_employees
AS
	SELECT EmployeeID AS id,
			FirstName + SPACE(1) + LastName AS 'nombre completo',
			Country AS pais,
			HomePhone AS telefono
	FROM Employees
GO

-- Prueba
SELECT * 
FROM v_employees
GO
