-- Excepciones para Costos.
-- Dado que Finanzas no toma control sobre lista 10, Octubre del 2019, 
--a demas A_COMPRAS se desvirtuo y ya no se actualizo MP. hare mi parte.

-- Los materiales se controlan por Standar y se actualiza en la Lista 10,  
-- Diseño captura en primer instancia, despues se validara los materiales,
-- contra la ultima compra, se valida y se actualiza L_10.

-- Los Productos y Sub-Productos se integran con la sumatoria de los materiales,
-- sin incluir gastos indirectos ni mano de obra, solo materiales.

-- Para las monedas extranjeras se utilizaron los siguientes tipo de cambio:				
-- Estimación calculada para el 2020 en Octubre del 2019
--	USD	 $20.00 		DÓLAR U.S.A.
--	EUR	 $22.83 		EURO
--	CAN	 $15.14 		DÓLAR CANADIENSE

/* Listas de Precio de SAP 
1	CALCULO DISEÑO.			(Dejo de actualizar, A_COMPRAS no actualizada).
2	A - VENTAS GENERAL.		(Nunca se ha usado).
9	A - COMPRAS				(Administra y controla Mary Pardo).
10	10						(Diseño -> U_Compra)

Es importante correr la rutina de actulizar los costos primero subordinado y 
luego superiores hasta que no quede ninguno sin actualizar 
(preferentemente antes de correr el Excel de Costos y estas excepciones).

*/

-- AUDITORIA DE COSTOS
-- En LDM Cabecera debe ser Lista de Precios 10 -> COSTO ESTANDAR.
	Select	'035 ! CAB<>10' AS REPORTE,
			OITM.ItemCode AS CODE, 
			OITM.ItemName AS PRODUCTO, 
			OITM.U_TipoMat AS TIPO,
			OITM.OnHand AS EXIS, 
			OITM.IsCommited AS COMP,
			OITM.OnOrder AS INORD,
			ITM1.Price AS L10,
			OITM.AvgPrice AS STD,
			OITT.PriceList AS P_C_LDM		  
	from OITM
	inner join ITM1 on OITM.ItemCode= ITM1.ItemCode and ITM1.PriceList=10
	inner join OITT on OITM.ItemCode= OITT.Code
	where OITT.PriceList <> 10
							
	-- Para Corregir utilizar esta consulta 28 Julio 2016		
	update OITT set PriceList=10
	Where  OITT.PriceList <> 10 
	
-- En Lista de Materiales los materiales deben tener Lista de Precios 10 COSTO ESTANDAR.
	Select	'040 ! LDM<>10' AS REPORTE,
			oitm.ItemCode AS CODE, 
			ItemName AS PRODUCTO, 
			U_TipoMat AS TIPO,
			OITM.OnHand AS EXIS, 
			OITM.IsCommited AS COMP,
			OITM.OnOrder AS INORD,
			ITM1.Price AS L10,
			OITM.AvgPrice AS STD,
			ITT1.PriceList AS P_L_LDM
	from OITM
	inner join ITM1 on OITM.ItemCode= ITM1.ItemCode and ITM1.PriceList=10
	inner join ITT1 on OITM.ItemCode = ITT1.Father
	where ITT1.PriceList <> 10
			
	-- Para corregir diferencia de Lista Precios 10, usar esta consulta 17/ABR/2017
	--Update ITT1 Set ITT1.PriceList = 10, ITT1.Currency = 'MXP'
	--Where ITT1.PriceList <> 10
				
-- DETECTAR DIFERENTE MONEDA EN L10.
	Select	'045 ? PRECIOS<>MX' AS REPORTE, 
			OITM.ItemCode AS CODE, 
			OITM.ItemName AS DESCRIPCION,
			ITM1.Price AS L10, 
			ITM1.Currency AS MONEDA, 
			ITM1.PriceList AS LISTA 
	From ITM1 
	inner join OITM on ITM1.ItemCode = OITM.ItemCode AND ITM1.PriceList = 10
	where ITM1.Currency <> 'MXP' 
	
-- DETECTAR EN L10 SIN PRECIOS.
	SELECT	'050 ? PRECIO=0' AS REPORTE,
			ITM1.ItemCode AS CODE, 
			OITM.ItemName AS DESCRIPCION, 
			ITM1.PriceList AS L_P,
			ITM1.Price AS PRECIO
		FROM ITM1   
		INNER JOIN OITM ON ITM1.ItemCode = OITM.ItemCode 
		WHERE ITM1.PriceList = 10 and  ITM1.Price = 0

-- En LDM tener Moneda igual a MXP.
	Select	'055 ? MONEDA=MXP' AS REPORTE, 
			OITM.ItemCode AS CODE, 
			OITM.ItemName AS PRODUCTO, 
			OITM.U_TipoMat AS TIPO,
			OITM.OnHand AS EXIS, 
			OITM.IsCommited AS COMP,
			OITM.OnOrder AS INORD,
			ITM1.Price AS L10,
			OITM.AvgPrice AS STD,
			ITT1.Currency AS MON_LDM	
		from OITM
		inner join ITM1 on OITM.ItemCode= ITM1.ItemCode and ITM1.PriceList=10
		inner join ITT1 on OITM.ItemCode = ITT1.Father
		where ITT1.Currency <> 'MXP'
		
-- Igualar Precio en ITT1 (Detalle de LDM) al Precio L10 Estandar.
	Select	'060 ! ITT1 = L10' AS REPORTE,
			ITT1.Father AS PRODUCTO, 
			ITT1.Code AS MP,
			ITT1.Price AS P_LDM,
			ITT1.Currency AS MO_LDM, 
			ITM1.Price as L10, 
			ITM1.Currency as MON_10 
	From ITT1 
	inner join ITM1 on ITT1.Code = ITM1.ItemCode and ITM1.PriceList=10 
	where ITT1.Price <> ITM1.Price 

	-- Para corregir diferentes Precios en L1 y Lista de Materiales.
	Update ITT1 Set ITT1.Price = ITM1.Price, ITT1.Currency = 'MXP'
	From ITT1 
	inner join ITM1 on ITT1.Code = ITM1.ItemCode and ITM1.PriceList=10 
	where ITT1.Price <> ITM1.Price 
		
-- No debe contener Manos de Obra la Lista de Materiales quitar Codigo Tipo CG.
-- Esto se quito aproximadamentes en Septiembre del 2015
	Select '065 ? TIENE M.O. L.M.' AS REPORTE, A1.ItemCode, A1.ItemName, A1.U_TipoMat, A1.EvalSystem, A1.OnHand, A1.AvgPrice
	from ITT1
	inner join OITM A1 on ITT1.Code = A1.ItemCode
	where A1.U_TipoMat = 'CG'
		
-- En Ordenes Vigentes
	Select '070 ? TIENE M.O. O.P.' AS REPORTE, A1.ItemCode, A1.ItemName, A1.U_TipoMat, A1.EvalSystem, A1.OnHand, A1.AvgPrice
	from WOR1
	inner join OITM A1 on WOR1.ItemCode = A1.ItemCode
	inner join OWOR on WOR1.DocEntry = OWOR.DocEntry
	where A1.U_TipoMat = 'CG' and OWOR.Status <> 'C' and OWOR.Status <> 'L'
		
--Catalogo de Articulos con Metodo de valoracion diferente a Estandar. 
--para EvalSystem S = Estandar A = Promedio Ponderado. 	
	Select '075 ? MATERIALES DIF STD' AS REPORTE, OITM.ItemCode as Codigo, OITM.ItemName as Nombre,
	OITM.AvgPrice as Costo, OITM.OnHand as Existencia, OITM.EvalSystem
	from OITM 
	where OITM.EvalSystem <> 'S'
	Order by OITM.ItemName

--LISTA PRECIOS DE VENTA (2) Se ajusta con lista 10 x 2.5
--Ajustado el Jueves 22 de Abril del 2021. 		
	Select	'080 ! LISTA VENTA MATERIALES' AS REPORTE, ITM1.ItemCode, OITM.ItemName
	--, OITM.AvgPrice
	, OITM.OnHand
	--, OITM.EvalSystem
	, L10.Price as Pre_STD
	, L10.Currency as Mon_STD
	, ITM1.Price as Pre_VEN
	, ITM1.Currency as Mon_VEN 
	from ITM1
	inner join OITM on OITM.ItemCode = ITM1.ItemCode and ITM1.PriceList = 2
	inner join ITM1 L10 on ITM1.ItemCode = L10.ItemCode and L10.PriceList = 10
	where  L10.Price * 2 <> ITM1.Price 
	order by OITM.ItemName
		
	Update ITM1 Set ITM1.Price = L10.Price * 2.5, ITM1.Currency = L10.Currency
	from ITM1
	inner join OITM on OITM.ItemCode = ITM1.ItemCode and ITM1.PriceList = 2
	inner join ITM1 L10 on ITM1.ItemCode = L10.ItemCode and L10.PriceList = 10
	where L10.Price * 2 <> ITM1.Price

		
--Para Ventas de SUB-PRODUCTOS se maneja lista de Precios 1 por 2. 		
	Select	'085 ! LISTA VENTA SUB-PROD' AS REPORTE, ITM1.ItemCode, OITM.ItemName, OITM.AvgPrice, OITM.OnHand, OITM.EvalSystem,
	L01.Price as Pre_CAL, L01.Currency as Mon_CAL, ITM1.Price as Pre_VEN, ITM1.Currency as Mon_VEN 
	from ITM1
	inner join OITM on OITM.ItemCode = ITM1.ItemCode and ITM1.PriceList = 2
	inner join ITM1 L01 on ITM1.ItemCode = L01.ItemCode and L01.PriceList = 1
	where (OITM.QryGroup29 = 'Y' or OITM.QryGroup30 = 'Y' or OITM.QryGroup31 = 'Y'
	or OITM.QryGroup32 = 'Y') and L01.Price * 2 <> ITM1.Price
	order by OITM.ItemName
			
	Update ITM1 Set Price = L01.Price * 2
	from ITM1
	inner join OITM on OITM.ItemCode = ITM1.ItemCode and ITM1.PriceList = 2
	inner join ITM1 L01 on ITM1.ItemCode = L01.ItemCode and L01.PriceList = 1
	where (OITM.QryGroup29 = 'Y' or OITM.QryGroup30 = 'Y' or OITM.QryGroup31 = 'Y'
	or OITM.QryGroup32 = 'Y')  and L01.Price * 2 <> ITM1.Price

-- COSTO ESTAN DAR EN CEROS.
	Select	'090 ? STD=0' AS REPORTE, 
	ITM1.ItemCode, A1.ItemName, A1.EvalSystem,
	A1.OnHand, A1.AvgPrice as ESTANDAR, ITM1.Price as L_10
	from ITM1
	inner join OITM A1 on ITM1.ItemCode = A1.ItemCode and ITM1.PriceList=10
	where A1.AvgPrice = 0
	order by A1.ItemName

-- COSTO ESTAN DAR EN NULL.
	Select	'095 ? STD=NULL' AS REPORTE, 
	ITM1.ItemCode, A1.ItemName, A1.EvalSystem,
	A1.OnHand, A1.AvgPrice as ESTANDAR, ITM1.Price as L_10
	from ITM1
	inner join OITM A1 on ITM1.ItemCode = A1.ItemCode and ITM1.PriceList=10
	where A1.AvgPrice is null
	order by A1.ItemName

-- Validar que el L10 no sea menor de Ultima compra en caso de ser asi, valorar cambiar L10.
	Select	'100 L10<UCOMP' AS REPORTE, 
			OITM.ItemCode AS CODIGO,
			OITM.ItemName AS DESCRIPCION,
			OITM.U_TipoMat AS TM,
			OITM.U_Linea AS LINE,
			OITM.OnHand AS EXI_TOTAL,
			Case When OITM.LastPurCur = 'USD' then OITM.LastPurPrc * 20  
				 When OITM.LastPurCur = 'CAN' then OITM.LastPurPrc * 15.14
				 When OITM.LastPurCur = 'EUR' then OITM.LastPurPrc * 22.83
				 When OITM.LastPurCur = 'MXP' then OITM.LastPurPrc * 1 end AS Prec,
			OITM.AvgPrice AS ESTANDAR,
			L10.Price as L_10,
			OITM.LastPurPrc AS U_COMP,
			OITM.LastPurCur AS U_MON,
			OITM.OnHand*OITM.AvgPrice AS IMPORTE,
			OITM.FrozenFor AS INACTIVO 
	from ITM1 L10
	inner join OITM on L10.ItemCode = OITM.ItemCode and L10.PriceList=10
	where (L10.Price + 0.1) < (Case When OITM.LastPurCur = 'USD' then OITM.LastPurPrc * 20  
	When OITM.LastPurCur = 'CAN' then OITM.LastPurPrc * 15.14
	When OITM.LastPurCur = 'EUR' then OITM.LastPurPrc * 22.83
	When OITM.LastPurCur = 'MXP' then OITM.LastPurPrc * 1 end) 
	and OITM.OnHand = 0 and OITM.U_TipoMat = 'MP' and OITM.QryGroup30 = 'N'
	and OITM.QryGroup31 = 'N' and OITM.QryGroup32 = 'N' and OITM.QryGroup2 = 'N'
	and OITM.FrozenFor = 'N'
	order by IMPORTE, OITM.ItemName

		
-- Calcula con lista 10 corregida los nuevos valores a las estructuras.
	Select	'105 ? LDM NW L10' AS REPORTE,
			ITT1.Father AS CODE, 
			OITM.ItemName AS PRODUCTO,
			OITM.U_TipoMat AS T_MP,
			Convert(Decimal(28,4),SUM(ITT1.Quantity * ITT1.Price)) AS LDM,
			10 AS LISTA,
			'MXP' AS MODEDA,

			Convert(Decimal(28,4),ITM1.Price) as L10, 
			OITM.OnHand AS EXIS, 
			OITM.IsCommited AS COMP,
			OITM.OnOrder AS INORD,
			OITM.FrozenFor AS INACTIVO 
	From ITT1 
	inner join ITM1 on ITT1.Father = ITM1.ItemCode and ITM1.PriceList=10 
	inner join OITM on OITM.ItemCode = ITM1.ItemCode
	Group by ITT1.Father, ITM1.Price, OITM.ItemName, OITM.OnHand, 
	OITM.IsCommited, OITM.OnOrder, OITM.FrozenFor, OITM.U_TipoMat
	Having OITM.OnHand = 0 and Convert(Decimal(28,4),ITM1.Price) <> Convert(Decimal(28,4),SUM(ITT1.Quantity * ITT1.Price)) 
	Order by PRODUCTO
	 
	-- Para corregir diferencias cargar en Qwery's Excel.
	
-- Compara AvPrice vs Lista 10 No debe haber ninguna diferencia, En caso 
-- de diferencia ajustar Lista 10, Solicito Marcos se habilite como Alarma
-- en SAP, pero nunca la pelaron asi que hay voy. 16/OCT/2019. 
	Select	'110 ? L10<>STD' AS REPORTE, 
			ITM1.ItemCode, 
			A1.ItemName, A1.EvalSystem,
		A1.OnHand, a1.AvgPrice as Sistema, ITM1.Price as L_10
		from ITM1
		inner join OITM A1 on ITM1.ItemCode = A1.ItemCode and ITM1.PriceList=10
		where A1.AvgPrice <> ITM1.Price and A1.InvntItem = 'Y' and A1.AvgPrice > 0
		order by A1.ItemName
	 
		-- Para Modificar usar... 
		Update ITM1 set Price = A1.AvgPrice, ITM1.Currency = 'MXP'
		from ITM1
		inner join OITM A1 on ITM1.ItemCode = A1.ItemCode and ITM1.PriceList=10
		where A1.AvgPrice <> ITM1.Price and A1.InvntItem = 'Y' and A1.AvgPrice > 0	
	
	-- Metodo de Valoracion para todo Estandar. 
	Select	'325 ? CAMBIAR A STD.' AS REPORTE, 
					OITM.ItemCode AS CODIGO,
					OITM.ItemName AS DESCRIPCION,
					OITM.U_TipoMat AS TM,
					OITM.EvalSystem AS MV
	From ITM1
		inner join OITM on ITM1.ItemCode = OITM.ItemCode and ITM1.PriceList=10
		where OITM.U_TipoMat = 'RF' and OITM.frozenFor = 'N' and OITM.ItemCode <> '1000001003'
		and OITM.ItemCode <> '1000001002' and OITM.ItemCode <> '1000000009' 
		and OITM.ItemCode <> '1000000002' and OITM.ItemCode <> '1000000010'
		and OITM.ItemCode <> '72000'
		order by OITM.ItemName

	-- Inactivar codigos que queden en cero
	Select	'330 INAVILITAR' AS REPORTE, 
					OITM.ItemCode AS CODIGO,
					OITM.ItemName AS DESCRIPCION,
					OITM.U_TipoMat AS TM,
					OITM.U_Linea AS LINE,
					OITM.OnHand AS EXI_TOTAL,
						Case 
					When OITM.LastPurCur = 'USD' then OITM.LastPurPrc * 20  
					When OITM.LastPurCur = 'CAN' then OITM.LastPurPrc * 15.14
					When OITM.LastPurCur = 'EUR' then OITM.LastPurPrc * 22.83
					When OITM.LastPurCur = 'MXP' then OITM.LastPurPrc * 1 
					end AS Prec,
					OITM.AvgPrice AS ESTANDAR,
					L10.Price as L_10,
					OITM.LastPurPrc AS U_COMP,
					OITM.LastPurCur AS U_MON,
					OITM.OnHand*OITM.AvgPrice AS IMPORTE,
					OITM.FrozenFor AS INACTIVO 
		from ITM1 L10
		inner join OITM on L10.ItemCode = OITM.ItemCode and L10.PriceList=10
		where OITM.ItemCode like '%ZIN%'
		and OITM.OnHand = 0
		and frozenFor = 'N'













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


	--LISTA PRECIOS A COMPRAS REPORTAR A MARY (COMPRAS).
	-- Se cargo en Alarma para que le aparezca todos los Miercoles.
		--Select	'269 ? CEROS A COMPRAS' AS REPORTE,
		--		ITM1.ItemCode AS CODIGO, 
		--		OITM.ItemName AS MATERIAL,
		--		OITM.AvgPrice AS COSTO_STD, 
		--		OITM.OnHand AS EXISTENCIA,
		--		L09.Price as A_COMPRA,
		--		L09.Currency as MONEDA ,
		--		OITM.CreateDate AS F_ALTA
		--from ITM1
		--inner join OITM on OITM.ItemCode = ITM1.ItemCode and ITM1.PriceList = 1
		--inner join ITM1 L09 on ITM1.ItemCode = L09.ItemCode and L09.PriceList = 9
		--where L09.Price = 0 and OITM.U_IsModel = 'N' and OITM.U_TipoMat <> 'PT'
		--order by OITM.CreateDate, OITM.ItemName	
	


	--Para Productos Terminados Lista de Ventas de Articulo sin Precio
	--SUSPENDIDO PORQUE NO SE LLEVO A CABO LA CAPTURA DE LOS PRECIOS.
		/*
		Select 'PT SIN PRECIO L2' AS REPORTE, ITM1.ItemCode, OITM.ItemName, OITM.AvgPrice, OITM.OnHand, OITM.EvalSystem,
		L01.Price as Pre_CAL, L01.Currency as Mon_CAL, ITM1.Price as Pre_VEN, ITM1.Currency as Mon_VEN 
		from ITM1
		inner join OITM on OITM.ItemCode = ITM1.ItemCode and ITM1.PriceList = 2
		inner join ITM1 L01 on ITM1.ItemCode = L01.ItemCode and L01.PriceList = 1
		where OITM.U_TipoMat = 'PT' and ITM1.Price = 0 and OITM.U_IsModel = 'N'
		order by OITM.ItemName
		*/	


	

	
	-- Costeo LDM L-10 contra Standar.
	/*
		Select OCEAN.REPORTE, OCEAN.CODIGO, OCEAN.MUEBLE, OCEAN.TIPO, OCEAN.STANDAR,
		OCEAN.L10, OCEAN.LDM
		from (
		Select	'400 ¿? LMD vs STANDAR' as REPORTE, 
				ITT1.Father as CODIGO, 
				OITM.ItemName as MUEBLE, 
				OITB.ItmsGrpNam as GRUPO,
				OITM.U_TipoMat as TIPO,
				OITM.AvgPrice as STANDAR, 
				ITM1.Price as L10,
				SUM(ITT1.Quantity * ITT1.Price) as LDM
		from ITT1
		inner join OITM on OITM.ItemCode = ITT1.Father
		inner join OITB on OITM.ItmsGrpCod=OITB.ItmsGrpCod
		inner join ITM1 on OITM.ItemCode= ITM1.ItemCode and ITM1.PriceList=10
		Group By ITT1.Father, OITM.ItemName, OITB.ItmsGrpNam, OITM.U_TipoMat,
		OITM.AvgPrice, ITM1.Price ) OCEAN
		Where STANDAR <> LDM and TIPO = 'PT'
		--and MUEBLE like '%PIZZA%'
		Order by MUEBLE
		
		*/




-- Fin del Archivo de Excepciones de Costos.

