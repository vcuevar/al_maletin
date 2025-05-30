-- Nombre Reporte: R125 ESTANDAR POR AJUSTAR.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Lunes 29 de Noviembre del 2021; Origen.
-- Actualizado: Jueves 02 de Diciembre del 2021; Cambiar Orden en Compras.
-- 

-- Para las monedas extranjeras se utilizaron los siguientes tipo de cambio:				
-- Select * from SIZ_TipoCambio
Declare @TC_USD as Integer
Declare @TC_CAN as Integer
Declare @TC_EUR as Integer
Declare @TC_MXP as Integer

Set @TC_USD = (Select top(1) TC_usd from SIZ_TipoCambio Order by TC_date DESC)
Set @TC_CAN = (Select top(1) TC_can from SIZ_TipoCambio Order by TC_date DESC)
Set @TC_EUR = (Select top(1) TC_eur from SIZ_TipoCambio Order by TC_date DESC)
Set @TC_MXP = 1

-- Validar que el L7 no sea menor de Ultima COMPRA en caso de ser asi, realizar cambio
-- para que se active validacion al ESTANDAR.
-- ESTE SE MONTO EN MACRO R125 ESTANDAR POR AJUSTAR.
-- Actualizado: Jueves 17 de Febrero del 2022; Agrege al Orden el numero de linea ya que cuando se repite el codigo genera problemas.

	Select	OITM.ItemCode AS CODIGO
			, OITM.ItemName AS DESCRIPCION
			, OITM.InvntryUom AS UDM
			, Cast(ITM1.Price as decimal(16,4)) as Pre_7
			, ITM1.Currency AS Mon_7
			, 7 AS LISTA
			, Cast(((Case When (Select top(1) PDN1.Currency from PDN1 WHERE PDN1.ItemCode = OITM.ItemCode 
				ORDER BY PDN1.DocEntry DESC, PDN1.BaseLine) = 'USD' then (Select top(1) PDN1.Price from PDN1 
				WHERE PDN1.ItemCode = OITM.ItemCode ORDER BY PDN1.DocEntry DESC, PDN1.BaseLine) * @TC_USD  
				When (Select top(1) PDN1.Currency from PDN1 WHERE PDN1.ItemCode = OITM.ItemCode 
				ORDER BY PDN1.DocEntry DESC, PDN1.BaseLine) = 'CAN' then (Select top(1) PDN1.Price from PDN1 
				WHERE PDN1.ItemCode = OITM.ItemCode ORDER BY PDN1.DocEntry DESC, PDN1.BaseLine) * @TC_CAN
				When (Select top(1) PDN1.Currency from PDN1 WHERE PDN1.ItemCode = OITM.ItemCode 
				ORDER BY PDN1.DocEntry DESC, PDN1.BaseLine) = 'EUR' then (Select top(1) PDN1.Price from PDN1 
				WHERE PDN1.ItemCode = OITM.ItemCode ORDER BY PDN1.DocEntry DESC, PDN1.BaseLine) * @TC_EUR
				When (Select top(1) PDN1.Currency from PDN1 WHERE PDN1.ItemCode = OITM.ItemCode 
				ORDER BY PDN1.DocEntry DESC, PDN1.BaseLine) = 'MXP' then (Select top(1) PDN1.Price from PDN1 
				WHERE PDN1.ItemCode = OITM.ItemCode ORDER BY PDN1.DocEntry DESC, PDN1.BaseLine) * @TC_MXP end) 
				/ (Select top(1) PDN1.NumPerMsr from PDN1 WHERE PDN1.ItemCode = OITM.ItemCode 
				ORDER BY PDN1.DocEntry DESC, PDN1.BaseLine)) as decimal(16,4))AS Pre_UC
			, 'MXP' AS Mon_UC
			, 'POR ACTUALIZAR' AS ACCION
			, Cast((Select top(1) PDN1.Price from PDN1 WHERE PDN1.ItemCode = OITM.ItemCode 
				ORDER BY PDN1.DocEntry DESC, PDN1.BaseLine) as decimal(16,4)) AS U_COMP
			, (Select top(1) PDN1.Currency from PDN1 WHERE PDN1.ItemCode = OITM.ItemCode 
				ORDER BY PDN1.DocEntry DESC, PDN1.BaseLine) AS U_MON
			, (SELECT CONVERT(varchar,T1.ActDelDate,3) + '  Se compro a: ' + CONVERT(varchar,T1.Price) + ' ' + T1.Currency 
				FROM (SELECT ROW_NUMBER() OVER(PARTITION BY P.ItemCode ORDER BY P.DocEntry DESC, P.BaseLine) AS NumReng,
				P.DocEntry, P.ItemCode, P.Price, P.ActDelDate, P.Currency FROM PDN1 P WHERE ItemCode = OITM.ItemCode) T1
				WHERE T1.NumReng = 1) AS ULT_1
			, (SELECT CONVERT(varchar,T1.ActDelDate,3) + '  Se compro a: ' + CONVERT(varchar,T1.Price) + ' ' + T1.Currency 
				FROM (SELECT ROW_NUMBER() OVER(PARTITION BY P.ItemCode ORDER BY P.DocEntry DESC, P.BaseLine) AS NumReng,
				P.DocEntry, P.ItemCode, P.Price, P.ActDelDate, P.Currency FROM PDN1 P WHERE ItemCode = OITM.ItemCode) T1
				WHERE T1.NumReng = 2) AS ULT_2
			, (SELECT CONVERT(varchar,T1.ActDelDate,3) + '  Se compro a: ' + CONVERT(varchar,T1.Price) + ' ' + T1.Currency 
				FROM (SELECT ROW_NUMBER() OVER(PARTITION BY P.ItemCode ORDER BY P.DocEntry DESC, P.BaseLine) AS NumReng,
				P.DocEntry, P.ItemCode, P.Price, P.ActDelDate, P.Currency FROM PDN1 P WHERE ItemCode = OITM.ItemCode) T1
				WHERE T1.NumReng = 3) AS ULT_3
			, Cast((Select top(1) PDN1.ActDelDate from PDN1 WHERE PDN1.ItemCode = OITM.ItemCode ORDER BY PDN1.DocEntry DESC, PDN1.BaseLine) as date) AS FEC_ULT
	from OITM
	inner join ITM1 on ITM1.ItemCode = OITM.ItemCode and ITM1.PriceList = 7
	WHERE Cast(ITM1.Price as decimal(16,4)) < 
	Cast(
	((Case 
	When (Select top(1) PDN1.Currency from PDN1 WHERE PDN1.ItemCode = OITM.ItemCode ORDER BY PDN1.DocEntry DESC, PDN1.BaseLine) = 'USD' 
	then (Select top(1) PDN1.Price from PDN1 WHERE PDN1.ItemCode = OITM.ItemCode ORDER BY PDN1.DocEntry DESC, PDN1.BaseLine) * @TC_USD  
	
	When (Select top(1) PDN1.Currency from PDN1 WHERE PDN1.ItemCode = OITM.ItemCode ORDER BY PDN1.DocEntry DESC, PDN1.BaseLine) = 'CAN' 
	then (Select top(1) PDN1.Price from PDN1 WHERE PDN1.ItemCode = OITM.ItemCode ORDER BY PDN1.DocEntry DESC, PDN1.BaseLine) * @TC_CAN
	
	When (Select top(1) PDN1.Currency from PDN1 WHERE PDN1.ItemCode = OITM.ItemCode ORDER BY PDN1.DocEntry DESC, PDN1.BaseLine) = 'EUR' 
	then (Select top(1) PDN1.Price from PDN1 WHERE PDN1.ItemCode = OITM.ItemCode ORDER BY PDN1.DocEntry DESC, PDN1.BaseLine) * @TC_EUR
	
	When (Select top(1) PDN1.Currency from PDN1 WHERE PDN1.ItemCode = OITM.ItemCode ORDER BY PDN1.DocEntry DESC, PDN1.BaseLine) = 'MXP' 
	then (Select top(1) PDN1.Price from PDN1 WHERE PDN1.ItemCode = OITM.ItemCode ORDER BY PDN1.DocEntry DESC, PDN1.BaseLine) * @TC_MXP 
	end)
	/ (Select top(1) PDN1.NumPerMsr from PDN1 WHERE PDN1.ItemCode = OITM.ItemCode ORDER BY PDN1.DocEntry DESC, PDN1.BaseLine))as decimal(16,4))
	and OITM.U_TipoMat = 'MP' 
	and OITM.FrozenFor = 'N'
	
	order by OITM.ItemName


	--SELECT TOP(10) * FROM PDN1

	Select top(10) PDN1.ShipDate, ActDelDate,  * from PDN1 
	WHERE PDN1.ItemCode = '18287' ORDER BY PDN1.DocEntry DESC, PDN1.BaseLine


/*
-- Consulta
Select	OITM.ItemCode AS CODE
		, OITM.ItemName AS NOMBRE
		, OITM.InvntryUom AS UDM
		, Cast(OITM.OnHand as decimal(16,2)) AS EXISTENCIA
		, Cast(LS.Price as decimal(16,2)) AS PRE_10
		, Cast(L7.Price as decimal(16,2)) AS PRE_7
		, Cast((OITM.OnHand * (L7.Price - LS.Price)) as decimal(16,2)) AS INCREMENTO
	
		, (SELECT CONVERT(varchar,T1.DocDate,3) + ' A: ' + CONVERT(varchar,Cast(T1.Price as decimal(16,2))) + ' ' + T1.Currency 
		FROM (
		SELECT ROW_NUMBER() OVER(PARTITION BY P.ItemCode ORDER BY P.DocDate DESC) AS NumReng
		, P.DocEntry
		, P.ItemCode
		, P.Price
		, P.DocDate
		, P.Currency 
		FROM PDN1 P 
		WHERE ItemCode = OITM.ItemCode) T1 WHERE T1.NumReng = 1
		) AS ULT_1,
	
	(SELECT CONVERT(varchar,T1.DocDate,3) + ' A: ' + CONVERT(varchar,Cast(T1.Price as decimal(16,2))) + ' ' + T1.Currency 
	FROM (SELECT ROW_NUMBER() OVER(PARTITION BY P.ItemCode ORDER BY P.DocDate DESC) AS NumReng, P.DocEntry, P.ItemCode, P.Price, P.DocDate, P.Currency 
	FROM PDN1 P WHERE ItemCode = OITM.ItemCode) T1 WHERE T1.NumReng = 2
	) AS ULT_2
	
	, (SELECT CONVERT(varchar,T1.DocDate,3) + ' A: ' + CONVERT(varchar,Cast(T1.Price as decimal(16,2))) + ' ' + T1.Currency 
	FROM (SELECT ROW_NUMBER() OVER(PARTITION BY P.ItemCode ORDER BY P.DocDate DESC) AS NumReng
	, P.DocEntry, P.ItemCode, P.Price, P.DocDate, P.Currency FROM PDN1 P 
	WHERE ItemCode = OITM.ItemCode) T1 WHERE T1.NumReng = 3 ) AS ULT_3 
	
	From OITM 
	INNER JOIN ITM1 L7 on OITM.ItemCode = L7.ItemCode and L7.PriceList = 7 
	INNER JOIN ITM1 LS on OITM.ItemCode= LS.ItemCode and LS.PriceList = 10 
	
	Where Cast(L7.Price as decimal(16,4)) <> Cast(LS.Price as decimal(16,4)) and OITM.EvalSystem = 'S' and U_TipoMat = 'MP' AND LS.Price > 0 and OITM.frozenFor = 'N' and OITM.OnHand > 0 Order By OITM.ItemName 



	
--Select OITM.ItemCode AS CODE, OITM.ItemName AS NOMBRE, OITM.InvntryUom AS UDM, Cast(OITM.OnHand as decimal(16,2)) AS EXISTENCIA, Cast(LS.Price as decimal(16,2)) AS PRE_10, Cast(L7.Price as decimal(16,2)) AS PRE_7, Cast((OITM.OnHand * (L7.Price - LS.Price)) as decimal(16,2)) AS INCREMENTO, (SELECT CONVERT(varchar,T1.DocDate,3) + ' A: ' + CONVERT(varchar,Cast(T1.Price as decimal(16,2))) + ' ' + T1.Currency FROM (SELECT ROW_NUMBER() OVER(PARTITION BY P.ItemCode ORDER BY P.DocDate DESC) AS NumReng, P.DocEntry, P.ItemCode, P.Price, P.DocDate, P.Currency FROM PDN1 P WHERE ItemCode = OITM.ItemCode) T1 WHERE T1.NumReng = 1) AS ULT_1, (SELECT CONVERT(varchar,T1.DocDate,3) + ' A: ' + CONVERT(varchar,Cast(T1.Price as decimal(16,2))) + ' ' + T1.Currency 
--FROM (SELECT ROW_NUMBER() OVER(PARTITION BY P.ItemCode ORDER BY P.DocDate DESC) AS NumReng, P.DocEntry, P.ItemCode, P.Price, P.DocDate, P.Currency FROM PDN1 P WHERE ItemCode = OITM.ItemCode) T1 WHERE T1.NumReng = 2) AS ULT_2, (SELECT CONVERT(varchar,T1.DocDate,3) + ' A: ' + CONVERT(varchar,Cast(T1.Price as decimal(16,2))) + ' ' + T1.Currency FROM (SELECT ROW_NUMBER() OVER(PARTITION BY P.ItemCode ORDER BY P.DocDate DESC) AS NumReng, P.DocEntry, P.ItemCode, P.Price, P.DocDate, P.Currency FROM PDN1 P WHERE ItemCode = OITM.ItemCode) T1 WHERE T1.NumReng = 3 ) AS ULT_3 From OITM INNER JOIN ITM1 L7 on OITM.ItemCode = L7.ItemCode and L7.PriceList = 7 INNER JOIN ITM1 LS on OITM.ItemCode= LS.ItemCode and LS.PriceList = 10 Where Cast(L7.Price as decimal(16,2)) <> Cast(LS.Price as decimal(16,2)) and OITM.EvalSystem = 'S' and U_TipoMat = 'MP' AND LS.Price > 0 and OITM.frozenFor = 'N' and OITM.OnHand > 0 Order By OITM.ItemName 
*/



/*

Select OITM.ItemCode AS CODE, OITM.ItemName AS NOMBRE, OITM.InvntryUom AS UDM, Cast(L9.Price as decimal(16,2)) AS PRECIO_COMPRAS, L9.Currency AS MONEDA_COMPRAS, Cast(L10.Price as decimal(16,2)) AS PRECIO_STANDAR, L10.Currency AS MONEDA_STANDAR, Cast(L1.Price as decimal(16,2)) AS PRECIO_DISE�O, L1.Currency AS MONEDA_DISE�O, Cast(L7.Price as decimal(16,2)) AS PRECIO_COSTOS, L7.Currency AS MONEDA_COSTOS, Cast(L2.Price as decimal(16,2)) AS PRECIO_VENTAS, L2.Currency AS MONEDA_VENTAS 
, T1.Descr AS GRUPPLAN From OITM 
INNER JOIN ITM1 L1 on OITM.ItemCode = L1.ItemCode and L1.PriceList = 1 
INNER JOIN ITM1 L2 on OITM.ItemCode = L2.ItemCode and L2.PriceList = 2 
INNER JOIN ITM1 L7 on OITM.ItemCode = L7.ItemCode and L7.PriceList = 7 
INNER JOIN ITM1 L9 on OITM.ItemCode = L9.ItemCode and L9.PriceList = 9 
INNER JOIN ITM1 L10 on OITM.ItemCode = L10.ItemCode and L10.PriceList=10 
left join UFD1 T1 on OITM.U_GrupoPlanea=T1.FldValue and T1.TableID='OITM' and T1.FieldID=9 
Where U_TipoMat = 'MP' and OITM.frozenFor = 'N' and OITM.U_Linea = '01' Order By OITM.ItemName 

*/


Select OITM.ItemCode AS CODIGO
	, OITM.ItemName AS DESCRIPCION
	, OITM.InvntryUom AS UDM
	, Cast(L7.Price as decimal(16,4)) AS P_PRU
	, L7.Currency AS M_PRU
	, L7.PriceList AS L_PRE
	, Cast(L10.Price as decimal(16,4)) AS P_STD
	, L10.Currency AS M_STD
	, 'POR ACTUALIZAR' AS ACCION 
From OITM
INNER JOIN ITM1 L7 on OITM.ItemCode = L7.ItemCode and L7.PriceList = 7 
INNER JOIN ITM1 L10 on OITM.ItemCode = L10.ItemCode and L10.PriceList=10 
Where L7.Price  <> L10.Price
Order By OITM.ItemCode



Select  OITM.ItemCode AS CODE, OITM.ItemName AS NOMBRE, OITM.InvntryUom AS UDM
	, Cast(L7.Price as decimal(16,4)) AS PRECIO_7, L7.Currency AS MON
	, 7 AS LIST_7, Cast(LS.Price as decimal(16,4)) AS PRECIO_L1
	, LS.Currency AS MON_L1, 'POR ACTUALIZAR' AS ACCION 
From OITM 
INNER JOIN ITM1 L7 on OITM.ItemCode = L7.ItemCode and L7.PriceList = 7 
INNER JOIN ITM1 LS on OITM.ItemCode= LS.ItemCode and LS.PriceList = 1 
Where L7.Price = 0  and OITM.EvalSystem = 'S' and OITM.frozenFor = 'N' --and OITM.U_TipoMat = 'MP' 
Order By OITM.ItemName 


-- ================================================================================================
-- |              PARA ASIGNAR PRECIO ESTANDAR EN BASE A LISTA 7.                                 |
-- ================================================================================================
-- Hoja 6 de la Macro.
-- Actualizado al 19 de Septiembre del 2024.
-- Presenta los MATERIALES COMPRADOS estandar diferente, con existencia validacion manual. 
Select OITM.ItemCode AS CODIGO
	, OITM.ItemName AS DESCRIPCION
	, OITM.InvntryUom AS UDM
	, ISNULL(LS.Price, 0) AS Pre_STD
	, LS.Currency AS Mon_STD
	, 10 AS LISTA
	, ITM1.Price AS Pre_7
	, ITM1.Currency AS Mon_7
	, (Case When OITM.OnHand > 0 then  'VALIDAR MANUAL' else 'POR ACTUALIZAR' end ) AS ACCION 
	, OITM.U_TipoMat AS TM 
From OITM 
INNER JOIN ITM1 on OITM.ItemCode=ITM1.ItemCode and ITM1.PriceList=7 
INNER JOIN ITM1 LS on OITM.ItemCode= LS.ItemCode and LS.PriceList=10 
Where OITM.EvalSystem = 'S' and OITM.frozenFor = 'N' and ITM1.Price <> ISNULL(LS.Price, 0)
and OITM.U_TipoMat = 'SP' 
and OITM.QryGroup32 = 'Y'
and OITM.OnHand = 0
Order By OITM.ItemName 

-- ================================================================================================
-- |              SUB ESNSAMBLES PENDIENTES DE AJUSTAR A BASE A LISTA 7.                          |
-- ================================================================================================
-- Hoja 2 de la Macro.
-- Actualizado al 19 de Septiembre del 2024.
-- Presenta los MATERIALES TODO TIPO DE SUB-ENSAMBLE estandar diferente, con existencia validacion manual. 
Select OITM.ItemCode AS CODE
	, OITM.ItemName AS NOMBRE
	, OITM.InvntryUom AS UDM
	, OITM.OnHand AS EXIST
	, LS.Price AS PRECIO_LS
	, L7.Price AS PRECIO_7
	, Cast((OITM.OnHand * (L7.Price - LS.Price)) as decimal(16,4)) AS INCREMENTO
	, Cast(OITM.LastPurDat as date) AS FECHULT 
From OITM 
INNER JOIN ITM1 L7 on OITM.ItemCode = L7.ItemCode and L7.PriceList=7 
INNER JOIN ITM1 LS on OITM.ItemCode= LS.ItemCode and LS.PriceList=10 
Where Cast(L7.Price as decimal(16,3)) <> Cast(ISNULL(LS.Price, 0) as decimal(16,3)) 
and OITM.EvalSystem = 'S' 
and OITM.frozenFor = 'N'
and U_TipoMat <> 'MP' and U_TipoMat <> 'PT' 
Order By OITM.ItemName 

-- ================================================================================================
-- |              PRODUCTOS TERMINADOS PENDIENTES DE AJUSTAR A BASE A LISTA 7.                    |
-- ================================================================================================
-- Hoja 3 de la Macro.
-- Actualizado al 19 de Septiembre del 2024.
-- Presenta los MATERIALES PRODUCTO TERMINADO estandar diferente, con existencia validacion manual. 
Select OITM.ItemCode AS CODE
	, OITM.ItemName AS NOMBRE
	, OITM.InvntryUom AS UDM
	, OITM.OnHand AS EXIST
	, LS.Price AS PRECIO_LS
	, L7.Price AS PRECIO_7
	, Cast((OITM.OnHand * (L7.Price - LS.Price)) as decimal(16,2)) AS INCREMENTO
	, Cast(OITM.LastPurDat as date) AS FECHULT 
From OITM 
INNER JOIN ITM1 L7 on OITM.ItemCode = L7.ItemCode and L7.PriceList=7 
INNER JOIN ITM1 LS on OITM.ItemCode= LS.ItemCode and LS.PriceList=10 
Where Cast(L7.Price as decimal(16,3)) <> Cast(LS.Price as decimal(16,3)) 
and OITM.EvalSystem = 'S' 
and OITM.frozenFor = 'N'
and U_TipoMat = 'PT' 
Order By OITM.ItemName 


-- ================================================================================================
-- |       ARTICULOS GLOBALES IGUALAR A ESTANDAR LISTA PRUEBA PARA INICIAR CAMBIOS.               |
-- ================================================================================================
-- Hoja 6 de la Macro.
-- Actualizado al 20 de Septiembre del 2024.
-- Presenta los ARTICULO diferente a lista prueba a estandar, para igualar al estandar. 
Select OITM.ItemCode AS CODIGO
	, OITM.ItemName AS DESCRIPCION
	, OITM.InvntryUom AS UDM
	, ITM1.Price AS Pre_7
	, ITM1.Currency AS Mon_7
	, 7 AS LISTA
	, ISNULL(LS.Price, 0) AS Pre_STD
	, LS.Currency AS Mon_STD
	, 'POR ACTUALIZAR' AS ACCION 
	, OITM.U_TipoMat AS TM 
	, OITM.OnHand AS EXT 
From OITM 
INNER JOIN ITM1 on OITM.ItemCode=ITM1.ItemCode and ITM1.PriceList=7 
INNER JOIN ITM1 LS on OITM.ItemCode= LS.ItemCode and LS.PriceList=10 
Where OITM.EvalSystem = 'S' and OITM.frozenFor = 'N' and ITM1.Price <> ISNULL(LS.Price, 0)
Order By OITM.ItemName 


