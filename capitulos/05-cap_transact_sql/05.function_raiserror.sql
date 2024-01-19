/***************************************************************************************************
Funci�n RAISERROR
***************************************************************************************************
Se usa para devolver mensajes definidos por el usuario a las aplicaciones con el mismo formato que un error del sistema
o un mensaje de advertencia generado por el Motor de Base de Datos SQLServer.

Formato:

RAISERROR <msg_id | msg_str | @local_variable, severity, state>

- msg_id: N�mero de msg de error definido por el usuario. El n�mero debe ser > 50 000. Si no
  se especifica el msg_id, RAISERROR genera unmensaje de error con el n�mero 50000.

- msg_str: Cadena de caracteres que incluye especificaciones de conversi�n opcionales.

- severity: Nivel de gravedad def. por el usuario asociado a este msg.

- state: N�mero entre 0 - 255
*/


/* EJERCICIO 01.
****************************************************
Implementar un script que permita controla el error de una divisi�n irreal.
*/
BEGIN TRY
	PRINT 1/0
END TRY
BEGIN CATCH
	DECLARE @messageError VARCHAR(4000)
	DECLARE @severidad INT
	DECLARE @estado INT

	SELECT @messageError = ERROR_MESSAGE(),
		   @severidad = ERROR_SEVERITY(),
		   @estado = ERROR_STATE()

	RAISERROR (@messageError, @severidad, @estado)
END CATCH
GO
