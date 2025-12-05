-- Nombre: 142 Resumen de Produccion por Areas.
-- Uso: Presenta Produccion de las areas de produccion en el rango establecido.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Lunes 11 de agosto del 2025; Origen.
-- Actualizado: Miercoles 24 de septiembre del 2025; Agregar cantidad fabricada.
/* ============================================================================
|  PARAMETROS.                                                                 |
=============================================================================*/
Declare @FechaIS as Date
Declare @FechaFS as Date
Declare @Estacion nVarchar(3) 

Set @FechaIS = CONVERT (DATE, '2025-09-22', 102)
Set @FechaFS = CONVERT (DATE, '2025-09-24', 102)
Set @Estacion = '209'

/* ============================================================================
|  Produccion reportada por rango de fecha.                                    |
=============================================================================*/

Select CAST(CP.U_FechaHora as DATE) AS Fecha
	, OP.DocEntry
	, RH.firstName
	, RH.lastName
	, OP.ItemCode
	, A3.ItemName AS Mueble
	, CP.U_Cantidad AS CANTIDAD
	, (A3.U_VS * CP.U_Cantidad) as U_VS
	, A4.ItemCode, A4.ItemName 
From OWOR OP 
inner join [@CP_LOGOF] CP on OP.DocEntry= CP.U_DocEntry 
inner join OHEM RH on CP.U_idEmpleado=RH.empID 
inner join OITM A3 on OP.ItemCode=A3.ItemCode 
left join OITM A4 on left(A3.ItemCode,4) = A4.ItemCode 
Where Cast(CP.U_FechaHora as date) BETWEEN @FechaIS and @FechaFS and CP.U_CT = @Estacion 
Order by CAST(CP.U_FechaHora as DATE), RH.firstName 

