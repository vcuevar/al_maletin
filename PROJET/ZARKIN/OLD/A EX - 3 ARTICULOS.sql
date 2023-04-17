/* EXCEPCIONES DE ARTICULOS  */

--Actualizar que quede a 7 meses para atras.
Declare @FechaIS nvarchar(30)
Declare @FechaCrea nvarchar(30)
Declare @FechaInac nvarchar(30)
-- Fecha Creacion aaa/dd/mm
Set @FechaIS = '2019/30/07 00:00:00.000'
Set @FechaCrea =  '2020/20/04'
Set @FechaInac =  '2020/10/03'
/*
-- Asignar cuenta contable de acuerdo a los grupos de Articulos.
	--Select OITM.ItemCode as Codigo, OITM.ItemName as Descripcion, OITM.ItmsGrpCod as Grupo,
	--OITB.ItmsGrpNam as Nombre_Gpo, OITM.U_VerReporte as Cuenta_Conta
	--from OITM
	--inner join OITB on OITM.ItmsGrpCod = OITB.ItmsGrpCod
	--Where OITM.U_TipoMat = 'MP'
	--Order by OITM.ItemName
	
	/* Actualiza Cuentas contables para Poliza de Compras. */
	
	Update OITM set U_VerReporte = '500100001' Where OITM.ItmsGrpCod = 100 and (OITM.U_VerReporte is null or OITM.U_VerReporte <> '500100001')
	Update OITM set U_VerReporte = '500100002' Where OITM.ItmsGrpCod = 114 and (OITM.U_VerReporte is null or OITM.U_VerReporte <> '500100002')
	Update OITM set U_VerReporte = '500100003' Where OITM.ItmsGrpCod = 113 and (OITM.U_VerReporte is null or OITM.U_VerReporte <> '500100003')
	Update OITM set U_VerReporte = '500100004' Where OITM.ItmsGrpCod = 109 and (OITM.U_VerReporte is null or OITM.U_VerReporte <> '500100004')
	Update OITM set U_VerReporte = '500100005' Where OITM.ItmsGrpCod = 138 and (OITM.U_VerReporte is null or OITM.U_VerReporte <> '500100005')
	Update OITM set U_VerReporte = '500100006' Where OITM.ItmsGrpCod = 116 and (OITM.U_VerReporte is null or OITM.U_VerReporte <> '500100006')
	Update OITM set U_VerReporte = '500100007' Where OITM.ItmsGrpCod = 107 and (OITM.U_VerReporte is null or OITM.U_VerReporte <> '500100007')
	Update OITM set U_VerReporte = '500100008' Where OITM.ItmsGrpCod = 105 and (OITM.U_VerReporte is null or OITM.U_VerReporte <> '500100008')
	Update OITM set U_VerReporte = '500100009' Where OITM.ItmsGrpCod = 110 and (OITM.U_VerReporte is null or OITM.U_VerReporte <> '500100009')
	Update OITM set U_VerReporte = '500100010' Where OITM.ItmsGrpCod = 111 and (OITM.U_VerReporte is null or OITM.U_VerReporte <> '500100010')
	Update OITM set U_VerReporte = '500100012' Where OITM.ItmsGrpCod = 139 and (OITM.U_VerReporte is null or OITM.U_VerReporte <> '500100012')
	Update OITM set U_VerReporte = '500100013' Where OITM.ItmsGrpCod = 140 and (OITM.U_VerReporte is null or OITM.U_VerReporte <> '500100013')
	Update OITM set U_VerReporte = '500100014' Where OITM.ItmsGrpCod = 141 and (OITM.U_VerReporte is null or OITM.U_VerReporte <> '500100014')
	Update OITM set U_VerReporte = '500100016' Where OITM.ItmsGrpCod = 142 and (OITM.U_VerReporte is null or OITM.U_VerReporte <> '500100016')
	Update OITM set U_VerReporte = '500100018' Where OITM.ItmsGrpCod = 108 and (OITM.U_VerReporte is null or OITM.U_VerReporte <> '500100018')
	Update OITM set U_VerReporte = '500100020' Where OITM.ItmsGrpCod = 106 and (OITM.U_VerReporte is null or OITM.U_VerReporte <> '500100020')
	Update OITM set U_VerReporte = '500100022' Where OITM.ItmsGrpCod = 112 and (OITM.U_VerReporte is null or OITM.U_VerReporte <> '500100022')
	Update OITM set U_VerReporte = '500100023' Where OITM.ItmsGrpCod = 143 and (OITM.U_VerReporte is null or OITM.U_VerReporte <> '500100023')
	Update OITM set U_VerReporte = '500100030' Where OITM.ItmsGrpCod = 115 and (OITM.U_VerReporte is null or OITM.U_VerReporte <> '500100030')
	Update OITM set U_VerReporte = '500200004' Where OITM.ItmsGrpCod = 121 and (OITM.U_VerReporte is null or OITM.U_VerReporte <> '500200004')	
	Update OITM set U_VerReporte = '500100030' Where OITM.ItmsGrpCod = 132 and (OITM.U_VerReporte is null or OITM.U_VerReporte <> '500100030')
	
		
--Verificar que todos los articulos PT tengan un Lead time de 21 dias.
	Select '030 ? PT ERROR LEAD TIME' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.LeadTime
	from OITM
	where OITM.U_TipoMat='PT' and LeadTime<> 21 or OITM.U_TipoMat='PT' and LeadTime is null 
	
--Que ningun Articulo tenga tiempo de Entrega cero o Nulo..
	Select '035 ! SIN LEAD TIME' as REPORTE, oitm.ItemCode, OITM.ItemName, OITM.LeadTime
	from OITM
	where LeadTime = 0 or LeadTime is null 
	
	update OITM set LeadTime = 15 where LeadTime = 0 or LeadTime is null
	
-- Ver lo 50 nuevos articulos ingresados, tratar de identificar capturar erroneas.
	select top  50 '040 ART. MP NEW' as REPORTE, Cast(OITM.CreateDate as date) AS FEC_CREA, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_VS, OITM.AvgPrice as COSTO, L10.Price as Precio_10, L10.Currency as Mone_10, L9.Price  AS Precio_CO, L9.Currency  AS Mone_CO, L1.Price as Precio_CAL, L1.Currency as Mone_CAL, OITB.ItmsGrpNam, OITM.U_TipoMat, UFD1.Descr
	from OITM inner join OITB on OITM.ItmsGrpCod=OITB.ItmsGrpCod inner join UFD1 on OITM.U_GrupoPlanea=UFD1.FldValue and UFD1.TableID='OITM' and UFD1.FieldID=19 inner join ITM1 L10 on OITM.ItemCode = L10.ItemCode and L10.PriceList=10 inner join ITM1 L1 on OITM.ItemCode = L1.ItemCode and L1.PriceList = 1 inner join ITM1 L9 on OITM.ItemCode = L9.ItemCode and L9.PriceList = 9
	--where OITM.CreateDate > @FechaCrea and OITM.U_TipoMat <> 'PT' and OITM.U_TipoMat <> 'CA'
	--and OITM.QryGroup32 = 'N' and OITM.QryGroup31 = 'N' and OITM.QryGroup30 = 'N'  
	order by OITM.CreateDate DESC

-- Reporte de Excepciones los 20 ultimos codigos enviados a Inactivos, ver que los materiales enviados,
-- realmente deban ser inactivo, no existir estructura que lo lleve y no tener existencia.
	select top 20 '045 ART. A INACTIVOS' as REPORTE, OITM.frozenFrom, OITM.ItemCode, OITM.ItemName, OITM.AvgPrice as Estandar,
	L10.Price as Precio_Std, L10.Currency as Mone_Std, LCO.Price as Precio_CO, LCO.Currency as Mone_CO,
	OITB.ItmsGrpNam, OITM.U_TipoMat,
	UFD1.Descr, OITM.frozenFor, OITM.frozenFrom,frozenTo,OITM.FrozenComm
	from OITM
	inner join OITB on OITM.ItmsGrpCod=OITB.ItmsGrpCod
	inner join UFD1 on OITM.U_GrupoPlanea=UFD1.FldValue and UFD1.TableID='OITM' and UFD1.FieldID=19
	inner join ITM1 L10 on OITM.ItemCode=L10.ItemCode and L10.PriceList=10 
	inner join ITM1 LCO on OITM.ItemCode=LCO.ItemCode and LCO.PriceList=9 
	WHERE OITM.frozenFor='Y' and OITM.frozenFrom > @FechaInac --'2019/06/11'
	order by OITM.frozenFrom DESC


-- Articulos con Factor en la pestaña compras.
	Select '050 ? CON FACTOR DE CANTIDAD' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.PurFactor1
	from OITM
	Where OITM.PurFactor1 <> 1
	
	/*
	Update OITM set PurFactor1 = 1 
	Where OITM.PurFactor1 <> 1
	*/
	
-- Existencias Negativas en algun almacen (error que en ocasiones genera el sistema de control de piso).
-- se corrige trasladando existencia a dicho almacen con existencia negativa.
	Select '055 ? EXISTENCIAS NEGATIVAS' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITW.OnHand, OITW.WhsCode
	from OITM
	inner join OITW on OITM.ItemCode=OITW.ItemCode 
	Where OITW.OnHand < 0
*/
-- Verificar que todos los PT utilicen el Metodo de JIT, para que no le hagan ruido en los grupo de MRP a compras.
	select '060 ? PT CON JIT' AS REPORTE, oitm.ItemCode, OITM.ItemName, OITM.LeadTime, OITM.U_Metodo
	from OITM
	where OITM.U_TipoMat='PT' and OITM.U_Metodo <> 'JIT'

-- Verificar que los articulos que tienen metodo OTRO sean asignados a uno correcto.
	select '065 ? METODO OTRO QUITAR' AS REPORTE, oitm.ItemCode, OITM.ItemName, OITM.LeadTime, OITM.U_Metodo
	from OITM
	where OITM.U_Metodo = 'OTRO' or OITM.U_Metodo is null
	

-- ARTICULO CASCO.
-- Articulo Casco con Grupo de Planeacion diferente a 2 CASCO Y HABILITADO. 
	select '070 ? GRUPO CASCO PLAN' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.ItmsGrpCod, OITM.U_TipoMat, OITM.U_GrupoPlanea 
	from OITM
	where OITM.QryGroup29='Y' and U_GrupoPlanea<> 2
	order by OITM.ItemName

-- Validar que sean tipo de material CA (CASCOS) los que estan en Propiedad 29 *
	Select '075 ? TIPO CA PROP-29' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat, OITM.DfltWH, oitm.ItmsGrpCod, OITB.ItmsGrpNam,
	OITM.U_GrupoPlanea, UFD1.Descr, OITM.U_estacion,
	OITM.PurPackMsr, OITM.NumInBuy, OITM.BuyUnitMsr from OITM 
	inner join UFD1 on OITM.U_GrupoPlanea=UFD1.FldValue and UFD1.TableID='UITM'
	inner join OITB on OITM.ItmsGrpCod=OITB.ItmsGrpCod
	where OITM.QryGroup29='Y' and OITM.U_TipoMat<>'CA'
	ORDER BY OITM.ItemName
		
-- Validar que los CASCOS, Tengan en su dato maestro Valor Sala, estan en Propiedad 29 
	Select '080 ? VS DE CASCO' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat, OITM.DfltWH, OITM.U_VS  
	from OITM 
	where OITM.QryGroup29='Y' and OITM.U_VS = 0
	ORDER BY OITM.ItemName	
	
-- Validar que los CASCOS, Tengan el numero de Modelo al que corresponden 
	Select '095 ? MODELO IGUAL CODIGO' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat, OITM.DfltWH, OITM.U_VS, 
	SUBSTRING(OITM.ItemCode,1,4) as ModelC, OITM.U_Modelo
	from OITM 
	where OITM.QryGroup29='Y' and SUBSTRING(OITM.ItemCode,1,4) <> OITM.U_Modelo
	ORDER BY OITM.ItemName	
	 
	 /*
	 update OITM set U_Modelo = SUBSTRING(OITM.ItemCode,1,4)
	 where OITM.QryGroup29='Y' and SUBSTRING(OITM.ItemCode,1,4) <> OITM.U_Modelo 
	 */
	
-- VER-160414 VALIDAR ALMACEN DE CASCOS SEA APT-PA 
	Select '100 ? ALM DFL CASCO' AS REPORTE, OITM.ItemCode, OITM.ItemName, 
	OITM.U_TipoMat, OITM.DfltWH
	from OITM 
	where OITM.QryGroup29='Y' and OITM.DfltWH <>'APT-PA'
	ORDER BY OITM.ItemName	
	
	Update OITM set OITM.DfltWH = 'APT-PA' where OITM.QryGroup29='Y' and OITM.DfltWH <>'APT-PA'

-- VER-170829 VALIDAR QUE TENGA LISTA DE MATERIALES EL CASCO PROP-29 
	Select '105 ? SIN LDM CASCO' AS REPORTE, A3.ItemCode, ITT1.Father ,A3.ItemName, A3.U_TipoMat, A3.QryGroup29
	from OITM A3
	left join ITT1 on A3.ItemCode = ITT1.Father    
	where A3.QryGroup29='Y' and ITT1.Father is null
	ORDER BY A3.ItemName	
	
	/* PARA CORREGIR USAR ...
	Update OITM set QryGroup29 = 'N'
	from OITM 
	left join ITT1 on OITM.ItemCode = ITT1.Father    
	where OITM.QryGroup29='Y' and ITT1.Father is null
	*/
				
-- VER-160414 VALIDAR LISTA DE MATERIALES DE CASCO CONSUMAN DEL APG-ST (6/NOV/18 VIRTUAL)
	Select '110 ! LDM CASCO CONSUME APG-ST' AS REPORTE, ITT1.Father, 
	A3.ItemName, A3.U_TipoMat, A3.DfltWH, ITT1.Code, A1.ItemName, 
	A1.U_TipoMat, ITT1.Warehouse
	from ITT1 
	inner join OITM A3 on ITT1.Father = A3.ItemCode
	inner join OITM A1 on ITT1.Code=A1.ItemCode  
	where A3.QryGroup29='Y' and ITT1.Warehouse <>'APG-ST' and A1.U_TipoMat <> 'CG'
	ORDER BY A3.ItemName			

	Update ITT1 Set ITT1.Warehouse = 'APG-ST'
	from ITT1 
	inner join OITM A3 on ITT1.Father = A3.ItemCode
	inner join OITM A1 on ITT1.Code=A1.ItemCode  
	where A3.QryGroup29='Y' and ITT1.Warehouse <>'APG-ST' and A1.U_TipoMat <> 'CG'

			
-- VER-160414 VALIDAR ALMACEN DE BASE OITT CABECERA DE LISTA DE MATERIALES CASCO. 
	Select '120 ? ALM. DFL CABECERA LMD' AS REPORTE, OITT.Code, A3.ItemName, A3.U_TipoMat, OITT.ToWH
	from OITT 
	inner join OITM A3 on OITT.Code = A3.ItemCode 
	where A3.QryGroup29='Y' and OITT.TOWH <>'APT-PA'
	ORDER BY A3.ItemName

	--hacer update


-- ARTICULO COMPLEMENTOS PROP. 31 PATAS Y BASTIDORES FABRICADOS EN CARPINTERIA. 
-- Articulo Complementos de Madera con Grupo de Planeacion diferente a 14 PATAS DE MADERA.
	select '125 ? GRUPO PLANEACION' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.ItmsGrpCod, OITM.U_TipoMat, OITM.U_GrupoPlanea 
	from OITM
	where OITM.QryGroup31='Y' and U_GrupoPlanea<> 14
	order by OITM.ItemName
 
-- Validar que sean COMPLEMENTOS DE CASCOS los que estan en Propiedad 31
	Select '130 ? VALIDA SEAN FAB. CARPINT.' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat, OITM.DfltWH, oitm.ItmsGrpCod, OITB.ItmsGrpNam,
	OITM.U_GrupoPlanea, UFD1.Descr, OITM.U_estacion,
	OITM.PurPackMsr, OITM.NumInBuy, OITM.BuyUnitMsr from OITM 
	inner join UFD1 on OITM.U_GrupoPlanea=UFD1.FldValue and UFD1.TableID='UITM'
	inner join OITB on OITM.ItmsGrpCod=OITB.ItmsGrpCod
	where OITM.QryGroup31='Y' and OITM.ItemName not like '%BASTIDOR%' and OITM.ItemName not like '%PATA%'
	and OITM.ItemName not like '%BASTON%' and OITM.ItemName not like '%CAJA%' and OITM.ItemName not like '%CUBIERTA%'
	and OITM.ItemName not like '%BOTON%' and OITM.ItemName not like '%MESA%' and OITM.ItemName not like '%VISTA%'
	ORDER BY OITM.ItemName		
		
-- VER-160414 VALIDAR ALMACEN DE COMPLEMENTOS SEA APT-PA 
	Select '135 ? LDM COMPL. ENTREGA APT-PA' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat, OITM.DfltWH, oitm.ItmsGrpCod, OITB.ItmsGrpNam,
	OITM.U_GrupoPlanea, UFD1.Descr, OITM.U_estacion,
	OITM.PurPackMsr, OITM.NumInBuy, OITM.BuyUnitMsr
	from OITM 
	inner join UFD1 on OITM.U_GrupoPlanea=UFD1.FldValue and UFD1.TableID='UITM'
	inner join OITB on OITM.ItmsGrpCod=OITB.ItmsGrpCod
	where OITM.QryGroup31='Y' and OITM.DfltWH <>'APT-PA'
	ORDER BY OITM.ItemName
		
-- VER-160414 VALIDAR ALMACEN DE BASE OITT CABECERA DE LISTA DE MATERIALES COMPLEMENTOS ASIGNE EL APT-PA 
	Select '140 ? ALM. DFL CABECERA LMD' AS REPORTE, OITT.Code, A3.ItemName, A3.U_TipoMat, OITT.ToWH
	from OITT 
	inner join OITM A3 on OITT.Code = A3.ItemCode 
	where A3.QryGroup31='Y' and OITT.TOWH <>'APT-PA'
	ORDER BY A3.ItemName
		
-- VER-160414 VALIDAR ALMACEN DE BASE OITM MASTRO DE ARTICULO COMPLEMENTOS DEFAUL APT-PA 
	Select '145 ? ALM.DFL COMPL. APT-PA' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat, OITM.DfltWH
	from OITM 
	where OITM.QryGroup31='Y' and OITM.DfltWH <>'APT-PA'
	ORDER BY OITM.ItemName
		
-- VER-160414 VALIDAR LISTA DE MATERIALES DE COMPLEMENTOS CONSUMAN DEL APT-PA 
	Select '150 ! LDM COMPL. CONSUME APG-ST' AS REPORTE, ITT1.Father, A3.ItemName, A3.U_TipoMat, A3.DfltWH, ITT1.Code, A1.ItemName, A1.U_TipoMat, ITT1.Warehouse
	from ITT1 
	inner join OITM A3 on ITT1.Father = A3.ItemCode
	inner join OITM A1 on ITT1.Code=A1.ItemCode  
	where A3.QryGroup31='Y' and ITT1.Warehouse <>'APG-ST'
	ORDER BY A3.ItemName
	
	Update ITT1 Set ITT1.Warehouse = 'APG-ST'
	from ITT1 
	inner join OITM A3 on ITT1.Father = A3.ItemCode
	inner join OITM A1 on ITT1.Code=A1.ItemCode  
	where A3.QryGroup31='Y' and ITT1.Warehouse <>'APG-ST' 

	
-- VER-170829 VALIDAR QUE TENGA LISTA DE MATERIALES LAS PATAS O BASTIDORES PROP-31 
	Select '155 ? COMPL. SIN LDM' AS REPORTE, A3.ItemCode, ITT1.Father ,A3.ItemName, A3.U_TipoMat, A3.QryGroup31
	from OITM A3
	left join ITT1 on A3.ItemCode = ITT1.Father    
	where A3.QryGroup31='Y' and ITT1.Father is null
	ORDER BY A3.ItemName	
	
	/* PARA CORREGIR CORRER...
	Update OITM set QryGroup31 = 'N'
	from OITM 
	left join ITT1 on OITM.ItemCode = ITT1.Father    
	where OITM.QryGroup31='Y' and ITT1.Father is null
	*/
	
	
-- VER-170829 VALIDAR QUE TENGA LISTA DE MATERIALES DE COMPLEMENTOS PROP-32 
	Select '160 ? SP SIN LDM' AS REPORTE, A3.ItemCode, ITT1.Father ,A3.ItemName, A3.U_TipoMat, A3.QryGroup32
	from OITM A3
	left join ITT1 on A3.ItemCode = ITT1.Father    
	where A3.QryGroup32='Y' and ITT1.Father is null
	ORDER BY A3.ItemName	
	
	/* PARA CORREGIR CORRER...
	Update OITM set QryGroup32 = 'N'
	from OITM 
	left join ITT1 on OITM.ItemCode = ITT1.Father    
	where OITM.QryGroup32='Y' and ITT1.Father is null
	*/
	
	-- Configuración Grupo de Articulos MATERIAS PRIMAS W PT POR C 
	SELECT distinct(T1.[ItemCode]),'165 ? CLASE ART. MP' AS REPORTE, T1.[ItemName], T2.[ItmsGrpNam], T1.[GLMethod]
	FROM ITT1 T0
	INNER JOIN OITM T1 ON T0.Code = T1.ItemCode
	INNER JOIN OITB T2 ON T1.ItmsGrpCod = T2.ItmsGrpCod 
	WHERE T1.U_TipoMat <> 'PT' and T1.[GLMethod] <> 'W' and ItemCode <> '10121'
	
	-- Configuración Grupo de Articulos MATERIAS PRIMAS W PT POR C 
	SELECT distinct(T1.[ItemCode]),'170 ? CLASE ART. PT' AS REPORTE,  T1.[ItemName], T2.[ItmsGrpNam], T1.[GLMethod]
	FROM ITT1 T0
	INNER JOIN OITM T1 ON T0.Code = T1.ItemCode
	INNER JOIN OITB T2 ON T1.ItmsGrpCod = T2.ItmsGrpCod 
	WHERE T1.U_TipoMat = 'PT' and T1.[GLMethod] <> 'C'
	
-- ARTICULO HABILITADO DE CASCO PROPIEDAD 30. 
-- Articulo Habilitado con Grupo de Planeacion diferente a 2 CASCO Y HABILITADO. 
	select '175 ? GRUPO PLAN HAB.' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.ItmsGrpCod, OITM.U_TipoMat, OITM.U_GrupoPlanea 
	from OITM
	where OITM.QryGroup30='Y' and U_GrupoPlanea<> 2
	order by OITM.ItemName

-- Validar que sean HABILITADOS DE CASCOS los que estan en Propiedad 30 */
	Select '180 ? NOMBRE SEA HABIL PROP 30' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat, OITM.DfltWH, oitm.ItmsGrpCod, OITB.ItmsGrpNam,
	OITM.U_GrupoPlanea, UFD1.Descr, OITM.U_estacion,
	OITM.PurPackMsr, OITM.NumInBuy, OITM.BuyUnitMsr from OITM 
	inner join UFD1 on OITM.U_GrupoPlanea=UFD1.FldValue and UFD1.TableID='UITM'
	inner join OITB on OITM.ItmsGrpCod=OITB.ItmsGrpCod
	where OITM.QryGroup30='Y' and OITM.ItemName NOT like '%HABIL%'
	ORDER BY OITM.ItemName
		
-- Validar que los CASCOS, Tengan el numero de Modelo al que corresponden 
	Select '190 ? HABILITADO MODELO IGUAL CODIGO' AS REPORTE,OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat, OITM.DfltWH, OITM.U_VS, 
	SUBSTRING(OITM.ItemCode,1,4) as ModelC, OITM.U_Modelo
	from OITM 
	where OITM.QryGroup30='Y' and SUBSTRING(OITM.ItemCode,1,4) <> OITM.U_Modelo
	ORDER BY OITM.ItemName	
	 
	 /*
	 update OITM set U_Modelo = SUBSTRING(OITM.ItemCode,1,4)
	 where OITM.QryGroup30='Y' and SUBSTRING(OITM.ItemCode,1,4) <> OITM.U_Modelo
	 */
	
-- VC-160414 Validar que los HABILITADOS DE CASCOS Almacen Defauld APG-ST y estan en Propiedad 30 
	Select '195 ? HABIL. ALM.DFL APG-ST' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat, OITM.DfltWH
	from OITM 
	where OITM.QryGroup30='Y' and OITM.DfltWH <> 'APG-ST'
	ORDER BY OITM.ItemName

	update OITM Set OITM.DfltWH = 'APG-ST' where OITM.QryGroup30='Y' and OITM.DfltWH <> 'APG-ST'


	
	-- VALIDAR ALMACEN DE BASE OITT CABECERA DE LDM HABILITADOS. 
	Select '200 ! DFL CAB. LMD 30.' AS REPORTE, OITT.Code, A3.ItemName, A3.U_TipoMat, OITT.ToWH
	from OITT 
	inner join OITM A3 on OITT.Code = A3.ItemCode 
	where A3.QryGroup30='Y' and OITT.TOWH <> 'APG-ST'
	ORDER BY A3.ItemName

	Update OITT set OITT.ToWH = 'APG-ST'
	from OITT 
	inner join OITM A3 on OITT.Code = A3.ItemCode 
	where A3.QryGroup30='Y' and OITT.TOWH <> 'APG-ST'

-- VC-160414 Validar que los HABILITADOS DE CASCOS (ESTRUCTURA) consuman del Almacen APT-PA y estan en Propiedad 30 */
	Select '205 ! LDM HABIL. CONSUMA APG-ST' AS REPORTE, ITT1.Father, A3.ItemName, A3.U_TipoMat, ITT1.Code,A1.ItemName,ITT1.Warehouse
	from ITT1 
	inner join OITM A3 on A3.ItemCode=ITT1.Father
	inner join OITM A1 on A1.ItemCode=ITT1.Code
	where A3.QryGroup30='Y' and ITT1.warehouse <> 'APG-ST' 
	ORDER BY A3.ItemName
	
	Update ITT1 Set ITT1.Warehouse = 'APG-ST'
	from ITT1 
	inner join OITM A3 on ITT1.Father = A3.ItemCode
	inner join OITM A1 on ITT1.Code=A1.ItemCode  
	where A3.QryGroup30='Y' and ITT1.Warehouse <>'APG-ST'

	
-- Validar que los HABILITADOS DE CASCOS Tengan en su dato maestro Valor Sala, estan en Propiedad 30 
	Select '210 ? ART. HABIL ALM. S/VS' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat, OITM.DfltWH
	from OITM 
	where OITM.QryGroup30='Y' and OITM.U_VS = 0
	ORDER BY OITM.ItemName
	
	
-- VER-170829 VALIDAR QUE TENGA LISTA DE MATERIALES LOS HABILITADOS PROP-30 
	Select '215 ? HABIL. SIN LDM' AS REPORTE, A3.ItemCode, ITT1.Father ,A3.ItemName, A3.U_TipoMat, A3.QryGroup30
	from OITM A3
	left join ITT1 on A3.ItemCode = ITT1.Father    
	where A3.QryGroup30='Y' and ITT1.Father is null
	ORDER BY A3.ItemName	
	
	/* PARA CORREGIR CORRER...
	Update OITM set QryGroup30 = 'N'
	from OITM 
	left join ITT1 on OITM.ItemCode = ITT1.Father    
	where OITM.QryGroup30='Y' and ITT1.Father is null
	*/
	
	
-- ARTICULOS EN GENERAL
-- Catalogo de Materiales con Metodo Manual cuando debe ser Notificacion
	select '220 ? ERR, METODO EN MANUAL' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat, OITM.DfltWH, OITM.IssueMthd, OITM.ItmsGrpCod,
	OITM.U_estacion, OITM.PurPackMsr, OITM.NumInBuy, OITM.BuyUnitMsr
	from OITM 
	where IssueMthd='M' and ItmsGrpCod<> 113
		
-- Catalogo de Piel debe tener Lotes*/
	select '225 ? PIEL SIN LOTES' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat, OITM.OnHand, OITM.DfltWH, OITM.IssueMthd, OITM.ItmsGrpCod,
	OITM.U_estacion, OITM.PurPackMsr, OITM.NumInBuy, OITM.BuyUnitMsr, OITM.ManBtchNum
	from OITM 
	where ItmsGrpCod = 113 and OITM.ManBtchNum = 'N'
	
-- Materiales que no se les asigno Linea (01 Linea, 05 Fuera de Linea, 10 Obsoleto)
--	Actualizar para que salga completo inventarios 
	select '230 ? ART. SIN LINEA' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat, OITM.DfltWH, OITM.ItmsGrpCod, OITM.U_estacion,
	OITM.PurPackMsr, OITM.NumInBuy, OITM.BuyUnitMsr from OITM 
	where U_Linea is null
		
-- Materiales que NO se encuentran en Estructura o esta en estructuras donde 
--	estan descontinuados y Linea esta como NO OBSOLETO. Se concidera como OBSOLETO.
-- Y su ultima compra sea mas de 7 meses.
	SELECT '235 ? A OBS. 7 MES' AS REPORTE, OITM.ItemCode, OITM.ItemName , OITM.CreateDate, 
	OITM.LastPurDat, Mat.CODE, OITM.U_Linea, OITM.ItmsGrpCod
	FROM OITM 
	LEFT join (Select ITT1.Code from ITT1 inner join OITM A3 on ITT1.Father = A3.ItemCode
	where A3.U_Linea = '01'	group by ITT1.Code ) Mat on OITM.ItemCode = Mat.Code 
	WHERE Mat.Code IS NULL 
	and (OITM.U_TipoMat='MP' and OITM.U_Linea = '01' and OITM.ItmsGrpCod <> 114 and
	OITM.ItmsGrpCod <> 113 ) and OITM.CreateDate < @FechaIS and OITM.LastPurDat < @FechaIS 
	ORDER BY OITM.CreateDate

-- Materiales que ESTA COMO OBSOLETO y se encuentra cargado en las Estructuras.
	SELECT '240 ? REGRESAR A LINEA' AS REPORTE, OITM.ItemCode, OITM.ItemName , Mat.CODE, OITM.U_Linea, OITM.ItmsGrpCod
	FROM OITM 
	LEFT join (Select ITT1.Code from ITT1 inner join OITM A3 on ITT1.Father = A3.ItemCode
	where A3.U_Linea = '01'	group by ITT1.Code ) Mat on OITM.ItemCode = Mat.Code 
	WHERE Mat.Code IS NOT NULL 
	and (OITM.U_TipoMat='MP' and OITM.U_Linea = '10' and OITM.ItmsGrpCod<> 114 and OITM.ItmsGrpCod <> 113 )
	ORDER BY Mat.Code	

-- Articulos Sin estacion de Trabajo, Capturar Manualmente 
	Select '245 ? SIN ESTACION MP' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat, OITM.DfltWH, oitm.ItmsGrpCod, OITB.ItmsGrpNam,
	OITM.U_GrupoPlanea, UFD1.Descr, OITM.U_estacion, OITM.InvntryUom,
	OITM.PurPackMsr, OITM.NumInBuy, OITM.BuyUnitMsr from OITM 
	inner join UFD1 on OITM.U_GrupoPlanea=UFD1.FldValue and UFD1.TableID='UITM'
	inner join OITB on OITM.ItmsGrpCod=OITB.ItmsGrpCod
	where OITM.U_estacion is null and OITM.U_TipoMat <> 'PT'
	ORDER BY OITM.ItemName
		

-- Articulos Sin estacion de Trabajo, PT SE ASIGNA. 
	Select '250 ! SIN ESTACION PT' AS REPO_372, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat, 
	OITM.DfltWH, oitm.ItmsGrpCod, OITB.ItmsGrpNam,
	OITM.U_GrupoPlanea, UFD1.Descr, OITM.U_estacion, OITM.InvntryUom,
	OITM.PurPackMsr, OITM.NumInBuy, OITM.BuyUnitMsr from OITM 
	inner join UFD1 on OITM.U_GrupoPlanea=UFD1.FldValue and UFD1.TableID='UITM'
	inner join OITB on OITM.ItmsGrpCod=OITB.ItmsGrpCod
	where OITM.U_estacion is null and OITM.U_TipoMat = 'PT'
	ORDER BY OITM.ItemName

	update OITM set OITM.U_estacion = 99 where OITM.U_estacion is null and OITM.U_TipoMat = 'PT'


-- Articulos Sin unidad de Inventario. 
	Select '255 ! PT KIT UM <> JGO' AS REPO_374, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat, 
	OITM.InvntItem, OITM.InvntryUom, OITM.PurPackMsr, OITM.BuyUnitMsr from OITM 
	where OITM.InvntryUom <> 'JGO' and OITM.U_TipoMat = 'PT' and OITM.InvntItem = 'N'
	and OITM.ItemCode <> '70000' and OITM.ItemCode <> '71000'
	ORDER BY OITM.ItemName		

	Update OITM set OITM.InvntryUom = 'JGO', OITM.PurPackMsr = 'JGO', OITM.BuyUnitMsr = 'JGO'
	where OITM.InvntryUom <> 'JGO' and OITM.U_TipoMat = 'PT' and OITM.InvntItem = 'N'
	and OITM.ItemCode <> '70000' and OITM.ItemCode <> '71000'

-- Articulos Sin unidad de Inventario. 
	Select '300 ? SIN UM INVENTARIO' AS REPO_376, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat, OITM.DfltWH, oitm.ItmsGrpCod, OITB.ItmsGrpNam,
	OITM.U_GrupoPlanea, UFD1.Descr, OITM.U_estacion, OITM.InvntryUom,
	OITM.PurPackMsr, OITM.NumInBuy, OITM.BuyUnitMsr from OITM 
	inner join UFD1 on OITM.U_GrupoPlanea=UFD1.FldValue and UFD1.TableID='UITM'
	inner join OITB on OITM.ItmsGrpCod=OITB.ItmsGrpCod
	where OITM.InvntryUom is null
	ORDER BY OITM.ItemName		
		
-- Articulos Sin unidad definida Inventario cantidad compra = 1, Capturar Manualmente 
	Select '305 ? SIN UM COMPRAS' AS REPO_378, OITM.ItemCode, OITM.ItemName,
	OITM.InvntryUom, OITM.BuyUnitMsr,OITM.PurPackMsr, OITM.SalUnitMsr, OITM.SalPackMsr
	, OITM.NumInBuy from OITM 
	where   OITM.NumInBuy = 1 AND OITM.InvntryUom <> 'CAJA'
	AND OITM.InvntryUom <> 'PZA'AND OITM.InvntryUom <> 'LTS' AND OITM.InvntryUom <> 'JGO'
	AND OITM.InvntryUom <> 'MTS' AND OITM.InvntryUom <> 'KGS'  AND OITM.InvntryUom <> 'YDS'
	AND OITM.InvntryUom <> 'MIN' AND OITM.InvntryUom <> 'MT2' AND OITM.InvntryUom <> 'FT3'
	AND OITM.InvntryUom <> 'DC2' AND OITM.InvntryUom <> 'ROLLO' AND OITM.InvntryUom <> 'PAR'
	AND OITM.InvntryUom <> 'PESOS' AND OITM.InvntryUom <> 'ACT'
	ORDER BY OITM.ItemName
		
-- Articulo sin Unidad definida Cantidad de Compra > 1.
	Select '310 ? SIN UM COMPRAS 2' AS REPO_380, OITM.ItemCode, OITM.ItemName,
	OITM.InvntryUom, OITM.BuyUnitMsr,OITM.PurPackMsr, OITM.SalUnitMsr, OITM.SalPackMsr
	, OITM.NumInBuy from OITM 
	where   OITM.NumInBuy > 1 --AND OITM.InvntryUom = 'm'
	AND OITM.InvntryUom <> 'PZA'AND OITM.InvntryUom <> 'LTS' AND OITM.InvntryUom <> 'JGO'
	AND OITM.InvntryUom <> 'MTS' AND OITM.InvntryUom <> 'KGS'  AND OITM.InvntryUom <> 'YDS'
	AND OITM.InvntryUom <> 'MIN' AND OITM.InvntryUom <> 'MT2' AND OITM.InvntryUom <> 'FT3'
	AND OITM.InvntryUom <> 'DC2' AND OITM.InvntryUom <> 'ROLLO' AND OITM.InvntryUom <> 'PAR'
	AND OITM.InvntryUom <> 'ML' AND OITM.InvntryUom <> 'ACT' AND OITM.InvntryUom <> 'G'
	ORDER BY OITM.ItemName
		
-- Articulo con Unidad de Compra no definida	
	Select '315 ? UM NO DEFINIDA ' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.BuyUnitMsr,OITM.PurPackMsr, OITM.SalUnitMsr, OITM.SalPackMsr
	, OITM.NumInBuy from OITM 
	where OITM.NumInBuy > 1 --AND OITM.PurPackMsr = 'caja'
	AND OITM.PurPackMsr <> 'PAQ'
	AND OITM.PurPackMsr <> 'PZA'AND OITM.PurPackMsr <> 'LTS' AND OITM.PurPackMsr <> 'JGO'
	AND OITM.PurPackMsr <> 'MTS' AND OITM.PurPackMsr <> 'KGS'  AND OITM.PurPackMsr <> 'YDS'
	AND OITM.PurPackMsr <> 'MIN' AND OITM.PurPackMsr <> 'MT2' AND OITM.PurPackMsr <> 'FT3'
	AND OITM.PurPackMsr <> 'DC2' AND OITM.PurPackMsr <> 'ROLLO' AND OITM.PurPackMsr <> 'CAJA'
	AND OITM.PurPackMsr <> 'CUBETA' AND OITM.PurPackMsr <> 'FT2' AND OITM.PurPackMsr <> 'TAMBO'
	ORDER BY OITM.ItemName
	
	
-- Articulos Sin unidad de Compra en Paquetes.
	Select '320 ? SIN UM EN PAQUETE' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat, OITM.DfltWH, oitm.ItmsGrpCod, OITB.ItmsGrpNam,
	OITM.U_GrupoPlanea, UFD1.Descr, OITM.U_estacion, OITM.InvntryUom,
	OITM.PurPackMsr, OITM.NumInBuy, OITM.BuyUnitMsr from OITM 
	inner join UFD1 on OITM.U_GrupoPlanea=UFD1.FldValue and UFD1.TableID='UITM'
	inner join OITB on OITM.ItmsGrpCod=OITB.ItmsGrpCod
	where OITM.PurPackMsr is null --and OITM.NumInBuy=1
	ORDER BY OITM.ItemName

		
-- Articulos Sin unidad de Compra pero si con unidad de Empaque, Capturar Manualmente 
	Select '325 ? SIN UM COMPRAS CON CONV' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat, OITM.DfltWH, oitm.ItmsGrpCod, OITB.ItmsGrpNam,
	OITM.U_GrupoPlanea, UFD1.Descr, OITM.U_estacion, OITM.InvntryUom,
	OITM.PurPackMsr, OITM.NumInBuy, OITM.BuyUnitMsr from OITM 
	inner join UFD1 on OITM.U_GrupoPlanea=UFD1.FldValue and UFD1.TableID='UITM'
	inner join OITB on OITM.ItmsGrpCod=OITB.ItmsGrpCod
	where OITM.BuyUnitMsr is null --and OITM.NumInBuy=1
	ORDER BY OITM.ItemName
		
				
-- Articulos Sin unidad de Ventas. 
	Select '330 ? SIN UM VENTAS' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat, OITM.DfltWH, oitm.ItmsGrpCod, OITB.ItmsGrpNam,
	OITM.U_GrupoPlanea, UFD1.Descr, OITM.U_estacion, OITM.InvntryUom,
	OITM.PurPackMsr, OITM.NumInBuy, OITM.BuyUnitMsr from OITM 
	inner join UFD1 on OITM.U_GrupoPlanea=UFD1.FldValue and UFD1.TableID='UITM'
	inner join OITB on OITM.ItmsGrpCod=OITB.ItmsGrpCod
	where OITM.SalUnitMsr is null --and OITM.NumInBuy=1
	ORDER BY OITM.ItemName
				
-- Articulos Sin unidad de Ventas por Paquete.
	Select '335 ? SIN UM VENTAS' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat, OITM.DfltWH, oitm.ItmsGrpCod, OITB.ItmsGrpNam,
	OITM.U_GrupoPlanea, UFD1.Descr, OITM.U_estacion, OITM.InvntryUom,
	OITM.PurPackMsr, OITM.NumInBuy, OITM.BuyUnitMsr from OITM 
	inner join UFD1 on OITM.U_GrupoPlanea=UFD1.FldValue and UFD1.TableID='UITM'
	inner join OITB on OITM.ItmsGrpCod=OITB.ItmsGrpCod
	where OITM.SalPackMsr is null --and OITM.NumInBuy=1
	ORDER BY OITM.ItemName
				
-- VER-170829 ARTICULO CON LISTA DE MATERIALES Y NO TIENE MARCADAS PROPIEDADES.
	Select '340 ? ART. CON LDM Y SIN PROPI.' AS REPORTE, A3.ItemCode, ITT1.Father ,A3.ItemName, A3.U_TipoMat, A3.QryGroup29, A3.QryGroup30,
	A3.QryGroup31, A3.QryGroup32, A3.frozenFor
	from OITM A3
	left join ITT1 on A3.ItemCode = ITT1.Father    
	where ITT1.Father is not null and A3.U_TipoMat <> 'PT' and A3.QryGroup29 = 'N'  
	and A3.QryGroup30 = 'N' and A3.QryGroup31 = 'N' and A3.QryGroup32 = 'N'
	and A3.frozenFor = 'N'
	ORDER BY A3.ItemName	
	
	
-- ARTICULO PROPIEDAD 32 NO MARCADOS COMO SP.
	Select '345 ? ART. PROP-32 NO SP' AS REPORTE, A3.ItemCode, A3.ItemName, A3.U_TipoMat, A3.QryGroup29, A3.QryGroup30,
	A3.QryGroup31, A3.QryGroup32
	from OITM A3
	where A3.U_TipoMat <> 'SP' and A3.QryGroup32 = 'Y'
	ORDER BY A3.ItemName				
				
				
-- ARTICULOS PRODUCTOS TERMINADOS
-- Producto Terminado que no tiene almacen asignado APT-ST. 
	select '400 ! PT, SIN ALMA.' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat, OITM.DfltWH, OITM.ItmsGrpCod, OITM.U_estacion,
	OITM.PurPackMsr, OITM.NumInBuy, OITM.BuyUnitMsr from OITM 
	where U_TipoMat = 'PT' and OITM.DfltWH is null
	
	Update OITM set DfltWH = 'APT-ST'
	where U_TipoMat = 'PT' and OITM.DfltWH is null

-- Producto Terminado que tienen almacen Equivocado. 
	select '405 ? PT ALM. EQUIVOCADO' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat, OITM.DfltWH, OITM.ItmsGrpCod, OITM.U_estacion,
	OITM.PurPackMsr, OITM.NumInBuy, OITM.BuyUnitMsr from OITM 
	where U_TipoMat = 'PT' and OITM.DfltWH <> 'APT-ST' 
		
	-- VALIDAR ALMACEN DE BASE OITT CABECERA DE LDM PT. 
	Select '410 ! DFL CAB. LMD PT.' AS REPORTE, OITT.Code, A3.ItemName, A3.U_TipoMat, OITT.ToWH
	from OITT 
	inner join OITM A3 on OITT.Code = A3.ItemCode 
	where U_TipoMat = 'PT' and OITT.TOWH <> 'APT-ST'
	ORDER BY A3.ItemName

	Update OITT set OITT.ToWH = 'APT-ST'
	from OITT 
	inner join OITM A3 on OITT.Code = A3.ItemCode 
	where U_TipoMat = 'PT' and OITT.TOWH <> 'APT-ST'

-- Validar que los PT (ESTRUCTURA) CONSUMAN DEL APG-ST (NO KIT de VENTAS)
	Select '415 ! LDM PT. CONSUMA APG-ST' AS REPORTE, ITT1.Father, A3.ItemName, A3.U_TipoMat, ITT1.Code,A1.ItemName,ITT1.Warehouse
	from ITT1 
	inner join OITM A3 on A3.ItemCode=ITT1.Father
	inner join OITM A1 on A1.ItemCode=ITT1.Code
	where A3.U_TipoMat = 'PT' and ITT1.warehouse <> 'APG-ST' 
	and A1.ItmsGrpCod <> '113' and A3.InvntItem = 'Y'
	ORDER BY A3.ItemName

	
	Update ITT1 Set ITT1.Warehouse = 'APG-ST'
	from ITT1 
	inner join OITM A3 on A3.ItemCode=ITT1.Father
	inner join OITM A1 on A1.ItemCode=ITT1.Code
	where A3.U_TipoMat = 'PT' and ITT1.warehouse <> 'APG-ST' 
	and A1.ItmsGrpCod <> '113' and A3.InvntItem = 'Y'
	
-- Validar que los PT (ESTRUCTURA) CONSUMAN DEL APT-ST (KIT VENTAS)
	Select '420 ! LDM PT. CONSUMA APT-ST' AS REPORTE, ITT1.Father, A3.ItemName, A3.U_TipoMat, ITT1.Code,A1.ItemName,ITT1.Warehouse
	from ITT1 
	inner join OITM A3 on A3.ItemCode=ITT1.Father
	inner join OITM A1 on A1.ItemCode=ITT1.Code
	where A3.U_TipoMat = 'PT' and ITT1.warehouse <> 'APT-ST' 
	and A1.ItmsGrpCod <> '113' and A3.InvntItem = 'N'
	ORDER BY A3.ItemName
	
	Update ITT1 Set ITT1.Warehouse = 'APT-ST'
	from ITT1 
	inner join OITM A3 on A3.ItemCode=ITT1.Father
	inner join OITM A1 on A1.ItemCode=ITT1.Code
	where A3.U_TipoMat = 'PT' and ITT1.warehouse <> 'APT-ST' 
	and A1.ItmsGrpCod <> '113' and A3.InvntItem = 'N'
	
-- Articulos del Grupo Piel y no son Piel 
	select '425 ? ART. 113 Y NO DICE PIEL' AS REPORTE, OITM.ItemCode,OITM.ItemName, OITM.ItmsGrpCod, OITB.ItmsGrpNam, OITM.U_TipoMat
	from OITM
	inner join OITB on OITM.ItmsGrpCod=OITB.ItmsGrpCod
	where OITM.ItmsGrpCod='113' and OITM.ItemName not like '%PIEL%' 
	order by OITM.ItemName
		
-- Productos Terminados con Grupo de Planeacion diferente a Z PRODUCTO TERMINADO. */
	select '430 ? PT GRUPO PLAN MAL' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.ItmsGrpCod, OITM.U_TipoMat, OITM.U_GrupoPlanea 
	from OITM
	where U_TipoMat='PT' and U_GrupoPlanea<> 12 and U_GrupoPlanea<> 15 or
	U_TipoMat='PT' and U_GrupoPlanea is null
	order by OITM.ItemName
 
-- Producto Terminado con Numero de Modelo diferente 
	select '435 ? NUMERO MODELO NO IGUAL' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.ItmsGrpCod, SUBSTRING(OITM.ItemCode,1,4) As Mode, OITM.U_Modelo, OITM.U_TipoMat 
	from OITM
	where OITM.U_TipoMat = 'PT' and SUBSTRING(OITM.ItemCode,1,4) <> OITM.U_Modelo and OITM.ItemCode not like 'Z%'
	order by OITM.ItemName
		
-- Producto Terminado SIN Numero de Modelo. 
	select '440 ? NUMERO MODELO SIN NUMERO' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.ItmsGrpCod, SUBSTRING(OITM.ItemCode,1,4) As Mode, OITM.U_Modelo, OITM.U_TipoMat 
	from OITM
	where OITM.U_TipoMat = 'PT' and OITM.U_Modelo is null and OITM.ItemCode not like 'Z%'and OITM.ItemCode not like 'MES%'
	order by OITM.ItemName
		
--	Estructura de Salas PT con almacen diferente de Piel al AMP-ST  
	select '445 ? LDM ALM.DIF AMP-ST' AS REPORTE, ITT1.Father, A3.ItemName, ITT1.Code, A1.ItemName, ITT1.Warehouse
	from ITT1 
	inner join OITM A3 on ITT1.Father=A3.ItemCode
	inner join OITM A1 on ITT1.Code=A1.ItemCode
	Where ITT1.Warehouse <> 'AMP-ST' and A3.U_TipoMat='PT' and A1.U_TipoMat<> 'PT' and A1.ItmsGrpCod= '113'
	Order by A3.ItemName
	
	/* Para corregir utilizar...
		update ITT1 set wareHouse='AMP-ST'
		from ITT1 
		inner join OITM A3 on ITT1.Father=A3.ItemCode
		inner join OITM A1 on ITT1.Code=A1.ItemCode
		Where ITT1.Warehouse <> 'AMP-ST' and A3.U_TipoMat='PT' and A1.U_TipoMat<> 'PT' and A1.ItmsGrpCod= '113'
		*/
 
--	Estructura de consumen el material del AMP-CC 
	select '450 ? LDM CONSUME AMP-CC' AS REPORTE, ITT1.Father, A3.ItemName, ITT1.Code, A1.ItemName, ITT1.Warehouse
	from ITT1 
	inner join OITM A3 on ITT1.Father=A3.ItemCode
	inner join OITM A1 on ITT1.Code=A1.ItemCode
	Where ITT1.Warehouse = 'AMP-CC' and A1.ItmsGrpCod <> '113'
	Order by A3.ItemName
	
		/* Para corregir utilizar...
		update ITT1 set wareHouse='APP-ST'
		from ITT1 
		inner join OITM A3 on ITT1.Father=A3.ItemCode
		inner join OITM A1 on ITT1.Code=A1.ItemCode
		Where ITT1.Warehouse = 'AMP-CC' and A1.ItmsGrpCod <> '113'
		Order by A3.ItemName
		*/
		
-- Estructura de consumen el material del AMP-ST
	select '455 ? CONS. AMP-ST->APP-ST' AS REPORTE, ITT1.Father, A3.ItemName, ITT1.Code, A1.ItemName, ITT1.Warehouse
	from ITT1 
	inner join OITM A3 on ITT1.Father=A3.ItemCode
	inner join OITM A1 on ITT1.Code=A1.ItemCode
	Where ITT1.Warehouse = 'AMP-ST' and A1.ItmsGrpCod <> '113' and ITT1.Father <> '17621'
	and ITT1.Father <> '17620' and ITT1.Father <> '17691' and ITT1.Father <> '17701'
	and ITT1.Father <> '17822' and ITT1.Father <> '17814'  and ITT1.Father <> '18292'
	 and ITT1.Father <> '18288' and ITT1.Father <> '18262' and ITT1.Father <> '18627'
	 and ITT1.Father <> '18626' and ITT1.Father <> '18696' and ITT1.Father <> '18559'
	 and ITT1.Father <> '18761' and ITT1.Father <> '10436' and ITT1.Father <> '19416'
	 and ITT1.Father <> '19415' and ITT1.Father <> '19430'
	Order by A3.ItemName	
	
	
		/* Para corregir utilizar...
		 
		update ITT1 set wareHouse='AMP-ST'
		from ITT1 
		inner join OITM A3 on ITT1.Father=A3.ItemCode
		inner join OITM A1 on ITT1.Code=A1.ItemCode
		Where ITT1.Warehouse <> 'AMP-ST' and A3.U_TipoMat='PT' and A1.U_TipoMat<> 'PT' and A1.ItmsGrpCod= '113'
		*/
		
-- Articulos Valor Sala y Valor pago Diferentes.
	Select '460 ! VS DIFERENTE Y VSP' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_VS, OITM.U_VSPago
	from OITM
	where OITM.U_VS <> OITM.U_VSPago
	
	-- Actualizar a el dato de U_VS
	update OITM set U_VSPago = U_VS
	where OITM.U_VS <> OITM.U_VSPago
	
			
-- Articulo VENTAS que la suma de valor sala sea la de sus componentes, Capture correcto diseño.
-- Instalodo en Alarma en SAP.
	Select '465 ! VS DIFERENTE' AS REPORTE, A2.ItemCode, A2.ItemName, A2.U_TipoMat, A2.U_VS, B0.ValSal ,A2.SellItem, A2.InvntItem, A2.PrchseItem
	from OITM A2
	inner join (Select ITT1.Father, sum(A3.U_VS*ITT1.Quantity) As ValSal 
	from ITT1
	inner join OITM A3 on ITT1.Code=A3.ItemCode
	group by ITT1.Father ) B0 on A2.ItemCode= B0.Father
	where A2.U_TipoMat='PT' and A2.SellItem='Y' and A2.InvntItem='N' and A2.PrchseItem='N' and A2.U_VS<>B0.ValSal
	order by A2.ItemName 
		
		
-- Para corregir utilizar...  		 
		update A2 set A2.U_VS=B0.ValSal
		from OITM A2
		inner join (Select ITT1.Father, sum(A3.U_VS*ITT1.Quantity) As ValSal 
					from ITT1
					inner join OITM A3 on ITT1.Code=A3.ItemCode
					group by ITT1.Father ) B0 on A2.ItemCode= B0.Father
		where A2.U_TipoMat='PT' and A2.SellItem='Y' and A2.InvntItem='N' and A2.PrchseItem='N' and A2.U_VS<>B0.ValSal
	
	
		update A2 set A2.U_VSPago=B0.ValSal
		from OITM A2
		inner join (Select ITT1.Father, sum(A3.U_VS*ITT1.Quantity) As ValSal 
					from ITT1
					inner join OITM A3 on ITT1.Code=A3.ItemCode
					group by ITT1.Father ) B0 on A2.ItemCode= B0.Father
		where A2.U_TipoMat='PT' and A2.SellItem='Y' and A2.InvntItem='N' and A2.PrchseItem='N' and A2.U_VSPago<>B0.ValSal
		
-- Articulo Con Grupo de Planeacion Nulo (Asignar segun el material).
	select '500 ? SIN GPO. PLANEA' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.ItmsGrpCod, OITM.U_TipoMat, OITM.U_GrupoPlanea 
	from OITM
	where OITM.U_GrupoPlanea is null 
	order by OITM.ItemName
 

-- SUB-ENSAMBLES
-- Debe tener activada la Propiedad 32
	Select '505 ? PROP-32' AS REPORTE, OITM.U_TipoMat, OITM.ItemCode, OITM.ItemName,
	OITM.InvntryUom, OITM.OnHand, QryGroup32, OITM.frozenFor
	from OITM 
	where OITM.U_TipoMat='SP' and OITM.QryGroup32 <> 'Y'
	and OITM.frozenFor = 'N'
	Order by OITM.ItemName


-- Articulos que les quitaron Retencion de Impuestos.
	Select '510 ? SIN RET. IMP.' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.WTLiable
	from OITM
	where OITM.WTLiable = 'N'

-- Articulos que les quitaron Sujeto a Impuestos de Impuestos.
	Select '515 ? SIN SUJ. IMP.' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.VATLiable
	from OITM
	where OITM.VATLiable = 'N'

-- Articulos con Tipo Oficial
	-- MP Materias Primas.
	-- MA Materiales Solo se tenia Pedacera de Piel y agregue a MP
	-- SP Sub-Productos.
	-- CA Casco.
	-- PT Producto Terminado.
	-- RF Refacciones y Cualquier otra cosa.
	
	Select '520 ? TIPO MAT. NO OFICIAL' AS REPORTE, OITM.U_TipoMat, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, 
	OITM.OnHand, OITM.AvgPrice, (OITM.OnHand*OITM.AvgPrice) as Imp_Std,
	LCO.Price , LCO.Currency 
	from OITM 
	inner join ITM1 LCO on OITM.ItemCode=LCO.ItemCode and LCO.PriceList=9 
	where OITM.U_TipoMat <> 'MP' and OITM.U_TipoMat <> 'SP' and
	OITM.U_TipoMat <> 'CA' and OITM.U_TipoMat <> 'PT' and OITM.U_TipoMat <> 'RF'  
	Order by OITM.ItemName 
	
    /*  Para corregir usar --
	Update OITM SET U_TipoMat = 'RF'
	where OITM.U_TipoMat = 'SE'
	*/
	
-- Clave de Productos y Servicios para Salas Kit de Ventas.
	Select '525 ! SALAS C. PROD. SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.U_TipoMat = 'PT' and OITM.InvntItem = 'N' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 56101532
	where OITM.U_TipoMat = 'PT' and OITM.InvntItem = 'N' and (OITM.U_ClaveProdServ is null)

-- Clave de Unidad de medida para Salas Kit de Ventas.
	Select '530 ! SALAS C. UM. SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.U_TipoMat = 'PT' and OITM.InvntItem = 'N' and (OITM.U_ClaveUnidad is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveUnidad = '10'
	where OITM.U_TipoMat = 'PT' and OITM.InvntItem = 'N' and (OITM.U_ClaveUnidad is null)

-- Clave de Productos y Servicios para Muebles y Articulos que son Inventariables.
-- Se realiza en funcion a los Grupos de Articulos.
-- Select OITB.ItmsGrpCod, OITB.ItmsGrpNam from OITB Order by OITB.ItmsGrpNam

	Select '535 ! ART. REFACCIONES CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 134 and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 56101907
	where OITM.ItmsGrpCod = 134 and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 56101907
	where OITM.ItmsGrpCod = 134 and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 56101907)

	Select '540 ! ART. MUEBLES CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where (OITM.ItmsGrpCod = 145 or OITM.ItmsGrpCod = 117 or OITM.ItmsGrpCod = 121 or OITM.ItmsGrpCod = 123
	or OITM.ItmsGrpCod = 124 or OITM.ItmsGrpCod = 125 or OITM.ItmsGrpCod = 126 or OITM.ItmsGrpCod = 127
	or OITM.ItmsGrpCod = 128) 
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 56101500
	where (OITM.ItmsGrpCod = 145 or OITM.ItmsGrpCod = 117 or OITM.ItmsGrpCod = 121 or OITM.ItmsGrpCod = 123
	or OITM.ItmsGrpCod = 124 or OITM.ItmsGrpCod = 125 or OITM.ItmsGrpCod = 126 or OITM.ItmsGrpCod = 127
	or OITM.ItmsGrpCod = 128) 
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 56101500
	where (OITM.ItmsGrpCod = 145 or OITM.ItmsGrpCod = 117 or OITM.ItmsGrpCod = 121 or OITM.ItmsGrpCod = 123
	or OITM.ItmsGrpCod = 124 or OITM.ItmsGrpCod = 125 or OITM.ItmsGrpCod = 126 or OITM.ItmsGrpCod = 127
	or OITM.ItmsGrpCod = 128) 
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 56101500)

	Select '545 ! ART. SERVICIOS CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 135 
	and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 81141800
	where OITM.ItmsGrpCod = 135 
	and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 81141800
	where OITM.ItmsGrpCod = 135 
	and (OITM.U_ClaveProdServ <> 81141800)
	
	Select '550 ! ART. COMPLEMENTOS CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where (OITM.ItmsGrpCod = 118 or OITM.ItmsGrpCod = 119 or OITM.ItmsGrpCod = 120 or OITM.ItmsGrpCod = 122
	or OITM.ItmsGrpCod = 129) 
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 56101900
	where (OITM.ItmsGrpCod = 118 or OITM.ItmsGrpCod = 119 or OITM.ItmsGrpCod = 120 or OITM.ItmsGrpCod = 122
	or OITM.ItmsGrpCod = 129) 
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 56101900
	where (OITM.ItmsGrpCod = 118 or OITM.ItmsGrpCod = 119 or OITM.ItmsGrpCod = 120 or OITM.ItmsGrpCod = 122
	or OITM.ItmsGrpCod = 129) 
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 56101900)
	
	Select '555 ! ART. HULE ESPUMA CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 109
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 13111300
	where OITM.ItmsGrpCod = 109
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 13111300
	where OITM.ItmsGrpCod = 109
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 13111300)

	Select '560 ! ART. BANDA Y RESORTE CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 116
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 31151900
	where OITM.ItmsGrpCod = 116
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 31151900
	where OITM.ItmsGrpCod = 116
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 31151900)

	Select '565 ! ART. CARTON CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 106
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 31261500
	where OITM.ItmsGrpCod = 106
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 31261500
	where OITM.ItmsGrpCod = 106
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 31261500)

	Select '570 ! ART. LACAS-ESMALTES CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 110
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 31211700
	where OITM.ItmsGrpCod = 110
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 31211700
	where OITM.ItmsGrpCod = 110
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 31211700)

	Select '575 ! ART. CIERRES CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 111
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 53141500
	where OITM.ItmsGrpCod = 111
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 53141500
	where OITM.ItmsGrpCod = 111
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 53141500)

	Select '580 ! ART. CINTAS CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 143
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 31201500
	where OITM.ItmsGrpCod = 143
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 31201500
	where OITM.ItmsGrpCod = 143
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 31201500)

	Select '585 ! ART. GUATAS CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 138
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 11162400
	where OITM.ItmsGrpCod = 138
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 11162400
	where OITM.ItmsGrpCod = 138
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 11162400)

	Select '590 ! ART. CUEROS CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 113
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 11162300
	where OITM.ItmsGrpCod = 113
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 11162300
	where OITM.ItmsGrpCod = 113
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 11162300)

	Select '595 ! ART. PLUMONES CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 112
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 52121507
	where OITM.ItmsGrpCod = 112
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 52121507
	where OITM.ItmsGrpCod = 112
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 52121507)

	Select '600 ! ART. HILOS CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 142
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 11151700
	where OITM.ItmsGrpCod = 142
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 11151700
	where OITM.ItmsGrpCod = 142
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 11151700)

	Select '605 ! ART. MADERAS CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where (OITM.ItmsGrpCod = 100 OR  OITM.ItmsGrpCod = 101) 
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 30103600
	where (OITM.ItmsGrpCod = 100 OR  OITM.ItmsGrpCod = 101) 
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 30103600
	where (OITM.ItmsGrpCod = 100 OR  OITM.ItmsGrpCod = 101) 
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 30103600)

	Select '610 ! ART. TORNILLOS CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 141
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 31161500
	where OITM.ItmsGrpCod = 141
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 31161500
	where OITM.ItmsGrpCod = 141
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 31161500)

	Select '615 ! ART. GRAPAS CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 107
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 31162400
	where OITM.ItmsGrpCod = 107
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 31162400
	where OITM.ItmsGrpCod = 107
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 31162400)

	Select '620 ! ART. POLIETILENO CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 105
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 13111200
	where OITM.ItmsGrpCod = 105
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 13111200
	where OITM.ItmsGrpCod = 105
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 13111200)

	Select '625 ! ART. POLIPACK CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 140
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 31181700
	where OITM.ItmsGrpCod = 140
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 31181700
	where OITM.ItmsGrpCod = 140
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 31181700)

	Select '630 ! ART. TELAS CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 114
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 11161800
	where OITM.ItmsGrpCod = 114
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 11161800
	where OITM.ItmsGrpCod = 114
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 11161800)

	Select '635 ! ART. DE LIMPIEZA CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 130
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 47121900
	where OITM.ItmsGrpCod = 130
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 47121900
	where OITM.ItmsGrpCod = 130
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 47121900)

	Select '640 ! ART. ISUMOS CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where (OITM.ItmsGrpCod = 115 OR OITM.ItmsGrpCod = 132) 
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 14101500
	where (OITM.ItmsGrpCod = 115 OR OITM.ItmsGrpCod = 132)
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 14101500
	where (OITM.ItmsGrpCod = 115 OR OITM.ItmsGrpCod = 132)
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 14101500)

	Select '645 ! ART. PAPELERIA CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 133
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 44121600
	where OITM.ItmsGrpCod = 133
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 44121600
	where OITM.ItmsGrpCod = 133
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 44121600)

	Select '650 ! ART. HERRAMIENTA CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 131
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 27112100
	where OITM.ItmsGrpCod = 131
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 27112100
	where OITM.ItmsGrpCod = 131
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 27112100)

	Select '655 ! ART. GASTOS CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 136
	and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 78121600
	where OITM.ItmsGrpCod = 136
	and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 78121600
	where OITM.ItmsGrpCod = 136
	and (OITM.U_ClaveProdServ <> 78121600)
	
	Select '660 ! ART. MAQUILAS CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 139
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 72152300
	where OITM.ItmsGrpCod = 139
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 72152300
	where OITM.ItmsGrpCod = 139
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 72152300)

	Select '665 ! ART. GASTOS CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where (OITM.ItmsGrpCod = 102 OR OITM.ItmsGrpCod = 103 OR OITM.ItmsGrpCod = 104)
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 76122405
	where (OITM.ItmsGrpCod = 102 OR OITM.ItmsGrpCod = 103 OR OITM.ItmsGrpCod = 104)
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 76122405
	where (OITM.ItmsGrpCod = 102 OR OITM.ItmsGrpCod = 103 OR OITM.ItmsGrpCod = 104)
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 76122405)

	Select '670 ! ART. HERRAJES CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.ItmsGrpCod = 108
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveProdServ = 72154024
	where OITM.ItmsGrpCod = 108
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ is null)

	Update OITM set OITM.U_ClaveProdServ = 72154024
	where OITM.ItmsGrpCod = 108
	and OITM.InvntItem = 'Y' and (OITM.U_ClaveProdServ <> 72154024)

-- Articulos sin Clave de Productos del SAT
	Select '675 ! ART. SIN CLV-SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad, OITM.ItmsGrpCod
	from OITM 
	where OITM.U_ClaveProdServ is null
	Order by OITM.ItemName

--Las Unidades del las materias primas correran en funcion a la unidad de inventario.
-- Clave de Unidad y Servicios para Salas Kit de Ventas.
	Select '680 ! PT. SIN UM. PZA SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.InvntryUom = 'PZA'  AND OITM.U_TipoMat = 'PT' AND ((OITM.U_ClaveUnidad <> '10' AND OITM.U_ClaveUnidad <> 'H87') OR OITM.U_ClaveUnidad IS NULL )
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveUnidad = 'H87' where OITM.InvntryUom = 'PZA'  AND OITM.U_TipoMat = 'PT' AND ((OITM.U_ClaveUnidad <> '10' AND OITM.U_ClaveUnidad <> 'H87') OR OITM.U_ClaveUnidad IS NULL )
	
	Select '685 ! ART. SIN UM. PZA SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.InvntryUom = 'PZA'  AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'H87' OR OITM.U_ClaveUnidad IS NULL)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveUnidad = 'H87' where OITM.InvntryUom = 'PZA'  AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'H87' OR OITM.U_ClaveUnidad IS NULL)

	Select '690 ! ART. SIN UM. MT2 SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.InvntryUom = 'MT2'  AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'MTK' OR OITM.U_ClaveUnidad IS NULL)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveUnidad = 'MTK' WHERE OITM.InvntryUom = 'MT2'  AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'MTK' OR OITM.U_ClaveUnidad IS NULL)
	
	Select '695 ! ART. SIN UM. JGO SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.InvntryUom = 'JGO' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> '10' OR OITM.U_ClaveUnidad IS NULL)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveUnidad = '10' WHERE OITM.InvntryUom = 'JGO'  AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> '10' OR OITM.U_ClaveUnidad IS NULL)
	
	Select '700 ! ART. SIN UM. DC2 SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.InvntryUom = 'DC2' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'DMK' OR OITM.U_ClaveUnidad IS NULL)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveUnidad = 'DMK' WHERE OITM.InvntryUom = 'DC2' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'DMK' OR OITM.U_ClaveUnidad IS NULL)
	
	Select '705 ! ART. SIN UM. MTS SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.InvntryUom = 'MTS' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'LM' OR OITM.U_ClaveUnidad IS NULL)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveUnidad = 'LM' WHERE OITM.InvntryUom = 'MTS' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'LM' OR OITM.U_ClaveUnidad IS NULL)

	Select '710 ! ART. SIN UM. LTS SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.InvntryUom = 'LTS' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'LTR' OR OITM.U_ClaveUnidad IS NULL)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveUnidad = 'LTR' WHERE OITM.InvntryUom = 'LTS' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'LTR' OR OITM.U_ClaveUnidad IS NULL)

	Select '715 ! ART. SIN UM. ML SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.InvntryUom = 'ML' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'MLT' OR OITM.U_ClaveUnidad IS NULL)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveUnidad = 'MLT' WHERE OITM.InvntryUom = 'ML' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'MLT' OR OITM.U_ClaveUnidad IS NULL)

	Select '720 ! ART. SIN UM. KGS SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.InvntryUom = 'KGS' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'KGM' OR OITM.U_ClaveUnidad IS NULL)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveUnidad = 'KGM' WHERE OITM.InvntryUom = 'KGS' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'KGM' OR OITM.U_ClaveUnidad IS NULL)

	Select '725 ! ART. SIN UM. CUBETA SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.InvntryUom = 'CUBETA' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'XBJ' OR OITM.U_ClaveUnidad IS NULL)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveUnidad = 'XBJ' WHERE OITM.InvntryUom = 'CUBETA' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'XBJ' OR OITM.U_ClaveUnidad IS NULL)

	Select '730 ! ART. SIN UM. ROLLO SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.InvntryUom = 'ROLLO' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'XRO' OR OITM.U_ClaveUnidad IS NULL)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveUnidad = 'XRO' WHERE OITM.InvntryUom = 'ROLLO' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'XRO' OR OITM.U_ClaveUnidad IS NULL)

	Select '735 ! ART. SIN UM. ROLLO SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.InvntryUom = 'ROLLO' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'XRO' OR OITM.U_ClaveUnidad IS NULL)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveUnidad = 'XRO' WHERE OITM.InvntryUom = 'ROLLO' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'XRO' OR OITM.U_ClaveUnidad IS NULL)

	Select '740 ! ART. SIN UM. FT2 SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.InvntryUom = 'FT2' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'FTK' OR OITM.U_ClaveUnidad IS NULL)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveUnidad = 'FTK' WHERE OITM.InvntryUom = 'FT2' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'FTK' OR OITM.U_ClaveUnidad IS NULL)

	Select '745 ! ART. SIN UM. FT3 SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.InvntryUom = 'FT3' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'BFT' OR OITM.U_ClaveUnidad IS NULL)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveUnidad = 'BFT' WHERE OITM.InvntryUom = 'FT3' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'BFT' OR OITM.U_ClaveUnidad IS NULL)

	Select '750 ! ART. SIN UM. MIN SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.InvntryUom = 'MIN' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'MIN' OR OITM.U_ClaveUnidad IS NULL)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveUnidad = 'MIN' WHERE OITM.InvntryUom = 'MIN' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'MIN' OR OITM.U_ClaveUnidad IS NULL)

	Select '755 ! ART. SIN UM. CAJA SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.InvntryUom = 'CAJA' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'XBX' OR OITM.U_ClaveUnidad IS NULL)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveUnidad = 'XBX' WHERE OITM.InvntryUom = 'CAJA' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'XBX' OR OITM.U_ClaveUnidad IS NULL)

	Select '760 ! ART. SIN UM. PAQ SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.InvntryUom = 'PAQ' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'XPK' OR OITM.U_ClaveUnidad IS NULL)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveUnidad = 'XPK' WHERE OITM.InvntryUom = 'PAQ' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'XPK' OR OITM.U_ClaveUnidad IS NULL)

	Select '765 ! ART. SIN UM. YDS SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.InvntryUom = 'YDS' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'YRD' OR OITM.U_ClaveUnidad IS NULL)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveUnidad = 'YRD' WHERE OITM.InvntryUom = 'YDS' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'YRD' OR OITM.U_ClaveUnidad IS NULL)

	Select '770 ! ART. SIN UM. PAR SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.InvntryUom = 'PAR' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'PR' OR OITM.U_ClaveUnidad IS NULL)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveUnidad = 'PR' WHERE OITM.InvntryUom = 'PAR' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'PR' OR OITM.U_ClaveUnidad IS NULL)

	Select '775 ! ART. SIN UM. PESOS SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.InvntryUom = 'PESOS' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'M4' OR OITM.U_ClaveUnidad IS NULL)
	Order by OITM.ItemName
	
	Update OITM set OITM.U_ClaveUnidad = 'M4' WHERE OITM.InvntryUom = 'PESOS' AND OITM.U_TipoMat <> 'PT' AND (OITM.U_ClaveUnidad <> 'M4' OR OITM.U_ClaveUnidad IS NULL)

	Select '780 ? ART. SIN UM. SAT' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_TipoMat, 
	OITM.SellItem, OITM.InvntItem, OITM.U_ClaveProdServ, OITM.U_ClaveUnidad
	from OITM 
	where OITM.U_ClaveUnidad IS NULL
	Order by OITM.ItemName
	
	



	Select '785 ! BLOQUEADOS' as REPORTE,
			OITM.ItemCode as CODIGO,
			OITM.ItemName as MATERIAL,
			OITM.InvntryUom as UDM,
			OITW.Locked as BLOQUEO
	from OITM
	inner join OITW on OITM.ItemCode = OITW.ItemCode
	Where OITW.Locked = 'Y'

	update OITW set OITW.Locked = 'N'
	from OITM
	inner join OITW on OITM.ItemCode = OITW.ItemCode
	Where OITW.Locked = 'Y'

-- ALMACEN CUSTODIA FINANZAS DEBEN ESTAR BLOQUEADO PARA TODOS LOS ARTICULOS.
	-- Almacen Custodia de Producto Terminado.
	--select '785! TENER BLOQUEADO AXL-AC' AS REPORTE, oitm.ItemCode as Codigo, 
	--OITM.ItemName as Nombre, OITM.InvntryUom, OITW.OnHand as Existencia,
	-- OITW.WhsCode, OITW.Locked
	--from OITW 
	--inner join OITM on OITM.ItemCode=OITW.ItemCode and WhsCode='AXL-AC'
	--where OITW.Locked = 'N' 
	---order by OITM.ItemName
	
	--update OITW set OITW.Locked = 'N'
	--from OITW 
	--inner join OITM on OITM.ItemCode=OITW.ItemCode and WhsCode='AXL-AC'
	--where OITW.Locked = 'Y' 

	-- Almacen de Custodia WIP
	--Desbloqueo para cargar diferencias de Casco 11 abril 19
	--select '1306 ! TENER BLOQUEADO ATL-RS' AS REPORTE, oitm.ItemCode as Codigo, 
	--OITM.ItemName as Nombre, OITM.InvntryUom, OITW.OnHand as Existencia,
	 --OITW.WhsCode, OITW.Locked
	--from OITW 
	--inner join OITM on OITM.ItemCode=OITW.ItemCode and WhsCode='ATL-RS'
	--where OITW.Locked = 'N' 
	--order by OITM.ItemName
	
	--update OITW set OITW.Locked = 'N'
	--from OITW 
	--inner join OITM on OITM.ItemCode=OITW.ItemCode and WhsCode='ARF-ST'
	--where OITW.Locked = 'Y' 

	-- Almacen de Custodia de Guadalajara
	-- Se desbloquea para que cargue PT que se trajo de Lerma 29/Mar/19
	--select '1304 ! TENER BLOQUEADO ATG-FX' AS REPORTE, oitm.ItemCode as Codigo, 
	--OITM.ItemName as Nombre, OITM.InvntryUom, OITW.OnHand as Existencia,
	 --OITW.WhsCode, OITW.Locked
	--from OITW 
	--inner join OITM on OITM.ItemCode=OITW.ItemCode and WhsCode='ATG-FX'
	--where OITW.Locked = 'N' 
	--order by OITM.ItemName
	
	--update OITW set OITW.Locked = 'N'
	--from OITW 
	--inner join OITM on OITM.ItemCode=OITW.ItemCode and WhsCode='ATG-FX'
	--where OITW.Locked = 'Y' 

	-- Solicito Marcos volver a abrir para que se carguen ahi las diferencias.
	-- El 08 de Marzo del 2018 en Lerma.
	-- 28 de Agosto 2018, se paso a APG-ST y se activo bloqueo. 
	--select '1335! TENER BLOQUEADO APT-FX' AS REPORTE, oitm.ItemCode as Codigo, 

	-- SE VOLVIO A ACTIVAR PARA MANEJO DE FERNANDO EN ALMACEN

	--OITM.ItemName as Nombre, OITM.InvntryUom, OITW.OnHand as Existencia,
	 --OITW.WhsCode, OITW.Locked
	--from OITW 
	--inner join OITM on OITM.ItemCode=OITW.ItemCode and WhsCode='APT-FX'
	--where OITW.Locked = 'N' 
	--order by OITM.ItemName
	
	--update OITW set OITW.Locked = 'Y'
	--from OITW 
	--inner join OITM on OITM.ItemCode=OITW.ItemCode and WhsCode='APT-FX'
	--where OITW.Locked = 'N' 
	

/* USE PARA ASIGNACION GENERICA HAY QUE ACTUALIZAR MANUALMENTE

	-- Actualiza Estacion de Consumo de los Articulos, Segun el grupo de Material. 
	--Select DISTINCT OITM.ItmsGrpCod from OITM order by oitm.ItmsGrpCod (39)
	--Select DISTINCT OITM.U_estacion from OITM order by oitm.U_estacion (23 se usaran 12)

	-- Validar que los materiales contenidos en el Grupo Correspondan al uso.
	DECLARE @Estacion VARCHAR(10)
	DECLARE @Grupo VARCHAR(10)
	Set @Estacion = '112'
	Set @Grupo = '113'
	 
	Select Itemcode, ItemName, InvntryUom, U_estacion
	from OITM
	Where OITM.ItmsGrpCod = @Grupo

	Update OITM set U_estacion = @Estacion Where OITM.ItmsGrpCod = @Grupo  and U_estacion <> @Estacion

	--Estacion de Consumo del Material		Grupo de Articulos.	
		--Name	Orden	Código	Nombre
		-- Refacciones y Servicios, se consumen en su entrega.
		--109	109 Anaquel de Corte	
			--130	RF ARTICULOS DE LIMP
			--131	RF HERRAMIENTA
			--132	RF INSUMOS
			--133	RF PAPELERIA
			--134	RF REFACCIONES
			--135	SE SERVICIOS

		-- Material Piel, cosumido despues de Inspeccion.
		--112	112 Corte	
			--113	MP PIEL.

		-- Material de Telas, consumido despues de Pegado para Costura.
		--118	118 Pegado para Costura	
			--114	MP TELAS.

		-- Materiales para Costura.
		--136	136 Inspeccionar Costura
			--111	MP CIERRES.
			--142	MP HILOS.
			--143	MP CINTAS.

		--Materiales para Cojineria
		--148	148 Fundas Terminadas	
			--112	MP PLUMAS.
			--138	MP DELCRON.
			--109	MP HULE ESPUMA.

		--Materiales para Tapiceria y Diversos.
		--160	160 Armado de Tapiz
			--101	CA CASCO
			--115	MP DIVERSOS.
			--139	MP MAQUILAS.
			--141	MP TORNILLOS-CLAVOS-
			--107	MP GRAPAS.
			--108	MP HERRAJES Y METAL.

		--Materiales para Empacar el Producto.
		--172	172 Empaque	
			--105	MP POLIETILENO.
			--106	MP CARTON.
			--140	MP POLIPACK.

		--Cuotas de Manos de Obras hasta que se entregue el PT.	
		--175	175 Inspeccion Final	
			--102	CUOTA GASTOS FIJOS
			--103	CUOTA GASTOS VARIABL
			--104	CUOTA MANO DE OBRA
			--136	GC GASTOS DE COMPRA

		--Materiales consumo en Carpinteria.
		--406	406 Armado	
			--100	MP MADERA.

		--415	415 Pegado Hule / Terminado	
			--116	MP BANDA Y RESORTE.
			--110	MP LACAS-ESMALTES.

		-- Producto Terminado, Sin Estacion.
		--99	099 Sin Ubicacion
			--117	PT CLASICO
			--118	PT COJINES
			--119	PT COMODAS Y BUROES
			--120	PT COMPLEMENTOS
			--121	PT INTERACTIV
			--122	PT MESAS
			--123	PT MODERNISTA
			--124	PT MULTIFUNCIONAL
			--125	PT PROTOTIPOS
			--126	PT RECAMARAS
			--127	PT RECLINABLES
			--128	PT SOFA CAMA
			--129	PT TAPETES
			--145	PT CINES
*/

-- Producto Terminado que tienen almacen Equivocado. 
	select '790 ? CINTILLO ALM. EQUIVOCADO' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat, OITM.DfltWH, OITM.ItmsGrpCod, OITM.U_estacion,
	OITM.PurPackMsr, OITM.NumInBuy, OITM.BuyUnitMsr from OITM 
	where ItemCode = '3778-42-P0201' and OITM.DfltWH <> 'APG-ST' 
		
	-- VALIDAR ALMACEN DE BASE OITT CABECERA DE LDM PT. 
	Select '795 ! DFL CAB. LMD CINTILLO.' AS REPORTE, OITT.Code, A3.ItemName, A3.U_TipoMat, OITT.ToWH
	from OITT 
	inner join OITM A3 on OITT.Code = A3.ItemCode 
	where ItemCode = '3778-42-P0201' and OITT.TOWH <> 'APG-ST'
	ORDER BY A3.ItemName

	Update OITT set OITT.ToWH = 'APG-ST'
	from OITT 
	inner join OITM A3 on OITT.Code = A3.ItemCode 
	where ItemCode = '3778-42-P0201' and OITT.TOWH <> 'APG-ST'


-- GRUPO PARA EL BLOQUEO DE ALMACENES SEGUN SU CONTENIDO.
/*
-- ALMACEN NO SE USA 01 DEBE ESTAR BLOQUEADO PARA TODOS LOS ARTICULOS.
	Select '800! TENER BLOQUEADO ALM-01' AS REPORTE, oitm.ItemCode as CODIGO, 
	OITM.ItemName as ARTICULO, OITM.InvntryUom as UDM, OITW.OnHand as EXISTENCIA,
	 OITW.WhsCode as ALMACEN, OITW.Locked as BLOQUEADO
	from OITW 
	inner join OITM on OITM.ItemCode=OITW.ItemCode and WhsCode='01'
	where OITW.Locked = 'N' 
	order by OITM.ItemName
	
	update OITW set OITW.Locked = 'Y'
	from OITW 
	inner join OITM on OITM.ItemCode=OITW.ItemCode and WhsCode='01'
	where OITW.Locked = 'N' 

-- ALMACENES QUE PUEDEN CONTENER ARTICULO PIEL, EL RESTO BLOQUEAR. 
	Select '805 ! PIEL -> BLOQUEO' AS REPORTE, OITM.ItemCode as CODIGO, 
	OITM.ItemName as ARTICULO, OITM.InvntryUom, OITW.WhsCode as ALMACEN, 
	OITW.Locked as BLOQUEADO
	from OITW 
	inner join OITM on OITM.ItemCode=OITW.ItemCode and (WhsCode <>'AMP-ST' 
	AND WhsCode <>'AMP-CC' AND WhsCode <>'AMP-FE' AND WhsCode <>'APT-FX' AND WhsCode <>'APG-ST'
	AND WhsCode <>'APT-PR' AND WhsCode <>'APT-SE' AND WhsCode <>'ATL-DS' AND WhsCode <>'AMG-ST'
	AND WhsCode <>'AMP-TR' AND  WhsCode <>'AMP-CO')
	where OITW.Locked = 'N' and OITM.ItmsGrpCod = '113'
	order by OITM.ItemName
	
	update OITW set OITW.Locked = 'Y'
	from OITW 
	inner join OITM on OITM.ItemCode=OITW.ItemCode and (WhsCode <>'AMP-ST' 
	AND WhsCode <>'AMP-CC' AND WhsCode <>'AMP-FE' AND WhsCode <>'APT-FX' AND WhsCode <>'APG-ST'
	AND WhsCode <>'APT-PR' AND WhsCode <>'APT-SE' AND WhsCode <>'ATL-DS' AND WhsCode <>'AMG-ST'
	AND WhsCode <>'AMP-TR' AND  WhsCode <>'AMP-CO')
	where OITW.Locked = 'N' and OITM.ItmsGrpCod = '113'


-- ALMACENES QUE PUEDEN CONTENER ARTICULO CASCO, EL RESTO BLOQUEAR. 
	Select '810 ! CASCO -> BLOQUEO' AS REPORTE, OITM.ItemCode as CODIGO, 
	OITM.ItemName as ARTICULO, OITM.InvntryUom, OITW.WhsCode as ALMACEN, 
	OITW.Locked as BLOQUEADO
	from OITW 
	inner join OITM on OITM.ItemCode=OITW.ItemCode and (WhsCode <>'APG-PA' 
	AND WhsCode <>'APT-PA' AND WhsCode <>'ATL-RS' AND WhsCode <>'APP-ST'
	AND WhsCode <>'APG-ST' AND WhsCode <>'APT-SE' AND WhsCode <>'ATL-DS' AND WhsCode <>'AMG-FE'
	AND WhsCode <>'AMP-TR' AND WhsCode <>'APT-TR')
	where OITW.Locked = 'N' and OITM.U_TipoMat = 'CA'
	order by OITM.ItemName
	
	update OITW set OITW.Locked = 'Y'
	from OITW 
	inner join OITM on OITM.ItemCode=OITW.ItemCode and (WhsCode <>'APG-PA' 
	AND WhsCode <>'APT-PA' AND WhsCode <>'ATL-RS' AND WhsCode <>'APP-ST'
	AND WhsCode <>'APG-ST' AND WhsCode <>'APT-SE' AND WhsCode <>'ATL-DS' AND WhsCode <>'AMG-FE'
	AND WhsCode <>'AMP-TR' AND WhsCode <>'APT-TR')
	where OITW.Locked = 'N' and OITM.U_TipoMat = 'CA'

-- ALMACENES QUE PUEDEN CONTENER ARTICULO HABILITADO, EL RESTO BLOQUEAR. 
	Select '815 ! HAB.CASCO -> BLOQUEO' AS REPORTE, OITM.ItemCode as CODIGO, 
	OITM.ItemName as ARTICULO, OITM.InvntryUom, OITW.WhsCode as ALMACEN, 
	OITW.Locked as BLOQUEADO
	from OITW 
	inner join OITM on OITM.ItemCode=OITW.ItemCode and WhsCode <>'APG-ST' 
	where OITW.Locked = 'N' and  OITM.QryGroup30='Y'
	order by OITM.ItemName
	
	update OITW set OITW.Locked = 'Y'
	from OITW 
	inner join OITM on OITM.ItemCode=OITW.ItemCode and WhsCode <>'APG-ST' 
	where OITW.Locked = 'N' and OITM.QryGroup30='Y'


-- ALMACENES APP-ST BLOQUEADOS PARA MP, SP Y RF NO SEAN HABILITADOS. 
	Select '820 ! MP-SP-RF -> BK APP-ST' AS REPORTE, OITM.ItemCode as CODIGO, 
	OITM.ItemName as ARTICULO, OITM.InvntryUom, OITW.WhsCode as ALMACEN, 
	OITW.Locked as BLOQUEADO
	from OITW 
	inner join OITM on OITM.ItemCode=OITW.ItemCode and WhsCode = 'APP-ST' 
	--OR WhsCode = 'APT-PA'
	where OITW.Locked = 'N' and OITM.ItmsGrpCod <> '113' and U_TipoMat <> 'CA'
	and U_TipoMat <> 'PT' and  OITM.QryGroup30='N'
	order by OITM.ItemName
	
	update OITW set OITW.Locked = 'Y'
	from OITW 
	inner join OITM on OITM.ItemCode=OITW.ItemCode and WhsCode = 'APP-ST' 
	where OITW.Locked = 'N' and OITM.ItmsGrpCod <> '113' and U_TipoMat <> 'CA'
	and U_TipoMat <> 'PT' and  OITM.QryGroup30='N'

-- ALMACENES APT-PA BLOQUEADOS PARA MP, SP Y RF NO SEAN HABILITADOS. 
	Select '825 ! MP-SP-RF -> BK APT-PA' AS REPORTE, OITM.ItemCode as CODIGO, 
	OITM.ItemName as ARTICULO, OITM.InvntryUom, OITW.WhsCode as ALMACEN, 
	OITW.Locked as BLOQUEADO
	from OITW 
	inner join OITM on OITM.ItemCode=OITW.ItemCode and WhsCode = 'APT-PA'
	where OITW.Locked = 'N' and OITM.ItmsGrpCod <> '113' and U_TipoMat <> 'CA'
	and U_TipoMat <> 'PT' and  OITM.QryGroup30='N'
	order by OITM.ItemName
	
	update OITW set OITW.Locked = 'Y'
	from OITW 
	inner join OITM on OITM.ItemCode=OITW.ItemCode and WhsCode = 'APT-PA'
	where OITW.Locked = 'N' and OITM.ItmsGrpCod <> '113' and U_TipoMat <> 'CA'
	and U_TipoMat <> 'PT' and  OITM.QryGroup30='N'


-- Almacen Bloqueado y no debe estarlo APT-PA, APP-ST y que no sean Piel 
		select '615 ? ALM. BLOQ. WIP' AS REPORTE, oitm.ItemCode as Codigo, OITM.ItemName as Habilitados, OITM.InvntryUom, OITW.OnHand as Existencia,
		OITW.WhsCode, OITW.Locked
		from oitm 
		inner join OITW on OITM.ItemCode=OITW.ItemCode and WhsCode='APT-PA'
		where OITW.Locked='Y' and OITM.ItmsGrpCod <> '113'
		order by OITM.ItemName
		
		select '622 ? PIEL NO LOCK APP-ST' AS REPORTE, oitm.ItemCode as Codigo, OITM.ItemName as Habilitados, OITM.InvntryUom, OITW.OnHand as Existencia,
		OITW.WhsCode, OITW.Locked
		from oitm 
		inner join OITW on OITM.ItemCode=OITW.ItemCode and WhsCode='APP-ST'
		where OITW.Locked='Y' and OITM.ItmsGrpCod <> '113' and OITM.ItemCode <> '19187'
		and OITM.ItemCode <> '13382'
		order by OITM.ItemName

-- ALMACEN ARF-ST ESTARA BLOQUEADO PP MARY PARDO 17ENE19 HASTA NUEVO AVISO.
-- como no avisa, libere los dos articulos 17777 y 17073 y el resto quedo bloqueado.
	--select '608! TENER BLOQUEADO ARF-ST' AS REPORTE, oitm.ItemCode as Codigo, 
	--OITM.ItemName as Nombre, OITM.InvntryUom, OITW.OnHand as Existencia,
	 --OITW.WhsCode, OITW.Locked
	--from OITW 
	--inner join OITM on OITM.ItemCode=OITW.ItemCode and WhsCode='ARF-ST'
	--where OITW.Locked = 'N' 
	--order by OITM.ItemName
	
	--update OITW set OITW.Locked = 'Y'
	--from OITW 
	--inner join OITM on OITM.ItemCode=OITW.ItemCode and WhsCode='ARF-ST'
	--where OITW.Locked = 'N' 

-- ALMACEN APT-FX DESBLOQUEAR PARA QUE LO USE FERNANDO PARA AJUSTES.
	select '624! TENER BLOQUEADO APT-FX' AS REPORTE, oitm.ItemCode as Codigo, 
	OITM.ItemName as Nombre, OITM.InvntryUom, OITW.OnHand as Existencia,
	 OITW.WhsCode, OITW.Locked
	from OITW 
	inner join OITM on OITM.ItemCode=OITW.ItemCode and WhsCode='APT-FX'
	where OITW.Locked = 'Y' 
	order by OITM.ItemName
	
	update OITW set OITW.Locked = 'N'
	from OITW 
	inner join OITM on OITM.ItemCode=OITW.ItemCode and WhsCode='APT-FX'
	where OITW.Locked = 'Y' 
*/



-- Aqui Actualizacion del 02 de Agosto del 2019, Sub Ensambles almacenes.
	
-- VER-190802 VALIDAR ALMACEN DE BASE OITT CABECERA DE LISTA DE MATERIALES, COMPLEMENTOS 32 
-- ASIGNE ENTREGA A APT-SE, NO HERRAJES Y NO SEA CINTILLOS. 
	Select '830 ! ALM. DFL LMD APG-ST' AS REPORTE, OITT.Code, A3.ItemName, A3.U_TipoMat, OITT.ToWH
	from OITT 
	inner join OITM A3 on OITT.Code = A3.ItemCode 
	where A3.QryGroup32 ='Y'  and A3.Itemname not like '%CINTILL%' and  Len(A3.ItemCode) > 6
	and (OITT.TOWH <> 'APT-SE' or  OITT.TOWH is null)
	ORDER BY A3.ItemName

	Update OITT set OITT.ToWH = 'APT-SE'
	from OITT 
	inner join OITM A3 on OITT.Code = A3.ItemCode 
	where A3.QryGroup32 ='Y'  and A3.Itemname not like '%CINTILL%' and  Len(A3.ItemCode) > 6
	and (OITT.TOWH <> 'APT-SE' or  OITT.TOWH is null)
		
-- VER-190802 VALIDAR ALMACEN DE BASE OITM MASTRO DE ARTICULO COMPLEMENTOS 32 DEFAUL APT-SE
-- ASIGNE ENTREGA A APT-SE, NO HERRAJES Y NO SEA CINTILLOS. 
	Select '835 ! ALM.DFL APT-SE' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat, OITM.DfltWH
	from OITM 
	where OITM.QryGroup32 ='Y'  and OITM.Itemname not like '%CINTILL%' and  Len(OITM.ItemCode) > 6
	and (OITM.DfltWH <>'APT-SE' or OITM.DfltWH is null) 
	ORDER BY OITM.ItemName
		
	Update OITM set OITM.DfltWH = 'APT-SE'
	where OITM.QryGroup32 ='Y'  and OITM.Itemname not like '%CINTILL%' and  Len(OITM.ItemCode) > 6
	and (OITM.DfltWH <>'APT-SE' or OITM.DfltWH is null) 

-- VER-190802 VALIDAR LISTA DE MATERIALES DE COMPLEMENTOS 32 CONSUMAN SUS MATERIALES DEL ALMACEN
-- DEL APG-ST, NO HERRAJES Y NO CINTILLOS.
	Select '840 ! LDM COMPL. CONSUME APG-ST' AS REPORTE, ITT1.Father, A3.ItemName, A3.U_TipoMat, A3.DfltWH, ITT1.Code, A1.ItemName, A1.U_TipoMat, ITT1.Warehouse
	from ITT1 
	inner join OITM A3 on ITT1.Father = A3.ItemCode
	inner join OITM A1 on ITT1.Code=A1.ItemCode  
	where A3.QryGroup32='Y' and A3.Itemname not like '%CINTILL%' and  Len(A3.ItemCode) > 6
	and (ITT1.Warehouse <> 'APG-ST' or  ITT1.Warehouse is null)
	ORDER BY A3.ItemName
	
	Update ITT1 Set ITT1.Warehouse = 'APG-ST'
	from ITT1 
	inner join OITM A3 on ITT1.Father = A3.ItemCode
	inner join OITM A1 on ITT1.Code=A1.ItemCode  
	where A3.QryGroup32='Y' and A3.Itemname not like '%CINTILL%' and  Len(A3.ItemCode) > 6
	and (ITT1.Warehouse <> 'APG-ST' or  ITT1.Warehouse is null)

-- VER-190802 VALIDAR ALMACEN DE BASE OITT CABECERA DE LISTA DE MATERIALES, COMPLEMENTOS 32 
-- ASIGNE ENTREGA A APG-ST, SOLO CINTILLOS. 
	Select '845 ! ALM. DFL LMD APG-ST' AS REPORTE, OITT.Code, A3.ItemName, A3.U_TipoMat, OITT.ToWH
	from OITT 
	inner join OITM A3 on OITT.Code = A3.ItemCode 
	where A3.QryGroup32 ='Y'  and A3.Itemname like '%CINTILL%' 
	and (OITT.TOWH <> 'APG-ST' or OITT.TOWH is null)
	ORDER BY A3.ItemName

	Update OITT set OITT.ToWH = 'APG-ST'
	from OITT 
	inner join OITM A3 on OITT.Code = A3.ItemCode 
	where A3.QryGroup32 ='Y'  and A3.Itemname like '%CINTILL%' 
	and (OITT.TOWH <> 'APG-ST' or OITT.TOWH is null)
		
-- VER-190802 VALIDAR ALMACEN DE BASE OITM MASTRO DE ARTICULO COMPLEMENTOS 32 DEFAUL APG-ST
-- ASIGNE ENTREGA A APG-ST, SOLO CINTILLOS. 
	Select '850 ! ALM.DFL APT-SE' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat, OITM.DfltWH
	from OITM 
	where OITM.QryGroup32 ='Y'  and OITM.Itemname like '%CINTILL%' 
	and (OITM.DfltWH <>'APG-ST' or  OITM.DfltWH is null)
	ORDER BY OITM.ItemName
		
	Update OITM set OITM.DfltWH = 'APG-ST'
	where OITM.QryGroup32 ='Y'  and OITM.Itemname like '%CINTILL%' 
	and (OITM.DfltWH <>'APG-ST' or  OITM.DfltWH is null)

-- VER-190802 VALIDAR LISTA DE MATERIALES DE COMPLEMENTOS 32 CONSUMAN SUS MATERIALES DEL ALMACEN
-- DEL APG-ST, SOLO CINTILLOS.
	Select '855 ! LDM COMPL. CONSUME APG-ST' AS REPORTE, ITT1.Father, A3.ItemName, A3.U_TipoMat, A3.DfltWH, ITT1.Code, A1.ItemName, A1.U_TipoMat, ITT1.Warehouse
	from ITT1 
	inner join OITM A3 on ITT1.Father = A3.ItemCode
	inner join OITM A1 on ITT1.Code=A1.ItemCode  
	where A3.QryGroup32='Y' and A3.Itemname like '%CINTILL%' 
	and (ITT1.Warehouse <> 'APG-ST' or  ITT1.Warehouse is null)
	ORDER BY A3.ItemName
	
	Update ITT1 Set ITT1.Warehouse = 'APG-ST'
	from ITT1 
	inner join OITM A3 on ITT1.Father = A3.ItemCode
	inner join OITM A1 on ITT1.Code=A1.ItemCode  
	where A3.QryGroup32='Y' and A3.Itemname like '%CINTILL%' 
	and (ITT1.Warehouse <> 'APG-ST' or  ITT1.Warehouse is null)
		
-- VER-190802 VALIDAR ALMACEN DE BASE OITT CABECERA DE LISTA DE MATERIALES, COMPLEMENTOS 32 
-- ASIGNE ENTREGA A AMP-CC, SOLO HERRAJES. 
	Select '860 ! ALM. DFL LMD AMP_CC' AS REPORTE, OITT.Code, A3.ItemName, A3.U_TipoMat, OITT.ToWH
	from OITT 
	inner join OITM A3 on OITT.Code = A3.ItemCode 
	where A3.QryGroup32 ='Y'  and A3.Itemname not like '%CINTILL%' and  Len(A3.ItemCode) < 7
	and (OITT.TOWH <> 'AMP-CC' or OITT.ToWH is null)
	ORDER BY A3.ItemName

	Update OITT set OITT.ToWH = 'AMP_CC'
	from OITT 
	inner join OITM A3 on OITT.Code = A3.ItemCode 
	where A3.QryGroup32 ='Y'  and A3.Itemname not like '%CINTILL%' and  Len(A3.ItemCode) < 7
	and (OITT.TOWH <> 'AMP-CC' or OITT.ToWH is null)

-- VER-190802 VALIDAR ALMACEN DE BASE OITM MASTRO DE ARTICULO COMPLEMENTOS 32 DEFAUL AMP-CC
-- ASIGNE ENTREGA A AMP-CC, SOLO HERRAJES. 
	Select '865 ! ALM.DFL AMP-CC' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat, OITM.DfltWH
	from OITM 
	where OITM.QryGroup32 ='Y'  and OITM.Itemname not like '%CINTILL%' and  Len(OITM.ItemCode) < 7
	and (OITM.DfltWH <>'AMP-CC' or OITM.DfltWH is null)
	ORDER BY OITM.ItemName
		
	Update OITM set OITM.DfltWH = 'AMP-CC'
	where OITM.QryGroup32 ='Y'  and OITM.Itemname not like '%CINTILL%' and  Len(OITM.ItemCode) < 7
	and (OITM.DfltWH <>'AMP-CC' or OITM.DfltWH is null)


-- VER-190802 VALIDAR LISTA DE MATERIALES DE COMPLEMENTOS 32 CONSUMAN SUS MATERIALES DEL ALMACEN
-- DEL AMP-ST, SOLO HERRAJES.
	Select '870 ! LDM COMPL. CONSUME AMP-ST' AS REPORTE, ITT1.Father, A3.ItemName, A3.U_TipoMat, A3.DfltWH, ITT1.Code, A1.ItemName, A1.U_TipoMat, ITT1.Warehouse
	from ITT1 
	inner join OITM A3 on ITT1.Father = A3.ItemCode
	inner join OITM A1 on ITT1.Code=A1.ItemCode  
	where A3.QryGroup32='Y' and A3.Itemname not like '%CINTILL%' and  Len(A3.ItemCode) < 7
	and (ITT1.Warehouse <> 'AMP-ST' or  ITT1.Warehouse is null) 
	ORDER BY A3.ItemName
	
	Update ITT1 Set ITT1.Warehouse = 'AMP-ST'
	from ITT1 
	inner join OITM A3 on ITT1.Father = A3.ItemCode
	inner join OITM A1 on ITT1.Code=A1.ItemCode  
	where A3.QryGroup32='Y' and A3.Itemname not like '%CINTILL%' and  Len(A3.ItemCode) < 7
	and (ITT1.Warehouse <> 'AMP-ST' or  ITT1.Warehouse is null) 
	

-- Fin del Archivo Excepciones de Articulos.


/*


	Select 'valida' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat
	from OITM 
	where OITM.QryGroup4='Y' 
	ORDER BY OITM.ItemName

	Update OITM set OITM.QryGroup4 = 'N' where OITM.QryGroup4='Y' 


valida	ZAR0634	ARTE (PROTO) -1- PIEL 0409 BROWNIE.	PT
valida	ZAR0867	AZZTOR (MO) -3 MAXI- PIEL NOBUCK RED BROWN.	PT
valida	3754-02-P0402	AZZTOR, -2-, PIEL 0402 GRIS.	PT
valida	3754-02-P0406	AZZTOR, -2-, PIEL 0406 CHEESE.	PT
valida	3754-02-P0502	AZZTOR, -2-, PIEL 0502 MARBLE.	PT
valida	3754-03-P0636	AZZTOR, -3-, PIEL 0636 WALNUT.	PT
valida	3754-03-P0718	AZZTOR, -3-, PIEL 0718 ANTICATO.	PT
valida	3754-50-P0502	AZZTOR, -3MAXI-, PIEL 0502 MARBLE.	PT
valida	3754-50-P0526	AZZTOR, -3MAXI-, PIEL 0526 CIGAR.	PT
valida	3754-50-P0636	AZZTOR, -3MAXI-, PIEL 0636 WALNUT.	PT
valida	3754-50-P0718	AZZTOR, -3MAXI-, PIEL 0718 ANTICATO.	PT
valida	3754-51-P0636	AZZTOR, 3MAXI-3, PIEL 0636 WALNUT.	PT
valida	3754-51-P0718	AZZTOR, 3MAXI-3, PIEL 0718 ANTICATO.	PT
valida	3754-95-P0502	AZZTOR, -COJIN 65X65-, PIEL 0502 MARBLE.	PT
valida	3754-95-P0607	AZZTOR, -COJIN 65X65-, PIEL 0607 DEEP WATER.	PT
valida	3754-95-P0619	AZZTOR, -COJIN 65X65-, PIEL 0619 BLEU.	PT
valida	3754-10-P0502	AZZTOR, -PIE DE CAMA KS-, BASTIDOR NOGAL, PIEL 0502 MARBLE.	PT
valida	3754-09-P0303	AZZTOR, -PIE DE CAMA KS-, PIEL 0303 BLANCO.	PT
valida	3754-09-P0304	AZZTOR, -PIE DE CAMA KS-, PIEL 0304 SIENA.	PT
valida	3754-09-P0314	AZZTOR, -PIE DE CAMA KS-, PIEL 0314 MOHO.	PT
valida	3754-09-P0501	AZZTOR, -PIE DE CAMA KS-, PIEL 0501 OREGON BLACK.	PT
valida	3754-09-P0502	AZZTOR, -PIE DE CAMA KS-, PIEL 0502 MARBLE.	PT
valida	3754-09-P0412	AZZTOR, -PIE DE CAMA KS-, PIEL 0512 CUOIO	PT
valida	3754-09-P0526	AZZTOR, -PIE DE CAMA KS-, PIEL 0526 CIGAR	PT
valida	3754-09-P0636	AZZTOR, -PIE DE CAMA KS-, PIEL 0636 WALNUT.	PT
valida	3754-08-P0502	AZZTOR, -REC KS-, BASTIDOR NOGAL, PIEL 0502 MARBLE.	PT
valida	3754-07-P0228	AZZTOR, -REC KS-, PIEL 0228 AMARETTO.	PT
valida	3754-07-P0304	AZZTOR, -REC KS-, PIEL 0304 SIENA.	PT
valida	3754-07-P0314	AZZTOR, -REC KS-, PIEL 0314 MOHO.	PT
valida	3754-07-P0319	AZZTOR, -REC KS-, PIEL 0319 NOGAL.	PT
valida	3754-07-P0502	AZZTOR, -REC KS-, PIEL 0502 MARBLE.	PT
valida	3754-07-P0413	AZZTOR, -REC KS-, PIEL 0513 SABBIA.	PT
valida	3754-07-P0526	AZZTOR, -REC KS-, PIEL 0526 CIGAR.	PT
valida	3754-07-P0636	AZZTOR, -REC KS-, PIEL 0636 WALNUT.	PT
valida	3754-21-P0502	AZZTOR, -TAB CIRCULAR-, PIEL 0502 MARBLE.	PT
valida	3754-21-P0636	AZZTOR, -TAB CIRCULAR-, PIEL 0636 WALNUT.	PT
valida	3666-05-P0718	BATAGLIA  3BI-CHBD PIEL 0718 ANTICATO.	PT
valida	3666-16-P0718	BATAGLIA -3BI- PIEL 0718 ANTICATO.	PT
valida	3666-23-P0321	BATAGLIA -CHBI- PIEL 0321 TRIGO	PT
valida	3666-35-P0321	BATAGLIA, -1SB-, PIEL 0321 TRIGO	PT
valida	3666-02-P0304	BATAGLIA, -2-, PIEL 0304 SIENA.	PT
valida	3666-03-P0304	BATAGLIA, -3-, PIEL 0304 SIENA.	PT
valida	3666-15-P0321	BATAGLIA, -3BD-, PIEL 0321 TRIGO	PT
valida	3666-22-P0718	BATAGLIA, -CHBD-, PIEL 0718 ANTICATO.	PT
valida	3666-09-P0103	BATAGLIA, -HB-, PIEL 0103 BLANCO.	PT
valida	3666-09-P0230	BATAGLIA, -HB-, PIEL 0230 CHOCOLATE.	PT
valida	3666-09-P0302	BATAGLIA, -HB-, PIEL 0302 GRAYSH.	PT
valida	3666-09-P0303	BATAGLIA, -HB-, PIEL 0303 BLANCO.	PT
valida	3666-09-P0310	BATAGLIA, -HB-, PIEL 0310 BROWN.	PT
valida	3666-09-P0318	BATAGLIA, -HB-, PIEL 0318 MORA.	PT
valida	3666-09-P0325	BATAGLIA, -HB-, PIEL 0325 FANGO.	PT
valida	3666-09-P0412	BATAGLIA, -HB-, PIEL 0512 CUOIO.	PT
valida	3666-09-P0526	BATAGLIA, -HB-, PIEL 0526 CIGAR.	PT
valida	3666-09-P0607	BATAGLIA, -HB-, PIEL 0607 DEEP WATER.	PT
valida	3666-09-P0640	BATAGLIA, -HB-, PIEL 0640 ROSE.	PT
valida	3666-09-P0712	BATAGLIA, -HB-, PIEL 0712 BLANCO.	PT
valida	ZAR0783	BAZZTA (MO) -CHS- PIEL ACERO.	PT
valida	ZAR0669	BAZZTA (PROTO) -1R- PIEL 0402 GRIS.	PT
valida	3745-37-P0301	BAZZTA, -1R-, PIEL 0301 NEGRO MATE.	PT
valida	3745-37-P0302	BAZZTA, -1R-, PIEL 0302 GRAYSH.	PT
valida	3745-37-P0306	BAZZTA, -1R-, PIEL 0306 CANELA.	PT
valida	3745-37-P0314	BAZZTA, -1R-, PIEL 0314 MOHO.	PT
valida	3745-37-P0318	BAZZTA, -1R-, PIEL 0318 MORA.	PT
valida	3745-37-P0319	BAZZTA, -1R-, PIEL 0319 NOGAL.	PT
valida	3745-37-P0322	BAZZTA, -1R-, PIEL 0322 LATTE.	PT
valida	3745-37-P0342	BAZZTA, -1R-, PIEL 0342 TOPO.	PT
valida	3745-37-P0402	BAZZTA, -1R-, PIEL 0402 GRIS.	PT
valida	3745-37-P0422	BAZZTA, -1R-, PIEL 0422 BUCK HUMO.	PT
valida	3745-37-P0501	BAZZTA, -1R-, PIEL 0501 OPORTO.	PT
valida	3745-37-P0544	BAZZTA, -1R-, PIEL 0644 CARBON.	PT
valida	3745-37-P0702	BAZZTA, -1R-, PIEL 0702 GRAFITO.	PT
valida	3745-37-P0706	BAZZTA, -1R-, PIEL 0706 GRILLO.	PT
valida	3745-37-P0830	BAZZTA, -1R-, PIEL 0830 RED BROWN.	PT
valida	3745-37-P0304	BAZZTA, -1R-,PIEL 0304 SIENA.	PT
valida	3745-20-P0301	BAZZTA, -CHS-, PIEL 0301 NEGRO MATE.	PT
valida	3745-20-P0312	BAZZTA, -CHS-, PIEL 0312 NIEVE.	PT
valida	3745-20-P0342	BAZZTA, -CHS-, PIEL 0342 TOPO.	PT
valida	3745-20-P0402	BAZZTA, -CHS-, PIEL 0402 GRIS.	PT
valida	3745-20-P0403	BAZZTA, -CHS-, PIEL 0403 BUCK OFF WHITE.	PT
valida	3745-20-P0433	BAZZTA, -CHS-, PIEL 0433 CHERRY.	PT
valida	3745-20-P0412	BAZZTA, -CHS-, PIEL 0512 CUOIO.	PT
valida	3745-20-P0544	BAZZTA, -CHS-, PIEL 0644 CARBON.	PT
valida	3661-15-P0442	BERTIE -3BD-, PIEL 0442 TOPO.	PT
valida	3661-23-P0442	BERTIE -ECHI-, PIEL 0442 TOPO.	PT
valida	3661-40-B0003	BERTIE -T-, PIEL 0229 CREMA / CEZZANE BEIGE / OLAS MARFIL.	PT
valida	3661-40-P0301	BERTIE -T-, PIEL 0301 NEGRO.	PT
valida	3661-05-P0442	BERTIE, -3BI-ECHD-, PIEL 0442 TOPO.	PT
valida	3661-06-P0442	BERTIE, -ECHI-3BD-, PIEL 0442 TOPO.	PT
valida	3491-02-P0353	BIANCA, -2-, PIEL 0353 HONEY.	PT
valida	3491-02-P0702	BIANCA, -2-, PIEL 0702 GRAFITO.	PT
valida	3491-03-MP0703	BIANCA, -3-, MPIEL 0703 OFF WHITE.	PT
valida	3491-03-P0306	BIANCA, -3-, PIEL 0306 CANELA.	PT
valida	3491-03-P0314	BIANCA, -3-, PIEL 0314 MOHO.	PT
valida	3491-03-P0353	BIANCA, -3-, PIEL 0353 HONEY.	PT
valida	3491-03-P0402	BIANCA, -3-, PIEL 0402 GRIS.	PT
valida	3491-03-P0422	BIANCA, -3-, PIEL 0422 BUCK HUMO.	PT
valida	3491-03-P0415	BIANCA, -3-, PIEL 0515 MOON.	PT
valida	3491-03-P0702	BIANCA, -3-, PIEL 0702 GRAFITO.	PT
valida	3491-13-P0703	BIANCA, -3-, PIEL 0703 OFF WHITE.	PT
valida	3491-03-P0703	BIANCA, -3-, PIEL 0703 VAINILLA.	PT
valida	3491-03-P0704	BIANCA, -3-, PIEL 0704 ALMENDRA.	PT
valida	3491-32-MP0703	BIANCA, 3-2, MPIEL 0703 OFF WHITE	PT
valida	3491-32-P0353	BIANCA, 3-2, PIEL 0353 HONEY.	PT
valida	3491-32-P0501	BIANCA, 3-2, PIEL 0501 OREGON BLACK	PT
valida	3491-32-P0412	BIANCA, 3-2, PIEL 0512 CUOIO.	PT
valida	3491-32-P0702	BIANCA, 3-2, PIEL 0702 GRAFITO.	PT
valida	3491-32-P0703	BIANCA, 3-2, PIEL 0703 OFF WHITE	PT
valida	3491-32-P0801	BIANCA, 3-2, PIEL 0801 WENGE.	PT
valida	3491-21-MP0703	BIANCA, -T-, MPIEL 0703 OFFWHITE.	PT
valida	3491-21-MP0806	BIANCA, -T-, MPIEL 0806 HABA.	PT
valida	3491-21-P0301	BIANCA, -T-, PIEL 0301 NEGRO.	PT
valida	3491-21-P0306	BIANCA, -T-, PIEL 0306 CANELA.	PT
valida	3491-21-P0314	BIANCA, -T-, PIEL 0314 MOHO.	PT
valida	3491-21-P0353	BIANCA, -T-, PIEL 0353 HONEY.	PT
valida	3491-21-P0504	BIANCA, -T-, PIEL 0504 TABACCO.	PT
valida	3491-31-P0703	BIANCA, -T-, PIEL 0703 OFFWHITE.	PT
valida	3491-21-P0703	BIANCA, -T-, PIEL 0703 VAINILLA.	PT
valida	3491-21-P0806	BIANCA, -T-, PIEL 0806 HABA.	PT
valida	ZAR0807	BOFFO (PROTO) 2R ELECTRICO PIEL 0301 NEGRO MATE.	PT
valida	3772	BORIZZ 1B,	PT
valida	3772-39-P0301	BORIZZ 1B, -1RBD-, PIEL 0301 NEGRO.	PT
valida	3772-38-P0301	BORIZZ 1B, -1RBI-, PIEL 0301 NEGRO.	PT
valida	3772-36-P0301	BORIZZ 1B, -1RSB-, PIEL 0301 NEGRO.	PT
valida	3772-17-P0301	BORIZZ 1B, -1SB-, PIEL 0301 NEGRO.	PT
valida	3772-40-P0301	BORIZZ 1B, -E-, PIEL 0301 NEGRO.	PT
valida	3756-39-P0318	BORIZZ NEW, -1RBD-, PIEL 0318 MORA	PT
valida	3756-39-P0342	BORIZZ NEW, -1RBD-, PIEL 0342 TOPO.	PT
valida	3756-38-P0318	BORIZZ NEW, -1RBI-, PIEL 0318 MORA.	PT
valida	3756-38-P0342	BORIZZ NEW, -1RBI-, PIEL 0342 TOPO.	PT
valida	3756-05-P0306	BORIZZ NEW, 1RBI-1RSB-E-1SB-1RBD, PIEL 0306 CANELA.	PT
valida	3756-05-P0319	BORIZZ NEW, 1RBI-1RSB-E-1SB-1RBD, PIEL 0319 NOGAL.	PT
valida	3756-05-P0413	BORIZZ NEW, 1RBI-1RSB-E-1SB-1RBD, PIEL 0513 SABBIA.	PT
valida	3756-36-P0306	BORIZZ NEW, -1RSB-, PIEL 0306 CANELA.	PT
valida	3756-36-P0318	BORIZZ NEW, -1RSB-, PIEL 0318 MORA.	PT
valida	3756-36-P0342	BORIZZ NEW, -1RSB-, PIEL 0342 TOPO.	PT
valida	3756-36-P0413	BORIZZ NEW, -1RSB-, PIEL 0513 SABBIA.	PT
valida	3688-39-P0228	BORIZZ, -1RBD-, PIEL 0228 AMARETTO.	PT
valida	3688-39-P0302	BORIZZ, -1RBD-, PIEL 0302 GRAYSH.	PT
valida	3688-39-P0306	BORIZZ, -1RBD-, PIEL 0306 CANELA.	PT
valida	3688-39-P0314	BORIZZ, -1RBD-, PIEL 0314 MOHO.	PT
valida	3688-39-P0319	BORIZZ, -1RBD-, PIEL 0319 NOGAL.	PT
valida	3688-39-P0337	BORIZZ, -1RBD-, PIEL 0337 NATURAL.	PT
valida	3688-39-P0353	BORIZZ, -1RBD-, PIEL 0353 HONEY.	PT
valida	3688-38-P0228	BORIZZ, -1RBI-, PIEL 0228 AMARETTO.	PT
valida	3688-38-P0302	BORIZZ, -1RBI-, PIEL 0302 GRAYSH.	PT
valida	3688-38-P0306	BORIZZ, -1RBI-, PIEL 0306 CANELA.	PT
valida	3688-38-P0314	BORIZZ, -1RBI-, PIEL 0314 MOHO.	PT
valida	3688-38-P0319	BORIZZ, -1RBI-, PIEL 0319 NOGAL.	PT
valida	3688-38-P0337	BORIZZ, -1RBI-, PIEL 0337 NATURAL.	PT
valida	3688-38-P0353	BORIZZ, -1RBI-, PIEL 0353 HONEY.	PT
valida	3688-05-P0304	BORIZZ, 1RBI-1RSB-E-1SB-1RBD, PIEL 0304 SIENA.	PT
valida	3688-05-P0306	BORIZZ, 1RBI-1RSB-E-1SB-1RBD, PIEL 0306 CANELA.	PT
valida	3688-05-P0402	BORIZZ, 1RBI-1RSB-E-1SB-1RBD, PIEL 0402 GRIS.	PT
valida	3688-08-P0337	BORIZZ, 1RBI-1SB-E-1RSB-1RBD, PIEL 0337 NATURAL.	PT
valida	3688-06-P0413	BORIZZ, 1RBI-1SB-E-1RSB-1RSB-1RSB-1RBD, PIEL 0513 SABBIA.	PT
valida	3688-36-P0302	BORIZZ, -1RSB-, PIEL 0302 GRAYSH.	PT
valida	3688-36-P0306	BORIZZ, -1RSB-, PIEL 0306 CANELA.	PT
valida	3688-36-P0314	BORIZZ, -1RSB-, PIEL 0314 MOHO.	PT
valida	3688-36-P0319	BORIZZ, -1RSB-, PIEL 0319 NOGAL.	PT
valida	3688-36-P0337	BORIZZ, -1RSB-, PIEL 0337 NATURAL.	PT
valida	3688-36-P0353	BORIZZ, -1RSB-, PIEL 0353 HONEY.	PT
valida	3688-17-P0228	BORIZZ, -1SB-, PIEL 0228 AMARETTO.	PT
valida	3688-17-P0302	BORIZZ, -1SB-, PIEL 0302 GRAYSH.	PT
valida	3688-17-P0306	BORIZZ, -1SB-, PIEL 0306 CANELA.	PT
valida	3688-17-P0314	BORIZZ, -1SB-, PIEL 0314 MOHO.	PT
valida	3688-17-P0319	BORIZZ, -1SB-, PIEL 0319 NOGAL.	PT
valida	3688-17-P0337	BORIZZ, -1SB-, PIEL 0337 NATURAL.	PT
valida	3688-17-P0353	BORIZZ, -1SB-, PIEL 0353 HONEY.	PT
valida	3688-40-P0302	BORIZZ, -E-, PIEL 0302 GRAYSH.	PT
valida	3688-40-P0306	BORIZZ, -E-, PIEL 0306 CANELA.	PT
valida	3688-40-P0314	BORIZZ, -E-, PIEL 0314 MOHO.	PT
valida	3688-40-P0319	BORIZZ, -E-, PIEL 0319 NOGAL.	PT
valida	3688-40-P0337	BORIZZ, -E-, PIEL 0337 NATURAL.	PT
valida	3688-40-P0353	BORIZZ, -E-, PIEL 0353 HONEY.	PT
valida	3688-40-P0402	BORIZZ, -E-, PIEL 0402 GRIS.	PT
valida	3688-40-B0057	BORIZZ, -E-, TELA ZARK TERCIOPELO GRIS.	PT
valida	3688-37-P0314	BORIZZ, -RECLI-, PIEL 0314 MOHO.	PT
valida	17058	BOTON 2-BUTTON TOUCH SENSOR (7742650001) (BORIZZ)	MP
valida	17777	BOTON PLASTICO CON PUERTO USB INTEGRADO (7744300001) P/HERRAJE MOTORIZADO	MP
valida	3594-32-P0321	BRAVA -3-2, PIEL 0321 TRIGO.	PT
valida	3594-02-P0228	BRAVA, -2-, PIEL 0228 AMARETTO.	PT
valida	3594-02-P0321	BRAVA, -2-, PIEL 0321 TRIGO.	PT
valida	3594-03-P0321	BRAVA, -3-, PIEL 0321 TRIGO.	PT
valida	3594-05-P0342	BRAVA, 3BI-CHBD, PIEL 0342 TOPO.	PT
valida	3594-21-P0301	BRAVA, -T-, PIEL 0301 NEGRO.	PT
valida	3594-21-P0318	BRAVA, -T-, PIEL 0318 MORA.	PT
valida	17012	BRAZO MESA ABATIBLE PIZZA (XIC) MANUAL LICITACION DER/IZQ.	MP
valida	ZAR0717	CAPOTTI (PROTO) -REVISTERO- PIEL 0442 TOPO.	PT
valida	3750-29-P7004	CAPOTTI, -REVISTERO-, PIEL 0301 NEGRO / PIEL 0504 TABACCO.	PT
valida	3750-29-P0301	CAPOTTI, -REVISTERO-, PIEL 0301 NEGRO MATE.	PT
valida	3750-29-P0306	CAPOTTI, -REVISTERO-, PIEL 0306 CANELA.	PT
valida	3750-29-P0342	CAPOTTI, -REVISTERO-, PIEL 0342 TOPO.	PT
valida	3750-29-P0403	CAPOTTI, -REVISTERO-, PIEL 0403 BUCK OFF WHITE.	PT
valida	3750-29-P0422	CAPOTTI, -REVISTERO-, PIEL 0422 BUCK HUMO.	PT
valida	3750-29-P0703	CAPOTTI, -REVISTERO-, PIEL 0703 VAINILLA	PT
valida	3750-29-B0044	CAPOTTI, -REVISTERO-, PIEL 0703 VAINILLA / PIEL 0403 BUCK OFF WHITE.	PT
valida	3750-29-P0704	CAPOTTI, -REVISTERO-, PIEL 0704 ALMENDRA.	PT
valida	3557-07-P0230	CAVALLI, -REC KS-, PIEL 0230 CHOCOLATE.	PT
valida	3557-08-P0230	CAVALLI, -REC MAT-, PIEL 0230 CHOCOLATE.	PT
valida	3557-08-P0319	CAVALLI, -REC MAT-, PIEL 0319 NOGAL.	PT
valida	3690-01-P0235	CAZZ, -1-, PIEL 0235 OYSTER.	PT
valida	3690-01-P0305	CAZZ, -1-, PIEL 0305 OLIVO.	PT
valida	3690-01-P0312	CAZZ, -1-, PIEL 0312 NIEVE.	PT
valida	3690-01-P0318	CAZZ, -1-, PIEL 0318 MORA.	PT
valida	3690-01-P0442	CAZZ, -1-, PIEL 0342 TOPO.	PT
valida	3690-01-P0802	CAZZ, -1-, PIEL 0702 GRAFITO.	PT
valida	3691-24-P0415	CAZZAT, -MTC-, PIEL 0515 MOON.	PT
valida	3765-07-P0415	CAZZATA NEW, -REC KS-, PIEL 0515 MOON.	PT
valida	3689-16-P0412	CAZZATA, -3BI-, PIEL 0512 CUOIO.	PT
valida	3689-16-P0802	CAZZATA, -3BI-, PIEL 0802 GRAFITO.	PT
valida	3689-52-P0412	CAZZATA, 3BI-CHBD,  PIEL 0512 CUOIO.	PT
valida	3689-22-P0412	CAZZATA, -CHBD-, PIEL 0512 CUOIO.	PT
valida	3689-07-P0422	CAZZATA, -REC KS-, PIEL 0422 BUCK HUMO.	PT
valida	3689-07-P0806	CAZZATA, -REC KS-, PIEL 0806 ACERO.	PT
valida	3749-51-P0312	CAZZETTI, - MESA RECTANGULAR CEN.-, PIEL 0312 NIEVE.	PT
valida	3749-51-P0502	CAZZETTI, - MESA RECTANGULAR CEN.-, PIEL 0502 MARBLE.	PT
valida	3749-53-P0301	CAZZETTI, -MESA LATERAL CUADRADA-, PIEL 0301 NEGRO MATE.	PT
valida	3749-53-P0302	CAZZETTI, -MESA LATERAL CUADRADA-, PIEL 0302 GRAYSH.	PT
valida	3749-53-P0312	CAZZETTI, -MESA LATERAL CUADRADA-, PIEL 0312 NIEVE.	PT
valida	3749-53-P0314	CAZZETTI, -MESA LATERAL CUADRADA-, PIEL 0314 MOHO.	PT
valida	3749-53-P0322	CAZZETTI, -MESA LATERAL CUADRADA-, PIEL 0322 LATTE.	PT
valida	3749-53-P0422	CAZZETTI, -MESA LATERAL CUADRADA-, PIEL 0422 BUCK HUMO.	PT
valida	3749-53-P0427	CAZZETTI, -MESA LATERAL CUADRADA-, PIEL 0427 BUCK MARRONE.	PT
valida	3749-53-P0440	CAZZETTI, -MESA LATERAL CUADRADA-, PIEL 0440 ROBLE.	PT
valida	3749-53-P0501	CAZZETTI, -MESA LATERAL CUADRADA-, PIEL 0501 OREGON BLACK.	PT
valida	3749-53-P0502	CAZZETTI, -MESA LATERAL CUADRADA-, PIEL 0502 MARBLE.	PT
valida	3749-53-P0412	CAZZETTI, -MESA LATERAL CUADRADA-, PIEL 0512 CUOIO.	PT
valida	3749-53-P0526	CAZZETTI, -MESA LATERAL CUADRADA-, PIEL 0526 CIGAR.	PT
valida	3749-53-P0720	CAZZETTI, -MESA LATERAL CUADRADA-, PIEL 0720 INDIGO.	PT
valida	ZAR0868	CINE LOUNGE NEW (PROTO) -2R- PIEL 0314 MOHO / TELA CANCUN	PT
valida	ZAR0869	CINE LOUNGE US (PROTO) -2R- PIEL 0342 TOPO	PT
valida	3759-42-P0342	CINE LOUNGE,-CINTILLO-, PIEL 0342 TOPO XIC.	SP
valida	10435	CINE: BOTON DE ACTIVACION ROUND SWITCH POWER KIT 5114.	MP
valida	16232	CINE: BRAZO DERECHO PARA MESA ABATIBLE PIZZA 180	MP
valida	16233	CINE: BRAZO IZQUIERDO PARA MESA ABATIBLE PIZZA 180	MP
valida	10091	CINE: CHICOTE CAPROHEAD CON RESORTE.	MP
valida	10166	CINE: CHICOTE REDONDO.	MP
valida	10437	CINE: ELIMINADOR OKIN SMPS TRANSFORMER POWER KIT 5114.	MP
valida	10424	CINE: MOTOR/PISTON OKIN ELECTRIC MOTOR. POWER KIT 5114.	MP
valida	14416	CINE: PLACA P/ VIDRIO MESA ABATIBLE CHICA DER. CINPLEX (XIC).	MP
valida	3787-32-P0342	CINE-LOUNGE -BRA-2R- PIEL 0342 TOPO / VINIL TOPO.	PT
valida	3790-47-B0086	CINE-LOUNGE Z1-2R- PIEL 0402 GRIS / TELA TERCIOPELO MUSE.	PT
valida	3801-47-P0342	CINE-LOUNGE-2R- OMAN, PIEL 0342 TOPO / NEXPIEL ME M. LACA TOPO RAF.	PT
valida	3759-32-B0101	CINE-LOUNGE-2R- PIEL 0342 TOPO / VINIL TOPO / .	PT
valida	3759-32-P0342	CINE-LOUNGE-2R- PIEL 0342 TOPO / VINIL TOPO.	PT
valida	3759-32-B0066	CINE-LOUNGE-2R- PIEL 0701 WENGE / TELA TERCIOPELO MARRON.	PT
valida	3803-32-P0342	CINE-LOUNGE-2R- US -MAMPARA CORTA, PIEL 0342 TOPO / NEXPIEL ME M. LACA TOPO RAF.	PT
valida	3786-32-P0342	CINE-LOUNGE-2R- US, PIEL 0342 TOPO / NEXPIEL ME M. LACA TOPO RAF.	PT
valida	3759-22-P0342	CINE-LOUNGE-2R, -PATA CORTA MAMPARA-, VINIL TOPO.	PT
valida	3510-42-P0230	CINTILLO DE PIZZA, PIEL 0230 CHOCOLATE CON VELCRO,  (CORTE Y COSTURA).	SP
valida	ZAR0806	COFFE (MO) -COFEE TABLE LITH- MTL BROWN/MARBLE EMPERADOR	PT
valida	3478-80-P0311	COJIN -40X40 GREÑA- PIEL 0311 MARFIL.	PT
valida	3478-80-P0321	COJIN, -40X40 GREÑA-, PIEL 0321 TRIGO.	PT
valida	3478-97-P0305	COJIN, -PIONINI-, PIEL 0305 OLIVO.	PT
valida	3478-97-P0318	COJIN, -PIONINI-, PIEL 0318 MORA.	PT
valida	3478-97-P0422	COJIN, -PIONINI-, PIEL 0422 BUCK HUMO.	PT
valida	3478-97-P0433	COJIN, -PIONINI-, PIEL 0433 CHERRY.	PT
valida	3478-97-P0442	COJIN, -PIONINI-, PIEL 0442 TOPO.	PT
valida	3478-97-P0526	COJIN, -PIONINI-, PIEL 0526 CIGAR.	PT
valida	3478-97-B0075	COJIN, -PIONINI-, TELA INK ALMENDRA.	PT
valida	3478-97-B0057	COJIN, -PIONINI-, TELA ZARK B0057 TERCIOPELO GRIS .	PT
valida	3478-97-B0054	COJIN, -PIONINI-, TELA ZARKS TERCIOPELO AZUL.	PT
valida	3478-97-B0055	COJIN, -PIONINI-, TELA ZARKS TERCIOPELO MUSE.	PT
valida	3478-97-B0062	COJIN, -PIONINI-, TELA ZARKS TERCIOPELO TURQUESA.	PT
valida	ZAR0625	CORAZZ (PROTO) -1- PIEL 0501 OREGON BLACK.	PT
valida	3719-01-P0312	CORAZZ, -1-, PIEL 0312 NIEVE.	PT
valida	3719-01-P0501	CORAZZ, -1-, PIEL 0501 OREGON BLACK	PT
valida	3719-01-P0526	CORAZZ, -1-, PIEL 0526 CIGAR.	PT
valida	3719-01-P0806	CORAZZ, -1-, PIEL 0806 HABA.	PT
valida	3717-02-P0303	CORAZZOLA, -2-, PIEL 0303 BLANCO.	PT
valida	3717-02-P0307	CORAZZOLA, -2-, PIEL 0307 CHANTILLY.	PT
valida	3717-02-P0312	CORAZZOLA, -2-, PIEL 0312 NIEVE.	PT
valida	3717-02-P0339	CORAZZOLA, -2-, PIEL 0339 POLAR.	PT
valida	3717-02-P0353	CORAZZOLA, -2-, PIEL 0353 HONEY.	PT
valida	3717-02-P0501	CORAZZOLA, -2-, PIEL 0501 OREGON BLACK .	PT
valida	3717-02-P0526	CORAZZOLA, -2-, PIEL 0526 CIGAR.	PT
valida	3717-02-P0814	CORAZZOLA, -2-, PIEL 0814 CAPUCHINO.	PT
valida	3717-03-P0228	CORAZZOLA, -3-, PIEL 0228 AMARETTO.	PT
valida	3717-03-P0303	CORAZZOLA, -3-, PIEL 0303 BLANCO.	PT
valida	3717-03-P0312	CORAZZOLA, -3-, PIEL 0312 NIEVE.	PT
valida	3717-03-P0339	CORAZZOLA, -3-, PIEL 0339 POLAR.	PT
valida	3717-03-P0501	CORAZZOLA, -3-, PIEL 0501 OREGON BLACK	PT
valida	3717-03-P0526	CORAZZOLA, -3-, PIEL 0526 CIGAR.	PT
valida	3717-03-P0814	CORAZZOLA, -3-, PIEL 0814 CAPUCHINO.	PT
valida	3717-15-P0501	CORAZZOLA, -3BD-, PIEL 0501 OREGON BLACK	PT
valida	3717-15-P0526	CORAZZOLA, -3BD-, PIEL 0526 CIGAR.	PT
valida	3717-50-P0228	CORAZZOLA, -3MAXI-, PIEL 0228 AMARETO.	PT
valida	3717-50-P0301	CORAZZOLA, -3MAXI-, PIEL 0301 NEGRO MATE.	PT
valida	3717-50-P0303	CORAZZOLA, -3MAXI-, PIEL 0303 BLANCO.	PT
valida	3717-50-P0318	CORAZZOLA, -3MAXI-, PIEL 0318 MORA.	PT
valida	3717-50-P0501	CORAZZOLA, -3MAXI-, PIEL 0501 OREGON BLACK.	PT
valida	3717-50-P0526	CORAZZOLA, -3MAXI-, PIEL 0526 CIGAR.	PT
valida	3717-50-P0619	CORAZZOLA, -3MAXI-, PIEL 0619 BLEU.	PT
valida	3717-50-P0718	CORAZZOLA, -3MAXI-, PIEL 0718 ANTICATO.	PT
valida	3717-52-P0501	CORAZZOLA, 3MAXI-3MAXI-T-, PIEL 0501 OREGON BLACK	PT
valida	3717-55-P0501	CORAZZOLA, 3MAXI-3MAXI-T-T, PIEL 0501 OREGON BLACK	PT
valida	3717-23-P0501	CORAZZOLA, -CHBI-, PIEL 0501 OREGON BLACK.	PT
valida	3717-23-P0526	CORAZZOLA, -CHBI-, PIEL 0526 CIGAR.	PT
valida	3717-21-P0228	CORAZZOLA, -T-, PIEL 00228 AMARETTO.	PT
valida	3717-21-P0325	CORAZZOLA, -T-, PIEL 0325 FANGO.	PT
valida	3717-21-P0422	CORAZZOLA, -T-, PIEL 0422 BUCK HUMO.	PT
valida	3717-21-P0501	CORAZZOLA, -T-, PIEL 0501 OREGON BLACK.	PT
valida	3717-21-P0526	CORAZZOLA, -T-, PIEL 0526 CIGAR.	PT
valida	3717-21-P0619	CORAZZOLA, -T-, PIEL 0619 BLEU.	PT
valida	3700-32-P0312	DIMITRI -3-2, PIEL 0312 NIEVE.	PT
valida	3700-02-P0235	DIMITRI, -2- PIEL 0235 M OYSTER.	PT
valida	3700-14-P0235	DIMITRI, -2BD- PIEL 0235 OYSTER.	PT
valida	3700-14-P0310	DIMITRI, -2BD- PIEL 0310 BROWN.	PT
valida	3700-14-P0319	DIMITRI, -2BD- PIEL 0319 NOGAL.	PT
valida	3700-14-P0342	DIMITRI, -2BD- PIEL 0342 TOPO.	PT
valida	3700-14-P0413	DIMITRI, -2BD- PIEL 0513 SABBIA.	PT
valida	3700-14-P0415	DIMITRI, -2BD- PIEL 0515 MOON.	PT
valida	3700-13-P0235	DIMITRI, -2BI- PIEL 0235 OYSTER.	PT
valida	3700-13-P0310	DIMITRI, -2BI- PIEL 0310 BROWN.	PT
valida	3700-13-P0319	DIMITRI, -2BI- PIEL 0319 NOGAL.	PT
valida	3700-13-P0342	DIMITRI, -2BI- PIEL 0342 TOOPO.	PT
valida	3700-13-P0413	DIMITRI, -2BI- PIEL 0513 SABBIA.	PT
valida	3700-13-P0415	DIMITRI, -2BI- PIEL 0515 MOON.	PT
valida	3700-35-P0235	DIMITRI, 2BI-2BD-3, PIEL 0235 OYSTER.	PT
valida	3700-35-P0310	DIMITRI, 2BI-2BD-3, PIEL 0310 BROWN.	PT
valida	3700-03-P0235	DIMITRI, -3- PIEL 0235 OYSTER.	PT
valida	3700-96-P0306	DIMITRI,-2BI-2BD, PIEL 0306 CANELA.	PT
valida	3700-96-P0342	DIMITRI,-2BI-2BD, PIEL 0342 TOPO.	PT
valida	3700-96-P0413	DIMITRI,-2BI-2BD, PIEL 0513 SABBIA.	PT
valida	3700-96-P0415	DIMITRI,-2BI-2BD, PIEL 0515 MOON.	PT
valida	ZAR0713	ELVA (PROTO) -1- PIEL 0310 BROWN.	PT
valida	ZAR0796	ELVA (PROTO) -1- PIEL 04 BUCK MARRON.	PT
valida	3692-33-P0310	FLAI -MESA LAPTOP CAFE- PIEL 0310 BROWN.	PT
valida	3692-32-P0318	FLAI -MESA LAPTOP NEGRA- PIEL 0318 MORA.	PT
valida	3589-01-P0204	FLUX -1- PIEL 0204 ARENA.	PT
valida	3589-01-P0318	FLUX -1- PIEL 0318 MORA.	PT
valida	3589-01-P0342	FLUX -1- PIEL 0342 TOPO.	PT
valida	3589-01-P0702	FLUX -1- PIEL 0702 GRAFITO.	PT
valida	3589-01-P0806	FLUX -1- PIEL 0806 ACERO.	PT
valida	3726-02-P0319	GAGAZZO, -2-, PIEL 0319 NOGAL.	PT
valida	3776-79-P0312	GAZZAPA, -1RBD-1RSB-1RSB-E-1SB-CR-CHBI, PIEL 0312 NIEVE.	PT
valida	3776-78-P0322	GAZZAPA, -1RBD-1RSB-CHBI-, PIEL 0322 LATTE.	PT
valida	3776-78-P0312	GAZZAPA, -1RBD-1RSB-CR-CHBI, PIEL 0312 NIEVE.	PT
valida	3776-89-P0544	GAZZAPA, -1RBI-1RSB-1RSB-CHBD-, PIEL 0644 CARBON.	PT
valida	3776-73-P0312	GAZZAPA, -1RBI-1RSB-CR-CHBD-, PIEL 0312 NIEVE.	PT
valida	3776-73-P0325	GAZZAPA, -1RBI-1RSB-CR-CHBD-, PIEL 0325 FANGO.	PT
valida	3776-73-P0544	GAZZAPA, -1RBI-1RSB-CR-CHBD-, PIEL 0644 CARBON.	PT
valida	3776-85-P0312	GAZZAPA, -1RBI-1RSB-CT-CHBD-, PIEL 0312 NIEVE.	PT
valida	3776-70-P0415	GAZZAPA, -1RBI-1RSB-CT-CHBD-, PIEL 0515 MOON.	PT
valida	3776-80-P0312	GAZZAPA, -1RBI-1RSB-E-1SB-1SB-CR-CHBD, PIEL 0312 NIEVE.	PT
valida	3776-75-P0312	GAZZAPA, -1RBI-1SB-E-1RSB-CHBD-, PIEL 0312 NIEVE.	PT
valida	3776-75-P0325	GAZZAPA, -1RBI-1SB-E-1RSB-CHBD-, PIEL 0325 FANGO.	PT
valida	3776-92-P0306	GAZZAPA, -1RBI-1SB-E-1SB-1RSB-CHBD-, PIEL 0306 CANELA.	PT
valida	3776-87-P0312	GAZZAPA, -1RBI-CR-1RSB-1RSB-E-1SB-CR-CHBD-, PIEL 0312 NIEVE.	PT
valida	3776-86-P0312	GAZZAPA, -1RBI-CR-1RSB-E-1SB-CR-CHBD-, PIEL 0312 NIEVE.	PT
valida	3776-77-P0523	GAZZAPA, -1RBI-CR-1SB-E-1RSB-1RSB-CR-CHBD-PIEL 0623 CHAMPAGNE.	PT
valida	3776-90-P0402	GAZZAPA, -1RBI-CR-E-1RSB-1RSB-1RBD-, PIEL 0402 GRIS.	PT
valida	3776-88-P0544	GAZZAPA, -1RBI-CR-E-1SB-1SB-CR-1RSB-1RBD-, PIEL 0644 CARBON.	PT
valida	3776-91-P0302	GAZZAPA, -1RBI-E-1RSB-1CR-1SB-CHBD-, PIEL 0302 GRAYSH.	PT
valida	3776-74-P0312	GAZZAPA, -CHBI- CR-1RSB-1RBD-, PIEL 0312 NIEVE.	PT
valida	3776-76-P0312	GAZZAPA, -CHBI-1SB-E-1RSB-1RBD-, PIEL 0312 NIEVE.	PT
valida	3776-76-P0325	GAZZAPA, -CHBI-1SB-E-1RSB-1RBD-PIEL 0325 FANGO.	PT
valida	3776-71-P0415	GAZZAPA, -CHBI-CHBD-, PIEL 0515 MOON.	PT
valida	3776-74-P0325	GAZZAPA, -CHBI-CR-1RSB-1RBD-, PIEL 0325 FANGO.	PT
valida	3776-82-P0312	GAZZAPA, -CHBI-CR-1RSB-1SB-E-1SB-1RBD-, PIEL 0312 NIEVE.	PT
valida	3776-84-P0312	GAZZAPA, -CHBI-CR-1RSB-1SB-E-1SB-CR-1RBD-, PIEL 0312 NIEVE.	PT
valida	3776-83-P0312	GAZZAPA, -CHBI-CR-1RSB-1SB-E-1SB-CT-1RBD-, PIEL 0312 NIEVE.	PT
valida	3776-81-P0312	GAZZAPA, -CHBI-CT-1RSB-1RBD-, PIEL 0312 NIEVE.	PT
valida	3776-72-P0312	GAZZAPA, -E-CR-1SB-, PIEL 0415 NIEVE.	PT
valida	3776-72-P0415	GAZZAPA, -E-CR-1SB-, PIEL 0515 MOON.	PT
valida	3776-93-P0306	GAZZAPA,-1RBI-CT-1RSB-1RSB-1RSB-CT-1RBD- , PIEL 0306 CANELA.	PT
valida	ZAR0798	GINGER (MO) -SILLA- 50X60X84, PIEL 959 ICE	PT
valida	3638-38-P0303	GIUZZTI, -1RBD-, PIEL 0303 BLANCO.	PT
valida	3638-38-P0339	GIUZZTI, -1RBD-, PIEL 0339 POLAR.	PT
valida	3638-39-P0303	GIUZZTI, -1RBI-, PIEL 0303 BLANCO.	PT
valida	3638-39-P0339	GIUZZTI, -1RBI-, PIEL 0339 POLAR.	PT
valida	3638-37-P0301	GIUZZTI, -RECLI-, PIEL 0301 NEGRO.	PT
valida	3419-07-P0228	GLAZZ -REC KS-, PIEL 0228 AMARETTO.	PT
valida	3419-07-P0303	GLAZZ -REC KS-, PIEL 0303 BLANCO.	PT
valida	ZAR0803	HALIBUT (MO) -COMPLEMENTO- 240X340	PT
valida	3658-37-P2230	HAWA -RECLI- PIEL 0230 CHOCOLATE / PIEL 0130 CHOCOLATE.	PT
valida	3658-37-P0230	HAWA -RECLI- PIEL 0230 CHOCOLATE.	PT
valida	3658-37-P0302	HAWA -RECLI- PIEL 0302 GRAYSH.	PT
valida	3658-37-P0305	HAWA -RECLI- PIEL 0305 OLIVO.	PT
valida	3658-37-P0313	HAWA -RECLI- PIEL 0313 CUIR.	PT
valida	3658-37-P0314	HAWA -RECLI- PIEL 0314 MOHO.	PT
valida	3658-37-P0342	HAWA -RECLI- PIEL 0342 TOPO.	PT
valida	3658-37-P0544	HAWA -RECLI- PIEL 0644 CARBON.	PT
valida	3658-37-P0702	HAWA -RECLI- PIEL 0702 GRAFITTO.	PT
valida	3658-37-P0703	HAWA -RECLI- PIEL 0703 VAINILLA.	PT
valida	3658-37-P0814	HAWA -RECLI- PIEL 0814 CAPUCHINO.	PT
valida	ZAR0876	HT VOLITO GRAY SOFHYDE	PT
valida	ZAR0871	IJOY ACTIVE 2.0 BONE/GRAY SOFHYDE	PT
valida	ZAR0870	IJOY ACTIVE 2.0 ESPRESSO/GRAY SOFHYDE	PT
valida	3755-19-P0301	IZZOLA NEW, -1BBD-, PIEL 0301 NEGRO MATE.	PT
valida	3755-19-P0303	IZZOLA NEW, -1BBD-, PIEL 0303 BLANCO.	PT
valida	3755-19-P0306	IZZOLA NEW, -1BBD-, PIEL 0306 CANELA.	PT
valida	3755-19-P0312	IZZOLA NEW, -1BBD-, PIEL 0312 NIEVE.	PT
valida	3755-19-P0314	IZZOLA NEW, -1BBD-, PIEL 0314 MOHO.	PT
valida	3755-19-P0318	IZZOLA NEW, -1BBD-, PIEL 0318 MORA.	PT
valida	3755-19-P0321	IZZOLA NEW, -1BBD-, PIEL 0321 TRIGO.	PT
valida	3755-19-P0322	IZZOLA NEW, -1BBD-, PIEL 0322 LATTE.	PT
valida	3755-19-P0342	IZZOLA NEW, -1BBD-, PIEL 0342 TOPO.	PT
valida	3755-19-P0402	IZZOLA NEW, -1BBD-, PIEL 0402 GRIS.	PT
valida	3755-19-P0501	IZZOLA NEW, -1BBD-, PIEL 0501 OREGON BLACK.	PT
valida	3755-19-P0502	IZZOLA NEW, -1BBD-, PIEL 0502 MARBLE.	PT
valida	3755-19-P0415	IZZOLA NEW, -1BBD-, PIEL 0515 MOON.	PT
valida	3755-19-P0611	IZZOLA NEW, -1BBD-, PIEL 0611 NEGRO.	PT
valida	3755-19-P0619	IZZOLA NEW, -1BBD-, PIEL 0619 BLEU.	PT
valida	3755-19-P0544	IZZOLA NEW, -1BBD-, PIEL 0644 CARBON.	PT
valida	3755-18-P0230	IZZOLA NEW, -1BBI-, PIEL 0230 CHOCOLATE.	PT
valida	3755-18-P0301	IZZOLA NEW, -1BBI-, PIEL 0301 NEGRO MATE.	PT
valida	3755-18-P0303	IZZOLA NEW, -1BBI-, PIEL 0303 BLANCO.	PT
valida	3755-18-P0312	IZZOLA NEW, -1BBI-, PIEL 0312 NIEVE.	PT
valida	3755-18-P0314	IZZOLA NEW, -1BBI-, PIEL 0314 MOHO.	PT
valida	3755-18-P0318	IZZOLA NEW, -1BBI-, PIEL 0318 MORA.	PT
valida	3755-18-P0332	IZZOLA NEW, -1BBI-, PIEL 0332 CIMARRON.	PT
valida	3755-18-P0337	IZZOLA NEW, -1BBI-, PIEL 0337 NATURAL.	PT
valida	3755-18-P0402	IZZOLA NEW, -1BBI-, PIEL 0402 GRIS.	PT
valida	3755-18-P0433	IZZOLA NEW, -1BBI-, PIEL 0433 CHERRY.	PT
valida	3755-18-P0501	IZZOLA NEW, -1BBI-, PIEL 0501 OREGON BLACK.	PT
valida	3755-18-P0412	IZZOLA NEW, -1BBI-, PIEL 0512 CUOIO.	PT
valida	3755-18-P0415	IZZOLA NEW, -1BBI-, PIEL 0515 MOON.	PT
valida	3755-18-P0611	IZZOLA NEW, -1BBI-, PIEL 0611 NEGRO.	PT
valida	3755-18-P0619	IZZOLA NEW, -1BBI-, PIEL 0619 BLEU.	PT
valida	3755-18-P0544	IZZOLA NEW, -1BBI-, PIEL 0644 CARBON.	PT
valida	3755-18-P0701	IZZOLA NEW, -1BBI-, PIEL 0701 WENGE.	PT
valida	3755-18-P0702	IZZOLA NEW, -1BBI-, PIEL 0702 GRAFITO.	PT
valida	3755-17-P0230	IZZOLA NEW, -1SB-, PIEL 0230 CHOCOLATE.	PT
valida	3755-17-P0301	IZZOLA NEW, -1SB-, PIEL 0301 NEGRO MATE.	PT
valida	3755-17-P0303	IZZOLA NEW, -1SB-, PIEL 0303 BLANCO.	PT
valida	3755-17-P0306	IZZOLA NEW, -1SB-, PIEL 0306 CANELA.	PT
valida	3755-17-P0312	IZZOLA NEW, -1SB-, PIEL 0312 NIEVE.	PT
valida	3755-17-P0314	IZZOLA NEW, -1SB-, PIEL 0314 MOHO	PT
valida	3755-17-P0318	IZZOLA NEW, -1SB-, PIEL 0318 MORA.	PT
valida	3755-17-P0321	IZZOLA NEW, -1SB-, PIEL 0321 TRIGO.	PT
valida	3755-17-P0322	IZZOLA NEW, -1SB-, PIEL 0322 LATTE	PT
valida	3755-17-P0332	IZZOLA NEW, -1SB-, PIEL 0332 CIMARRON.	PT
valida	3755-17-P0337	IZZOLA NEW, -1SB-, PIEL 0337 NATURAL.	PT
valida	3755-17-P0342	IZZOLA NEW, -1SB-, PIEL 0342 TOPO.	PT
valida	3755-17-P0402	IZZOLA NEW, -1SB-, PIEL 0402 GRIS.	PT
valida	3755-17-P0433	IZZOLA NEW, -1SB-, PIEL 0433 CHERRY.	PT
valida	3755-17-P0501	IZZOLA NEW, -1SB-, PIEL 0501 OREGON BLACK.	PT
valida	3755-17-P0502	IZZOLA NEW, -1SB-, PIEL 0502 MARBLE.	PT
valida	3755-17-P0412	IZZOLA NEW, -1SB-, PIEL 0512 CUOIO.	PT
valida	3755-17-P0415	IZZOLA NEW, -1SB-, PIEL 0515 MOON.	PT
valida	3755-17-P0611	IZZOLA NEW, -1SB-, PIEL 0611 NEGRO.	PT
valida	3755-17-P0619	IZZOLA NEW, -1SB-, PIEL 0619 BLEU.	PT
valida	3755-17-P0544	IZZOLA NEW, -1SB-, PIEL 0644 CARBON.	PT
valida	3755-17-P0702	IZZOLA NEW, -1SB-, PIEL 0702 GRAFITO.	PT
valida	3755-23-P0230	IZZOLA NEW, -CHBAD-, PIEL 0230 CHOCOLATE.	PT
valida	3755-23-P0332	IZZOLA NEW, -CHBAD-, PIEL 0332 CIMARRON.	PT
valida	3755-23-P0433	IZZOLA NEW, -CHBAD-, PIEL 0433 CHERRY.	PT
valida	3755-23-P0412	IZZOLA NEW, -CHBAD-, PIEL 0512 CUOIO.	PT
valida	3755-23-P0619	IZZOLA NEW, -CHBAD-, PIEL 0619 BLEU.	PT
valida	3755-23-P0702	IZZOLA NEW, -CHBAD-, PIEL 0702 GRAFITO.	PT
valida	3755-22-P0301	IZZOLA NEW, -CHBAI-, PIEL 0301 NEGRO MATE.	PT
valida	3755-22-P0302	IZZOLA NEW, -CHBAI-, PIEL 0302 GRAYSH.	PT
valida	3755-22-P0303	IZZOLA NEW, -CHBAI-, PIEL 0303 BLANCO.	PT
valida	3755-22-P0306	IZZOLA NEW, -CHBAI-, PIEL 0306 CANELA.	PT
valida	3755-22-P0314	IZZOLA NEW, -CHBAI-, PIEL 0314 MOHO.	PT
valida	3755-22-P0318	IZZOLA NEW, -CHBAI-, PIEL 0318 MORA.	PT
valida	3755-22-P0321	IZZOLA NEW, -CHBAI-, PIEL 0321 TRIGO.	PT
valida	3755-22-P0322	IZZOLA NEW, -CHBAI-, PIEL 0322 LATTE.	PT
valida	3755-22-P0342	IZZOLA NEW, -CHBAI-, PIEL 0342 TOPO.	PT
valida	3755-22-P0406	IZZOLA NEW, -CHBAI-, PIEL 0406 CHEESE.	PT
valida	3755-22-P0502	IZZOLA NEW, -CHBAI-, PIEL 0502 MARBLE.	PT
valida	3755-22-P0415	IZZOLA NEW, -CHBAI-, PIEL 0515 MOON.	PT
valida	3755-22-P0619	IZZOLA NEW, -CHBAI-, PIEL 0619 BLEU.	PT
valida	3755-40-P0230	IZZOLA NEW, -E-, PIEL 0230 CHOCOLATE.	PT
valida	3755-40-P0301	IZZOLA NEW, -E-, PIEL 0301 NEGRO MATE.	PT
valida	3755-40-P0303	IZZOLA NEW, -E-, PIEL 0303 BLANCO.	PT
valida	3755-40-P0314	IZZOLA NEW, -E-, PIEL 0314 MOHO.	PT
valida	3755-40-P0318	IZZOLA NEW, -E-, PIEL 0318 MORA.	PT
valida	3755-40-P0321	IZZOLA NEW, -E-, PIEL 0321 TRIGO.	PT
valida	3755-40-P0322	IZZOLA NEW, -E-, PIEL 0322 LATTE.	PT
valida	3755-40-P0332	IZZOLA NEW, -E-, PIEL 0332 CIMARRON.	PT
valida	3755-40-P0337	IZZOLA NEW, -E-, PIEL 0337 NATURAL.	PT
valida	3755-40-P0342	IZZOLA NEW, -E-, PIEL 0342 TOPO.	PT
valida	3755-40-P0402	IZZOLA NEW, -E-, PIEL 0402 GRIS.	PT
valida	3755-40-P0433	IZZOLA NEW, -E-, PIEL 0433 CHERRY.	PT
valida	3755-40-P0501	IZZOLA NEW, -E-, PIEL 0501 OREGON BLACK.	PT
valida	3755-40-P0502	IZZOLA NEW, -E-, PIEL 0502 MARBLE.	PT
valida	3755-40-P0412	IZZOLA NEW, -E-, PIEL 0512 CUOIO.	PT
valida	3755-40-P0415	IZZOLA NEW, -E-, PIEL 0515 MOON.	PT
valida	3755-40-P0611	IZZOLA NEW, -E-, PIEL 0611 NEGRO.	PT
valida	3755-40-P0619	IZZOLA NEW, -E-, PIEL 0619 BLEU.	PT
valida	3755-40-P0544	IZZOLA NEW, -E-, PIEL 0644 CARBON.	PT
valida	3755-09-P0325	IZZOLA NEW,-1BBD-1SB-1SB-E-1SB-1BBI,  0325 FANGO.	PT
valida	3755-07-P0230	IZZOLA NEW,-1BBI-1SB-1SB-E-1SB-CHBAD-, PIEL 0230 CHOCOLATE.	PT
valida	3755-07-P0332	IZZOLA NEW,-1BBI-1SB-1SB-E-1SB-CHBAD-, PIEL 0332 CIMARRON.	PT
valida	3755-07-P0412	IZZOLA NEW,-1BBI-1SB-1SB-E-1SB-CHBAD-, PIEL 0512 CUOIO.	PT
valida	3755-07-P0619	IZZOLA NEW,-1BBI-1SB-1SB-E-1SB-CHBAD-, PIEL 0619 BLEU.	PT
valida	3755-04-P0230	IZZOLA NEW,-1BBI-1SB-1SB-E-CHBAD-, PIEL 0230 CHOCOLATE.	PT
valida	3755-04-P0332	IZZOLA NEW,-1BBI-1SB-1SB-E-CHBAD-, PIEL 0332 CIMARRON.	PT
valida	3755-04-P0406	IZZOLA NEW,-1BBI-1SB-1SB-E-CHBAD-, PIEL 0406 CHEESE.	PT
valida	3755-12-P0544	IZZOLA NEW,-1BBI-1SB-E-1SB-1BBD,  0644 CARBON.	PT
valida	3755-05-P0301	IZZOLA NEW,-1BBI-1SB-E-1SB-1SB-CHBAD, PIEL 0301 NEGRO.	PT
valida	3755-05-P0302	IZZOLA NEW,-1BBI-1SB-E-1SB-1SB-CHBAD, PIEL 0302 GRAYSH.	PT
valida	3755-05-P0314	IZZOLA NEW,-1BBI-1SB-E-1SB-1SB-CHBAD, PIEL 0314 MOHO.	PT
valida	3755-05-P0402	IZZOLA NEW,-1BBI-1SB-E-1SB-1SB-CHBAD, PIEL 0402 GRIS.	PT
valida	3755-09-P0337	IZZOLA NEW,-1BBI-1SB-E-1SB-CHBAD,  0337 NATURAL.	PT
valida	3755-13-P0314	IZZOLA NEW,1BBI-E-1SB-1SB-1SB-1SB-1SB-CHBD, PIEL 0314 MOHO.	PT
valida	3755-10-P0619	IZZOLA NEW,-CHBAI-1SB-1SB-1SB-E-1SB-1BBD-, PIEL 0619 BLEU.	PT
valida	3755-11-P0406	IZZOLA NEW,-CHBAI-1SB-E-1SB-1BBD-, PIEL 0406 CHEESE.	PT
valida	3755-08-P0318	IZZOLA NEW,-CHBAI-1SB-E-1SB-1SB-1BBD-, PIEL 0318 MORA.	PT
valida	3755-08-P0322	IZZOLA NEW,-CHBAI-1SB-E-1SB-1SB-1BBD-, PIEL 0322 LATTE.	PT
valida	3755-08-P0502	IZZOLA NEW,-CHBAI-1SB-E-1SB-1SB-1BBD-, PIEL 0502 MARBLE.	PT
valida	3686-19-P0230	IZZOLA, -1BBD-, PIEL 0230 CHOCOLATE.	PT
valida	3686-18-P0230	IZZOLA, -1BBI-, PPIEL 0230 CHOCOLATE.	PT
valida	3686-04-P0342	IZZOLA, 1BBI-1SB-E-1SB-1SB-1BBD, PIEL 0342 TOPO.	PT
valida	3686-07-P0230	IZZOLA, 1BBI-1SB-E-1SB-1SB-CHBAD, PIEL 0230 CHOCOLATE.	PT
valida	3686-07-P0332	IZZOLA, 1BBI-1SB-E-1SB-1SB-CHBAD, PIEL 0332 CIMARRON.	PT
valida	3686-17-P0230	IZZOLA, -1SB-, PIEL 0230 CHOCOLATE.	PT
valida	3686-17-P0619	IZZOLA, -1SB-, PIEL 0619 BLEU.	PT
valida	3686-22-P0230	IZZOLA, -CHBAD-, PIEL 0230 CHOCOLATE.	PT
valida	3686-23-P0230	IZZOLA, -CHBAI-, PIEL 0230 CHOCOLATE.	PT
valida	3686-06-P0230	IZZOLA, CHBAI-1SB-1SB-E-1SB-1BBD, PIEL 0230 CHOCOLATE.	PT
valida	3686-40-P0230	IZZOLA, -E-, PIEL 0230 CHOCOLATE.	PT
valida	ZAR0804	JERRY (MO) -COMPLEMENTO- CUERO 42 FANGO	PT
valida	ZAR0801	KADIR (MO) -MESITA-150X80X24	PT
valida	3636-01-B0004	KAFKA, -1-, PIEL 0301 NEGRO / TELA CEZZANE BEIGE / TELA OLAS MARFIL ALASKA	PT
valida	3636-07-B0053	KAFKA, -1BDAD-, PIEL 0422 BUCK HUMO / TELA INK ALMENDRA / TELA OLAS MARFIL ALASKA.	PT
valida	3636-07-B0052	KAFKA, -1BDAD-, PIEL 0422 BUCK HUMO/PIEL 0515 MOON/TELA PLATINUM-KAYE-PEBBLE.	PT
valida	3636-07-B0086	KAFKA, -1BDAD-, PIEL 0515 MOON / TELA INK ALMENDRA / TELA OLAS MARFIL ALASKA.	PT
valida	3636-07-B0036	KAFKA, -1BDAD-, PIEL 0803 VAINILLA / TELA CEZZANE BEIGE / TELA OLAS MARFIL ALASKA	PT
valida	3636-11-B0036	KAFKA, -1BIAI-, PIEL 0803 VAINILLA / TELA CEZZANE BEIGE / TELA OLAS MARFIL ALASKA	PT
valida	3636-10-B0053	KAFKA, -1SB-, PIEL 0422 BUCK HUMO / TELA INK ALMENDRA / TELA OLAS MARFIL ALASKA.	PT
valida	3636-10-B0052	KAFKA, -1SB-, PIEL 0422 BUCK HUMO/PIEL 0515 MOON/TELA PLATINUM-KAYE-PEBBLE.	PT
valida	3636-10-B0086	KAFKA, -1SB-, PIEL 0515 MOON / TELA INK ALMENDRA / TELA OLAS MARFIL ALASKA.	PT
valida	3636-10-B0036	KAFKA, -1SB-, PIEL 0803 VAINILLA / TELA CEZZANE BEIGE / TELA OLAS MARFIL ALASKA	PT
valida	3636-06-B0053	KAFKA, -1SBAD-, PIEL 0422 BUCK HUMO / TELA INK ALMENDRA / TELA OLAS MARFIL ALASKA.	PT
valida	3636-06-B0052	KAFKA, -1SBAD-, PIEL 0422 BUCK HUMO/PIEL 0515 MOON/TELA PLATINUM-KAYE-PEBBLE.	PT
valida	3636-06-B0036	KAFKA, -1SBAD-, PIEL 0803 VAINILLA / TELA CEZZANE BEIGE / TELA OLAS MARFIL ALASKA	PT
valida	3636-27-B0053	KAFKA, -1SBAI-, PIEL 0422 BUCK HUMO / TELA INK ALMENDRA / TELA OLAS MARFIL ALASKA.	PT
valida	3636-27-B0052	KAFKA, -1SBAI-, PIEL 0422 BUCK HUMO/PIEL 0515 MOON/TELA PLATINUM-KAYE-PEBBLE.	PT
valida	3636-27-B0036	KAFKA, -1SBAI-, PIEL 0803 VAINILLA / TELA CEZZANE BEIGE / TELA OLAS MARFIL ALASKA	PT
valida	3636-66-B0052	KAFKA, 1SBAI-1SB-1SBAD-1SBAI-1BDAD- PIEL 0422 BUCK HUMO/PIEL 0515 MOON/TELA PLATINUM-KAYE-PEBBLE.	PT
valida	3636-66-B0053	KAFKA, 1SBAI-1SB-1SBAD-1SBAI-1BDAD-,PIEL 0422 BUCK HUMO/TELA INK ALMENDRA/TELA OLAS MARFIL ALASKA.	PT
valida	3636-50-B0075	KAFKA, -CS-, TELA INK ALMENDRA.	PT
valida	3636-21-P0204	KAFKA, -TC-, PIEL 0204 ARENA.	PT
valida	3636-21-P0415	KAFKA, -TC-, PIEL 0515 MOON.	PT
valida	3636-21-P0814	KAFKA, -TC-, PIEL 0814 CAPUCHINO.	PT
valida	3636-22-B0050	KAFKA, -TG-, TELA INK ALMENDRA.	PT
valida	3789-37-P0701	KARLO, -1R-, PIEL 0701 WENGE.	PT
valida	ZAR0724	KEBY (PROTO) -1R- PIEL 0442 TOPO.	PT
valida	3753-37-P0806	KEBY, -1R-, PIEL 0806 ACERO.	PT
valida	3668-07-P0314	KENZZI, -REC KS-, PIEL 0314 MOHO.	PT
valida	3668-08-P0402	KENZZI, -REC MAT-, PIEL 0402 GRIS.	PT
valida	3568-32-P0303	KENZZO, 3-2, PIEL 0303 BLANCO.	PT
valida	3568-32-P0314	KENZZO, 3-2, PIEL 0314 MOHO.	PT
valida	3664-07-P0312	KIRSH 1RBI-1SB-CHBD PIEL 0312 NIEVE.	PT
valida	3664-07-P0408	KIRSH 1RBI-1SB-CHBD PIEL 0408 SEPIA.	PT
valida	3664-38-P0312	KIRSH, -1RBD-, PIEL 0312 NIEVE.	PT
valida	3664-38-P0313	KIRSH, -1RBD-, PIEL 0313 CUIR.	PT
valida	3664-39-P0313	KIRSH, -1RBI-, PIEL 0313 CUIR.	PT
valida	3664-39-P0314	KIRSH, -1RBI-, PIEL 0314 MOHO.	PT
valida	3664-16-P0301	KIRSH, 1RBI-1RSB-CHBD, PIEL 0301 NEGRO.	PT
valida	3664-05-P0312	KIRSH, 1RBI-1RSB-CHBD, PIEL 0312 NIEVE.	PT
valida	3664-18-P0321	KIRSH, 1RBI-1SB-1RBD-, PIEL 0321 TRIGO.	PT
valida	3664-18-P0408	KIRSH, 1RBI-1SB-1RBD-, PIEL 0408 SEPIA.	PT
valida	3664-36-P0312	KIRSH, -1RSB-, PIEL 0312 NIEVE.	PT
valida	3664-36-P0314	KIRSH, -1RSB-, PIEL 0314 MOHO.	PT
valida	3664-35-P0312	KIRSH, -1SB-, PIEL 0312 NIEVE.	PT
valida	3664-35-P0408	KIRSH, -1SB-, PIEL 0408 SEPIA.	PT
valida	3664-22-P0313	KIRSH, -CHBD-, PIEL 0313 CUIR.	PT
valida	3664-22-P0314	KIRSH, -CHBD-, PIEL 0314 MOHO.	PT
valida	3664-23-P0312	KIRSH, -CHBI-, PIEL 0312 NIEVE.	PT
valida	3664-23-P0313	KIRSH, -CHBI-, PIEL 0313 CUIR.	PT
valida	3664-19-P0314	KIRSH, CHBI-1SB-1RBD-, PIEL 0314 MOHO.	PT
valida	3664-19-P0321	KIRSH, CHBI-1SB-1RBD-, PIEL 0321 TRIGO.	PT
valida	3664-19-P0408	KIRSH, CHBI-1SB-1RBD-, PIEL 0408 SEPIA.	PT
valida	17009	KIT ESPECIAL PIZZA 2R ELECTRICO #2	MP
valida	3703-41-P0311	KUNO, -SILLA-, PIEL 0311 MARFIL.	PT
valida	3703-41-P0312	KUNO, -SILLA-, PIEL 0312 NIEVE.	PT
valida	3703-41-P0339	KUNO, -SILLA-, PIEL 0339 POLAR.	PT
valida	3703-41-P0342	KUNO, -SILLA-, PIEL 0342 TOPO.	PT
valida	3703-41-P0402	KUNO, -SILLA-, PIEL 0402 GRIS.	PT
valida	3703-41-P0415	KUNO, -SILLA-, PIEL 0515 MOON.	PT
valida	3703-41-B0050	KUNO, -SILLA-, TELA INK ALMENDRA.	PT
valida	3635-01-P0412	LA MATTI, -1-, PIEL 0512 CUOIO.	PT
valida	ZAR0800	LITRO (MO) -MESITA- 45X45, BLANCO CARRARA MATE	PT
valida	ZAR0799	LITRO (MO) -MESITA- 55X55, BLANCO CARRARA MATE	PT
valida	3640-01-B0001	LONTANO -1- PIEL 0502 MARBLE / TELA CEZZANE BEIGE.	PT
valida	3640-03-B0001	LONTANO -3- PIEL 0502 MARBLE / TELA CEZZANE BEIGE.	PT
valida	ZAR0864	LOTUS (PROTO) 2R ELECTRICO PIEL 0415 MOON.	PT
valida	3629-01-P0412	LUKA, -1-, PIEL 0512 CUOIO.	PT
valida	3596-52-P0306	LUZZIANO, 1BI-1SB-1BD-, PIEL 0306 CANELA.	PT
valida	3596-52-P0412	LUZZIANO, 1BI-1SB-1BD-, PIEL 0512 CUOIO.	PT
valida	3596-52-P0414	LUZZIANO, 1BI-1SB-1BD-, PIEL 0514 CASTAÑO.	PT
valida	3596-52-P0544	LUZZIANO, 1BI-1SB-1BD-, PIEL 0644 CARBON.	PT
valida	3596-52-P0830	LUZZIANO, 1BI-1SB-1BD-, PIEL 0830 RED BROWN.	PT
valida	3596-52-B0082	LUZZIANO, -1BI-1SB-1BD-, TELA ZARK TERCIOPELO TINTO.	PT
valida	3596-57-P0703	LUZZIANO, -1BI-1SB-1BD-1BI-1BD-, PIEL 0703 VAINILLA.	PT
valida	3596-57-P0704	LUZZIANO, -1BI-1SB-1BD-1BI-1BD-, PIEL 0704 ALMENDRA.	PT
valida	3596-56-B0082	LUZZIANO, -1BI-1SB-1BD-T-, TELA ZARK TERCIOPELO TINTO.	PT
valida	3596-01-P0306	LUZZIANO, -1SB-, PIEL 0306 CANELA.	PT
valida	3596-01-P0318	LUZZIANO, -1SB-, PIEL 0318 MORA.	PT
valida	3596-01-P0342	LUZZIANO, -1SB-, PIEL 0342 TOPO.	PT
valida	3596-01-P0414	LUZZIANO, -1SB-, PIEL 0514 CASTAÑO	PT
valida	3596-01-P0544	LUZZIANO, -1SB-, PIEL 0644 CARBON.	PT
valida	3596-01-P0704	LUZZIANO, -1SB-, PIEL 0704 ALMENDRA.	PT
valida	3596-01-P0806	LUZZIANO, -1SB-, PIEL 0806 ACERO.	PT
valida	3596-01-P0830	LUZZIANO, -1SB-, PIEL 0830 RED BROWN.	PT
valida	3596-16-P0806	LUZZIANO, -3BI-, PIEL 0806 ACERO.	PT
valida	3596-51-P0806	LUZZIANO, 3BI-1SB-ED-1SB-T, PIEL 0806 ACERO.	PT
valida	3596-41-P0806	LUZZIANO, -ED-, PIEL 0806 ACERO.	PT
valida	3596-21-P0306	LUZZIANO, -T-, PIEL 0306 CANELA.	PT
valida	3596-21-P0318	LUZZIANO, -T-, PIEL 0318 MORA.	PT
valida	3596-21-P0342	LUZZIANO, -T-, PIEL 0342 TOPO.	PT
valida	3596-21-P0544	LUZZIANO, -T-, PIEL 0644 CARBON.	PT
valida	3596-21-P0806	LUZZIANO, -T-, PIEL 0806 ACERO.	PT
valida	3596-06-P0830	LUZZIANO, T-1SB-EI-3BD, PIEL 0830 RED BROWN.	PT
valida	3699-02-P0230	MANGIERI AMEX -2- PIEL 0230 CHOCOLATE.	PT
valida	3699-02-P0402	MANGIERI AMEX -2- PIEL 0402 GRIS.	PT
valida	3699-03-P0230	MANGIERI AMEX -3- PIEL 0230 CHOCOLATE.	PT
valida	3699-03-P0402	MANGIERI AMEX -3- PIEL 0402 GRIS.	PT
valida	3642-02-P0402	MANGIERI, -2-, PIEL 0402 GRIS	PT
valida	3642-03-P0301	MANGIERI, -3-, PIEL 0301 NEGRO.	PT
valida	3642-03-P0325	MANGIERI, -3-, PIEL 0325 FANGO.	PT
valida	ZAR0802	MAPOON (MO) -COMPLEMENTO- 240X340	PT
valida	ZAR0875	MASSAGE ANYWHERE, GRAY	PT
valida	3620-32-P0310	MAZZA, 3-2, PIEL 0310 BROWN.	PT
valida	3620-32-P0321	MAZZA, 3-2, PIEL 0321 TRIGO.	PT
valida	3706-32-P0229	MAZZALI, 3-2, PIEL 0229 CREMA.	PT
valida	3706-32-P0804	MAZZALI, 3-2, PIEL 0804 ALMENDRA.	PT
valida	3655-07-P0235	MAZZOLA -REC KS- PIEL 0235 OYSTER.	PT
valida	3655-07-P0310	MAZZOLA -REC KS- PIEL 0310 BROWN.	PT
valida	3655-07-P0318	MAZZOLA, -REC KS-, PIEL 0318 MORA.	PT
valida	3655-07-P0422	MAZZOLA, -REC KS-, PIEL 0422 BUCK HUMO.	PT
valida	3655-08-P0312	MAZZOLA, -REC MAT-, PIEL 0312 NIEVE.	PT
valida	3652-01-P0422	MELANZZANA, -1-, PIEL 0422 BUCK HUMO.	PT
valida	3652-02-P0230	MELANZZANA, -2-, PIEL 0230 CHOCOLATE.	PT
valida	3652-02-P0303	MELANZZANA, -2-, PIEL 0303 BLANCO.	PT
valida	3652-02-P0310	MELANZZANA, -2-, PIEL 0310 BROWN.	PT
valida	3652-02-P0312	MELANZZANA, -2-, PIEL 0312 NIEVE.	PT
valida	3652-02-P0319	MELANZZANA, -2-, PIEL 0319 NOGAL.	PT
valida	3652-02-P0501	MELANZZANA, -2-, PIEL 0501 OREGON BLACK.	PT
valida	3652-03-P0228	MELANZZANA, -3-, PIEL 0228 AMARETTO.	PT
valida	3652-03-P0230	MELANZZANA, -3-, PIEL 0230 CHOCOLATE.	PT
valida	3652-03-P0303	MELANZZANA, -3-, PIEL 0303 BLANCO.	PT
valida	3652-03-P0310	MELANZZANA, -3-, PIEL 0310 BROWN.	PT
valida	3652-03-P0312	MELANZZANA, -3-, PIEL 0312 NIEVE.	PT
valida	3652-03-P0314	MELANZZANA, -3-, PIEL 0314 MOHO.	PT
valida	3652-03-P0319	MELANZZANA, -3-, PIEL 0319 NOGAL.	PT
valida	3652-03-P0321	MELANZZANA, -3-, PIEL 0321 TRIGO.	PT
valida	3652-32-P0312	MELANZZANA, 3-2, PIEL 0312 NIEVE.	PT
valida	3652-91-P0422	MELANZZANA, M -1-, PIEL 0422 BUCK HUMO.	PT
valida	3652-92-P0230	MELANZZANA, M -2-, PIEL 0230 CHOCOLATE.	PT
valida	3652-92-P0501	MELANZZANA, M -2-, PIEL 0501 OREGON BLACK.	PT
valida	3652-93-P0230	MELANZZANA, M -3-, PIEL 0230 CHOCOLATE.	PT
valida	3652-93-P0314	MELANZZANA, M -3-, PIEL 0314 MOHO.	PT
valida	3652-93-P0321	MELANZZANA, M -3-, PIEL 0321 TRIGO.	PT
valida	3652-92-P0312	MELANZZANA,M -2-, PIEL 0312 NIEVE.	PT
valida	3652-93-P0312	MELANZZANA,M -3-, PIEL 0312 NIEVE.	PT
valida	3652-32-P0230	MELANZZANA,M 3-2, PIEL 0230 CHOCOLATE.	PT
valida	19320	MENOS PIEL 0402 GRIS	MP
valida	17628	MESA ABATIBLE DERECHO PIZZA B ELECTRICO (XIC) C/14416 PLACA CHICA.	MP
valida	16227	MESA ABATIBLE DERECHO PIZZA ELECTRICO C/14416 PLACA CHICA. (XIC).	MP
valida	17629	MESA ABATIBLE IZQUIERDO PIZZA B ELECTRICO (XIC) C/14686 PLACA GRANDE.	MP
valida	16226	MESA ABATIBLE IZQUIERDO PIZZA ELECTRICO C/14686 PLACA GRANDE. (XIC).	MP
valida	3769	MIKA,	PT
valida	3769-80-M0110	MIKA, -MESA CENTRAL- CHAPA EBANO NEGRO GABON.	PT
valida	3769-82-M0112	MIKA, -MESA CENTRAL- CHAPA EUCALIPTO, -EST MET NEG- (TEMP).	PT
valida	3769-81-M0112	MIKA, -MESA CENTRAL- CHAPA EUCALIPTO.	PT
valida	3770	MIKELE,	PT
valida	3770-35-B0095	MIKELE, -1MBD-, PIEL 0301 NEGRO / TELA INK ALMENDRA.	PT
valida	3770-35-B0063	MIKELE, -1MBD-, PIEL 0302 GRAYSH / TELA INK ALMENDRA.	PT
valida	3770-35-B0069	MIKELE, -1MBD-, PIEL 0302 GRAYSH / TELA ZARK TERCIOPELO BEIGE.	PT
valida	3770-35-B0086	MIKELE, -1MBD-, PIEL 0314 MOHO / TELA ZARK TERCIOPELO BEIGE.	PT
valida	3770-35-B0084	MIKELE, -1MBD-, PIEL 0342 TOPO / TELA ZARK TERCIOPELO BEIGE.	PT
valida	3770-35-P0342	MIKELE, -1MBD-, PIEL 0342 TOPO.	PT
valida	3770-35-B0080	MIKELE, -1MBD-, PIEL 0402 GRIS / TELA INK ALMENDRA.	PT
valida	3770-35-B0078	MIKELE, -1MBD-, PIEL 0402 GRIS / TELA INK ONIX.	PT
valida	3770-35-P0402	MIKELE, -1MBD-, PIEL 0402 GRIS.	PT
valida	3770-35-B0081	MIKELE, -1MBD-, PIEL 0515 MOON / TELA ZARK TERCIOPELO BEIGE.	PT
valida	3770-35-B0067	MIKELE, -1MBD-, PIEL 0515 MOON / TELA ZARK TERCIOPELO MUSE.	PT
valida	3770-35-P0415	MIKELE, -1MBD-, PIEL 0515 MOON.	PT
valida	3770-35-P0523	MIKELE, -1MBD-, PIEL 0623 CHAMPAGNE.	PT
valida	3770-35-B0100	MIKELE, -1MBD-, PIEL 0644 CARBON / TELA ZARK TERCIOPELO TINTO.	PT
valida	3770-35-P0544	MIKELE, -1MBD-, PIEL 0644 CARBON.	PT
valida	3770-35-B0050	MIKELE, -1MBD-, PIEL 0702 GRAFITO / TELA INK ALMENDRA.	PT
valida	3770-35-B0061	MIKELE, -1MBD-, PIEL 0702 GRAFITO / TELA ZARK TERCIOPELO GRIS.	PT
valida	3770-35-P0702	MIKELE, -1MBD-, PIEL 0702 GRAFITO.	PT
valida	3770-35-B0090	MIKELE, -1MBD-, PIEL 0814 CAPUCHINO / TELA ZARK TERCIOPELO MUSE.	PT
valida	3770-73-P0523	MIKELE, -1MBD-1MBI-, PIEL 0623 CHAMPAGNE.	PT
valida	3770-36-B0069	MIKELE, -1MBI-, PIEL 0302 GRAYSH / TELA ZARK TERCIOPELO BEIGE.	PT
valida	3770-36-P0303	MIKELE, -1MBI-, PIEL 0303 BLANCO.	PT
valida	3770-36-B0084	MIKELE, -1MBI-, PIEL 0342 TOPO / TELA ZARK TERCIOPELO BEIGE.	PT
valida	3770-36-P0342	MIKELE, -1MBI-, PIEL 0342 TOPO.	PT
valida	3770-36-B0067	MIKELE, -1MBI-, PIEL 0515 MOON / TELA ZARK TERCIOPELO MUSE.	PT
valida	3770-36-P0415	MIKELE, -1MBI-, PIEL 0515 MOON.	PT
valida	3770-36-P0523	MIKELE, -1MBI-, PIEL 0623 CHAMPAGNE.	PT
valida	3770-36-B0100	MIKELE, -1MBI-, PIEL 0644 CARBON / TELA ZARKS TERCIOPELO TINTO.	PT
valida	3770-36-P0544	MIKELE, -1MBI-, PIEL 0644 CARBON.	PT
valida	3770-36-B0050	MIKELE, -1MBI-, PIEL 0702 GRAFITO / TELA INK ALMENDRA.	PT
valida	3770-36-B0061	MIKELE, -1MBI-, PIEL 0702 GRAFITO / TELA ZARK TERCIOPELO GRIS.	PT
valida	3770-36-P0702	MIKELE, -1MBI-, PIEL 0702 GRAFITO.	PT
valida	3770-36-P0814	MIKELE, -1MBI-, PIEL 0814 CAPUCHINO.	PT
valida	3770-37-P0544	MIKELE, -1MSBRD+-, PIEL 0644 CARBON.	PT
valida	3770-37-P0303	MIKELE, -1MSBRD+-,PIEL 0303 BLANCO.	PT
valida	3770-37-P0523	MIKELE, -1MSBRD+-,PIEL 0623 CHAMPAGNE.	PT
valida	3770-37-P0702	MIKELE, -1MSBRD+-,PIEL 0702 GRAFITO.	PT
valida	3770-37-B0084	MIKELE, -1MSBRD+-,TELA ZARK TERCIOPELO BEIGE.	PT
valida	3770-37-B0057	MIKELE, -1MSBRD+-,TELA ZARK TERCIOPELO GRIS.	PT
valida	3770-37-B0055	MIKELE, -1MSBRD+-,TELA ZARK TERCIOPELO MUSE.	PT
valida	3770-38-P0402	MIKELE, -1MSBRI+-, PIEL 0402 GRIS.	PT
valida	3770-38-P0415	MIKELE, -1MSBRI+-, PIEL 0515 MOON.	PT
valida	3770-38-P0523	MIKELE, -1MSBRI+-, PIEL 0623 CHAMPAGNE.	PT
valida	3770-38-P0544	MIKELE, -1MSBRI+-, PIEL 0644 CARBON.	PT
valida	3770-38-P0702	MIKELE, -1MSBRI+-, PIEL 0702 GRAFITO.	PT
valida	3770-38-B0050	MIKELE, -1MSBRI+-, TELA INK ALMENDRA.	PT
valida	3770-38-B0079	MIKELE, -1MSBRI+-, TELA INK ONIX.	PT
valida	3770-38-B0056	MIKELE, -1MSBRI+-, TELA ZARK TERCIOPELO BEIGE.	PT
valida	3770-38-B0057	MIKELE, -1MSBRI+-, TELA ZARK TERCIOPELO GRIS.	PT
valida	3770-38-B0055	MIKELE, -1MSBRI+-, TELA ZARK TERCIOPELO MUSE.	PT
valida	3770-38-B0098	MIKELE, -1MSBRI+-, TELA ZARK TERCIOPELO TINTO.	PT
valida	3770-45-B0050	MIKELE, -3MBD-, PIEL 0702 GRAFITO / TELA INK ALMENDRA.	PT
valida	3770-45-P0702	MIKELE, -3MBD-, PIEL 0702 GRAFITO.	PT
valida	3770-40-B0098	MIKELE, -3MSBRD+-,TELA ZARK TERCIOPELO TINTO.	PT
valida	3770-40-P0402	MIKELE, -3MSBRI+-,PIEL 0402 GRIS.	PT
valida	3770-40-P0523	MIKELE, -3MSBRI+-,PIEL 0623 CHAMPAGNE.	PT
valida	3770-40-P0702	MIKELE, -3MSBRI+-,PIEL 0702 GRAFITO.	PT
valida	3770-40-B0050	MIKELE, -3MSBRI+-,TELA INK ALMENDRA.	PT
valida	3770-40-B0055	MIKELE, -3MSBRI+-,TELA ZARK TERCIOPELO MUSE.	PT
valida	3770-48-B0095	MIKELE, -CC-, PIEL 0301 NEGRO / TELA INK ALMENDRA.	PT
valida	3770-48-B0063	MIKELE, -CC-, PIEL 0302 GRAYSH / TELA INK ALMENDRA.	PT
valida	3770-48-P0302	MIKELE, -CC-, PIEL 0302 GRAYSH.	PT
valida	3770-48-P0303	MIKELE, -CC-, PIEL 0303 BLANCO.	PT
valida	3770-48-B0084	MIKELE, -CC-, PIEL 0342 TOPO / TELA ZARK TERCIOPELO BEIGE.	PT
valida	3770-48-P0342	MIKELE, -CC-, PIEL 0342 TOPO.	PT
valida	3770-48-B0080	MIKELE, -CC-, PIEL 0402 GRIS / TELA INK ALMENDRA.	PT
valida	3770-48-B0078	MIKELE, -CC-, PIEL 0402 GRIS / TELA INK ONIX.	PT
valida	3770-48-P0402	MIKELE, -CC-, PIEL 0402 GRIS.	PT
valida	3770-48-B0081	MIKELE, -CC-, PIEL 0515 MOON / TELA ZARK TERCIOPELO BEIGE.	PT
valida	3770-48-P0415	MIKELE, -CC-, PIEL 0515 MOON.	PT
valida	3770-48-B0085	MIKELE, -CC-, PIEL 0623 CHAMPAGNE / TELA ZARK TERCIOPELO BEIGE.	PT
valida	3770-48-B0099	MIKELE, -CC-, PIEL 0644 CARBON / TELA ZARKS TERCIOPELO MOUSE	PT
valida	3770-48-B0100	MIKELE, -CC-, PIEL 0644 CARBON / TELA ZARKS TERCIOPELO TINTO	PT
valida	3770-48-B0050	MIKELE, -CC-, PIEL 0702 GRAFITO / TELA INK ALMENDRA.	PT
valida	3770-48-B0061	MIKELE, -CC-, PIEL 0702 GRAFITO / TELA ZARK TERCIOPELO GRIS.	PT
valida	3770-48-P0702	MIKELE, -CC-, PIEL 0702 GRAFITO.	PT
valida	3770-48-B0090	MIKELE, -CC-, PIEL 0814 CAPUCHINO / TELA ZARK TERCIOPELO MUSE	PT
valida	3770-51-B0069	MIKELE, -CD-, PIEL 0302 GRAYSH / TELA ZARK TERCIOPELO BEIGE.	PT
valida	3770-51-B0070	MIKELE, -CD-, PIEL 0318 MORA / TELA ZARK TERCIOPELO GRIS.	PT
valida	3770-51-B0096	MIKELE, -CD-, PIEL 0325 FANGO/ TELA ZARK TERCIOPELO BEIGE.	PT
valida	3770-51-B0084	MIKELE, -CD-, PIEL 0342 TOPO / TELA ZARK TERCIOPELO BEIGE.	PT
valida	3770-51-B0078	MIKELE, -CD-, PIEL 0402 GRIS / TELA INK ONIX.	PT
valida	3770-51-B0071	MIKELE, -CD-, PIEL 0402 GRIS/ TELA ZARK TERCIOPELO GRIS.	PT
valida	3770-51-B0081	MIKELE, -CD-, PIEL 0515 MOON/ TELA ZARK TERCIOPELO BEIGE.	PT
valida	3770-51-B0083	MIKELE, -CD-, PIEL 0515 MOON/ TELA ZARK TERCIOPELO TINTO.	PT
valida	3770-51-B0085	MIKELE, -CD-, PIEL 0623 CHAMPAGNE/ TELA ZARK TERCIOPELO BEIGE.	PT
valida	3770-51-B0061	MIKELE, -CD-, PIEL 0702 GRAFITO / TELA ZARK TERCIOPELO GRIS.	PT
valida	3770-51-B0090	MIKELE, -CD-, PIEL 0814 CAPUCHINO/ TELA ZARK TERCIOPELO MUSE.	PT
valida	3770-49-P0415	MIKELE, -CG-, PIEL 0515 MOON.	PT
valida	3770-49-P0702	MIKELE, -CG-, PIEL 0702 GRAFITO.	PT
valida	3770-49-B0050	MIKELE, -CG-, TELA INK ALMENDRA.	PT
valida	3770-49-B0056	MIKELE, -CG-, TELA ZARK TERCIOPELO BEIGE.	PT
valida	3770-49-B0057	MIKELE, -CG-, TELA ZARK TERCIOPELO GRIS.	PT
valida	3770-49-B0055	MIKELE, -CG-, TELA ZARK TERCIOPELO MUSE.	PT
valida	3770-49-B0062	MIKELE, -CG-, TELA ZARK TERCIOPELO TURQUESA.	PT
valida	3770-41-P0303	MIKELE, -CHBD-, PIEL 0303 BLANCO.	PT
valida	3770-41-B0098	MIKELE, -CHBD-, PIEL 0402 GRIS / TELA  ZARKS TERCIOPELO TINTO.	PT
valida	3770-41-B0050	MIKELE, -CHBD-, PIEL 0702 GRAFITO / TELA INK ALMENDRA.	PT
valida	3770-41-P0702	MIKELE, -CHBD-, PIEL 0702 GRAFITO.	PT
valida	3770-41-P0814	MIKELE, -CHBD-, PIEL 0814 CAPUCHINO.	PT
valida	3770-42-B0098	MIKELE, -CHBI-, PIEL 0402 GRIS / TELA  ZARKS TERCIOPELO TINTO.	PT
valida	3770-42-P0544	MIKELE, -CHBI-, PIEL 0644 CARBON.	PT
valida	3770-50-B0063	MIKELE, -CS-, PIEL 0302 GRAYSH / TELA INK ALMENDRA.	PT
valida	3770-50-B0080	MIKELE, -CS-, PIEL 0402 GRIS / TELA INK ALMENDRA.	PT
valida	3770-50-B0050	MIKELE, -CS-, PIEL 0702 GRAFITO / TELA INK ALMENDRA.	PT
valida	3770-50-P0702	MIKELE, -CS-, PIEL 0702 GRAFITO.	PT
valida	3770-50-CB0095	MIKELE, -CS-CUILTEADO, PIEL 0301 NEGRO / TELA INK ALMENDRA.	PT
valida	3770-50-CB0069	MIKELE, -CS-CUILTEADO, PIEL 0302 GRAYSH / TELA ZARK TERCIOPELO BEIGE.	PT
valida	3770-50-CP0303	MIKELE, -CS-CUILTEADO, PIEL 0303 BLANCO.	PT
valida	3770-50-CB0070	MIKELE, -CS-CUILTEADO, PIEL 0318 MORA / TELA ZARK TERCIOPELO GRIS.	PT
valida	3770-50-CP0325	MIKELE, -CS-CUILTEADO, PIEL 0325 FANGO.	PT
valida	3770-50-CB0084	MIKELE, -CS-CUILTEADO, PIEL 0342 TOPO / TELA ZARK TERCIOPELO BEIGE.	PT
valida	3770-50-CB0071	MIKELE, -CS-CUILTEADO, PIEL 0402 GRIS / TELA ZARK TERCIOPELO GRIS.	PT
valida	3770-50-CB0081	MIKELE, -CS-CUILTEADO, PIEL 0515 MOON / TELA ZARK TERCIOPELO BEIGE.	PT
valida	3770-50-CB0067	MIKELE, -CS-CUILTEADO, PIEL 0515 MOON / TELA ZARK TERCIOPELO MUSE.	PT
valida	3770-50-CB0083	MIKELE, -CS-CUILTEADO, PIEL 0515 MOON / TELA ZARK TERCIOPELO TINTO.	PT
valida	3770-50-CP0415	MIKELE, -CS-CUILTEADO, PIEL 0515 MOON.	PT
valida	3770-50-CP0523	MIKELE, -CS-CUILTEADO, PIEL 0623 CHAMPAGNE.	PT
valida	3770-50-CB0085	MIKELE, -CS-CUILTEADO, PIEL 0623 CHAMPAGNE/ TELA ZARKS TERCIOPELO BEIGE.	PT
valida	3770-50-CB0099	MIKELE, -CS-CUILTEADO, PIEL 0644 CARBON / TELA ZARKS TERCIOPELO MOUSE.	PT
valida	3770-50-CB0100	MIKELE, -CS-CUILTEADO, PIEL 0644 CARBON / TELA ZARKS TERCIOPELO TINTO.	PT
valida	3770-50-CB0061	MIKELE, -CS-CUILTEADO, PIEL 0702 GRAFITO / TELA ZARK TERCIOPELO GRIS.	PT
valida	3770-50-CP0702	MIKELE, -CS-CUILTEADO, PIEL 0702 GRAFITO.	PT
valida	3770-50-CB0090	MIKELE, -CS-CUILTEADO, PIEL 0814 CAPUCHINO / TELA ZARK TERCIOPELO MUSE.	PT
valida	3770-47-CP0301	MIKELE, -S- CUILTEADO, PIEL 0301 NEGRO.	PT
valida	3770-47-CP0302	MIKELE, -S- CUILTEADO, PIEL 0302 GRAYSH.	PT
valida	3770-47-CP0314	MIKELE, -S- CUILTEADO, PIEL 0314 MOHO.	PT
valida	3770-47-CP0318	MIKELE, -S- CUILTEADO, PIEL 0318 MORA.	PT
valida	3770-47-CP0325	MIKELE, -S- CUILTEADO, PIEL 0325 FANGO.	PT
valida	3770-47-CP0342	MIKELE, -S- CUILTEADO, PIEL 0342 TOPO.	PT
valida	3770-47-CP0415	MIKELE, -S- CUILTEADO, PIEL 0515 MOON.	PT
valida	3770-47-CP0544	MIKELE, -S- CUILTEADO, PIEL 0644 CARBON.	PT
valida	3770-47-B0061	MIKELE, -S- CUILTEADO, PIEL 0702 GRAFITO / TELA ZARK TERCIOPELO GRIS.	PT
valida	3770-47-CP0702	MIKELE, -S- CUILTEADO, PIEL 0702 GRAFITO.	PT
valida	3770-47-CP0814	MIKELE, -S- CUILTEADO, PIEL 0814 CAPUCHINO.	PT
valida	3770-47-CB0056	MIKELE, -S- CUILTEADO, TELA ZARK TERCIOPELO BEIGE.	PT
valida	3770-47-CB0057	MIKELE, -S- CUILTEADO, TELA ZARK TERCIOPELO GRIS.	PT
valida	3770-47-CB0062	MIKELE, -S- CUILTEADO, TELA ZARK TERCIOPELO TURQUESA.	PT
valida	3770-47-B0063	MIKELE, -S- PIEL 0302 GRAYSH / TELA INK ALMENDRA.	PT
valida	3770-47-B0080	MIKELE, -S-, PIEL 0402 GRIS / TELA INK ALMENDRA.	PT
valida	3770-47-B0085	MIKELE, -S-, PIEL 0523 CHAMPAGNE/ TELA ZARKS TERCIOPELO BEIGE.	PT
valida	3770-47-B0050	MIKELE, -S-, PIEL 0702 GRAFITO / PIEL 0302 GRAYSH / TELA INK ALMENDRA.	PT
valida	3770-43-CB0095	MIKELE, -T- CUILTEADO, PIEL 0301 NEGRO / TELA INK ALMENDRA.	PT
valida	3770-43-CP0301	MIKELE, -T- CUILTEADO, PIEL 0301 NEGRO.	PT
valida	3770-43-CB0069	MIKELE, -T- CUILTEADO, PIEL 0302 GRAYSH / TELA ZARK TERCIOPELO BEIGE .	PT
valida	3770-43-CP0302	MIKELE, -T- CUILTEADO, PIEL 0302 GRAYSH.	PT
valida	3770-43-CP0303	MIKELE, -T- CUILTEADO, PIEL 0303 BLANCO.	PT
valida	3770-43-CP0314	MIKELE, -T- CUILTEADO, PIEL 0314 MOHO.	PT
valida	3770-43-CP0318	MIKELE, -T- CUILTEADO, PIEL 0318 MORA.	PT
valida	3770-43-CB0084	MIKELE, -T- CUILTEADO, PIEL 0342 TOPO / TELA ZARK TERCIOPELO BEIGE .	PT
valida	3770-43-CP0342	MIKELE, -T- CUILTEADO, PIEL 0342 TOPO.	PT
valida	3770-43-CP0406	MIKELE, -T- CUILTEADO, PIEL 0406 CHEESE.	PT
valida	3770-43-CB0071	MIKELE, -T- CUILTEADO, PIEL 0412 GRIS / TELA ZARK TERCIOPELO GRIS.	PT
valida	3770-43-CB0081	MIKELE, -T- CUILTEADO, PIEL 0515 MOON / TELA ZARK TERCIOPELO BEIGE.	PT
valida	3770-43-CB0067	MIKELE, -T- CUILTEADO, PIEL 0515 MOON / TELA ZARK TERCIOPELO MUSE.	PT
valida	3770-43-CP0415	MIKELE, -T- CUILTEADO, PIEL 0515 MOON.	PT
valida	3770-43-CP0523	MIKELE, -T- CUILTEADO, PIEL 0623 CHAMPAGNE.	PT
valida	3770-43-CB0099	MIKELE, -T- CUILTEADO, PIEL 0644 CARBON / TELA ZARKS TERCIOPELO MOUSE.	PT
valida	3770-43-CB0061	MIKELE, -T- CUILTEADO, PIEL 0702 GRAFITO / TELA ZARK TERCIOPELO GRIS.	PT
valida	3770-43-CP0702	MIKELE, -T- CUILTEADO, PIEL 0702 GRAFITO.	PT
valida	3770-43-CB0090	MIKELE, -T- CUILTEADO, PIEL 0814 CAPUCHINO / TELA ZARK TERCIOPELO MUSE.	PT
valida	3770-43-CP0814	MIKELE, -T- CUILTEADO, PIEL 0814 CAPUCHINO.	PT
valida	3770-43-B0063	MIKELE, -T-, PIEL 0302 GRAYSH / TELA INK ALMENDRA.	PT
valida	3770-43-B0080	MIKELE, -T-, PIEL 0402 GRIS / TELA INK ALMENDRA.	PT
valida	3770-43-B0078	MIKELE, -T-, PIEL 0402 GRIS / TELA INK ONIX (ESPECIAL).	PT
valida	3770-43-P0415	MIKELE, -T-, PIEL 0515 MOON.	PT
valida	3770-43-B0050	MIKELE, -T-, PIEL 0702 GRAFITO / PIEL 0302 GRAYSH / TELA INK ALMENDRA.	PT
valida	3770-43-B0061	MIKELE, -T-, PIEL 0702 GRAFITO / TELA ZARKS TERCIOPELO GRIS.	PT
valida	3770-44-B0063	MIKELE, -TMX-, PIEL 0302 GRAYSH / TELA INK ALMENDRA.	PT
valida	3770-44-P0302	MIKELE, -TMX-, PIEL 0302 GRAYSH.	PT
valida	3770-44-B0080	MIKELE, -TMX-, PIEL 0402 GRIS / TELA INK ALMENDRA.	PT
valida	3770-44-P0415	MIKELE, -TMX-, PIEL 0515 MOON.	PT
valida	3770-44-B0081	MIKELE, -TMX-, PIEL 0515 MOON/ TELA ZARKS TERCIOPELO BEIGE.	PT
valida	3770-44-B0085	MIKELE, -TMX-, PIEL 0623 CHAMPAGNE/ TELA ZARKS TERCIOPELO BEIGE.	PT
valida	3770-44-B0050	MIKELE, -TMX-, PIEL 0702 GRAFITO / PIEL 0302 GRAYSH / TELA INK ALMENDRA.	PT
valida	3770-44-B0061	MIKELE, -TMX-, PIEL 0702 GRAFITO / TELA ZARK TERCIOPELO GRIS.	PT
valida	3770-44-P0702	MIKELE, -TMX-, PIEL 0702 GRAFITO.	PT
valida	3770-44-B0090	MIKELE, -TMX-, PIEL 0814 CAPUCHINO/ TELA ZARKS TERCIOPELO MUSE.	PT
valida	3770-60-B0050	MIKELE, -TMX-3MSBRI+-1MBD-, PIEL 0702 GRAFITO / PIEL 0302 GRAYSH / TELA INK ALMENDRA.	PT
valida	3770-71-B0063	MIKELE, -TMX-3MSBRI+-1MSBRI+-1MBD-T-, PIEL 0302 GRAYSH / TELA INK ALMENDRA.	PT
valida	3770-72-B0085	MIKELE, TMX-3MSBRI-TC-1SMBRD-TC-1MBD, PIEL 0623 CHAMPAGNE/ TELA ZARKS TERCIOPELO BEIGE.	PT
valida	3569-37-P0228	MINO -RECLI- PIEL 0228 AMARETTO	PT
valida	3569-37-P2229	MINO -RECLI- PIEL 0229 CREMA / PIEL 0129 CREMA.	PT
valida	3569-37-P0230	MINO -RECLI- PIEL 0230 CHOCOLATE.	PT
valida	3673-02-P0303	MIZZHA, -2-, PIEL 0303 BLANCO.	PT
valida	3673-03-P0303	MIZZHA, -3-, PIEL 0303 BLANCO.	PT
valida	ZAR0805	MOJITO (MO) -CARRITO MOJITO- 80X45X73	PT
valida	17612	MO-PS-1589 TRANSFORMER 19V-1A WALL POWER SUPPLY	MP
valida	3771	MORETTI 1B,	PT
valida	3771-51-P0427	MORETTI 1B, -1RB1-1RSB--1RSB-1RBD, PIEL 0427 BUCK MARRONE.	PT
valida	3771-38-P0228	MORETTI 1B, -1RBD- PIEL 0228 AMARETTO.	PT
valida	3771-38-P0301	MORETTI 1B, -1RBD- PIEL 0301 NEGRO.	PT
valida	3771-38-P0302	MORETTI 1B, -1RBD- PIEL 0302 GRAYSH.	PT
valida	3771-38-P0303	MORETTI 1B, -1RBD- PIEL 0303 BLANCO.	PT
valida	3771-38-P0310	MORETTI 1B, -1RBD- PIEL 0310 BROWN.	PT
valida	3771-38-P0322	MORETTI 1B, -1RBD- PIEL 0322 LATTE.	PT
valida	3771-38-P0325	MORETTI 1B, -1RBD- PIEL 0325 FANGO.	PT
valida	3771-38-P0342	MORETTI 1B, -1RBD- PIEL 0342 TOPO.	PT
valida	3771-38-P0402	MORETTI 1B, -1RBD- PIEL 0402 GRIS.	PT
valida	3771-38-P0427	MORETTI 1B, -1RBD- PIEL 0427 BUCK MARRONE.	PT
valida	3771-38-P0413	MORETTI 1B, -1RBD- PIEL 0513 SABBIA.	PT
valida	3771-38-P0414	MORETTI 1B, -1RBD- PIEL 0514 CASTAÑO.	PT
valida	3771-50-P0310	MORETTI 1B, -1RBD-IRSB-1SB-E-1RBI, PIEL 0310 BROWN.	PT
valida	3771-50-P0414	MORETTI 1B, -1RBD-IRSB-1SB-E-1RBI, PIEL 0514 CASTAÑO.	PT
valida	3771-39-P0228	MORETTI 1B, -1RBI- PIEL 0228 AMARETTO.	PT
valida	3771-39-P0301	MORETTI 1B, -1RBI- PIEL 0301 NEGRO.	PT
valida	3771-39-P0302	MORETTI 1B, -1RBI- PIEL 0302 GRAYSH.	PT
valida	3771-39-P0303	MORETTI 1B, -1RBI- PIEL 0303 BLANCO.	PT
valida	3771-39-P0310	MORETTI 1B, -1RBI- PIEL 0310 BROWN.	PT
valida	3771-39-P0322	MORETTI 1B, -1RBI- PIEL 0322 LATTE.	PT
valida	3771-39-P0325	MORETTI 1B, -1RBI- PIEL 0325 FANGO.	PT
valida	3771-39-P0342	MORETTI 1B, -1RBI- PIEL 0342 TOPO.	PT
valida	3771-39-P0402	MORETTI 1B, -1RBI- PIEL 0402 GRIS.	PT
valida	3771-39-P0427	MORETTI 1B, -1RBI- PIEL 0427 BUCK MARRONE.	PT
valida	3771-39-P0413	MORETTI 1B, -1RBI- PIEL 0513 SABBIA.	PT
valida	3771-39-P0414	MORETTI 1B, -1RBI- PIEL 0514 CASTAÑO.	PT
valida	3771-36-P0228	MORETTI 1B, -1RSB- PIEL 0228 AMARETTO.	PT
valida	3771-36-P0301	MORETTI 1B, -1RSB- PIEL 0301 NEGRO.	PT
valida	3771-36-P0302	MORETTI 1B, -1RSB- PIEL 0302 GRAYSH.	PT
valida	3771-36-P0310	MORETTI 1B, -1RSB- PIEL 0310 BROWN.	PT
valida	3771-36-P0322	MORETTI 1B, -1RSB- PIEL 0322 LATTE.	PT
valida	3771-36-P0325	MORETTI 1B, -1RSB- PIEL 0325 FANGO.	PT
valida	3771-36-P0402	MORETTI 1B, -1RSB- PIEL 0402 GRIS.	PT
valida	3771-36-P0427	MORETTI 1B, -1RSB- PIEL 0427 BUCK MARRONE.	PT
valida	3771-36-P0413	MORETTI 1B, -1RSB- PIEL 0513 SABBIA.	PT
valida	3771-36-P0414	MORETTI 1B, -1RSB- PIEL 0514 CASTAÑO.	PT
valida	3771-17-P0228	MORETTI 1B, -1SB- PIEL 0228 AMARETTO.	PT
valida	3771-17-P0301	MORETTI 1B, -1SB- PIEL 0301 NEGRO.	PT
valida	3771-17-P0302	MORETTI 1B, -1SB- PIEL 0302 GRAYSH.	PT
valida	3771-17-P0303	MORETTI 1B, -1SB- PIEL 0303 BLANCO.	PT
valida	3771-17-P0310	MORETTI 1B, -1SB- PIEL 0310 BROWN.	PT
valida	3771-17-P0322	MORETTI 1B, -1SB- PIEL 0322 LATTE.	PT
valida	3771-17-P0325	MORETTI 1B, -1SB- PIEL 0325 FANGO.	PT
valida	3771-17-P0413	MORETTI 1B, -1SB- PIEL 0513 SABBIA.	PT
valida	3771-17-P0414	MORETTI 1B, -1SB- PIEL 0514 CASTAÑO.	PT
valida	3771-40-P0301	MORETTI 1B, -E- PIEL 0301 NEGRO.	PT
valida	3771-40-P0302	MORETTI 1B, -E- PIEL 0302 GRAYSH.	PT
valida	3771-40-P0303	MORETTI 1B, -E- PIEL 0303 BLANCO.	PT
valida	3771-40-P0310	MORETTI 1B, -E- PIEL 0310 BROWN	PT
valida	3771-40-P0322	MORETTI 1B, -E- PIEL 0322 LATTE.	PT
valida	3771-40-P0325	MORETTI 1B, -E- PIEL 0325 FANGO.	PT
valida	3771-40-P0413	MORETTI 1B, -E- PIEL 0513 SABBIA.	PT
valida	3771-40-P0414	MORETTI 1B, -E- PIEL 0514 CASTAÑO	PT
valida	3564-38-P0229	MORETTI -1RBD- PIEL 0229 CREMA.	PT
valida	3564-38-P2230	MORETTI -1RBD- PIEL 0230 CHOCOLATE / PIEL 0130 CHOCOLATE.	PT
valida	3564-38-P0301	MORETTI -1RBD- PIEL 0301 NEGRO	PT
valida	3564-38-P0303	MORETTI -1RBD- PIEL 0303 BLANCO.	PT
valida	3564-38-P0319	MORETTI -1RBD- PIEL 0319 NOGAL.	PT
valida	3564-38-P0403	MORETTI -1RBD- PIEL 0403 BUCK OFF WHITE.	PT
valida	3564-38-P0413	MORETTI -1RBD- PIEL 0513 SABBIA.	PT
valida	3564-39-P0229	MORETTI -1RBI- PIEL 0229 CREMA.	PT
valida	3564-39-P2230	MORETTI -1RBI- PIEL 0230 CHOCOLATE / PIEL 0130 CHOCOLATE.	PT
valida	3564-39-P0301	MORETTI -1RBI- PIEL 0301 NEGRO.	PT
valida	3564-39-P0303	MORETTI -1RBI- PIEL 0303 BLANCO.	PT
valida	3564-39-P0319	MORETTI -1RBI- PIEL 0319 NOGAL.	PT
valida	3564-39-P0403	MORETTI -1RBI- PIEL 0403 BUCK OFF WHITE.	PT
valida	3564-39-P0413	MORETTI -1RBI- PIEL 0513 SABBIA.	PT
valida	3564-36-P0301	MORETTI -1RSB- PIEL 0301 NEGRO	PT
valida	3564-36-P0413	MORETTI -1RSB- PIEL 0513 SABBIA.	PT
valida	3564-35-P2230	MORETTI -1SB- PIEL 0230 CHOCOLATE / PIEL 0130 CHOCOLATE.	PT
valida	3564-35-P0319	MORETTI -1SB- PIEL 0319 NOGAL.	PT
valida	3564-35-P0413	MORETTI -1SB- PIEL 0513 SABBIA.	PT
valida	3564-98-B0029	MORETTI 2 -1RBD- PIEL 0229 CREMA / H. PANNA 1.2	PT
valida	3564-98-B0028	MORETTI 2 -1RBD- PIEL 0230 CHOCOLATE / H. IMPALA 1.2	PT
valida	3564-98-P0302	MORETTI 2 -1RBD- PIEL 0302 GRAYSH.	PT
valida	3564-98-P0312	MORETTI 2 -1RBD- PIEL 0312 NIEVE.	PT
valida	3564-98-P0314	MORETTI 2 -1RBD- PIEL 0314 MOHO.	PT
valida	3564-98-P0318	MORETTI 2 -1RBD- PIEL 0318 MORA.	PT
valida	3564-98-P0353	MORETTI 2 -1RBD- PIEL 0353 HONEY.	PT
valida	3564-98-P0502	MORETTI 2 -1RBD- PIEL 0502 MARBLE.	PT
valida	3564-99-P0302	MORETTI 2 -1RBI- PIEL 0302 GRAYSH.	PT
valida	3564-99-P0312	MORETTI 2 -1RBI- PIEL 0312 NIEVE.	PT
valida	3564-96-B0028	MORETTI 2 -1RSB- PIEL 0230 CHOCOLATE / H. IMPALA 1.2	PT
valida	3564-96-P0302	MORETTI 2 -1RSB- PIEL 0302 GRAYSH.	PT
valida	3564-96-P0312	MORETTI 2 -1RSB- PIEL 0312 NIEVE.	PT
valida	3564-96-P0314	MORETTI 2 -1RSB- PIEL 0314 MOHO.	PT
valida	3564-96-P0318	MORETTI 2 -1RSB- PIEL 0318 MORA.	PT
valida	3564-96-P0502	MORETTI 2 -1RSB- PIEL 0502 MARBLE.	PT
valida	3564-90-B0028	MORETTI 2 -E- PIEL 0230 CHOCOLATE / H. IMPALA 1.2	PT
valida	3564-90-P0312	MORETTI 2 -E- PIEL 0312 NIEVE.	PT
valida	3564-90-P0314	MORETTI 2 -E- PIEL 0314 MOHO.	PT
valida	3564-40-P0413	MORETTI -E- PIEL 0513 SABBIA.	PT
valida	3564-99-B0029	MORETTI, 2 -1RBI- PIEL 0229 CREMA / H. PANNA 1.2	PT
valida	3564-99-B0028	MORETTI, 2 -1RBI- PIEL 0230 CHOCOLATE / H. IMPALA 1.2	PT
valida	3564-99-P0314	MORETTI, 2 -1RBI- PIEL 0314 MOHO.	PT
valida	3564-99-P0318	MORETTI, 2 -1RBI- PIEL 0318 MORA.	PT
valida	3564-99-P0502	MORETTI, 2 -1RBI- PIEL 0502 MARBLE.	PT
valida	3564-95-B0028	MORETTI, 2 -1SB- PIEL 0230 CHOCOLATE / H. IMPALA 1.2	PT
valida	3564-95-P0312	MORETTI, 2 -1SB- PIEL 0312 NIEVE.	PT
valida	3564-95-P0314	MORETTI, 2 -1SB- PIEL 0314 MOHO.	PT
valida	3702-01-P0103	MOZZO, -1-, PIEL 0103 BLANCO.	PT
valida	3702-01-P0301	MOZZO, -1-, PIEL 0301 NEGRO.	PT
valida	3702-01-P0303	MOZZO, -1-, PIEL 0303 BLANCO.	PT
valida	3702-01-P0312	MOZZO, -1-, PIEL 0312 NIEVE.	PT
valida	3702-01-P0442	MOZZO, -1-, PIEL 0342 TOPO.	PT
valida	3702-01-P0415	MOZZO, -1-, PIEL 0515 MOON.	PT
valida	3702-01-P0702	MOZZO, -1-, PIEL 0702 GRAFITO.	PT
valida	3499-20-P0303	NEZZTA, -CHS-, PIEL 0303 BLANCO.	PT
valida	3499-20-P0501	NEZZTA, -CHS-, PIEL 0501 OREGON BLACK.	PT
valida	3499-20-P0526	NEZZTA, -CHS-, PIEL 0526 CIGAR.	PT
valida	3499-07-P0501	NEZZTA, -REC KS-, PIEL 0501 OREGON BLACK.	PT
valida	3499-07-P0526	NEZZTA, -REC KS-, PIEL 0526 CIGAR.	PT
valida	ZAR0873	NOVOXT BLACK SOFHYDE	PT
valida	ZAR0872	OPUS ESPRESSO SOFHYDE	PT
valida	3653-07-P0301	ORZZA, -REC KS-, PIEL 0301 NEGRO.	PT
valida	3653-07-P0312	ORZZA, -REC KS-, PIEL 0312 NIEVE.	PT
valida	ZAR0733	OTTOMANO (MO) PUFF PC0402 GRIS	PT
valida	ZAR0716	OTTOMANO (PROTO) -PUFF- PIEL 04 BUCK HUMO.	PT
valida	3758-29-P0422	OTTOMANO, -PUFF-, PIEL 0422 BUCK HUMO.	PT
valida	3758-29-P0619	OTTOMANO, -PUFF-, PIEL 0619 BLEU.	PT
valida	3758-29-P0640	OTTOMANO, -PUFF-, PIEL 0640 ROSE.	PT
valida	17563	PATA MADERA CORAZZ, POSTERIOR [CASCO].	MP
valida	17932	PATA MADERA TAZZO, 3-2, FRONTAL [CASCO].	MP
valida	17933	PATA MADERA TAZZO, 3-2, TRASERA [CASCO].	MP
valida	3773	PETROV 1B,	PT
valida	3773-37-P0501	PETROV 1B, -1R-, PIEL 0501 OREGON BLACK.	PT
valida	3773-39-P0204	PETROV 1B, -1RBD-, PIEL 0204 ARENA.	PT
valida	3773-39-P0229	PETROV 1B, -1RBD-, PIEL 0229 CREMA.	PT
valida	3773-39-P0301	PETROV 1B, -1RBD-, PIEL 0301 NEGRO.	PT
valida	3773-39-P0302	PETROV 1B, -1RBD-, PIEL 0302 GRAYSH.	PT
valida	3773-39-P0303	PETROV 1B, -1RBD-, PIEL 0303 BLANCO.	PT
valida	3773-39-P0306	PETROV 1B, -1RBD-, PIEL 0306 CANELA.	PT
valida	3773-39-P0307	PETROV 1B, -1RBD-, PIEL 0307 CHANTILLY.	PT
valida	3773-39-P0310	PETROV 1B, -1RBD-, PIEL 0310 BROWN.	PT
valida	3773-39-P0312	PETROV 1B, -1RBD-, PIEL 0312 NIEVE.	PT
valida	3773-39-P0314	PETROV 1B, -1RBD-, PIEL 0314 MOHO.	PT
valida	3773-39-P0318	PETROV 1B, -1RBD-, PIEL 0318 MORA.	PT
valida	3773-39-P0319	PETROV 1B, -1RBD-, PIEL 0319 NOGAL.	PT
valida	3773-39-P0337	PETROV 1B, -1RBD-, PIEL 0337 NATURAL.	PT
valida	3773-39-P0342	PETROV 1B, -1RBD-, PIEL 0342 TOPO.	PT
valida	3773-39-P0402	PETROV 1B, -1RBD-, PIEL 0402 GRIS.	PT
valida	3773-39-P0406	PETROV 1B, -1RBD-, PIEL 0406 CHEESE.	PT
valida	3773-39-P0422	PETROV 1B, -1RBD-, PIEL 0422 BUCK HUMO.	PT
valida	3773-39-P0433	PETROV 1B, -1RBD-, PIEL 0433 CHERRY.	PT
valida	3773-39-P0440	PETROV 1B, -1RBD-, PIEL 0440 ROBLE.	PT
valida	3773-39-P0412	PETROV 1B, -1RBD-, PIEL 0512 CUOIO.	PT
valida	3773-39-P0413	PETROV 1B, -1RBD-, PIEL 0513 SABBIA.	PT
valida	3773-39-P0415	PETROV 1B, -1RBD-, PIEL 0515 MOON.	PT
valida	3773-39-P0526	PETROV 1B, -1RBD-, PIEL 0526 CIGAR.	PT
valida	3773-39-P0607	PETROV 1B, -1RBD-, PIEL 0607 DEEP WATER.	PT
valida	3773-39-P0701	PETROV 1B, -1RBD-, PIEL 0701 WENGE.	PT
valida	3773-39-P0702	PETROV 1B, -1RBD-, PIEL 0702 GRAFITO.	PT
valida	3773-39-P0353	PETROV 1B, -1RBD-, PIEL P0353 HONEY.	PT
valida	3773-73-P0306	PETROV 1B, 1RBD-1RSB-1RSB-1RBI, PIEL 0306 CANELA.	PT
valida	3773-38-P0204	PETROV 1B, -1RBI-, PIEL 0204 ARENA.	PT
valida	3773-38-P0229	PETROV 1B, -1RBI-, PIEL 0229 CREMA.	PT
valida	3773-38-P0301	PETROV 1B, -1RBI-, PIEL 0301 NEGRO.	PT
valida	3773-38-P0302	PETROV 1B, -1RBI-, PIEL 0302 GRAYSH.	PT
valida	3773-38-P0303	PETROV 1B, -1RBI-, PIEL 0303 BLANCO.	PT
valida	3773-38-P0306	PETROV 1B, -1RBI-, PIEL 0306 CANELA.	PT
valida	3773-38-P0307	PETROV 1B, -1RBI-, PIEL 0307 CHANTILLY.	PT
valida	3773-38-P0310	PETROV 1B, -1RBI-, PIEL 0310 BROWN.	PT
valida	3773-38-P0312	PETROV 1B, -1RBI-, PIEL 0312 NIEVE.	PT
valida	3773-38-P0314	PETROV 1B, -1RBI-, PIEL 0314 MOHO.	PT
valida	3773-38-P0318	PETROV 1B, -1RBI-, PIEL 0318 MORA.	PT
valida	3773-38-P0319	PETROV 1B, -1RBI-, PIEL 0319 NOGAL.	PT
valida	3773-38-P0337	PETROV 1B, -1RBI-, PIEL 0337 NATURAL.	PT
valida	3773-38-P0342	PETROV 1B, -1RBI-, PIEL 0342 TOPO.	PT
valida	3773-38-P0402	PETROV 1B, -1RBI-, PIEL 0402 GRIS.	PT
valida	3773-38-P0406	PETROV 1B, -1RBI-, PIEL 0406 CHEESE.	PT
valida	3773-38-P0422	PETROV 1B, -1RBI-, PIEL 0422 BUCK HUMO.	PT
valida	3773-38-P0433	PETROV 1B, -1RBI-, PIEL 0433 CHERRY.	PT
valida	3773-38-P0440	PETROV 1B, -1RBI-, PIEL 0440 ROBLE.	PT
valida	3773-38-P0413	PETROV 1B, -1RBI-, PIEL 0513 SABBIA.	PT
valida	3773-38-P0415	PETROV 1B, -1RBI-, PIEL 0515 MOON.	PT
valida	3773-38-P0526	PETROV 1B, -1RBI-, PIEL 0526 CIGAR.	PT
valida	3773-38-P0607	PETROV 1B, -1RBI-, PIEL 0607 DEEP WATER.	PT
valida	3773-38-P0701	PETROV 1B, -1RBI-, PIEL 0701 WENGE.	PT
valida	3773-38-P0702	PETROV 1B, -1RBI-, PIEL 0702 GRAFITO.	PT
valida	3773-38-P0353	PETROV 1B, -1RBI-, PIEL P0353 HONEY.	PT
valida	3773-38-P0412	PETROV 1B, -1RBI-, PIEL P0512 CUOIO.	PT
valida	3773-67-P0303	PETROV 1B, 1RBI-1RSB-1RBD, PIEL 0303 BLANCO.	PT
valida	3773-67-P0306	PETROV 1B, 1RBI-1RSB-1RBD, PIEL 0306 CANELA.	PT
valida	3773-67-P0307	PETROV 1B, 1RBI-1RSB-1RBD, PIEL 0307 CHANTILLY.	PT
valida	3773-67-P0310	PETROV 1B, 1RBI-1RSB-1RBD, PIEL 0310 BROWN.	PT
valida	3773-67-P0312	PETROV 1B, 1RBI-1RSB-1RBD, PIEL 0312 NIEVE.	PT
valida	3773-62-P0312	PETROV 1B, 1RBI-1RSB-1RBD, PIEL 0312 NIEVE.	PT
valida	3773-67-P0318	PETROV 1B, 1RBI-1RSB-1RBD, PIEL 0318 MORA.	PT
valida	3773-62-P0353	PETROV 1B, 1RBI-1RSB-1RBD, PIEL 0353 HONEY.	PT
valida	3773-67-P0402	PETROV 1B, 1RBI-1RSB-1RBD, PIEL 0402 GRIS.	PT
valida	3773-67-P0433	PETROV 1B, 1RBI-1RSB-1RBD, PIEL 0433 CHERRY.	PT
valida	3773-72-P0302	PETROV 1B, 1RBI-1RSB-1RSB-E-1SB-1RBD, PIEL 0302 GRAYSH.	PT
valida	3773-72-P0306	PETROV 1B, 1RBI-1RSB-1RSB-E-1SB-1RBD, PIEL 0306 CANELA.	PT
valida	3773-72-P0310	PETROV 1B, 1RBI-1RSB-1RSB-E-1SB-1RBD, PIEL 0310 BROWN.	PT
valida	3773-72-P0318	PETROV 1B, 1RBI-1RSB-1RSB-E-1SB-1RBD, PIEL 0318 MORA.	PT
valida	3773-72-P0440	PETROV 1B, 1RBI-1RSB-1RSB-E-1SB-1RBD, PIEL 0440 ROBLE.	PT
valida	3773-72-P0412	PETROV 1B, 1RBI-1RSB-1RSB-E-1SB-1RBD, PIEL 0512 CUOIO.	PT
valida	3773-61-P0301	PETROV 1B, 1RBI-1RSB-1SB-E-1SB-1RSB-1RBD, PIEL 0301 NEGRO.	PT
valida	3773-61-P0302	PETROV 1B, 1RBI-1RSB-1SB-E-1SB-1RSB-1RBD, PIEL 0302 GRAYSH.	PT
valida	3773-61-P0303	PETROV 1B, 1RBI-1RSB-1SB-E-1SB-1RSB-1RBD, PIEL 0303 BLANCO.	PT
valida	3773-61-P0319	PETROV 1B, 1RBI-1RSB-1SB-E-1SB-1RSB-1RBD, PIEL 0319 NOGAL.	PT
valida	3773-61-P0342	PETROV 1B, 1RBI-1RSB-1SB-E-1SB-1RSB-1RBD, PIEL 0342 TOPO.	PT
valida	3773-61-P0415	PETROV 1B, 1RBI-1RSB-1SB-E-1SB-1RSB-1RBD, PIEL 0515 MOON.	PT
valida	3773-68-P0318	PETROV 1B, 1RBI-1RSB-E-1RBD, PIEL 0318 MORA.	PT
valida	3773-62-P0402	PETROV 1B, 1RBI-1RSB-E-1RSB-1SB-1RBD, PIEL 0402 GRIS.	PT
valida	3773-60-P0204	PETROV 1B, 1RBI-1RSB-E-1SB-1RBD, PIEL 0204 ARENA.	PT
valida	3773-70-P0229	PETROV 1B, 1RBI-1RSB-E-1SB-1RBD, PIEL 0229 CREMA.	PT
valida	3773-60-P0301	PETROV 1B, 1RBI-1RSB-E-1SB-1RBD, PIEL 0301 NEGRO.	PT
valida	3773-60-P0302	PETROV 1B, 1RBI-1RSB-E-1SB-1RBD, PIEL 0302 GRAYSH.	PT
valida	3773-60-P0303	PETROV 1B, 1RBI-1RSB-E-1SB-1RBD, PIEL 0303 BLANCO.	PT
valida	3773-70-P0306	PETROV 1B, 1RBI-1RSB-E-1SB-1RBD, PIEL 0306 CANELA.	PT
valida	3773-60-P0312	PETROV 1B, 1RBI-1RSB-E-1SB-1RBD, PIEL 0312 NIEVE.	PT
valida	3773-60-P0314	PETROV 1B, 1RBI-1RSB-E-1SB-1RBD, PIEL 0314 MOHO.	PT
valida	3773-60-P0318	PETROV 1B, 1RBI-1RSB-E-1SB-1RBD, PIEL 0318 MORA.	PT
valida	3773-70-P0319	PETROV 1B, 1RBI-1RSB-E-1SB-1RBD, PIEL 0319 NOGAL.	PT
valida	3773-60-P0342	PETROV 1B, 1RBI-1RSB-E-1SB-1RBD, PIEL 0342 TOPO.	PT
valida	3773-60-P0412	PETROV 1B, 1RBI-1RSB-E-1SB-1RBD, PIEL 0512 CUOIO.	PT
valida	3773-60-P0413	PETROV 1B, 1RBI-1RSB-E-1SB-1RBD, PIEL 0513 SABBIA.	PT
valida	3773-60-P0415	PETROV 1B, 1RBI-1RSB-E-1SB-1RBD, PIEL 0515 MOON.	PT
valida	3773-60-P0701	PETROV 1B, 1RBI-1RSB-E-1SB-1RBD, PIEL 0701 WENGE.	PT
valida	3773-60-P0702	PETROV 1B, 1RBI-1RSB-E-1SB-1RBD, PIEL 0702 GRAFITO.	PT
valida	3773-71-P0301	PETROV 1B, 1RBI-1RSB-E-1SB-1SB-1RBD, PIEL 0301 NEGRO.	PT
valida	3773-71-P0302	PETROV 1B, 1RBI-1RSB-E-1SB-1SB-1RBD, PIEL 0302 GRAYSH.	PT
valida	3773-71-P0303	PETROV 1B, 1RBI-1RSB-E-1SB-1SB-1RBD, PIEL 0303 BLANCO.	PT
valida	3773-71-P0306	PETROV 1B, 1RBI-1RSB-E-1SB-1SB-1RBD, PIEL 0306 CANELA.	PT
valida	3773-71-P0319	PETROV 1B, 1RBI-1RSB-E-1SB-1SB-1RBD, PIEL 0319 NOGAL.	PT
valida	3773-71-P0406	PETROV 1B, 1RBI-1RSB-E-1SB-1SB-1RBD, PIEL 0406 CHEESE.	PT
valida	3773-71-P0607	PETROV 1B, 1RBI-1RSB-E-1SB-1SB-1RBD, PIEL 0607 DEEP WATER.	PT
valida	3773-69-P0433	PETROV 1B, 1RBI-1SB-1SB-1SB-E-1RBD, PIEL 0433 CHERRY.	PT
valida	3773-36-P0204	PETROV 1B, -1RSB-, PIEL 0204 ARENA.	PT
valida	3773-36-P0229	PETROV 1B, -1RSB-, PIEL 0229 CREMA.	PT
valida	3773-36-P0301	PETROV 1B, -1RSB-, PIEL 0301 NEGRO.	PT
valida	3773-36-P0302	PETROV 1B, -1RSB-, PIEL 0302 GRAYSH.	PT
valida	3773-36-P0303	PETROV 1B, -1RSB-, PIEL 0303 BLANCO.	PT
valida	3773-36-P0306	PETROV 1B, -1RSB-, PIEL 0306 CANELA.	PT
valida	3773-36-P0307	PETROV 1B, -1RSB-, PIEL 0307 CHANTILLY.	PT
valida	3773-36-P0310	PETROV 1B, -1RSB-, PIEL 0310 BROWN.	PT
valida	3773-36-P0312	PETROV 1B, -1RSB-, PIEL 0312 NIEVE.	PT
valida	3773-36-P0314	PETROV 1B, -1RSB-, PIEL 0314 MOHO.	PT
valida	3773-36-P0318	PETROV 1B, -1RSB-, PIEL 0318 MORA.	PT
valida	3773-36-P0319	PETROV 1B, -1RSB-, PIEL 0319 NOGAL.	PT
valida	3773-36-P0342	PETROV 1B, -1RSB-, PIEL 0342 TOPO.	PT
valida	3773-36-P0402	PETROV 1B, -1RSB-, PIEL 0402 GRIS.	PT
valida	3773-36-P0406	PETROV 1B, -1RSB-, PIEL 0406 CHEESE.	PT
valida	3773-36-P0422	PETROV 1B, -1RSB-, PIEL 0422 BUCK HUMO.	PT
valida	3773-36-P0433	PETROV 1B, -1RSB-, PIEL 0433 CHERRY.	PT
valida	3773-36-P0440	PETROV 1B, -1RSB-, PIEL 0440 ROBLE.	PT
valida	3773-36-P0412	PETROV 1B, -1RSB-, PIEL 0512 CUOIO.	PT
valida	3773-36-P0413	PETROV 1B, -1RSB-, PIEL 0513 SABBIA.	PT
valida	3773-36-P0415	PETROV 1B, -1RSB-, PIEL 0515 MOON.	PT
valida	3773-36-P0607	PETROV 1B, -1RSB-, PIEL 0607 DEEP WATER.	PT
valida	3773-36-P0701	PETROV 1B, -1RSB-, PIEL 0701 WENGE.	PT
valida	3773-36-P0702	PETROV 1B, -1RSB-, PIEL 0702 GRAFITO.	PT
valida	3773-36-P0353	PETROV 1B, -1RSB-, PIEL P0353 HONEY.	PT
valida	3773-17-P0204	PETROV 1B, -1SB-, PIEL 0204 ARENA.	PT
valida	3773-17-P0229	PETROV 1B, -1SB-, PIEL 0229 CREMA.	PT
valida	3773-17-P0301	PETROV 1B, -1SB-, PIEL 0301 NEGRO.	PT
valida	3773-17-P0302	PETROV 1B, -1SB-, PIEL 0302 GRAYSH.	PT
valida	3773-17-P0303	PETROV 1B, -1SB-, PIEL 0303 BLANCO.	PT
valida	3773-17-P0306	PETROV 1B, -1SB-, PIEL 0306 CANELA.	PT
valida	3773-17-P0310	PETROV 1B, -1SB-, PIEL 0310 BROWN.	PT
valida	3773-17-P0312	PETROV 1B, -1SB-, PIEL 0312 NIEVE.	PT
valida	3773-17-P0314	PETROV 1B, -1SB-, PIEL 0314 MOHO.	PT
valida	3773-17-P0318	PETROV 1B, -1SB-, PIEL 0318 MORA.	PT
valida	3773-17-P0319	PETROV 1B, -1SB-, PIEL 0319 NOGAL.	PT
valida	3773-17-P0342	PETROV 1B, -1SB-, PIEL 0342 TOPO.	PT
valida	3773-17-P0402	PETROV 1B, -1SB-, PIEL 0402 GRIS.	PT
valida	3773-17-P0406	PETROV 1B, -1SB-, PIEL 0406 CHEESE.	PT
valida	3773-17-P0433	PETROV 1B, -1SB-, PIEL 0433 CHERRY.	PT
valida	3773-17-P0440	PETROV 1B, -1SB-, PIEL 0440 ROBLE.	PT
valida	3773-17-P0412	PETROV 1B, -1SB-, PIEL 0512 CUOIO.	PT
valida	3773-17-P0413	PETROV 1B, -1SB-, PIEL 0513 SABBIA.	PT
valida	3773-17-P0415	PETROV 1B, -1SB-, PIEL 0515 MOON.	PT
valida	3773-17-P0526	PETROV 1B, -1SB-, PIEL 0526 CIGAR.	PT
valida	3773-17-P0607	PETROV 1B, -1SB-, PIEL 0607 DEEP WATER.	PT
valida	3773-17-P0701	PETROV 1B, -1SB-, PIEL 0701 WENGE.	PT
valida	3773-17-P0702	PETROV 1B, -1SB-, PIEL 0702 GRAFITO.	PT
valida	3773-40-P0204	PETROV 1B, -E-, PIEL 0204 ARENA.	PT
valida	3773-40-P0229	PETROV 1B, -E-, PIEL 0229 CREMA.	PT
valida	3773-40-P0301	PETROV 1B, -E-, PIEL 0301 NEGRO.	PT
valida	3773-40-P0302	PETROV 1B, -E-, PIEL 0302 GRAYSH.	PT
valida	3773-40-P0303	PETROV 1B, -E-, PIEL 0303 BLANCO.	PT
valida	3773-40-P0306	PETROV 1B, -E-, PIEL 0306 CANELA.	PT
valida	3773-40-P0310	PETROV 1B, -E-, PIEL 0310 BROWN.	PT
valida	3773-40-P0312	PETROV 1B, -E-, PIEL 0312 NIEVE.	PT
valida	3773-40-P0314	PETROV 1B, -E-, PIEL 0314 MOHO.	PT
valida	3773-40-P0318	PETROV 1B, -E-, PIEL 0318 MORA.	PT
valida	3773-40-P0319	PETROV 1B, -E-, PIEL 0319 NOGAL.	PT
valida	3773-40-P0342	PETROV 1B, -E-, PIEL 0342 TOPO.	PT
valida	3773-40-P0402	PETROV 1B, -E-, PIEL 0402 GRIS.	PT
valida	3773-40-P0406	PETROV 1B, -E-, PIEL 0406 CHEESE.	PT
valida	3773-40-P0422	PETROV 1B, -E-, PIEL 0422 BUCK HUMO.	PT
valida	3773-40-P0433	PETROV 1B, -E-, PIEL 0433 CHERRY.	PT
valida	3773-40-P0440	PETROV 1B, -E-, PIEL 0440 ROBLE.	PT
valida	3773-40-P0412	PETROV 1B, -E-, PIEL 0512 CUOIO.	PT
valida	3773-40-P0413	PETROV 1B, -E-, PIEL 0513 SABBIA.	PT
valida	3773-40-P0415	PETROV 1B, -E-, PIEL 0515 MOON.	PT
valida	3773-40-P0607	PETROV 1B, -E-, PIEL 0607 DEEP WATER.	PT
valida	3773-40-P0701	PETROV 1B, -E-, PIEL 0701 WENGE.	PT
valida	3773-40-P0702	PETROV 1B, -E-, PIEL 0702 GRAFITO.	PT
valida	3773-70-P0412	PETROV 1RBI-1RSB-1RBD, PIEL 0512 CUOIO.	PT
valida	3683-39-P0203	PETROV, -1RBD-, PIEL 0203 BLANCO.	PT
valida	3683-39-P0228	PETROV, -1RBD-, PIEL 0228 AMARETTO	PT
valida	3683-39-P0302	PETROV, -1RBD-, PIEL 0302 GRAYSH.	PT
valida	3683-39-P0303	PETROV, -1RBD-, PIEL 0303 BLANCO.	PT
valida	3683-39-P0304	PETROV, -1RBD-, PIEL 0304 SIENA.	PT
valida	3683-39-P0306	PETROV, -1RBD-, PIEL 0306 CANELA.	PT
valida	3683-39-P0310	PETROV, -1RBD-, PIEL 0310 BROWN.	PT
valida	3683-39-P0312	PETROV, -1RBD-, PIEL 0312 NIEVE.	PT
valida	3683-39-P0314	PETROV, -1RBD-, PIEL 0314 MOHO.	PT
valida	3683-39-P0318	PETROV, -1RBD-, PIEL 0318 MORA.	PT
valida	3683-39-P0342	PETROV, -1RBD-, PIEL 0342 TOPO.	PT
valida	3683-39-P0353	PETROV, -1RBD-, PIEL 0353 HONEY.	PT
valida	3683-39-P0402	PETROV, -1RBD-, PIEL 0402 GRIS.	PT
valida	3683-39-P0403	PETROV, -1RBD-, PIEL 0403 BUCK OFF WHITE.	PT
valida	3683-39-P0433	PETROV, -1RBD-, PIEL 0433 CHERRY.	PT
valida	3683-39-P0412	PETROV, -1RBD-, PIEL 0512 CUOIO.	PT
valida	3683-39-P0526	PETROV, -1RBD-, PIEL 0526 CIGAR.	PT
valida	3683-39-P0709	PETROV, -1RBD-, PIEL 0709 MOKA.	PT
valida	3683-39-P0814	PETROV, -1RBD-, PIEL 0814 CAPUCHINO.	PT
valida	3683-72-P0516	PETROV, 1RBD-1RSB-E-1SB-1RBI, PIEL 0516 SESAME.	PT
valida	3683-38-P0228	PETROV, -1RBI-, PIEL 0228 AMARETTO	PT
valida	3683-38-P0302	PETROV, -1RBI-, PIEL 0302 GRAYSH.	PT
valida	3683-38-P0303	PETROV, -1RBI-, PIEL 0303 BLANCO.	PT
valida	3683-38-P0304	PETROV, -1RBI-, PIEL 0304 SIENA.	PT
valida	3683-38-P0306	PETROV, -1RBI-, PIEL 0306 CANELA.	PT
valida	3683-38-P0310	PETROV, -1RBI-, PIEL 0310 BROWN.	PT
valida	3683-38-P0312	PETROV, -1RBI-, PIEL 0312 NIEVE.	PT
valida	3683-38-P0314	PETROV, -1RBI-, PIEL 0314 MOHO.	PT
valida	3683-38-P0318	PETROV, -1RBI-, PIEL 0318 MORA.	PT
valida	3683-38-P0342	PETROV, -1RBI-, PIEL 0342 TOPO.	PT
valida	3683-38-P0353	PETROV, -1RBI-, PIEL 0353 HONEY.	PT
valida	3683-38-P0402	PETROV, -1RBI-, PIEL 0402 GRIS.	PT
valida	3683-38-P0403	PETROV, -1RBI-, PIEL 0403 BUCK OFF WHITE.	PT
valida	3683-38-P0433	PETROV, -1RBI-, PIEL 0433 CHERRY.	PT
valida	3683-38-P0412	PETROV, -1RBI-, PIEL 0512 CUOIO.	PT
valida	3683-38-P0526	PETROV, -1RBI-, PIEL 0526 CIGAR.	PT
valida	3683-38-P0709	PETROV, -1RBI-, PIEL 0709 MOKA.	PT
valida	3683-38-P0814	PETROV, -1RBI-, PIEL 0814 CAPUCHINO.	PT
valida	3683-61-P0314	PETROV, 1RBI-1RSB-1SB-E-1SB-1RSB-1RBD, PIEL 0314 MOHO.	PT
valida	3683-61-P0342	PETROV, 1RBI-1RSB-1SB-E-1SB-1RSB-1RBD, PIEL 0342 TOPO.	PT
valida	3683-71-P0204	PETROV, 1RBI-1RSB-E-1SB-1RBD, PIEL 0204 ARENA.	PT
valida	3683-60-P0301	PETROV, 1RBI-1RSB-E-1SB-1RBD, PIEL 0301 NEGRO.	PT
valida	3683-60-P0302	PETROV, -1RBI-1RSB-E-1SB-1RBD, PIEL 0302 GRAYSH.	PT
valida	3683-60-P0312	PETROV, 1RBI-1RSB-E-1SB-1RBD, PIEL 0312 NIEVE	PT
valida	3683-60-P0314	PETROV, 1RBI-1RSB-E-1SB-1RBD, PIEL 0314 MOHO.	PT
valida	3683-60-P0342	PETROV, 1RBI-1RSB-E-1SB-1RBD, PIEL 0342 TOPO.	PT
valida	3683-60-P0402	PETROV, 1RBI-1RSB-E-1SB-1RBD, PIEL 0402 GRIS.	PT
valida	3683-60-P0422	PETROV, 1RBI-1RSB-E-1SB-1RBD, PIEL 0422 BUCK HUMO.	PT
valida	3683-36-P0302	PETROV, -1RSB-, PIEL 0302 GRAYSH.	PT
valida	3683-36-P0303	PETROV, -1RSB-, PIEL 0303 BLANCO.	PT
valida	3683-36-P0304	PETROV, -1RSB-, PIEL 0304 SIENA.	PT
valida	3683-36-P0310	PETROV, -1RSB-, PIEL 0310 BROWN.	PT
valida	3683-36-P0312	PETROV, -1RSB-, PIEL 0312 NIEVE.	PT
valida	3683-36-P0314	PETROV, -1RSB-, PIEL 0314 MOHO.	PT
valida	3683-36-P0318	PETROV, -1RSB-, PIEL 0318 MORA.	PT
valida	3683-36-P0342	PETROV, -1RSB-, PIEL 0342 TOPO.	PT
valida	3683-36-P0353	PETROV, -1RSB-, PIEL 0353 HONEY.	PT
valida	3683-36-P0402	PETROV, -1RSB-, PIEL 0402 GRIS.	PT
valida	3683-36-P0709	PETROV, -1RSB-, PIEL 0709 MOKA.	PT
valida	3683-36-P0814	PETROV, -1RSB-, PIEL 0814 CAPUCHINO.	PT
valida	3683-17-P0228	PETROV, -1SB-, PIEL 0228 AMARETTO	PT
valida	3683-17-P0302	PETROV, -1SB-, PIEL 0302 GRAYSH.	PT
valida	3683-17-P0303	PETROV, -1SB-, PIEL 0303 BLANCO.	PT
valida	3683-17-P0312	PETROV, -1SB-, PIEL 0312 NIEVE.	PT
valida	3683-17-P0314	PETROV, -1SB-, PIEL 0314 MOHO.	PT
valida	3683-17-P0353	PETROV, -1SB-, PIEL 0353 HONEY.	PT
valida	3683-17-P0422	PETROV, -1SB-, PIEL 0422 BUCK HUMO.	PT
valida	3683-17-P0433	PETROV, -1SB-, PIEL 0433 CHERRY.	PT
valida	3683-17-P0412	PETROV, -1SB-, PIEL 0512 CUOIO.	PT
valida	3683-17-P0415	PETROV, -1SB-, PIEL 0515 MOON.	PT
valida	3683-17-P0526	PETROV, -1SB-, PIEL 0526 CIGAR.	PT
valida	3683-40-P0228	PETROV, -E-, PIEL 0228 AMARETTO	PT
valida	3683-40-P0302	PETROV, -E-, PIEL 0302 GRAYSH.	PT
valida	3683-40-P0303	PETROV, -E-, PIEL 0303 BLANCO.	PT
valida	3683-40-P0306	PETROV, -E-, PIEL 0306 CANELA.	PT
valida	3683-40-P0312	PETROV, -E-, PIEL 0312 NIEVE.	PT
valida	3683-40-P0318	PETROV, -E-, PIEL 0318 MORA.	PT
valida	3683-40-P0353	PETROV, -E-, PIEL 0353 HONEY.	PT
valida	3683-40-P0402	PETROV, -E-, PIEL 0402 GRIS.	PT
valida	3683-40-P0422	PETROV, -E-, PIEL 0422 BUCK HUMO.	PT
valida	3683-40-P0433	PETROV, -E-, PIEL 0433 CHERRY.	PT
valida	3683-40-P0412	PETROV, -E-, PIEL 0512 CUOIO.	PT
valida	3683-40-P0415	PETROV, -E-, PIEL 0515 MOON.	PT
valida	3683-37-P0230	PETROV, -RECLI-, PIEL 0230 CHOCOLATE.	PT
valida	3683-37-P0312	PETROV, -RECLI-, PIEL 0312 NIEVE.	PT
valida	3683-37-P0314	PETROV, -RECLI-, PIEL 0314 MOHO.	PT
valida	3683-37-P0337	PETROV, -RECLI-, PIEL 0337 NATURAL.	PT
valida	3683-37-P0526	PETROV, -RECLI-, PIEL 0526 CIGAR.	PT
valida	3683-37-P0602	PETROV, -RECLI-, PIEL 0602 AGADIR.	PT
valida	3683-37-B0043	PETROV, -RECLI-, PIEL ART. KERRY COLOR 6130.B0043	PT
valida	3513-15-Q1206	PETROZZIAN -3BI- TELA GRASSHOPPER NEGRO/PIEL0301A	PT
valida	3506-03-T3011	PETROZZIAN -CHBD- TELA GRASSHOPPER NEGRO/PIEL0301A	PT
valida	3513-08-Q1206	PETROZZIAN -MD- TELA GRASSHOPPER NEGRO/PIEL0301A	PT
valida	14015	PIEL 0230 CHOCOLATE.	MP
valida	10539	PIEL 0314 MOHO.	MP
valida	18618	PIEL 0318 MORA.	MP
valida	18621	PIEL 0319 NOGAL.	MP
valida	18453	PIEL 0325 FANGO.	MP
valida	15557	PIEL 0342 TOPO.	MP
valida	10797	PIEL 0402 GRIS	MP
valida	10579	PIEL 0440 ROBLE.	MP
valida	10087	PIEL 0513 SABBIA.	MP
valida	10064	PIEL 0526 CIGAR.	MP
valida	18738	PIEL 0623 CHAMPAGNE.	MP
valida	18737	PIEL 0624 ESPRESSO.	MP
valida	19335	PIEL 0640 ROSE.	MP
valida	18736	PIEL 0644 CARBON.	MP
valida	18652	PIEL 0701 WENGE.	MP
valida	18690	PIEL 0702 GRAFITO.	MP
valida	19187	PIEL PEDACERA CHICA (VENTA).	MP
valida	3711-01-P0229	PIERO 2, -1-, PIEL 0229 CREMA.	PT
valida	3711-01-P0303	PIERO 2, -1-, PIEL 0303 BLANCO.	PT
valida	3711-01-P0440	PIERO 2, -1-, PIEL 0440 ROBLE.	PT
valida	3711-02-P0229	PIERO 2, -2-, PIEL 0229 CREMA.	PT
valida	3711-02-P0303	PIERO 2, -2-, PIEL 0303 BLANCO.	PT
valida	3711-02-P0310	PIERO 2, -2-, PIEL 0310 BROWN.	PT
valida	3711-02-P0440	PIERO 2, -2-, PIEL 0440 ROBLE.	PT
valida	3711-03-P0229	PIERO 2, -3-, PIEL 0229 CREMA.	PT
valida	3711-03-P0303	PIERO 2, -3-, PIEL 0303 BLANCO.	PT
valida	3711-03-P0310	PIERO 2, -3-, PIEL 0310 BROWN.	PT
valida	3711-03-P0440	PIERO 2, -3-, PIEL 0440 ROBLE.	PT
valida	3591-01-P0307	PIERO, -1-, PIEL 0307 CHANTILLY.	PT
valida	3591-01-P0319	PIERO, -1-, PIEL 0319 NOGAL.	PT
valida	3591-02-P0204	PIERO, -2-, PIEL 0204 ARENA	PT
valida	3591-02-P0307	PIERO, -2-, PIEL 0307 CHANTILLY.	PT
valida	3591-02-P0319	PIERO, -2-, PIEL 0319 NOGAL.	PT
valida	3591-03-P0204	PIERO, -3-, PIEL 0204 ARENA	PT
valida	3591-03-P0307	PIERO, -3-, PIEL 0307 CHANTILLY	PT
valida	3591-03-P0319	PIERO, -3-, PIEL 0319 NOGAL.	PT
valida	3591-32-P0228	PIERO, 3-2, PIEL 0228 AMARETTO.	PT
valida	3591-32-P0402	PIERO, 3-2, PIEL 0402 GRIS.	PT
valida	3586-28-P0814	PIONINI -3BDC- PIEL 0814 CAPUCHINO.	PT
valida	3586-16-P0715	PIONINI -3BDL- PIEL 0715 MUSHROOM.	PT
valida	3586-29-P0814	PIONINI -3BIC- PIEL 0814 CAPUCHINO.	PT
valida	3586-23-P0715	PIONINI -CHBIC- PIEL 0715 MUSHROOM.	PT
valida	3586-51-P0433	PIONINI -COJIN RESP. 1SB- PIEL 0433 CHERRY.	PT
valida	3586-51-P0526	PIONINI -COJIN RESP. 1SB- PIEL 0526 CIGAR.	PT
valida	3586-25-P0715	PIONINI -M- PIEL 0715 MUSHROOM.	PT
valida	3586-21-P0422	PIONINI -T- PIEL 0402 BUCK HUMO.	PT
valida	3586-21-P0715	PIONINI -T- PIEL 0715 MUSHROOM.	PT
valida	3766-01-P0702	PIPPO, -1-, PIEL 0702 GRAFITO.	PT
valida	ZAR0640	PIRAMID (PROTO) -1- PIEL 0318 MORA.	PT
valida	3510-46-P0230	PIZZA 2R -FUNDA RESPALDO DER- P0230 CHOCOLATE / VINIL CHOCOLATE.	SP
valida	3510-45-P0230	PIZZA 2R -FUNDA RESPALDO IZQ- P0230 CHOCOLATE / VINIL CHOCOLATE.	SP
valida	3715-48-P0230	PIZZA B ELECTRICO 2R -FUNDA RESPALDO DERECH- P0230 CHOCOLATE / VINIL CHOCOLATE.	SP
valida	3715-45-P0230	PIZZA B ELECTRICO 2R -FUNDA RESPALDO IZQU- P0230 CHOCOLATE / VINIL CHOCOLATE.	SP
valida	3715-39-P0230	PIZZA B ELECTRICO -2R- PIEL 0230 CHOCOLATE / VINIL CHOCOLATE.	PT
valida	3715-39-P0303	PIZZA B ELECTRICO -2R- PIEL 0303 BLANCO / PIEL 0103 BLANCO.	PT
valida	3791-47-P0230	PIZZA B ELECTRICO MM -2R- PIEL 0230 CHOCOLATE / VINIL CHOCOLATE.	PT
valida	3791-47-P0402	PIZZA B ELECTRICO MM -2R- PIEL 0402 GRIS.	PT
valida	3791-38-P0230	PIZZA B ELECTRICO MM, -1RBI-, PIEL 0230 CHOCOLATE / VINIL CHOCOLATE.	PT
valida	3791-38-P0402	PIZZA B ELECTRICO MM, -1RBI-, PIEL 0402 GRIS.	PT
valida	3715-37-P0230	PIZZA B ELECTRICO, -1RBI-, PIEL 0230 CHOCOLATE / VINIL CHOCOLATE.	PT
valida	3581-31-P1030	PIZZA ELECTRICO -1RBD- US, PIEL 0230 CHOCOLATE / VINIL CHOCOLATE.	PT
valida	3581-29-P1030	PIZZA ELECTRICO -1RBDBA- US PIEL 0230 CHOCOLATE / VINIL CHOCOLATE.	PT
valida	3581-32-P1030	PIZZA ELECTRICO -1RBI- US, PIEL 0230 CHOCOLATE / VINIL CHOCOLATE.	PT
valida	3581-30-P1030	PIZZA ELECTRICO -1RBIBA- US PIEL 0230 CHOCOLATE / VINIL CHOCOLATE.	PT
valida	3581-54-P0230	PIZZA ELECTRICO 2R -FUNDA ASIENTO- P0230 CHOCOLATE / VINIL CHOCOLATE.	SP
valida	3581-51-P0230	PIZZA ELECTRICO 2R -FUNDA BRAZO INTERMEDIO- P0230 CHOCOLATE / VINIL CHOCOLATE.	SP
valida	3581-45-P0230	PIZZA ELECTRICO 2R -FUNDA RESPALDO- P0230 CHOCOLATE / VINIL CHOCOLATE.	SP
valida	3581-49-P0230	PIZZA ELECTRICO 2R -PIECERA- P0230 CHOCOLATE / VINIL CHOCOLATE.	SP
valida	3581-33-P1030	PIZZA ELECTRICO -2R- US, PIEL 0230 CHOCOLATE / VINIL CHOCOLATE.	PT
valida	3581-58-P0230	PIZZA ELECTRICO 2RBDBA US-, PIEL 0230 CHOCOLATE / VINIL CHOCOLATE.	PT
valida	3581-57-P0230	PIZZA ELECTRICO 2RBIBA US-, PIEL 0230 CHOCOLATE / VINIL CHOCOLATE.	PT
valida	3802-31-P1030	PIZZA ELECTRICO MM (140º), -1RBD- US, PIEL 0230 CHOCOLATE / VINIL CHOCOLATE.	PT
valida	3802-32-P1030	PIZZA ELECTRICO MM (140º), -1RBI- US, PIEL 0230 CHOCOLATE / VINIL CHOCOLATE.	PT
valida	3802-33-P1030	PIZZA ELECTRICO MM (140º), -2R- US, PIEL 0230 CHOCOLATE / VINIL CHOCOLATE.	PT
valida	3802-57-P0230	PIZZA ELECTRICO MM (140º), 2RBIBA US-, PIEL 0230 CHOCOLATE / VINIL CHOCOLATE.	PT
valida	3785-58-P0230	PIZZA ELECTRICO MM 2RBDBA US-, PIEL 0230 CHOCOLATE / VINIL CHOCOLATE.	PT
valida	3785-57-P0230	PIZZA ELECTRICO MM 2RBIBA US-, PIEL 0230 CHOCOLATE / VINIL CHOCOLATE.	PT
valida	3802-29-P1030	PIZZA ELECTRICO MM(140°), -1RBDBA- US PIEL 0230 CHOCOLATE / VINIL CHOCOLATE.	PT
valida	3802-30-P1030	PIZZA ELECTRICO MM(140°), -1RBIBA- US PIEL 0230 CHOCOLATE / VINIL CHOCOLATE.	PT
valida	3785-31-P1030	PIZZA ELECTRICO MM, -1RBD- US, PIEL 0230 CHOCOLATE / VINIL CHOCOLATE.	PT
valida	3785-29-P1030	PIZZA ELECTRICO MM, -1RBDBA- US PIEL 0230 CHOCOLATE / VINIL CHOCOLATE.	PT
valida	3785-32-P1030	PIZZA ELECTRICO MM, -1RBI- US, PIEL 0230 CHOCOLATE / VINIL CHOCOLATE.	PT
valida	3785-30-P1030	PIZZA ELECTRICO MM, -1RBIBA- US PIEL 0230 CHOCOLATE / VINIL CHOCOLATE.	PT
valida	3785-33-P1030	PIZZA ELECTRICO MM, -2R- US, PIEL 0230 CHOCOLATE / VINIL CHOCOLATE.	PT
valida	3581-42-P0230	PIZZA ELECTRICO,-CINTILLO-, PIEL 0230 CHOCOLATE	SP
valida	3767-40-P0310	PIZZA Z1 -2R- S/CINTILLO PIEL 0310 BROWN.	PT
valida	3767-56-P0230	PIZZA Z1 2R, -FUNDA LATERAL BD S/PERFORACION - P0230 CHOCOLATE/ VINIL CHOCOLATE.	SP
valida	3767-55-P0230	PIZZA Z1 2R, -FUNDA LATERAL BI S/PERFORACION - P0230 CHOCOLATE/ VINIL CHOCOLATE.	SP
valida	3713-39-P0319	PIZZA Z1 ELECTRICO, -2R-, S/CINTILLO PIEL 0319 NOGAL.	PT
valida	3713-39-P0321	PIZZA Z1 ELECTRICO, -2R-, S/CINTILLO PIEL 0321 TRIGO.	PT
valida	3614-42-P0230	PIZZUTTI ELECTRICO -2R- PIEL 0230 CHOCOLATE	PT
valida	3614-42-P0302	PIZZUTTI ELECTRICO -2R- PIEL 0302 GRAYSH	PT
valida	3614-42-P0312	PIZZUTTI ELECTRICO -2R- PIEL 0312 NIEVE.	PT
valida	3614-42-P0321	PIZZUTTI ELECTRICO -2R- PIEL 0321 TRIGO	PT
valida	3614-43-P0312	PIZZUTTI ELECTRICO -3R- PIEL 0312 NIEVE.	PT
valida	3614-43-P0318	PIZZUTTI ELECTRICO -3R-PIEL 0318 MORA.	PT
valida	3614-41-P0230	PIZZUTTI ELECTRICO -RECLI- PIEL 0230 CHOCOLATE	PT
valida	3614-41-P0302	PIZZUTTI ELECTRICO -RECLI- PIEL 0302 GRAYSH	PT
valida	3614-41-P0312	PIZZUTTI ELECTRICO -RECLI- PIEL 0312 NIEVE.	PT
valida	3614-41-P0424	PIZZUTTI ELECTRICO -RECLI- PIEL 0424 RUBI.	PT
valida	3469-37-P0424	PIZZUTTI, -1R-, PIEL 0424 RUBI.	PT
valida	3469-43-P0301	PIZZUTTI, -3R-, PIEL 0301 NEGRO.	PT
valida	3528-37-P2229	PLUSH -1R- PIEL 0229 CREMA / PIEL 0129 CREMA.	PT
valida	3528-04-P0230	PLUSH, -3R-2R-1R, PIEL 0230 CHOCOLATE.	PT
valida	18432	PORTAVASO ACERO INOXIDABLE (XIC).	MP
valida	14429	PORTAVASO ALUMINIO ANODIZADO	MP
valida	3720-15-P0342	PUNZZO,  -3BD-, PIEL 0342 TOPO.	PT
valida	3720-14-P0312	PUNZZO,  -3BI-, PIEL 0312 NIEVE	PT
valida	3720-14-P0319	PUNZZO,  -3BI-, PIEL 0319 NOGAL.	PT
valida	3720-14-P0321	PUNZZO,  -3BI-, PIEL 0321 TRIGO.	PT
valida	3720-14-P0442	PUNZZO,  -3BI-, PIEL 0342 TOPO.	PT
valida	3720-14-P0402	PUNZZO,  -3BI-, PIEL 0402 GRIS.	PT
valida	3720-14-P0403	PUNZZO,  -3BI-, PIEL 0403 BUCK OFF WHITE.	PT
valida	3720-14-P0406	PUNZZO,  -3BI-, PIEL 0406 CHEESE.	PT
valida	3720-14-P0422	PUNZZO,  -3BI-, PIEL 0422 BUCK HUMO.	PT
valida	3720-14-P0415	PUNZZO,  -3BI-, PIEL 0515 MOON.	PT
valida	3720-14-P0523	PUNZZO,  -3BI-, PIEL 0623 CHAMPAGNE.	PT
valida	3720-35-P0312	PUNZZO, -1SB-, PIEL 0312 NIEVE.	PT
valida	3720-35-P0318	PUNZZO, -1SB-, PIEL 0318 MORA.	PT
valida	3720-35-P0321	PUNZZO, -1SB-, PIEL 0321 TRIGO.	PT
valida	3720-35-P0442	PUNZZO, -1SB-, PIEL 0342 TOPO.	PT
valida	3720-35-P0353	PUNZZO, -1SB-, PIEL 0353 HONEY.	PT
valida	3720-35-P0402	PUNZZO, -1SB-, PIEL 0402 GRIS.	PT
valida	3720-35-P0403	PUNZZO, -1SB-, PIEL 0403 BUCK OFF WHITE.	PT
valida	3720-35-P0422	PUNZZO, -1SB-, PIEL 0422 BUCK HUMO.	PT
valida	3720-35-P0414	PUNZZO, -1SB-, PIEL 0514 CASTAÑO	PT
valida	3720-35-P0415	PUNZZO, -1SB-, PIEL 0515 MOON.	PT
valida	3720-35-P0704	PUNZZO, -1SB-, PIEL 0704 ALMENDRA.	PT
valida	3720-35-B0057	PUNZZO, -1SB-, TELA ZARK TERCIOPELO GRIS.	PT
valida	3720-08-P0312	PUNZZO, -3BD- CHBI-, PIEL 0312 NIEVE.	PT
valida	3720-08-P0415	PUNZZO, -3BD- CHBI-, PIEL 0515 MOON.	PT
valida	3720-15-P0302	PUNZZO, -3BD-, PIEL 0302 GRAYSH.	PT
valida	3720-15-P0314	PUNZZO, -3BD-, PIEL 0314 MOHO.	PT
valida	3720-15-P0321	PUNZZO, -3BD-, PIEL 0321 TRIGO.	PT
valida	3720-15-P0414	PUNZZO, -3BD-, PIEL 0514 CASTAÑO	PT
valida	3720-04-P0301	PUNZZO, -3BI- CHBD-, PIEL 0301 NEGRO MATE.	PT
valida	3720-05-P0312	PUNZZO, -3BI- CHBD-, PIEL 0312 NIEVE.	PT
valida	3720-04-P0314	PUNZZO, -3BI- CHBD-, PIEL 0314 MOHO.	PT
valida	3720-04-P0321	PUNZZO, -3BI- CHBD-, PIEL 0321 TRIGO.	PT
valida	3720-04-P0415	PUNZZO, -3BI- CHBD-, PIEL 0515 MOON.	PT
valida	3720-04-B0056	PUNZZO, -3BI- CHBD-, TELA ZARK TERCIOPELO BEIGE.	PT
valida	3720-14-B0073	PUNZZO, -3BI-, TELA INK AZUL.	PT
valida	3720-14-B0056	PUNZZO, -3BI-, TELA ZARK TERCIOPELO BEIGE.	PT
valida	3720-14-B0057	PUNZZO, -3BI-, TELA ZARK TERCIOPELO GRIS.	PT
valida	3720-14-B0055	PUNZZO, -3BI-, TELA ZARK TERCIOPELO MUSE.	PT
valida	3720-59-P0312	PUNZZO, -3BI-1SB-CHBD-, PIEL 0312 NIEVE.	PT
valida	3720-59-P0544	PUNZZO, -3BI-1SB-CHBD-, PIEL 0644 CARBON.	PT
valida	3720-59-0412	PUNZZO, -3BI-1SB-CHSB-, PIEL 0512 CUOIO.	PT
valida	3720-73-0204	PUNZZO, -3BI-1SB-CHSB-CHBD-, PIEL 0204 ARENA.	PT
valida	3720-05-P0303	PUNZZO, -3BI-CHBD-, PIEL 0303 BLANCO.	PT
valida	3720-05-P0319	PUNZZO, -3BI-CHBD-, PIEL 0319 NOGAL.	PT
valida	3720-05-P0442	PUNZZO, 3BI-CHBD, PIEL 0342 TOPO.	PT
valida	3720-05-P0402	PUNZZO, -3BI-CHBD-, PIEL 0402 GRIS.	PT
valida	3720-05-P0412	PUNZZO, -3BI-CHBD-, PIEL 0512 CUOIO.	PT
valida	3720-22-P0312	PUNZZO, -CHBD-, PIEL 0312 NIEVE.	PT
valida	3720-22-P0318	PUNZZO, -CHBD-, PIEL 0318 MORA.	PT
valida	3720-22-P0319	PUNZZO, -CHBD-, PIEL 0319 NOGAL.	PT
valida	3720-22-P0412	PUNZZO, -CHBD-, PIEL 0512 CUOIO.	PT
valida	3720-22-P0415	PUNZZO, -CHBD-, PIEL 0515 MOON.	PT
valida	3720-22-P0523	PUNZZO, -CHBD-, PIEL 0623 CHAMPAGNE.	PT
valida	3720-22-P0321	PUNZZO, -CHBD-, PPIEL 0321 TRIGO.	PT
valida	3720-23-P0318	PUNZZO, -CHBI-, PIEL 0318 MORA.	PT
valida	3720-20-P0312	PUNZZO, -CHSB-, PIEL 0312 NIEVE	PT
valida	3720-20-P0321	PUNZZO, -CHSB-, PIEL 0321 TRIGO.	PT
valida	3720-20-P0442	PUNZZO, -CHSB-, PIEL 0342 TOPO.	PT
valida	3720-20-P0402	PUNZZO, -CHSB-, PIEL 0402 GRIS.	PT
valida	3720-20-P0422	PUNZZO, -CHSB-, PIEL 0422 BUCK HUMO.	PT
valida	3720-20-P0414	PUNZZO, -CHSB-, PIEL 0514 CASTAÑO	PT
valida	3720-20-P0415	PUNZZO, -CHSB-, PIEL 0515 MOON.	PT
valida	3720-20-P0701	PUNZZO, -CHSB-, PIEL 0701 WENGE.	PT
valida	3720-30-M0103	PUNZZO, -M-,  MADERA NOGAL.	PT
valida	3720-66-P0342	PUNZZO,-3BD,CHBI-, PIEL 0342 TOPO.	PT
valida	3720-20-B0057	PUNZZOZ, -CHS-, TELA ZARK TERCIOPELO GRIS.	PT
valida	3679-52-P0303	RAVIOLI -1SB-1SB-E-1SB-1SB-ASB-TC,  PIEL 0303 BLANCO	PT
valida	3679-60-P0303	RAVIOLI -T-1SB-1SB-E-1SB-1SB-ASB-TC-1SB,  PIEL 00303 BLANCO.	PT
valida	3679-60-P0301	RAVIOLI -T-1SB-1SB-E-1SB-1SB-ASB-TC-1SB,  PIEL 0301 NEGRO.	PT
valida	3679-60-P0342	RAVIOLI -T-1SB-1SB-E-1SB-1SB-ASB-TC-1SB,  PIEL 0342 TOPO.	PT
valida	3679-17-P0228	RAVIOLI, -1SB-, PIEL 0228 AMARETTO.	PT
valida	3679-17-P0235	RAVIOLI, -1SB-, PIEL 0235 OYSTER.	PT
valida	3679-17-P0301	RAVIOLI, -1SB-, PIEL 0301 NEGRO.	PT
valida	3679-17-P0302	RAVIOLI, -1SB-, PIEL 0302 GRAYSH.	PT
valida	3679-17-P0306	RAVIOLI, -1SB-, PIEL 0306 CANELA.	PT
valida	3679-17-P0312	RAVIOLI, -1SB-, PIEL 0312 NIEVE.	PT
valida	3679-17-P0314	RAVIOLI, -1SB-, PIEL 0314 MOHO.	PT
valida	3679-17-P0321	RAVIOLI, -1SB-, PIEL 0321 TRIGO.	PT
valida	3679-17-P0402	RAVIOLI, -1SB-, PIEL 0402 GRIS.	PT
valida	3679-17-P0415	RAVIOLI, -1SB-, PIEL 0515 MOON.	PT
valida	3679-17-P0802	RAVIOLI, -1SB-, PIEL 0702 GRAFITO.	PT
valida	3679-62-P0302	RAVIOLI, 1SB-1SB-E-1SB-1SB-1SB-E-1SB-1SB-1SB-T, PIEL 0302 GRAYSH.	PT
valida	3679-52-P0302	RAVIOLI, 1SB-1SB-E-1SB-1SB-ASB-TC, PIEL 0302 GRAYSH	PT
valida	3679-90-P0301	RAVIOLI, -ASB-, PIEL 0301 NEGRO.	PT
valida	3679-40-P0228	RAVIOLI, -E-, PIEL 0228 AMARETTO.	PT
valida	3679-40-P0301	RAVIOLI, -E-, PIEL 0301 NEGRO.	PT
valida	3679-40-P0302	RAVIOLI, -E-, PIEL 0302 GRAYSH.	PT
valida	3679-40-P0312	RAVIOLI, -E-, PIEL 0312 NIEVE.	PT
valida	3679-40-P0314	RAVIOLI, -E-, PIEL 0314 MOHO.	PT
valida	3679-40-P0321	RAVIOLI, -E-, PIEL 0321 TRIGO.	PT
valida	3679-40-P0402	RAVIOLI, -E-, PIEL 0402 GRIS.	PT
valida	3679-40-P0415	RAVIOLI, -E-, PIEL 0515 MOON.	PT
valida	3679-07-P0103	RAVIOLI, -REC KS-, PIEL 0103 BLANCO.	PT
valida	3679-07-P0301	RAVIOLI, -REC KS-, PIEL 0301 NEGRO.	PT
valida	3679-07-P0302	RAVIOLI, -REC KS-, PIEL 0302 GRAYSH.	PT
valida	3679-07-P0303	RAVIOLI, -REC KS-, PIEL 0303 BLANCO.	PT
valida	3679-07-P0306	RAVIOLI, -REC KS-, PIEL 0306 CANELA.	PT
valida	3679-07-P0307	RAVIOLI, -REC KS-, PIEL 0307 CHANTILLY.	PT
valida	3679-07-P0312	RAVIOLI, -REC KS-, PIEL 0312 NIEVE.	PT
valida	3679-07-P0318	RAVIOLI, -REC KS-, PIEL 0318 MORA.	PT
valida	3679-07-P0319	RAVIOLI, -REC KS-, PIEL 0319 NOGAL.	PT
valida	3679-07-P0402	RAVIOLI, -REC KS-, PIEL 0402 GRIS.	PT
valida	3679-07-P0403	RAVIOLI, -REC KS-, PIEL 0403 BUCK OFF WHITE.	PT
valida	3679-07-P0422	RAVIOLI, -REC KS-, PIEL 0422 BUCK HUMO.	PT
valida	3679-07-P0433	RAVIOLI, -REC KS-, PIEL 0433 CHERRY.	PT
valida	3679-07-P0440	RAVIOLI, -REC KS-, PIEL 0440 ROBLE.	PT
valida	3679-07-P0502	RAVIOLI, -REC KS-, PIEL 0502 MARBLE.	PT
valida	3679-07-P0412	RAVIOLI, -REC KS-, PIEL 0512 CUOIO.	PT
valida	3679-07-P0415	RAVIOLI, -REC KS-, PIEL 0515 MOON.	PT
valida	3679-07-P0523	RAVIOLI, -REC KS-, PIEL 0623 CHAMPAGNE.	PT
valida	3679-07-P0702	RAVIOLI, -REC KS-, PIEL 0702 GRAFITO.	PT
valida	3679-07-P0806	RAVIOLI, -REC KS-, PIEL 0806 ACERO.	PT
valida	3679-07-P0353	RAVIOLI, -REC KS-,PIEL 0353 HONEY.	PT
valida	3679-21-P0228	RAVIOLI, -T-, PIEL 0228 AMARETTO.	PT
valida	3679-21-P0301	RAVIOLI, -T-, PIEL 0301 NEGRO.	PT
valida	3679-21-P0302	RAVIOLI, -T-, PIEL 0302 GRAYSH.	PT
valida	3679-21-P0312	RAVIOLI, -T-, PIEL 0312 NIEVE.	PT
valida	3679-21-P0402	RAVIOLI, -T-, PIEL 0402 GRIS.	PT
valida	3679-21-P0415	RAVIOLI, -T-, PIEL 0515 MOON.	PT
valida	3679-51-P0301	RAVIOLI, T-1SB-1SB-E-1SB-1SB-ASB-TC-1SB, PIEL 0301 NEGRO.	PT
valida	3679-51-P0302	RAVIOLI, T-1SB-1SB-E-1SB-1SB-ASB-TC-1SB, PIEL 0302 GRAYSH.	PT
valida	3679-28-P0702	RAVIOLI, -TC-, PIEL 0702 GRAFITO.	PT
valida	3679-28-P0802	RAVIOLI, -TC-, PIEL 0802 GRAFITO.	PT
valida	ZAR0865	RECLINABLE (MO) GAMMA COLOR BEIGE.	PT
valida	ZAR0866	RECLINER (PROTO) 1R ELECTRICO US, PIEL 0231 FERRERO/PU FERRERO	PT
valida	3794-38-B0051	RECLINER ELECTRICO (BOTON P2), -1RMD-, PIEL 0231 FERRERO/PU FERRERO/TELA SOFT CHOCOLATE.	PT
valida	3794-37-B0051	RECLINER ELECTRICO (BOTON P2), -1RMI-, PIEL 0231 FERRERO/PU FERRERO/TELA SOFT CHOCOLATE.	PT
valida	3794-32-B0051	RECLINER ELECTRICO (BOTON P2), -2R-, PIEL 0231 FERRERO/PU FERRERO/TELA SOFT CHOCOLATE.	PT
valida	3795-38-B0051	RECLINER ELÉCTRICO C/NUQUERA (BOTON P2), -1RMD-, PIEL 0231 FERRERO/PU FERRERO/TELA SOFT CHOCOLATE.	PT
valida	3795-37-B0051	RECLINER ELÉCTRICO C/NUQUERA (BOTON P2), -1RMI-, PIEL 0231 FERRERO/PU FERRERO/TELA SOFT CHOCOLATE.	PT
valida	3795-32-B0051	RECLINER ELÉCTRICO C/NUQUERA (BOTON P2), -2R-, PIEL 0231 FERRERO/PU FERRERO/TELA SOFT CHOCOLATE.	PT
valida	3775	RECLINER ELECTRICO C/NUQUERA,	PT
valida	3775-38-B0051	RECLINER ELÉCTRICO C/NUQUERA, -1RMD-, PIEL 0231 FERRERO/PU FERRERO/TELA SOFT CHOCOLATE.	PT
valida	3775-37-B0051	RECLINER ELÉCTRICO C/NUQUERA, -1RMI-, PIEL 0231 FERRERO/PU FERRERO/TELA SOFT CHOCOLATE.	PT
valida	3775-32-B0051	RECLINER ELÉCTRICO C/NUQUERA, -2R-, PIEL 0231 FERRERO/PU FERRERO/TELA SOFT CHOCOLATE.	PT
valida	3775-42-B0051	RECLINER ELÉCTRICO C/NUQUERA,-CINTILLO-, POLIURETANO FERRERO.	SP
valida	3774	RECLINER ELECTRICO,	PT
valida	3774-40- B0051	RECLINER ELÉCTRICO, -1RMD-, BRA PIEL 0231 FERRERO/PU FERRERO/TELA SOFT CHOCOLATE.	PT
valida	3774-38-B0051	RECLINER ELECTRICO, -1RMD-, PIEL 0231 FERRERO/PU FERRERO/TELA SOFT CHOCOLATE.	PT
valida	3774-39- B0051	RECLINER ELÉCTRICO, -1RMI-, BRA PIEL 0231 FERRERO/PU FERRERO/TELA SOFT CHOCOLATE.	PT
valida	3774-37-B0051	RECLINER ELECTRICO, -1RMI-, PIEL 0231 FERRERO/PU FERRERO/TELA SOFT CHOCOLATE.	PT
valida	3774-41- B0051	RECLINER ELÉCTRICO, -2R-, BRA PIEL 0231 FERRERO/PU FERRERO/TELA SOFT CHOCOLATE.	PT
valida	3774-32-B0051	RECLINER ELECTRICO, -2R-, PIEL 0231 FERRERO/PU FERRERO/TELA SOFT CHOCOLATE.	PT
valida	3774-42-B0051	RECLINER ELECTRICO,-CINTILLO-, POLIURETANO FERRERO (XIC).	SP
valida	3781-32-B0077	RECLINER ELECTRICO,-CINTILLO-, POLIURETANO NEGRO.	SP
valida	3800	RECLINER OMAN ELECTRICO CON NUQUERA	PT
valida	3800-38-B0051	RECLINER OMAN ELECTRICO CON NUQUERA, -1RMD-, PIEL 0231 FERRERO/PU FERRERO/TELA SOFT CHOCOLATE.	PT
valida	3800-37-B0051	RECLINER OMAN ELECTRICO CON NUQUERA, -1RMI-, PIEL 0231 FERRERO/PU FERRERO/TELA SOFT CHOCOLATE.	PT
valida	3800-47-B0051	RECLINER OMAN ELECTRICO CON NUQUERA, -2R-, PIEL 0231 FERRERO/PU FERRERO/TELA SOFT CHOCOLATE.	PT
valida	3800-32-B0051	RECLINER OMAN ELECTRICO CON NUQUERA, -2R-, PIEL 0231 FERRERO/PU FERRERO/TELA SOFT CHOCOLATE.	PT
valida	ZAR0770	RINO (PROTO) - ASIENTO - PIEL 0433 CHERRY.	PT
valida	ZAR0768	RINO (PROTO) - ASIENTO - PIEL 0640 ROSE.	PT
valida	3768-11-P0228	RINO, -ASIENTO-, PIEL 0228 AMARETTO.	PT
valida	3768-11-P0301	RINO, -ASIENTO-, PIEL 0301 NEGRO MATE.	PT
valida	3768-11-P0342	RINO, -ASIENTO-, PIEL 0342 TOPO.	PT
valida	3768-11-P0433	RINO, -ASIENTO-, PIEL 0433 CHERRY.	PT
valida	3768-12-M0110	RINO, -BANCA-, CHAPA EBANO NEGRO GABON.	PT
valida	ZAR0797	RITA (MO) -SILLA- 48X58X87, PIEL 953 ARDESIA	PT
valida	27078Z0015	ROBOTICK PERFECT CHAIR 200 -NEGRO- (AG-6000)	PT
valida	27078Z0001	ROBOTICK ZK-001 -RECLI- NEGRO (EC570C)	PT
valida	27078Z0007	ROBOTICK ZK-005 -RECLI- NEGRO (EC585C)	PT
valida	27078Z0008	ROBOTICK ZK-006 -RECLI- NEGRO (EC380D)	PT
valida	27078Z0013	ROBOTICK ZK-008-RECLI-BROWN (EC618B)	PT
valida	3742-54-P0302	SKAR, MESA OVALADA, 1.10 X 2.00 X .35 M. PIEL 0302 GRAYSH.	PT
valida	ZAR0709	SKY (PROTO) -SILLA- PIEL 0402 GRIS.	PT
valida	3747-01-P0314	SKY, -1-, PIEL 0314 MOHO.	PT
valida	3747-01-P0342	SKY, -1-, PIEL 0342 TOPO (FI).	PT
valida	3747-01-P0402	SKY, -1-, PIEL 0402 GRIS.	PT
valida	3747-01-P0422	SKY, -1-, PIEL 0422 BUCK HUMO.	PT
valida	3747-01-P0415	SKY, -1-, PIEL 0515 MOON.	PT
valida	3747-01-P0640	SKY, -1-, PIEL 0640 ROSE.	PT
valida	3747-55-P0332	SKY, -ANTECOMEDOR CIRCULAR DIA.1400MM-, CRISTAL/ PIEL 0332 CIMARRON.	PT
valida	3747-51-P0339	SKY, -COMEDOR REC.-, MARMOL SANTO TOMAS GRIS / PIEL 0339 POLAR.	PT
valida	ZAR0874	SOL MASSAGER	PT
valida	3248-07-P0302	SPUTNIK, -REC KS-, PIEL 0302 GRAYSH.	PT
valida	3248-07-P0303	SPUTNIK, -REC KS-, PIEL 0303 BLANCO.	PT
valida	3248-07-P0402	SPUTNIK, -REC KS-, PIEL 0402 GRIS.	PT
valida	3248-07-P0703	SPUTNIK, -REC KS-, PIEL 0703 OFF WHITE.	PT
valida	3718-37-P0230	STOZZA, -1R-, PIEL 0230 CHOCOLATE.	PT
valida	3718-37-P0301	STOZZA, -1R-, PIEL 0301 NEGRO.	PT
valida	3718-37-P0305	STOZZA, -1R-, PIEL 0305 OLIVO	PT
valida	3718-37-P0306	STOZZA, -1R-, PIEL 0306 CANELA	PT
valida	3718-37-P0310	STOZZA, -1R-, PIEL 0310 BROWN	PT
valida	3718-37-P0318	STOZZA, -1R-, PIEL 0318 MORA.	PT
valida	3718-37-P0342	STOZZA, -1R-, PIEL 0342 TOPO.	PT
valida	3718-37-P0422	STOZZA, -1R-, PIEL 0422 BUCK HUMO.	PT
valida	3718-37-P0440	STOZZA, -1R-, PIEL 0440 ROBLE.	PT
valida	3718-38-P0228	STOZZA, -1RBD-, PIEL 0228 AMARETTO.	PT
valida	3718-38-P0301	STOZZA, -1RBD-, PIEL 0301 NEGRO MATE.	PT
valida	3718-38-P0319	STOZZA, -1RBD-, PIEL 0319 NOGAL.	PT
valida	3718-38-P0406	STOZZA, -1RBD-, PIEL 0406 CHEESE.	PT
valida	3718-38-P0511	STOZZA, -1RBD-, PIEL 0511 NEGRO.	PT
valida	3718-38-P0412	STOZZA, -1RBD-, PIEL 0512 CUOIO.	PT
valida	3718-38-P0413	STOZZA, -1RBD-, PIEL 0513 SABBIA.	PT
valida	3718-39-P0228	STOZZA, -1RBI-, PIEL 0228 AMARETTO.	PT
valida	3718-39-P0319	STOZZA, -1RBI-, PIEL 0319 NOGAL.	PT
valida	3718-39-P0412	STOZZA, -1RBI-, PIEL 0512 CUOIO.	PT
valida	3718-39-P0703	STOZZA, -1RBI-, PIEL 0703 VAINILLA.	PT
valida	3718-61-P0204	STOZZA, 1RBI-1RBD, PIEL 0204 ARENA.	PT
valida	3718-61-P0312	STOZZA, 1RBI-1RBD, PIEL 0312 NIEVE.	PT
valida	3718-62-P0306	STOZZA, 1RBI-1RSB-1RBD, PIEL 0306 CANELA.	PT
valida	3718-62-P0314	STOZZA, 1RBI-1RSB-1RBD, PIEL 0314 MOHO.	PT
valida	3718-62-P0318	STOZZA, 1RBI-1RSB-1RBD, PIEL 0318 MORA.	PT
valida	3718-36-P0306	STOZZA, -1RSB-, PIEL 0306 CANELA.	PT
valida	3718-36-P0318	STOZZA, -1RSB-, PIEL 0318 MORA.	PT
valida	3718-36-P0406	STOZZA, -1RSB-, PIEL 0406 CHEESE.	PT
valida	3718-36-P0412	STOZZA, -1RSB-, PIEL 0512 CUOIO.	PT
valida	3718-36-P0415	STOZZA, -1RSB-, PIEL 0515 MOON.	PT
valida	3718-35-P0306	STOZZA, -1SB- PIEL 0306 CANELA.	PT
valida	3718-35-P0321	STOZZA, -1SB- PIEL 0321 TRIGO.	PT
valida	3718-35-P0353	STOZZA, -1SB- PIEL 0353 HONEY.	PT
valida	3718-35-P0433	STOZZA, -1SB- PIEL 0433 CHERRY.	PT
valida	3718-35-P0440	STOZZA, -1SB- PIEL 0440 ROBLE.	PT
valida	3718-35-P0413	STOZZA, -1SB- PIEL 0513 SABBIA.	PT
valida	3718-34-P0306	STOZZA, 3RR-2RR, PIEL 0306 CANELA.	PT
valida	3718-34-P0342	STOZZA, 3RR-2RR, PIEL 0342 TOPO.	PT
valida	3718-34-P0353	STOZZA, 3RR-2RR, PIEL 0353 HONEY.	PT
valida	3718-34-P0433	STOZZA, 3RR-2RR, PIEL 0433 CHERRY.	PT
valida	3718-34-P0440	STOZZA, 3RR-2RR, PIEL 0440 ROBLE.	PT
valida	3718-34-P0413	STOZZA, 3RR-2RR, PIEL 0513 SABBIA.	PT
valida	3718-33-P0306	STOZZA, 3RRR-2RR, PIEL 0306 CANELA.	PT
valida	3718-32-P0440	STOZZA, 3RRR-2RR, PIEL 0440 ROBLE.	PT
valida	3718-39-P0301	STOZZA,-1RBI-, PIEL 0301 NEGRO MATE.	PT
valida	3718-39-P0406	STOZZA,-1RBI-, PIEL 0406 CHEESE.	PT
valida	3718-61-P0318	STOZZA,-1RBI-1RBD-, PIEL 0318 MORA.	PT
valida	3718-61-P0830	STOZZA,-1RBI-1RBD-, PIEL 0830 RED BROWN.	PT
valida	3718-62-P0412	STOZZA,-1RBI-1RSB-1RBD-, PIEL 0512 CUOIO.	PT
valida	3739-01-P0402	TAZZ, -1-, PIEL 0402 GRIS.	PT
valida	3739-01-P0403	TAZZ, -1-, PIEL 0403 BUCK OFF WHITE.	PT
valida	3739-01-P0422	TAZZ, -1-, PIEL 0422 BUCK HUMO.	PT
valida	3739-01-P0427	TAZZ, -1-, PIEL 0427 BUCK MARRRONE.	PT
valida	3739-01-P0506	TAZZ, -1-, PIEL 0506 WALNUT (PULL UP EXPORTACION).	PT
valida	3739-01-P0412	TAZZ, -1-, PIEL 0512 CUOIO.	PT
valida	3739-01-P0703	TAZZ, -1-, PIEL 0703 OFF WHITE.	PT
valida	3738-90-P0230	TAZZI, -RIÑONERA-, PIEL 0230 CHOCOLATE.	PT
valida	3738-90-P0304	TAZZI, -RIÑONERA-, PIEL 0304 SIENA.	PT
valida	3738-90-P0312	TAZZI, -RIÑONERA-, PIEL 0312 NIEVE.	PT
valida	3738-90-P0342	TAZZI, -RIÑONERA-, PIEL 0342 TOPO.	PT
valida	3738-90-P0619	TAZZI, -RIÑONERA-, PIEL 0619 BLEU.	PT
valida	3738-02-P0312	TAZZO, -2-, PIEL 0312 NIEVE.	PT
valida	3738-02-P0415	TAZZO, -2-, PIEL 0515 MOON.	PT
valida	3738-03-P0403	TAZZO, -3-, PIEL 0403 BUCK OFF WHITE.	PT
valida	3738-32-P0312	TAZZO, -3-2-, PIEL 0312 NIEVE.	PT
valida	3738-32-P0314	TAZZO, -3-2-, PIEL 0314 MOHO.	PT
valida	3738-34-P0415	TAZZO, -3-2-, PIEL 0515 MOON.	PT
valida	3738-26-P0301	TAZZO, -BURO-, PIEL 0301 NEGRO.	PT
valida	3738-53-P0312	TAZZO, -MESA REDONDA-, DIAM 40 X 53 CMS PIEL 0312 NIEVE.	PT
valida	3738-09-P0301	TAZZO, -PIE DE CAMA KS-, PIEL 0301 NEGRO MATE.	PT
valida	3738-09-P0306	TAZZO, -PIE DE CAMA KS-, PIEL 0306 CANELA.	PT
valida	3738-09-P0342	TAZZO, -PIE DE CAMA KS-, PIEL 0342 TOPO.	PT
valida	3738-09-P0402	TAZZO, -PIE DE CAMA KS-, PIEL 0402 GRIS.	PT
valida	3738-09-P0403	TAZZO, -PIE DE CAMA KS-, PIEL 0403 BUCK OFF WHITE.	PT
valida	3738-09-P0422	TAZZO, -PIE DE CAMA KS-, PIEL 0422 BUCK HUMO.	PT
valida	3738-09-P0427	TAZZO, -PIE DE CAMA KS-, PIEL 0427 BUCK MARRONE.	PT
valida	3738-09-P0415	TAZZO, -PIE DE CAMA KS-, PIEL 0515 MOON.	PT
valida	3738-09-P0544	TAZZO, -PIE DE CAMA KS-, PIEL 0644 CARBON.	PT
valida	3738-09-P0702	TAZZO, -PIE DE CAMA KS-, PIEL 0702 GRAFITO.	PT
valida	3738-09-P0720	TAZZO, -PIE DE CAMA KS-, PIEL 0720 INDIGO.	PT
valida	3738-09-B0058	TAZZO, -PIE DE CAMA KS-, TELA ZARK TERCIOPELO AZUL.	PT
valida	3738-07-P0302	TAZZO, -RECAMARA KS-, PIEL 0302 GRAYSH.	PT
valida	3738-07-P0303	TAZZO, -RECAMARA KS-, PIEL 0303 BLANCO.	PT
valida	3738-07-P0312	TAZZO, -RECAMARA KS-, PIEL 0312 NIEVE.	PT
valida	3738-07-P0314	TAZZO, -RECAMARA KS-, PIEL 0314 MOHO.	PT
valida	3738-07-P0402	TAZZO, -RECAMARA KS-, PIEL 0402 GRIS.	PT
valida	3738-07-P0403	TAZZO, -RECAMARA KS-, PIEL 0403 BUCK OFF WHITE.	PT
valida	3738-07-P0422	TAZZO, -RECAMARA KS-, PIEL 0422 BUCK HUMO.	PT
valida	3738-50-P0312	TAZZO, -SET 3 MESAS-, PIEL 0312 NIEVE.	PT
valida	18230	TELA INK ONIX.	MP
valida	3684-15-P0414	TERZO , 3-2- BASTIDOR DE MADERA, PIEL 0514 CASTAÑO.	PT
valida	3684-32-P0414	TERZO , 3-2, PIEL 0514 CASTAÑO.	PT
valida	3684-11-P0230	TERZO, -1- BASTIDOR DE MADERA, PIEL 0230 CHOCOLATE.	PT
valida	3684-11-P0301	TERZO, -1- BASTIDOR DE MADERA, PIEL 0301 NEGRO.	PT
valida	3684-11-P0318	TERZO, -1- BASTIDOR DE MADERA, PIEL 0318 MORA.	PT
valida	3684-11-P0353	TERZO, -1- BASTIDOR DE MADERA, PIEL 0353 HONEY.	PT
valida	3684-01-P0318	TERZO, -1-, PIEL 0318 MORA	PT
valida	3684-12-P0228	TERZO, -2- BASTIDOR DE MADERA, PIEL 0228 AMARETTO.	PT
valida	3684-12-P0312	TERZO, -2- BASTIDOR DE MADERA, PIEL 0312 NIEVE.	PT
valida	3684-12-P0318	TERZO, -2- BASTIDOR DE MADERA, PIEL 0318 MORA.	PT
valida	3684-12-P0353	TERZO, -2- BASTIDOR DE MADERA, PIEL 0353 HONEY.	PT
valida	3684-12-P0414	TERZO, -2- BASTIDOR DE MADERA, PIEL 0514 CASTAÑO.	PT
valida	3684-12-P0702	TERZO, -2- BASTIDOR DE MADERA, PIEL 0702 GRAFITO.	PT
valida	3684-02-P0204	TERZO, -2-, PIEL 0204 ARENA.	PT
valida	3684-02-P0318	TERZO, -2-, PIEL 0318 MORA	PT
valida	3684-02-P0342	TERZO, -2-, PIEL 0342 TOPO	PT
valida	3684-02-P0414	TERZO, -2-, PIEL 0514 CASTAÑO.	PT
valida	3684-02-P0526	TERZO, -2-, PIEL 0526 CIGAR.	PT
valida	3684-02-P0703	TERZO, -2-, PIEL 0703 VAINILLA	PT
valida	3684-02-P0803	TERZO, -2-, PIEL 0803 PEWTER	PT
valida	3684-13-P0228	TERZO, -3- BASTIDOR DE MADERA, PIEL 0228 AMARETTO.	PT
valida	3684-13-P0301	TERZO, -3- BASTIDOR DE MADERA, PIEL 0301 NEGRO.	PT
valida	3684-13-P0312	TERZO, -3- BASTIDOR DE MADERA, PIEL 0312 NIEVE.	PT
valida	3684-13-P0318	TERZO, -3- BASTIDOR DE MADERA, PIEL 0318 MORA.	PT
valida	3684-13-P0353	TERZO, -3- BASTIDOR DE MADERA, PIEL 0353 HONEY.	PT
valida	3684-13-P0433	TERZO, -3- BASTIDOR DE MADERA, PIEL 0433 CHERRY.	PT
valida	3684-13-P0414	TERZO, -3- BASTIDOR DE MADERA, PIEL 0514 CASTAÑO.	PT
valida	3684-13-P0702	TERZO, -3- BASTIDOR DE MADERA, PIEL 0702 GRAFITO.	PT
valida	3684-03-P0318	TERZO, -3-, PIEL 0318 MORA	PT
valida	3684-03-P0414	TERZO, -3-, PIEL 0514 CASTAÑO.	PT
valida	3364-11-P0403	TIKRIT, -1 BAST. MADERA-, PIEL 0403 BUCK OFF WHITE.	PT
valida	3364-11-P0415	TIKRIT, -1 BAST. MADERA-, PIEL 0515 MOON.	PT
valida	3364-01-P0302	TIKRIT, -1-, PIEL 0302 GRAYSH.	PT
valida	3364-01-P0303	TIKRIT, -1-, PIEL 0303 BLANCO.	PT
valida	3364-01-P0313	TIKRIT, -1-, PIEL 0313 CUIR.	PT
valida	3364-01-P0314	TIKRIT, -1-, PIEL 0314 MOHO.	PT
valida	3364-01-P0321	TIKRIT, -1-, PIEL 0321 TRIGO.	PT
valida	3364-01-P0402	TIKRIT, -1-, PIEL 0402 GRIS.	PT
valida	3364-01-P0403	TIKRIT, -1-, PIEL 0403 BUCK OFF WHITE.	PT
valida	3364-01-P0415	TIKRIT, -1-, PIEL 0515 MOON.	PT
valida	3364-01-P0706	TIKRIT, -1-, PIEL 0706 GRILLO.	PT
valida	ZAR0744	TOTTO (PROTO) - 1SB - PIEL 0619 BLEU/TELA PLATINUM KAYE INK.	PT
valida	ZAR0743	TOTTO (PROTO) - E - PIEL 0619 BLEU/TELA PLATINUM KAYE INK.	PT
valida	ZAR0745	TOTTO (PROTO) - T - PIEL 0619 BLEU/TELA PLATINUM KAYE INK.	PT
valida	3761-17-B0047	TOTTO, -1SB-, PIEL 0619 BLEU / TELA INK AZUL.	PT
valida	3761-17-B0073	TOTTO, -1SB-, TELA INK AZUL.	PT
valida	3761-17-B0079	TOTTO, -1SB-, TELA INK ONIX.	PT
valida	3761-17-B0064	TOTTO, -1SB-, TELA NATURA BEIGE.	PT
valida	3761-17-B0065	TOTTO, -1SB-, TELA NATURA GRIS.	PT
valida	3761-17-B0055	TOTTO, -1SB-, TELA ZARK TERCIOPELO MUSE.	PT
valida	3761-40-B0047	TOTTO, -E-, PIEL 0619 BLEU / TELA INK AZUL.	PT
valida	3761-40-B0073	TOTTO, -E-, TELA INK AZUL.	PT
valida	3761-40-B0064	TOTTO, -E-, TELA NATURA BEIGE.	PT
valida	3761-40-B0065	TOTTO, -E-, TELA NATURA GRIS.	PT
valida	3761-40-B0055	TOTTO, -E-, TELA ZARK TERCIOPELO MUSE.	PT
valida	3761-56-P0422	TOTTO,-COJIN DECORATIVO-PIEL 0422 BUCK HUMO.	PT
valida	3761-56-B0091	TOTTO,-COJIN DECORATIVO-TELA ZARKS TERCIOPELO MARRON	PT
valida	3729-37-P0103	TRIKIZZ, -1R-, PIEL 0103 BLANCO.	PT
valida	3729-37-P0228	TRIKIZZ, -1R-, PIEL 0228 AMARETTO.	PT
valida	3729-37-P0230	TRIKIZZ, -1R-, PIEL 0230 CHOCOLATE.	PT
valida	3729-37-P0312	TRIKIZZ, -1R-, PIEL 0312 NIEVE.	PT
valida	3729-37-P0313	TRIKIZZ, -1R-, PIEL 0313 CUIR.	PT
valida	3729-37-P0342	TRIKIZZ, -1R-, PIEL 0342 TOPO.	PT
valida	3729-37-P0636	TRIKIZZ, -1R-, PIEL 0636 WALNUT.	PT
valida	3663-01-MP0318	UNDIZZI, -1-, MPIEL 0318 MORA.	PT
valida	3663-01-P0318	UNDIZZI, -1-, PIEL 0318 MORA.	PT
valida	3663-01-P0702	UNDIZZI, -1-, PIEL 0702 GRAFITO.	PT
valida	3659-02-P0314	VERDI -2- PIEL 0314 MOHO.	PT
valida	3659-03-P0314	VERDI -3- PIEL 0314 MOHO.	PT
valida	3659-32-P0342	VERDI -3-2- PIEL 0342 TOPO.	PT
valida	3624-01-P0228	VEREY, -1SB-, PIEL 0228 AMARETTO.	PT
valida	3624-01-P0310	VEREY, -1SB-, PIEL 0310 BROWN.	PT
valida	3624-01-P0312	VEREY, -1SB-, PIEL 0312 NIEVE.	PT
valida	3624-14-P0301	VEREY, -3BI-, PIEL 0301 NEGRO.	PT
valida	3624-14-P0312	VEREY, -3BI-, PIEL 0312 NIEVE.	PT
valida	3624-06-P0301	VEREY, 3BI-ECHD, PIEL 0301 NEGRO.	PT
valida	3624-24-P0301	VEREY, -ECHD-, PIEL 0301 NEGRO.	PT
valida	3624-24-P0312	VEREY, -ECHD-, PIEL 0312 NIEVE.	PT
valida	3624-23-P0310	VEREY, -ECHI-, PIEL 0310 BROWN.	PT
valida	3624-21-P0442	VEREY, -T-, PIEL 0442 TOPO.	PT
valida	16225	VIDRIO PARA MESA ABATIBLE PIZZA ELECTRICO 1R/2R (XIC)	MP
valida	3482-01-P0311	ZAMPA, -1-, PIEL 0311 MARFIL.	PT
valida	ZAR0696	ZAPPI (PROTO) -CONSOLA RECANGULAR- MARMOL SANTO TOMAS GRIS.	PT
valida	ZAR0672	ZAPPI (PROTO) -CONSOLA TRIANGULAR- MARMOL SANTO TOMAS GRIS.	PT
valida	ZAR0697	ZAPPI (PROTO) -MESA RECTANGULAR- MARMOL SANTO TOMAS GRIS.	PT
valida	ZAR0786	ZAPPO (MO) 3BD PIEL GRIS.	PT
valida	ZAR0787	ZAPPO (MO) ABI PIEL GRIS.	PT
valida	ZAR0694	ZAPPO (PROTO) ABI-3BD PIEL 0801 WENGE.	PT
valida	3743-14-P0342	ZAPPO, -3BI-, PIEL 0342 TOPO.	PT
valida	3743-17-P0342	ZAPPO, -ABD-, PIEL 0342 TOPO.	PT
valida	3743-07-P0342	ZAPPO,3BD-ABI, PIEL 0342 TOPO.	PT
valida	ZAR0735	ZAPPU (MO) -1- PC0402 GRIS	PT
valida	3757-17-P0301	ZAREY, -1SB-, PIEL 0301 NEGRO MATE.	PT
valida	3757-17-P0303	ZAREY, -1SB-, PIEL 0303 BLANCO.	PT
valida	3757-17-P0306	ZAREY, -1SB-, PIEL 0306 CANELA.	PT
valida	3757-17-P0312	ZAREY, -1SB-, PIEL 0312 NIEVE.	PT
valida	3757-17-P0318	ZAREY, -1SB-, PIEL 0318 MORA.	PT
valida	3757-17-P0342	ZAREY, -1SB-, PIEL 0342 TOPO.	PT
valida	3757-15-P0306	ZAREY, -3BD-, PIEL 0306 CANELA.	PT
valida	3757-14-P0303	ZAREY, -3BI-, PIEL 0303 BLANCO.	PT
valida	3757-14-P0306	ZAREY, -3BI-, PIEL 0306 CANELA.	PT
valida	3757-14-P0312	ZAREY, -3BI-, PIEL 0312 NIEVE.	PT
valida	3757-14-P0314	ZAREY, -3BI-, PIEL 0314 MOHO	PT
valida	3757-14-P0318	ZAREY, -3BI-, PIEL 0318 MORA.	PT
valida	3757-04-P0301	ZAREY, 3BI-CHBD, PIEL 0301 NEGRO MATE.	PT
valida	3757-04-P0302	ZAREY, 3BI-CHBD, PIEL 0302 GRAYSH.	PT
valida	3757-04-P0303	ZAREY, 3BI-CHBD, PIEL 0303 BLANCO.	PT
valida	3757-08-P0303	ZAREY, 3BI-CHBD, PIEL 0303 BLANCO.	PT
valida	3757-04-P0306	ZAREY, 3BI-CHBD, PIEL 0306 CANELA.	PT
valida	3757-04-P0312	ZAREY, 3BI-CHBD, PIEL 0312 NIEVE	PT
valida	3757-04-P0318	ZAREY, 3BI-CHBD, PIEL 0318 MORA.	PT
valida	3757-04-P0342	ZAREY, 3BI-CHBD, PIEL 0342 TOPO	PT
valida	3757-04-P0402	ZAREY, 3BI-CHBD, PIEL 0402 GRIS.	PT
valida	3757-24-P0303	ZAREY, -CHBD-, PIEL 0303 BLANCO.	PT
valida	3757-24-P0314	ZAREY, -CHBD-, PIEL 0314 MOHO	PT
valida	3757-24-P0318	ZAREY, -CHBD-, PIEL 0318 MORA.	PT
valida	3757-05-P0301	ZAREY, CHBI-3BD, PIEL 0301 NEGRO MATE.	PT
valida	3757-05-P0302	ZAREY, CHBI-3BD, PIEL 0302 GRAYSH.	PT
valida	3757-05-P0303	ZAREY, CHBI-3BD, PIEL 0303 BLANCO.	PT
valida	3757-05-P0306	ZAREY, CHBI-3BD, PIEL 0306 CANELA.	PT
valida	3757-05-P0312	ZAREY, CHBI-3BD, PIEL 0312 NIEVE.	PT
valida	3757-05-P0318	ZAREY, CHBI-3BD, PIEL 0318 MORA	PT
valida	3757-05-P0342	ZAREY, CHBI-3BD, PIEL 0342 TOPO.	PT
valida	3757-51-P0302	ZAREY, -ECHD-, PIEL 0302 GRAYSH.	PT
valida	3757-51-P0318	ZAREY, -ECHD-, PIEL 0318 MORA.	PT
valida	3757-21-P0301	ZAREY, -T-, PIEL 0301 NEGRO MATE.	PT
valida	3757-21-P0303	ZAREY, -T-, PIEL 0303 BLANCO.	PT
valida	3757-21-P0306	ZAREY, -T-, PIEL 0306 CANELA.	PT
valida	3757-21-P0312	ZAREY, -T-, PIEL 0312 NIEVE.	PT
valida	3757-21-P0342	ZAREY, -T-, PIEL 0342 TOPO.	PT
valida	3464-17-P0302	ZEDIE -1SB- PIEL 0302 GRAYSH.	PT
valida	3464-41-P0302	ZEDIE -TX- PIEL 0302 GRAYSH.	PT
valida	3464-20-P0302	ZEDIE, -E-, PIEL 0302 GRAYSH.	PT
valida	3464-20-P0303	ZEDIE, -E-, PIEL 0303 BLANCO.	PT
valida	3464-31-P0302	ZEDIE, -TM-, PIEL 0302 GRAYSH.	PT
valida	3464-51-P0302	ZEDIE, -TXB-, PIEL 0302 GRAYSH.	PT
valida	3672-32-P0412	ZEPPO, 3-2, PIEL 0512 CUOIO.	PT
valida	3788-21-P0412	ZERGENTTI, -T-, PIEL 0512 CUOIO.	PT
valida	3678-01-P0103	ZI, -1-, PIEL 0103 BLANCO.	PT
valida	3678-01-P0312	ZI, -1-, PIEL 0312 NIEVE	PT
valida	3678-01-P0422	ZI, -1-, PIEL 0422 BUCK HUMO.	PT
valida	3678-01-P0414	ZI, -1-, PIEL 0514 CASTAÑO.	PT
valida	3680-02-PM703	ZIAMO, -2-, MENOS PIEL 0703 OFF WHITE.	PT
valida	3680-02-P0433	ZIAMO, -2-, PIEL 0433 CHERRY.	PT
valida	3680-02-P0415	ZIAMO, -2-, PIEL 0515 MOON.	PT
valida	3680-03-PM703	ZIAMO, -3-, MENOS PIEL 0703 OFF WHITE.	PT
valida	3680-03-P0402	ZIAMO, -3-, PIEL 0402 GRIS.	PT
valida	3680-03-P0433	ZIAMO, -3-, PIEL 0433 CHERRY.	PT
valida	3680-03-P0415	ZIAMO, -3-, PIEL 0515 MOON.	PT
valida	3680-03-P0526	ZIAMO, -3-, PIEL 0526 CIGAR.	PT
valida	3680-03-P0619	ZIAMO, -3-, PIEL 0619 BLEU.	PT
valida	3680-32-PM703	ZIAMO, 3-2, MENOS PIEL 0703 OFF WHITE.	PT
valida	3680-32-P0402	ZIAMO, 3-2, PIEL 0402 GRIS.	PT
valida	3680-32-P0433	ZIAMO, 3-2, PIEL 0433 CHERRY.	PT
valida	3680-32-P0442	ZIAMO, 3-2, PIEL 0442 TOPO.	PT
valida	3680-34-P0415	ZIAMO, 3-2, PIEL 0515 MOON.	PT
valida	ZINMP482	ZINMP PLACA DE SERVICIO GRABADA DERECHA (PIZZA).	MP
valida	ZINMP484	ZINMP PLACA DE SERVICIO GRABADA IZQUIERDA (PIZZA).	MP
valida	ZINPT006	ZINPT BORIZZ, -RECLI-, PIEL 0314 MOHO.	PT
valida	ZINPT013	ZINPT CAZZATA, -CHBD-, PIEL 0802 GRAFITO.	PT
valida	ZINPT097	ZINPT MINO -RECLI- PIEL 0229 CREMA / PIEL 0129 CREMA.	PT
valida	ZINPT098	ZINPT MINO -RECLI- PIEL 0230 CHOCOLATE.	PT
valida	ZINPT119	ZINPT PIONINI -CHBIC- PIEL 0715 MUSHROOM.	PT
valida	ZINPT188	ZINPT ZU (MO) -1- PIEL DARK BROWN	PT
valida	3764-02-P0415	ZITRE NEW, -2-, PIEL 0515 MOON.	PT
valida	3764-02-P0803	ZITRE NEW, -2-, PIEL 0803 PEWTER.	PT
valida	3764-03-P0312	ZITRE NEW, -3-, PIEL 0312 NIEVE.	PT
valida	3764-03-P0402	ZITRE NEW, -3-, PIEL 0402 GRIS.	PT
valida	3764-03-P0415	ZITRE NEW, -3-, PIEL 0515 MOON.	PT
valida	3764-03-P0526	ZITRE NEW, -3-, PIEL 0526 CIGAR.	PT
valida	3764-03-P0803	ZITRE NEW, -3-, PIEL 0803 PEWTER.	PT
valida	3764-03-B0055	ZITRE NEW, -3-, TELA ZARK TERCIOPELO MUSE.	PT
valida	3764-32-P0406	ZITRE NEW, 3-2, PIEL 0406 CHESSE	PT
valida	3687-01-P0306	ZITRE, -1-, PIEL 0306 CANELA.	PT
valida	3687-01-P0312	ZITRE, -1-, PIEL 0312 NIEVE.	PT
valida	3687-01-P0318	ZITRE, -1-, PIEL 0318 MORA.	PT
valida	3687-01-P0406	ZITRE, -1-, PIEL 0406 CHEESE	PT
valida	3687-01-P0802	ZITRE, -1-, PIEL 0802 GRAFITO.	PT
valida	3687-02-P0406	ZITRE, -2-, PIEL 0406 CHEESE	PT
valida	3687-02-P0415	ZITRE, -2-, PIEL 0515 MOON.	PT
valida	3687-02-P0619	ZITRE, -2-, PIEL 0619 BLEU.	PT
valida	3687-03-P0406	ZITRE, -3-, PIEL 0406 CHEESE	PT
valida	3687-03-P0415	ZITRE, -3-, PIEL 0515 MOON.	PT
valida	3687-03-P0619	ZITRE, -3-, PIEL 0619 BLEU.	PT
valida	3687-32-P0406	ZITRE, 3-2, PIEL 0406 CHESSE	PT
valida	3687-32-P0422	ZITRE, 3-2, PIEL 0422 BUCK HUMO.	PT
valida	3687-32-P0305	ZITRE, 3-2. PIEL 0305 OLIVO.	PT
valida	3687-32-P0402	ZITRE, 3-2. PIEL 0402 GRIS.	PT
valida	3587-02-P0229	ZITRON -2- PIEL 0229 CREMA.	PT
valida	3587-32-P0342	ZITRON -3-2- PIEL 0342 TOPO.	PT
valida	3587-32-P0302	ZITRON -3-2,  PIEL 0302 GRAYSH	PT
valida	3587-32-P0802	ZITRON, 3-2, PIEL 0702 GRAFITO.	PT
valida	3587-32-P0803	ZITRON, 3-2, PIEL 0803 VAINILLA.	PT
valida	3770-50-B0061	ZO USAR MIKELE, -CS-CUILTEADO, PIEL 0702 GRAFITO / TELA ZARK TERCIOPELO GRIS.	PT
valida	3770-47-B0057	ZO USAR MIKELE, -S- CUILTEADO, TELA ZARK TERCIOPELO GRIS.	PT
valida	3770-43-P0702	ZO USAR MIKELE, -T- CUILTEADO, PIEL 0702 GRAFITO.	PT
valida	3770-43-B0057	ZO USAR MIKELE, -T- CUILTEADO, TELA ZARK TERCIOPELO GRIS .	PT
valida	3720-59-P0412	ZO USAR PUNZZO, -3BI-1SB-CHSB-, PIEL 0512 CUOIO.	PT
valida	3718-69-P0318	ZO USAR STOZZA,-1RBI-1RSB-1RBD-, PIEL 0318 MORA.	PT
valida	3718-74-P0412	ZO USAR STOZZA,-1RBI-1RSB-1RBD-, PIEL 0512 CUOIO.	PT
valida	3688-40-P0515	ZO USAR, BORIZZ, -E-, PIEL 0515 ELEPHANT.	PT
valida	ZAR0598	ZU (MO) -1- PIEL DARK BROWN	PT
valida	ZAR0689	ZUBITTO (PROTO) 1SBLI-1SB-1SBLD PIEL 0803 VAINILLA.	PT
valida	3748-96-P0403	ZUBITTO -COJIN C/CENEFA-, PIEL 0403 BUCK OF WHITE.	PT
valida	3748-96-P0422	ZUBITTO -COJIN C/CENEFA-, PIEL 0422 BUCK HUMO.	PT
valida	3748-96-P0502	ZUBITTO -COJIN C/CENEFA-, PIEL 0502 MARBLE.	PT
valida	3748-96-P0703	ZUBITTO -COJIN C/CENEFA-, PIEL 0703 VAINILLA.	PT
valida	3748-96-P0814	ZUBITTO -COJIN C/CENEFA-, PIEL 0814 CACHUPINO.	PT
valida	3748-95-P0312	ZUBITTO -COJIN C/VIVO-, PIEL 0312 NIEVE.	PT
valida	3748-95-P0318	ZUBITTO -COJIN C/VIVO-, PIEL 0318 MORA.	PT
valida	3748-95-P0403	ZUBITTO -COJIN C/VIVO-, PIEL 0403BUCK OF WITHE.	PT
valida	3748-95-P0422	ZUBITTO -COJIN C/VIVO-, PIEL 0422 BUCK HUMO.	PT
valida	3748-95-P0701	ZUBITTO -COJIN C/VIVO-, PIEL 0701 WENGE.	PT
valida	3748-95-P0703	ZUBITTO -COJIN C/VIVO-, PIEL 0703 VAINILLA.	PT
valida	3748-95-P0814	ZUBITTO -COJIN C/VIVO-, PIEL 0814 CAPUCHINO.	PT
valida	3748-17-P0301	ZUBITTO, -1SB-, PIEL 0301 NEGRO MATE.	PT
valida	3748-17-P0306	ZUBITTO, -1SB-, PIEL 0306 CANELA.	PT
valida	3748-17-P0403	ZUBITTO, -1SB-, PIEL 0403 BUCK OFF WHITE.	PT
valida	3748-17-P0415	ZUBITTO, -1SB-, PIEL 0515 MOON.	PT
valida	3748-09-P0703	ZUBITTO, 1SBLD-ISB-1SBLI, PIEL 0703 VAINILLA.	PT
valida	3748-13-P0103	ZUBITTO, -3BD-, PIEL 0103 BLANCO.	PT
valida	3748-13-P0303	ZUBITTO, -3BD-, PIEL 0303 BLANCO.	PT
valida	3748-13-P0310	ZUBITTO, -3BD-, PIEL 0310 BROWN.	PT
valida	3748-13-P0318	ZUBITTO, -3BD-, PIEL 0318 MORA.	PT
valida	3748-13-P0342	ZUBITTO, -3BD-, PIEL 0342 TOPO.	PT
valida	3748-14-P0228	ZUBITTO, -3BI-, PIEL 0228 AMARETTO.	PT
valida	3748-06-P0204	ZUBITTO, 3BI-ECHD, PIEL 0204 ARENA.	PT
valida	3748-06-P0228	ZUBITTO, 3BI-ECHD, PIEL 0228 AMARETTO.	PT
valida	3748-10-P0303	ZUBITTO, 3BI-ECHD-, PIEL 0303 BLANCO.	PT
valida	3748-06-P0306	ZUBITTO, 3BI-ECHD, PIEL 0306 CANELA.	PT
valida	3748-06-P0312	ZUBITTO, 3BI-ECHD, PIEL 0312 NIEVE.	PT
valida	3748-06-P0314	ZUBITTO, 3BI-ECHD, PIEL 0314 MOHO.	PT
valida	3748-06-P0433	ZUBITTO, 3BI-ECHD, PIEL 0433 CHERRY.	PT
valida	3748-22-P0228	ZUBITTO, -ECHD-, PIEL 0228 AMARETTO.	PT
valida	3748-23-P0103	ZUBITTO, -ECHI-, PIEL 0103 BLANCO.	PT
valida	3748-23-P0303	ZUBITTO, -ECHI-, PIEL 0303 BLANCO.	PT
valida	3748-23-P0310	ZUBITTO, -ECHI-, PIEL 0310 BROWN.	PT
valida	3748-23-P0318	ZUBITTO, -ECHI-, PIEL 0318 MORA.	PT
valida	3748-23-P0342	ZUBITTO, -ECHI-, PIEL 0342 TOPO.	PT
valida	3748-07-P0103	ZUBITTO, ECHI-3BD, PIEL 0103 BLANCO.	PT
valida	3748-07-P0229	ZUBITTO, ECHI-3BD, PIEL 0229 CREMA.	PT
valida	3748-07-P0301	ZUBITTO, ECHI-3BD, PIEL 0301 NEGRO MATE.	PT
valida	3748-07-P0303	ZUBITTO, ECHI-3BD, PIEL 0303 BLANCO.	PT
valida	3748-07-P0306	ZUBITTO, ECHI-3BD, PIEL 0306 CANELA.	PT
valida	3748-07-P0310	ZUBITTO, ECHI-3BD, PIEL 0310 BROWN.	PT
valida	3748-07-P0318	ZUBITTO, ECHI-3BD, PIEL 0318 MORA.	PT
valida	3748-07-P0342	ZUBITTO, ECHI-3BD, PIEL 0342 TOPO.	PT
valida	3748-90-P0318	ZUBITTO, -RIÑONERA-, PIEL 0318 MORA.	PT
valida	3748-90-P0704	ZUBITTO, -RIÑONERA-, PIEL 0704 ALMENDRA.	PT
valida	3748-31-P0403	ZUBITTO, -TAB CUADRADO-, PIEL 0403 BUCK OFF WHITE.	PT
valida	3748-21-P0103	ZUBITTO, -TAB REC-, PIEL 0103 BLANCO.	PT
valida	3748-21-P0229	ZUBITTO, -TAB REC-, PIEL 0229 CREMA.	PT
valida	3748-21-P0301	ZUBITTO, -TAB REC-, PIEL 0301 NEGRO MATE.	PT
valida	3748-21-P0303	ZUBITTO, -TAB REC-, PIEL 0303 BLANCO.	PT
valida	3748-21- P0312	ZUBITTO, -TAB REC-, PIEL 0312 NIEVE.	PT
valida	3748-21-P0403	ZUBITTO, -TAB REC-, PIEL 0403 BUCK OFF WHITE.	PT
valida	3707-07-P0204	ZURDA -RECAMARA KS- PIEL 0204 ARENA.	PT
valida	3707-07-P0301	ZURDA -RECAMARA KS- PIEL 0301 NEGRO.	PT
valida	3707-07-P0306	ZURDA -RECAMARA KS- PIEL 0306 CANELA.	PT
valida	3707-07-P0307	ZURDA -RECAMARA KS- PIEL 0307 CHANTILLY.	PT
valida	3707-07-P0314	ZURDA -RECAMARA KS- PIEL 0314 MOHO.	PT
valida	3707-07-P0318	ZURDA -RECAMARA KS- PIEL 0318 MORA.	PT
valida	3707-07-P0342	ZURDA -RECAMARA KS- PIEL 0342 TOPO.	PT
valida	3707-07-P0415	ZURDA -RECAMARA KS- PIEL 0515 MOON.	PT
valida	3707-07-P0701	ZURDA -RECAMARA KS- PIEL 0701 WENGE.	PT
valida	3707-07-P0702	ZURDA -RECAMARA KS- PIEL 0702 GRAFITO.	PT
valida	3707-07-P0704	ZURDA -RECAMARA KS- PIEL 0704 ALMENDRA.	PT
valida	3707-07-P0720	ZURDA -RECAMARA KS- PIEL 0720 INDIGO.	PT
valida	3707-07-P0806	ZURDA -RECAMARA KS- PIEL 0806 ACERO.	PT
valida	3707-07-P0814	ZURDA -RECAMARA KS- PIEL 0814 CAPUCHINO.	PT



*/