/***************************************************************************************************
Procedimientos almacenados del sistema
****************************************************************************************************/

/* EJEMPLO 01
*****************************************************
Procedimiento almacenado del sistema que muestre los privilegios de las columnas involucradas en la 
tabla products
*/
USE Northwind
GO

SP_COLUMN_PRIVILEGES products
GO


/* EJEMPLO 02
*****************************************************
Procedimiento almacenado del sistema que muestre las columnas de la tabla products
*/

SP_COLUMNS products
GO


/* EJEMPLO 03
*****************************************************
Procedimiento almacenado del sistema que liste la información del producto con id = 10
*/
EXECUTE SP_EXECUTESQL N'SELECT * FROM products WHERE ProductId = @cod', N'@cod INT', @cod = 10
GO

/* EJEMPLO 04
*****************************************************
SP del sistema que devuelva una lista de nombres de atributo y sus valores correspondientes para SQL Server, la
puerta de enlace de la base de datos o el origen de datos subyacente del servidor activo
*/
SP_SERVER_INFO
GO

/* EJEMPLO 05
*****************************************************
Listar tablas creadas dentro de la base de datos actual
*/
SP_TABLES
GO