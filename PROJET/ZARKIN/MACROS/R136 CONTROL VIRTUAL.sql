-- Macro Reclasificacion del Gurú.
-- Objetivo: Calcular las materias prima que se consumen, se deben consumir de lo produccido
-- por OP y por LDM, para poder validar lo consumido y sacar la diferencia.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Miercoles 22 de Noviembre del 2023; Origen.
-- Actualizado: Lunes 27 de Noviembre del 2023; Reporte de Produccion Detalle y Resumen


/* ==============================================================================================
|     PARAMETROS GENERALES.                                                                     |
============================================================================================== */

/*
Indice de Tipo de Operaciones en Libro de Almacen (OINM)
13  Facturas clientes
14  Notas de crédito clientes
15  Entregas
16  Devoluciones
18  Fact.proveedores
20  Pedido de entrada de mercancías
21  Devolución de mercancías
59  Entrada de mercancías / Recibo de produccion
60  Emisión para producción / Salidas de Mercancia
67  Traslados -
162  Revalorización de inventario
*/

Declare @FechaIS as Date
Declare @FechaFS as Date
Declare @xCodProd AS VarChar(20)

Set @FechaIS = CONVERT (DATE, '2024-06-03', 102)
Set @FechaFS = CONVERT (DATE, '2024-06-30', 102)

--Set @xCodProd =  '3707-07-P0596'
--Set @xCodProd =  '3936-38-V0340'
--Set @xCodProd =  '393638-ESTRUCTURA'
Set @xCodProd =  '17871' 

/* ==============================================================================================
|  Reporte de Produccion Agrupado por Modelos. Hoja 2 de Excel                                  |
============================================================================================== */
/*
-- Reporte Total de lo Producido
Select SUM(PD.CANT) AS T_VS, SUM(PD.VS) AS T_VS 
From (
Select	'PRODUCCION TOTAL: ' AS TITULO
		, OP.PlannedQty AS CANT
		, OP.PlannedQty * A3.U_VS AS VS  
from OWOR OP 
inner join [@CP_LOGOF] CP on OP.DocEntry= CP.U_DocEntry 
inner join OITM A3 on OP.ItemCode = A3.ItemCode 
Where CP.U_FechaHora BETWEEN @FechaIS and @FechaFS and (CP.U_CT=175) 
) PD 

-- Reporte Agrupado por Modelos.
Select PD.CODE_PT AS CODE_PT, PD.MODELO AS MODELO, SUM(PD.CANT) AS PZA, SUM(PD.VS) AS T_VS 
From (
-- Reporte Produccion Detallado Area 175
Select	CAST(CP.U_FechaHora as DATE) as FECHA
		, OP.DocEntry AS OP
		, OP.ItemCode AS CODE_PT
		, A3.ItemName AS MODELO
		, OP.PlannedQty AS CANT
		, OP.PlannedQty * A3.U_VS AS VS 
from OWOR OP 
inner join [@CP_LOGOF] CP on OP.DocEntry= CP.U_DocEntry 
inner join OITM A3 on OP.ItemCode = A3.ItemCode 
Where Cast(CP.U_FechaHora as DATE) BETWEEN @FechaIS and @FechaFS and (CP.U_CT=175) 
) PD 
Group by PD.CODE_PT, PD.MODELO
Order by MODELO
*/

--  231207 Le he dado tantas vueltas que no he encontrado la forma de hacerlo lo mas generico posible
-- asi que me ire por pasos, al igual que lo hago con Las Estructuras de solo materiales.

/* ==============================================================================================
|  Informacion del Producto Terminado.                                                          |
============================================================================================== */
/*
Select A3.ItemCode AS CODIGO
		, A3.ItemName AS SUBENSAMBLE
		, A3.InvntryUom AS UDM
		, A3.U_VS AS VS
from OITM A3 
where  A3.ItemCode = '3936-38-V0340' 
Order by SUBENSAMBLE
*/
/* ==============================================================================================
|  Obtencion de SubEnsambles de un Codigo. Hoja 3 de Excel.                                                      |
============================================================================================== */
/*
Select OITM.ItemCode AS CODIGO
	, OITM.ItemName AS SUBENSAMBLE
	, OITM.InvntryUom AS UDM
	, ITT1.Quantity AS CAN_BASE 
from ITT1 
inner join OITM on OITM.ItemCode = ITT1.Code 
where  ITT1.Father = '3936-38-V0340' and (OITM.QryGroup29 = 'Y' or OITM.QryGroup30 = 'Y' or OITM.QryGroup31 = 'Y' or OITM.QryGroup32 = 'Y')
Order by SUBENSAMBLE
*/

/* ==============================================================================================
|  Obtencion de Materiales Comprados. Hoja 4 de Excel.                                                          |
============================================================================================== */
/*
Select OITM.ItemCode AS CODIGO
	, OITM.ItemName AS MATERIAL
	, OITM.InvntryUom AS UDM
	, ITT1.Quantity AS CAN_BASE 
	, ITM1.Price AS L_10
from ITT1 
inner join OITM on OITM.ItemCode = ITT1.Code 
inner join ITM1 on ITM1.ItemCode = OITM.ItemCode and ITM1.PriceList=10
where  ITT1.Father = '3936-38-V0340' and OITM.QryGroup29 = 'N' and OITM.QryGroup30 = 'N' and OITM.QryGroup31 = 'N' and OITM.QryGroup32 = 'N'
Order by MATERIAL
*/


/* ==============================================================================================
|     MATERIAL MOVIMIENTO EN WIP.                             Hoja 5 de Excel                    |
============================================================================================== */

Select ALM.CODIGO
	, ALM.MATERIAL
	, ALM.UDM
	, ALM.PRECIO
	, ISNULL(SUM(ALM.TRASLADOS), 0) AS TRASLADO
	, ISNULL(SUM(ALM.PROD_OP), 0) AS PROD_OP
	, ISNULL(SUM(ALM.CON_OP), 0) AS CON_OP
	, ISNULL(SUM(ALM.RECLASIFICA),0) AS RECLASIFICA
	, ISNULL(SUM(ALM.CONSUMO), 0) AS CONSUMO
From (
Select OINM.ItemCode AS CODIGO
	, OITM.ItemName AS MATERIAL
	, OITM.InvntryUom AS UDM
	, ITM1.Price as PRECIO
	, Case When OINM.TransType = 67 then SUM(OINM.InQty - OINM.OutQty) end AS TRASLADOS
	
	, Case When OINM.TransType = 59 and (OINM.CardCode = '_SYS00000000022' or OINM.CardCode = '_SYS00000000023') or OINM.TransType = 60 and (OINM.CardCode = '_SYS00000000022' or OINM.CardCode = '_SYS00000000023') then SUM(OINM.InQty) end AS PROD_OP
	, Case When OINM.TransType = 59 and (OINM.CardCode = '_SYS00000000022' or OINM.CardCode = '_SYS00000000023') or OINM.TransType = 60 and (OINM.CardCode = '_SYS00000000022' or OINM.CardCode = '_SYS00000000023') then SUM(OINM.OutQty*-1) end AS CON_OP

	, Case When OINM.TransType = 59 and OINM.CardCode = '_SYS00000000350' or OINM.TransType = 60 and OINM.CardCode = '_SYS00000000350' then SUM(OINM.InQty - OINM.OutQty) end AS RECLASIFICA
	, Case When OINM.TransType = 59 and OINM.CardCode = '_SYS00000000351' or OINM.TransType = 60 and OINM.CardCode = '_SYS00000000351' then SUM(OINM.InQty - OINM.OutQty) end AS CONSUMO
From OINM  
Inner join OITM on OINM.ItemCode = OITM.ItemCode 
Inner join ITM1 on ITM1.ItemCode = OITM.ItemCode and ITM1.PriceList = 10  
Where Cast (OINM.CreateDate as DATE) between @FechaIS and @FechaFS
and OINM.Warehouse = 'APG-ST' 
and OITM.U_TipoMat <> 'PT'

Group By OINM.ItemCode, OITM.ItemName, OITM.InvntryUom, ITM1.Price, OINM.TransType, OINM.CardCode ) ALM
Group By ALM.CODIGO, ALM.MATERIAL, ALM.UDM, ALM.PRECIO 
Order by ALM.MATERIAL


/*
-- Para Sacar lo entregado de los almacenes de Stock a Producción
-- Se utiliza traslados 67 y ajustes entrada 59 sobre APG-ST.
Select OINM.ItemCode AS CODIGO
	, OITM.ItemName AS MATERIAL
	, OITM.InvntryUom AS UDM
	, ITM1.Price as PRECIO
	, SUM(OINM.InQty) AS ENTRADA
	, SUM(OINM.OutQty) AS SALIDAS
From OINM  
Inner join OITM on OINM.ItemCode = OITM.ItemCode 
Inner join ITM1 on ITM1.ItemCode = OITM.ItemCode and ITM1.PriceList = 10  
Where Cast (OINM.CreateDate as DATE) between @FechaIS and @FechaFS
and OINM.Warehouse = 'APG-ST' 
and OITM.U_TipoMat <> 'PT'
and (OINM.TransType = 67 or OINM.TransType = 59) 
and OINM.CardCode <> '_SYS00000000350'
Group By OINM.ItemCode, OITM.ItemName, OITM.InvntryUom, ITM1.Price
Order by MATERIAL
*/

/* ==============================================================================================
|     CATALOGO COMPLETO DE ARTICULOS MATERIALES COMPRADOS. Hoja 6 de Excel.                                      |
============================================================================================== */
/*
Select EXT_AC.CODIGO
	, EXT_AC.ARTICULO
	, EXT_AC.UDM
	, EXT_AC.PRECIO
	, SUM(EXT_AC.EXI_ACTUAL) AS EXI_ACTUAL
From (

Select OITM.ItemCode AS CODIGO
		, OITM.ItemName AS ARTICULO
		, OITM.InvntryUom AS UDM
		, ITM1.Price AS PRECIO
		, OITW.OnHand AS EXI_ACTUAL		
From OITM
inner join ITM1 on ITM1.ItemCode = OITM.ItemCode and ITM1.PriceList=10
inner join OITW on OITM.ItemCode=OITW.ItemCode and OITW.WhsCode = 'APG-ST'
where OITM.U_TipoMat <> 'PT' and OITM.frozenFor = 'N' 

Union All
Select OW.ItemCode AS CODIGO
	, A1.ItemName AS ARTICULO
	, A1.InvntryUom AS UDM
	, L10.Price AS PRECIO
	, OW.IssuedQty AS EXI_ACTUAL		 
From Vw_BackOrderExcel BO 
Inner join WOR1 OW on BO.OP = OW.DocEntry 
Inner join OITM A1 on OW.ItemCode = A1.ItemCode 
inner join ITM1 L10 on A1.ItemCode= L10.ItemCode and L10.PriceList = 10 
where BO.U_Starus = '06' and A1.ItmsGrpCod <> 113 and OW.IssuedQty > 0 
Union All
Select OW.ItemCode AS CODIGO
	, A1.ItemName AS ARTICULO
	, A1.InvntryUom AS UDM
	, L10.Price AS PRECIO
	, OW.IssuedQty AS EXI_ACTUAL	
From Vw_BackOrderExcel BO 
inner join WOR1 OW on BO.OP = OW.DocEntry 
inner join OITM A1 on OW.ItemCode = A1.ItemCode 
inner join ITM1 L10 on A1.ItemCode= L10.ItemCode and L10.PriceList=10 
where BO.U_Starus = '06' and A1.ItmsGrpCod = 113 
) EXT_AC
Group By EXT_AC.CODIGO, EXT_AC.ARTICULO, EXT_AC.UDM, EXT_AC.PRECIO
Order By EXT_AC.ARTICULO
*/
/* ==============================================================================================
| Materiales Cargados a Ordenes de Produccion, sin Casco, solo PT y RF--> Hoja 07 de Excel.      |
============================================================================================== */

-- Calcula materiales cargados a las OP para PT y RF la fecha de Corte.
/*
Select KDX.CODIGO AS CODIGO
	, OITM.ItemName AS ARTICULO
	, OITM.InvntryUom AS UDM
	, ITM1.Price as PRECIO
	, SUM(KDX.ENTRADA) AS ENTRADA 
	, SUM(KDX.SALIDA) AS SALIDA
	, SUM(KDX.ENTRADA + KDX.SALIDA) AS EX_INI
From (
Select OINM.ItemCode AS CODIGO
	, (OINM.OutQty -OINM.InQty) AS ENTRADA
	, 0 AS SALIDA
	, OINM.AppObjAbs
From OINM 
Inner Join OWOR on OINM.AppObjAbs = OWOR.DocEntry 
Inner Join OITM A3 on OWOR.ItemCode = A3.ItemCode and (A3.U_TipoMat = 'PT' or A3.U_TipoMat = 'RF')
Where Cast (OINM.CreateDate as DATE) < @FechaIS 
and OINM.AppObjAbs <> -1 
Union All	
Select OINM.ItemCode AS CODIGO
	, 0 AS ENTRADA
	, (OINM.InQty - OINM.OutQty) AS SALIDA
	, OINM.AppObjAbs
From OINM  
Inner Join OWOR on OINM.AppObjAbs = OWOR.DocEntry 
Inner Join OITM A3 on OWOR.ItemCode = A3.ItemCode and (A3.U_TipoMat = 'PT' or A3.U_TipoMat = 'RF') 
Where Cast(OWOR.CloseDate as DATE) < @FechaIS 
and OINM.AppObjAbs <> -1 
) KDX
Inner Join OITM on KDX.CODIGO = OITM.ItemCode
Inner Join ITM1 on ITM1.ItemCode = OITM.ItemCode and ITM1.PriceList = 10 
Group By KDX.CODIGO, OITM.ItemName, OITM.InvntryUom, ITM1.Price
Having SUM(KDX.ENTRADA + KDX.SALIDA) <> 0 
Order By ARTICULO
*/

/* ==============================================================================================
| INVENTARIO INICIAL MENOR QUE A LA FECHA DE INICIO. ALMACEN APG-ST --> Hoja 11 de Excel.       |
============================================================================================== */

-- Calcula Existencia del Inventario Inicial a la Menor que a la Fecha de Inicio.
/*
 Select OINM.ItemCode AS CODIGO
		, OITM.ItemName AS ARTICULO
		, OITM.InvntryUom AS UDM
		, ITM1.Price AS PRECIO
		, SUM(OINM.InQty - OINM.OutQty) AS  EX_INI
		, OITM.U_TipoMat AS TIPO
From OINM  
Inner Join OITM on OINM.ItemCode = OITM.ItemCode
inner join ITM1 on OITM.ItemCode= ITM1.ItemCode and ITM1.PriceList= 10 
Where Cast (OINM.CreateDate as DATE) < @FechaIS and OINM.Warehouse = 'APG-ST'  
--Where Cast (OINM.CreateDate as DATE) < '" & FechaIS & "' and OINM.Warehouse = 'APG-ST'  
Group By OINM.ItemCode, OITM.ItemName, OITM.InvntryUom, ITM1.Price, OITM.U_TipoMat
Having SUM(OINM.InQty - OINM.OutQty) <> 0
Order by ARTICULO
*/

/* ==============================================================================================
|     Materiales Cargados a las OP en el Periodo.  Hoja 12 de Excel.                            |
============================================================================================== */
/*
-- Materiales Cargados a las OP.
Select KDX.CODIGO AS CODIGO
	, OITM.ItemName AS ARTICULO
	, OITM.InvntryUom AS UDM
	, ITM1.Price as PRECIO
	, SUM(KDX.ENTRADA) AS ENTRADA 
	, SUM(KDX.SALIDA) AS SALIDA
	, SUM(KDX.ENTRADA + KDX.SALIDA) AS EX_INI
From (
Select OINM.ItemCode AS CODIGO
	, (OINM.OutQty -OINM.InQty) AS ENTRADA
	, 0 AS SALIDA
	, OINM.AppObjAbs
From OINM 
Inner Join OWOR on OINM.AppObjAbs = OWOR.DocEntry 
Inner Join OITM A3 on OWOR.ItemCode = A3.ItemCode and (A3.U_TipoMat = 'PT' or A3.U_TipoMat = 'RF')
Where Cast (OINM.CreateDate as DATE) BETWEEN @FechaIS and @FechaFS
and OINM.AppObjAbs <> -1 

Union All	

Select OINM.ItemCode AS CODIGO
	, 0 AS ENTRADA
	, (OINM.InQty - OINM.OutQty) AS SALIDA
	, OINM.AppObjAbs
From OINM  
Inner Join OWOR on OINM.AppObjAbs = OWOR.DocEntry 
Inner Join OITM A3 on OWOR.ItemCode = A3.ItemCode and (A3.U_TipoMat = 'PT' or A3.U_TipoMat = 'RF') 
Where Cast(OWOR.CloseDate as DATE) BETWEEN @FechaIS and @FechaFS
and OINM.AppObjAbs <> -1 

) KDX
Inner Join OITM on KDX.CODIGO = OITM.ItemCode
Inner Join ITM1 on ITM1.ItemCode = OITM.ItemCode and ITM1.PriceList = 10 
Group By KDX.CODIGO, OITM.ItemName, OITM.InvntryUom, ITM1.Price
Having SUM(KDX.ENTRADA + KDX.SALIDA) <> 0 and KDX.CODIGO = @xCodProd
Order By ARTICULO

*/


/*
-- Consumo de Ordenes de Produccion mediante Libro de almacen Tipo = 60 Recibos de Produccion.
Select OINM.ItemCode AS CODIGO
	, A1.ItemName AS ARTICULO
	, A1.InvntryUom AS UDM
	, ITM1.Price AS PRECIO
	, SUM(OINM.InQty) AS ENTRADA
	, SUM(OINM.OutQty) AS SALIDA
From OINM  
Inner Join OITM A1 on OINM.ItemCode = A1.ItemCode
Inner Join ITM1 on ITM1.ItemCode = A1.ItemCode and ITM1.PriceList = 10 
Where Cast (OINM.CreateDate as DATE) BETWEEN @FechaIS and @FechaFS and OINM.Warehouse = 'APG-ST'  
and OINM.TransType = 60
and OINM.CardCode = '_SYS00000000023' --Producto Terminado
Group By OINM.ItemCode, A1.ItemName, A1.InvntryUom, ITM1.Price 
Order By ARTICULO
*/

/* ==============================================================================================
|     MATERIAL AJUSTADOS POR RECLASIFICACION.  Hoja 13 de Excel.                                |
============================================================================================== */
/*
 Select OINM.ItemCode AS CODIGO
	, OITM.ItemName AS MATERIAL
	, OITM.InvntryUom AS UDM
	, ITM1.Price as PRECIO
	, (OINM.InQty) AS ENTRADA
	, (OINM.OutQty) AS SALIDA
	, OINM.*
From OINM 
Inner join OITM on OINM.ItemCode = OITM.ItemCode 
Inner join ITM1 on ITM1.ItemCode = OITM.ItemCode and ITM1.PriceList = 10  
Where Cast (OINM.CreateDate as DATE) between @FechaIS and @FechaFS
and OINM.Warehouse = 'APG-ST' 
--and OINM.CardCode = '_SYS00000000350'
--and (OINM.TransType = 59 or OINM.TransType = 60)
and OINM.TransType = 59
and OINM.ItemCode = @xCodProd
--Group By OINM.ItemCode, OITM.ItemName, OITM.InvntryUom, ITM1.Price
Order By MATERIAL
*/

/* ==============================================================================================
|     KARDEX DE MATERIALES.   Hoja 14 de Excel.                                                                  |
============================================================================================== */
/*
-- KARDEX detallado, Se maneja con el Libro de Almacen.
 Select Cast(OINM.DocDate as date) AS FECHA
		, Case When Month(OINM.DocDate) = 1 then '01_ENE'
			When Month(OINM.DocDate) = 2 then '02_FEB'
			When Month(OINM.DocDate) = 3 then '03_MAR'
			When Month(OINM.DocDate) = 4 then '04_ABR'
			When Month(OINM.DocDate) = 5 then '05_MAY'
			When Month(OINM.DocDate) = 6 then '06_JUN'
			When Month(OINM.DocDate) = 7 then '07_JUL'
			When Month(OINM.DocDate) = 8 then '08_AGO'
			When Month(OINM.DocDate) = 9 then '09_SEP'
			When Month(OINM.DocDate) = 10 then '10_OCT'
			When Month(OINM.DocDate) = 11 then '11_NOV'
			When Month(OINM.DocDate) = 12 then '12_DIC'
			Else 'NO_DEF' end AS MES
	--, OINM.TransType AS TIPO 
	, Case When OINM.TransType = 59 and OINM.CardCode = '_SYS00000000351' then '1_AJUSTE'
			When OINM.TransType = 59 and OINM.CardCode = '_SYS00000000350' then '1_RECLASI'
			When OINM.TransType = 67 then '2_TRASLADO' 
			When Left(OINM.JrnlMemo, 5) = 'Issue' then '3_KOMSUMO'
			When OINM.TransType = 60 and OINM.CardCode = '_SYS00000000351' then '3_CON_SOP'
			When OINM.TransType = 60 and OINM.CardCode = '_SYS00000000350' then '4_RECLASI'
			When OINM.TransType = 60 and OINM.JrnlMemo Not like '%Salida%' then '3_CONSUMO'
			When OINM.TransType = 60 and OINM.JrnlMemo like '%Salida%' then '4_SALIDA'
			Else 'X0' end AS MOVIMIENTO
	, OINM.ItemCode AS CODIGO
	, OITM.ItemName AS MATERIAL
	, OITM.InvntryUom AS UDM
	, ITM1.Price as PRECIO
	, OINM.InQty AS ENTRADA
	, OINM.OutQty AS SALIDA
	, OINM.Warehouse AS ALMA_BAS
	, OINM.JrnlMemo AS MOVI
	, OINM.BASE_REF AS REFERENCIA
	, ISNULL(OINM.Ref2, OINM.AppObjAbs) AS ALMA_OP
	, OINM.TransType AS TIPO_MOV
	, OINM.CardCode AS CUEN_CONT
	--, Case When OINM.TransType = 60 and OINM.JrnlMemo Not like '%Salida%' then A3.ItemName else '' end AS PT
	--, OINM.* 
From OINM  
Inner join OITM on OINM.ItemCode = OITM.ItemCode 
Inner join ITM1 on ITM1.ItemCode = OITM.ItemCode and ITM1.PriceList = 10  
Left join OWOR on OINM.AppObjAbs = OWOR.DocEntry
Left join OITM A3 on OWOR.ItemCode = A3.ItemCode
Where Cast (OINM.CreateDate as DATE) between @FechaIS and @FechaFS
and OINM.Warehouse = 'APG-ST' 
--and OINM.OutQty > 0
--and OINM.TransType = 67 -- Codigo para Traslados
--and OITM.QryGroup29 = 'N' and OITM.QryGroup30 = 'N' and OITM.QryGroup31 = 'N' and OITM.QryGroup32 = 'N'
and OITM.U_TipoMat <> 'PT'
and OINM.ItemCode = @xCodProd
--Group By Month(OINM.DocDate), OINM.TransType, OINM.JrnlMemo, OINM.ItemCode, OITM.ItemName, OITM.InvntryUom, ITM1.Price
Order by FECHA, MOVIMIENTO
*/

/*
-- KARDEX Resumido, Se maneja con el Libro de Almacen.
 Select -- Cast(OINM.DocDate as date) AS FECHA
	 Case When Month(OINM.DocDate) = 1 then '01_ENE'
			When Month(OINM.DocDate) = 2 then '02_FEB'
			When Month(OINM.DocDate) = 3 then '03_MAR'
			When Month(OINM.DocDate) = 4 then '04_ABR'
			When Month(OINM.DocDate) = 5 then '05_MAY'
			When Month(OINM.DocDate) = 6 then '06_JUN'
			When Month(OINM.DocDate) = 7 then '07_JUL'
			When Month(OINM.DocDate) = 8 then '08_AGO'
			When Month(OINM.DocDate) = 9 then '09_SEP'
			When Month(OINM.DocDate) = 10 then '10_OCT'
			When Month(OINM.DocDate) = 11 then '11_NOV'
			When Month(OINM.DocDate) = 12 then '12_DIC'
			Else 'NO_DEF' end AS MES
	--, OINM.TransType AS TIPO 
	, Case When OINM.TransType = 59 and OINM.CardCode = '_SYS00000000351' then '1_AJUSTE'
			When OINM.TransType = 59 and OINM.CardCode = '_SYS00000000350' then '1_RECLASI' 
			When OINM.TransType = 67 then '2_TRASLADO' 
			When Left(OINM.JrnlMemo, 5) = 'Issue' then '3_KOMSUMO'
			When OINM.TransType = 60 and OINM.CardCode = '_SYS00000000351' then '3_CON_SOP'
			When OINM.TransType = 60 and OINM.CardCode = '_SYS00000000350' then '4_RECLASI'
			When OINM.TransType = 60 and Left(OINM.JrnlMemo, 5) = 'Salid' then '4_SALIDA'
			When OINM.TransType = 60 and Left(OINM.JrnlMemo, 5) <> 'Salid' then '3_CONSUMO'
			Else 'X0' end AS MOVIMIENTO
	--, OINM.JrnlMemo AS MOVI
	, OINM.ItemCode AS CODIGO
	, OITM.ItemName AS MATERIAL
	, OITM.InvntryUom AS UDM
	, ITM1.Price as PRECIO
	, SUM(OINM.InQty) AS ENTRADA
	, SUM(OINM.OutQty) AS SALIDA
	--, ISNULL(OINM.Ref2, OINM.AppObjAbs) AS ALMA_OP
	--, Case When OINM.TransType = 60 and OINM.JrnlMemo Not like '%Salida%' then A3.ItemName else '' end AS PT
From OINM  
Inner join OITM on OINM.ItemCode = OITM.ItemCode 
Inner join ITM1 on ITM1.ItemCode = OITM.ItemCode and ITM1.PriceList = 10  
Left join OWOR on OINM.AppObjAbs = OWOR.DocEntry
--Left join OWOR on OINM.BASE_REF = OWOR.DocNum
Left join OITM A3 on OWOR.ItemCode = A3.ItemCode
Where Cast (OINM.CreateDate as DATE) between @FechaIS and @FechaFS
and OINM.Warehouse = 'APG-ST' 
--and OINM.OutQty > 0
--and OINM.TransType = 67 -- Codigo para Traslados
--and OITM.QryGroup29 = 'N' and OITM.QryGroup30 = 'N' and OITM.QryGroup31 = 'N' and OITM.QryGroup32 = 'N'
and OITM.U_TipoMat <> 'PT'
and OINM.ItemCode = @xCodProd
Group By Month(OINM.DocDate), OINM.TransType, Left(OINM.JrnlMemo,5), OINM.ItemCode, OITM.ItemName, 
OITM.InvntryUom, ITM1.Price, OINM.CardCode
Order by MES, MOVIMIENTO
*/


/* ==============================================================================================
| Materiales Cargados a Ordenes de Produccion, para Casco --> Hoja 15 de Excel.                 |
============================================================================================== */
/*
-- Calcula materiales cargados a las OP para CA la fecha de Corte.
Select KDX.CODIGO AS CODIGO
	, OITM.ItemName AS ARTICULO
	, OITM.InvntryUom AS UDM
	, ITM1.Price as PRECIO
	, (KDX.ENTRADA) AS ENTRADA 
	, (KDX.SALIDA) AS SALIDA
	, (KDX.ENTRADA + KDX.SALIDA) AS EX_INI
	, KDX.AppObjAbs AS OC
From (
Select OINM.ItemCode AS CODIGO
	, (OINM.OutQty -OINM.InQty) AS ENTRADA
	, 0 AS SALIDA
	, OINM.AppObjAbs
From OINM 
--Inner Join WOR1 on OINM.AppObjAbs = WOR1.DocEntry 
Inner Join OWOR on OINM.AppObjAbs = OWOR.DocEntry 
Inner Join OITM A3 on OWOR.ItemCode = A3.ItemCode and A3.U_TipoMat = 'CA' --and (A3.U_TipoMat = 'CA' or A3.U_TipoMat = 'SP') 
Inner Join OITM A1 on OINM.ItemCode = A1.ItemCode and A1.U_TipoMat <> 'CA' --A1.U_TipoMat <> 'CA' and A3.U_TipoMat <> 'SP'
Where Cast (OINM.CreateDate as DATE) < @FechaIS 
--and OINM.AppObjAbs <> -1 
and OINM.AppObjAbs = 42020

Union All	
Select OINM.ItemCode AS CODIGO
	, 0 AS ENTRADA
	, (OINM.InQty - OINM.OutQty) AS SALIDA
	, OINM.AppObjAbs
From OINM  
--Inner Join WOR1 on OINM.AppObjAbs = WOR1.DocEntry 
Inner Join OWOR on OINM.AppObjAbs = OWOR.DocEntry 
Inner Join OITM A3 on OWOR.ItemCode = A3.ItemCode and A3.U_TipoMat = 'CA' --and (A3.U_TipoMat = 'CA' or A3.U_TipoMat = 'SP')
Inner Join OITM A1 on OINM.ItemCode = A1.ItemCode and A1.U_TipoMat <> 'CA' --and A1.U_TipoMat <> 'CA' and A3.U_TipoMat <> 'SP'
Where Cast(OWOR.CloseDate as DATE) < @FechaIS 
--and OINM.AppObjAbs <> -1 
and OINM.AppObjAbs = 42020
) KDX
Inner Join OITM on KDX.CODIGO = OITM.ItemCode
Inner Join ITM1 on ITM1.ItemCode = OITM.ItemCode and ITM1.PriceList = 10 
--Group By KDX.CODIGO, OITM.ItemName, OITM.InvntryUom, ITM1.Price, KDX.AppObjAbs 
--Having SUM(KDX.ENTRADA + KDX.SALIDA) <> 0 and KDX.AppObjAbs = 42020
Order By ARTICULO


--Select * from WOR1 Where DocEntry = 42020

Select Cast(OINM.CreateDate as Date) AS FECHA
	, OINM.ItemCode AS CODIGO
	, OINM.Dscription AS MATERIAL
	, OINM.Price AS PRECIO
	, OINM.Currency AS MONEDA
	, OINM.InQty AS ENTRADA
	, OINM.OutQty AS SALIDA
	, OINM.Warehouse AS ALMACEN
	, OINM.*
From OINM  
--Inner Join OWOR on OINM.AppObjAbs = OWOR.DocEntry 
--Inner Join OITM A3 on OWOR.ItemCode = A3.ItemCode and A3.U_TipoMat = 'CA' --and (A3.U_TipoMat = 'CA' or A3.U_TipoMat = 'SP')
Inner Join OITM A1 on OINM.ItemCode = A1.ItemCode and A1.U_TipoMat <> 'CA' --and A1.U_TipoMat <> 'CA' and A3.U_TipoMat <> 'SP'
Where OINM.AppObjAbs = 42020 --Cast(OWOR.CloseDate as DATE) < @FechaIS 
and OINM.ItemCode = '10057'

*/



/*
-- Calcula materiales cargados a las OP para CA la fecha de Corte.
Select SUM((KDX.ENTRADA + KDX.SALIDA)*ITM1.Price) AS IMPORTE
From (
Select OINM.ItemCode AS CODIGO
	, (OINM.OutQty -OINM.InQty) AS ENTRADA
	, 0 AS SALIDA
	, OINM.AppObjAbs
From OINM 
Inner Join OWOR on OINM.AppObjAbs = OWOR.DocEntry 
Inner Join OITM A3 on OWOR.ItemCode = A3.ItemCode and A3.U_TipoMat = 'CA' 
Inner Join OITM A1 on OINM.ItemCode = A1.ItemCode and A1.U_TipoMat = 'CA'
Where Cast (OINM.CreateDate as DATE) < @FechaIS 
and OINM.AppObjAbs <> -1 
Union All	
Select OINM.ItemCode AS CODIGO
	, 0 AS ENTRADA
	, (OINM.InQty - OINM.OutQty) AS SALIDA
	, OINM.AppObjAbs
From OINM  
Inner Join OWOR on OINM.AppObjAbs = OWOR.DocEntry 
Inner Join OITM A3 on OWOR.ItemCode = A3.ItemCode and A3.U_TipoMat = 'CA' 
Inner Join OITM A1 on OINM.ItemCode = A1.ItemCode and A1.U_TipoMat = 'CA'
Where Cast(OWOR.CloseDate as DATE) < @FechaIS 
and OINM.AppObjAbs <> -1 
) KDX
Inner Join OITM on KDX.CODIGO = OITM.ItemCode
Inner Join ITM1 on ITM1.ItemCode = OITM.ItemCode and ITM1.PriceList = 10 
--Group By KDX.CODIGO, OITM.ItemName, OITM.InvntryUom, ITM1.Price
--Having SUM(KDX.ENTRADA + KDX.SALIDA) <> 0 
--Order By ARTICULO
*/


/*
-- CONEJILLO DE INDIAS...
 Select Cast(OINM.CreateDate as Date) AS FECHA
	, OINM.ItemCode AS CODIGO
	, OINM.Dscription AS MATERIAL
	, OINM.Price AS PRECIO
	, OINM.Currency AS MONEDA
	, OINM.InQty AS ENTRADA
	, OINM.OutQty AS SALIDA
	, OINM.Warehouse AS ALMACEN
	
	, OINM.AppObjAbs AS OP
	, OINM.TransType AS MOVIMIENTO
	, OINM.Ref1 AS REF_1
	, OINM.Ref2 AS REF_2
	, OINM.Comments AS COMENTARIO
	, OINM.JrnlMemo AS NOTAS
From OINM  
--Inner join OITM on OINM.ItemCode = OITM.ItemCode 
--Inner join ITM1 on ITM1.ItemCode = OITM.ItemCode and ITM1.PriceList = 10  
--Inner Join WOR1 on OINM.AppObjAbs = WOR1.DocEntry -- and OINM.ItemCode = WOR1.ItemCode and WOR1.IssueType = 'M'
--Inner Join OWOR on OINM.AppObjAbs = OWOR.DocEntry --and (OWOR.Status <> 'C' or OWOR.Status <> 'L')
--Where Cast(OWOR.CloseDate as DATE) < @FechaIS and (OINM.Warehouse = 'AMP-ST' or OINM.Warehouse =  'AMP-CC')
Where 

 OINM.AppObjAbs = 42020
 --Cast (OINM.CreateDate as DATE) < @FechaIS --and (OINM.Warehouse = 'AMP-ST' or OINM.Warehouse =  'AMP-CC')
and OINM.ItemCode = '10057'
-- and OINM.TransType = 67

--and OINM.Warehouse = 'APG-ST'
Order by Cast(OINM.CreateDate as Date), MATERIAL

*/







