/***************************************************************************************************
Funciones agregadas
***************************************************************************************************/
USE Northwind
GO

/* Cláusula Grop By con resúmenes
*****************************************************
Los resúmenes solo se pueden aplicar a un grupo de información; esto permitirá visualizar
montos o conteos realizados sobre un conjunto de información agrupada.

SELECT <ALL> <*>
	<ALIAS.CAMPO AS CAMPO>
FROM <TABLA> <AS ALIAS>
<GROUP BY CAMPO>
[ROLLUP]
[CUBE] <CAMPOS>
<HAVING CONDITION>

- ROLLUP, genera filas de agregado en la cláusula GROUP BY más filas de subtotal y, también,
	una fila con un total general. EL número de agregaciones es igual al número de expresiones
	de la lista de elmentos compuestos más uno; aquí justamente muestra los resultantes.

- CUBE, genera filas de agregado en la cláusula GROUP BY más una fila de superagreado y filas
	de tabulación cruzada. El número de agrupaciones es igual a 2n, donde n es el número de 
	expresionesde la lista de elementos compuestos.
*/
SELECT * 
FROM orders
GO

SELECT COUNT(*)
FROM Orders
GO

-- Usando ROLLUP
SELECT EmployeeID AS empleado, COUNT(*) AS 'Ventas realizadas'
FROM Orders
GROUP BY EmployeeID
WITH ROLLUP
GO

-- Usando CUBE
SELECT EmployeeID AS empleado, COUNT(*) AS 'Ventas realizadas'
FROM Orders
GROUP BY CUBE(EmployeeID)
GO

-- Por defecto, se muestra NULL dentro de la consulta agrupada con resúmenes. Podríamos usar el siguiente código para darle un valor. Para
-- eso tendríamos que utilizar la tabla empleados para obtener el nombre y en ese campo nombre colocar el texto 'Ventas totales' ya que
-- si lo dejamos como antes, el campo que usábamos era entero y en ese campo no podemos colocar texto.
SELECT CASE
			WHEN e.FirstName IS NULL THEN 'VENTAS TOTALES'
			ELSE e.FirstName
		END AS empleado, COUNT(*) AS 'Ventas realizadas'
FROM Orders AS o
	INNER JOIN Employees AS e ON(o.EmployeeID = e.EmployeeID)
GROUP BY e.FirstName
WITH ROLLUP
GO

--- Usando CUBE 
SELECT CASE
			WHEN e.FirstName IS NULL THEN 'VENTAS TOTALES'
			ELSE e.FirstName
		END AS empleado, COUNT(*) AS 'Ventas realizadas'
FROM Orders AS o
	INNER JOIN Employees AS e ON(o.EmployeeID = e.EmployeeID)
GROUP BY CUBE(e.FirstName)
GO

-- Usando ROLLUP
SELECT YEAR(o.OrderDate) AS año, MONTH(o.OrderDate) AS mes, COUNT(*) AS total
FROM Orders AS o
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate)
WITH ROLLUP
GO

SELECT CASE
			WHEN YEAR(o.OrderDate) IS NULL THEN 'TOTAL'
			ELSE CAST(YEAR(o.OrderDate) AS CHAR(4)) 
		END AS año,
		CASE 
			WHEN MONTH(o.OrderDate) IS NULL THEN 'TOTAL POR AÑO'
			ELSE CAST(MONTH(o.OrderDate) AS CHAR(2))
		END AS mes, 
		COUNT(*) AS total
FROM Orders AS o
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate)
WITH ROLLUP
GO