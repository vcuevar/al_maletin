-- Macro 140 Inspeccion de Materiales.
-- Objetivo: Reporte de los materiales inspeccionados en el area de coming.
-- Solicitado: Sr. Eduardo Belis.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Jueves 16 de Mayo del 2024; Origen.
-- Actualizado: 

/* ==============================================================================================
|     PARAMETROS GENERALES.                                                                     |
============================================================================================== */

Declare @FechaIS as Date
Declare @FechaFS as Date
Declare @xCodProd AS VarChar(20)

Set @FechaIS = CONVERT (DATE, '2024-05-13', 102)
Set @FechaFS = CONVERT (DATE, '2024-05-16', 102)
Set @xCodProd =  '17871' 

/* ==============================================================================================
|  Reporte Inspeccion por rango de fecha.                                                           |
============================================================================================== */

Select id AS ID
	, CAST(fechaRevision as Date) AS FE_REV
	, proveedorNombre AS PROVEEDOR
	, materialCodigo AS CODIGO
	, materialDescripcion AS MATERIAL
	, cantidadRecibida AS RECIBIDO
	, cantidadRevisada AS REVISADA
	, cantidadAceptada AS ACEPTADA
	, cantidadRechazada AS RECHAZADA
	, cantidadAceptada/cantidadRecibida AS PORC
	, InspectorNombre AS INSPECTOR
	, DocumentoNumero AS FACTURA
	, DescripcionRechazo AS MOT_RECHAZO
	, Observaciones AS OBSERVACION
	, T1.Descr AS GRUPPLAN
From Siz_Calidad_Rechazos
INNER JOIN OITM on OITM.ItemCode = Siz_Calidad_Rechazos.materialCodigo
LEFT JOIN UFD1 T1 on OITM.U_GrupoPlanea=T1.FldValue and T1.TableID='OITM' and T1.FieldID=9 
WHERE Cast(fechaRevision as date) between  @FechaIS and @FechaFS 
Order By fechaRevision, materialDescripcion


