-- R146 Consumo HE en el mes.
-- ID: 250915-271
-- Objetivo: Calcular el consumo de HE segun Diseño contra lo real.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Martes 30 de septiembre dek 2025; Origen.

/* ==============================================================================================
|     PARAMETROS GENERALES.                                                                     |
============================================================================================== */

Declare @FechaI as Date
Declare @FechaF as Date
Declare @Estacion nVarchar(3)
Declare @nCiclo nVarchar(7) 
Declare @Articulo nVarchar(5)

Set @Estacion = '221'
Set @nCiclo = '2025-09'
Set @Articulo = '20649'

--Set @FechaIS = CONVERT (DATE, '2025-09-22', 102)
--Set @FechaFS = CONVERT (DATE, '2025-09-28', 102)

-- Define las fechas del Mes,
Set @FechaI = (Select Cast(SCC.FEC_INI as date) From Siz_Calendario_Cierre SCC Where SCC.PERIODO = @nCiclo )
Set @FechaF = (Select Cast(SCC.FEC_FIN as date) From Siz_Calendario_Cierre SCC Where SCC.PERIODO = @nCiclo )


/* ============================================================================
|  Produccion reportada por rango de fecha.                                    |
=============================================================================*/
/*
Select CAST(CP.U_FechaHora as DATE) AS FEC_PROD
	, OP.DocEntry AS OP
	, OP.ItemCode AS CODIGO
	, A1.ItemName AS DESCRIPCION
	, CP.U_Cantidad AS CANTIDAD
	, A1.U_VS AS VS
	, (A1.U_VS * CP.U_Cantidad) AS TVS
	, A1.IWeight1 AS PESO
	, (A1.IWeight1* CP.U_Cantidad) AS TPESO
From OWOR OP 
inner join [@CP_LOGOF] CP on OP.DocEntry= CP.U_DocEntry 
inner join OITM A1 on OP.ItemCode = A1.ItemCode 
Where Cast(CP.U_FechaHora as date) BETWEEN @FechaI and @FechaF and CP.U_CT = @Estacion 
Order by CAST(CP.U_FechaHora as date), A1.ItemName  
*/


/* ============================================================================
|  Consumo de HE por Ordenes de Produccion.                                   |
=============================================================================*/
/*
  Select Cast(OINM.CreateDate as date) AS FEC_CON
		, OINM.AppObjAbs AS OP
		, OWOR.ItemCode AS CODE
		, A3.ItemName AS PRODUCTO
		, A1.ItemCode AS CODIGO
		, A1.ItemName AS DESCRIPCION
		, A1.InvntryUom AS UDM  
		, OINM.OutQty AS CONSUMO
		, OINM.Warehouse AS ALM_ORG
From OINM
Inner Join OITM A1 on OINM.ItemCode = A1.ItemCode 
Left Join OWOR on OINM.AppObjAbs = OWOR.DocEntry 
Left Join OITM A3 on OWOR.ItemCode = A3.ItemCode
Where Cast (OINM.CreateDate as DATE) between  @FechaI and @FechaF 
and OINM.TransType = 60 and OINM.AppObjAbs > -1 and A1.U_GrupoPlanea = '6'
and (OINM.Warehouse = 'AMP-ST' or OINM.Warehouse = 'AMP-CC')
order by FEC_CON, OINM.AppObjAbs 
 */

/* ============================================================================
|  Consumo de HE fuera de las Ordenes de Produccion.                          |
=============================================================================*/

 Select Cast(OINM.CreateDate as date) AS FEC_CON
		, OINM.BASE_REF AS DOC
		, OINM.JrnlMemo AS MOVIMIENTO
		, A1.ItemCode AS CODIGO
		, A1.ItemName AS DESCRIPCION
		, A1.InvntryUom AS UDM  
		, OINM.InQty AS ENTRADA
		, OINM.OutQty AS CONSUMO
		, OINM.Warehouse AS ALM_ORG
From OINM
Inner Join OITM A1 on OINM.ItemCode = A1.ItemCode 
Left Join OWOR on OINM.AppObjAbs = OWOR.DocEntry 
Left Join OITM A3 on OWOR.ItemCode = A3.ItemCode
Where Cast (OINM.CreateDate as DATE) between  @FechaI and @FechaF 
and (OINM.TransType = 59 or OINM.TransType = 60) and OINM.AppObjAbs = -1 and A1.U_GrupoPlanea = '6'
and A1.QryGroup32 = 'N'
and OINM.Warehouse <> 'APG-ST'
Order By ALM_ORG, FEC_CON 
  



