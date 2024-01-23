/***************************************************************************************************
Cursores
****************************************************************************************************/
USE Northwind
GO

/* Ejemplo 01
******************************************************
Script que permita implementar un cursor básico donde se imprima el primer registro de la tabla employees.
*/
-- Declarando el cursor
DECLARE c_employees CURSOR
FOR SELECT * FROM Employees

-- Abrir el curor
OPEN c_employees

-- Mostramos el primer registro
FETCH NEXT 
FROM c_employees

-- Cerrando cursor
CLOSE c_employees

-- Liberando recursos del cursor
DEALLOCATE c_employees
GO


/* Ejemplo 02
******************************************************
Script que permita implementar un cursor donde se imprima todos los registros de la tabla Customers.
*/
-- Declaramos variables
DECLARE @id NCHAR(5), @company NVARCHAR(40), @contact NVARCHAR(30)

-- Declarando el cursor
DECLARE c_customers CURSOR
FOR SELECT CustomerID, CompanyName, ContactName
	FROM Customers


-- Abrir el cursor
OPEN c_customers


-- Obtener el primer registro
FETCH NEXT
FROM c_customers INTO @id, @company, @contact

PRINT 'ID COMPANY CONTACT'
PRINT '------------------'

-- Recorrer el cursor con la variable global @@FETCH_STATUS
WHILE (@@FETCH_STATUS = 0)
	BEGIN
		PRINT	@id + SPACE(1) + @company + SPACE(1) + @contact
		FETCH c_customers INTO @id, @company, @contact
	END

-- Cerrar el inhabilitar el cursor
CLOSE c_customers
DEALLOCATE c_customers
GO

/* Ejemplo 03
******************************************************
Script que permita implementar un cursor done se imprima todos los registros de la tabla products
dependiendo del id de la categoría.
*/

DECLARE @id INT, @product NVARCHAR(40), @categoryId INT, 
		@price MONEY, @unitsInStock SMALLINT, @total SMALLINT = 0
SET @categoryId = 1

DECLARE c_products_by_category CURSOR
FOR SELECT ProductID, ProductName, CategoryID, UnitPrice, UnitsInStock
	FROM Products
	WHERE CategoryID = @categoryId

OPEN c_products_by_category

--NEXT: como es predeterminado, no lo pusimos como en los 2 ejercios anteriores.
FETCH c_products_by_category INTO @id, @product, @categoryId, @price, @unitsInStock

WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @total += 1
		PRINT CAST(@id AS VARCHAR) + SPACE(1) + @product + SPACE(1) + CAST(@categoryId AS VARCHAR) + SPACE(1) + CAST(@unitsInStock AS VARCHAR)
		FETCH c_products_by_category INTO @id, @product, @categoryId, @price, @unitsInStock
	END

PRINT 'Total de registros: ' + CAST(@total AS VARCHAR)

CLOSE c_products_by_category
DEALLOCATE c_products_by_category
GO


/* Ejemplo 04
******************************************************
Script que permita implementar un cursor done se imprima los empleados por Región.
*/
DECLARE @regionDescription NCHAR(50)

DECLARE c_region CURSOR
FOR SELECT regionDescription
	FROM Region

OPEN c_region

FETCH c_region INTO @regionDescription

WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT 'Región: ' + @regionDescription
		PRINT '*****************************'

		-- Cursor employees ------------------------------------------
		DECLARE @id INT, @firstName NVARCHAR(10), @lastName NVARCHAR(20), @territoryDescription NCHAR(50)

		DECLARE c_employees CURSOR
		FOR SELECT e.EmployeeID, e.FirstName, e.LastName, t.TerritoryDescription
			FROM Employees AS e
				INNER JOIN EmployeeTerritories AS et ON(e.EmployeeID = et.EmployeeID)
				INNER JOIN Territories AS t ON(et.TerritoryID = t.TerritoryID)
				INNER JOIN Region AS r ON(t.RegionID = r.RegionID)
			WHERE r.RegionDescription = @regionDescription

		OPEN c_employees

		FETCH c_employees INTO @id, @firstName, @lastName, @territoryDescription
		PRINT 'ID	FIRST NAME	LAST NAME	TERRITORY'
		PRINT '--------------------------------------'
		
		WHILE @@FETCH_STATUS = 0
			BEGIN				
				PRINT CAST(@id AS VARCHAR) + SPACE(2) + @firstName + SPACE(2) + @lastName + SPACE(2) + @territoryDescription

				FETCH c_employees INTO @id, @firstName, @lastName, @territoryDescription
			END

		PRINT ''

		CLOSE c_employees
		DEALLOCATE c_employees
		-- -----------------------------------------------------------

		FETCH c_region INTO @regionDescription
	END

CLOSE c_region
DEALLOCATE c_region
GO



/* Ejemplo 05
******************************************************
Implementar un cursor donde se imprima los clientes.
Mostrar: NEXT, LAST. ABSOLUTE, RELATIVE, FIRST, PRIOR.

SCROLL, significa que nos podremos desplazar adelante, atrás, etc.
*/
DECLARE @n INT = 5

DECLARE c_all_clientes CURSOR SCROLL
FOR SELECT *
	FROM Customers

OPEN c_all_clientes

--Primera fila
FETCH NEXT 
FROM c_all_clientes

--Última fila
FETCH LAST 
FROM c_all_clientes

--Fila @n desde el principio del cursor
FETCH ABSOLUTE @n 
FROM c_all_clientes

--Fila @n después de la fila actual
FETCH RELATIVE @n 
FROM c_all_clientes

--Primera fila
FETCH FIRST 
FROM c_all_clientes

---------- Volvemos a llamar a algunos para ver que nos da -------
--Como arriba llamamos a FIRST, es decir la posición será el primer registro(1), 
--ahora lo llamaremos con NEXT, dándonos la siguiente fila o sea, el segundo registro(2)
FETCH NEXT 
FROM c_all_clientes

--Fila anterior a la posición actual
FETCH PRIOR 
FROM c_all_clientes

CLOSE c_all_clientes
DEALLOCATE c_all_clientes
GO
