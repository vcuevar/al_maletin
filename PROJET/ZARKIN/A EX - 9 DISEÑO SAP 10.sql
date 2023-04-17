-- Concentrado de Excepciones DEL AREA DE DISEÑO.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Viernes 28 de Diciembre del 2018; Origen.
-- Actualizado: ;  Integrar Excepcion de
-- Actualizado: Lunes 26 de Julio del 2021; SAP-10.

-- ================================================================================================
-- |              Cabecera de la de Lista de Materiales.                                          |
-- ================================================================================================

-- LDM DIFERENTE 'P' produccion para articulos inventariables.
	SELECT '005 LDM P NO AUTORIZADAS' AS REPORTE_005
		, OITT.Code AS CODIGO
		, A3.ItemName AS DESCRIPCION
		, A3.InvntryUom AS UDM
		, A3.U_TipoMat AS TIPO
		,OITT.TreeType AS TYP
	FROM OITT 
	inner join OITM A3 on OITT.Code = A3.ItemCode
	WHERE OITT.TreeType <> 'P' and A3.InvntItem = 'Y'
	ORDER BY A3.ItemName			

-- LDM DIFERENTE 'S' ventas para articulos de Ventas (No Inventariables).
	SELECT '010 LDM S NO AUTORIZADAS' AS REPORTE_010
		, OITT.Code AS CODIGO
		, A3.ItemName AS DESCRIPCION
		, A3.InvntryUom AS UDM
		, A3.U_TipoMat AS TIPO
		, OITT.TreeType AS TYP
	FROM OITT 
	inner join OITM A3 on OITT.Code = A3.ItemCode
	WHERE OITT.TreeType <> 'S' and A3.InvntItem = 'N'
	ORDER BY A3.ItemName			

-- TAMAÑO PRODUCCION SIEMPRE DEBE SER 1.00, NO MANEJAMOS LOTES DE PRODUCCION.
	SELECT '015 TAMAÑO PROM. 1' AS REPORTE_015
		, OITT.Code AS CODIGO
		, A3.ItemName AS DESCRIPCION
		, A3.InvntryUom AS UDM
		, A3.U_TipoMat AS TIPO
		, OITT.PlAvgSize AS CANT
	FROM OITT 
	inner join OITM A3 on OITT.Code = A3.ItemCode
	WHERE OITT.PlAvgSize <> 1
	ORDER BY A3.ItemName	

-- ALMACEN SE DEFINE POR EL DEFAL DEL ARTICULO, SI HAY DIFERENCIAS VALIDAR.
-- Hay materiales que tienen LDM pero se compra actualmente, esos estan integrados en el where
-- y llevan en la descripcion la palabra COMPRAR.
	SELECT '020 ALMACEN ENTREGA' AS REPORTE_020
		, OITT.Code AS CODIGO
		, A3.ItemName AS DESCRIPCION
		, A3.InvntryUom AS UDM
		, A3.U_TipoMat AS TIPO
		, OITT.ToWH AS DFL_LDM
		, A3.DfltWH AS DFL_ART
	FROM OITT 
	inner join OITM A3 on OITT.Code = A3.ItemCode
	WHERE OITT.ToWH <> A3.DfltWH and A3.U_GrupoPlanea <> '6'
	and OITT.Code <> '19472' and OITT.Code <> '19742' and OITT.Code <> '19743' and OITT.Code <> '17896'
	and OITT.Code <> '18877' and OITT.Code <> '19765' and OITT.Code <> '19786' and OITT.Code <> '19789'
	and OITT.Code <> '10436' and OITT.Code <> '19738' and OITT.Code <> '19016' and OITT.Code <> '19015'
	and OITT.Code <> '18988' and OITT.Code <> '18990' and OITT.Code <> '19993' and OITT.Code <> '18894'
	and OITT.Code <> '18559' and OITT.Code <> '18874' and OITT.Code <> '20414' and OITT.Code <> '20415'
	ORDER BY A3.ItemName	

-- LA LISTA DE PRECIOS PARA EL CALCULO ES LA DE 00 CALCULO DISEÑO.
	SELECT '025 LP_00 CAL-DIS.' AS REPORTE_025
		, OITT.Code AS CODIGO
		, A3.ItemName AS DESCRIPCION
		, A3.InvntryUom AS UDM
		, A3.U_TipoMat AS TIPO
		, OITT.PriceList
	FROM OITT 
	inner join OITM A3 on OITT.Code = A3.ItemCode
	WHERE OITT.PriceList <> 1 
	ORDER BY A3.ItemName	

-- ================================================================================================
-- |                    Lista de Materiales Detalles.                                             |
-- |                 ALMACEN DE CONSUMO DE LOS COMPONENTES.                                       |
-- ================================================================================================
	
-- ALMACEN DE CONSUMO DE LOS COMPONENTES DEL ARTICULO CASCO APG-ST.
	SELECT '035 CASCO, ALMACEN <> APG-ST' AS REPORTE_035
		, A3.ItemCode AS CODE
		, A3.ItemName AS MODELO
		, A1.ItemCode AS CODIGO
		, A1.ItemName AS DESCRIPCION
		, ITT1.Warehouse AS ALMACEN
	FROM ITT1
	INNER JOIN OITM A3 on ITT1.Father = A3.ItemCode and A3.QryGroup29 = 'Y'
	INNER JOIN OITM A1 on ITT1.Code=A1.ItemCode
	WHERE ITT1.Warehouse <> 'APG-ST'  

-- ALMACEN DE CONSUMO DE LOS COMPONENTES DEL ARTICULO HABILITADOS APG-ST.
	SELECT '040 HABILITADOS, ALMACEN <> APG-ST' AS REPORTE_040
		, A3.ItemCode AS CODE
		, A3.ItemName AS MODELO
		, A1.ItemCode AS CODIGO
		, A1.ItemName AS DESCRIPCION
		, ITT1.Warehouse AS ALMACEN
	FROM ITT1
	INNER JOIN OITM A3 on ITT1.Father = A3.ItemCode and A3.QryGroup30 = 'Y'
	INNER JOIN OITM A1 on ITT1.Code=A1.ItemCode
	WHERE ITT1.Warehouse <> 'APG-ST'  

-- ALMACEN DE CONSUMO DE LOS COMPONENTES DEL ARTICULO PATAS Y BASTIDORES APG-ST.
	SELECT '045 PATAS, ALMACEN <> APG-ST' AS REPORTE_045
		, A3.ItemCode AS CODE
		, A3.ItemName AS MODELO
		, A1.ItemCode AS CODIGO
		, A1.ItemName AS DESCRIPCION
		, ITT1.Warehouse AS ALMACEN
	FROM ITT1
	INNER JOIN OITM A3 on ITT1.Father = A3.ItemCode and A3.QryGroup31 = 'Y'
	INNER JOIN OITM A1 on ITT1.Code=A1.ItemCode
	WHERE ITT1.Warehouse <> 'APG-ST'  

-- ALMACEN DE CONSUMO DE LOS COMPONENTES DEL ARTICULO SUBENSAMBLES EMPAQUE MADERA APG-ST.
	SELECT '050 PATAS, ALMACEN <> APG-ST' AS REPORTE_050
		, A3.ItemCode AS CODE
		, A3.ItemName AS MODELO
		, A1.ItemCode AS CODIGO
		, A1.ItemName AS DESCRIPCION
		, ITT1.Warehouse AS ALMACEN
	FROM ITT1
	INNER JOIN OITM A3 on ITT1.Father = A3.ItemCode and A3.QryGroup32 = 'Y'
	INNER JOIN OITM A1 on ITT1.Code=A1.ItemCode
	WHERE ITT1.Warehouse <> 'APG-ST' and A3.U_GrupoPlanea = '28'

-- ALMACEN DE CONSUMO DE LOS COMPONENTES DEL ARTICULO SUBENSAMBLES HERRAJES AMP-ST.
	SELECT '055 HERRAJES, ALMACEN <> AMP-ST' AS REPORTE_055
		, A3.ItemCode AS CODE
		, A3.ItemName AS MODELO
		, A1.ItemCode AS CODIGO
		, A1.ItemName AS DESCRIPCION
		, ITT1.Warehouse AS ALMACEN
	FROM ITT1
	INNER JOIN OITM A3 on ITT1.Father = A3.ItemCode and A3.QryGroup32 = 'Y'
	INNER JOIN OITM A1 on ITT1.Code=A1.ItemCode
	WHERE ITT1.Warehouse <> 'AMP-ST' and A3.U_GrupoPlanea = '5'

			
-- VER-160414 VALIDAR ALMACEN DE BASE OITT CABECERA DE LISTA DE MATERIALES CASCO. 
	Select '120 ? ALM. DFL CABECERA LMD' AS REPORTE, OITT.Code, A3.ItemName, A3.U_TipoMat, OITT.ToWH
	from OITT 
	inner join OITM A3 on OITT.Code = A3.ItemCode 
	where A3.QryGroup29='Y' and OITT.TOWH <>'APT-PA'
	ORDER BY A3.ItemName
		
	-- VALIDAR ALMACEN DE BASE OITT CABECERA DE LDM HABILITADOS. 
	Select '200 ! DFL CAB. LMD 30.' AS REPORTE, OITT.Code, A3.ItemName, A3.U_TipoMat, OITT.ToWH
	from OITT 
	inner join OITM A3 on OITT.Code = A3.ItemCode 
	where A3.QryGroup30='Y' and OITT.TOWH <> 'APG-ST' and A3.frozenFor = 'N'
	ORDER BY A3.ItemName

-- VC-160414 Validar que los HABILITADOS DE CASCOS (ESTRUCTURA) consuman del Almacen APT-PA y estan en Propiedad 30 */
	Select '205 ! LDM HABIL. CONSUMA APG-ST' AS REPORTE, ITT1.Father, A3.ItemName, A3.U_TipoMat, ITT1.Code,A1.ItemName,ITT1.Warehouse
	from ITT1 
	inner join OITM A3 on A3.ItemCode=ITT1.Father
	inner join OITM A1 on A1.ItemCode=ITT1.Code
	where A3.QryGroup30='Y' and ITT1.warehouse <> 'APG-ST' and A3.frozenFor = 'N' 
	ORDER BY A3.ItemName

-- VALIDAR QUE TENGA LISTA DE MATERIALES LOS CASCOS PROP-29 
	Select '210 CASCO SIN LDM' AS REPORTE_210
		, A3.ItemCode AS CODIGO
		, A3.ItemName AS DESCRIPCION
		, A3.U_TipoMat AS TIPO
		, A3.OnHand AS EXISTENCIA
	from OITM A3
	left join ITT1 on A3.ItemCode = ITT1.Father    
	where A3.QryGroup29='Y' and ITT1.Father is null
	and A3.OnHand > 0 and A3.frozenFor = 'N'
	and A3.U_Linea = '01'
	ORDER BY A3.ItemName	

-- VALIDAR QUE TENGA LISTA DE MATERIALES LAS PATAS Y BASTIDORES PROP-31 
-- Las que no tengan LDM en SAP 8 pasar a MP comprada.
	Select '215 PATAS SIN LDM' AS REPORTE_215
		, A3.ItemCode AS CODIGO
		, A3.ItemName AS DESCRIPCION
		, A3.U_TipoMat AS TIPO
		, A3.OnHand AS EXISTENCIA
	from OITM A3
	left join ITT1 on A3.ItemCode = ITT1.Father    
	where A3.QryGroup31='Y' and ITT1.Father is null
	and A3.OnHand > 0 and A3.frozenFor = 'N'
	and A3.U_Linea = '01'
	ORDER BY A3.ItemName	


-- VALIDAR QUE TENGA LISTA DE MATERIALES LOS SUBENSAMBLES PROP-32 
	Select '220 SUB-ENSAMBLES SIN LDM' AS REPORTE_220
		, A3.ItemCode AS CODIGO
		, A3.ItemName AS DESCRIPCION
		, A3.U_TipoMat AS TIPO
		, A3.OnHand AS EXISTENCIA
	from OITM A3
	left join ITT1 on A3.ItemCode = ITT1.Father    
	where A3.QryGroup32='Y' and ITT1.Father is null and A3.frozenFor = 'N'
	and A3.U_Linea = '01'
	ORDER BY A3.ItemName


-- VALIDAR QUE TENGA LISTA DE MATERIALES LOS PRODUCTO TERMINADO 
	Select '225 PT SIN LDM' AS REPORTE_225
		, A3.ItemCode AS CODIGO
		, A3.ItemName AS DESCRIPCION
		, A3.U_TipoMat AS TIPO
		, A3.OnHand AS EXISTENCIA
	from OITM A3
	left join ITT1 on A3.ItemCode = ITT1.Father    
	where A3.U_TipoMat = 'PT' and ITT1.Father is null
	and A3.U_Linea = '01' and A3.U_IsModel = 'N' and A3.frozenFor = 'N'
	and A3.OnHand > 0
	--and A3.OnOrder > 0
	ORDER BY A3.ItemName



	-- VALIDAR ALMACEN DE BASE OITT CABECERA DE LDM PT. 
	Select '410 ! DFL CAB. LMD PT.' AS REPORTE, OITT.Code, A3.ItemName, A3.U_TipoMat, OITT.ToWH
	from OITT 
	inner join OITM A3 on OITT.Code = A3.ItemCode 
	where U_TipoMat = 'PT' and OITT.TOWH <> 'APT-ST'
	ORDER BY A3.ItemName



-- Validar que los PT (ESTRUCTURA) CONSUMAN DEL APT-ST (KIT VENTAS)
	Select '420 ! LDM PT. CONSUMA APT-ST' AS REPORTE, ITT1.Father, A3.ItemName, A3.U_TipoMat, ITT1.Code,A1.ItemName,ITT1.Warehouse
	from ITT1 
	inner join OITM A3 on A3.ItemCode=ITT1.Father
	inner join OITM A1 on A1.ItemCode=ITT1.Code
	where A3.U_TipoMat = 'PT' and ITT1.warehouse <> 'APT-ST' 
	and A1.ItmsGrpCod <> '113' and A3.InvntItem = 'N'
	ORDER BY A3.ItemName
	
	
-- Estructura de consumen el material del AMP-ST
	select '455 CONS. AMP-ST->APP-ST' AS REPORTE, ITT1.Father, A3.ItemName, ITT1.Code, A1.ItemName, ITT1.Warehouse
	from ITT1 
	inner join OITM A3 on ITT1.Father=A3.ItemCode
	inner join OITM A1 on ITT1.Code=A1.ItemCode
	Where ITT1.Warehouse = 'AMP-ST' and A1.ItmsGrpCod <> '113' and A1.U_GrupoPlanea <> '6' 
	and ITT1.Father <> '17621' and ITT1.Father <> '19646' and ITT1.Father <> '20348' and ITT1.Father <> '20363' and ITT1.Father <> '20289'
	and ITT1.Father <> '17620' and ITT1.Father <> '17691' and ITT1.Father <> '17701' and ITT1.Father <> '19052' and ITT1.Father <> '20290' 
	and ITT1.Father <> '17822' and ITT1.Father <> '17814'  and ITT1.Father <> '18292' and ITT1.Father <> '18939'  and ITT1.Father <> '19053'  
	and ITT1.Father <> '18288' and ITT1.Father <> '18262' and ITT1.Father <> '18627' and ITT1.Father <> '19057' and ITT1.Father <> '19057'
	and ITT1.Father <> '18626' and ITT1.Father <> '18696' and ITT1.Father <> '18559' and ITT1.Father <> '18943' and ITT1.Father <> '19053'  
	and ITT1.Father <> '18761' and ITT1.Father <> '10436' and ITT1.Father <> '19416' and ITT1.Father <> '18939'  and ITT1.Father <> '19430'  
	and ITT1.Father <> '19415' and ITT1.Father <> '20357' and ITT1.Father <> '20358' and ITT1.Father <> '20414' and ITT1.Father <> '20415'
	Order by A3.ItemName	
	
	
	
	/*
	-- VALIDAR ALMACEN DE BASE OITT CABECERA DE LDM PT. 
	Select '795 ! DFL CAB. LMD CINTILLO.' AS REPORTE, OITT.Code, A3.ItemName, A3.U_TipoMat, OITT.ToWH
	from OITT 
	inner join OITM A3 on OITT.Code = A3.ItemCode 
	where ItemCode = '3778-42-P0201' and OITT.TOWH <> 'APG-ST'
	ORDER BY A3.ItemName
	*/



-- VER-190802 VALIDAR LISTA DE MATERIALES DE COMPLEMENTOS 32 CONSUMAN SUS MATERIALES DEL ALMACEN
-- DEL APG-ST, SOLO CINTILLOS.
	Select '855 ! LDM COMPL. CONSUME APG-ST' AS REPORTE, ITT1.Father, A3.ItemName, A3.U_TipoMat, A3.DfltWH, ITT1.Code, A1.ItemName, A1.U_TipoMat, ITT1.Warehouse
	from ITT1 
	inner join OITM A3 on ITT1.Father = A3.ItemCode
	inner join OITM A1 on ITT1.Code=A1.ItemCode  
	where A3.QryGroup32='Y' and A3.Itemname like '%CINTILL%' 
	and (ITT1.Warehouse <> 'APG-ST' or  ITT1.Warehouse is null) and A1.ItmsGrpCod <> '113'
	ORDER BY A3.ItemName

	-- Configuración Grupo de Articulos MATERIAS PRIMAS W PT POR C  Lista de Materiales
	SELECT distinct(T1.[ItemCode]),'165 ? CLASE ART. MP' AS REPORTE, T1.[ItemName], T2.[ItmsGrpNam], T1.[GLMethod]
	FROM ITT1 T0
	INNER JOIN OITM T1 ON T0.Code = T1.ItemCode
	INNER JOIN OITB T2 ON T1.ItmsGrpCod = T2.ItmsGrpCod 
	WHERE T1.U_TipoMat <> 'PT' and T1.[GLMethod] <> 'W' and ItemCode <> '10121'
	
	-- Configuración Grupo de Articulos MATERIAS PRIMAS W PT POR C Lista de Materiales
	SELECT distinct(T1.[ItemCode]),'170 ? CLASE ART. PT' AS REPORTE,  T1.[ItemName], T2.[ItmsGrpNam], T1.[GLMethod]
	FROM ITT1 T0
	INNER JOIN OITM T1 ON T0.Code = T1.ItemCode
	INNER JOIN OITB T2 ON T1.ItmsGrpCod = T2.ItmsGrpCod 
	WHERE T1.U_TipoMat = 'PT' and T1.[GLMethod] <> 'W'


-- ================================================================================================
-- |                 VALIDAR QUE TENGAN CUOTAS Y SEAN LAS CANTIDADES CORRECTAS.                   |
-- ================================================================================================

-- ARTICULOS PT QUE CONTIENEN CODIGOS 11000 Y SU CANTIDAD NO ES IGUAL AL VS.
	SELECT '860 PT <> 11000' AS REPORTE_860
		, ITT1.Father AS CODE
		, A3.ItemName AS MODELO
		, ITT1.Code AS CODIGO
		, Cast(ITT1.Quantity as decimal(16,2)) AS CANTIDAD
		, Cast(A3.U_VS as decimal(16,2)) AS VS
	FROM ITT1
	INNER JOIN OITM A3 on ITT1.Father = A3.ItemCode and A3.U_TipoMat = 'PT'
	WHERE ITT1.Code = '11000'  AND Cast(ITT1.Quantity as decimal(16,2)) <>  Cast(A3.U_VS as decimal(16,2))

-- ARTICULOS PT QUE CONTIENEN CODIGOS 11001 Y SU CANTIDAD NO ES IGUAL AL VS.
	SELECT '185 PT <> 11001' AS REPORTE_185
		, ITT1.Father AS CODE
		, A3.ItemName AS MODELO
		, ITT1.Code AS CODIGO
		, Cast(ITT1.Quantity as decimal(16,2)) AS CANTIDAD
		, Cast(A3.U_VS as decimal(16,2)) AS VS
	FROM ITT1
	INNER JOIN OITM A3 on ITT1.Father = A3.ItemCode and A3.U_TipoMat = 'PT'
	WHERE ITT1.Code = '11001' AND Cast(ITT1.Quantity as decimal(16,2)) <>  Cast(A3.U_VS as decimal(16,2))

-- ARTICULOS ESTRUCTURA QUE CONTIENEN CODIGOS 11000 Y SU CANTIDAD NO ES IGUAL AL VS.
-- aqui tengo que ver como ver que ldm no tienen 11000 o 11001
	SELECT '900 PT <> 11000' AS REPORTE_900
		, ITT1.Father AS CODE
		, A3.ItemName AS MODELO
		, ITT1.Code AS CODIGO
		, ITT1.Quantity AS CANTIDAD
		, A3.U_VS AS VS
	FROM ITT1
	INNER JOIN OITM A3 on ITT1.Father = A3.ItemCode and A3.ItemCode like '%ESTRU%'
	WHERE ITT1.Code = '11000' AND ITT1.Quantity <>  A3.U_VS

-- ARTICULOS ESTRUCTURA QUE CONTIENEN CODIGOS 11001 Y SU CANTIDAD NO ES IGUAL AL VS.
	SELECT '901 PT <> 11001' AS REPORTE_901
		, ITT1.Father AS CODE
		, A3.ItemName AS MODELO
		, ITT1.Code AS CODIGO
		, ITT1.Quantity AS CANTIDAD
		, A3.U_VS AS VS
	FROM ITT1
	INNER JOIN OITM A3 on ITT1.Father = A3.ItemCode and A3.ItemCode like '%ESTRU%'
	WHERE ITT1.Code = '11001' AND ITT1.Quantity <>  A3.U_VS


-- ARTICULOS PT QUE NO CONTIENEN CODIGOS 11000 PARA ASIGNAR.
-- Se quita ya esta activado SIMULADOR y que de ahy controle Diseño, adsemas que pidio diseño que 
-- ya no les ayude.
/*
	SELECT '902 PT SIN 11000 tempo quitar' AS REPORTE_902
		, OITT.Code AS CODE
		, Cast(A3.U_VS as decimal(16,2)) AS VS
		, A3.ItemName AS MODELO
		, ITT1.Code AS CODIGO
	FROM OITT
	INNER JOIN OITM A3 on OITT.Code = A3.ItemCode and A3.U_TipoMat = 'PT'
	LEFT JOIN ITT1 on OITT.Code = ITT1.Father and (ITT1.Code= '11000' or ITT1.Code like '%-EST%')
	WHERE  ITT1.Code is null and A3.InvntItem = 'Y'
	and A3.ItemCode like '%P0301%'
	ORDER BY OITT.Code DESC
*/

-- ARTICULOS ESTRUCTURA QUE NO CONTIENEN CODIGOS 11000 PARA ASIGNAR.
		SELECT '904 ESTR SIN 11000' AS REPORTE_904
		, OITT.Code AS CODE
		, A3.U_VS AS VS
		, A3.ItemName AS MODELO
		, ITT1.Code AS CODIGO
	FROM OITT
	INNER JOIN OITM A3 on OITT.Code = A3.ItemCode and A3.ItemCode like '%-EST%'
	LEFT JOIN ITT1 on OITT.Code = ITT1.Father and ITT1.Code= '11000'
	WHERE  ITT1.Code is null and A3.InvntItem = 'Y'
	ORDER BY OITT.Code DESC

-- ARTICULOS PT QUE NO CONTIENEN CODIGOS 11001 PARA ASIGNAR.
		SELECT '906 ESTR SIN 11000' AS REPORTE_906
		, OITT.Code AS CODE
		, A3.U_VS AS VS
		, A3.ItemName AS MODELO
		, ITT1.Code AS CODIGO
	FROM OITT
	INNER JOIN OITM A3 on OITT.Code = A3.ItemCode and A3.ItemCode like '%-EST%'
	LEFT JOIN ITT1 on OITT.Code = ITT1.Father and ITT1.Code= '11001'
	WHERE  ITT1.Code is null and A3.InvntItem = 'Y'
	ORDER BY OITT.Code DESC


-- ARTICULOS ESTRUCTURA QUE NO CONTIENEN CODIGOS 11000 PARA ASIGNAR.
		SELECT '908 ESTR SIN 11000' AS REPORTE_908
		, OITT.Code AS CODE
		, A3.U_VS AS VS
		, A3.ItemName AS MODELO
		, ITT1.Code AS CODIGO
	FROM OITT
	INNER JOIN OITM A3 on OITT.Code = A3.ItemCode and A3.ItemCode like '%-EST%'
	LEFT JOIN ITT1 on OITT.Code = ITT1.Father and ITT1.Code= '11001'
	WHERE  ITT1.Code is null and A3.InvntItem = 'Y'
	ORDER BY OITT.Code DESC


-- ================================================================================================
-- |                    Lista de Materiales Detalles.                                             |
-- |                 ALMACEN DE CONSUMO DE LOS COMPONENTES.                                       |
-- ================================================================================================
	
-- ARTICULOS QUE NO TIENEN COMPLEMENTO, NOUSAR
	SELECT '909 COMPLEMENTO NOUSA' AS REPORTE_909
		, OITM.ItemCode AS CODIGO
		, OITM.ItemName AS DESCRIPCION
		, OITM.U_CodAnt as COMPLEMENTO
	FROM OITM
	WHERE OITM.U_CodAnt <> 'NOUSA' AND OITM.U_GrupoPlanea <> 6 

	/*
	UPDATE OITM SET U_CodAnt = 'NOUSA' WHERE OITM.U_CodAnt <> 'NOUSA' AND OITM.U_GrupoPlanea <> 6 
	*/

-- ================================================================================================
-- |                    ARTICULOS COMO SP Y DEBEN SER MP.                                         |
-- |                        CASO DE LOS HULES ESPUMAS.                                            |
-- ================================================================================================
	
-- ARTICULOS QUE ESTAN COMO SP DE HULE ESPUMA.
	SELECT '910 HULE COMO SP' AS REPORTE_910
		, OITM.ItemCode AS CODIGO
		, OITM.ItemName AS NOMBRE
		, OITM.InvntryUom AS UDM
		, OITM.U_TipoMat AS TIPO
	FROM OITM
	WHERE OITM.U_TipoMat <> 'MP' AND OITM.U_GrupoPlanea = 6 














--< EOF > EXCEPCIONES PARA DISEÑO LDM.