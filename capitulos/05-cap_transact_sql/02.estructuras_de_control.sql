/***************************************************************************************************
Estructuras de control
***************************************************************************************************
T-SQL Server, cuenta solo con 3 estructuras de control:

- Estructuras secuenciales: se ejecutan instrucciones una a continuación de otra.
- Estructuras selectivas: se ejecutan las instrucciones según el valor de una variable.
- Estructuras repetitivas: los cilos, bucles
*/

/* Estructura selectiva IF
*****************************************************/
-- EJERCICIO 01.
USE db_proyectos_industriales
GO

DECLARE @distrito VARCHAR(40), @cod CHAR(3)
SET @distrito = 'NEPEÑA'
SET @cod = 'D06'

IF EXISTS(SELECT cod_dis FROM distrito WHERE nom_dis = @distrito)
	BEGIN
		PRINT 'Distrito ya se encuentra registrado'
	END
ELSE
	BEGIN
		INSERT INTO distrito(cod_dis, nom_dis)
		VALUES(@cod, @distrito)
		PRINT 'Nuevo distrito registrado'
	END
GO

SELECT * 
FROM distrito
GO


-- EJERCICIO 02. Mostrar el total de orders registradas en un determinado año;
-- si en dicho año no hay orders registradas, mostrar "No hay orders registradas"
USE Northwind
GO

DECLARE @year INT = 1998
DECLARE @count INT

SET @count = (SELECT COUNT(*) 
			  FROM Orders 
			  WHERE YEAR(OrderDate) = @year)
IF @count = 0
	BEGIN
		PRINT 'No hay facturas registradas para el año ' + CAST(@year AS VARCHAR)
	END
ELSE 
	BEGIN
		PRINT 'Existe un total de ' + CAST(@count AS VARCHAR) + ' órdenes registradas en el año ' + CAST(@year AS VARCHAR)
	END
GO

SELECT * 
FROM Orders


/* Estructura condicional CASE
****************************************************
Formato de múltiples valores para una sola condición
CASE <CAMPO>
	WHEN <VALOR1> THEN expresión_resultado
	WHEN <VALOR2> THEN expresión_resultado
ELSE expresón_falsa
END

Formato múltiples condiciones
CASE
	WHEN <CONDICION 1> THEN expresión_resultado
	WHEN <CONDICION 2> THEN expresión_resultado
	WHEN <CONDICION 3> THEN expresión_resultado
ELSE expresón_falsa
END
*/

-- EJERCICIO 03. Listar código, fecha de registro de la orden, forma de envío donde
--1: DOMICILIO, 2: EN TIENDA, 3: POR TERCEROS, ciudad de envío.

SELECT * 
FROM Orders
GO

SELECT OrderID, OrderDate, ShipCity,
		(CASE ShipVia
			WHEN 1 THEN 'DOMICILIO'
			WHEN 2 THEN 'EN TIENDA'
			WHEN 3 THEN 'POR TERCEROS'
		END) AS [forma de recojo]
FROM Orders
ORDER BY ShipVia
GO


-- EJERCICIO 04. Listar el código, nombre completo del vendedor, la fecha de inicio y la fecha de inicio en letras
SELECT EmployeeID,  FirstName + SPACE(1) + LastName AS fullName, HireDate,
	CAST(DAY(HireDate) AS VARCHAR) + 
	' de ' + 
	(CASE MONTH(HireDate)
		WHEN 1 THEN 'enero'
		WHEN 2 THEN 'febrero'
		WHEN 3 THEN 'marzo'
		WHEN 4 THEN 'abril'
		WHEN 5 THEN 'mayo'
		WHEN 6 THEN 'junio'
		WHEN 7 THEN 'julio'
		WHEN 8 THEN 'agosto'
		WHEN 9 THEN 'setiembre'
		WHEN 10 THEN 'octubre'
		WHEN 11 THEN 'noviembre'
		WHEN 12 THEN 'diciembre'
	END) + 
	' de ' + CAST(YEAR(HireDate) AS VARCHAR) AS contratacion
FROM Employees
GO

SELECT *
FROM Employees
GO

select * 
from Suppliers

/* Estructura de control WHILE
****************************************************
WHILE <condición>
	<expresión_repetida>
	[BREAK]
	<expresión_repetida>
	[CONTINUE]
	<expresión_repetida>

*/

-- EJERCICIO 05. Listar los 10 primeros números
DECLARE @num SMALLINT
SET @num = 1
WHILE (@num <= 10)
	BEGIN
		PRINT @num
		SET @num += 1
	END
GO

-- EJERCICIO 06. Mostrar los tres últimos registros de facturas
DECLARE @n INT, @tope INT
SET @n = 1
SET @tope = 3

WHILE @n <= 100
	BEGIN
		IF @n = @tope
			BEGIN
				SELECT TOP(@n) *
				FROM Orders
				ORDER BY OrderID DESC

				BREAK
			END
		ELSE 
			BEGIN
				SET @n += 1
				CONTINUE
			END
	END
GO


SELECT TOP(3) *
FROM Orders
ORDER BY OrderID DESC
GO

-- EJERCICIO 07. Mostrar cierta cantidad de registros de los clientes usando valores iniciales y finales.
-- Es decir, supongamos que tengo registrado los siguientes clientes: c1, c2, c3, c4, c5, c6, c7, c8 y 
-- le pido que muestre todos los clientes desde el c3 hasta el c5, el resultado deberá ser: c3, c4 y c5
DECLARE @start INT = 3
DECLARE @end INT = 5

SELECT num_row, id, company, contact
FROM (SELECT ROW_NUMBER() OVER(ORDER BY CustomerID ASC) AS num_row,
			CustomerID AS id, 
			CompanyName AS company, 
			ContactName AS contact
	  FROM Customers) AS temporal
WHERE num_row BETWEEN @start AND @end
GO


SELECT ROW_NUMBER() OVER(ORDER BY CustomerID ASC) AS 'orden', * 
FROM Customers
ORDER BY CustomerID ASC
GO

/* ¡Importante!
Estamos usando la función ROW_NUMBER() que usa la función de ventana OVER().

ROW_NUMBER(), cuenta los registros de acuerdo con el orden de clasificación
definido en el filtro OVER(). 

El ROW_NUMBER() siempre debería ir acompañado de la cláusula OVER().
La cláusula OVER() siempre debería tener un ORDER BY.
*/


-- EJERCICIO 08. Implementar un script que permita mostrar el registro de los clientes en forma de paginación de cinco en cinco.
DECLARE @page INT = 1
WHILE (@page <= 5)
	BEGIN
		DECLARE @count_rows INT = 5
		SELECT *
		FROM (SELECT ROW_NUMBER() OVER(ORDER BY CustomerID ASC) AS row_num, *
			  FROM Customers) AS temporal
		WHERE row_num > (@count_rows * (@page - 1)) AND row_num <= (@count_rows * (@page - 1)) + @count_rows

		SET @page += 1
	END
GO