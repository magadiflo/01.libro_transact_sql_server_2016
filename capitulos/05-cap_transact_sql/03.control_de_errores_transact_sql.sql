/***************************************************************************************************
Control de errores en Transact SQL
***************************************************************************************************
Formato:

BEGIN TRY
	<expresión_sql>
END TRY
BEGIN CATCH
	<expresión_sql>
END CATCH

Funciones especiales de error:

- ERROR_NUMBER(), devuelve el número de error detectado.
- ERROR_MESSAGE(), devuelve el texto completo del mensaje de error. El texto
  incluye los valores suministrados para los parámetros sustituibles, como longitudes,
  nombres de objetos u horas.
- ERROR_SEVERITY(), devuelve la gravedad del error.
- ERROR_STATE(), devuelve el número de estado del error.
- ERROR_LINE(), devuelve el número de línea dentro de la rutina en que se produjo el error.
- ERROR_PROCEDURE(), devuelve el nombre del procedimiento almacenado o trigger en que se produjo el error.
*/

/* EJERCICIO 01.
****************************************************
Implementar un script que permita mostrar los valores que emiten las funciones de control de errores a 
partir de una división por cero.
*/
BEGIN TRY
	SELECT 1/0
END TRY
BEGIN CATCH
	SELECT
		ERROR_NUMBER() AS errorNumber, 
		ERROR_SEVERITY() AS errorSeverity,
		ERROR_STATE() AS errorState,
		ERROR_PROCEDURE() AS errorProcedure,
		ERROR_LINE() AS errorLine,
		ERROR_MESSAGE() AS errorMessage
END CATCH

/* EJERCICIO 02.
****************************************************
Implementar un script que permita registrar un nuevo distrito; en caso ocurriera algún error
en el registro, mostrar un mensaje
*/
USE db_proyectos_industriales

BEGIN TRY	
	DECLARE @cod VARCHAR(3) = 'D07', @nom VARCHAR(40) = 'MORO'

	INSERT INTO distrito(cod_dis, nom_dis)
	VALUES(@cod, @nom)
END TRY
BEGIN CATCH
	PRINT 'No se pudo insertar el registro'
	PRINT ERROR_MESSAGE()
END CATCH
GO
