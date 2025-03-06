-- EXCEPCIONES DE COSTOS Y MANEJO DE LISTA DE PRECIOS. 
-- OBJETIVO: Mantener al dia El costo Estandar y auditar las Listas de Precios.
-- Desarrollo: Ing. Vicente Cueva Ramírez.
-- Actualizado: Lunes 26 de Agosto del 2021; SAP-10, Quitar autocorrecion.
-- Actualizado: Martes 16 de Enero del 2024; Depurar.

/* ================================================================================================
|    EXCEPCIONES TIPO DE CAMBIO ASIGNADOS.                                                        |
================================================================================================= */

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
-- Actualizado Viernes 31 de enero del 2024; Reactivar revalirizacion de AvPrice.

/* Listas de Precio de SAP 
1	00 DISEÑO.				(Administra DISEÑO).
2	A - VENTAS GENERAL.		(2.5 del 10 ESTANDAR).
9	A - COMPRAS				(Administra nadie se utiliza 10 ESTANDAR).
7   PRUEBAS SISTEAS         (Administra SISTEMAS base comparativa con las compras 3 meses) 
10	10						(Administra SISTEMAS automatico sin existencia, revalirizacion con existencia)
*/

/* ============================================================================
|    EXCEPCIONES LISTA PRECIOS.                                               |
============================================================================ */

--	EX-DIS-005 Validar que los articulos modelos cuenten con Estandar de 0.0001 
		Select	'048 ? SIN ESTANDAR MODELO' AS REPORTE_048, 
				OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat,
				OITM.U_VS, OITM.AvgPrice
		from OITM
		where  OITM.U_IsModel = 'S' 
		and OITM.AvgPrice <> 0.0001
		order by OITM.ItemName

-- DETECTAR DIFERENTE MONEDA EN L10 COSTO ESTANDAR.
	Select	'050 ? PRECIOS<>MX' AS REPORTE_050, 
			OITM.ItemCode AS CODE, 
			OITM.ItemName AS DESCRIPCION,
			ITM1.Price AS L10, 
			ITM1.Currency AS MONEDA, 
			ITM1.PriceList AS LISTA 
	From ITM1 
	inner join OITM on ITM1.ItemCode = OITM.ItemCode AND ITM1.PriceList = 10
	where ITM1.Currency <> 'MXP' 

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
	, '501-500-000' AS C_AUMENTA	
	, '501-500-000' AS C_DISMINUYE	
From OITM 
Inner JOIN ITM1 on OITM.ItemCode=ITM1.ItemCode and ITM1.PriceList=10
Where OITM.AvgPrice = 0 and OITM.EvalSystem = 'S' and ITM1.Price <> 0 
and OITM.InvntItem = 'Y' and  OITM.frozenFor = 'N'
Order By OITM.ItemName 

-- Usar Revalorizacion de Inventarios. MP sin Existencia. Se dejo de usar como el 
-- 20 de Septiembre 2023, solo se deja lo que este con costo estandar cero, pero para Enero 2025 
-- vuelvo a retomar ya que el costo que se guarda en los recibo deproduccion es es AvPrice y no el de
-- la lista de precios.
-- Usar Revalorizacion de Inventarios. MP sin Existencia.
-- Reactivada 31/enero/2025 Por que se guarda historial recibos de produccion con AvPrice.
/*
Select OITM.ItemCode AS REP_053
	, OITM.ItemName AS NOMBRE
	, OITM.InvntryUom as UDM
	, OITM.OnHand AS EXISTENCIA 
	, Cast(Cast(OITM.AvgPrice as decimal(16,4)) as varchar) + ' MXP' AS ESTANDAR
	, Cast(Cast(ITM1.Price as decimal(16,4)) as varchar) + ' MXP' AS PRECIO_10
	, OITM.DfltWH AS ALMACEN
	, '501-500-000' AS C_AUMENTA	
	, '501-500-000' AS C_DISMINUYE	
From OITM 
INNER JOIN ITM1 on OITM.ItemCode=ITM1.ItemCode and ITM1.PriceList=10
Where Cast(OITM.AvgPrice as decimal(16,4)) <> Cast(ITM1.Price as decimal(16,4)) 
and OITM.InvntItem = 'Y' and OITM.U_TipoMat = 'MP' and OITM.AvgPrice > 0 and  OITM.frozenFor = 'N'
and OITM.OnHand = 0 
Order By OITM.ItemName 
*/

-- Usar Revalorizacion de Inventarios. SB diferente sin existencia.
-- 01/DIC/21 SUSPENDO HASTA VER QUE PASOS DA PABLO AL VER DIFERENCIAS.
-- 20/JUN/22 RETOMO PERO SOLO CUANDO LA DIFERENCIA SEA EN AUMENTO Y SIN EXISTENCIA
-- Reactivada 31/enero/2025 Por que se guarda historial recibos de produccion con AvPrice.
/*
Select OITM.ItemCode AS REP_057
	, OITM.ItemName AS NOMBRE
	, OITM.InvntryUom as UDM
	, OITM.OnHand AS EXISTENCIA 
	, Cast(Cast(OITM.AvgPrice as decimal(16,4)) as varchar) + ' MXP' AS ESTANDAR
	, Cast(Cast(ITM1.Price as decimal(16,4)) as varchar) + ' MXP' AS PRECIO_10
	, OITM.DfltWH AS ALMACEN
	, '501-500-000' AS C_AUMENTA	
	, '501-500-000' AS C_DISMINUYE	
From OITM 
INNER JOIN ITM1 on OITM.ItemCode=ITM1.ItemCode and ITM1.PriceList=10
Where Cast(OITM.AvgPrice as decimal(16,4)) < Cast(ITM1.Price as decimal(16,4)) 
and OITM.InvntItem = 'Y' and OITM.AvgPrice > 0 and OITM.OnHand = 0
and OITM.U_TipoMat <> 'MP' and OITM.U_TipoMat <> 'PT' and  OITM.frozenFor = 'N'
Order By OITM.ItemName 
*/
-- Usar Revalorizacion de Inventarios. PT diferente sin existencia.
-- 01/DIC/21 SUSPENDO HASTA VER QUE PASOS DA PABLO AL VER DIFERENCIAS.
-- Reactivada 31/enero/2025 Por que se guarda historial recibos de produccion con AvPrice.
/*
Select Top(200) OITM.ItemCode AS REP_059
	, OITM.ItemName AS NOMBRE
	, OITM.InvntryUom as UDM
	, OITM.OnHand AS EXISTENCIA 
	, Cast(Cast(OITM.AvgPrice as decimal(16,4)) as varchar) + ' MXP' AS ESTANDAR
	, Cast(Cast(ITM1.Price as decimal(16,4)) as varchar) + ' MXP' AS PRECIO_10
	, OITM.DfltWH AS ALMACEN
	, '501-500-000' AS C_AUMENTA	
	, '501-500-000' AS C_DISMINUYE	
From OITM 
INNER JOIN ITM1 on OITM.ItemCode=ITM1.ItemCode and ITM1.PriceList=10
Where Cast(OITM.AvgPrice as decimal(16,4)) <> Cast(ITM1.Price as decimal(16,4)) 
and OITM.InvntItem = 'Y' and OITM.AvgPrice > 0 
and OITM.U_TipoMat = 'PT' and OITM.OnHand = 0 and  OITM.frozenFor = 'N'
Order By OITM.ItemName 
*/
-- Usar Revalorizacion de Inventarios. Cambios de Estandar <> LP 10 con o sin Existencia.
-- Reactivada 31/enero/2025 Por que se guarda historial recibos de produccion con AvPrice.
Select OITM.ItemCode AS REP_060
	, OITM.ItemName AS NOMBRE
	, OITM.InvntryUom as UDM
	, OITM.OnHand AS EXISTENCIA 
	, Cast(Cast(OITM.AvgPrice as decimal(16,4)) as varchar) + ' MXP' AS ESTANDAR
	, Cast(Cast(ITM1.Price as decimal(16,4)) as varchar) + ' MXP' AS PRECIO_10
	, OITM.DfltWH AS ALMACEN
	, '501-500-000' AS C_AUMENTA	
	, '501-500-000' AS C_DISMINUYE	
From OITM 
INNER JOIN ITM1 on OITM.ItemCode=ITM1.ItemCode and ITM1.PriceList=10
Where Cast(OITM.AvgPrice as decimal(16,4)) <> Cast(ITM1.Price as decimal(16,4)) 
and OITM.InvntItem = 'Y' and OITM.AvgPrice > 0 and  OITM.frozenFor = 'N'
Order By OITM.ItemName 

-- Articulos Pendientes por Inactivar que aun tienen Existencia
-- Al 12/Agosto/2022 Quedan 539 Articulos.

Select	'61 PENDIENTES POR INHABILITAR' AS REPO_61, 
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
and (OITM.OnHand + OITM.OnOrder + OITM.IsCommited = 0)
Order By OITM.ItemName


/* ============================================================================
| EOF Excepciones de Costos.                                                  |
============================================================================ */


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


