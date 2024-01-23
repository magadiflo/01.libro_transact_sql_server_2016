/***************************************************************************************************
XML con SQL e Imágenes
****************************************************************************************************
*/

/* Ejemplo 01
******************************************************
Script que permita crear una tabla llamada CLIENTEXML en donde se registren el código y sus tipos de razon
social dentro de una columna de tipo XML
*/
IF OBJECT_ID('CLIENTEXML') IS NOT NULL
	DROP TABLE CLIENTEXML
GO

CREATE TABLE CLIENTEXML(
	codigo INT IDENTITY NOT NULL PRIMARY KEY,
	razon_social XML
)
GO

INSERT INTO CLIENTEXML(razon_social)
VALUES('<rsocial>Magadiflo SAC</rsocial>')
GO

SELECT *
FROM CLIENTEXML
GO

/* Ejemplo 02
******************************************************
Del ejemplo anterior, si se necesita registrar dos tipos de razón social por cada registro
de clientes, entonces se debe ejecutar el siguiente script.
*/
DECLARE @pxml AS XML
SET @pxml = '<rsocial>Magadiflo SAC</rsocial>
			 <rsocial>Multiservicios Maga</rsocial>
			 <rsocial>Magadiflo EIRL</rsocial>'
INSERT INTO CLIENTEXML(razon_social)
VALUES(@pxml)
GO

SELECT *
FROM CLIENTEXML
GO

/* Ejemplo 03
******************************************************
Script que permita crear una tabla llamada CLIENTEXML en donde se registren dos filas
al mismo tiempo; esta vez se implementará dentro del XML la columna código y razón social,
por lo menos dos tipos de razón social por cada cliente.
*/
IF OBJECT_ID('CLIENTEXML') IS NOT NULL
	DROP TABLE CLIENTEXML
GO
CREATE TABLE CLIENTEXML(
	codigo INT IDENTITY NOT NULL PRIMARY KEY,
	razon_social XML
)
GO

DECLARE @pxml AS XML
SET @pxml = '<clientes>
				<cliente>
					<codigo>P0001</codigo>
					<rsocial>Multiservicios Alison EIRL</rsocial>
				</cliente>
				<cliente>
					<codigo>P0002</codigo>
					<rsocial>SIDECOM SAC</rsocial>
				</cliente>
			</clientes>'
INSERT INTO CLIENTEXML(razon_social)
VALUES(@pxml)
GO

--Prueba
SELECT * FROM CLIENTEXML
GO

/* MÉTODOS DEL TIPO DE DATO XML
******************************************************
- query(): permite mostrar el contenido de una columna de tipo XML
- value(): permite recuperar un valor de tipo SQL de una instancia XML
- exist(): permite determinar si una consulta de tipo XML devuelve un resultado vacío
- nodes(): permite dividir varias filas, es decir, se propaga partes de
			documentos XML en conjunto de filas
*/


/* Ejemplo 04
******************************************************
Script que permita listar los registros de la tabla CLIENTEXML. Use el 
método QUERY
*/
SELECT codigo, razon_social.query('clientes')
FROM CLIENTEXML
GO

/* Ejemplo 05
******************************************************
Scritp que permita mostrar el código del cliente 1 y su segunda razón social registrado en 
la tabla CLIENTEXML. Use la función VALUE del tipo de dato XML.
*/
DECLARE @pxml AS XML
SET @pxml = '<clientes>
				<cliente>
					<codigo>P0001</codigo>
					<rsocial>Multiservicios Alison EIRL</rsocial>
					<rsocial>Pablito impresiones SAC</rsocial>
				</cliente>
				<cliente>
					<codigo>P0002</codigo>
					<rsocial>SIDECOM SAC</rsocial>
					<rsocial>MULTICOPIAS SA</rsocial>
				</cliente>
			</clientes>'
DECLARE @codigo AS CHAR(5), @razon AS VARCHAR(30)
SELECT @codigo = @pxml.value('(clientes/cliente/codigo)[1]', 'char(5)'),
	   @razon = @pxml.value('(clientes/cliente/rsocial)[2]', 'varchar(30)')

SELECT @codigo AS [CODIGO], @razon AS [RAZON SOCIAL]
GO

/* Ejemplo 06
******************************************************
Scritp que permita mostrar el registro según el código de un cliente ingresado por el usuario desde
la tabla CLIENTEXML. Se debe usar la función EXISTS del tipo de datos XML.
*/
DECLARE @n INT = 1
SELECT x.codigo, x.razon_social
FROM CLIENTEXML AS x
WHERE x.razon_social.exist('(clientes/cliente/rsocial)[2]') = @n
GO

/* Ejemplo 07
******************************************************
Script que permita inserar los registros de los clientes almacenados en un archivo XML y volcarlo a la tabla
CLIENTESXML. Se dbee usar la sentencia BULK.


Para lograr insertar registros desde un XML a una tabla se necesita tener un archivo XML preparado; esto se 
puede realizar en el block de notas, colocando el siguiente script:

'<clientes>
	<cliente>
		<codigo>CL001</codigo>
		<rsocial>LIMA-TEEN SAC</rsocial>
		<rsocial>LIMA-TEEN SRLTDA</rsocial>
	</cliente>
	<cliente>
		<codigo>CL002</codigo>
		<rsocial>PERU TEEN SAC</rsocial>
		<rsocial>PERU TEEN SRLTDA</rsocial>
	</cliente>
</clientes>'

El archivo lo colocaremos en la siguiente ruta:
D:\PROGRAMACION\DESARROLLO_BASE DE DATOS\SQL_SERVER\03_programacion_transact_sql_server_2016\cliente.xml
*/

INSERT INTO CLIENTEXML
SELECT razon_social
FROM (SELECT * 
		FROM OPENROWSET(BULK 'D:\PROGRAMACION\DESARROLLO_BASE DE DATOS\SQL_SERVER\03_programacion_transact_sql_server_2016\cliente.xml', SINGLE_CLOB) AS CLIENTEXML)
		AS P(razon_social)
GO