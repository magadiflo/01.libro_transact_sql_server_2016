/***************************************************************************************************
Triggers
****************************************************************************************************
- AFTER: Son aquellos que se disparan después de una acción. Especifica que el desencadenador DML solo 
  se activa cuando todas las operaciones especificadas en la instrucción SQL desencadenadora se han
  ejecutado correctamente. Si solo se usa FOR se sobreentiende que es del tipo AFTER (por defecto)

- INSTEAD OF: Se dispara antes de que ocurra un cambio en las tablas (insert, update, delete) cuando se
  dispara cancela el resto de las acciones, ejecutando solo el que cumpla el criterio definido.


Formato para triggers DML

CREATE TRIGGER <NOMBRE_TRIGGER>
ON <TABLE>
FOR | AFTER | INSTEAD OF
	[INSERT] [,] [UPDATE] [,] [ DELETE ]
AS
	SENTENCIA_SQL
*/

USE db_store
GO

/* Ejemplo 01
******************************************************
Mostrar todos los triggers de la base de datos
*/
SELECT *
FROM SYS.TRIGGERS
GO

/* Ejemplo 02
******************************************************
Eliminar un trigger
*/
DROP TRIGGER tr_prueba
GO

/* Ejemplo 03
******************************************************
Inhabilitar un trigger: La inhabilitación indica que la tabla podrá ejecutar sus sentencias DML sin mayor control
del trigger inhabilitado.
*/
DISABLE TRIGGER tr_prueba
ON tbl_tabla
GO


/* Ejemplo 04
******************************************************
Habilitar un trigger
*/
ENABLE TRIGGER tr_prueba
ON tbl_tabla
GO


/* Ejemplo 05
******************************************************
Inhabilitar todos los triggers de una determinada tabla
*/
ALTER TABLE tbl_tabla
DISABLE TRIGGER ALL
GO


/* Ejemplo 06
******************************************************
Implemente un trigger que permita mostrar un mensaje cada vez que se inserte o actualice un 
registro en la tabla clients
*/

CREATE TRIGGER tx_message_client
ON clients
FOR INSERT, UPDATE
AS
	BEGIN
		PRINT 'Mensaje disparado por la inserción o actualización de la tabla clients'
	END
GO

-- Probar el trigger con inserción
INSERT INTO clients(firstname, lastname, ruc, phone)
VALUES('Test', 'Test', '12345678912', '943669685')
GO
-- Probar el trigger con una actualización
UPDATE clients
SET ruc = '10000000001'
WHERE id = 2
GO

SELECT * 
FROM clients

/* Ejemplo 07
******************************************************
Implemente un trigger que permita crear un histórico de los registros realizados a la tabla facturas, en la 
cual por cada registro realizado por un cliente deberá enviar el código del cliente y el conteo total
de facturas realizadas por dicho cliente a una nueva tabla llamada facturas por cliente.


¡IMPORTANTE!

Los triggers definen 2 tablas especiales que contienen toda la informacion que necesitamos: INSERTED y DELETED

- INSERTED: Contiene los registros con los nuevos valores para triggers que se desencadenan con sentencias INSERT y UPDATE.
- DELETED: Contiene los registros con los viejos valores.

Así pues, en un trigger definido como AFTER INSERT sólo dispondremos de la tabla INSERTED, en uno definido 
como AFTER DELETE solamente tendremos la tabla DELETED, mientras que, finalmente, ambas tablas estarán disponibles 
en triggers definidos para ejecutarse tras un UPDATE con AFTER UPDATE, pudiendo consultar así de los valores antes y después
de actualizarse los registros correspondientes.

*/
-- Creando tabla para registrar histórico
CREATE TABLE facturas_x_cliente(
	cliente VARCHAR(30) NOT NULL,
	total INT
)
GO

CREATE OR ALTER TRIGGER tx_facturas_x_cliente
ON facturas
AFTER INSERT
AS
	BEGIN
		DECLARE @total INT, @codCli VARCHAR(30)

		SELECT @total = COUNT(*)
		FROM facturas AS f
			INNER JOIN INSERTED AS i ON(f.cod_cli = i.cod_cli)

		SELECT @codCli = INSERTED.cod_cli
		FROM INSERTED

		IF EXISTS(SELECT * FROM facturas_x_cliente WHERE cliente = @codCli)
			BEGIN
				UPDATE facturas_x_cliente
				SET total = @total
				WHERE cliente = @codCli
			END
		ELSE
			BEGIN
				INSERT INTO facturas_x_cliente(cliente, total)
				VALUES(@codCli, @total)
			END
	END
GO

-- Insertando registro en facturas
INSERT INTO facturas(fec_fac, fec_can, est_fac, por_igv, cod_cli)
VALUES('2024-01-23', '2024-01-22', 'REALIZADO', 18, 'C0001')
GO

INSERT INTO facturas(fec_fac, fec_can, est_fac, por_igv, cod_cli)
VALUES('2024-01-15', '2024-01-14', 'RECIBIDO', 21, 'C0001')
GO

SELECT * 
FROM facturas
GO

SELECT * 
FROM facturas_x_cliente
GO


/* Ejemplo 08
******************************************************
Implemente un trigger que permita controlar los registros de la tabla distrito; si el nombre de dicho distrito fue
registrado, entonces deberá mostrar con qué código fue registrado; en caso contrario, emitir un mensaje de
"Distrito registrado correctamente"
*/

CREATE TABLE distrito(
	cod_dist CHAR(5) PRIMARY KEY,
	nom_dist VARCHAR(50)
)
GO

CREATE OR ALTER TRIGGER tx_valida_distrito
ON distrito
FOR INSERT -- FOR, recordemos la definición de la parte superior, si solo se usa el FOR, significa que es del tipo AFTER. En este caso, después de haber insertado.
AS
	BEGIN
		DECLARE @count INT
		
		SELECT @count = COUNT(*)
		FROM distrito AS d 
			INNER JOIN INSERTED AS i ON(d.nom_dist = i.nom_dist)

		PRINT 'Total registrados: ' + CAST(@count AS VARCHAR)

		IF @count > 1 
			BEGIN
				DECLARE @distrito VARCHAR(50), @cod CHAR(5)

				SELECT @distrito = nom_dist
				FROM INSERTED

				ROLLBACK

				SELECT @cod = distrito.cod_dist
				FROM distrito
				WHERE distrito.nom_dist = @distrito

				PRINT 'Nombre de distrito ya registrado en la tabla'
				PRINT ''
				PRINT 'El distrito ' + @distrito + ' está registrado con el código: ' + @cod
			END
		ELSE
			BEGIN
				PRINT 'Distrito registrado correctamente'
			END		
	END
GO

-- Insertando registro en distrito
INSERT INTO distrito(cod_dist, nom_dist)
VALUES('D0001', 'CHIMBOTE')
GO

INSERT INTO distrito(cod_dist, nom_dist)
VALUES('D0002', 'CHIMBOTE')
GO

SELECT * 
FROM distrito
GO

TRUNCATE TABLE distrito
GO

/* Ejemplo 09
******************************************************
Implemente un trigger que permita controla la eliminación de un registro de una tabla cliente; en
la cual, si dicho cliente tiene facturas registradas, no permita su eliminación mostrando un
mensaje; en caso contrario, mostrar el mensaje "eliminación correcta".
*/

-- Creando escenario
DROP TABLE facturas
DROP TABLE clients
GO

CREATE TABLE clients(
	cod_cli CHAR(5) NOT NULL PRIMARY KEY,
	nom_cli VARCHAR(100) NOT NULL,
	tlf_cli CHAR(9)
)
GO

CREATE TABLE facturas(
	num_fact CHAR(11) NOT NULL PRIMARY KEY,
	cod_cli CHAR(5) NOT NULL,
	fec_fac DATE NOT NULL,
	por_igv DECIMAL(18,0) NOT NULL,
	CONSTRAINT fk_clients_facturas FOREIGN KEY(cod_cli) REFERENCES clients(cod_cli)
)
GO

INSERT INTO clients(cod_cli, nom_cli, tlf_cli)
VALUES('C0001', 'Martín Díaz', '974854789'),
('C0002', 'Paulina Rubio', '945859658'),
('C0003', 'Carlos Pinto', '943857456')
GO

INSERT INTO facturas(num_fact, cod_cli, fec_fac, por_igv)
VALUES('F01001', 'C0001', '2024-01-23', 18),
('F01002', 'C0001', '2024-01-23', 18),
('F01003', 'C0001', '2024-01-23', 18),
('F01004', 'C0001', '2024-01-23', 18)
GO

SELECT * 
FROM clients AS c
	INNER JOIN facturas AS f ON(c.cod_cli = f.cod_cli)
GO

-- Implementando Trigger
CREATE OR ALTER TRIGGER tx_elimina_cliente
ON clients
INSTEAD OF DELETE
AS
	BEGIN
		DECLARE @codCli CHAR(5)
		SET @codCli = (SELECT cod_cli 
					   FROM DELETED)

		IF EXISTS(SELECT * FROM facturas WHERE cod_cli = @codCli)
			BEGIN
				ROLLBACK TRANSACTION
				PRINT 'El cliente tiene facturas registradas, no puede eliminarse'
			END
		ELSE 
			BEGIN
				DELETE FROM clients WHERE cod_cli = @codCli
				PRINT 'Cliente eliminado correctamente'
			END

	END
GO

-- Probando trigger
DELETE FROM clients WHERE cod_cli = 'C0001'
GO

SELECT * 
FROM clients
GO

SELECT * 
FROM facturas
GO

/* Ejemplo 10
******************************************************
Implemente un trigger que permita controlar el registro de un detalle de factura, 
en la cual se evalúe la cantidad registrada para que no se registre un valor inferior
a cero en la columna cantidad de venta
*/
-- Preparando escenario
CREATE TABLE detalle_factura(
	num_fac CHAR(11) NOT NULL,
	cod_pro CHAR(5) NOT NULL,
	can_ven INT NOT NULL,
	pre_ven MONEY NOT NULL,
	PRIMARY KEY(num_fac, cod_pro),
	FOREIGN KEY(num_fac) REFERENCES facturas(num_fact),
	FOREIGN KEY(cod_pro) REFERENCES productos(cod_pro)
)
GO

SELECT * 
FROM facturas
GO

SELECT *
FROM productos
GO

SELECT * 
FROM detalle_factura
GO

-- Creando trigger
CREATE OR ALTER TRIGGER tx_valida_detalle
ON detalle_factura
FOR INSERT
AS
	BEGIN
		IF (SELECT can_ven FROM INSERTED) <= 0
			BEGIN
				ROLLBACK TRANSACTION
				PRINT 'No se puede insertar valores inferiores o iguales a cero (0)'
			END
		ELSE
			BEGIN
				PRINT 'Cantidad registrada correctamente'
			END
	END
GO

-- Probando trigger
INSERT INTO detalle_factura(num_fac, cod_pro, can_ven, pre_ven)
VALUES('F01001', 'P001', 50, 1.50)
GO

INSERT INTO detalle_factura(num_fac, cod_pro, can_ven, pre_ven)
VALUES('F01002', 'P002', 0, 1.50)
GO


SELECT * 
FROM detalle_factura
GO

/* Ejemplo 11
******************************************************
Implemente un trigger que permita crear una réplica de los registros insertados en la tabla distrito;
para dicho proceso debe implementar una nueva tabla llamada distrito_bak con las mismas columnas que 
la tabla distrito
*/

-- Preparando escenario
CREATE TABLE distrito_bak(
	cod_dist CHAR(5) PRIMARY KEY,
	nom_dist VARCHAR(50)
)
GO

-- Creando trigger
CREATE OR ALTER TRIGGER tx_replica_distrito
ON distrito
AFTER INSERT -- Se dispara después de hacer el insert
AS
	SET NOCOUNT ON -- Deshabilitamos la impresión en pantalla del número de registros afectados, esto evita que se den cuenta que esta tabla tiene asignado un trigger

	BEGIN
		INSERT INTO distrito_bak(cod_dist, nom_dist)
		SELECT i.cod_dist, i.nom_dist
		FROM INSERTED AS i
	END
GO

-- Probando
INSERT INTO distrito(cod_dist, nom_dist)
VALUES('D0003', 'SANTA')
GO

SELECT * 
FROM distrito
GO
SELECT *
FROM distrito_bak
GO