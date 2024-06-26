-- Macro Reclasificacion del Gur�.
-- Objetivo: Calcular las materias prima que se consumen, se deben consumir de lo produccido
-- por OP y por LDM, para poder validar lo consumido y sacar la diferencia.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Miercoles 22 de Noviembre del 2023; Origen.
-- Actualizado: Lunes 27 de Noviembre del 2023; Reporte de Produccion Detalle y Resumen


/* ==============================================================================================
|     PARAMETROS GENERALES.                                                                     |
============================================================================================== */

Declare @FechaIS as Date
Declare @FechaFS as Date
Declare @xCodProd AS VarChar(20)

Set @FechaIS = CONVERT (DATE, '2023-12-04', 102)
Set @FechaFS = CONVERT (DATE, '2023-12-31', 102)

--Set @xCodProd =  '3707-07-P0596'
--Set @xCodProd =  '3936-38-V0340'
--Set @xCodProd =  '393638-ESTRUCTURA'

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
|     MATERIAL ENTREGADO A WIP POR PARTE DEL ALMACEN. Hoja 5 de Excel                           |
============================================================================================== */

--Para Sacar lo entregado de los almacenes de Stock a Producci�n
-- Se cambia para usar Libro de Almacen. OINM
/*
 Select OINM.ItemCode AS CODIGO
	, OITM.ItemName AS MATERIAL
	, OITM.InvntryUom AS UDM
	, ITM1.Price as PRECIO
	, SUM(OINM.OutQty) as CANTIDAD
From OINM  
Inner join OITM on OINM.ItemCode = OITM.ItemCode 
Inner join ITM1 on ITM1.ItemCode = OITM.ItemCode and ITM1.PriceList = 10  
Where Cast (OINM.CreateDate as DATE) between @FechaIS and @FechaFS
and OINM.Warehouse = 'AMP-ST' 
and OINM.Ref2 = 'APG-ST'
and OINM.OutQty > 0
and OINM.TransType = 67 -- Codigo para Traslados
and OITM.U_TipoMat <> 'PT'
Group By OINM.ItemCode, OITM.ItemName, OITM.InvntryUom, ITM1.Price
Order by MATERIAL
*/

/* ==============================================================================================
|     CATALOGO COMPLETO DE ARTICULOS MATERIALES COMPRADOS. Hoja 6 de Excel.                                      |
============================================================================================== */
/*
Select OITM.ItemCode AS CODIGO
		, OITM.ItemName AS ARTICULO
		, OITM.InvntryUom AS UDM
		, ITM1.Price as PRECIO
From OITM
inner join ITM1 on ITM1.ItemCode = OITM.ItemCode and ITM1.PriceList=10
where OITM.U_TipoMat <> 'GF' and OITM.U_TipoMat <> 'PT' and OITM.frozenFor = 'N' 
Order By ARTICULO
*/

/* ==============================================================================================
|     MATERIAL DEVUELTO POR PRODUCCION A ALMACEN O ENVIA A OTROS ALMACENES.  Hoja 07 de Excel.  |
============================================================================================== */
/*
-- Se maneja con el Libro de Almacen.
 Select OINM.ItemCode AS CODIGO
	, OITM.ItemName AS MATERIAL
	, OITM.InvntryUom AS UDM
	, ITM1.Price as PRECIO
	, SUM(OINM.OutQty) as CANTIDAD
From OINM  
Inner join OITM on OINM.ItemCode = OITM.ItemCode 
Inner join ITM1 on ITM1.ItemCode = OITM.ItemCode and ITM1.PriceList = 10  
Where Cast (OINM.CreateDate as DATE) between @FechaIS and @FechaFS
and OINM.Warehouse = 'APG-ST' 
and OINM.OutQty > 0
and OINM.TransType = 67 -- Codigo para Traslados
and OITM.QryGroup29 = 'N' and OITM.QryGroup30 = 'N' and OITM.QryGroup31 = 'N' and OITM.QryGroup32 = 'N'
and OITM.U_TipoMat <> 'PT'
Group By OINM.ItemCode, OITM.ItemName, OITM.InvntryUom, ITM1.Price
Order by MATERIAL

*/

/* ==============================================================================================
|     CALCULA LA EXISTENCIA INICIAL  Hoja 11 de Excel.                                      |
============================================================================================== */
/*
Select OITM.ItemCode AS CODIGO
	, OITM.ItemName AS ARTICULO
	, OITM.InvntryUom AS UDM
	, ISNULL(INIC.SalInic, 0) AS EX_INI
	, ITM1.Price AS PRECIO
	, OITM.U_TipoMat AS TIPO
from OITM 
inner join ITM1 on OITM.ItemCode= ITM1.ItemCode and ITM1.PriceList= 10 
left join (Select INICIO.ItemCode, (SUM(INICIO.InQty)-SUM(INICIO.OutQty)) as SalInic 
From (Select OINM.ItemCode, OINM.InQty, OINM.OutQty from OINM 
where OINM.CreateDate < @FechaIS and OINM.Warehouse = 'APG-ST' ) INICIO 
Group by INICIO.ItemCode) INIC on INIC.ItemCode = OITM.ItemCode 
Where  ISNULL(INIC.SalInic, 0) <> 0
Order by ARTICULO  
*/
/* ==============================================================================================
|     MATERIAL CARGADO DIRECTAMENTE DEL ALMACEN A LA OP.  Hoja 12 de Excel.                                      |
============================================================================================== */
/*
-- Se maneja con el Libro de Almacen.
 Select OINM.ItemCode AS CODIGO
	, OITM.ItemName AS MATERIAL
	, OITM.InvntryUom AS UDM
	, ITM1.Price as PRECIO
	, SUM((OINM.InQty-OINM.OutQty) * -1) as CANTIDAD
From OINM  
Inner join OITM on OINM.ItemCode = OITM.ItemCode 
Inner join ITM1 on ITM1.ItemCode = OITM.ItemCode and ITM1.PriceList = 10  
Where Cast (OINM.CreateDate as DATE) between @FechaIS and @FechaFS
and OINM.Warehouse = 'AMP-ST' 
and OINM.TransType = 60 -- Emisiones de Produccion
and OITM.QryGroup29 = 'N' and OITM.QryGroup30 = 'N' and OITM.QryGroup31 = 'N' and OITM.QryGroup32 = 'N'
and OITM.U_TipoMat <> 'PT'
Group By OINM.ItemCode, OITM.ItemName, OITM.InvntryUom, ITM1.Price
Order by MATERIAL
*/

/* ==============================================================================================
|     MATERIAL AJUSTADOS POR RECLASIFICACION.  Hoja 13 de Excel.                                |
============================================================================================== */

 Select OINM.ItemCode AS CODIGO
	, OITM.ItemName AS MATERIAL
	, OITM.InvntryUom AS UDM
	, ITM1.Price as PRECIO
	, SUM(OINM.InQty) AS ENTRADA
	, SUM(OINM.OutQty) AS SALIDA
From OINM 
Inner join OITM on OINM.ItemCode = OITM.ItemCode 
Inner join ITM1 on ITM1.ItemCode = OITM.ItemCode and ITM1.PriceList = 10  
Where Cast (OINM.CreateDate as DATE) between @FechaIS and @FechaFS
and OINM.Warehouse = 'APG-ST' and OINM.CardCode = '_SYS00000000350'
and (OINM.TransType = 59 or OINM.TransType = 60)
Group By OINM.ItemCode, OITM.ItemName, OITM.InvntryUom, ITM1.Price
Order By MATERIAL






/* ==============================================================================================
|     KARDEX DE MATERIALES.   Hoja 14 de Excel.                                                                  |
============================================================================================== */

/*
Set @xCodProd =  '10059' 

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
	
	, OINM.JrnlMemo AS MOVI
	, OINM.BASE_REF AS REFERENCIA
	, ISNULL(OINM.Ref2, OINM.AppObjAbs) AS ALMA_OP
	, Case When OINM.TransType = 60 and OINM.JrnlMemo Not like '%Salida%' then A3.ItemName else '' end AS PT
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
|  Calcular los Materiales Comprados para un producto.                                          |
============================================================================================== */
/*
-- Primer parte MP a Nivel 1

Select	'NIVEL 1' AS TITULO
		, L1.Code AS CODE_MP
		, A1.ItemName AS MATERIAL
		, L1.Quantity AS CANT_MP
from OITM A3 
Inner Join ITT1 L1 on L1.Father = A3.ItemCode
Inner Join OITM A1 on L1.Code = A1.ItemCode
Where (A1.QryGroup29 = 'N' and A1.QryGroup30 = 'N' and A1.QryGroup31 = 'N' and A1.QryGroup32 = 'N')
and L1.Father = '3936-38-V0340'

-- Segunda Parte Materiales del Primer Sub-Ensamble

Select	L2.Code AS CODE_MP
		, L2.Quantity AS CANT_MP
from OITM A5 
Inner Join ITT1 L2 on L2.Father = A5.ItemCode
Inner Join OITM A4 on L2.Code = A4.ItemCode
Where (A4.QryGroup29 = 'Y' or A4.QryGroup30 = 'Y' or A4.QryGroup31 = 'Y' or A4.QryGroup32 = 'Y')
and L2.Father = '3936-38-V0340'

Select 'SEGUNDA PARTE' AS TITULO
	, L2.Code AS CODE_MP
	, A7.ItemName AS MATERIAL
	, SUM(L2.Quantity * NIV.CANT_MP) AS CANT_MP
From ITT1 L2
Inner Join OITM A7 on L2.Code = A7.ItemCode
Inner Join (
	Select	L1.Code AS CODE_MP
			, A1.ItemName AS MATERIAL
			, SUM(L1.Quantity * OP.PlannedQty) AS CANT_MP
	from OWOR OP 
	Inner join [@CP_LOGOF] CP on OP.DocEntry= CP.U_DocEntry 
	Inner join OITM A3 on OP.ItemCode = A3.ItemCode 
	Inner Join ITT1 L1 on L1.Father = A3.ItemCode
	Inner Join OITM A1 on L1.Code = A1.ItemCode
	Where Cast(CP.U_FechaHora as DATE) BETWEEN @FechaIS and @FechaFS and (CP.U_CT=175) 
	and (A1.QryGroup29 = 'Y' or A1.QryGroup30 = 'Y' or A1.QryGroup31 = 'Y' or A1.QryGroup32 = 'Y')
	Group by L1.Code, A1.ItemName, A1.U_TipoMat ) NIV on L2.Father = NIV.CODE_MP
Where (A7.QryGroup29 = 'N' and A7.QryGroup30 = 'N' and A7.QryGroup31 = 'N' and A7.QryGroup32 = 'N')
Group by L2.Code, A7.ItemName

Order By MATERIAL
-- (MP) and (A1.QryGroup29 = 'N' and A1.QryGroup30 = 'N' and A1.QryGroup31 = 'N' and A1.QryGroup32 = 'N')
-- (sub) and (A1.QryGroup29 = 'Y' or A1.QryGroup30 = 'Y' or A1.QryGroup31 = 'Y' or A1.QryGroup32 = 'Y')

-- Tercer Parte Parte Materiales del Segundo Sub-Ensamble
Select 'TERCER PARTE' AS TITULO
	, L3.Code AS CODE_MP
	, A8.ItemName AS MATERIAL
	, SUM(L3.Quantity * NIV2.CANT_MP) AS CANT_MP
From ITT1 L3
Inner Join OITM A8 on A8.ItemCode = L3.Code
Inner Join (
	Select L2.Code AS CODE_MP
		, A7.ItemName AS MATERIAL
		, SUM(L2.Quantity * NIV.CANT_MP) AS CANT_MP
	From ITT1 L2
	Inner Join OITM A7 on L2.Code = A7.ItemCode
	Inner Join (
		Select	L1.Code AS CODE_MP
			, A1.ItemName AS MATERIAL
			, SUM(L1.Quantity * OP.PlannedQty) AS CANT_MP
		from OWOR OP 
		Inner join [@CP_LOGOF] CP on OP.DocEntry= CP.U_DocEntry 
		Inner join OITM A3 on OP.ItemCode = A3.ItemCode 
		Inner Join ITT1 L1 on L1.Father = A3.ItemCode
		Inner Join OITM A1 on L1.Code = A1.ItemCode
		Where Cast(CP.U_FechaHora as DATE) BETWEEN @FechaIS and @FechaFS and (CP.U_CT=175) 
		and (A1.QryGroup29 = 'Y' or A1.QryGroup30 = 'Y' or A1.QryGroup31 = 'Y' or A1.QryGroup32 = 'Y')
		Group by L1.Code, A1.ItemName, A1.U_TipoMat ) NIV on L2.Father = NIV.CODE_MP
	Where (A7.QryGroup29 = 'N' and A7.QryGroup30 = 'N' and A7.QryGroup31 = 'N' and A7.QryGroup32 = 'N')
	Group by L2.Code, A7.ItemName ) NIV2 on L3.Father = NIV2.CODE_MP
Group by L3.Code, A8.ItemName
Order By MATERIAL

-- Cuarta Parte Materiales del Tercer Sub-Ensamble

Select 'CUARTA PARTE' AS TITULO
	, L4.Code AS CODE_MP
	, A9.ItemName AS MATERIAL
From ITT1 L4
Inner Join OITM A9 on L4.Code = A9.ItemCode
Inner Join (
	Select L3.Code AS CODE_MP
		, A8.ItemName AS MATERIAL
		, SUM(L3.Quantity * NIV2.CANT_MP) AS CANT_MP
	From ITT1 L3
	Inner Join OITM A8 on A8.ItemCode = L3.Code
	Inner Join (
		Select L2.Code AS CODE_MP
			, A7.ItemName AS MATERIAL
			, SUM(L2.Quantity * NIV.CANT_MP) AS CANT_MP
		From ITT1 L2
		Inner Join OITM A7 on L2.Code = A7.ItemCode
		Inner Join (
			Select	L1.Code AS CODE_MP
				, A1.ItemName AS MATERIAL
				, SUM(L1.Quantity * OP.PlannedQty) AS CANT_MP
			from OWOR OP 
			Inner join [@CP_LOGOF] CP on OP.DocEntry= CP.U_DocEntry 
			Inner join OITM A3 on OP.ItemCode = A3.ItemCode 
			Inner Join ITT1 L1 on L1.Father = A3.ItemCode
			Inner Join OITM A1 on L1.Code = A1.ItemCode
			Where Cast(CP.U_FechaHora as DATE) BETWEEN @FechaIS and @FechaFS and (CP.U_CT=175) 
			and (A1.QryGroup29 = 'Y' or A1.QryGroup30 = 'Y' or A1.QryGroup31 = 'Y' or A1.QryGroup32 = 'Y')
			Group by L1.Code, A1.ItemName, A1.U_TipoMat ) NIV on L2.Father = NIV.CODE_MP
		Where (A7.QryGroup29 = 'Y' or A7.QryGroup30 = 'Y' or A7.QryGroup31 = 'Y' or A7.QryGroup32 = 'Y')
		Group by L2.Code, A7.ItemName ) NIV2 on L3.Father = NIV2.CODE_MP 
	Group by L3.Code, A8.ItemName
	) NIV3 on L4.Father = NIV3.CODE_MP
Group by L4.Code, A9.ItemName
--Where (A9.QryGroup29 = 'Y' or A9.QryGroup30 = 'Y' or A9.QryGroup31 = 'Y' or A9.QryGroup32 = 'Y')
Order By MATERIAL
*/


/* ==============================================================================================
|     MATERIAL CON QUE CERRO LA OP.                                                             |
============================================================================================== */

/*
Select OP.DocNum AS NUM_OP
	, OP.ItemCode AS COD_PT
	, A3.ItemName AS PRODUCTO
	, OP.PlannedQty AS CANTIDAD
	, LO.ItemCode AS COD_MAT
	, A1.ItemName AS MATERIAL
	, LO.IssuedQty AS CAN_MAT
	, Case  When A1.QryGroup29 = 'Y' then 'CASCO' 
			When A1.QryGroup30 = 'Y' then 'HABIL'
			When A1.QryGroup31 = 'Y' then 'PATAS' 
			When A1.QryGroup32 = 'Y' and A1.U_GrupoPlanea = '28' then 'COMPL' 
			When A1.QryGroup32 = 'Y' and A1.U_GrupoPlanea = '6' then 'HULES' 
			When A1.QryGroup32 = 'Y' and A1.U_GrupoPlanea = '13' then 'REFAC' 
			When A1.QryGroup32 = 'Y' and A1.U_GrupoPlanea = '4' then 'ESTRU' 
			When A1.QryGroup32 = 'Y' and A1.U_GrupoPlanea = '3' then 'EMPAQ'
			Else 'MA-PR'
	End AS SUB_ENS 
From OWOR OP
inner join WOR1 LO on LO.DocEntry = OP.DocEntry
inner join OITM A3 on OP.ItemCode = A3.ItemCode
inner join OITM A1 on LO.ItemCode = A1.ItemCode
Where OP.DocNum = 39380

*/



-- ================================================================================================
-- |     Existencia en Almacenes Resumen por Tipo de Material.                                    |
-- ================================================================================================
/*
Select INV.CODIGO
	, B0.ItemName AS DESCRIPCION
	, INV.EXI_ALMA AS EXI_ALMA
	, Case
		When B0.QryGroup29 = 'Y' then 'CASCO' 
		When B0.QryGroup30 = 'Y' then 'HABIL'
		When B0.QryGroup31 = 'Y' then 'PATAS'
		When B0.QryGroup32 = 'Y' and B0.U_GrupoPlanea = '28' then 'COMPL'
		When B0.QryGroup32 = 'Y' and B0.U_GrupoPlanea = '6' then 'HULE'
		When B0.QryGroup32 = 'Y' and B0.U_GrupoPlanea = '13' then 'REFA'
		When B0.QryGroup32 = 'Y' and B0.U_GrupoPlanea = '4' then 'ESTR'
		When B0.QryGroup32 = 'Y' and B0.U_GrupoPlanea = '3' then 'EMPA'
		When B0.QryGroup32 = 'Y' and B0.U_GrupoPlanea = '26' then 'MAQI'
	 End AS SUB_ENS 
From OITM B0 
Inner Join 
(Select B1.ItemCode AS CODIGO
	, SUM(B1.OnHand) AS EXI_ALMA
From OITW B1
Where (B1.WhsCode = 'AMP-ST' or B1.WhsCode = 'AMP-CC' or B1.WhsCode = 'APT-PA' or B1.WhsCode = 'APP-ST')
and  B1.OnHand > 0
Group By B1.ItemCode ) INV on INV.CODIGO = B0.ItemCode
Where (B0.QryGroup29 = 'Y' or B0.QryGroup30 = 'Y'or B0.QryGroup31 = 'Y' or B0.QryGroup32 = 'Y')
Order By B0.ItemName
*/

/* ==============================================================================================
|     ORDENES GENERADAS PARA LOS SUB-ENSAMBLES.                                                  |
============================================================================================== */
/*
Select W0.ItemCode AS CODIGO
	, W3.ItemName AS DESCRIPCION
	, QW1.CANT AS CANT
	, Case
		When W3.QryGroup29 = 'Y' then 'CASCO' 
		When W3.QryGroup30 = 'Y' then 'HABIL'
		When W3.QryGroup31 = 'Y' then 'PATAS'
		When W3.QryGroup32 = 'Y' and W3.U_GrupoPlanea = '28' then 'COMPL'
		When W3.QryGroup32 = 'Y' and W3.U_GrupoPlanea = '6' then 'HULE'
		When W3.QryGroup32 = 'Y' and W3.U_GrupoPlanea = '13' then 'REFA'
		When W3.QryGroup32 = 'Y' and W3.U_GrupoPlanea = '4' then 'ESTR'
		When W3.QryGroup32 = 'Y' and W3.U_GrupoPlanea = '3' then 'EMPA'
		When W3.QryGroup32 = 'Y' and W3.U_GrupoPlanea = '26' then 'MAQI'
	 End AS SUB_ENS 
From OWOR W0
Inner Join OITM W3 on W0.ItemCode = W3.ItemCode
Inner Join (
Select W1.ItemCode AS CODIGO,
	SUM(W1.PlannedQty) AS CANT
From OWOR W1 
Where W1.Status <> 'C' and W1.Status <> 'L'
Group By W1.ItemCode ) QW1 on QW1.CODIGO = W0.ItemCode

*/

-- ================================================================================================
-- |     DETALLE POR ALMACEN EXISTENCIA.                                                          |
-- ================================================================================================
/*
Select B1.WhsCode AS COD_ALMA
	, B2.WhsName AS ALMACEN
	, B0.ItemCode AS CODIGO
	, B0.ItemName AS DESCRIPCION
	, B0.InvntryUom AS UDM
	, B1.OnHand AS EXISTE
	, Case
		When B0.QryGroup29 = 'Y' then 'CASCO' 
		When B0.QryGroup30 = 'Y' then 'HABIL'
		When B0.QryGroup31 = 'Y' then 'PATAS'
		When B0.QryGroup32 = 'Y' and B0.U_GrupoPlanea = '28' then 'COMPL'
		When B0.QryGroup32 = 'Y' and B0.U_GrupoPlanea = '6' then 'HULE'
		When B0.QryGroup32 = 'Y' and B0.U_GrupoPlanea = '13' then 'REFA'
		When B0.QryGroup32 = 'Y' and B0.U_GrupoPlanea = '4' then 'ESTR'
		When B0.QryGroup32 = 'Y' and B0.U_GrupoPlanea = '3' then 'EMPA'
		When B0.QryGroup32 = 'Y' and B0.U_GrupoPlanea = '26' then 'MAQI'
	 End AS SUB_ENS 
From OITM B0 
inner join OITW B1 on B0.ItemCode = B1.ItemCode 
inner join OWHS B2 on B2.WhsCode = B1.WhsCode 
Where (B1.WhsCode = 'AMP-ST' or B1.WhsCode = 'AMP-CC' or B1.WhsCode = 'APT-PA' or B1.WhsCode = 'APP-ST')
and  B1.OnHand > 0
and (B0.QryGroup29 = 'Y' or B0.QryGroup30 = 'Y'or B0.QryGroup31 = 'Y' or B0.QryGroup32 = 'Y')
Order By ALMACEN, B0.ItemName

*/

/*================================================================================================
|     DETALLE DE OP PARA LOS SUB ENSAMBLES.                                                      |
================================================================================================*/

/*
Select Case
	When C0.Status = 'P' then 'PLANIFICADO'
		When C0.Status = 'R' then 'LIBERADO'
	End AS ESTATUS
	, C0.DocEntry AS OP 
	, C0.ItemCode AS CODIGO
	, C1.ItemName AS DESCRIPCION
	
	, CP.U_Recibido-CP.U_Entregado AS CANTIDAD

	, (ISNULL(RT.Name,  
		Case 
		When C0.U_Starus = '01' then '010 Detenido Ventas.  '
		When C0.U_Starus = '02'	then '020 Falta Informacion.' 
		When C0.U_Starus = '03' then '030 Falta Piel o Tela.' 
		When C0.U_Starus = '04' then '040 Revision de Piel. ' 
		When C0.U_Starus = '05' then '050 Por Ordenar.      ' 
		When C0.U_Starus = '06' then  'Proceso de Fabricacion.'
		End
	)) AS AVANCE

	, C0.PostDate AS FEC_ELABORA
	, C0.DueDate AS FEC_TERMINO


		, Case
		When C1.QryGroup29 = 'Y' then 'CASCO' 
		When C1.QryGroup30 = 'Y' then 'HABIL'
		When C1.QryGroup31 = 'Y' then 'PATAS'
		When C1.QryGroup32 = 'Y' and C1.U_GrupoPlanea = '28' then 'COMPL'
		When C1.QryGroup32 = 'Y' and C1.U_GrupoPlanea = '6' then 'HULE'
		When C1.QryGroup32 = 'Y' and C1.U_GrupoPlanea = '13' then 'REFA'
		When C1.QryGroup32 = 'Y' and C1.U_GrupoPlanea = '4' then 'ESTR'
		When C1.QryGroup32 = 'Y' and C1.U_GrupoPlanea = '3' then 'EMPA'
		When C1.QryGroup32 = 'Y' and C1.U_GrupoPlanea = '26' then 'MAQI'
	 End AS SUB_ENS
	
From OWOR C0
inner join OITM C1 on C0.ItemCode = C1.ItemCode 
Left Join [@CP_OF] CP  on CP.U_DocEntry = C0.DocEntry 
Left Join [@PL_RUTAS] RT on CP.U_CT = RT.Code

Where C0.PlannedQty-C0.CmpltQty > 0 
and C0.Status <> 'C' and C0.Status <> 'L'
and C1.U_TipoMat <> 'PT' 
Order by DESCRIPCION,  OP, CANTIDAD Desc

*/

