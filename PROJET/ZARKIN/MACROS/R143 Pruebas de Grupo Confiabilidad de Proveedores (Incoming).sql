
/* ==============================================================================================
|     PARAMETROS GENERALES.                                                                     |
============================================================================================== */

Declare @FechaI as Date
Declare @FechaF as Date

Declare @xCodProd as VarChar(20)
Declare @nCiclo nVarchar(4) 

--Set @FechaI = CONVERT (DATE, '2025-08-28', 102)
--Set @FechaF = CONVERT (DATE, '2025-09-28', 102)

Set @xCodProd =  'P2221' 
Set @nCiclo = '2025'

Set @FechaI = (Select Cast(SCC.FEC_INI as date) From Siz_Calendario_Cierre SCC Where SCC.PERIODO = @nCiclo + '-01')
Set @FechaF = (Select Cast(SCC.FEC_FIN as date) From Siz_Calendario_Cierre SCC Where SCC.PERIODO = @nCiclo + '-12')

--Select SCC.FEC_INI AS FI From Siz_Calendario_Cierre SCC Where SCC.PERIODO = '2025' + '-01'
--Select SCC.FEC_FIN AS FF From Siz_Calendario_Cierre SCC Where SCC.PERIODO = '2025' + '-12'

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
Where Cast(SIC.INC_fechaInspeccion as date) between  @FechaI and @FechaF 
and SIC.INC_borrado = 'N' and SIC.INC_codProveedor = @xCodProd
Group By SIC.INC_codProveedor, OCRD.CardName, OOND.IndDesc,
SIC.INC_docNum, SIC.INC_fechaInspeccion, SIC.INC_esPiel, OOND.IndName, SCC.MES
) RCP
Group By RCP.NUM_MES
























/*
Select DIAR.COD_PROV
	, 'NE' AS NE
	, 'SEMANA' AS SEMANA
	, DIAR.NUM_MES
	, 'CODE' AS COD_MAT
	, 'MATER' AS MATERIAL
	, 'UDM' AS UDM
	, SUM(DIAR.RECIBIDO) AS RECIBIDO
	, SUM(DIAR.REVISADA) AS REVISA
	, SUM(DIAR.ACEPTADA) AS ACEPTADA
	, SUM(DIAR.RECHAZADA) AS RECHAZADA
	, AVG(DIAR.CALF_1) AS CALIFICA

	, ISNULL((
	(SUM(SPC.PLC_claseA)/SUM(SIC.INC_cantRecibida))/.3 +
	(SUM(SPC.PLC_claseB)/SUM(SIC.INC_cantRecibida))/.5 +
	(1-((SUM(SPC.PLC_claseC)/SUM(SIC.INC_cantRecibida))-.2)) +
	(Case When SUM(SPC.PLC_claseD) = 0 Then 1 else
	((SUM(SPC.PLC_claseD)/SUM(SIC.INC_cantRecibida))*-1) end))/4
	, 0) AS CALF_2





From (
Select SIC.INC_codProveedor AS COD_PROV
	, SIC.INC_docNum AS NE
	, DATEPART(ISO_WEEK, SIC.INC_fechaInspeccion) AS SEMANA
	, SCC.MES AS NUM_MES
	, SIC.INC_codMaterial AS COD_MAT
	, OITM.ItemName AS MATERIAL
	, OITM.InvntryUom AS UDM
	, SUM(SIC.INC_cantRecibida) AS RECIBIDO
	, SUM((SIC.INC_cantAceptada + SIC.INC_cantRechazada)) AS REVISADA
	, SUM(SIC.INC_cantAceptada) AS ACEPTADA
	, SUM(SIC.INC_cantRechazada) AS RECHAZADA
	, (SUM(SIC.INC_cantAceptada) / SUM(SIC.INC_cantRecibida)) AS CALF_1
From Siz_Incoming SIC
Inner Join OCRD on SIC.INC_codProveedor = OCRD.CardCode
Inner Join  Siz_Calendario_Cierre SCC on CAST(SIC.INC_fechaInspeccion as Date) between Cast(SCC.FEC_INI as date) and Cast(SCC.FEC_FIN as date)
Left Join OOND on OCRD.IndustryC = OOND.IndCode
Inner Join OITM on OITM.ItemCode = SIC.INC_codMaterial
Left Join UFD1 T1 on OITM.U_GrupoPlanea=T1.FldValue and T1.TableID='OITM' and T1.FieldID=9 
Left Join Siz_PielClases SPC on SIC.INC_id = SPC.PLC_incId 
Where Cast(SIC.INC_fechaInspeccion as date) between  @FechaI and @FechaF
and SIC.INC_codProveedor = @xCodProd and SIC.INC_borrado = 'N'
Group By SIC.INC_docNum, SIC.INC_codProveedor, SIC.INC_codMaterial
, OOND.IndName, SIC.INC_fechaInspeccion, SIC.INC_nomMaterial, OITM.InvntryUom
, OITM.ItemName, SCC.MES
) DIAR
Group By DIAR.COD_PROV, DIAR.NUM_MES
Order By DIAR.NUM_MES 
*/