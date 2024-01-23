/***************************************************************************************************
For XML y OPENXML
****************************************************************************************************
Es posible ejecutar consultas SQL para obtener resultados en formato XML en lugar de conjuntos
de filas estándar. Estas consultas pueden ejecutarse directamente o desde procedimientos almacenados
y funciones definidas por el usuario. Para obtener los resultados directamente, se utiliza primero
la cláusula FOR XML de la instrucción SELECT. A continuación, dentro de la cláusula FOR XML, 
se especifica un modo de XML: RAW, AUTO, EXPLICIT o PATH

- RAW[('ElementName')]: Obtiene el resultado de la consulta y transforma cada fila del conjunto de
  resultados en un elemento XML con un identificador genérico <row/> como etiqueta de elemento.
  Opcionalmente, puede especificar un nombre para el elemento de fila cuando se utiliza esta directiva. 
  El XML resultante utilizará el ElementName especificado como el elemento de fila generado para cada fila.

- AUTO: Devuelve los resultados de la consulta en un árbol anidado XML sencillo.

- EXPLICIT: Especifica que la forma del árbol XML resultante está definida explícitamente.

- PATH: Facilita la mezcla de elementos y atributos, así como la especificación de anidación
  adicional para representar propiedades complejas.
*/
USE Northwind
GO

/* Ejemplo 01
******************************************************
Script que permita mostrar los registros de la tabla employees en un elemento XML genérico.
Se usará la cláusula FOR XML en modo RAW
*/
SELECT EmployeeID, FirstName, LastName, Address 
FROM Employees
FOR XML RAW
GO



/* Ejemplo 02
******************************************************
Script que permita mostrar los registros de la tabla Customers en un elemento genérico.
Se usará la cláusula FOR XML en modo ELEMENTS.


NOTA: Si se especifica ELEMENTS, las columnas se devuelvcen como subelementos.
Sin embargo, se les asignan atributos XML. Esta opción solo se admite en los modos RAW, AUTO
y PATH.
*/
SELECT CustomerID AS id, ContactName AS contact, ContactTitle AS title, Address AS address
FROM Customers
FOR XML RAW, ELEMENTS
GO


/* Ejemplo 03
******************************************************
Script que permita ingresar registros desde un archivo XML hacia la tabla distrito de la bd db_store.

Para el ejercicio, crearemos un archivo en la siguiente ruta: 
M:\MAGADIFLO\distritos.xml
Este archivo deberá contener la siguiente información:

<distritos>
	<distrito>
		<cod_dist>D0001</cod_dist>
		<nom_dist>CHIMBOTE</nom_dist>
	</distrito>
	<distrito>
		<cod_dist>D0002</cod_dist>
		<nom_dist>NUEVO CHIMBOTE</nom_dist>
	</distrito>
	<distrito>
		<cod_dist>D0003</cod_dist>
		<nom_dist>COISHCO</nom_dist>
	</distrito>
	<distrito>
		<cod_dist>D0004</cod_dist>
		<nom_dist>SANTA</nom_dist>
	</distrito>
	<distrito>
		<cod_dist>D0005</cod_dist>
		<nom_dist>CASMA</nom_dist>
	</distrito>
</distritos>
*/
USE db_store
GO

CREATE TABLE distrito(
	cod_dist CHAR(5) NOT NULL PRIMARY KEY,
	nom_dist VARCHAR(50) NOT NULL
)
GO

INSERT INTO distrito(cod_dist, nom_dist)
SELECT d.distritos.query('cod_dist').value('.', 'CHAR(5)'), 
	   d.distritos.query('nom_dist').value('.', 'VARCHAR(50)')
FROM (SELECT CAST(d AS XML)
	  FROM OPENROWSET(BULK 'M:\MAGADIFLO\distritos.xml', SINGLE_BLOB) AS PROP(d)) AS PROP(d)
CROSS APPLY d.nodes('distritos/distrito') AS d(distritos);
GO

SELECT * 
FROM distrito
GO

sp_columns DISTRITO
truncate table DISTRITO

drop table DISTRITO

/* Ejemplo 04
******************************************************
Script que permita buscar un determinado proveedor mediante su código dentro
de un archivo XML
*/

DECLARE @pxml XML
SET @pxml = '<proveedores>
				<proveedor cod_prv="PR22">
					<cod_dis>D003</cod_dis>
					<rso_prv>MAYORSA</rso_prv>
					<dir_prv>AV. EL SOL 545</dir_prv>
					<tel_prv>586-9685</tel_prv>
					<rep_prv>JOSÉ MARTINEZ</rep_prv>
				</proveedor>
				<proveedor cod_prv="PR23">
					<cod_dis>D003</cod_dis>
					<rso_prv>MAYORSA</rso_prv>
					<dir_prv>AV. EL SOL 545</dir_prv>
					<tel_prv>586-9685</tel_prv>
					<rep_prv>MARK TENERE</rep_prv>
				</proveedor>
				<proveedor cod_prv="PR24">
					<cod_dis>D003</cod_dis>
					<rso_prv>MAYORSA</rso_prv>
					<dir_prv>AV. EL SOL 545</dir_prv>
					<tel_prv>586-9685</tel_prv>
					<rep_prv>JUAN RYTORES</rep_prv>
				</proveedor>
			</proveedores>'
--Buscando el proveedor con código PR23
SELECT @pxml.query('proveedores/proveedor[./@cod_prv="PR23"]')
GO