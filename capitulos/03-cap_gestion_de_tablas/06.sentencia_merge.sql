/***************************************************************************************************
Sentencia MERGE
***************************************************************************************************
Puede realizar  operaciones de inserción, actualización o eliminacón en una misma tabla.

Las características de la sentencia MERGE son:

- Sincronizar datos de dos tablas. Permite realizar una comparación entre dos tablas con la misma estructura, 
  quizás en una copia de seguridad, ya que MERGE puede igualar registros entre dos tablas.

- Registrar información. Cuando se registra un dato por primera vez, lo inserta como nuevo valor; 
  en las siguientes veces, para el mismo registro, solo actualiza sus valores.

La sintaxis de MERGE es:

MERGE <table_destino> [AS TARGET]
USING <table_origen> [AS SOURCE]
   ON <condicion_compara_llaves>
[WHEN MATCHED THEN 
    <accion cuando coinciden> ]
[WHEN NOT MATCHED [BY TARGET] THEN 
    <accion cuando no coinciden por destino> ]
[WHEN NOT MATCHED BY SOURCE THEN 
    <accion cuando no coinciden por origen> ];

DONDE:
MERGE <table_destino> [AS TARGET]
USING <table_origen> [AS SOURCE], sincronizará la tabla TARGET con los datos actuales de la tabla SOURCE.

ON <condicion_compara_llaves>
[WHEN MATCHED THEN 
    <accion cuando coinciden> ], cuando los registros concuerdan por la llave podemos actualizar los registros.

[WHEN NOT MATCHED [BY TARGET] THEN 
    <accion cuando no coinciden por destino> ], cuando los registros no concuerdan por la llave, indica que es un
	dato nuevo, podemos insertar el registro en la tabla target proveniente de la tabla source.

[WHEN NOT MATCHED BY SOURCE THEN 
    <accion cuando no coinciden por origen> ], cuando el registro existe en target pero no existe en source
	podemos borrar dicho registro en target.
*/

USE db_store
GO

/*EJERCICIO 01. Este ejercicio no es del libro, lo encontré por la web, pero lo coloco para tener otro ejemplo. */
IF OBJECT_ID('students') IS NOT NULL
	DROP TABLE students
GO

IF OBJECT_ID('current_students') IS NOT NULL
	DROP TABLE current_students
GO

CREATE TABLE students(
	code INT PRIMARY KEY NOT NULL,
	name VARCHAR(100) NOT NULL,
	year INT,
	grade VARCHAR(10),
)
GO

CREATE TABLE current_students(
	code INT PRIMARY KEY NOT NULL,
	name VARCHAR(100) NOT NULL,
	year INT,
	grade VARCHAR(10),
)
GO

INSERT INTO students(code, name, year, grade)
VALUES(1, 'Luis Enrique', 28, ''),
(2,'Susan Miñano', 30, ''),
(3,'Tinkler Flores', 24, ''),
(4,'Jeyson Orellano', 29, ''),
(5,'Rosa María', 35, ''),
(6,'Estudiante no existe en la tabla de source, este registro debe ser eliminado', 1000, '')
GO

INSERT INTO current_students(code, name, year, grade)
VALUES(1,'Luis Enrique', 28, 'A'),
(2,'Susan Miñano', 30, 'C'),
(3,'Tinkler Flores', 24, 'A'),
(4,'Jeyson Orellano', 29, 'A'),
(5,'Rosa María', 35, 'B'),
(20,'Marzeth Hinostroza', 22, 'A'),
(21,'Marco Antonio', 18, 'B'),
(22,'Belén Velez', 26, 'A')
GO


SELECT * 
FROM students
GO

SELECT * 
FROM current_students
GO

-- Usando MERGE
MERGE students AS target
USING current_students AS source
ON (target.code = source.code)
WHEN MATCHED THEN
	UPDATE SET target.grade = source.grade
WHEN NOT MATCHED BY target THEN
	INSERT (code, name, year, grade)
	VALUES(source.code, source.name, source.year, source.grade)
WHEN NOT MATCHED BY source THEN
	DELETE;	
GO

SELECT * 
FROM students
GO

SELECT * 
FROM current_students
GO


/*
EJERCICIO 02. Implementar un MERGE que permita registrar un nuevo producto. Si este producto ya se encuentra
registrado, solo actualizará sus datos; caso contrario, lo registrará como un nuevo registro.
*/
IF OBJECT_ID('productos') IS NOT NULL
	DROP TABLE productos
GO

CREATE TABLE productos(
	cod_pro CHAR(5)		NOT NULL PRIMARY KEY,
	des_pro VARCHAR(50) NOT NULL,
	pre_pro MONEY		NOT NULL CHECK(pre_pro BETWEEN 1 AND 100),
	sac_pro INT			NOT NULL CHECK(sac_pro > 0),
	smi_pro INT			NOT NULL,
	uni_pro VARCHAR(30) NOT NULL CHECK(uni_pro IN('BOLSA', 'CAJA', 'PAQUETE')),
	lin_pro VARCHAR(30) NOT NULL,
	imp_pro VARCHAR(10) NOT NULL
)
GO

SELECT *
FROM productos
GO

-- SOLUCIÓN
DECLARE @cod CHAR(5), @des VARCHAR(50), @pre MONEY,
		@sac INT, @smi INT, @uni VARCHAR(30), 
		@lin VARCHAR(30), @imp VARCHAR(10)

SET @cod = 'P001'
SET @des = 'PAPEL BOND A-4'
SET @pre = 20.50
SET @sac = 50
SET @smi = 1500
SET @uni = 'CAJA'
SET @lin = '2'
SET @imp = 'F'

MERGE productos AS target 
USING(SELECT @cod, @des, @pre, @sac, @smi, @uni, @lin, @imp) AS source(cod_pro, des_pro, pre_pro, sac_pro, smi_pro, uni_pro, lin_pro, imp_pro)
ON(target.cod_pro = source.cod_pro)
WHEN MATCHED THEN
	UPDATE SET 
			target.des_pro = source.des_pro, target.pre_pro = source.pre_pro,
			target.sac_pro = source.sac_pro, target.smi_pro = source.smi_pro,
			target.uni_pro = source.uni_pro, target.lin_pro = source.lin_pro,
			target.imp_pro = source.imp_pro
WHEN NOT MATCHED THEN
	INSERT VALUES(source.cod_pro, source.des_pro, source.pre_pro, source.sac_pro, 
					source.smi_pro, source.uni_pro, source.lin_pro, source.imp_pro);
GO

SELECT *
FROM productos
GO

