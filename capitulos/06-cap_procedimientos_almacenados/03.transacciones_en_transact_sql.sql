/***************************************************************************************************
Transacciones en Transact-SQL
****************************************************************************************************
Formato:

BEGIN <TRAN | TRANSACTION> NOMBRE_TRANSACCION
COMMIT TRAN <NOMBRE_TRANSACCION>
ROLLBACK TRAN <NOMBRE_TRANSACCIÓN>
*/
USE db_store
GO

SELECT * 
FROM proveedor
GO

SP_COLUMNS proveedor
GO

/* PRIMERA FORMA
******************************************************/
IF OBJECT_ID('sp_nuevo_proveedor') IS NOT NULL
	DROP PROCEDURE sp_nuevo_proveedor
GO

CREATE PROCEDURE sp_nuevo_proveedor(@cod CHAR(5), @rso VARCHAR(80), @dir VARCHAR(100), @tel CHAR(15))
AS
BEGIN TRANSACTION t_nuevo_proveedor
	INSERT INTO proveedor(cod_prv, rso_prv, dir_prv, tel_prv)
	VALUES(@cod, @rso, @dir, @tel)
	IF @@ERROR = 0
		BEGIN
			COMMIT TRANSACTION t_nuevo_proveedor
			PRINT 'Proveedor registrado correctamente'
		END
	ELSE
		BEGIN
			ROLLBACK TRANSACTION t_nuevo_proveedor
			PRINT 'Error, no se pudo insertar al proveedor'
		END
GO


--Ejecutando
EXECUTE sp_nuevo_proveedor 'PRO03', 'LG', 'Lima', '328596'
GO

/* SEGUNDA FORMA
******************************************************/
IF OBJECT_ID('sp_nuevo_proveedor') IS NOT NULL
	DROP PROCEDURE sp_nuevo_proveedor
GO

CREATE PROCEDURE sp_nuevo_proveedor(@cod CHAR(4), @rso VARCHAR(80), @dir VARCHAR(100), @tel CHAR(15))
AS
BEGIN TRY
	BEGIN TRANSACTION t_nuevo_proveedor
		INSERT INTO proveedor(cod_prv, rso_prv, dir_prv, tel_prv)
		VALUES(@cod, @rso, @dir, @tel)

		COMMIT TRANSACTION t_nuevo_proveedor
		PRINT 'PROVEEDOR REGISTRADO CORRECTAMENTE'
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION t_nuevo_proveedor
	PRINT 'ERROR, NO SE PUDO INSERTAR AL PROVEEDOR'
END CATCH

--Ejecutando
EXECUTE sp_nuevo_proveedor 'PRO05', 'Fierros', 'Arequipa', '357485'
GO

SELECT * 
FROM proveedor
GO


/* EJERCICIO
*****************************************************
Procedimiento almacenado que permita eliminar un proveedor
*/
IF OBJECT_ID('sp_eliminar_proveedor') IS NOT NULL
	DROP PROCEDURE sp_eliminar_proveedor
GO
CREATE PROCEDURE sp_eliminar_proveedor(@cod CHAR(5))
AS
BEGIN
	IF EXISTS(SELECT * FROM proveedor WHERE cod_prv = @cod)
		BEGIN TRY
			BEGIN TRANSACTION t_eliminar_proveedor
				DELETE FROM proveedor WHERE cod_prv = @cod

				COMMIT TRANSACTION t_eliminar_proveedor
				PRINT 'El proveedor fue eliminado'
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION t_eliminar_proveedor
			PRINT 'No se pudo eliminar al proveedor'
		END CATCH
	ELSE
		BEGIN
			PRINT 'El proveedor no existe'
		END
END

--Ejecutando
EXECUTE sp_eliminar_proveedor 'PRO02'
GO

