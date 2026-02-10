-- Macro 140 Inspeccion de Materiales.
-- Objetivo: Reporte de los materiales inspeccionados en el area de coming.
-- Solicitado: Sr. Eduardo Belis.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Jueves 16 de Mayo del 2024; Origen.
-- Actualizado: Viernes 08 de agosto del 2025; Alinear al nuevo sistema Incoming.

/* ==============================================================================================
|     PARAMETROS GENERALES.                                                                     |
============================================================================================== */

Declare @FechaIS as Date
Declare @FechaFS as Date
Declare @xCodProd AS VarChar(20)

Set @FechaIS = CONVERT (DATE, '2025-09-29', 102)
Set @FechaFS = CONVERT (DATE, '2025-10-15', 102)

Set @xCodProd =  '17871' 


/* ==============================================================================================
|  Utileria para cambio de algunos datos.                                                       |
============================================================================================== */
/*
Select * 
From Siz_Incoming 
--Where INC_docNum = 20249
WHERE Cast(INC_fechaInspeccion as date) =  @FechaIS

*/
-- Update Siz_Incoming Set INC_fechaInspeccion = CONVERT (DATE, '2025-09-26', 102) WHERE INC_id = 89
-- Update Siz_Incoming Set INC_fechaInspeccion = CONVERT (DATE, '2025-09-26', 102) WHERE INC_id = 116


/* ==============================================================================================
|  Reporte Inspeccion por rango de fecha. Nuevo Sistema Incoming                                |
============================================================================================== */
/*
Select * from Siz_Incoming
Select * from Siz_IncomDetalle
Select * from Siz_IncomImagen
Select * from Siz_PielClases
*/

Select SIC.INC_docNum AS ID
	, CAST(SIC.INC_fechaInspeccion as Date) AS FE_REV
	, OCRD.CardName AS PROVEEDOR
	, SIC.INC_codMaterial AS CODIGO
	, SIC.INC_nomMaterial AS MATERIAL
	, SIC.INC_unidadMedida AS UDM
	, SIC.INC_cantRecibida AS RECIBIDO
	, (SIC.INC_cantAceptada + SIC.INC_cantRechazada) AS REVISADA
	, SIC.INC_cantAceptada AS ACEPTADA
	, SIC.INC_cantRechazada AS RECHAZADA
	, SIC.INC_cantAceptada/SIC.INC_cantRecibida AS PORC
	, SIC.INC_nomInspector AS INSPECTOR
	, SIC.INC_numFactura AS FACTURA
	, SIC.INC_notas AS MOT_RECHAZO
	, T1.Descr AS GRUPPLAN
From Siz_Incoming SIC
INNER JOIN OITM on OITM.ItemCode = SIC.INC_codMaterial
Inner Join OCRD on SIC.INC_codProveedor = OCRD.CardCode
LEFT JOIN UFD1 T1 on OITM.U_GrupoPlanea=T1.FldValue and T1.TableID='OITM' and T1.FieldID=9 
WHERE Cast(SIC.INC_fechaInspeccion as date) between  @FechaIS and @FechaFS and SIC.INC_borrado = 'N'
Order By SIC.INC_fechaRecepcion, SIC.INC_nomMaterial

