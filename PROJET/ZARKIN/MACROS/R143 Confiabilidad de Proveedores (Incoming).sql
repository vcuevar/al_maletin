-- Macro 143 Confiabilidad de Proveedores (Incoming)
-- Objetivo: Segun las inspecciones asignar una calificacion a los proveedores por reporte anual.
-- Solicitado: Sr. Eduardo Belis.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Lunes 11 de agosto del 2025; Origen.
-- Actualizado: 

/* ==============================================================================================
|     PARAMETROS GENERALES.                                                                     |
============================================================================================== */

Declare @FechaIS as Date
Declare @FechaFS as Date
Declare @xCodProd AS VarChar(20)

Set @FechaIS = CONVERT (DATE, '2025-08-08', 102)
Set @FechaFS = CONVERT (DATE, '2025-08-12', 102)
Set @xCodProd =  '10867' 

/* ==============================================================================================
|  Reporte para Calificar a los Proveedores Agrupado por Mes Anualizado  R-143-A                |
============================================================================================== */

Select RCP.GRUPO AS GRUPO 
	, RCP.COD_PROV AS COD_PRO		
	, RCP.PROVEEDOR AS PROVEEDOR
	, SUM(RCP.ENTRADA) AS ENTRADAS
	, Case When RCP.NUM_MES = 1 then AVG(RCP.CALF_U) else 0 end AS ENE
	, Case When RCP.NUM_MES = 2 then AVG(RCP.CALF_U) else 0 end AS FEB
	, Case When RCP.NUM_MES = 3 then AVG(RCP.CALF_U) else 0 end AS MAR
	, Case When RCP.NUM_MES = 4 then AVG(RCP.CALF_U) else 0 end AS ABR
	, Case When RCP.NUM_MES = 5 then AVG(RCP.CALF_U) else 0 end AS MAY
	, Case When RCP.NUM_MES = 6 then AVG(RCP.CALF_U) else 0 end AS JUN
	, Case When RCP.NUM_MES = 7 then AVG(RCP.CALF_U) else 0 end AS JUL
	, Case When RCP.NUM_MES = 8 then AVG(RCP.CALF_U) else 0 end AS AGO
	, Case When RCP.NUM_MES = 9 then AVG(RCP.CALF_U) else 0 end AS SEP
	, Case When RCP.NUM_MES = 10 then AVG(RCP.CALF_U) else 0 end AS OCT
	, Case When RCP.NUM_MES = 11 then AVG(RCP.CALF_U) else 0 end AS NOV
	, Case When RCP.NUM_MES = 12 then AVG(RCP.CALF_U) else 0 end AS DIC
From (
Select MONTH(CAST(SIC.INC_fechaInspeccion as Date)) AS NUM_MES
	, ISNULL(OOND.IndName, 'SIN GRUPO') AS GRUPO
	, SIC.INC_codProveedor AS COD_PROV
	, SIC.INC_nomProveedor AS PROVEEDOR
	, Case When SIC.INC_esPiel = 'N' then
	  (SUM(SIC.INC_cantAceptada) / SUM(SIC.INC_cantRecibida)) else
	  (ISNULL((SUM(SPC.PLC_claseA)/SUM(SIC.INC_cantRecibida))/.3 +
	(SUM(SPC.PLC_claseB)/SUM(SIC.INC_cantRecibida))/.5 +
	(1-((SUM(SPC.PLC_claseC)/SUM(SIC.INC_cantRecibida))-.2)) +
	(Case When SUM(SPC.PLC_claseD) = 0 Then 1 else
	((SUM(SPC.PLC_claseD)/SUM(SIC.INC_cantRecibida))*-1) end), 0)/4
	) end AS CALF_U
	, 1 AS ENTRADA
From Siz_Incoming SIC
Inner Join OCRD on SIC.INC_codProveedor = OCRD.CardCode
Left Join OOND on OCRD.IndustryC = OOND.IndCode
Left Join Siz_PielClases SPC on SIC.INC_id = SPC.PLC_incId 
Where Cast(SIC.INC_fechaInspeccion as date) between  @FechaIS and @FechaFS 
Group By SIC.INC_codProveedor, SIC.INC_nomProveedor, 
SIC.INC_docNum, SIC.INC_fechaInspeccion, SIC.INC_esPiel, OOND.IndName
) RCP
Group By  RCP.GRUPO, RCP.COD_PROV, RCP.PROVEEDOR, RCP.NUM_MES
Order By GRUPO, PROVEEDOR

-- EOF R-143-A

/* ==============================================================================================
|  Reporte para Calificar a los Proveedores Detalles   R-143-B                                         |
============================================================================================== */
/*
Select SIC.INC_docNum AS NE
	, DATEPART(ISO_WEEK, SIC.INC_fechaInspeccion) AS SEMANA
	, MONTH(CAST(SIC.INC_fechaInspeccion as Date)) AS NUM_MES
	, SIC.INC_codProveedor AS COD_PROV
	, SIC.INC_nomProveedor AS PROVEEDOR
	, SIC.INC_codMaterial AS COD_MAT
	, SIC.INC_nomMaterial AS MATERIAL
	, SIC.INC_unidadMedida AS UDM
	, SUM(SIC.INC_cantRecibida) AS RECIBIDO
	, SUM((SIC.INC_cantAceptada + SIC.INC_cantRechazada)) AS REVISADA
	, SUM(SIC.INC_cantAceptada) AS ACEPTADA
	, SUM(SIC.INC_cantRechazada) AS RECHAZADA
	, ISNULL(SUM(SPC.PLC_claseA), 0) AS CLAS_A
	, ISNULL(SUM(SPC.PLC_claseB), 0) AS CLAS_B
	, ISNULL(SUM(SPC.PLC_claseC), 0) AS CLAS_C
	, ISNULL(SUM(SPC.PLC_claseD), 0) AS CLAS_D
	, SIC.INC_esPiel AS ES_PIEL
	, ISNULL(OOND.IndName, 'SIN GRUPO') AS GRUPO
	, (SUM(SIC.INC_cantAceptada) / SUM(SIC.INC_cantRecibida)) AS CALF_1
	, ISNULL((
	(SUM(SPC.PLC_claseA)/SUM(SIC.INC_cantRecibida))/.3 +
	(SUM(SPC.PLC_claseB)/SUM(SIC.INC_cantRecibida))/.5 +
	(1-((SUM(SPC.PLC_claseC)/SUM(SIC.INC_cantRecibida))-.2)) +
	(Case When SUM(SPC.PLC_claseD) = 0 Then 1 else
	((SUM(SPC.PLC_claseD)/SUM(SIC.INC_cantRecibida))*-1) end))/4
	, 0) AS CALF_2
From Siz_Incoming SIC
Inner Join OCRD on SIC.INC_codProveedor = OCRD.CardCode
Left Join OOND on OCRD.IndustryC = OOND.IndCode
Inner Join OITM on OITM.ItemCode = SIC.INC_codMaterial
Left Join UFD1 T1 on OITM.U_GrupoPlanea=T1.FldValue and T1.TableID='OITM' and T1.FieldID=9 
Left Join Siz_PielClases SPC on SIC.INC_id = SPC.PLC_incId 
Where Cast(SIC.INC_fechaInspeccion as date) between  @FechaIS and @FechaFS 
Group By SIC.INC_docNum, SIC.INC_fechaInspeccion, SIC.INC_codProveedor, SIC.INC_nomProveedor, 
SIC.INC_codMaterial, SIC.INC_nomMaterial, SIC.INC_unidadMedida, SIC.INC_esPiel, OOND.IndName 
Order By GRUPO, SIC.INC_fechaInspeccion, SIC.INC_nomProveedor,SIC.INC_nomMaterial
*/
-- EOF R-143-B

/* ==============================================================================================
|  Reporte para Calificar a los Proveedores Agrupado por Proveedor  R-143-C                      |
============================================================================================== */
/*
Select RCP.GRUPO AS GRUPO 
	,RCP.ES_PIEL AS PIELSN
	, RCP.SEMANA AS NUM_SEM
	, RCP.PROVEEDOR AS PROVEEDOR
	, AVG(RCP.CALF_1) AS CALF_1
	, AVG(RCP.CALF_2) AS CALF_2
From (
Select SIC.INC_docNum AS NE
	, DATEPART(ISO_WEEK, SIC.INC_fechaInspeccion) AS SEMANA
	, MONTH(CAST(SIC.INC_fechaInspeccion as Date)) AS NUM_MES
	, SIC.INC_codProveedor AS COD_PROV
	, SIC.INC_nomProveedor AS PROVEEDOR
	, SIC.INC_codMaterial AS COD_MAT
	, SIC.INC_nomMaterial AS MATERIAL
	, SIC.INC_unidadMedida AS UDM
	, SUM(SIC.INC_cantRecibida) AS RECIBIDO
	, SUM((SIC.INC_cantAceptada + SIC.INC_cantRechazada)) AS REVISADA
	, SUM(SIC.INC_cantAceptada) AS ACEPTADA
	, SUM(SIC.INC_cantRechazada) AS RECHAZADA
	, ISNULL(SUM(SPC.PLC_claseA), 0) AS CLAS_A
	, ISNULL(SUM(SPC.PLC_claseB), 0) AS CLAS_B
	, ISNULL(SUM(SPC.PLC_claseC), 0) AS CLAS_C
	, ISNULL(SUM(SPC.PLC_claseD), 0) AS CLAS_D
	, SIC.INC_esPiel AS ES_PIEL
	, ISNULL(OOND.IndName, 'SIN GRUPO') AS GRUPO
	, (SUM(SIC.INC_cantAceptada) / SUM(SIC.INC_cantRecibida)) AS CALF_1
	, ISNULL((
	(SUM(SPC.PLC_claseA)/SUM(SIC.INC_cantRecibida))/.3 +
	(SUM(SPC.PLC_claseB)/SUM(SIC.INC_cantRecibida))/.5 +
	(1-((SUM(SPC.PLC_claseC)/SUM(SIC.INC_cantRecibida))-.2)) +
	(Case When SUM(SPC.PLC_claseD) = 0 Then 1 else
	((SUM(SPC.PLC_claseD)/SUM(SIC.INC_cantRecibida))*-1) end))/4
	, 0) AS CALF_2
From Siz_Incoming SIC
Inner Join OCRD on SIC.INC_codProveedor = OCRD.CardCode
Left Join OOND on OCRD.IndustryC = OOND.IndCode
Inner Join OITM on OITM.ItemCode = SIC.INC_codMaterial
Left Join UFD1 T1 on OITM.U_GrupoPlanea=T1.FldValue and T1.TableID='OITM' and T1.FieldID=9 
Left Join Siz_PielClases SPC on SIC.INC_id = SPC.PLC_incId 
Where Cast(SIC.INC_fechaInspeccion as date) between  @FechaIS and @FechaFS 
Group By SIC.INC_docNum, SIC.INC_fechaInspeccion, SIC.INC_codProveedor, SIC.INC_nomProveedor, 
SIC.INC_codMaterial, SIC.INC_nomMaterial, SIC.INC_unidadMedida, SIC.INC_esPiel, OOND.IndName 
) RCP
Group By  RCP.GRUPO, RCP.ES_PIEL, RCP.SEMANA, RCP.PROVEEDOR
Order By NUM_SEM, GRUPO, PROVEEDOR
*/
-- EOF R-143-C

/* ==============================================================================================
|     REPORTE DE PROVEEDORES SIN GURPO PARA REPORTE DE CONFIABILIDAD DE PROVEEDORES.            |
============================================================================================== */

/*
Select OCRD.CardCode AS CODIGO
	, OCRD.CardName AS PROVEEDOR
	, ISNULL(OCRD.IndustryC, '0') AS COD_GRUP
	, ISNULL(OOND.IndName, '') AS GRUPO
from OCRD
Left Join OOND on OCRD.IndustryC = OOND.IndCode
Where frozenFor = 'N' and ISNULL(OCRD.IndustryC, '0') = '0'
Order By OCRD.CardName
*/

-- EOF REPORTE PROVEEDORES SIN GRUPO

/**************************************************************************************************************
* Varias Cosas que use borrar al termiar
*/


/*
Select * from Siz_Incoming SIC
Where SIC.INC_id = 16

Update Siz_Incoming Set INC_cantAceptada = 43094 Where INC_id = 15

Select * from Siz_IncomDetalle
Select * from Siz_IncomImagen
Select * from Siz_PielClases

*/

/*
Select SIC.INC_docNum AS NE
	, SIC.INC_codMaterial AS COD_MAT
	, SIC.INC_esPiel AS ES_PIEL
	, MONTH(CAST(SIC.INC_fechaInspeccion as Date)) AS FE_REV
	, 1 AS ENTRADAS
	, SIC.INC_codProveedor AS COD_PROV
	, SIC.INC_nomProveedor AS PROVEEDOR
	, ISNULL(OOND.IndName, 'SIN GRUPO') AS GRUPO

	, (SUM(SIC.INC_cantAceptada) / SUM(SIC.INC_cantRecibida)) AS CALF_1
	, ISNULL((
	(SUM(SPC.PLC_claseA)/SUM(SIC.INC_cantRecibida))/.3 +
	(SUM(SPC.PLC_claseB)/SUM(SIC.INC_cantRecibida))/.5 +
	(1-((SUM(SPC.PLC_claseC)/SUM(SIC.INC_cantRecibida))-.2)) +
	(Case When SUM(SPC.PLC_claseD) = 0 Then 1 else
	((SUM(SPC.PLC_claseD)/SUM(SIC.INC_cantRecibida))*-1) end))/4
	, 0) AS CALF_2
From Siz_Incoming SIC
Inner Join OCRD on SIC.INC_codProveedor = OCRD.CardCode
Left Join OOND on OCRD.IndustryC = OOND.IndCode
Left Join Siz_PielClases SPC on SIC.INC_id = SPC.PLC_incId 
Where Cast(SIC.INC_fechaInspeccion as date) between  @FechaIS and @FechaFS 
Group By SIC.INC_fechaInspeccion, SIC.INC_docNum, SIC.INC_esPiel, SIC.INC_codMaterial, OOND.IndName, SIC.INC_codProveedor, SIC.INC_nomProveedor 
Order By GRUPO, PROVEEDOR


-- Select * from Siz_IncomDetalle SID
-- Where SID.IND_incId = 34

-- Select * from Siz_PielClases SPC
-- Where SPC.PLC_incId = 15


Select * from Siz_Incoming
Select * from Siz_IncomDetalle
Select * from Siz_IncomImagen
Select * from Siz_PielClases
*/


-- Select * from Siz_IncomDetalle SID
-- Where SID.IND_incId = 34

-- Select * from Siz_PielClases SPC
-- Where SPC.PLC_incId = 15

-- EOF BASURA PARA BORRAR.......................................................................................
