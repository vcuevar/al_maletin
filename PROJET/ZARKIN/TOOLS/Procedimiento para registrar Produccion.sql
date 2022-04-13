-- Vicente Romero el 20 de Noviembre del 2013

-- ****************** INICIA PROCEDIMIENTO  ***************************
-- REGISTRAR PRODUCTO TERMINADO EN CONTROL DE PISO CUANDO POR ALGUNA CAUSA NO SE HAYA REGISTRADO POR MEDIO DE LA APLICACION  ---------------

DECLARE @ID_EMPLEADO INT
DECLARE @ESTACION INT
DECLARE @ORDEN INT
DECLARE @CANTIDAD INT
DECLARE @CONTADOR INT
DECLARE @CODE NVARCHAR(8)

SET @ID_EMPLEADO = 777     -- ESPECIFICAR USUARIO 7 corresponde a vicente QUE REGISTRA
SET @ESTACION = 175        -- 175 INSPECCIONAR EMPAQUE, 418 CARPINTERIA  
SET @ORDEN = 161         -- INDICAR ORDEN A REGISTRAR
SET @CANTIDAD = 1       -- INDICR LA CANTIDAD A REGISTRAR

SET @CONTADOR =1
WHILE @CONTADOR  <= @CANTIDAD 
   BEGIN
       
      SET @CODE = (SELECT MAX(CONVERT(INT,CODE)) FROM [@CP_LOGOF]) + 1 
       
      INSERT INTO [@CP_LOGOF]  (Code , Name , U_idEmpleado ,      U_CT , U_Status , U_FechaHora , U_DocEntry , U_Cantidad , U_Reproceso)
                        VALUES (@CODE, @CODE, @ID_EMPLEADO , @ESTACION ,       'T',   GETDATE (),     @ORDEN ,           1,        'N' )
      
     PRINT 'Consecutivo: ' + cast(@CONTADOR as varchar(10))  + ' CODE: ' + cast(@CODE as varchar (10))
      
      SET @CONTADOR = @CONTADOR + 1
   END

/* Ordenes Terminadas en Octubre y no se registraron en el reporte de Produccion Terminada.
	22727 y 27043 se aplico procedimiento el 5/noviembre/14 */
