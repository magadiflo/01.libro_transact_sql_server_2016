/***************************************************************************************************
Transact SQL
***************************************************************************************************
Transact SQL es el lenguaje de programación que proporciona Microsoft SQL Server para extender el 
SQL estándar con otro tipo de instrucciones y elementos propios de los lenguajes de programación.

Características:

- Variables globales propias de SQL Server: @@VariableGlobal.
- Variables locales, se usa el operador DECLARE para declarar la variable locales.
- El identificacor oficial de la variable local es el @.
- Para asignar un valor a la variable local se usa el operador SET.
- Se puede declarar y asignar una variable local al mismo tiempo. Ejemplo: DECLARE @miVariable TIPO_DE_DATO = VALOR
- Una tabla temporal o procedimiento temporal está representada por un #.
- Un objeto global temporal está representada por ##.
*/

/* EJEMPLO 01.
*****************************************************
Script que permita calcular el promedio de cuatro notas de un deteminado alumno; 
dichas notas deberán estar inicializadas con valores predeterminados.
*/
DECLARE @name VARCHAR(50) = 'Gabriel Diaz'
DECLARE @noteOne INT, @noteTwo INT, @noteThree INT, @noteFour INT, @average DECIMAL(5,2)

SET @noteOne	= 12
SET @noteTwo	= 20
SET @noteThree	= 15
SET @noteFour	= 18

SET @average = (@noteOne + @noteTwo + @noteThree + @noteFour)/4.0

PRINT '**** RESUMEN DE NOTAS ****'
PRINT '----------------------------------'
PRINT 'Estudiante: ' + @name
PRINT 'Nota 1: ' + CAST(@noteOne AS VARCHAR)
PRINT 'Nota 2: ' + CAST(@noteTwo AS VARCHAR)
PRINT 'Nota 3: ' + CAST(@noteThree AS VARCHAR)
PRINT 'Nota 4: ' + CAST(@noteFour AS VARCHAR)
PRINT '----------------------------------'
PRINT 'El promedio es: ' + CAST(@average AS VARCHAR)
GO

/* EJEMPLO 02.
*****************************************************
Se usará la bd de Northwind y se hará una consulta a la tabla
orders donde se mostrará el nombre del cliente asociado a una
determinada factura, haciendo uso de variables locales:
*/

DECLARE @idOrder INT = 10253
DECLARE @customer VARCHAR(40)
SET @customer = (SELECT c.CompanyName
				FROM Orders AS o
					INNER JOIN Customers AS c ON(o.CustomerID = c.CustomerID)
				WHERE o.OrderID = @idOrder)

PRINT 'La orden N° ' + CAST(@idOrder AS VARCHAR) + ' tiene como cliente a ' + @customer
GO


/* Funciones CAST y CONVERT
*****************************************************
El uso de CAST y CONVERT es para pasar de un tipo de dato a otro; normalmente
se realiza una conversión cuando una función requiere un tipo especial de 
datos como parámetros.

CAST(EXPRESION - VARIABLE AS TIPO_DATO)
CONVERT(TIPO_DATO, EXPRESION - VARIABLE)
*/


--1° Forma de conversión
DECLARE @monto MONEY
SET @monto = 2500.50
PRINT 'El monto ingresado es ' + CAST(@monto AS VARCHAR) -- El monto ingresado es 2500.50
GO


--2° Forma de conversión
DECLARE @monto MONEY
SET @monto = 2500.50
PRINT 'El monto ingresado es ' + CONVERT(VARCHAR, @monto) -- El monto ingresado es 2500.50
GO

--2° Forma de conversión
--STR, redondea el valor, convierte a cadena, adiciona espacioas a la izq. y elimina los decimales
DECLARE @monto MONEY
SET @monto = 2500.50
PRINT 'El monto ingresado es ' + STR(@monto) -- El monto ingresado es       2501
GO


/* Diferencias entre CAST y CONVERT
*****************************************************
CAST: Es soportado por el estándar ANSI mientras que convert no lo es.
CONVERT: Soporta tipos de datos de fechas (date, datetime, etc) mientras que cast no; es decir,
		con cast no se pueden modificar tipos de datos de fecha.

A pesar de estas diferencias, tanto cast como convert tienen el mismo comportamiento a nivel 
de performance del script inclusive.

Es recomendable (según la información encontrada en blogs de otros autores e inclusive en
la documentación de Microsoft) utilizar CAST debido a que es un estándar ANSI, lo que le
da ventajas de compatibilidad en cuanto a los caracteres generados. De todas formas, al 
momento de convertir datos de fecha se utilizará CONVERT.
*/
							   
SELECT CONVERT(DATE, GETDATE())
SELECT CONVERT(SMALLDATETIME, GETDATE())
SELECT CONVERT(TIME, GETDATE())
GO