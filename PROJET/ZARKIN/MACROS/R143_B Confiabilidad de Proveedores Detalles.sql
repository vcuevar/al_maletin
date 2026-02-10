-- Macro 143 Confiabilidad de Proveedores 
-- Subproceso B VMA_R143_B() Hoja 2
-- Objetivo: Segun las inspecciones asignar una calificacion a los proveedores por reporte anual.
-- Solicitado: Sr. Eduardo Belis.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Lunes 11 de agosto del 2025; Origen.
-- Actualizado: Martes 16 de diciembre del 2025; Hacer que cero no sea cero.

/* ==============================================================================================
|     PARAMETROS GENERALES.                                                                     |
============================================================================================== */

Declare @FechaIS as Date
Declare @FechaFS as Date
Declare @xCodArti as VarChar(20)
Declare @xCodProd as VarChar(20)
Declare @nCiclo nVarchar(4) 

Set @FechaIS = CONVERT (DATE, '2025-12-01', 102)
Set @FechaFS = CONVERT (DATE, '2025-12-31', 102)

Set @xCodArti = '18311'
Set @xCodProd = 'P1788' 
Set @nCiclo = '2025'

-- Set @FechaIS = (Select Cast(SCC.FEC_INI as date) From Siz_Calendario_Cierre SCC Where SCC.PERIODO = @nCiclo + '-01')
-- Set @FechaFS = (Select Cast(SCC.FEC_FIN as date) From Siz_Calendario_Cierre SCC Where SCC.PERIODO = @nCiclo + '-12')

--Select SCC.FEC_INI AS FI From Siz_Calendario_Cierre SCC Where SCC.PERIODO = '2025' + '-01'
--Select SCC.FEC_FIN AS FF From Siz_Calendario_Cierre SCC Where SCC.PERIODO = '2025' + '-12'

/* ==============================================================================================
|  Reporte para Calificar a los Proveedores Detalles   R-143-B                                         |
============================================================================================== */


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

	, (Case When (SUM(SIC.INC_cantAceptada) / SUM(SIC.INC_cantRecibida)) = 0 Then
	0.00001 else (SUM(SIC.INC_cantAceptada) / SUM(SIC.INC_cantRecibida)) end) 	AS CALF_1

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
--and SIC.INC_codProveedor = @xCodProd 
and SIC.INC_borrado = 'N'
Group By SIC.INC_docNum, SIC.INC_fechaInspeccion, SIC.INC_codProveedor, OCRD.CardName, 
SIC.INC_codMaterial, SIC.INC_nomMaterial, SIC.INC_unidadMedida, SIC.INC_esPiel, OOND.IndName 
Order By GRUPO, SIC.INC_fechaInspeccion, OCRD.CardName, SIC.INC_nomMaterial


-- EOF R-143-B
