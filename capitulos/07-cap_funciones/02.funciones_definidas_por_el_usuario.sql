/***************************************************************************************************
Funciones definidas por el usuario
****************************************************************************************************
- Devuelve un valor.
- Se puede mostrar a través de una consulta SELECT o la función PRINT o asignarlo a través de una
  variable local mediante la sentencia SET.
- No se pueden usar para modificar el estado de la base de datos.
- Las funciones escalares se pueden ejecutar con la instrucción EXECUTE como los procedimientos almacenados.
*/
USE db_proyectos_industriales
GO

/* Funciones escalares
******************************************************
Son funciones que devuelven UN SOLO VALOR a quien lo invoque. Estas funciones luego se integran a sentencias
como consultas, actualizaciones o eliminaciones.

Formato:

CREATE FUNCTION <PROPIETARIO.NOMBRE_FUNCION>(@PARAMETRO TIPO_DATO)
RETURNS <TIPO_DATO_RETORNADO>
<AS>
	BEGIN
		--CUERPO_FUNCION
		RETURN EXPRESION_SALIDA
	END
*/

/*
EJEMPLO 01.
Función que permite calcular el 12% de un monto
*/
IF OBJECT_ID('fn_calcula_descuento') IS NOT NULL
	DROP FUNCTION fn_calcula_descuento
GO

CREATE FUNCTION fn_calcula_descuento(@monto MONEY)
RETURNS MONEY
AS
	BEGIN
		RETURN @monto * 0.12
	END
GO

-- Ejecutando
--Cuando ejecutamos una función definida por el usuario debemos especificar su propitario,
--en este caso sería el dbo
SELECT dbo.fn_calcula_descuento(100) AS descuento
GO

/*
EJEMPLO 02.
Función que permite mostrar el nombre del distrito a partir del código del mismo
*/
IF OBJECT_ID('fn_nombre_distrito') IS NOT NULL
	DROP FUNCTION fn_nombre_distrito
GO

CREATE FUNCTION fn_nombre_distrito(@cod CHAR(3))
RETURNS VARCHAR(40)
AS
	BEGIN
		DECLARE @nombre VARCHAR(40)

		SELECT @nombre = nom_dis
		FROM distrito
		WHERE cod_dis = @cod

		RETURN @nombre
	END
GO

-- Ejecutando
SELECT dbo.fn_nombre_distrito('D01') AS distrito
GO

/*
EJEMPLO 03.
Script que permite mostrar la fecha de facturación en letras.
*/
USE Northwind
GO

IF OBJECT_ID('fn_fecha_en_letras') IS NOT NULL	
	DROP FUNCTION fn_fecha_en_letras
GO

CREATE FUNCTION fn_fecha_en_letras(@fecha DATE)
RETURNS VARCHAR(100)
AS
	BEGIN
		DECLARE @day VARCHAR(2)
		DECLARE @month VARCHAR(10)
		DECLARE @year CHAR(4)

		SET @day = (
			CASE LEN(DAY(@fecha))
				WHEN 1 THEN '0' + CAST(DAY(@fecha) AS VARCHAR(1))
				ELSE CAST(DAY(@fecha) AS VARCHAR(2))
			END)
		SET @month = CHOOSE(MONTH(@fecha), 'ENERO', 'FEBRERO', 'MARZO', 'ABRIL', 'MAYO', 'JUNIO', 'JULIO', 'AGOSTO', 'SETIEMBRE', 'OCTUBRE', 'NOVIEMBRE', 'DICIEMBRE')
		SET @year = YEAR(@fecha)

		RETURN @day + ' de ' + @month + ' de ' + @year
	END
GO

SELECT OrderId, 
		CONVERT(DATE, OrderDate) AS 'fecha', 
		dbo.fn_fecha_en_letras(OrderDate) as 'fecha en letras'
FROM Orders



/* Funciones de tabla en línea
******************************************************
Son funciones que devuelven los registros de una tabla como un conjunto.

Formato:

CREATE FUNCTION <PROPIETARIO.NOMBRE_FUNCION>(@PARAMETRO TIPO_DATO)
RETURNS TABLE
<AS>
	BEGIN
		RETURN (CONSULTA)
	END

Donde:

RETURNS TABLE, especifica que la devolución de la función se refiere a un conjunto de valores.
RETURN (CONSULTA), aquí se especifica la consulta que permite ser devuelto por la función;
se debe tener en cuenta que los parámetros de la función pueden ser usados en la condición
de la consulta.
*/

/*
EJEMPLO 04.
Función que permita  listar los productos
*/
USE Northwind
GO

IF OBJECT_ID('fn_products') IS NOT NULL
	DROP FUNCTION fn_products
GO

CREATE FUNCTION fn_products()
RETURNS TABLE
AS 
	RETURN (SELECT p.ProductID AS id, 
					p.ProductName AS name, 
					p.UnitPrice AS price, 
					p.UnitsInStock AS stock
			FROM Products AS p)
GO

SELECT *
FROM dbo.fn_products()
GO

/*
EJEMPLO 05.
Función que permita listar los empleados según su región
*/
IF OBJECT_ID('fn_empleados_por_region') IS NOT NULL
	DROP FUNCTION fn_empleados_por_region
GO
CREATE FUNCTION fn_empleados_por_region(@regionId SMALLINT)
RETURNS TABLE
AS
	RETURN (SELECT e.EmployeeID, e.LastName, e.FirstName, t.TerritoryDescription, r.RegionDescription 
			FROM Employees AS e
				INNER JOIN EmployeeTerritories AS et ON(e.EmployeeID = et.EmployeeID)
				INNER JOIN Territories AS t ON(et.TerritoryID = t.TerritoryID)
				INNER JOIN Region AS r ON(t.RegionID = r.RegionID)
			WHERE r.RegionID = @regionId)
GO

SELECT * 
FROM dbo.fn_empleados_por_region(3)
GO


/* Funciones de tabla multisentencia
******************************************************
Son funciones que devuelven los registros de una tabla como un conjunto.

Formato:

CREATE FUNCTION <PROPIETARIO.NOMBRE_FUNCION>(@PARAMETRO TIPO_DATO)
RETURNS @VARIABLE TABLE(ARGUMENTO)
<AS>
	BEGIN
		--CUERPO DE LA FUNCIÓN
		RETURN
	END
*/

/*
EJEMPLO 06.
Función que permita mostrar los datos de la tabla empleados
*/
USE Northwind
GO

IF OBJECT_ID('fn_employees') IS NOT NULL
	DROP FUNCTION fn_employees
GO
CREATE FUNCTION fn_employees()
RETURNS @tabla TABLE(id INT, fullname VARCHAR(60), birthdate DATE)
AS
	BEGIN
		INSERT INTO @tabla(id, fullname, birthdate)
		SELECT e.EmployeeID, e.FirstName + SPACE(1) + e.LastName, e.BirthDate
		FROM Employees AS e
		
		RETURN
	END
GO

SELECT * 
FROM dbo.fn_employees()
GO

/*
EJEMPLO 07.
Función que permita mostrar dos columnas, según la tabla seleccionada: Employees, Customers o Suppliers.
*/
IF OBJECT_ID('fn_tablas') IS NOT NULL
	DROP FUNCTION fn_tablas
GO
CREATE FUNCTION fn_tablas(@tableName VARCHAR(20))
RETURNS @tabla TABLE(id VARCHAR(10), description VARCHAR(100))
AS
	BEGIN
		IF @tableName = 'Employees' 
			BEGIN 
				INSERT INTO @tabla(id, description)
				SELECT EmployeeID, FirstName + SPACE(1) + LastName
				FROM Employees
			END
		ELSE IF @tableName = 'Customers'
			BEGIN
				INSERT INTO @tabla(id, description)
				SELECT CustomerID, CompanyName
				FROM Customers
			END
		ELSE IF @tableName = 'Suppliers'
			BEGIN
				INSERT INTO @tabla(id, description)
				SELECT SupplierID, CompanyName
				FROM Suppliers
			END
		RETURN
	END
GO

-- Probando
SELECT * FROM dbo.fn_tablas('Employees')
SELECT * FROM dbo.fn_tablas('Customers')
SELECT * FROM dbo.fn_tablas('Suppliers')