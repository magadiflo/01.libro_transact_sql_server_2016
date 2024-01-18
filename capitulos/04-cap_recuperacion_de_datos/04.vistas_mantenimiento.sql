/***************************************************************************************************
Mantenimiento de datos mediante vistas
***************************************************************************************************
Las vistas pueden gestionar el mantenimiento de registros como si se tratase de una tabla, para 
lo cual se debe tener en cuenta que solo se pueden ejecutar tres tipos de sentencias como son 
INSERT, UPDATE y DELETE. Asímismo, se debe considerar que el mantenimiento se realiza a la vista
así como a la tabla original de forma automática.
*/
-- Primero crearemos una tabla clients en la bd_store
USE db_store
GO

CREATE TABLE clients(
	id INT NOT NULL IDENTITY,
	firstname VARCHAR(50) NOT NULL,
	lastname VARCHAR(50) NOT NULL,
	ruc CHAR(11) NOT NULL,
	phone CHAR(9) NOT NULL
)
GO

-- Empezamos con el ejercico del mantenimiento de la vista
IF OBJECT_ID('v_clients') IS NOT NULL
	DROP VIEW v_clients
GO

CREATE VIEW v_clients
AS
	SELECT * FROM clients
GO

-- Probamos
SELECT * 
FROM v_clients
GO

-- Insertando registros a través de la vista
INSERT INTO v_clients(firstname, lastname, ruc, phone)
VALUES('Karen', 'Caldas', '12345678921', '943698589')
GO

-- Actualizamos el phone del usuario anterior
UPDATE v_clients
SET phone = '943747474'
WHERE id = 1
GO

-- Eliminando registro
DELETE FROM v_clients WHERE id = 1
GO