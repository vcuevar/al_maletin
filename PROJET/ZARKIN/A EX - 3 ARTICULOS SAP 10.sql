-- Reporte de EXCEPCIONES PARA ARTICULOS
-- Elaborado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Jueves 06 de Mayo del 2021.
-- Actualizado: Viernes 23 de Julio del 2021; SAP 10.

-- ================================================================================================
-- |               PARAMETROS GENERALES PARA EXCEPCIONES.                                         |
-- ================================================================================================
Declare @FechaCrea nvarchar(30)
Declare @FechaInac nvarchar(30)
Declare @FechaIS nvarchar(30)

-- Fecha Creacion Nuevos Articulos aaaa/mm/dd
Set @FechaCrea = CONVERT (DATE, '2023/01/23', 102)
--Set @FechaCrea = '2022/03/30'
-- Fecha de Inactivos Modificacion. aaaa/mm/dd
Set @FechaInac =  CONVERT (DATE, '2023/12/01', 102)

-- Fecha 3 meses atras para enviar a Obsoletos aaa/dd/mm
Set @FechaIS = (SELECT DATEADD(MM, -5, GETDATE()))

-- ================================================================================================
-- |               DATOS MAESTROS DE ARTICULO CABECERA.                                           |
-- ================================================================================================

-- Nombre Extranjero uasa como agrupador de Modelo + Composicion en los PT
/*
	Select '005 NOMBRE AGRUPADOR PT' AS REPORTE_005
		, OITM.ItemCode AS CODE
		, OITM.ItemName AS NOMBRE
		, OITM.FrgnName AS AGRUPADOR
	From OITM
	Where OITM.U_TipoMat = 'PT' AND  (OITM.FrgnName IS NULL OR OITM.FrgnName = '') AND OITM.U_IsModel = 'N'
	AND U_Linea = '01' AND OITM.InvntItem = 'Y' and OITM.frozenFor = 'N'
	ORDER BY OITM.ItemName
*/

-- Estaba en SAP si se vuelve a presentar pasar a  las Alarmas.
SELECT T0.[ItemCode] AS 'Número de artículo', T0.[ItemName] AS 'Descripción del artículo', T0.[InvntryUom] AS 'Unidad de medida de inventario', T0.[ByWh] AS 'Gestión de stocks por almacén' FROM  [dbo].[OITM] T0  WHERE T0.[ByWh] = ('N' ) and T0.[OnHand] > 0 and T0.[U_TipoMat] = 'MP' 
Order By T0.[ItemCode]

SELECT T0.[DocEntry], T0.[ItemCode], T1.[ItemName], T1.[InvntryUom]
From OWOR T0
Inner Join OITM T1 on T0.[ItemCode] = T1.[ItemCode]
Where T1.[U_TipoMat] = 'CA' and T0.[Status] <> 'C' and T0.[Status] <> 'L' and T0.[Warehouse] <> 'APT-PA'

-- ================================================================================================
-- |               PESTAÑA DATOS DE INVENTARIOS.                                                  |
-- ================================================================================================

-- Existencias Negativas en algun almacen (error que en ocasiones genera el sistema de control de piso).
-- se corrige trasladando existencia a dicho almacen con existencia negativa.
	Select '005 EXISTENCIAS NEGATIVAS' AS REPORTE_005, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITW.OnHand, OITW.WhsCode
	from OITM
	inner join OITW on OITM.ItemCode=OITW.ItemCode 
	Where OITW.OnHand < 0

--Catalogo de Articulos con Metodo de valoracion diferente a Estandar. 
--para EvalSystem S = Estandar A = Promedio Ponderado. (Al cambio de SAP 10 dejaron estos en ponderados)	
	Select '007 ? MATERIALES DIF STD' AS REPORTE_007, OITM.ItemCode as Codigo, OITM.ItemName as Nombre,
	OITM.AvgPrice as Costo, OITM.OnHand as Existencia, OITM.EvalSystem
	from OITM 
	where OITM.EvalSystem <> 'S' and OITM.ItemCode <> '19076' and OITM.ItemCode <> '19091'
	and OITM.ItemCode <> '3831-58-L0001' and OITM.ItemCode <> '19107'
	and OITM.ItemCode <> '19089' and OITM.ItemCode <> '19755' and OITM.ItemCode <> '19756'
	and OITM.ItemCode <> '19757' and OITM.ItemCode <> '19111' and OITM.ItemCode <> '19092'
	and OITM.ItemCode <> '19090' and OITM.ItemCode <> '19108' and OITM.ItemCode <> '19833'
	and OITM.ItemCode <> '19110' and OITM.ItemCode <> '19822' and OITM.ItemCode <> '19112'
	Order by OITM.ItemName

-- Articulos con Metodo Promedio Ponderado, hay 16 con este error.
	Select '010 ARTICULO METODO NO ESTANDAR' AS REPORTE_10
		, OITM.ItemCode AS CODE
		, OITM.ItemName AS NOMBRE
		, OITM.U_TipoMat AS TMAT
		, OITM.AvgPrice AS COSTO
	From OITM
	Where OITM.EvalSystem <> 'S' and OITM.ItemCode <> '19076' and OITM.ItemCode <> '19089'
	and OITM.ItemCode <> '19090' and OITM.ItemCode <> '19091' and OITM.ItemCode <> '19092'
	and OITM.ItemCode <> '19107' and OITM.ItemCode <> '19108' and OITM.ItemCode <> '19110'
	and OITM.ItemCode <> '19111' and OITM.ItemCode <> '19112' and OITM.ItemCode <> '19755'
	and OITM.ItemCode <> '19756' and OITM.ItemCode <> '19757' and OITM.ItemCode <> '19822'
	and OITM.ItemCode <> '19833' and OITM.ItemCode <> '3831-58-L0001'

--Verificar que todos los articulos tengan un Lead time.
	Select '030 ? SIN LEAD TIME' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.LeadTime
	from OITM
	where LeadTime = 0  or LeadTime is null 
/*	
-- Ver los Nuevos articulos ingresados, Ajustar PRECIO ESTANDAR.
	Select '040 ART. NEW PREC-10' as REPORTE_040
		, OITM.ItemCode
		, OITM.ItemName
		, OITM.InvntryUom
		, OITM.U_TipoMat
		, LS.Price AS ESTANDAR
		, LD.Price AS COSTOS
		, Cast(OITM.CreateDate as date) AS FEC_CREA
		, OITM.OnHand
	from OITM 
	INNER JOIN ITM1 LS on OITM.ItemCode = LS.ItemCode and LS.PriceList=10 
	INNER JOIN ITM1 LD on OITM.ItemCode = LD.ItemCode and LD.PriceList=7
	where OITM.CreateDate > @FechaCrea and LS.Price <> LD.Price
	Order by OITM.CreateDate DESC
*/

-- Reporte de Excepciones, ver que los materiales enviados, realmente deban ser inactivo, 
-- no existir estructura que lo lleve y no tener existencia.
	select '045 ART. A INACTIVOS' as REPORTE_045
		, OITM.ItemCode AS CODIGO
		, OITM.ItemName AS DESCRIPCION
		, OITM.InvntryUom AS UDM
		, OITM.OnHand AS EXISTENCIA
		, OITM.frozenFor AS INACTIVO
		, Cast(OITM.frozenFrom as date) AS FECH_INACT
		, Cast(OITM.UpdateDate as date) AS FECH_CAMBIOI
		,OITM.FrozenComm AS NOTAS
	from OITM
	WHERE Cast(OITM.frozenFrom as date) > Cast(@FechaInac as date) and OITM.frozenFor='Y'
	--WHERE Cast(OITM.UpdateDate as date) > Cast(@FechaInac as date) and OITM.frozenFor='Y'
	Order by Cast(OITM.UpdateDate as date) DESC

-- Articulos con Factor en la pestaña compras.
	Select '050 ? CON FACTOR DE CANTIDAD' AS REPORTE_050
		, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.PurFactor1
	from OITM
	Where OITM.PurFactor1 <> 1

-- ================================================================================================
-- |               VENTANA DATOS DE USUARIO.                                                      |
-- ================================================================================================

-- Valor Sala Habilitado, Casco, Estructura y Empaque debe tener mismo valor.
	SELECT '070 <> VS HB' AS REPORTE_070
		, HB.CODIGO , HB.DESCRIPCION, HB.VS_ART, HB.VS_COM
	FROM (
	SELECT OITM.ItemCode AS CODIGO
		, OITM.ItemName AS DESCRIPCION
		, OITM.U_VS AS VS_ART
		, LEFT(OITM.ItemCode,4) + '-' + RIGHT(LEFT(OITM.ItemCode,6),2) AS COMPONENTE
		, (SELECT TOP (1) A3.U_VS FROM OITM A3 WHERE A3.ItemCode LIKE '%' + LEFT(OITM.ItemCode,4) + '-' + RIGHT(LEFT(OITM.ItemCode,6),2) + '%') AS VS_COM
	FROM OITM
	WHERE OITM.QryGroup30 = 'Y') HB 
	WHERE HB.VS_ART <> HB.VS_COM


-- Valor Sala Habilitado, Casco, Estructura y Empaque debe tener mismo valor.
	SELECT '075 <> VS CA' AS REPORTE_075
		, HB.CODIGO , HB.DESCRIPCION, HB.VS_ART, HB.VS_COM
	FROM (
	SELECT OITM.ItemCode AS CODIGO
		, OITM.ItemName AS DESCRIPCION
		, OITM.U_VS AS VS_ART
		, LEFT(OITM.ItemCode,4) + '-' + RIGHT(LEFT(OITM.ItemCode,6),2) AS COMPONENTE
		, (SELECT TOP (1) A3.U_VS FROM OITM A3 WHERE A3.ItemCode LIKE '%' + LEFT(OITM.ItemCode,4) + '-' + RIGHT(LEFT(OITM.ItemCode,6),2) + '%') AS VS_COM
	FROM OITM
	WHERE OITM.QryGroup29 = 'Y') HB 
	WHERE HB.VS_ART <> HB.VS_COM

-- Valor Sala Habilitado, Casco, Estructura y Empaque debe tener mismo valor.
	SELECT '080 <> VS ESTR' AS REPORTE_080
		, HB.CODIGO , HB.DESCRIPCION, HB.VS_ART, HB.VS_COM
	FROM (
	SELECT OITM.ItemCode AS CODIGO
		, OITM.ItemName AS DESCRIPCION
		, OITM.U_VS AS VS_ART
		, LEFT(OITM.ItemCode,4) + '-' + RIGHT(LEFT(OITM.ItemCode,6),2) AS COMPONENTE
		, (SELECT TOP (1) A3.U_VS FROM OITM A3 WHERE A3.ItemCode LIKE '%' + LEFT(OITM.ItemCode,4) + '-' + RIGHT(LEFT(OITM.ItemCode,6),2) + '%') AS VS_COM
	FROM OITM
	WHERE OITM.QryGroup32 = 'Y' AND OITM.ItemCode LIKE '%ESTRU%') HB 
	WHERE HB.VS_ART <> HB.VS_COM

-- Valor Sala Habilitado, Casco, Estructura y Empaque debe tener mismo valor.
	SELECT '085 <> VS ESTR' AS REPORTE_085
		, HB.CODIGO , HB.DESCRIPCION, HB.VS_ART, HB.VS_COM
	FROM (
	SELECT OITM.ItemCode AS CODIGO
		, OITM.ItemName AS DESCRIPCION
		, OITM.U_VS AS VS_ART
		, LEFT(OITM.ItemCode,4) + '-' + RIGHT(LEFT(OITM.ItemCode,6),2) AS COMPONENTE
		, (SELECT TOP (1) A3.U_VS FROM OITM A3 WHERE A3.ItemCode LIKE '%' + LEFT(OITM.ItemCode,4) + '-' + RIGHT(LEFT(OITM.ItemCode,6),2) + '%') AS VS_COM
	FROM OITM
	WHERE OITM.QryGroup29 = 'Y') HB 
	WHERE HB.VS_ART <> HB.VS_COM

-- Habilitado y Casco en Grupo "C".
	SELECT '090 GRUPO "C"' AS REPORTE_090
			, OITM.ItemCode AS CODIGO
			, OITM.ItemName AS DESCRIPCION
			, OITM.U_SubModelo AS CLASIFICACION
	FROM OITM
	WHERE (OITM.QryGroup29 = 'Y' OR OITM.QryGroup30 = 'Y')
	and  OITM.U_SubModelo <> 'C'
	   	  
	-- Corregir con Update
	-- update OITM set  OITM.U_SubModelo = 'C' WHERE (OITM.QryGroup29 = 'Y' OR OITM.QryGroup30 = 'Y') and  OITM.U_SubModelo <> 'C'

-- Articulo Fabricado con Comprador Asignado. Debe ser Planeacion.
	Select '065 COMPRADOR->PLANEA' AS REPORTE_065
		, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_Comprador
	From OITM
	Where (OITM.QryGroup29 = 'Y' or OITM.QryGroup30 = 'Y' or OITM.QryGroup31 = 'Y' or OITM.QryGroup32 = 'Y')
	and OITM.U_Comprador <> 'PL' and U_GrupoPlanea <> 6
	Order By OITM.[ItemName]

-- Articulo Con Activacion de Patas y Grupo diferente a Patas y Bastidores.
	Select '207 GRP. PLANEA->PATAS' AS REPORTE_207
		, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_Comprador
	From OITM
	Where OITM.QryGroup31 = 'Y' and OITM.U_GrupoPlanea <> '14'  
	Order By OITM.[ItemName]

-- Articulo Diferente MP con Comprador diferente a Planeacion.
	Select '075 COMPRA->ES PLANEA' AS REPORTE_075
		, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_Comprador
	From OITM
	Where OITM.U_TipoMat <> 'MP' and OITM.U_Comprador <> 'PL'  
	Order By OITM.[ItemName]

-- Articulo Diferente MP con Metodo diferente a JIT.
	Select '080 METODO->ES JIT' AS REPORTE_080
		, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_Metodo
	From OITM
	Where OITM.U_TipoMat <> 'MP' and OITM.U_Metodo <> 'JIT'  
	Order By OITM.[ItemName]

-- Articulo Igual a MP con Comprador asignado com Planeacion.
	Select '085 COMPRA->NO PLANEA' AS REPORTE_085
		, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_Comprador
	From OITM
	Where OITM.U_TipoMat = 'MP' and OITM.U_Comprador = 'PL'  
	Order By OITM.[ItemName]

-- Articulo Diferente MP con Metodo diferente a MRP.
	Select '089 METODO->NO ES JIT !' AS REPORTE_089
		, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_Metodo
	From OITM
	Where OITM.U_TipoMat = 'MP' and OITM.U_Metodo <> 'MRP'  
	Order By OITM.[ItemName]

	Update OITM Set OITM.U_Metodo = 'MRP'  Where OITM.U_TipoMat = 'MP' and OITM.U_Metodo <> 'MRP'

-- Obtener Determinacion del Almacen por defauld para PT => APT-ST.
	SELECT '095 DEFAULT PT <> APT-ST' AS REPORTE_095
		, T0.[ItemCode] AS 'Número de artículo'
		, T0.[ItemName] AS 'Descripción del artículo'
		, T0.[InvntryUom] AS 'Unidad de medida de inventario'
		, T0.[PurPackMsr] AS UDM_COMPRA
		, T0.[DfltWH] AS ALMACEN_DF
		, T0.[ByWh] AS 'Gestión de stocks por almacén' 
	FROM  [dbo].[OITM] T0  
	WHERE T0.[U_TipoMat] = 'PT' and T0.[DfltWH] <> 'APT-ST'
	Order By T0.[ItemCode]

-- Obtener Determinacion del Almacen por defauld para CA => APT-PA.
	SELECT '100 DEFAULT CA <> APT-PA' AS REPORTE_100
		, T0.[ItemCode] AS 'Número de artículo'
		, T0.[ItemName] AS 'Descripción del artículo'
		, T0.[InvntryUom] AS 'Unidad de medida de inventario'
		, T0.[PurPackMsr] AS UDM_COMPRA
		, T0.[DfltWH] AS ALMACEN_DF
		, T0.[ByWh] AS 'Gestión de stocks por almacén' 
	FROM  [dbo].[OITM] T0  
	WHERE T0.[U_TipoMat] = 'CA' and T0.[DfltWH] <> 'APT-PA' 
	Order By T0.[ItemCode]

-- Obtener Determinacion del Almacen por defauld para HB => APG-ST.
	SELECT '110 DEFAULT HB <> APG-ST' AS REPORTE_110
		, T0.[ItemCode] AS 'Número de artículo'
		, T0.[ItemName] AS 'Descripción del artículo'
		, T0.[InvntryUom] AS 'Unidad de medida de inventario'
		, T0.[PurPackMsr] AS UDM_COMPRA
		, T0.[DfltWH] AS ALMACEN_DF
		, T0.[ByWh] AS 'Gestión de stocks por almacén' 
	FROM  [dbo].[OITM] T0  
	WHERE T0.[U_TipoMat] = 'HB' and T0.[DfltWH] <> 'APG-ST' 
	Order By T0.[ItemCode]

-- Articulo Fijar Cuentas de Mayor Mediante Almacen (W).
	Select '115 CTA. MAYOR ALMACEN' AS REPORTE_115
		, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.GLMethod
	From OITM
	Where OITM.GLMethod <> 'W'   
	Order By OITM.[ItemName]

-- Obtener Determinacion del Almacen por defauld para MP => AMP-CC.
SELECT '176 DEFAULT MP <> AMP-CC' AS REPORTE, T0.[ItemCode] AS 'Número de artículo'
		, T0.[ItemName] AS 'Descripción del artículo'
		, T0.[InvntryUom] AS 'Unidad de medida de inventario'
		, T0.[PurPackMsr] AS UDM_COMPRA
		, T0.[DfltWH] AS ALMACEN_DF
		, T0.[ByWh] AS 'Gestión de stocks por almacén' 
FROM  [dbo].[OITM] T0  
WHERE T0.[U_TipoMat] = 'MP' and T0.[DfltWH] <> 'AMP-CC' and T0.frozenFor = 'N' and T0.U_GrupoPlanea <> '6'
Order By T0.[ItemCode]


-- Obtener Determinacion del Almacen por defauld para SP => APT-PA Patas y Bastidores.
SELECT '178 DEFAULT PATAS <> APT-PA' AS REPORTE, T0.[ItemCode] AS 'Número de artículo'
		, T0.[ItemName] AS 'Descripción del artículo'
		, T0.[InvntryUom] AS 'Unidad de medida de inventario'
		, T0.[PurPackMsr] AS UDM_COMPRA
		, T0.[DfltWH] AS ALMACEN_DF
		, T0.[ByWh] AS 'Gestión de stocks por almacén' 
FROM  [dbo].[OITM] T0  
WHERE T0.[U_TipoMat] = 'SP' and T0.[DfltWH] <> 'APT-PA' and T0.[QryGroup31] = 'Y'
--T0.[U_TipoMat] = 'SP' and T0.[DfltWH] <> 'APG-ST' and T0.[QryGroup32] = 'Y' -- SP que no estan en almacenes de Proceso.
Order By T0.[ItemCode]

-- Obtener Determinacion del Almacen por defauld para SP (32) EMPAQUE DE MADERA => APT-PA.
SELECT '180 ALM-DFT EMPAQ. MADERA' AS REPORTE_180
	, T0.[ItemCode] AS CODIGO
		, T0.[ItemName] AS DESCRIPCION
		, T0.[InvntryUom] AS UDM
		, T0.[DfltWH] AS ALMACEN_DF
		, T0.U_GrupoPlanea AS GRUPO
FROM  [dbo].[OITM] T0  
WHERE T0.[DfltWH] <> 'APT-PA' and T0.[QryGroup32] = 'Y' and T0.U_GrupoPlanea = '28'
Order By T0.[ItemName]

-- Obtener Determinacion del Almacen por defauld para SP (32) HERRAJES => AMP-CC.
SELECT '185 ALM-DFT HERR. ' AS REPORTE_185
	, T0.[ItemCode] AS CODIGO
		, T0.[ItemName] AS DESCRIPCION
		, T0.[InvntryUom] AS UDM
		, T0.[DfltWH] AS ALMACEN_DF
		, T0.U_GrupoPlanea AS GRUPO
FROM  [dbo].[OITM] T0  
WHERE T0.[DfltWH] <> 'AMP-CC' and T0.[QryGroup32] = 'Y' and T0.U_GrupoPlanea = '5'
Order By T0.[ItemName]

-- Obtener Determinacion del Almacen por defauld para SP (32) MAQUILAS => AMP-CC.
SELECT '185 ALM-DFT HERR. ' AS REPORTE_185
	, T0.[ItemCode] AS CODIGO
		, T0.[ItemName] AS DESCRIPCION
		, T0.[InvntryUom] AS UDM
		, T0.[DfltWH] AS ALMACEN_DF
		, T0.U_GrupoPlanea AS GRUPO
FROM  [dbo].[OITM] T0  
WHERE T0.[DfltWH] <> 'AMP-CC' and T0.[QryGroup32] = 'Y' and T0.U_GrupoPlanea = '26'
Order By T0.[ItemName]

-- Obtener Determinacion del Almacen por defauld para SP (32) VARIOS => APT-ST Grupo 13 Refacciones.
SELECT '190 ALM-DFT SB. ' AS REPORTE_190
	, T0.[ItemCode] AS CODIGO
		, T0.[ItemName] AS DESCRIPCION
		, T0.[InvntryUom] AS UDM
		, T0.[DfltWH] AS ALMACEN_DF
		, T0.U_GrupoPlanea AS GRUPO
FROM  [dbo].[OITM] T0  
WHERE T0.[DfltWH] <> 'APT-ST' and T0.[QryGroup32] = 'Y' and T0.U_GrupoPlanea = '13'
and T0.[ItemName] not like '%CINTI%'
Order By T0.[ItemName]

-- Obtener Determinacion del Almacen por defauld para SP (32) VARIOS => APG-ST Grupo Diferentes
-- a 5, 13, 26 y 28.
SELECT '195 ALM-DFT SB. ' AS REPORTE_195
	, T0.[ItemCode] AS CODIGO
		, T0.[ItemName] AS DESCRIPCION
		, T0.[InvntryUom] AS UDM
		, T0.[DfltWH] AS ALMACEN_DF
		, T0.U_GrupoPlanea AS GRUPO
FROM  [dbo].[OITM] T0  
WHERE T0.[DfltWH] <> 'APG-ST' and T0.[QryGroup32] = 'Y' and T0.U_GrupoPlanea <> '5' and T0.U_GrupoPlanea <> '6' 
and T0.U_GrupoPlanea <> '13' and T0.U_GrupoPlanea <> '26'and T0.U_GrupoPlanea <> '28'
Order By T0.[ItemName]

SELECT '196 ALM-DFT HE. ' AS REPORTE_196
	, T0.[ItemCode] AS CODIGO
		, T0.[ItemName] AS DESCRIPCION
		, T0.[InvntryUom] AS UDM
		, T0.[DfltWH] AS ALMACEN_DF
		, T0.U_GrupoPlanea AS GRUPO
FROM  [dbo].[OITM] T0  
WHERE T0.[DfltWH] <> 'AMP-ST' and T0.[QryGroup32] = 'Y' and T0.U_GrupoPlanea = '6' 
Order By T0.[ItemName]

-- Proveedor por Omision para lo que no es MP => P1586
SELECT '200 PROVEE <> P1586' AS REPORTE
		, T0.[ItemCode] AS CODIGO
		, T0.[ItemName] AS DESCRIPCION
		, T0.[InvntryUom] AS UDM
		, T0.[CardCode] AS PROVEEDOR
FROM  [dbo].[OITM] T0  
WHERE (T0.[CardCode] <> 'P1586' or T0.[CardCode] is null) and T0.[U_TipoMat] <> 'MP'
Order By T0.[ItemName]

-- Articulos que tiene activado Propiedad de Casco son tipo CA
Select '136 TIPO CASCO' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat 
From OITM
Where OITM.U_TipoMat <> 'CA' and QryGroup29 = 'Y' 

-- Articulos que tiene activado Propiedad de Habilitado y no son Tipo HB
Select '141 TIPO HABILITADO' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat 
From OITM
Where OITM.U_TipoMat <> 'HB' and QryGroup30 = 'Y' 

-- Articulos que tiene activado Propiedad de Patas y Bastidores y no son Tipo SP
Select '146 TIPO PATAS Y BASTIDORES' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat
From OITM
Where OITM.U_TipoMat <> 'SP' and QryGroup31 = 'Y' 

-- Articulos que tiene activado Propiedad de Complementos y no son Tipo SP
Select '151 TIPO COMPLEMENTOS' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat
From OITM
Where OITM.U_TipoMat <> 'SP' AND OITM.U_TipoMat <> 'RF'and QryGroup32 = 'Y' and U_GrupoPlanea <> 6

-- Articulo Grupo de Planeacion si es SP - EMPA -> Grupo Planeacion = 3 (EMPAQUE).
Select '155 GP_PLAN->EMPAQUE' AS REPORTE_155
		, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_GrupoPlanea
	From OITM
	Where OITM.QryGroup32 = 'Y' AND OITM.ItemCode like '%EMPA%' AND OITM.U_GrupoPlanea <> 3
	Order By OITM.[ItemName]

	-- Update OITM Set OITM.U_GrupoPlanea = 3 Where OITM.QryGroup32 = 'Y' AND OITM.ItemCode like '%EMPA%' AND OITM.U_GrupoPlanea <> 3

-- Articulo Grupo de Planeacion; si es SP - ESTR -> Grupo Planeacion = 4 (GENERAL).
Select '160 GP_PLAN->GENERAL' AS REPORTE_160
		, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.U_GrupoPlanea
	From OITM
	Where OITM.QryGroup32 = 'Y' AND OITM.ItemCode like '%ESTR%' AND OITM.U_GrupoPlanea <> 4
	Order By OITM.[ItemName]

	-- Update OITM Set OITM.U_GrupoPlanea = 4 Where OITM.QryGroup32 = 'Y' AND OITM.ItemCode like '%ESTR%' AND OITM.U_GrupoPlanea <> 4

-- Unidad de Compra vacia
SELECT '210 UDM COMP VACIAS' AS REPORTE
		, OITM.ItemCode AS CODIGO
		, OITM.ItemName AS DESCRIPCION
		, OITM.InvntryUom AS UDM
		, OITM.PurPackMsr AS UMC
		, OITM.PurPackUn AS CONV
		, OITM.SalPackMsr AS UMV
FROM  OITM  
WHERE OITM.PurPackMsr is null and OITM.PurPackUn = 1
Order By OITM.ItemName

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
		 
-- VER-160414 VALIDAR ALMACEN DE CASCOS SEA APT-PA 
	Select '100 ? ALM DFL CASCO' AS REPORTE, OITM.ItemCode, OITM.ItemName, 
	OITM.U_TipoMat, OITM.DfltWH
	from OITM 
	where OITM.QryGroup29='Y' and OITM.DfltWH <>'APT-PA'
	ORDER BY OITM.ItemName	
	
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
	and OITM.ItemName not like '%CASCO%' and OITM.ItemName not like '%BASE%' and OITM.ItemName not like '%ZOCLO%' 
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
	
-- VC-160414 Validar que los HABILITADOS DE CASCOS Almacen Defauld APG-ST y estan en Propiedad 30 
	Select '195 ? HABIL. ALM.DFL APG-ST' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat, OITM.DfltWH
	from OITM 
	where OITM.QryGroup30='Y' and OITM.DfltWH <> 'APG-ST'
	ORDER BY OITM.ItemName

-- Validar que los HABILITADOS DE CASCOS Tengan en su dato maestro Valor Sala, estan en Propiedad 30 
	Select '210 ? ART. HABIL ALM. S/VS' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat, OITM.DfltWH
	from OITM 
	where OITM.QryGroup30='Y' and OITM.U_VS = 0
	ORDER BY OITM.ItemName
	
-- ARTICULOS EN GENERAL
-- Catalogo de Materiales con Metodo Manual cuando debe ser Notificacion
	select '220 ? ERR, METODO EN MANUAL' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat, OITM.DfltWH, OITM.IssueMthd, OITM.ItmsGrpCod,
	OITM.U_estacion, OITM.PurPackMsr, OITM.NumInBuy, OITM.BuyUnitMsr
	from OITM 
	where IssueMthd='M' and ItmsGrpCod <> 113 and OITM.ItemCode  <> '13382' and OITM.U_GrupoPlanea <> '11' 
		
-- Catalogo de Piel debe tener Lotes*/
	select '225 ? PIEL SIN LOTES' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat, OITM.OnHand, OITM.DfltWH, OITM.IssueMthd, OITM.ItmsGrpCod,
	OITM.U_estacion, OITM.PurPackMsr, OITM.NumInBuy, OITM.BuyUnitMsr, OITM.ManBtchNum
	from OITM 
	where ItmsGrpCod = 113 and OITM.ManBtchNum = 'N'
	and OITM.ItemCode <> '70023' and OITM.ItemCode <> '70024' and OITM.ItemCode <> '70028' and OITM.ItemCode <> '70029'
	and OITM.ItemCode <> '70030' and OITM.ItemCode <> '70031' and OITM.ItemCode <> '70032' and OITM.ItemCode <> '70033'
	and OITM.ItemCode <> '70034' and OITM.ItemCode <> '70035' and OITM.ItemCode <> '70036' and OITM.ItemCode <> '70038'
	and OITM.ItemCode <> '70039' and OITM.ItemCode <> '70040' and OITM.ItemCode <> '70041' and OITM.ItemCode <> '70042'
	and OITM.ItemCode <> '70043' and OITM.ItemCode <> '70044' and OITM.ItemCode <> '70045' and OITM.ItemCode <> '70046'
	and OITM.ItemCode <> '70047' and OITM.ItemCode <> '70048' and OITM.ItemCode <> '70049' and OITM.ItemCode <> '70050'
	and OITM.ItemCode <> '70051' and OITM.ItemCode <> '70052' and OITM.ItemCode <> '70053' and OITM.ItemCode <> '70054'
	and OITM.ItemCode <> '70056' and OITM.ItemCode <> '70057' and OITM.ItemCode <> '70058' and OITM.ItemCode <> '70060'
	and OITM.ItemCode <> '70062' and OITM.ItemCode <> '70063' and OITM.ItemCode <> '70064' and OITM.ItemCode <> '70065'
	and OITM.ItemCode <> '70066' and OITM.ItemCode <> '70067' and OITM.ItemCode <> '70068' and OITM.ItemCode <> '70069'
	and OITM.ItemCode <> '70070' and OITM.ItemCode <> '70071' and OITM.ItemCode <> '70072' and OITM.ItemCode <> '70073'
	and OITM.ItemCode <> '70074' and OITM.ItemCode <> '70075' and OITM.ItemCode <> '70076' and OITM.ItemCode <> '70077'
	and OITM.ItemCode <> '70078' and OITM.ItemCode <> '70079' and OITM.ItemCode <> '70080' and OITM.ItemCode <> '70081'
	and OITM.ItemCode <> '70082' and OITM.ItemCode <> '70083' and OITM.ItemCode <> '70084' and OITM.ItemCode <> '70085'
	and OITM.ItemCode <> '70086' and OITM.ItemCode <> '70208'
	
-- Materiales que no se les asigno Linea (01 Linea, 05 Fuera de Linea, 10 Obsoleto)
--	Actualizar para que salga completo inventarios 
	select '230 ? ART. SIN LINEA' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat, OITM.DfltWH, OITM.ItmsGrpCod, OITM.U_estacion,
	OITM.PurPackMsr, OITM.NumInBuy, OITM.BuyUnitMsr from OITM 
	where U_Linea is null
		
-- ================================================================================================
-- |               ASIGNACION ARTICULOS A LINEA U OBSOLETOS.                                      |
-- ================================================================================================

-- Conceptos en el caso de los materiales la regla es que si no existe ese articulo en ninguna LDM
-- entonces el se pasa a OBSOLETO siempre y cuando no se trate de PIEL o TELA si es esto entonces
-- se pasa a FUERA DE LINEA.
-- Un concepto que se agrego en tiempos de Luis Morales fue que no se cambiara a menos que su ultima
-- compras haya sido hace 7 meses.
-- Se concidera tambien que el modelo que lo contiene no este obsoleto.

-- Materiales No Piel y No tela. Pasa a Obsoleto de Forma Automatica.
	SELECT '235 !! A OBS. 5 MES' AS REPO_235
	, OITM.ItemCode AS CODIGO
	, OITM.ItemName AS DESCRIPCION
	, Cast(@FechaIS as date) AS FEC_BASE
	, Cast(OITM.CreateDate as date) AS FEC_CREA
	, Cast(IsNull(OITM.LastPurDat, @FechaIS)  as date) AS FEC_COMP
	, ITT1.Code AS CODE
	, OITM.U_Linea AS LINEA
	FROM OITM 
	Left Join ITT1 on ITT1.Code = OITM.ItemCode
	WHERE ITT1.Code IS NULL and OITM.U_TipoMat <> 'PT' and OITM.U_Linea = '01'
	and OITM.U_GrupoPlanea <> '9' 	and OITM.U_GrupoPlanea <> '11'  
	and OITM.CreateDate < @FechaIS and IsNull(OITM.LastPurDat, @FechaIS) <= @FechaIS 
	ORDER BY OITM.ItemName

	Update OITM set OITM.U_Linea = '10'
	FROM OITM 
	Left Join ITT1 on ITT1.Code = OITM.ItemCode
	WHERE ITT1.Code IS NULL and OITM.U_TipoMat <> 'PT' and OITM.U_Linea = '01'
	and OITM.U_GrupoPlanea <> '9' 	and OITM.U_GrupoPlanea <> '11'  
	and OITM.CreateDate < @FechaIS and IsNull(OITM.LastPurDat, @FechaIS) <= @FechaIS 
	
-- Materiales Piel y Tela pasan a FUERA DE LINEA.
	SELECT '237 !! A F_LIN. 5 MES' AS REPO_235
	, OITM.ItemCode AS CODIGO
	, OITM.ItemName AS DESCRIPCION
	, Cast(@FechaIS as date) AS FEC_BASE
	, Cast(OITM.CreateDate as date) AS FEC_CREA
	, Cast(OITM.LastPurDat as date) AS FEC_COMP
	, ITT1.Code AS CODE
	, OITM.U_Linea AS LINEA
	FROM OITM 
	Left Join ITT1 on ITT1.Code = OITM.ItemCode
	WHERE ITT1.Code IS NULL and OITM.U_TipoMat <> 'PT' and OITM.U_Linea = '01'
	and (OITM.U_GrupoPlanea = '9' or OITM.U_GrupoPlanea = '11')  
	and OITM.CreateDate < @FechaIS and OITM.LastPurDat < @FechaIS 
	ORDER BY OITM.ItemName

	Update OITM set OITM.U_Linea = '05'
	FROM OITM 
	Left Join ITT1 on ITT1.Code = OITM.ItemCode
	WHERE ITT1.Code IS NULL and OITM.U_TipoMat <> 'PT' and OITM.U_Linea = '01'
	and (OITM.U_GrupoPlanea = '9' or OITM.U_GrupoPlanea = '11')  
	and OITM.CreateDate < @FechaIS and OITM.LastPurDat < @FechaIS 
	
-- Materiales que ESTA COMO OBSOLETO y se encuentra cargado en las Estructuras y estas esten de Linea.
	SELECT '240 !! REGRESAR A LINEA' AS REPO_240
	, OITM.ItemCode AS CODIGO
	, OITM.ItemName AS DESCRIPCION
	, Cast(OITM.CreateDate as date) AS FEC_CREA
	, Cast(OITM.LastPurDat as date) AS FEC_COMP
	, LDM.Code AS CODE
	, OITM.U_Linea AS LINEA
	FROM OITM 
	Left Join (Select Distinct LDM.Code from ITT1 LDM ) LDM on LDM.Code = OITM.ItemCode
	WHERE LDM.Code IS NOT NULL and OITM.U_TipoMat <> 'PT' and OITM.U_Linea <> '01'
	and OITM.U_GrupoPlanea <> '9' and OITM.U_GrupoPlanea <> '11'  
	ORDER BY OITM.ItemName

	Update OITM set OITM.U_Linea = '01'
	FROM OITM 
	Left Join (Select Distinct LDM.Code from ITT1 LDM ) LDM on LDM.Code = OITM.ItemCode
	WHERE LDM.Code IS NOT NULL and OITM.U_TipoMat <> 'PT' and OITM.U_Linea <> '01'
	and OITM.U_GrupoPlanea <> '9' and OITM.U_GrupoPlanea <> '11'  
	
-- PT se pasan a Obsoleto todos los codigo ZAR
SELECT '241 !! A OBS. PT ZAR' AS REPO_241
	, OITM.ItemCode AS CODIGO
	, OITM.ItemName AS DESCRIPCION
	, Cast(@FechaIS as date) AS FEC_BASE
	, Cast(OITM.CreateDate as date) AS FEC_CREA
	, Cast(OITM.LastPurDat as date) AS FEC_COMP
	, OITM.U_Linea AS LINEA
	FROM OITM 
	WHERE OITM.U_TipoMat = 'PT' and OITM.U_Linea = '01' and OITM.ItemCode like 'ZAR%'
	ORDER BY OITM.ItemName

	Update OITM set OITM.U_Linea = '10'
	FROM OITM 
	WHERE OITM.U_TipoMat = 'PT' and OITM.U_Linea = '01' and OITM.ItemCode like 'ZAR%'

-- PT Que su MODELO este OBSOLETO.
SELECT '242 !! A OBS. PT MOD-OBS' AS REPO_242
	, OITM.ItemCode AS CODIGO
	, OITM.ItemName AS DESCRIPCION
	, Cast(@FechaIS as date) AS FEC_BASE
	, Cast(OITM.CreateDate as date) AS FEC_CREA
	, Cast(OITM.LastPurDat as date) AS FEC_COMP
	, MD.MODEL AS MODELO
	, OITM.U_Linea AS LINEA
	FROM OITM 
	LEFT JOIN (Select A3.ItemCode AS MODEL From OITM A3 Where A3.U_IsModel = 'S' and A3.U_Linea = '01') 
	MD on MD.MODEL = SubString(OITM.ItemCode, 1, 4)
	WHERE OITM.U_TipoMat = 'PT' and OITM.U_IsModel = 'N' and OITM.U_Linea = '01' 
	and MD.MODEL is null
	ORDER BY OITM.ItemName

	Update OITM set OITM.U_Linea = '10'
	FROM OITM 
	LEFT JOIN (Select A3.ItemCode AS MODEL From OITM A3 Where A3.U_IsModel = 'S' and A3.U_Linea = '01') 
	MD on MD.MODEL = SubString(OITM.ItemCode, 1, 4)
	WHERE OITM.U_TipoMat = 'PT' and OITM.U_IsModel = 'N' and OITM.U_Linea = '01' 
	and MD.MODEL is null

-- Articulo poner en U_CodAnt 'NOUSA' a todos los NULL
SELECT '245 ART. ANT NULL' AS REPO_245
	, OITM.ItemCode AS CODIGO
	, OITM.ItemName AS DESCRIPCION
	, OITM.InvntryUom AS UDM
	, OITM.U_Linea AS LINEA
FROM OITM 
Where OITM.U_CodAnt is null
ORDER BY OITM.ItemName

/*
Update OITM set OITM.U_CodAnt = 'NOUSA'
FROM OITM 
Where OITM.U_CodAnt is null
*/

/* ------------------------------------------------------------------------------------------------
|                       FIN DE BLOQUE                                                             |
-------------------------------------------------------------------------------------------------*/


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

-- ================================================================================================
-- |               VALIDACIONES DE UNIDADES DE MEDICION.                                           |
-- ================================================================================================

-- Articulos Sin unidad de Inventario. 
	Select '255 ! PT KIT UM <> JGO' AS REPO_374, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat, 
	OITM.InvntItem, OITM.InvntryUom, OITM.PurPackMsr, OITM.BuyUnitMsr from OITM 
	where OITM.InvntryUom <> 'JGO' and OITM.U_TipoMat = 'PT' and OITM.InvntItem = 'N'
	and OITM.ItemCode <> '70000' and OITM.ItemCode <> '71000' and OITM.ItemCode <> '71001'
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
	AND OITM.InvntryUom <> 'PESOS' AND OITM.InvntryUom <> 'ACT' AND OITM.InvntryUom <> 'VS'
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
		
		
-- Articulo con Factor y misma Unidad de Compra.	
	Select '317 ? CON FACTOR MISMA UM ' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.BuyUnitMsr,OITM.PurPackMsr, OITM.SalUnitMsr, OITM.SalPackMsr
	, OITM.NumInBuy from OITM 
	where OITM.NumInBuy > 1 AND OITM.PurPackMsr = BuyUnitMsr
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
	
-- Unidad Compras con factor uno debe ser misma que unidad de Inventario
Select '336 ? UDC FACT 1 DIF. UDM' AS REPORTE_336
	, OITM.ItemCode AS CODIGO
	, OITM.ItemName AS DESCRIPCION
	, OITM.InvntryUom as UDM
	, OITM.PurPackMsr AS UDC
	, OITM.NumInBuy AS FACTOR
	, OITM.BuyUnitMsr AS UDCM
From OITM
Where OITM.frozenFor = 'N' AND OITM.NumInBuy  = 1 and (OITM.PurPackMsr <> OITM.InvntryUom OR
OITM.BuyUnitMsr <> OITM.InvntryUom)
Order By DESCRIPCION

-- Unidad Venta con factor uno debe ser misma que unidad de Inventario
Select '338 ? UDV FACT 1 DIF. UDM' AS REPORTE_338
	, OITM.ItemCode AS CODIGO
	, OITM.ItemName AS DESCRIPCION
	, OITM.InvntryUom as UDM
	, OITM.SalPackMsr AS UDC
	, OITM.NumInSale AS FACTOR
	, OITM.SalUnitMsr AS UDVM
From OITM
Where OITM.frozenFor = 'N' AND OITM.NumInSale  = 1 and (OITM.SalPackMsr <> OITM.InvntryUom OR
OITM.SalUnitMsr <> OITM.InvntryUom) 
Order By DESCRIPCION

-- VER-170829 ARTICULO CON LISTA DE MATERIALES Y NO TIENE MARCADAS PROPIEDADES Y TIPO = SP.
-- QUITAR ARTICULOS QUE SE FABRICAN PERO SE ESTAN COMPRANDO ACTUALMENTE.
	Select '340 ? ART. CON LDM Y SIN PROPI.' AS REPORTE, A3.ItemCode, ITT1.Father ,A3.ItemName, A3.U_TipoMat, A3.QryGroup29, A3.QryGroup30,
	A3.QryGroup31, A3.QryGroup32, A3.frozenFor
	from OITM A3
	left join ITT1 on A3.ItemCode = ITT1.Father    
	where ITT1.Father is not null and A3.U_TipoMat <> 'PT' and A3.QryGroup29 = 'N'  
	and A3.QryGroup30 = 'N' and A3.QryGroup31 = 'N' and A3.QryGroup32 = 'N'
	and A3.frozenFor = 'N' and A3.U_TipoMat <> 'MP' and A3.U_TipoMat <> 'RF'
	ORDER BY A3.ItemName	
	
-- ARTICULO PROPIEDAD 32 NO MARCADOS COMO SP o RF.
	Select '345 ? ART. PROP-32 NO SP' AS REPORTE, A3.ItemCode, A3.ItemName, A3.U_TipoMat, A3.QryGroup29, A3.QryGroup30,
	A3.QryGroup31, A3.QryGroup32
	from OITM A3
	where A3.U_TipoMat <> 'SP' and A3.U_TipoMat <> 'RF' and A3.QryGroup32 = 'Y' and A3.U_GrupoPlanea <> 6
	ORDER BY A3.ItemName				
							
-- ARTICULOS PRODUCTOS TERMINADOS
-- Producto Terminado que no tiene almacen asignado APT-ST. 
	select '400 ! PT, SIN ALMA.' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat, OITM.DfltWH, OITM.ItmsGrpCod, OITM.U_estacion,
	OITM.PurPackMsr, OITM.NumInBuy, OITM.BuyUnitMsr from OITM 
	where U_TipoMat = 'PT' and OITM.DfltWH is null
	
-- Producto Terminado que tienen almacen Equivocado. 
	select '405 ? PT ALM. EQUIVOCADO' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat, OITM.DfltWH, OITM.ItmsGrpCod, OITM.U_estacion,
	OITM.PurPackMsr, OITM.NumInBuy, OITM.BuyUnitMsr from OITM 
	where U_TipoMat = 'PT' and OITM.DfltWH <> 'APT-ST' 
		
-- Articulos del Grupo Piel y no son Piel 
	select '425 ? ART. 113 Y NO DICE PIEL' AS REPORTE, OITM.ItemCode,OITM.ItemName, OITM.ItmsGrpCod, OITB.ItmsGrpNam, OITM.U_TipoMat
	from OITM
	inner join OITB on OITM.ItmsGrpCod=OITB.ItmsGrpCod
	where OITM.ItmsGrpCod='113' and OITM.ItemName not like '%PIEL%' 
	order by OITM.ItemName
		
-- Productos Terminados con Grupo de Planeacion diferente a Z PRODUCTO TERMINADO. */
	select '430 ? PT GRUPO PLAN MAL' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.ItmsGrpCod, OITM.U_TipoMat, OITM.U_GrupoPlanea 
	from OITM
	where U_TipoMat='PT' and U_GrupoPlanea<> 12 and U_GrupoPlanea <> 15 or
	U_TipoMat='PT' and U_GrupoPlanea is null
	order by OITM.ItemName
 			
-- Articulo VENTAS que la suma de valor sala sea la de sus componentes, Capture correcto diseño.
-- Instalodo en Alarma en SAP.
	Select '465 ! VS DIFERENTE' AS REPORTE, A2.ItemCode, A2.ItemName, A2.U_TipoMat
		, Cast(A2.U_VS as decimal(16,3)) AS U_VS
		, Cast(B0.ValSal as decimal(16,3)) AS ValSal, A2.SellItem, A2.InvntItem, A2.PrchseItem
	from OITM A2
	inner join (Select ITT1.Father, sum(A3.U_VS*ITT1.Quantity) As ValSal 
	from ITT1
	inner join OITM A3 on ITT1.Code=A3.ItemCode
	group by ITT1.Father ) B0 on A2.ItemCode= B0.Father
	where A2.U_TipoMat='PT' and A2.SellItem='Y' and A2.InvntItem='N' and A2.PrchseItem='N' and A2.U_VS<>B0.ValSal
	order by A2.ItemName 
		
-- Articulo Con Grupo de Planeacion Nulo (Asignar segun el material).
	select '500 ? SIN GPO. PLANEA' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.ItmsGrpCod, OITM.U_TipoMat, OITM.U_GrupoPlanea 
	from OITM
	where OITM.U_GrupoPlanea is null 
	order by OITM.ItemName
 
-- SUB-ENSAMBLES 210805 CREO QUE ESTO YA NO PROCEDE 
-- Debe tener activada la Propiedad 32
	--Select '505 ? PROP-32' AS REPORTE, OITM.U_TipoMat, OITM.ItemCode, OITM.ItemName,
	--OITM.InvntryUom, OITM.OnHand, QryGroup32, OITM.frozenFor
	--from OITM 
	--where OITM.U_TipoMat='SP' and OITM.QryGroup32 <> 'Y'
	--and OITM.frozenFor = 'N'
	---Order by OITM.ItemName
	
	Select '785 ! BLOQUEADOS' as REPORTE,
			OITM.ItemCode as CODIGO,
			OITM.ItemName as MATERIAL,
			OITM.InvntryUom as UDM,
			OITW.Locked as BLOQUEO
	from OITM
	inner join OITW on OITM.ItemCode = OITW.ItemCode
	Where OITW.Locked = 'Y'

-- Producto Terminado que tienen almacen Equivocado. 
	--select '790 ? CINTILLO ALM. EQUIVOCADO' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat, OITM.DfltWH, OITM.ItmsGrpCod, OITM.U_estacion,
	--OITM.PurPackMsr, OITM.NumInBuy, OITM.BuyUnitMsr from OITM 
	--where ItemCode = '3778-42-P0201' and OITM.DfltWH <> 'APG-ST' 

-- Articulo Casco o complemento, sin marcar casilla de Articulo de Venta, al no activarlo no se puede capturar
-- en pedido para generar la Orden de Produccion. 
	Select '020 CASILLA VENTAS SIN ACT.' AS REPORTE_020
		, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat, OITM.InvntItem,
		OITM.SellItem, OITM.PrchseItem
	from OITM 
	where U_GrupoPlanea = 2 and SellItem = 'N'

-- Validar casillas de Inventario, Ventas, Compras. PT deben esta llenas las tres, es caso de Piezas 
-- sueltas en caso, en caso de compuestos solo ventas.
	select '025 CASILLAS VENTA COMPRAS A PT' AS REPORTE_025
		, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat, OITM.InvntItem,
		OITM.SellItem, OITM.PrchseItem
	from OITM 
	where U_GrupoPlanea = 12 and InvntItem = 'Y' and PrchseItem='N'

--EX-DISEÑO
--	EX-DIS-001 Validar que los articulos modelos sean Tipo = PT 
		Select	'001 ? MODELOS NO SON PT' AS REPORTE, 
				OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat,
				OITM.U_VS, OITM.AvgPrice
		from OITM
		where  OITM.U_IsModel = 'S' 
		and OITM.U_TipoMat <> 'PT'
		order by OITM.ItemName

--	EX-DIS-010 Validar que los articulos modelos no haya borrado la Descripcion 
		Select	'010 ? SIN DESCRIPCION' AS REPORTE, 
				OITM.ItemCode, Isnull(OITM.ItemName,'BORRARON DESCRIPCION'),
				OITM.U_TipoMat,
				OITM.U_VS, OITM.AvgPrice
		from OITM
		where  OITM.U_IsModel = 'S' 
		and OITM.ItemName Is Null 
		order by OITM.ItemName

--	EX-DIS-015 Validar que los articulos hule espuma (preparado) consuma estacion 415
		Select	'015 ! HE PREP->EST 415' AS REPORTE, 
				OITM.ItemCode, 
				OITM.ItemName,
				OITM.U_TipoMat,
				OITM.U_VS, OITM.AvgPrice
				, OITM.QryGroup2
				, OITM.U_Estacion
		from OITM
		where QryGroup2 = 'Y'  and U_Estacion <> 415
		order by OITM.ItemName

--	EX-DIS-020 Validar que los articulos hule espuma (cojineria) consuma estacion 145
	Select	'020 ! HE COJIN->EST 145' AS REPORTE, 
				OITM.ItemCode, 
				OITM.ItemName,
				OITM.U_TipoMat,
				OITM.U_VS, OITM.AvgPrice
		from OITM
		where QryGroup1 = 'Y'  and U_estacion <> 145
		order by OITM.ItemName
	
--	EX-DIS-025 Validar que los articulos HABILITADO, consuma estacion 403
		Select	'025 ! HABIL->EST 403' AS REPORTE, 
				OITM.ItemCode, 
				OITM.ItemName,
				OITM.U_TipoMat,
				OITM.U_VS, OITM.AvgPrice
		from OITM
		where QryGroup30 = 'Y'  and U_estacion <> 403
		order by OITM.ItemName
		
--	EX-DIS-035 Sin Almacen por Default 
		Select	'035 ? SIN ALMACEN DFT' AS REPORTE, 
				OITM.ItemCode,
				OITM.ItemName,
				OITM.U_TipoMat,
				OITM.DfltWH
		from OITM
		where  OITM.DfltWH is null  
		order by OITM.ItemName

-- =================================================================================================================		
-- | NOTA: Las siguientes excepciones se deja su correccion automatica, dado que se trata de datos de Usuarios.    |
-- | Corresponden a los datos que se requieren para facturacion electronica.
-- =================================================================================================================
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
	
-- Asignar cuenta contable de acuerdo a los grupos de Articulos.

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

-- =================================================================================================================		
-- | Fin del Bloque con autocorrecciones.                                                                          |
-- =================================================================================================================
	
-- 230920 Validar que los articulos MP TELAS y TELAS Y VINILES Tengan Emision Manual. 
	Select '785 TELAS ART. MANUAL' AS REPORTE_785
		, A1.ItemCode AS CODIGO
		, A1.ItemName AS DESCRIPCION
		, A1.U_TipoMat AS TIPO
		, A1.ItmsGrpCod AS GRUPO
		, A1.U_GrupoPlanea AS PLANEA
		, A1.IssueMthd AS EMISION
	From OITM A1   
	where A1.frozenFor = 'N' and A1.ItmsGrpCod = 114 and A1.U_GrupoPlanea = '11'
	and A1.IssueMthd <> 'M' and A1.U_Linea = '01'
	ORDER BY A1.ItemName


-- 230920 Validar que las LDM los componentes MP TELAS y TELAS Y VINILES Tengan Emision Manual.
Select '801 TELAS LDM MANUAL' AS REPORTE_801
		, ITT1.Father AS PT
		, A1.ItemCode AS CODIGO
		, A1.ItemName AS DESCRIPCION
		, A1.U_TipoMat AS TIPO
		, A1.ItmsGrpCod AS GRUPO
		, A1.U_GrupoPlanea AS PLANEA
		, ITT1.IssueMthd AS EMISION
	From OITM A1  
	inner Join ITT1 on A1.ItemCode = ITT1.Code
	where A1.frozenFor = 'N' and A1.ItmsGrpCod = 114 and A1.U_GrupoPlanea = '11'
	and ITT1.IssueMthd <> 'M' -- and  A1.ItemCode = '20704'
	ORDER BY A1.ItemName

-- 230920 Validar que las OP los componentes MP TELAS y TELAS Y VINILES Tengan Emision Manual.
Select '804 TELAS OP MANUAL' AS REPORTE_804
		, OWOR.DocNum AS OP
		, OWOR.ItemCode AS PT
		, A1.ItemCode AS CODIGO
		, A1.ItemName AS DESCRIPCION
		, A1.U_TipoMat AS TIPO
		, A1.ItmsGrpCod AS GRUPO
		, A1.U_GrupoPlanea AS PLANEA
		, WOR1.IssueType AS EMISION
	From OITM A1  
	inner Join WOR1 on A1.ItemCode = WOR1.ItemCode
	inner Join OWOR on WOR1.DocEntry = OWOR.DocEntry
	where A1.frozenFor = 'N' and A1.ItmsGrpCod = 114 and A1.U_GrupoPlanea = '11'
	and OWOR.CmpltQty < OWOR.PlannedQty and OWOR.Status <> 'C' and OWOR.Status <> 'L'
	and WOR1.IssueType <> 'M' and  OWOR.U_Starus <> '06' --and A1.ItemCode = '19604' --[%] 
	ORDER BY A1.ItemName, OWOR.DocNum

-- 230920 Validar que las LDM los componentes MP TELAS y TELAS Y VINILES Tengan Almacen de AMP-ST.
Select '807 TELAS LDM MANUAL' AS REPORTE_807
		, ITT1.Father AS PT
		, A1.ItemCode AS CODIGO
		, A1.ItemName AS DESCRIPCION
		, A1.U_TipoMat AS TIPO
		, A1.ItmsGrpCod AS GRUPO
		, A1.U_GrupoPlanea AS PLANEA
		, ITT1.Warehouse AS ALMACEN
	From OITM A1  
	inner Join ITT1 on A1.ItemCode = ITT1.Code
	where A1.frozenFor = 'N' and A1.ItmsGrpCod = 114 and A1.U_GrupoPlanea = '11'
	and ITT1.Warehouse <> 'AMP-ST'  -- and  A1.ItemCode = '20704'
	ORDER BY A1.ItemName

-- 230920 Validar que las OP los componentes MP TELAS y TELAS Y VINILES Tengan Almacen de AMP-ST.
Select '810 TELAS OP MANUAL' AS REPORTE_810
		, OWOR.DocNum AS OP
		, OWOR.ItemCode AS PT
		, A1.ItemCode AS CODIGO
		, A1.ItemName AS DESCRIPCION
		, A1.U_TipoMat AS TIPO
		, A1.ItmsGrpCod AS GRUPO
		, A1.U_GrupoPlanea AS PLANEA
		, WOR1.wareHouse AS ALMACEN
	From OITM A1  
	inner Join WOR1 on A1.ItemCode = WOR1.ItemCode
	inner Join OWOR on WOR1.DocEntry = OWOR.DocEntry
	where A1.frozenFor = 'N' and A1.ItmsGrpCod = 114 and A1.U_GrupoPlanea = '11'
	and OWOR.CmpltQty < OWOR.PlannedQty and OWOR.Status <> 'C' and OWOR.Status <> 'L'
	and WOR1.wareHouse <> 'AMP-ST' --and  A1.ItemCode = '19604'
	ORDER BY A1.ItemName, OWOR.DocNum

--< EOF > EXCEPCIONES PARA LOS ARTICULOS.
