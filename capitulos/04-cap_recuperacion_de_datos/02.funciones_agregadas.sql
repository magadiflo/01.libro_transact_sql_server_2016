/***************************************************************************************************
Funciones agregadas
***************************************************************************************************/
USE Northwind
GO

/* Cl�usula Grop By con res�menes
*****************************************************
Los res�menes solo se pueden aplicar a un grupo de informaci�n; esto permitir� visualizar
montos o conteos realizados sobre un conjunto de informaci�n agrupada.

SELECT <ALL> <*>
	<ALIAS.CAMPO AS CAMPO>
FROM <TABLA> <AS ALIAS>
<GROUP BY CAMPO>
[ROLLUP]
[CUBE] <CAMPOS>
<HAVING CONDITION>

- ROLLUP, genera filas de agregado en la cl�usula GROUP BY m�s filas de subtotal y, tambi�n,
	una fila con un total general. EL n�mero de agregaciones es igual al n�mero de expresiones
	de la lista de elmentos compuestos m�s uno; aqu� justamente muestra los resultantes.

- CUBE, genera filas de agregado en la cl�usula GROUP BY m�s una fila de superagreado y filas
	de tabulaci�n cruzada. El n�mero de agrupaciones es igual a 2n, donde n es el n�mero de 
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

-- Por defecto, se muestra NULL dentro de la consulta agrupada con res�menes. Podr�amos usar el siguiente c�digo para darle un valor. Para
-- eso tendr�amos que utilizar la tabla empleados para obtener el nombre y en ese campo nombre colocar el texto 'Ventas totales' ya que
-- si lo dejamos como antes, el campo que us�bamos era entero y en ese campo no podemos colocar texto.
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
SELECT YEAR(o.OrderDate) AS a�o, MONTH(o.OrderDate) AS mes, COUNT(*) AS total
FROM Orders AS o
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate)
WITH ROLLUP
GO

SELECT CASE
			WHEN YEAR(o.OrderDate) IS NULL THEN 'TOTAL'
			ELSE CAST(YEAR(o.OrderDate) AS CHAR(4)) 
		END AS a�o,
		CASE 
			WHEN MONTH(o.OrderDate) IS NULL THEN 'TOTAL POR A�O'
			ELSE CAST(MONTH(o.OrderDate) AS CHAR(2))
		END AS mes, 
		COUNT(*) AS total
FROM Orders AS o
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate)
WITH ROLLUP
GO