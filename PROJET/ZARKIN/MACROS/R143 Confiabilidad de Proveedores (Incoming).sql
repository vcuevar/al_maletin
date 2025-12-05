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
Declare @xCodArti as VarChar(20)
Declare @xCodProd as VarChar(20)
Declare @nCiclo nVarchar(4) 

-- Set @FechaIS = CONVERT (DATE, '2025-09-01', 102)
-- Set @FechaFS = CONVERT (DATE, '2025-09-22', 102)
Set @xCodArti = '18311'
Set @xCodProd = 'P2221' 
Set @nCiclo = '2025'

Set @FechaIS = (Select Cast(SCC.FEC_INI as date) From Siz_Calendario_Cierre SCC Where SCC.PERIODO = @nCiclo + '-01')
Set @FechaFS = (Select Cast(SCC.FEC_FIN as date) From Siz_Calendario_Cierre SCC Where SCC.PERIODO = @nCiclo + '-12')

--Select SCC.FEC_INI AS FI From Siz_Calendario_Cierre SCC Where SCC.PERIODO = '2025' + '-01'
--Select SCC.FEC_FIN AS FF From Siz_Calendario_Cierre SCC Where SCC.PERIODO = '2025' + '-12'


/* ==============================================================================================
|  Reporte para Calificar a los Proveedores Agrupado por Mes Anualizado  R-143-A                |
============================================================================================== */

-- Promedio Anual
/*
Select AVG(CPT.CALF_U) AS CAL_ANUAL
From (
Select SIC.INC_codProveedor AS COD_PROV
	, SIC.INC_nomProveedor AS PROVEEDOR
	, Case When SIC.INC_esPiel = 'N' then
	  (SUM(SIC.INC_cantAceptada) / SUM(SIC.INC_cantRecibida)) else
	  (ISNULL((SUM(SPC.PLC_claseA)/SUM(SIC.INC_cantRecibida))/.3 +
	(SUM(SPC.PLC_claseB)/SUM(SIC.INC_cantRecibida))/.5 +
	(1-((SUM(SPC.PLC_claseC)/SUM(SIC.INC_cantRecibida))-.2)) +
	(Case When SUM(SPC.PLC_claseD) = 0 Then 1 else
	((SUM(SPC.PLC_claseD)/SUM(SIC.INC_cantRecibida))*-1) end), 0)/4
	) end AS CALF_U
From Siz_Incoming SIC
Inner Join OCRD on SIC.INC_codProveedor = OCRD.CardCode
Inner Join  Siz_Calendario_Cierre SCC on CAST(SIC.INC_fechaInspeccion as Date) between Cast(SCC.FEC_INI as date) and Cast(SCC.FEC_FIN as date)
Left Join OOND on OCRD.IndustryC = OOND.IndCode
Left Join Siz_PielClases SPC on SIC.INC_id = SPC.PLC_incId 
Where Cast(SIC.INC_fechaInspeccion as date) between  @FechaI and @FechaF and SIC.INC_borrado = 'N'
Group By SIC.INC_esPiel, SIC.INC_codProveedor, SIC.INC_nomProveedor ) CPT

*/

--  Llena la Calificacion por Mes General.
/*
Select SUM(RCP2.ENTRADAS) AS ENTRADAS
	, ISNULL(AVG(RCP2.ENE), 0) AS ENERO
	, ISNULL(AVG(RCP2.FEB), 0) AS FEBRERO
	, ISNULL(AVG(RCP2.MAR), 0) AS MARZO
	, ISNULL(AVG(RCP2.ABR), 0) AS ABRIL
	, ISNULL(AVG(RCP2.MAY), 0) AS MAYO
	, ISNULL(AVG(RCP2.JUN), 0) AS JUNIO
	, ISNULL(AVG(RCP2.JUL), 0) AS JULIO
	, ISNULL(AVG(RCP2.AGO), 0) AS AGOSTO
	, ISNULL(AVG(RCP2.SEP), 0) AS SEPTIEMBRE
	, ISNULL(AVG(RCP2.OCT), 0) AS OCTUBRE
	, ISNULL(AVG(RCP2.NOV), 0) AS NOVIEMBRE
	, ISNULL(AVG(RCP2.DIC), 0) AS DICIEMBRE
From (
Select RCP.IDG AS IDG 
	, RCP.GRUPO AS GRUPO 
	, RCP.COD_PROV AS COD_PRO		
	, RCP.PROVEEDOR AS PROVEEDOR
	, SUM(RCP.ENTRADA) AS ENTRADAS
	, Case When RCP.NUM_MES = '01' then AVG(RCP.CALF_U) else null end AS ENE
	, Case When RCP.NUM_MES = '02' then AVG(RCP.CALF_U) else null end AS FEB
	, Case When RCP.NUM_MES = '03' then AVG(RCP.CALF_U) else null end AS MAR
	, Case When RCP.NUM_MES = '04' then AVG(RCP.CALF_U) else null end AS ABR
	, Case When RCP.NUM_MES = '05' then AVG(RCP.CALF_U) else null end AS MAY
	, Case When RCP.NUM_MES = '06' then AVG(RCP.CALF_U) else null end AS JUN
	, Case When RCP.NUM_MES = '07' then AVG(RCP.CALF_U) else null end AS JUL
	, Case When RCP.NUM_MES = '08' then AVG(RCP.CALF_U) else null end AS AGO
	, Case When RCP.NUM_MES = '09' then AVG(RCP.CALF_U) else null end AS SEP
	, Case When RCP.NUM_MES = '10' then AVG(RCP.CALF_U) else null end AS OCT
	, Case When RCP.NUM_MES = '11' then AVG(RCP.CALF_U) else null end AS NOV
	, Case When RCP.NUM_MES = '12' then AVG(RCP.CALF_U) else null end AS DIC
From (
Select SCC.MES AS NUM_MES
	, ISNULL(OOND.IndDesc, '7') AS IDG
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
Inner Join  Siz_Calendario_Cierre SCC on CAST(SIC.INC_fechaInspeccion as Date) between Cast(SCC.FEC_INI as date) and Cast(SCC.FEC_FIN as date)
Left Join OOND on OCRD.IndustryC = OOND.IndCode
Left Join Siz_PielClases SPC on SIC.INC_id = SPC.PLC_incId 
Where Cast(SIC.INC_fechaInspeccion as date) between  @FechaI and @FechaF and SIC.INC_borrado = 'N'
Group By SIC.INC_codProveedor, SIC.INC_nomProveedor, OOND.IndDesc,
SIC.INC_docNum, SIC.INC_fechaInspeccion, SIC.INC_esPiel, OOND.IndName, SCC.MES
) RCP
Group By RCP.IDG, RCP.GRUPO, RCP.COD_PROV, RCP.PROVEEDOR, RCP.NUM_MES
) RCP2
*/


/* ============================================================================
|  Llena la Calificacion por Mes y por Grupo de Familia. R-143-A              | 
|  Primera Seccion.                                                           |
=============================================================================*/

/*
Select  RCP2.IDG 
	, RCP2.GRUPO 
	, SUM(RCP2.ENTRADAS) AS ENTRADAS
	, ISNULL(AVG(RCP2.ENE), 0) AS ENERO
	, ISNULL(AVG(RCP2.FEB), 0) AS FEBRERO
	, ISNULL(AVG(RCP2.MAR), 0) AS MARZO
	, ISNULL(AVG(RCP2.ABR), 0) AS ABRIL
	, ISNULL(AVG(RCP2.MAY), 0) AS MAYO
	, ISNULL(AVG(RCP2.JUN), 0) AS JUNIO
	, ISNULL(AVG(RCP2.JUL), 0) AS JULIO
	, ISNULL(AVG(RCP2.AGO), 0) AS AGOSTO
	, ISNULL(AVG(RCP2.SEP), 0) AS SEPTIEMBRE
	, ISNULL(AVG(RCP2.OCT), 0) AS OCTUBRE
	, ISNULL(AVG(RCP2.NOV), 0) AS NOVIEMBRE
	, ISNULL(AVG(RCP2.DIC), 0) AS DICIEMBRE
From (
Select RCP.IDG AS IDG 
	, RCP.GRUPO AS GRUPO 
	, RCP.COD_PROV AS COD_PRO		
	, RCP.PROVEEDOR AS PROVEEDOR
	, SUM(RCP.ENTRADA) AS ENTRADAS
	, Case When RCP.NUM_MES = '01' then AVG(RCP.CALF_U) else null end AS ENE
	, Case When RCP.NUM_MES = '02' then AVG(RCP.CALF_U) else null end AS FEB
	, Case When RCP.NUM_MES = '03' then AVG(RCP.CALF_U) else null end AS MAR
	, Case When RCP.NUM_MES = '04' then AVG(RCP.CALF_U) else null end AS ABR
	, Case When RCP.NUM_MES = '05' then AVG(RCP.CALF_U) else null end AS MAY
	, Case When RCP.NUM_MES = '06' then AVG(RCP.CALF_U) else null end AS JUN
	, Case When RCP.NUM_MES = '07' then AVG(RCP.CALF_U) else null end AS JUL
	, Case When RCP.NUM_MES = '08' then AVG(RCP.CALF_U) else null end AS AGO
	, Case When RCP.NUM_MES = '09' then AVG(RCP.CALF_U) else null end AS SEP
	, Case When RCP.NUM_MES = '10' then AVG(RCP.CALF_U) else null end AS OCT
	, Case When RCP.NUM_MES = '11' then AVG(RCP.CALF_U) else null end AS NOV
	, Case When RCP.NUM_MES = '12' then AVG(RCP.CALF_U) else null end AS DIC
From (
Select SCC.MES AS NUM_MES
	, ISNULL(OOND.IndDesc, '7') AS IDG
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
	, sic.INC_docNum AS ENTRADA
From Siz_Incoming SIC
Inner Join OCRD on SIC.INC_codProveedor = OCRD.CardCode
Inner Join  Siz_Calendario_Cierre SCC on CAST(SIC.INC_fechaInspeccion as Date) between Cast(SCC.FEC_INI as date) and Cast(SCC.FEC_FIN as date)
Left Join OOND on OCRD.IndustryC = OOND.IndCode
Left Join Siz_PielClases SPC on SIC.INC_id = SPC.PLC_incId 
Where Cast(SIC.INC_fechaInspeccion as date) between  @FechaI and @FechaF AND SCC.MES = '10' and SIC.INC_borrado = 'N'
Group By SIC.INC_codProveedor, SIC.INC_nomProveedor, OOND.IndDesc,
SIC.INC_docNum, SIC.INC_fechaInspeccion, SIC.INC_esPiel, OOND.IndName, SCC.MES, sic.INC_docNum
) RCP
Group By RCP.IDG, RCP.GRUPO, RCP.COD_PROV, RCP.PROVEEDOR, RCP.NUM_MES
) RCP2
Group By RCP2.IDG, RCP2.GRUPO
Order By RCP2.IDG 
*/


/* ============================================================================
|  Llena la Calificacion por Mes por Proveedor. R-143-A                       |
|  Segunda Seccion.                                                           |
=============================================================================*/
/*
Select SUM(RCP2.ENTRADAS) AS ENTRADAS
	, RCP2.IDG 
	, RCP2.GRUPO 
	, RCP2.COD_PRO
	, RCP2.PROVEEDOR
	, ISNULL(AVG(RCP2.ENE), 0) AS ENERO
	, ISNULL(AVG(RCP2.FEB), 0) AS FEBRERO
	, ISNULL(AVG(RCP2.MAR), 0) AS MARZO
	, ISNULL(AVG(RCP2.ABR), 0) AS ABRIL
	, ISNULL(AVG(RCP2.MAY), 0) AS MAYO
	, ISNULL(AVG(RCP2.JUN), 0) AS JUNIO
	, ISNULL(AVG(RCP2.JUL), 0) AS JULIO
	, ISNULL(AVG(RCP2.AGO), 0) AS AGOSTO
	, ISNULL(AVG(RCP2.SEP), 0) AS SEPTIEMBRE
	, ISNULL(AVG(RCP2.OCT), 0) AS OCTUBRE
	, ISNULL(AVG(RCP2.NOV), 0) AS NOVIEMBRE
	, ISNULL(AVG(RCP2.DIC), 0) AS DICIEMBRE
From (
Select RCP.IDG AS IDG 
	, RCP.GRUPO AS GRUPO 
	, RCP.COD_PROV AS COD_PRO		
	, RCP.PROVEEDOR AS PROVEEDOR
	, SUM(RCP.ENTRADA) AS ENTRADAS
	, Case When RCP.NUM_MES = '01' then AVG(RCP.CALF_U) else null end AS ENE
	, Case When RCP.NUM_MES = '02' then AVG(RCP.CALF_U) else null end AS FEB
	, Case When RCP.NUM_MES = '03' then AVG(RCP.CALF_U) else null end AS MAR
	, Case When RCP.NUM_MES = '04' then AVG(RCP.CALF_U) else null end AS ABR
	, Case When RCP.NUM_MES = '05' then AVG(RCP.CALF_U) else null end AS MAY
	, Case When RCP.NUM_MES = '06' then AVG(RCP.CALF_U) else null end AS JUN
	, Case When RCP.NUM_MES = '07' then AVG(RCP.CALF_U) else null end AS JUL
	, Case When RCP.NUM_MES = '08' then AVG(RCP.CALF_U) else null end AS AGO
	, Case When RCP.NUM_MES = '09' then AVG(RCP.CALF_U) else null end AS SEP
	, Case When RCP.NUM_MES = '10' then AVG(RCP.CALF_U) else null end AS OCT
	, Case When RCP.NUM_MES = '11' then AVG(RCP.CALF_U) else null end AS NOV
	, Case When RCP.NUM_MES = '12' then AVG(RCP.CALF_U) else null end AS DIC
From (
Select SCC.MES AS NUM_MES
	, ISNULL(OOND.IndDesc, '7') AS IDG
	, ISNULL(OOND.IndName, 'SIN GRUPO') AS GRUPO
	, SIC.INC_codProveedor AS COD_PROV
	, OCRD.CardName AS PROVEEDOR
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
Inner Join  Siz_Calendario_Cierre SCC on CAST(SIC.INC_fechaInspeccion as Date) between Cast(SCC.FEC_INI as date) and Cast(SCC.FEC_FIN as date)
Left Join OOND on OCRD.IndustryC = OOND.IndCode
Left Join Siz_PielClases SPC on SIC.INC_id = SPC.PLC_incId 
Where Cast(SIC.INC_fechaInspeccion as date) between  @FechaI and @FechaF and SIC.INC_borrado = 'N'
Group By SIC.INC_codProveedor, OCRD.CardName, OOND.IndDesc,
SIC.INC_docNum, SIC.INC_fechaInspeccion, SIC.INC_esPiel, OOND.IndName, SCC.MES
) RCP
Group By RCP.IDG, RCP.GRUPO, RCP.COD_PROV, RCP.PROVEEDOR, RCP.NUM_MES
) RCP2
Group By RCP2.IDG, RCP2.GRUPO, RCP2.COD_PRO, RCP2.PROVEEDOR
Order By RCP2.IDG, RCP2.PROVEEDOR
*/

-- EOF R-143-A

/* ==============================================================================================
|  Reporte para Calificar a los Proveedores Detalles   R-143-B                                         |
============================================================================================== */

/*
Select SIC.INC_docNum AS NE
	, DATEPART(ISO_WEEK, SIC.INC_fechaInspeccion) AS SEMANA
	, MONTH(CAST(SIC.INC_fechaInspeccion as Date)) AS NUM_MES
	, SIC.INC_codProveedor AS COD_PROV
	, OCRD.CardName AS PROVEEDOR
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
and SIC.INC_codProveedor = @xCodProd and SIC.INC_borrado = 'N'
Group By SIC.INC_docNum, SIC.INC_fechaInspeccion, SIC.INC_codProveedor, OCRD.CardName, 
SIC.INC_codMaterial, SIC.INC_nomMaterial, SIC.INC_unidadMedida, SIC.INC_esPiel, OOND.IndName 
Order By GRUPO, SIC.INC_fechaInspeccion, OCRD.CardName, SIC.INC_nomMaterial
*/

-- EOF R-143-B

/* ============================================================================
|  Reporte para Calificar a los Proveedores Agrupado por semanal  R-143-C     |
============================================================================ */

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
	, OCRD.CardName AS PROVEEDOR
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
Where Cast(SIC.INC_fechaInspeccion as date) between  @FechaIS and @FechaFS and SIC.INC_borrado = 'N'
Group By SIC.INC_docNum, SIC.INC_fechaInspeccion, SIC.INC_codProveedor, OCRD.CardName, 
SIC.INC_codMaterial, SIC.INC_nomMaterial, SIC.INC_unidadMedida, SIC.INC_esPiel, OOND.IndName 
) RCP
Group By  RCP.GRUPO, RCP.ES_PIEL, RCP.SEMANA, RCP.PROVEEDOR
Order By NUM_SEM, GRUPO, PROVEEDOR
*/
-- EOF R-143-C


/* ==============================================================================================
|  Reporte Anual por proveedor   R-143-D                                                        |
============================================================================================== */

/*
-- Detalles de las inspecciones.

Select ISNULL(SIR.IR_id, 0) AS RECHAZO
	, OCRD.CardName AS PROVEEDOR
	, SIC.INC_docNum AS NE
	, SIC.INC_codMaterial AS COD_MAT
	, SIC.INC_nomMaterial AS MATERIAL
	, SIC.INC_unidadMedida AS UDM
	, SUM(SIC.INC_cantRecibida) AS RECIBIDO
	, SUM(SIC.INC_cantRechazada) AS RECHAZADA
From Siz_Incoming SIC
Inner Join OCRD on SIC.INC_codProveedor = OCRD.CardCode
Inner Join OITM on OITM.ItemCode = SIC.INC_codMaterial
Left Join Siz_IncomRechazos SIR on SIR.IR_INC_incomld = SIC.INC_id
Where Cast(SIC.INC_fechaInspeccion as date) between  @FechaIS and @FechaFS
and SIC.INC_codProveedor = @xCodProd and SIC.INC_borrado = 'N'
Group By SIC.INC_docNum, OCRD.CardName,
SIC.INC_codMaterial, SIC.INC_nomMaterial, SIC.INC_unidadMedida, SIR.IR_id
Order By SIC.INC_docNum, SIC.INC_nomMaterial
*/


-- Resumen por mes
/*
Select  RCP.NUM_MES AS MES
	, AVG(RCP.CALF_U) AS CALIFA
From (
Select SCC.MES AS NUM_MES
	, Case When SIC.INC_esPiel = 'N' then
	  (SUM(SIC.INC_cantAceptada) / SUM(SIC.INC_cantRecibida)) else
	  (ISNULL((SUM(SPC.PLC_claseA)/SUM(SIC.INC_cantRecibida))/.3 +
	(SUM(SPC.PLC_claseB)/SUM(SIC.INC_cantRecibida))/.5 +
	(1-((SUM(SPC.PLC_claseC)/SUM(SIC.INC_cantRecibida))-.2)) +
	(Case When SUM(SPC.PLC_claseD) = 0 Then 1 else
	((SUM(SPC.PLC_claseD)/SUM(SIC.INC_cantRecibida))*-1) end), 0)/4
	) end AS CALF_U
From Siz_Incoming SIC
Inner Join OCRD on SIC.INC_codProveedor = OCRD.CardCode
Inner Join  Siz_Calendario_Cierre SCC on CAST(SIC.INC_fechaInspeccion as Date) between Cast(SCC.FEC_INI as date) and Cast(SCC.FEC_FIN as date)
Left Join OOND on OCRD.IndustryC = OOND.IndCode
Left Join Siz_PielClases SPC on SIC.INC_id = SPC.PLC_incId 
Where Cast(SIC.INC_fechaInspeccion as date) between  @FechaIS and @FechaFS 
and SIC.INC_borrado = 'N' and SIC.INC_codProveedor = @xCodProd
Group By SIC.INC_codProveedor, OCRD.CardName, OOND.IndDesc,
SIC.INC_docNum, SIC.INC_fechaInspeccion, SIC.INC_esPiel, OOND.IndName, SCC.MES
) RCP
Group By RCP.NUM_MES
Order By MES

-- EOF R-143-D
*/

/* =============================================================================
|  Reporte Anual por material y proveedor   R-143-E                            |
============================================================================= */


Select  RCP.COD_MAT AS COD_MATE
	, RCP.MATERIAL AS MATERIAL
	, RCP.UDM AS UDM
	, RCP.COD_PROV AS COD_PROV
	, RCP.PROVEEDOR AS PROVEEDOR
	, SUM(RCP.ACEPTADO) AS ACEPTADO
	, AVG(RCP.CALF_U) AS CALIFA
From (
Select SCC.MES AS NUM_MES
	, SIC.INC_codMaterial AS COD_MAT
	, SIC.INC_nomMaterial AS MATERIAL
	, OITM.InvntryUom AS UDM
	, SIC.INC_codProveedor AS COD_PROV
	, OCRD.CardName AS PROVEEDOR
	, SUM(SIC.INC_cantAceptada) AS ACEPTADO
	, Case When SIC.INC_esPiel = 'N' then
	  (SUM(SIC.INC_cantAceptada) / SUM(SIC.INC_cantRecibida)) else
	  (ISNULL((SUM(SPC.PLC_claseA)/SUM(SIC.INC_cantRecibida))/.3 +
	(SUM(SPC.PLC_claseB)/SUM(SIC.INC_cantRecibida))/.5 +
	(1-((SUM(SPC.PLC_claseC)/SUM(SIC.INC_cantRecibida))-.2)) +
	(Case When SUM(SPC.PLC_claseD) = 0 Then 1 else
	((SUM(SPC.PLC_claseD)/SUM(SIC.INC_cantRecibida))*-1) end), 0)/4
	) end AS CALF_U
From Siz_Incoming SIC
Inner Join OCRD on SIC.INC_codProveedor = OCRD.CardCode
Inner Join  Siz_Calendario_Cierre SCC on CAST(SIC.INC_fechaInspeccion as Date) between Cast(SCC.FEC_INI as date) and Cast(SCC.FEC_FIN as date)
Inner Join OITM on OITM.ItemCode = SIC.INC_codMaterial
Left Join OOND on OCRD.IndustryC = OOND.IndCode
Left Join Siz_PielClases SPC on SIC.INC_id = SPC.PLC_incId 
Where Cast(SIC.INC_fechaInspeccion as date) between  @FechaIS and @FechaFS 
and SIC.INC_borrado = 'N' 
and SIC.INC_codMaterial = @xCodArti
Group By SIC.INC_codProveedor, OCRD.CardName, OOND.IndDesc, SIC.INC_codMaterial,
SIC.INC_docNum, SIC.INC_fechaInspeccion, SIC.INC_esPiel, OOND.IndName, SCC.MES, 
SIC.INC_nomMaterial, OITM.InvntryUom
) RCP
Group By RCP.COD_PROV,  RCP.PROVEEDOR, RCP.COD_MAT,  RCP.MATERIAL, RCP.UDM
Order By RCP.PROVEEDOR


-- EOF R-143-E


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

/*=============================================================================
|  HERRAMIENTAS PARA MODIFICAR TABLAS.                                        |
=============================================================================*/
/*

Select * from Siz_Incoming SIC
Where SIC.INC_docNum = 19483


Update Siz_Incoming Set INC_cantAceptada = 0, INC_cantRechazada = 3000, INC_notas = 'R-009.25 (BOTON SOLICITADO PATA LARGA)' Where INC_id = 1748
Update Siz_Incoming Set INC_cantAceptada = 1, INC_cantRechazada = 1  Where INC_id = 1801
Update Siz_Incoming Set INC_cantAceptada = 354, INC_cantRechazada = 46  Where INC_id = 1921
Update Siz_Incoming Set INC_cantAceptada = 98, INC_cantRechazada = 2  Where INC_id =1922
Update Siz_Incoming Set INC_cantAceptada = 385, INC_cantRechazada = 35  Where INC_id =720


Update Siz_Incoming Set INC_borrado = 'S', INC_quienBorro = '246-VICENTE CUEVA (SIZ)' Where INC_id = 378
Update Siz_Incoming Set INC_borrado = 'S', INC_quienBorro = '246-VICENTE CUEVA (SIZ)' Where INC_id = 3452




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
