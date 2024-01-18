/***************************************************************************************************
Función @@ERROR
***************************************************************************************************
@@ERROR es una variable global que devuelve 0 (cero) si la última sentencia T-SQL se ejecutó con éxito;
si la sentencia causó un error, @@ERROR devuelve el número de error.
*/

/* Listando posibles errores
****************************************************
Para mostrar el número de error, SQL presenta una lista de posibles errores
usando la siguiente sentencia:
*/
SELECT *
FROM SYS.SYSMESSAGES
GO



/* EJERCICIO 01.
****************************************************
*/
USE db_proyectos_industriales
GO

BEGIN TRY
	INSERT INTO distrito(cod_dis, nom_dis)
	VALUES('D01', 'CASCAJAL')
END TRY
BEGIN CATCH
	IF @@ERROR <> 0 
		PRINT 'Ocurrió un error al registrar un distrito'
		PRINT 'Mensaje: ' + ERROR_MESSAGE()
END CATCH

SELECT * FROM distrito
SELECT * FROM encargado