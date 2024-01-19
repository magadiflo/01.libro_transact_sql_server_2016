/***************************************************************************************************
Funciones del sistema
****************************************************************************************************/
USE Northwind
GO
/* Funciones de conjunto de filas
*****************************************************
Son funciones que se caracterizan por devolver un objeto que se puede utilizar, como las referencias
de tabla en una instrucci�n SQL.

-OPENDATASOURCE
-OPENROWSET
-OPENQUERY
-OPENXML
*/


/* Funciones de agregado
*****************************************************
Son funciones que se caracterizan por operar sobre una colecci�n de valores y devolver un solo valor de resumen.
*/

-- Calcula el promedio subtotal
SELECT AVG(Quantity * UnitPrice) AS 'Promedio subTotal'
FROM [Order Details]
GO

-- Determina el menor valor del stock actual. Luego, muestra qu� productos tienen el mismo stock que el menor valor
DECLARE @minStock INT
SELECT @minStock = MIN(UnitsInStock)
FROM Products

SELECT *
FROM Products
WHERE UnitsInStock = @minStock
GO

/*
CHECKSUM_AGG:

- Devuelve la suma de comprobaci�n de valores de un grupo; as�mismo, omite los valores NULL que se presenten.
- Detecta cambios en la lista de valores/tabla calculando una suma de verificaci�n.
- Solo funciona con INTEGER
- Ignora NULL
- No muestra qu� fila ha cambiado


Seg�n le�, el CHECKSUM_AGG, devuelve un valor correspondiente a la suma de verificaci�nn. Es decir, 
si consulto a la tbl detalles con esa funci�nn, devolver� un valor entero que representa el estado actual de
esas filas. 

Ahora, si actualizo alguna de esas filas (con esos campos) y aplico nuevamente la funci�n, �ste devolver� otro
n�mero, lo que indica que se ha realizado una actualizaci�n en dichos registros.
*/

--Verificando el CHECKSUM_AGG actual
SELECT CHECKSUM_AGG(CAST(Quantity * UnitPrice AS INT)) --4521
FROM [Order Details]
GO

--Insertado una fila
INSERT INTO [Order Details](OrderID, ProductID, UnitPrice, Quantity, Discount)
VALUES(10248,14, 100, 100, 0)
GO

/*Al verificar el CHECKSUM_AGG, verificamos que nos devuelve otro valor, indicando
que ha habido cambios a los datos consultados inicialmente.
*/
SELECT CHECKSUM_AGG(CAST(Quantity * UnitPrice AS INT)) --14009
FROM [Order Details]
GO

DELETE FROM [Order Details] WHERE OrderID = 10248 AND ProductID = 14
GO


/* Funciones de categor�a
******************************************************/
/*
RANK, clasifica los elementos de un grupo en psiciones tipo ranking: primero, segundo, tercero.
Si hay datos con el mismo valor, se colocan dentro de la misma posici�n, como si se tratase de
un empate;
*/
SELECT uni_pro AS UNIDAD, des_pro AS DESCRIPCION, pre_pro AS PRECIO,
	   RANK() OVER(PARTITION BY uni_pro ORDER BY pre_pro DESC) AS ESCALA
FROM compras.producto
GO

/*
NTILE, distribuye las filas de una partici�n ordenada en un n�mero especificado de grupos. Los
grupos se numeran a partir de uno.
*/
SELECT uni_pro AS UNIDAD, des_pro AS DESCRIPCION, pre_pro AS PRECIO,
NTILE(4) OVER(ORDER BY uni_pro DESC) AS GRUPO
FROM compras.producto
GO

/*
ROW_NUMBER, devuelve un n�mero secuencial de una fila dentro de una partici�n de un
conjunto de resultados.
*/
SELECT ROW_NUMBER() OVER(ORDER BY cod_pro ASC) AS NUMERO, 
		cod_pro AS CODIGO, des_pro AS DESCRIPCION, 
		pre_pro AS PRECIO
FROM compras.producto
GO

/* Funciones escalares
*****************************************************
Son funciones que se caracterizan por operar sobre un valor y despu�s devolver otro valor. 
Las funcioens escalares se pueden utilziar donde la expresi�n sea v�lida.
*/

/*
FUNCIONES DE CONFIGURACI�N
*/

-- Muestra el nombre del servidor
SELECT @@SERVERNAME
GO

-- Muestra el idioma configurado en el servidor
SELECT @@LANGUAGE
GO

-- Muestra el nombre de la instancia del servidor SQL
SELECT @@SERVICENAME
GO

-- Muestra la versi�n de SQL Server actual
SELECT @@VERSION
GO

/*
FUNCIONES DE CONVERSI�N
*/

--PARSE: Se recomienda su uso para convertir tipos de cadena a tipos de fecha y hora y a n�mero
DECLARE @monto VARCHAR(10) = '2585,50'
SELECT PARSE(@monto AS MONEY USING 'es-ES') AS CONVERSION
GO

--otro ejemplo
DECLARE @fecha AS VARCHAR(10), @otraFecha AS VARCHAR(10)
SET @fecha = '13/09/2015' 
SET @otraFecha = '2020-07-28'

SELECT TRY_PARSE(@fecha AS DATE USING 'es-ES'); -- 2015-09-13 
SELECT TRY_PARSE(@otraFecha AS DATE); -- 2020-07-28

--TRY_CAST: Devuelve conversi�n de valor al tipo de datos especificado si la conversi�n se realiza correctamente; 
--de lo contrario devuelve NULL
SELECT TRY_CAST('12/07/2020' AS SMALLDATETIME) AS [CONVERSION OK],
	   TRY_CAST('12/07/151515' AS SMALLDATETIME) AS [CONVERSION FAIL]
GO

--TRY_CONVERT: Igual que el TRY_CAST
SELECT TRY_CONVERT(SMALLDATETIME, '12/12/2020'), TRY_CONVERT(SMALLDATETIME, '12/07/151515')
GO

/*
FUNCIONES DE FECHA Y HORA
*/

--SYSDATETIME: Devuelve el valor actual de la fecha y hora
SELECT SYSDATETIME()
GO

--SYSUTCDATETIM: Valor actual de la fecha universal
SELECT SYSUTCDATETIME()
GO

--CURRENT_TIMESTAMP: Valor actual de la fecha y hora en formato DateTime
SELECT CURRENT_TIMESTAMP
GO

--DATENAME: Cadena de caracteres que representa el par�metro especificado
SELECT DATENAME(mm, GETDATE()) --mm: mes, yy: a�o, hh: hora, etc...
GO

--DATEDIFF: Devuelve valor num�rico que representa la diferencia entre dos fechas
/*EJERCICIO. Mostrar la cantidad de a�os que tiene registrada cada factura con respecto a la fecha actual*/

SELECT num_fac AS FACTURA,
	   fec_fac AS FECHA,
	   DATEDIFF(YY, fec_fac, GETDATE()) AS [ANOS]
FROM ventas.factura
GO

--DATEADD: Aumenta o disminuye valores en una fecha determinada
DECLARE @fecha DATE = GETDATE()
DECLARE @i INT = 1
PRINT 'LISTADO DE FECHAS DE PAGO'
PRINT 'FECHA ACTUAL: ' + CAST(@fecha AS VARCHAR(10))
PRINT '---------------------------------------------'
WHILE @i <= 10
	BEGIN
		PRINT DATEADD(MONTH, @i, @fecha)
		SET @i += 1
	END
GO

--EOMONTH: Devuelve el �ltimo d�a del mes que contiene una fecha
SELECT GETDATE() AS 'DIA ACTUAL', EOMONTH(GETDATE()) AS 'ULTIMO DIA DEL MES'
GO

--SET DATEFORMAT: Define el formato de la fecha que se especifica en consultas o inserciones de registros. Se tiene las siguientes opciones.
/*
OPCIONES:
SET DATEFORMAT DMY
SET DATEFORMAT YMD
SET DATEFORMAT DYM
*/
-- Set date format to day/month/year.  
SET DATEFORMAT DMY;  
GO  

--GETDATE(): Devuelve la fecha actual
SELECT GETDATE() AS FECHA_ACTUAL
GO

--DATEPART(): Devuelve un n�mero correspondiente a la parte de la fecha
SELECT DATEPART(dd, GETDATE()) AS [DIA ACTUAL], 
		DATEPART(mm, GETDATE()) AS [MES ACTUAL], 
		DATEPART(yy, GETDATE()) AS [ANIO ACTUAL]
GO

--DAY(), MONTH(), YEAR()
SELECT DAY(GETDATE()) AS [DIA ACTUAL],
		MONTH(GETDATE()) AS [MES ACTUAL],
		YEAR(GETDATE()) AS [ANIO ACTUAL]
GO



/*
FUNCIONES L�GICAS
*/

--CHOOSE, devuelve un valor de un conjunto de valores especificado por un �ndice.
SELECT GETDATE() AS [FECHA ACTUAL],
		DAY(GETDATE()) AS [DIA],
		CHOOSE(MONTH(GETDATE()), 'ENERO', 'FEBRERO', 'MARZO','ABRIL', 'MAYO', 'JUNIO',
				'JULIO', 'AGOSTO', 'SETIEMBRE', 'OCTUBRE', 'NOVIEMBRE', 'DICIEMBRE') AS MES,
		YEAR(GETDATE()) AS [ANIO]
GO

--IIF: Devuelve uno de dos valores, dependiendo de la evaluaci�n de la condici�n
DECLARE @tipo INT = 1
SELECT IIF(@tipo = 1, 'ES DE VENTAS', 'NO ES VENTAS') AS [DESCRIPTION]
GO

/*-- FUNCIONES DE METADATOS --*/
SELECT DB_NAME()
GO

SELECT APP_NAME()
GO

/*-- FUNCIONES DE SEGURIDAD --*/
SELECT SCHEMA_NAME()
GO

SELECT SUSER_SNAME()
GO

/*-- FUNCIONES DE CADENA --*/
--ASCII
SELECT ASCII('a') AS a, ASCII('A') AS A
GO

--LTRIM: Quita espacios en blanco de la izq.
--RTRIM: Quita espacioes a la derecha.
--TRIM:	Quita espacios tanto en izquierda como en derecha.
DECLARE @cad VARCHAR(30) = ' HOLA '
SELECT LEN(@cad) AS [Longitud original],
		LEN(LTRIM(@cad)) AS [LTRIM],
		LEN(RTRIM(@cad)) AS [RTRIM],
		LEN(TRIM(@cad)) AS [TRIM]
		
GO

--CHAR():  Convierte un ASCII en CARACTER
SELECT CHAR(97) AS '97', CHAR(241) AS '241'
GO

--STUFF: Devuelve una cadena formada por la inserci�n de una cadena en otra
DECLARE @cad1 VARCHAR(4) = 'ABCD'
DECLARE @cad2 VARCHAR(5) = '12345'
SELECT @cad1 AS [CADENA 1], @cad2 AS [CADENA 2],
	   STUFF(@cad1, 2, 2, @cad2) AS [NUEVA CADENA]
GO

--REPLACE: Reemplaza una cadena dentro de otra
DECLARE @codigo VARCHAR(4) = 'C001'
SELECT @codigo, REPLACE(@codigo, '0', 'X') AS [NUEVO CODIGO]
GO

--SUBSTRING(): Devuelve cadena de caracteres desde pos inicial + cantidad de caracteres requeridas.
DECLARE @codigo CHAR(4) = 'C001'
SELECT SUBSTRING(@codigo, 1,1) AS LETRA, --Posici�n 1, 1 caracter
		SUBSTRING(@codigo, 2, 3) AS NUMERO --Posici�n 2, 3 caracteres
GO

--FORMAT: Devuelve un valor con formato aplicado a valores tipo fecha/hora, n�mero y cadenas
DECLARE @fecha DATETIME = GETDATE()
SELECT FORMAT(@fecha, 'd', 'en-US') AS 'FORMATO AMERICANO',
	   FORMAT(@fecha, 'd', 'es-ES') AS 'FORMATO ESPANIOL', --19/01/2024
	   FORMAT(@fecha, 'd', 'de-de') AS 'FORMATO ALEMAN'
GO

DECLARE @fecha DATETIME = GETDATE()
SELECT FORMAT(@fecha, 'D', 'en-US') AS 'FORMATO AMERICANO',
	   FORMAT(@fecha, 'D', 'es-ES') AS 'FORMATO ESPANIOL', --viernes, 19 de enero de 2024
	   FORMAT(@fecha, 'D', 'de-de') AS 'FORMATO ALEMAN'
GO

DECLARE @telefono INT = '943649626'
SELECT FORMAT(@telefono, '###-######') AS 'PHONE NUMBER'
GO

DECLARE @salary MONEY = 2500.50
SELECT FORMAT(@salary, 'C', 'es-pe') AS 'FORMATO MONEDA PERUANA'
GO

--REPLICATE: Permite asignar uno o m�s caracteres en una cadena
DECLARE @num VARCHAR(10) = '14'
DECLARE @totalLength SMALLINT = 6
SELECT REPLICATE('0', (@totalLength  - LEN(@num))) + @num AS [FORMATO]
GO

/*-- FUNCIONES ESTAD�STICAS DEL SISTEMA --*/
SELECT @@CONNECTIONS
GO