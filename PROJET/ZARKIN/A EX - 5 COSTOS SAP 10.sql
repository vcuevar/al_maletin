-- EXCEPCIONES DE COSTOS Y MANEJO DE LISTA DE PRECIOS. 
-- OBJETIVO: Mantener al dia El costo Estandar y auditar las Listas de Precios.
-- Desarrollo: Ing. Vicente Cueva Ramírez.
-- Actualizado: Lunes 26 de Agosto del 2021; SAP-10, Quitar autocorrecion.
-- Actualizado: Martes 16 de Enero del 2024; Depurar.

/* ================================================================================================
|    EXCEPCIONES TIPO DE CAMBIO ASIGNADOS.                                                        |
================================================================================================= */

-- Select * from SIZ_TipoCambio
Declare @TC_USD as Integer
Declare @TC_CAN as Integer
Declare @TC_EUR as Integer
Declare @TC_MXP as Integer

Set @TC_USD = (Select top(1) TC_usd from SIZ_TipoCambio Order by TC_date DESC)
Set @TC_CAN = (Select top(1) TC_can from SIZ_TipoCambio Order by TC_date DESC)
Set @TC_EUR = (Select top(1) TC_eur from SIZ_TipoCambio Order by TC_date DESC)
Set @TC_MXP = 1

-- Actualizado 09 de Diciembre del 2021; Origen
-- Actualizado Martes 16 de Enero del 2024; Actualizar. 
/* Listas de Precio de SAP 
1	00 DISEÑO.				(Administra DISEÑO).
2	A - VENTAS GENERAL.		(2.5 del 10 ESTANDAR).
9	A - COMPRAS				(Administra COMPRAS). a la fecha nadie toma control.
7   PRUEBAS SISTEAS         (Administra SISTEMAS (COSTO)) Se va actualizando al mes con Ultima compra 
10	10						(Administra FINANZAS)
*/

/* ================================================================================================
|    EXCEPCIONES LISTA PRECIOS (VALIDAR SI SE QUITAN YA QUE SE TIENE MACRO.                        |
================================================================================================= */

-- ------------------------------------------------------------------------------------------------------------------------
--        S-000   LISTA DE PRECIOS 7, COSTOS, A CARGO PROVISIONAL DE SISTEMAS.
-- ------------------------------------------------------------------------------------------------------------------------
-- Validar que no tenga ceros en listas de Precios 7 Pruebas Sistemas. Asignar mismo que se tiene
-- en Diseño o determinar, Solo MP y no esten Invalidos.
/*
Select	'005 CERO 7 SISTEMAS' AS COSTOS_005
		, OITM.ItemCode AS CODE
		, OITM.ItemName AS NOMBRE
		, OITM.InvntryUom AS UDM
		, Cast(L7.Price as decimal(16,4)) AS PRECIO_7
		, L7.Currency AS MON
		, 7 AS LIST_7
		, Cast(LS.Price as decimal(16,4)) AS PRECIO_L1
		, LS.Currency AS MON_L1
		, 'POR ACTUALIZAR' AS ACCION
From OITM 
INNER JOIN ITM1 L7 on OITM.ItemCode = L7.ItemCode and L7.PriceList = 7
INNER JOIN ITM1 LS on OITM.ItemCode= LS.ItemCode and LS.PriceList = 1 
Where L7.Price = 0  and OITM.EvalSystem = 'S' and OITM.frozenFor = 'N'
and OITM.U_TipoMat = 'MP' 
Order By OITM.ItemName 



-- Articulos sin Precio Estandar
Select '010 STD CERO' AS COSTO_010
		, OITM.ItemCode AS CODE
		, OITM.ItemName AS NOMBRE
		, OITM.InvntryUom AS UDM
		, Cast(OITM.AvgPrice as decimal(16,4)) AS PRECIO_AV
		, 'MXP' AS MON_AV
		, LS.PriceList AS LISTA
		, LS.Price AS PRECIO_LD
		, LS.Currency AS MON_LD
From OITM 
INNER JOIN ITM1 LS on OITM.ItemCode =LS.ItemCode and LS.PriceList=10
Where OITM.frozenFor = 'N' and OITM.AvgPrice = 0 and OITM.InvntItem = 'N'
Order By NOMBRE

	
	 SELECT top 3 P.Price, P.DocDate, P.Currency, *
                  FROM PDN1 P 
                  WHERE ItemCode = '15807'
                  order by DocEntry desc

		Select * from OPDN Where DocEntry = '1729'
		Select * from PDN1 Where DocEntry = '1729'

		SELECT CONVERT(varchar,T1.DocDate,3) + '  Se compro a: ' + CONVERT(varchar,T1.Price) + ' ' + T1.Currency FROM (
		SELECT
			ROW_NUMBER() OVER(PARTITION BY P.ItemCode ORDER BY P.DocEntry DESC) AS NumReng,
			 P.DocEntry, P.ItemCode, P.Price, P.DocDate, P.Currency
		FROM PDN1 P
		WHERE ItemCode = '15807') T1
		WHERE T1.NumReng = 4
*/
			   		 	  
-- ------------------------------------------------------------------------------------------------------------------------
--        S-200   LISTA DE PRECIOS 1, DISEÑO, A CARGO DE DISEÑO.
-- ------------------------------------------------------------------------------------------------------------------------

/*
--	EX-DIS-005 Validar que los articulos modelos cuenten con Estandar de 0.0001 
		Select	'205 ? SIN ESTANDAR MODELO' AS REPORTE, 
				OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat,
				OITM.U_VS, OITM.AvgPrice
		from OITM
		where  OITM.U_IsModel = 'S' 
		and OITM.AvgPrice <> 0.0001
		order by OITM.ItemName

-- Validar MENOR SOLO MP ENTRE 1 Y 7 SE CORRIGE MANUALMENTE L1
-- NO TOMAR EN CUENTA PIEL Y COLORES VALIDAR Y CAMBIAR AL MAS ALTO DEL ESTANDAR.

Integrada en Macro de Gestion de Costos.

Select	'210 MP 1 < 7' AS DISEÑO_210
		, OITM.ItemCode AS CODE
		, OITM.ItemName AS NOMBRE
		, OITM.InvntryUom AS UDM
		, L1.Price AS PRE_1
		, L1.Currency AS MON_1
		, 1 AS LIST_1
		--, LS.Price AS PRE_7
		, Cast((Case When L1.Currency = 'USD' then LS.Price  / @TC_USD  
			When L1.Currency = 'CAN' then LS.Price  / @TC_CAN
			When L1.Currency = 'EUR' then LS.Price  / @TC_EUR
			When L1.Currency = 'MXP' then LS.Price  / @TC_MXP end) as decimal(16,2)) AS PRE_1_NW
		, L1.Currency AS MON_1_NW
		, 'POR ACTUALIZAR' AS ACCION
From OITM 
INNER JOIN ITM1 L1 on OITM.ItemCode = L1.ItemCode and L1.PriceList = 1
INNER JOIN ITM1 LS on OITM.ItemCode= LS.ItemCode and LS.PriceList = 7 
Where Cast((Case When L1.Currency = 'USD' then L1.Price  * @TC_USD  
When L1.Currency = 'CAN' then L1.Price  * @TC_CAN
When L1.Currency = 'EUR' then L1.Price  * @TC_EUR
When L1.Currency = 'MXP' then L1.Price  * @TC_MXP end) as decimal(16,2)) < Cast(LS.Price as decimal(16,2)) and OITM.EvalSystem = 'S' 
and U_TipoMat = 'MP' AND LS.Price > 0 and OITM.frozenFor = 'N' and OITM.U_GrupoPlanea <> 9
Order By OITM.ItemName 
*/

-- Validar DIFERENTE SOLO MP ENTRE 10 Y 7 SE CORRIGE MANUALMENTE LP 7
-- 231123 Se lleva control en Excel Costos.
/*
Select	'213 LP 10 <> 7' AS LPRECIOS_213
		, OITM.ItemCode AS CODE
		, OITM.ItemName AS NOMBRE
		, OITM.InvntryUom AS UDM
		, L1.Price AS PRE_7
		, L1.Currency AS MON_7
		, L1.PriceList AS LIST_7
		, LS.Price AS PRE_10
		, LS.Currency AS MON_10
		, LS.PriceList AS LIST_10
		, 'POR ACTUALIZAR' AS ACCION
From OITM 
INNER JOIN ITM1 L1 on OITM.ItemCode = L1.ItemCode and L1.PriceList = 7
INNER JOIN ITM1 LS on OITM.ItemCode= LS.ItemCode and LS.PriceList = 10 
Where OITM.EvalSystem = 'S' and U_TipoMat = 'MP' and OITM.frozenFor = 'N' AND OITM.U_GrupoPlanea <> '6' 
AND LS.Price <> L1.Price
Order By OITM.ItemName 
*/
/*
-- Validar que no tenga ceros en listas de Precios 01 DISEÑO.
Select	'215 CERO 00 DISEÑO' AS DISEÑO_215
		, OITM.ItemCode AS CODE
		, OITM.ItemName AS NOMBRE
		, OITM.InvntryUom AS UDM
		, LS.Price AS PRECIO_LD
		, LS.Currency AS MON_LD
From OITM 
INNER JOIN ITM1 on OITM.ItemCode=ITM1.ItemCode and ITM1.PriceList=10
INNER JOIN ITM1 LS on OITM.ItemCode= LS.ItemCode and LS.PriceList=1 
Where LS.Price = 0  and OITM.EvalSystem = 'S' and ITM1.Price > 0
Order By OITM.ItemName 
*/
-- ------------------------------------------------------------------------------------------------------------------------
--        S-300   LISTA DE PRECIOS 10, ESTANDAR, A CARGO DE FINANZAS.
-- ------------------------------------------------------------------------------------------------------------------------
/*
-- Validar que no tenga ceros en listas de Precios 10 ESTANDAR, SIN EXISTENCIA.
Select	'305 CERO 10 ESTANDAR' AS FINANZAS_305
		, OITM.ItemCode AS CODE
		, OITM.ItemName AS NOMBRE
		, OITM.InvntryUom AS UDM
		, LS.Price AS PRECIO_10
		, LS.Currency AS MON_10
		, 10 AS LIST_10
		, L7.Price AS PRECIO_L7
		, L7.Currency AS MON_L7
		, 'POR ACTUALIZAR' AS ACCION
From OITM 
INNER JOIN ITM1 L7 on OITM.ItemCode = L7.ItemCode and L7.PriceList = 7
INNER JOIN ITM1 LS on OITM.ItemCode= LS.ItemCode and LS.PriceList = 10 
Where LS.Price = 0  and OITM.EvalSystem = 'S' and OITM.frozenFor = 'N'
Order By OITM.ItemName 
*/
/*
-- No usar cambios al Estandar ya que dira David como se hara Marzo 22
-- Validar DIFERENCIAS SOLO MP, ENTRE 7 Y 10 SE CORRIGE MACRO SIN EXISTENCIAS
Select	'310 MP 7 <> 10 s/exit' AS FINANZAS_310
		, OITM.ItemCode AS CODE
		, OITM.ItemName AS NOMBRE
		, OITM.InvntryUom AS UDM
		, OITM.OnHand AS EXISTENCIA
		, LS.Price AS PRE_10
		, L7.Price AS PRE_7
From OITM 
INNER JOIN ITM1 L7 on OITM.ItemCode = L7.ItemCode and L7.PriceList = 7
INNER JOIN ITM1 LS on OITM.ItemCode= LS.ItemCode and LS.PriceList = 10 
Where Cast(L7.Price as decimal(16,2)) <> Cast(LS.Price as decimal(16,2)) and OITM.EvalSystem = 'S' 
and U_TipoMat = 'MP' AND LS.Price > 0 and OITM.frozenFor = 'N' and OITM.OnHand = 0
Order By OITM.ItemName 
*/

/*
-- Validar DIFERENCIAS ENTRE 7 Y 10. ACTUALIZAR 10, SUBENSAMBLES CON EXISTENCIAS.
-- PARA ACTUALIZAR, Validar. Cuando la fecha de ultima compra fuera menor a 6 meses
-- Acual consulta tiene un mes pero hay que actualizar hasta fijar en 6 meses.
Select	'320 SB 7 <> 10 c/exit' AS FINANZAS_320
		, OITM.ItemCode AS CODE
		, OITM.ItemName AS NOMBRE
		, OITM.InvntryUom AS UDM
		, OITM.OnHand AS EXIST
		, LS.Price AS PRECIO_LS
		, L7.Price AS PRECIO_7
		, Cast((OITM.OnHand * (L7.Price - LS.Price)) as decimal(16,2)) AS INCREMENTO
		--, Cast(((L7.Price - LS.Price) /  LS.Price) * 100 as decimal(16,1)) AS INCRE
		--, Cast(DATEADD(MM,-4, GETDATE()) as date) AS FECHA
		, Cast(OITM.LastPurDat as date) AS FECHULT
From OITM 
INNER JOIN ITM1 L7 on OITM.ItemCode = L7.ItemCode and L7.PriceList=7
INNER JOIN ITM1 LS on OITM.ItemCode= LS.ItemCode and LS.PriceList=10 
Where Cast(L7.Price as decimal(16,2)) <> Cast(LS.Price as decimal(16,2)) and OITM.EvalSystem = 'S' 
and U_TipoMat <> 'MP' and U_TipoMat <> 'PT' AND LS.Price > 0 AND OITM.OnHand > 0
--and OITM.U_Linea = '01'
--and Cast(OITM.LastPurDat as date) > Cast(DATEADD(MM,-4, GETDATE()) as date)
Order By (Cast(((L7.Price - LS.Price) /  LS.Price) * 100 as decimal(16,1))) DESC, OITM.ItemName 


-- Validar DIFERENCIAS ENTRE 7 Y 10. ACTUALIZAR 10, PRODUCTO TERMINADO CON EXISTENCIAS.
-- PARA ACTUALIZAR, Validar. Cuando la fecha de ultima compra fuera menor a 6 meses
-- Acual consulta tiene un MES pero hay que actualizar hasta fijar en 6 meses.
Select	'325 PT. 7 <> 10 c/exit' AS FINANZAS_325
		, OITM.ItemCode AS CODE
		, OITM.ItemName AS NOMBRE
		, OITM.InvntryUom AS UDM
		, OITM.OnHand AS EXIST
		, LS.Price AS PRECIO_LS
		, L7.Price AS PRECIO_7
		, Cast((OITM.OnHand * (L7.Price - LS.Price)) as decimal(16,2)) AS INCREMENTO
		--, Cast(((L7.Price - LS.Price) /  LS.Price) * 100 as decimal(16,1)) AS INCRE
		--, Cast(DATEADD(MM,-4, GETDATE()) as date) AS FECHA
		, Cast(OITM.LastPurDat as date) AS FECHULT
From OITM 
INNER JOIN ITM1 L7 on OITM.ItemCode = L7.ItemCode and L7.PriceList = 7
INNER JOIN ITM1 LS on OITM.ItemCode= LS.ItemCode and LS.PriceList=10 
Where Cast(L7.Price as decimal(16,2)) <> Cast(LS.Price as decimal(16,2)) and OITM.EvalSystem = 'S' 
and U_TipoMat = 'PT' AND LS.Price > 0 AND OITM.OnHand > 0
--and Cast(OITM.LastPurDat as date) > Cast(DATEADD(MM,-1, GETDATE()) as date)
Order By (Cast(((L7.Price - LS.Price) /  LS.Price) * 100 as decimal(16,1))) DESC, OITM.ItemName 

-- Coparativo de las Listas de Precios.
Select	'330 LISTAS DE PRECIO' AS FINANZAS_325
		, OITM.ItemCode AS CODE
		, OITM.ItemName AS NOMBRE
		, OITM.InvntryUom AS UDM
		, Cast(L9.Price as decimal(16,2)) AS PRECIO_COMPRAS
		, L9.Currency AS MONEDA_COMPRAS
		, Cast(L10.Price as decimal(16,2)) AS PRECIO_STANDAR
		, L10.Currency AS MONEDA_STANDAR
		, Cast(L1.Price as decimal(16,2)) AS PRECIO_DISEÑO
		, L1.Currency AS MONEDA_DISEÑO
		, Cast(L7.Price as decimal(16,2)) AS PRECIO_COSTOS
		, L7.Currency AS MONEDA_COSTOS
		, Cast(L2.Price as decimal(16,2)) AS PRECIO_VENTAS
		, L2.Currency AS MONEDA_VENTAS
From OITM 
INNER JOIN ITM1 L1 on OITM.ItemCode = L1.ItemCode and L1.PriceList = 1
INNER JOIN ITM1 L2 on OITM.ItemCode = L2.ItemCode and L2.PriceList = 2
INNER JOIN ITM1 L7 on OITM.ItemCode = L7.ItemCode and L7.PriceList = 7
INNER JOIN ITM1 L9 on OITM.ItemCode = L9.ItemCode and L9.PriceList = 9
INNER JOIN ITM1 L10 on OITM.ItemCode = L10.ItemCode and L10.PriceList=10 
Where U_TipoMat = 'MP' 
Order By OITM.ItemName 
*/

-- DETECTAR DIFERENTE MONEDA EN L10 COSTO ESTANDAR.
	Select	'330 ? PRECIOS<>MX' AS REPORTE_330, 
			OITM.ItemCode AS CODE, 
			OITM.ItemName AS DESCRIPCION,
			ITM1.Price AS L10, 
			ITM1.Currency AS MONEDA, 
			ITM1.PriceList AS LISTA 
	From ITM1 
	inner join OITM on ITM1.ItemCode = OITM.ItemCode AND ITM1.PriceList = 10
	where ITM1.Currency <> 'MXP' 

/*
-- Validar que no tenga ceros en listas de Precios 09 A-COMPRAS.
-- Habilitar despues de que se libere seguimiento de Listas de Precios en SIZ.
Select	'015 CERO A-COMPRAS' AS REPORTE_015
		, OITM.ItemCode AS CODE
		, OITM.ItemName AS NOMBRE
		, OITM.U_TipoMat AS TMAT
		, ITM1.Price AS PRECIO
		, ITM1.PriceList AS LISTA
		, ITM1.Currency AS MON
From OITM 
INNER JOIN ITM1 on OITM.ItemCode=ITM1.ItemCode and ITM1.PriceList=9 
Where ITM1.Price = 0  and OITM.EvalSystem = 'S'
Order By OITM.ItemName 
*/

-- Validar que no tenga ceros en listas de Precios 02 VENTAS.
-- Quito esta validacion ya que esta la macro que ajusta los precios de Ventas.
/*
Select	'020 CERO A-VENTAS' AS REPORTE_020
		, OITM.ItemCode AS CODE
		, OITM.ItemName AS NOMBRE
		, OITM.U_TipoMat AS TMAT
		, ITM1.Price AS PRECIO
		, ITM1.PriceList AS LISTA
		, ITM1.Currency AS MON
From OITM 
INNER JOIN ITM1 on OITM.ItemCode=ITM1.ItemCode and ITM1.PriceList=2
Where ITM1.Price = 0  and OITM.EvalSystem = 'S'
Order By OITM.ItemName 
*/


/*
-- Validar que el L7 no sea menor de Ultima compra en caso de ser asi, 
-- valorar cambiar para que despues se reflejado el cambi a L10 solo MP con Existencia.
-- AQUI NECESITAMOS GENERAR RELACION DE ULTIMAS COMPRAS Y SI SON TRES IGUALES ENTONCES
-- CAMBIAR A ESA ULTIMA COMPRA.
	Select	'045 L10<UCOMP c/Exist' AS COSTOS_045, 
			OITM.ItemCode AS CODIGO,
			OITM.ItemName AS DESCRIPCION,
			OITM.OnHand AS EXI_TOTAL,
			Case When OITM.LastPurCur = 'USD' then OITM.LastPurPrc * @TC_USD  
				 When OITM.LastPurCur = 'CAN' then OITM.LastPurPrc * @TC_CAN
				 When OITM.LastPurCur = 'EUR' then OITM.LastPurPrc * @TC_EUR
				 When OITM.LastPurCur = 'MXP' then OITM.LastPurPrc * @TC_MXP end AS U_COM_MX,
			ITM1.Price as L_7
			,  Cast((((Case When OITM.LastPurCur = 'USD' then OITM.LastPurPrc * @TC_USD  
				 When OITM.LastPurCur = 'CAN' then OITM.LastPurPrc * @TC_CAN
				 When OITM.LastPurCur = 'EUR' then OITM.LastPurPrc * @TC_EUR
				 When OITM.LastPurCur = 'MXP' then OITM.LastPurPrc * @TC_MXP end) - ITM1.Price) / ITM1.Price) * 100 as decimal(16,1)) AS INCRE
	from OITM
	inner join ITM1 on ITM1.ItemCode = OITM.ItemCode and ITM1.PriceList = 7
	where (ITM1.Price + 0.1) < (Case When OITM.LastPurCur = 'USD' then OITM.LastPurPrc * @TC_USD  
	When OITM.LastPurCur = 'CAN' then OITM.LastPurPrc * @TC_CAN
	When OITM.LastPurCur = 'EUR' then OITM.LastPurPrc * @TC_EUR
	When OITM.LastPurCur = 'MXP' then OITM.LastPurPrc * @TC_MXP end) 
	and OITM.OnHand > 0 and OITM.U_TipoMat = 'MP'  
	and OITM.FrozenFor = 'N'
	order by ( Cast((((Case When OITM.LastPurCur = 'USD' then OITM.LastPurPrc * @TC_USD  
				 When OITM.LastPurCur = 'CAN' then OITM.LastPurPrc * @TC_CAN
				 When OITM.LastPurCur = 'EUR' then OITM.LastPurPrc * @TC_EUR
				 When OITM.LastPurCur = 'MXP' then OITM.LastPurPrc * @TC_MXP end) - ITM1.Price) / ITM1.Price) * 100 as decimal(16,1))
	) desc, OITM.ItemName

	*/

/* ================================================================================================
|    EXCEPCIONES COSTOS PARA REVALORIZAR.                                                          |
================================================================================================= */

-- Asignar COSTO ESTANDAR, Realizar Revalorizar Articulos Cero ESTANDAR.
Select OITM.ItemCode AS REP_051
	, OITM.ItemName AS NOMBRE
	, OITM.InvntryUom as UDM
	, OITM.OnHand AS EXISTENCIA 
	, Cast(Cast(OITM.AvgPrice as decimal(16,4)) as varchar) + ' MXP' AS ESTANDAR
	, Cast(Cast(ITM1.Price as decimal(16,4)) as varchar) + ' MXP' AS PRECIO_10
	, OITM.DfltWH AS ALMACEN
	, '501-200-000' AS C_AUMENTA	
	, '501-200-000' AS C_DISMINUYE	
From OITM 
Inner JOIN ITM1 on OITM.ItemCode=ITM1.ItemCode and ITM1.PriceList=10
Where OITM.AvgPrice = 0 and OITM.EvalSystem = 'S' and ITM1.Price <> 0 
and OITM.InvntItem = 'Y' and  OITM.frozenFor = 'N'
Order By OITM.ItemName 

-- Usar Revalorizacion de Inventarios. MP sin Existencia.
Select OITM.ItemCode AS REP_053
	, OITM.ItemName AS NOMBRE
	, OITM.InvntryUom as UDM
	, OITM.OnHand AS EXISTENCIA 
	, Cast(Cast(OITM.AvgPrice as decimal(16,4)) as varchar) + ' MXP' AS ESTANDAR
	, Cast(Cast(ITM1.Price as decimal(16,4)) as varchar) + ' MXP' AS PRECIO_10
	, OITM.DfltWH AS ALMACEN
	, '501-200-000' AS C_AUMENTA	
	, '501-200-000' AS C_DISMINUYE	
From OITM 
INNER JOIN ITM1 on OITM.ItemCode=ITM1.ItemCode and ITM1.PriceList=10
Where Cast(OITM.AvgPrice as decimal(16,4)) <> Cast(ITM1.Price as decimal(16,4)) 
and OITM.InvntItem = 'Y' and OITM.U_TipoMat = 'MP' and OITM.AvgPrice > 0 and OITM.OnHand = 0 and  OITM.frozenFor = 'N'
Order By OITM.ItemName 

-- Usar Revalorizacion de Inventarios. MP sin Existencia.
Select --'415 REVAL. MP c/e' AS REPORTE_415
	 OITM.ItemCode AS RE_055
	, OITM.ItemName AS NOMBRE
	, OITM.InvntryUom as UDM
	, OITM.OnHand AS EXISTENCIA 
	, Cast(Cast(OITM.AvgPrice as decimal(16,4)) as varchar) + ' MXP' AS ESTANDAR
	, Cast(Cast(ITM1.Price as decimal(16,4)) as varchar) + ' MXP' AS PRECIO_10
	, OITM.DfltWH AS ALMACEN
	, '501-200-000' AS C_AUMENTA	
	, '501-200-000' AS C_DISMINUYE	
From OITM 
INNER JOIN ITM1 on OITM.ItemCode=ITM1.ItemCode and ITM1.PriceList=10
Where Cast(OITM.AvgPrice as decimal(16,4)) <> Cast(ITM1.Price as decimal(16,4)) 
and OITM.InvntItem = 'Y'  and  OITM.frozenFor = 'N'
and OITM.U_TipoMat = 'MP' 
and OITM.AvgPrice > 0 and OITM.OnHand > 0
Order By OITM.ItemName 

-- Usar Revalorizacion de Inventarios. SB diferente sin existencia.
-- 01/DIC/21 SUSPENDO HASTA VER QUE PASOS DA PABLO AL VER DIFERENCIAS.
-- 20/JUN/22 RETOMO PERO SOLO CUANDO LA DIFERENCIA SEA EN AUMENTO Y SIN EXISTENCIA
Select OITM.ItemCode AS REP_057
	, OITM.ItemName AS NOMBRE
	, OITM.InvntryUom as UDM
	, OITM.OnHand AS EXISTENCIA 
	, Cast(Cast(OITM.AvgPrice as decimal(16,4)) as varchar) + ' MXP' AS ESTANDAR
	, Cast(Cast(ITM1.Price as decimal(16,4)) as varchar) + ' MXP' AS PRECIO_10
	, OITM.DfltWH AS ALMACEN
	, '501-200-000' AS C_AUMENTA	
	, '501-200-000' AS C_DISMINUYE	
From OITM 
INNER JOIN ITM1 on OITM.ItemCode=ITM1.ItemCode and ITM1.PriceList=10
Where Cast(OITM.AvgPrice as decimal(16,4)) < Cast(ITM1.Price as decimal(16,4)) 
and OITM.InvntItem = 'Y' and OITM.AvgPrice > 0 and OITM.OnHand = 0
and OITM.U_TipoMat <> 'MP' and OITM.U_TipoMat <> 'PT' and  OITM.frozenFor = 'N'
Order By OITM.ItemName 

-- Usar Revalorizacion de Inventarios. PT diferente sin existencia.
-- 01/DIC/21 SUSPENDO HASTA VER QUE PASOS DA PABLO AL VER DIFERENCIAS.
Select OITM.ItemCode AS REP_059
	, OITM.ItemName AS NOMBRE
	, OITM.InvntryUom as UDM
	, OITM.OnHand AS EXISTENCIA 
	, Cast(Cast(OITM.AvgPrice as decimal(16,4)) as varchar) + ' MXP' AS ESTANDAR
	, Cast(Cast(ITM1.Price as decimal(16,4)) as varchar) + ' MXP' AS PRECIO_10
	, OITM.DfltWH AS ALMACEN
	, '501-200-000' AS C_AUMENTA	
	, '501-200-000' AS C_DISMINUYE	
From OITM 
INNER JOIN ITM1 on OITM.ItemCode=ITM1.ItemCode and ITM1.PriceList=10
Where Cast(OITM.AvgPrice as decimal(16,4)) < Cast(ITM1.Price as decimal(16,4)) 
and OITM.InvntItem = 'Y' and OITM.AvgPrice > 0 
and OITM.U_TipoMat = 'PT' and OITM.OnHand = 0 and  OITM.frozenFor = 'N'
Order By OITM.ItemName 

-- Articulos Pendientes por Inactivar que aun tienen Existencia
-- Al 12/Agosto/2022 Quedan 539 Articulos.
/*
	Select	'431 PENDIENTES POR INHABILITAR' AS REPO_431, 
					OITM.ItemCode AS CODIGO,
					OITM.ItemName AS DESCRIPCION,
					OITM.U_TipoMat AS TM,
					OITM.U_Linea AS LINE,
					OITM.OnHand AS EXI_TOTAL,
					L10.Price as L_10,
					OITM.LastPurPrc AS U_COMP,
					OITM.LastPurCur AS U_MON
		from ITM1 L10
		inner join OITM on L10.ItemCode = OITM.ItemCode and L10.PriceList=10
		where OITM.ItemCode like '%ZIN%' and frozenFor = 'N'
		and (OITM.OnHand + OITM.OnOrder + OITM.IsCommited > 0)
		Order By OITM.ItemName
*/


-- Estas dos refacciones las cargaron a LDM, cambia MP y modifique directo Metodo a S
	-- Tenian EvalSystem = 'A'
	-- 14 DE Mayo segun yo afecta si hubiera Entras pendientes a Pasivo.

		--Update OITM set EvalSystem = 'S' Where OITM.ItemCode = '18734'
		--Update OITM set EvalSystem = 'S' Where OITM.ItemCode = '50189'
		
	-- Refacciones deben tener metodo Promedios.
	-- NO PROCEDE POR QUE SE METIO LOS CONSUMIBLES (MP todo lo de sistemas, y dejaron de usar)
	-- DE SISTEMAS COMO ESTANDAR.
		--select OITM.ItemCode as Codigo, OITM.ItemName as Nombre,
		--OITM.AvgPrice as Costo, OITM.OnHand as Existencia, OITM.EvalSystem
		--from OITM 
		--where OITM.EvalSystem <> 'A' and OITM.U_TipoMat = 'RF'
		--order by OITM.ItemName	
	

	-- Comprobar que no se tiene Costo en Lista 9 A COMPRAS para los PT.
	-- nO MOVER HASTA DEFINIR QUE SE HACE 
		--Select OITM.ItemCode, OITM.ItemName, OITM.OnHand, OITM.EvalSystem, OITM.AvgPrice, ITM1.Price, ITM1.Currency
		--from ITM1
		--inner join OITM on OITM.ItemCode = ITM1.ItemCode and ITM1.PriceList = 9
		--where OITM.U_TipoMat ='PT' and ITM1.Price <> 0
		--order by OITM.ItemName		
		
-- ASIGNA NUEVOS COSTOS A LOS ARTICULOS (avprice y lista 10).
	--Asignar Costo Calculado a PT articulos SIN EXISTENCIA.
	--Ya no realizar sacar Inventarios para Mary con Lista 1
		/*Select OITM.ItemCode, OITM.ItemName, OITM.OnHand, OITM.EvalSystem, OITM.OnHand,
		OITM.AvgPrice as Costo, L10.Price as Pre_10, L1.Price as Pre_CAL
		from ITM1 L10
		inner join OITM on OITM.ItemCode = L10.ItemCode and L10.PriceList = 10
		inner join ITM1 L1 on L10.ItemCode = L1.ItemCode and L1.PriceList = 1 
		where OITM.U_TipoMat ='PT' and OITM.OnHand = 0 and OITM.AvgPrice <> L1.Price
		order by OITM.ItemName
					
		UPDATE L10 SET Price = L1.Price , Currency = 'MXP'
		from ITM1 L10
		inner join OITM on OITM.ItemCode = L10.ItemCode and L10.PriceList = 10
		inner join ITM1 L1 on L10.ItemCode = L1.ItemCode and L1.PriceList = 1 
		where OITM.U_TipoMat ='PT' and OITM.OnHand = 0 and OITM.AvgPrice <> L1.Price

		UPDATE OITM SET AvgPrice = L1.Price 
		from ITM1 L10
		inner join OITM on OITM.ItemCode = L10.ItemCode and L10.PriceList = 10
		inner join ITM1 L1 on L10.ItemCode = L1.ItemCode and L1.PriceList = 1 
		where OITM.U_TipoMat ='PT' and OITM.OnHand = 0 and OITM.AvgPrice <> L1.Price

	--Asignar Costo Calculado a SUB-PRODUCTOS articulos SIN EXISTENCIA.
		Select OITM.ItemCode, OITM.ItemName, OITM.OnHand, OITM.EvalSystem, OITM.OnHand,
		OITM.AvgPrice as Costo, L10.Price as Pre_10, L1.Price as Pre_CAL
		from ITM1 L10
		inner join OITM on OITM.ItemCode = L10.ItemCode and L10.PriceList = 10
		inner join ITM1 L1 on L10.ItemCode = L1.ItemCode and L1.PriceList = 1 
		where (OITM.QryGroup29 = 'Y' or OITM.QryGroup30 = 'Y' or OITM.QryGroup31 = 'Y'
		or OITM.QryGroup32 = 'Y') and OITM.OnHand = 0 and OITM.AvgPrice <> L1.Price
		order by OITM.ItemName
		
			
		UPDATE L10 SET Price = L1.Price , Currency = 'MXP'
		from ITM1 L10
		inner join OITM on OITM.ItemCode = L10.ItemCode and L10.PriceList = 10
		inner join ITM1 L1 on L10.ItemCode = L1.ItemCode and L1.PriceList = 1 
		where (OITM.QryGroup29 = 'Y' or OITM.QryGroup30 = 'Y' or OITM.QryGroup31 = 'Y'
		or OITM.QryGroup32 = 'Y') and OITM.OnHand = 0 and OITM.AvgPrice <> L1.Price

		UPDATE OITM SET AvgPrice = L1.Price 
		from ITM1 L10
		inner join OITM on OITM.ItemCode = L10.ItemCode and L10.PriceList = 10
		inner join ITM1 L1 on L10.ItemCode = L1.ItemCode and L1.PriceList = 1 
		where (OITM.QryGroup29 = 'Y' or OITM.QryGroup30 = 'Y' or OITM.QryGroup31 = 'Y'
		or OITM.QryGroup32 = 'Y') and OITM.OnHand = 0 and OITM.AvgPrice <> L1.Price	
		
		
	--Asignar Costo Calculado a Materias Primas articulos SIN EXISTENCIA.
		Select OITM.ItemCode, OITM.ItemName, OITM.OnHand, OITM.EvalSystem, OITM.OnHand,
		OITM.AvgPrice as Costo, L10.Price as Pre_10, L1.Price as Pre_CAL
		from ITM1 L10
		inner join OITM on OITM.ItemCode = L10.ItemCode and L10.PriceList = 10
		inner join ITM1 L1 on L10.ItemCode = L1.ItemCode and L1.PriceList = 1 
		where OITM.U_TipoMat ='MP' and OITM.OnHand = 0 and OITM.AvgPrice <> L1.Price
		order by OITM.ItemName
			
		UPDATE L10 SET Price = L1.Price , Currency = 'MXP'
		from ITM1 L10
		inner join OITM on OITM.ItemCode = L10.ItemCode and L10.PriceList = 10
		inner join ITM1 L1 on L10.ItemCode = L1.ItemCode and L1.PriceList = 1 
		where OITM.U_TipoMat ='MP' and OITM.OnHand = 0 and OITM.AvgPrice <> L1.Price

		UPDATE OITM SET AvgPrice = L1.Price 
		from ITM1 L10
		inner join OITM on OITM.ItemCode = L10.ItemCode and L10.PriceList = 10
		inner join ITM1 L1 on L10.ItemCode = L1.ItemCode and L1.PriceList = 1 
		where OITM.U_TipoMat ='MP' and OITM.OnHand = 0 and OITM.AvgPrice <> L1.Price
		*/
	
	--LISTA PRECIOS DE CALCULO DE COSTO ESTANDAR // NUNCA QUISO CORREGIR MARCOS.
	--Para Lista de Calculo de Costo Estandar no debe ser nulo o cero.
		--Select '255 ? CEROS CALCULO ESTANDAR' AS REPORTE, ITM1.ItemCode, OITM.ItemName, OITM.AvgPrice, 
		--OITM.OnHand, OITM.EvalSystem,
		--L01.Price as Pre_CAL, L01.Currency as Mon_CAL, ITM1.Price as Pre_VEN, ITM1.Currency as Mon_VEN 
		--from ITM1
		--inner join OITM on OITM.ItemCode = ITM1.ItemCode and ITM1.PriceList = 1
		--inner join ITM1 L01 on ITM1.ItemCode = L01.ItemCode and L01.PriceList = 1
		--where L01.Price = 0 and OITM.U_IsModel = 'N'
		--.InvntItem='Y' 	
		--and (OITM.U_TipoMat ='MP' or OITM.U_TipoMat ='RF')and OITM.QryGroup29 = 'N'and OITM.QryGroup30 = 'N'
		--and OITM.QryGroup31 = 'N' and OITM.QryGroup32 = 'N' and L01.Price * 2 <> ITM1.Price
		--order by OITM.ItemName	


	
-- Hule Espuma de Preparado con contraparte de Cojineria dejas Conto a $ 0.0001
-- Ya no uso porque se estan cargando costos reales.
--Select	OITM.ItemCode AS CODIGO,
--		OITM.ItemName AS DESCRIPCION,
--		OITM.InvntryUom AS UM,
--		OITM.U_TipoMat AS TM,
--		OITM.U_Linea AS LINE,				
--		OITM.AvgPrice AS ESTANDAR,
--		ITM1.Price as L_10,
--		ISNULL((Select	SUM(ITT1.Quantity * ITT1.Price) From ITT1 
--		where  ITT1.Father = OITM.ItemCode ),0) AS P_LDM,
--		ISNULL(Case When OITM.LastPurCur = 'USD' then OITM.LastPurPrc * 20  
--			When OITM.LastPurCur = 'CAN' then OITM.LastPurPrc * 16
--			When OITM.LastPurCur = 'EUR' then OITM.LastPurPrc * 24
--			When OITM.LastPurCur = 'MXP' then OITM.LastPurPrc * 1 end,0) AS P_UCOM,
--		OITM.LastPurPrc AS U_COMP,
--		ISNULL(OITM.LastPurCur,'MXP') AS U_MON,	
--		Cast(OITM.LastPurDat AS DATE) AS F_UC,
--		OITM.OnHand AS EXIS, 
--		OITM.IsCommited AS COMP,
--		OITM.OnOrder AS INORD
--from OITM
--inner join ITM1 on ITM1.ItemCode = OITM.ItemCode and ITM1.PriceList=10
--where OITM.FrozenFor = 'N'
--and OITM.InvntItem = 'Y'
--and OITM.U_CodAnt <> 'NOUSA'
--and OITM.AvgPrice > 0.0001
--and OITM.OnHand = 0
--and OITM.QryGroup2 = 'Y'


-- Articulos no Inventariables sin Costo Estandar, Poner mismo que estandar.
-- Ficha Datos de Inventarios, 210901 Determine que no es necesario ya que no se utilizan 
-- Movimientos en esto articulos.
/*
Select	'999 SIN E$T PT NO INV.' AS REPORTE
		, OITM.ItemCode AS CODIGO
		, OITM.ItemName AS DESCRIPCION
		, OITM.InvntryUom AS UM
		, ITM1.Price AS PRE_STD
		, ITM1.Currency AS MON_STD
From OITM
inner join ITM1 on ITM1.ItemCode = OITM.ItemCode and ITM1.PriceList=10
Where OITM.AvgPrice = 0 AND OITM.InvntItem = 'N'  AND OITM.frozenFor = 'N'  
Order By OITM.ItemName
*/


/*
-- Coste de Hule Espuma de acuerdo al peso a Costo de xx. USD
Select	'999 CAL COSTO HULE KG. ' AS REPORTE
		, OITM.ItemCode AS CODIGO
		, OITM.ItemName AS DESCRIPCION
		, OITM.InvntryUom AS UM
		, Cast(OITM.LastPurPrc as decimal(16,4)) AS U_COMP
		, ISNULL(OITM.LastPurCur,'MXP') AS U_MON
		, Cast(OITM.LastPurDat AS DATE) AS F_UC
		, OITM.OnHand AS EXIS 
		, OITM.SWeight1 AS PESO
		, Cast((OITM.LastPurPrc/OITM.SWeight1) as decimal(16,4)) AS UNI_USD
From OITM
inner join ITM1 on ITM1.ItemCode = OITM.ItemCode and ITM1.PriceList=10
Where OITM.SWeight1 > 0 and OITM.LastPurPrc > 0 
Order By OITM.ItemName
*/

--< EOF > EXCEPCIONES COSTOS Y MANEJO DE LISTA DE PRECIOS.


