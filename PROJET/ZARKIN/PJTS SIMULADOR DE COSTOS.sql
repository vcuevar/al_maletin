-- Consultas para Simulador de COSTOS.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Viernes 13 de Agosto del 2021; Origen.

-- ================================================================================================
-- |              Variables a Manejar.                                                            |
-- ================================================================================================
Declare @CodeMode nvarchar(10)
Declare @NumeList integer 
Declare @TiCa_CAN decimal(10,4)
Declare @TiCa_USD decimal(10,4)
Declare @TiCa_EUR decimal(10,4)

--Set @CodeMode = 3704
Set @TiCa_CAN = (Select top(1) TC_can from SIZ_TipoCambio Order by TC_date DESC)
Set @TiCa_USD = (Select top(1) TC_usd from SIZ_TipoCambio Order by TC_date DESC)
Set @TiCa_EUR = (Select top(1) TC_eur from SIZ_TipoCambio Order by TC_date DESC)

-- Lista de Preios a Efectuar el RollOut solo procede para la 
Set @NumeList = 7 -- = 7 Pruebas por Sistemas (COSTOS) (Usuario 777)
--Set @NumeList = 1 -- Calculo de Diseño   (Usuario 1)
--Set @NumeList = 9 -- A_COMPRAS            (Usuario 2) 

-- ================================================================================================
-- |              Primer Pantalla Resumen de Modelos.                                             |
-- ================================================================================================
/*
SELECT OITM.ItemCode 
		, OITM.ItemName AS MODELO
FROM OITM 
WHERE OITM.U_IsModel = 'S' and OITM.frozenFor='N'
ORDER BY OITM.ItemName	
*/
-- Para el manejo de modelos que no se quieran ver se pondra como INACTIVO el MODELO.

-- ================================================================================================
-- |              Segunda Pantalla Resumen por Composicion y Categoria de Piel.                   |
-- ================================================================================================

-- Determinar los codigo a manejar
/*
Select OITM.ItemCode, OITM.ItemName, ITT1.Quantity
From OITM
inner join ITT1 on OITM.ItemCode = ITT1.Father  
inner join OITM A1 on ITT1.Code = A1.ItemCode and A1.ItemCode = '12826'
Where OITM.ItemCode like '3704-%' --and OITM.ItmsGrpCod = 113
*/
-- ================================================================================================
-- |              Tercer Pantalla Resumen por Composicion una sola Piel Cat. 3 (0301)             |
-- |     Aqui es donce se jugaria con las variables para la estructura de estas Compociciones.    |
-- ================================================================================================
/*
SELECT SC.COMPONENTE, SC.DESCRIPCION, MAX(SC.PC03) AS PC03, MAX(SC.PC04) AS PC04
, MAX(SC.PC05) AS PC05, MAX(SC.PC06) AS PC06, MAX(SC.PC07) AS PC07, MAX(SC.PC08) AS PC08, MAX(SC.OTROS) AS OTRO, SC.MONEDA, 
COUNT(SC.CATEGORIA) AS AGRUPADOS
FROM (
SELECT  Left(ITT1.Father, 7) AS COMPONENTE
		, Case When Left(Right(ITT1.Father, 5),2) = 'P0' then Left(Right(ITT1.Father, 5),2) else 'B0' END AS CATEGORIA
		, ITT1.Father AS CODIGO
		, A3.FrgnName AS DESCRIPCION
		, Case When Left(Right(ITT1.Father, 5),3) = 'P03' then SUM(ITT1.Quantity * L1.Price * 
			(Case When ITT1.Currency = 'USD' then @TiCa_USD When ITT1.Currency = 'CAN' then @TiCa_CAN When ITT1.Currency = 'EUR' 
			then @TiCa_EUR When ITT1.Currency = 'MXP' then  1 end)) ELSE 0 END AS PC03
		, Case When Left(Right(ITT1.Father, 5),3) = 'P04' then SUM(ITT1.Quantity * L1.Price * 
			(Case When ITT1.Currency = 'USD' then @TiCa_USD When ITT1.Currency = 'CAN' then @TiCa_CAN When ITT1.Currency = 'EUR' 
			then @TiCa_EUR When ITT1.Currency = 'MXP' then  1 end)) ELSE 0 END AS PC04
		, Case When Left(Right(ITT1.Father, 5),3) = 'P05' then SUM(ITTITT11.Quantity * L1.Price * 
			(Case When ITT1.Currency = 'USD' then @TiCa_USD When ITT1.Currency = 'CAN' then @TiCa_CAN When ITT1.Currency = 'EUR' 
			then @TiCa_EUR When ITT1.Currency = 'MXP' then  1 end)) ELSE 0 END AS PC05
		, Case When Left(Right(ITT1.Father, 5),3) = 'P06' then SUM(.Quantity * L1.Price * 
			(Case When ITT1.Currency = 'USD' then @TiCa_USD When ITT1.Currency = 'CAN' then @TiCa_CAN When ITT1.Currency = 'EUR' 
			then @TiCa_EUR When ITT1.Currency = 'MXP' then  1 end)) ELSE 0 END AS PC06
		, Case When Left(Right(ITT1.Father, 5),3) = 'P07' then SUM(ITT1.Quantity * L1.Price * 
			(Case When ITT1.Currency = 'USD' then @TiCa_USD When ITT1.Currency = 'CAN' then @TiCa_CAN When ITT1.Currency = 'EUR' 
			then @TiCa_EUR When ITT1.Currency = 'MXP' then  1 end)) ELSE 0 END AS PC07
		, Case When Left(Right(ITT1.Father, 5),3) = 'P08' then SUM(ITT1.Quantity * L1.Price * 
			(Case When ITT1.Currency = 'USD' then @TiCa_USD When ITT1.Currency = 'CAN' then @TiCa_CAN When ITT1.Currency = 'EUR' 
			then @TiCa_EUR When ITT1.Currency = 'MXP' then  1 end)) ELSE 0 END AS PC08
		, Case When Left(Right(ITT1.Father, 5),2) <> 'P0' then SUM(ITT1.Quantity * L1.Price * 
			(Case When ITT1.Currency = 'USD' then @TiCa_USD When ITT1.Currency = 'CAN' then @TiCa_CAN When ITT1.Currency = 'EUR' 
			then @TiCa_EUR When ITT1.Currency = 'MXP' then  1 end)) ELSE 0 END AS OTROS
		, 'MXP' AS MONEDA	
FROM ITT1 
INNER JOIN OITM A3 on ITT1.Father = A3.ItemCode
INNER JOIN ITM1 L1 on ITT1.Code= L1.ItemCode and L1.PriceList=1 
WHERE A3.InvntItem = 'Y' and A3.frozenFor='N' and A3.U_TipoMat = 'PT' 
and A3.U_IsModel = 'N'
and left(ITT1.Father,4) = @CodeMode
GROUP BY ITT1.Father, A3.FrgnName, ITT1.Currency
) SC
GROUP BY SC.COMPONENTE, SC.DESCRIPCION, SC.MONEDA
ORDER BY SC.DESCRIPCION	
*/

-- ================================================================================================
-- | Cuarta Pantalla Todas las Composiciones identificar las que brincan, por categoria de Piel.  |
-- ================================================================================================
/*
SELECT  ITT1.Father AS CODIGO
		, A3.ItemName AS DESCRIPCION		 
		, Case When Left(Right(ITT1.Father, 5),3) = 'P03' then SUM(ITT1.Quantity * L1.Price * 
			(Case When ITT1.Currency = 'USD' then @TiCa_USD When ITT1.Currency = 'CAN' then @TiCa_CAN When ITT1.Currency = 'EUR' 
			then @TiCa_EUR When ITT1.Currency = 'MXP' then  1 end)) ELSE 0 END AS PC03
		, Case When Left(Right(ITT1.Father, 5),3) = 'P04' then SUM(ITT1.Quantity * L1.Price * 
			(Case When ITT1.Currency = 'USD' then @TiCa_USD When ITT1.Currency = 'CAN' then @TiCa_CAN When ITT1.Currency = 'EUR' 
			then @TiCa_EUR When ITT1.Currency = 'MXP' then  1 end)) ELSE 0 END AS PC04
		, Case When Left(Right(ITT1.Father, 5),3) = 'P05' then SUM(ITT1.Quantity * L1.Price * 
			(Case When ITT1.Currency = 'USD' then @TiCa_USD When ITT1.Currency = 'CAN' then @TiCa_CAN When ITT1.Currency = 'EUR' 
			then @TiCa_EUR When ITT1.Currency = 'MXP' then  1 end)) ELSE 0 END AS PC05
		, Case When Left(Right(ITT1.Father, 5),3) = 'P06' then SUM(ITT1.Quantity * L1.Price * 
			(Case When ITT1.Currency = 'USD' then @TiCa_USD When ITT1.Currency = 'CAN' then @TiCa_CAN When ITT1.Currency = 'EUR' 
			then @TiCa_EUR When ITT1.Currency = 'MXP' then  1 end)) ELSE 0 END AS PC06
		, Case When Left(Right(ITT1.Father, 5),3) = 'P07' then SUM(ITT1.Quantity * L1.Price * 
			(Case When ITT1.Currency = 'USD' then @TiCa_USD When ITT1.Currency = 'CAN' then @TiCa_CAN When ITT1.Currency = 'EUR' 
			then @TiCa_EUR When ITT1.Currency = 'MXP' then  1 end)) ELSE 0 END AS PC07
		, Case When Left(Right(ITT1.Father, 5),3) = 'P08' then SUM(ITT1.Quantity * L1.Price * 
			(Case When ITT1.Currency = 'USD' then @TiCa_USD When ITT1.Currency = 'CAN' then @TiCa_CAN When ITT1.Currency = 'EUR' 
			then @TiCa_EUR When ITT1.Currency = 'MXP' then  1 end)) ELSE 0 END AS PC08
		, Case When Left(Right(ITT1.Father, 5),2) <> 'P0' then SUM(ITT1.Quantity * L1.Price * 
			(Case When ITT1.Currency = 'USD' then @TiCa_USD When ITT1.Currency = 'CAN' then @TiCa_CAN When ITT1.Currency = 'EUR' 
			then @TiCa_EUR When ITT1.Currency = 'MXP' then  1 end)) ELSE 0 END AS OTROS
		, 'MXP' AS MONEDA
FROM ITT1 
INNER JOIN OITM A3 on ITT1.Father = A3.ItemCode
INNER JOIN ITM1 L1 on ITT1.Code= L1.ItemCode and L1.PriceList=1 
WHERE A3.InvntItem = 'Y' and A3.frozenFor='N' and A3.U_TipoMat = 'PT' 
and A3.U_IsModel = 'N'
and left(ITT1.Father,4) = @CodeMode
GROUP BY ITT1.Father, A3.ItemName, ITT1.Currency
ORDER BY Left(A3.ItemName, 14), Left(Right(ITT1.Father, 5),3)
*/

-- ================================================================================================
-- |              Generar Informacion para la Simulacion del Costo.                               |
-- ================================================================================================

-- Generar Tabla de la informacion, para manipular y simulacion Costos.
/*
Select OITM.ItemCode
		, OITM.ItemName 
		, A1.ItemCode
		, A1.ItemName
		, A1.InvntryUom
		, ITT1.Quantity
		, L1.Price
		, L1.Currency
		, A1.ItmsGrpCod
		, A1.U_GrupoPlanea
		, A1.U_SubModelo
From OITM
inner join ITT1 on OITM.ItemCode = ITT1.Father  
inner join OITM A1 on ITT1.Code = A1.ItemCode 
inner join ITM1 L1 on A1.ItemCode = L1.ItemCode and L1.PriceList = 1 
Where (A1.QryGroup29 = 'N' and A1.QryGroup30 = 'N' and A1.QryGroup31 = 'N' and A1.QryGroup32 = 'N')
-- AND OITM.ItemCode = '3704-01-P0301'
-- AND OITM.ItemCode = '370401'
AND OITM.ItemCode = '370401-H'

*/

-- ================================================================================================
-- |              ROLLOUT Ejercicio para SIMULADOR DE COSTOS.                                     |
-- ================================================================================================

-- Generar Tabla de prueba realizando copia de la lista de Precios con la que se va ha trabajar.

--Cambio al ROLLOUT:
--Articulos Activos

--     1) Propiedad 30 Habilitados
Select LPNEW.* FROM(
Select OITM.ItemCode AS CONSULTA_1
		, OITM.ItemName 
		, OITM.InvntryUom
		, Cast(LA3.Price as decimal(16,2)) AS PRE_LA3
		, LA3.Currency
		, @NumeList AS LDP
		, Cast(SUM(ITT1.Quantity * LA1.Price *(Case When ITT1.Currency = 'USD' then @TiCa_USD 
								When ITT1.Currency = 'CAN' then @TiCa_CAN 
								When ITT1.Currency = 'EUR' then @TiCa_EUR 
								When ITT1.Currency = 'MXP' then  1 end)) as decimal(16,2)) AS PRICE_MXP
		-- Nota : A este precio hay que hacer la comparacion si la moneda del Articulo es diferente de
		-- MXP entonces se convierte a la moneda correspondiente dividiendo con el mismo factor de conversion
		-- que corresponda a la moneda.
		, 'MXP' AS MONEDA
		, 'POR ACTUALIZAR' AS ACCION
From OITM
inner join ITT1 on OITM.ItemCode = ITT1.Father  
inner join OITM A1 on ITT1.Code = A1.ItemCode 
inner join ITM1 LA1 on A1.ItemCode = LA1.ItemCode and LA1.PriceList = @NumeList
inner join ITM1 LA3 on OITM.ItemCode = LA3.ItemCode and LA3.PriceList = @NumeList
Where OITM.QryGroup30 = 'Y' AND OITM.frozenFor = 'N'
Group By OITM.ItemCode, OITM.ItemName, LA3.Price, LA3.Currency, OITM.InvntryUom ) LPNEW
Where LPNEW.PRE_LA3 <> LPNEW.PRICE_MXP
Order By LPNEW.ItemName

 --     2) Propiedad 29  Cascos.
Select LPNEW.* FROM(
Select OITM.ItemCode AS CONSULTA_2
		, OITM.ItemName 
		, OITM.InvntryUom
		, Cast(LA3.Price as decimal(16,2)) AS PRE_LA3
		, LA3.Currency 
		, @NumeList AS LDP
		, Cast(SUM(ITT1.Quantity * LA1.Price *(Case When ITT1.Currency = 'USD' then @TiCa_USD 
								When ITT1.Currency = 'CAN' then @TiCa_CAN 
								When ITT1.Currency = 'EUR' then @TiCa_EUR 
								When ITT1.Currency = 'MXP' then  1 end)) as decimal(16,2)) AS PRICE_MXP
		, 'MXP' AS MONEDA
		, 'POR ACTUALIZAR' AS ACCION
From OITM
inner join ITT1 on OITM.ItemCode = ITT1.Father  
inner join OITM A1 on ITT1.Code = A1.ItemCode 
inner join ITM1 LA1 on A1.ItemCode = LA1.ItemCode and LA1.PriceList = @NumeList
inner join ITM1 LA3 on OITM.ItemCode = LA3.ItemCode and LA3.PriceList = @NumeList
Where OITM.QryGroup29 = 'Y' AND OITM.frozenFor = 'N'
Group By OITM.ItemCode, OITM.ItemName, LA3.Price, LA3.Currency, OITM.InvntryUom ) LPNEW
Where LPNEW.PRE_LA3 <> LPNEW.PRICE_MXP
Order By LPNEW.ItemName

 --     3) Propiedad 31 Patas y Bastiores.
Select LPNEW.* FROM(
Select OITM.ItemCode AS CONSULTA_3
		, OITM.ItemName 
		, OITM.InvntryUom
		, Cast(LA3.Price as decimal(16,2)) AS PRE_LA3
		, LA3.Currency 
		, @NumeList AS LDP
		, Cast(SUM(ITT1.Quantity * LA1.Price *(Case When ITT1.Currency = 'USD' then @TiCa_USD 
								When ITT1.Currency = 'CAN' then @TiCa_CAN 
								When ITT1.Currency = 'EUR' then @TiCa_EUR 
								When ITT1.Currency = 'MXP' then  1 end)) as decimal(16,2)) AS PRICE_MXP
		, 'MXP' AS MONEDA
		, 'POR ACTUALIZAR' AS ACCION
From OITM
inner join ITT1 on OITM.ItemCode = ITT1.Father  
inner join OITM A1 on ITT1.Code = A1.ItemCode 
inner join ITM1 LA1 on A1.ItemCode = LA1.ItemCode and LA1.PriceList = @NumeList
inner join ITM1 LA3 on OITM.ItemCode = LA3.ItemCode and LA3.PriceList = @NumeList
Where OITM.QryGroup31 = 'Y' AND OITM.frozenFor = 'N' and ITT1.Father = '16721'
Group By OITM.ItemCode, OITM.ItemName, LA3.Price, LA3.Currency, OITM.InvntryUom ) LPNEW
Where LPNEW.PRE_LA3 <> LPNEW.PRICE_MXP

Order By LPNEW.ItemName

--     4) Propiedad  32 + (Gpo Planea = 3 EMPAQUES o 28 EMP- MADERA)
Select LPNEW.* FROM(
Select OITM.ItemCode AS CONSULTA_4
		, OITM.ItemName 
		, OITM.InvntryUom
		, Cast(LA3.Price as decimal(16,2)) AS PRE_LA3 
		, LA3.Currency
		, @NumeList AS LDP
		, Cast(SUM(ITT1.Quantity * LA1.Price *(Case When ITT1.Currency = 'USD' then @TiCa_USD 
								When ITT1.Currency = 'CAN' then @TiCa_CAN 
								When ITT1.Currency = 'EUR' then @TiCa_EUR 
								When ITT1.Currency = 'MXP' then  1 end)) as decimal(16,2)) AS PRICE_MXP
		, 'MXP' AS MONEDA
		, 'POR ACTUALIZAR' AS ACCION
From OITM
inner join ITT1 on OITM.ItemCode = ITT1.Father  
inner join OITM A1 on ITT1.Code = A1.ItemCode 
inner join ITM1 LA1 on A1.ItemCode = LA1.ItemCode and LA1.PriceList = @NumeList
inner join ITM1 LA3 on OITM.ItemCode = LA3.ItemCode and LA3.PriceList = @NumeList
Where OITM.QryGroup32 = 'Y' AND OITM.frozenFor = 'N' AND (OITM.U_GrupoPlanea = '3' OR OITM.U_GrupoPlanea = '28') 
Group By OITM.ItemCode, OITM.ItemName, LA3.Price, LA3.Currency, OITM.InvntryUom ) LPNEW
Where LPNEW.PRE_LA3 <> LPNEW.PRICE_MXP
Order By LPNEW.ItemName

 --     5) Propiedad 32 + Gpo Planea <> 3 y 28 NO SEA EMPAQUE
Select LPNEW.* FROM(
Select OITM.ItemCode AS CONSULTA_5
		, OITM.ItemName 
		, OITM.InvntryUom
		, Cast(LA3.Price as decimal(16,2)) AS PRE_LA3
		, LA3.Currency 
		, @NumeList AS LDP
		, Cast(SUM(ITT1.Quantity * LA1.Price *(Case When ITT1.Currency = 'USD' then @TiCa_USD 
								When ITT1.Currency = 'CAN' then @TiCa_CAN 
								When ITT1.Currency = 'EUR' then @TiCa_EUR 
								When ITT1.Currency = 'MXP' then  1 end)) as decimal(16,2)) AS PRICE_MXP
		, 'MXP' AS MONEDA
		, 'POR ACTUALIZAR' AS ACCION
From OITM
inner join ITT1 on OITM.ItemCode = ITT1.Father  
inner join OITM A1 on ITT1.Code = A1.ItemCode 
inner join ITM1 LA1 on A1.ItemCode = LA1.ItemCode and LA1.PriceList = @NumeList
inner join ITM1 LA3 on OITM.ItemCode = LA3.ItemCode and LA3.PriceList = @NumeList
Where OITM.QryGroup32 = 'Y' AND OITM.frozenFor = 'N' AND (OITM.U_GrupoPlanea <> '3' and OITM.U_GrupoPlanea <> '28') 
Group By OITM.ItemCode, OITM.ItemName, LA3.Price, LA3.Currency, OITM.InvntryUom ) LPNEW
Where LPNEW.PRE_LA3 <> LPNEW.PRICE_MXP
Order By LPNEW.ItemName


--     6) Articulo PT + Inventariable
Select LPNEW.* FROM(
Select OITM.ItemCode AS CONSULTA_6
		, OITM.ItemName 
		, OITM.InvntryUom
		, Cast(LA3.Price as decimal(16,2)) AS PRE_LA3 
		, LA3.Currency
		, @NumeList AS LDP
		, Cast(SUM(ITT1.Quantity * LA1.Price *(Case When ITT1.Currency = 'USD' then @TiCa_USD 
								When ITT1.Currency = 'CAN' then @TiCa_CAN 
								When ITT1.Currency = 'EUR' then @TiCa_EUR 
								When ITT1.Currency = 'MXP' then  1 end)) as decimal(16,2)) AS PRICE_MXP
		, 'MXP' AS MONEDA
		, 'POR ACTUALIZAR' AS ACCION
From OITM
inner join ITT1 on OITM.ItemCode = ITT1.Father  
inner join OITM A1 on ITT1.Code = A1.ItemCode 
inner join ITM1 LA1 on A1.ItemCode = LA1.ItemCode and LA1.PriceList = @NumeList
inner join ITM1 LA3 on OITM.ItemCode = LA3.ItemCode and LA3.PriceList = @NumeList
Where OITM.U_TipoMat = 'PT' AND OITM.frozenFor = 'N' AND OITM.InvntItem = 'Y'
Group By OITM.ItemCode, OITM.ItemName, LA3.Price, LA3.Currency, OITM.InvntryUom ) LPNEW
Where LPNEW.PRE_LA3 <> LPNEW.PRICE_MXP
Order By LPNEW.ItemName


 --     7) Articulo PT + No Inventariable
Select LPNEW.* FROM(
Select OITM.ItemCode AS CONSULTA_7
		, OITM.ItemName 
		, OITM.InvntryUom
		, Cast(LA3.Price as decimal(16,2)) AS PRE_LA3 
		, LA3.Currency
		, @NumeList AS LDP
		, Cast(SUM(ITT1.Quantity * LA1.Price *(Case When ITT1.Currency = 'USD' then @TiCa_USD 
								When ITT1.Currency = 'CAN' then @TiCa_CAN 
								When ITT1.Currency = 'EUR' then @TiCa_EUR 
								When ITT1.Currency = 'MXP' then  1 end)) as decimal(16,2)) AS PRICE_MXP
		, 'MXP' AS MONEDA
		, 'POR ACTUALIZAR' AS ACCION
From OITM
inner join ITT1 on OITM.ItemCode = ITT1.Father  
inner join OITM A1 on ITT1.Code = A1.ItemCode 
inner join ITM1 LA1 on A1.ItemCode = LA1.ItemCode and LA1.PriceList = @NumeList
inner join ITM1 LA3 on OITM.ItemCode = LA3.ItemCode and LA3.PriceList = @NumeList
Where OITM.U_TipoMat = 'PT' AND OITM.frozenFor = 'N' AND OITM.InvntItem = 'N'
Group By OITM.ItemCode, OITM.ItemName, LA3.Price, LA3.Currency, OITM.InvntryUom ) LPNEW
Where LPNEW.PRE_LA3 <> LPNEW.PRICE_MXP
Order By LPNEW.ItemName

 --     8) Articulo RF
Select LPNEW.* FROM(
Select OITM.ItemCode AS CONSULTA_8
		, OITM.ItemName 
		, OITM.InvntryUom
		, Cast(LA3.Price as decimal(16,2)) AS PRE_LA3 
		, LA3.Currency
		, @NumeList AS LDP
		, Cast(SUM(ITT1.Quantity * LA1.Price *(Case When ITT1.Currency = 'USD' then @TiCa_USD 
								When ITT1.Currency = 'CAN' then @TiCa_CAN 
								When ITT1.Currency = 'EUR' then @TiCa_EUR 
								When ITT1.Currency = 'MXP' then  1 end)) as decimal(16,2)) AS PRICE_MXP
		, 'MXP' AS MONEDA
		, 'POR ACTUALIZAR' AS ACCION
From OITM
inner join ITT1 on OITM.ItemCode = ITT1.Father  
inner join OITM A1 on ITT1.Code = A1.ItemCode 
inner join ITM1 LA1 on A1.ItemCode = LA1.ItemCode and LA1.PriceList = @NumeList
inner join ITM1 LA3 on OITM.ItemCode = LA3.ItemCode and LA3.PriceList = @NumeList
Where OITM.U_TipoMat = 'RF' AND OITM.frozenFor = 'N' 
Group By OITM.ItemCode, OITM.ItemName, LA3.Price, LA3.Currency, OITM.InvntryUom ) LPNEW
Where LPNEW.PRE_LA3 <> LPNEW.PRICE_MXP
Order By LPNEW.ItemName

/*

-- ================================================================================================
-- |              Generar Informacion de la Lista de Precios.                                     |
-- ================================================================================================

-- Generar Lista de Precios

Select OITM.ItemCode
		, OITM.ItemName 
		, OITM.InvntryUom
		, Cast(L1.Price as decimal(16,4)) AS PREC_10
		, L1.Currency
		, OITM.U_TipoMat
		, OITM.U_GrupoPlanea
From OITM
inner join ITM1 L1 on OITM.ItemCode = L1.ItemCode and L1.PriceList = 10

*/

