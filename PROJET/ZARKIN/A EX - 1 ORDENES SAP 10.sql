-- EXCEPCIONES DE OREDENES DE PRODUCCION, FUNDA, CASCO y HABILITADO. 
-- OBJETIVO: Mantener al dia algunos de los elementos claves para las Ordenes de Produccion.
-- Desarrollo: Ing. Vicente Cueva Ramírez.
-- Actualizado: Viernes 10 de Agosto del 2018. (Integracion del APG-ST)
-- Actualizado: Viernes 23 de Julio del 2021; SAP-10, Quitar autocorrecion.
-- NOTA: Por contar con soporte de SAP se deja de hacer correcciones automatica (update) para no correr
--riesgos de perder la garantia por parte de SAP.

-- Estructura del la Orden de Produccion:
--		Almacen:  Si es PT = APT-ST, CA y PROP-31 = APT-PA, SP = AMP-CC
--		Materiales se consumen de APG-ST (Solo piel de AMP-ST)
--		Validar Estatus PT = PROCESO cuando tenga cargada piel y Liberado.
--		Validar Estatus CA = PROCESO cuando este Liberado.
--		Validar Estatus Si esta en PROCESO y estatus en Planificado.
--		Registros de Control de Piso.

-- ================================================================================================
-- |               Informacion acumulada del Mes.                                                 |
-- ================================================================================================

-- Ordenes que fueron cerradas en el Periodo.
	--Select '005 ORDENES CERRADAS ' AS REPORTE_005
--		, COUNT(CIERRE.ItemCode) as Cerrados
	--from (
	--Select OWOR.DocEntry
--		, OWOR.ItemCode
--		, OWOR.CloseDate
--	from OWOR
--	Where OWOR.CloseDate between ('2021/10/04') and ('2021/10/31')) CIERRE
	-- Formato fecha aaaa/mm/dd

-- ================================================================================================
-- |             Almacen: Si es PT = APT-ST, CA y PROP-31 = APT-PA, SP = AMP-CC.                  |
-- ================================================================================================

-- Ordenes de Produccion de PT que caen en otro almacen que no es APT-ST.
	SELECT '010 OP PT <> APT-ST' AS REPORTE_010
		, OWOR.DocNum AS OP 
		, OWOR.ItemCode AS CODIGO
		, OITM.ItemName AS DESCRIPCION
		, OITM.InvntryUom AS UDM
		, OWOR.Warehouse AS PROVEEDOR
	FROM  OWOR 
	INNER JOIN OITM on OWOR.ItemCode = OITM.ItemCode and U_TipoMat = 'PT'
	WHERE OWOR.Warehouse <> 'APT-ST' and OWOR.CmpltQty < OWOR.PlannedQty
	ORDER BY OITM.ItemName

-- Ordenes de Produccion de CA que caen en otro almacen que no es APT-PA.
	SELECT '015 OP CA <> APT-PA' AS REPORTE_015
		, OWOR.DocNum AS OP 
		, OWOR.ItemCode AS CODIGO
		, OITM.ItemName AS DESCRIPCION
		, OITM.InvntryUom AS UDM
		, OWOR.Warehouse AS PROVEEDOR
	FROM  OWOR 
	INNER JOIN OITM on OWOR.ItemCode = OITM.ItemCode and U_TipoMat = 'CA'
	WHERE OWOR.Warehouse <> 'APT-PA' and OWOR.CmpltQty < OWOR.PlannedQty
	and OWOR.Status <> 'C' and OWOR.Status <> 'L'
	ORDER BY OITM.ItemName

-- Ordenes de Produccion de Patas y Bastidores caen en otro almacen que no es APT-PA.
	SELECT '020 OP PATAS <> APT-PA' AS REPORTE_020
		, OWOR.DocNum AS OP 
		, OWOR.ItemCode AS CODIGO
		, OITM.ItemName AS DESCRIPCION
		, OITM.InvntryUom AS UDM
		, OWOR.Warehouse AS PROVEEDOR
	FROM  OWOR 
	INNER JOIN OITM on OWOR.ItemCode = OITM.ItemCode and OITM.QryGroup31 = 'Y'
	WHERE OWOR.Warehouse <> 'APT-PA' and OWOR.CmpltQty < OWOR.PlannedQty
	and OWOR.Status <> 'C' and OWOR.Status <> 'L'
	ORDER BY OWOR.DocNum, OITM.ItemName

-- Ordenes de Produccion de SP que caen en otro almacen que no es AMP-CC, NO REFACCIONES.
/*
Ya no procede porque esta usando SB para cosas de carpinteria.
	SELECT '025 OP SP <> AMP-CC' AS REPORTE_025
		, OWOR.DocNum AS OP 
		, OWOR.ItemCode AS CODIGO
		, OITM.ItemName AS DESCRIPCION
		, OITM.InvntryUom AS UDM
		, OWOR.Warehouse AS ALMACEN
	FROM  OWOR 
	INNER JOIN OITM on OWOR.ItemCode = OITM.ItemCode and OITM.QryGroup32 = 'Y' and OITM.U_TipoMat <> 'RF'
	WHERE OWOR.Warehouse <> 'AMP-CC' and OWOR.CmpltQty < OWOR.PlannedQty 
	and OWOR.Status <> 'C' and OWOR.Status <> 'L'
	ORDER BY OITM.ItemName
*/

-- Ordenes de Produccion de SP que caen en otro almacen que no es APT-ST y son refacciones.
	SELECT '030 OP SP <> APT-ST' AS REPORTE_030
		, OWOR.DocNum AS OP 
		, OWOR.ItemCode AS CODIGO
		, OITM.ItemName AS DESCRIPCION
		, OITM.InvntryUom AS UDM
		, OWOR.Warehouse AS ALMACEN
	FROM  OWOR 
	INNER JOIN OITM on OWOR.ItemCode = OITM.ItemCode and OITM.QryGroup32 = 'Y' and OITM.U_TipoMat = 'RF'
	WHERE OWOR.Warehouse <> 'APT-ST' and OWOR.CmpltQty < OWOR.PlannedQty
	and OWOR.Status <> 'C' and OWOR.Status <> 'L' and  OITM.ItemName Not Like '%CINTI%'
	ORDER BY OITM.ItemName

-- ================================================================================================
-- |                  Materiales se consumen de APG-ST (Solo piel de AMP-ST).                     |
-- ================================================================================================

-- Ordenes de Produccion Fundas con Material Diferentes a Piel que consumen material de AMP-ST 
-- excepto las ordenes de Herrajes.
	Select '040 OP CONSUME AMP-ST' AS REPORTE_040, OWOR.Status, WOR1.DocEntry, OWOR.ItemCode, WOR1.ItemCode, OITM.ItemName
	, WOR1.wareHouse, OITM.U_GrupoPlanea 
	from WOR1
	inner join OWOR on WOR1.DocEntry = OWOR.DocEntry
	inner join OITM on WOR1.ItemCode = OITM.ItemCode
	where OWOR.Status <> 'C' and OWOR.Status <> 'L' and OITM.ItmsGrpCod <> '113' 
	and WOR1.wareHouse = 'AMP-ST' AND OWOR.ItemCode <> '17814' and 
	OWOR.ItemCode <> '17620' and OWOR.ItemCode <> '17621' and OWOR.ItemCode <> '17701'
	and OWOR.ItemCode <> '19415' and OWOR.ItemCode <> '19646' and OWOR.ItemCode <> '18939'
	and OWOR.ItemCode <> '20414' and OWOR.ItemCode <> '20415' and OWOR.ItemCode <> '18943'
	and OWOR.ItemCode <> '19416'
	and OITM.U_GrupoPlanea <> '6' and OITM.U_GrupoPlanea <> 11
	Order by WOR1.DocEntry
	
-- Ordenes de Produccion con Material PIEL cargado almacen Diferente al de AMP-ST
	Select '035 PIEL DIF. AMP-ST' AS REPORTE_35, OWOR.Status, WOR1.DocEntry, WOR1.ItemCode, OITM.ItemName, WOR1.wareHouse
	from WOR1
	inner join OWOR on WOR1.DocEntry = OWOR.DocEntry
	inner join OITM on WOR1.ItemCode = OITM.ItemCode
	where OWOR.Status <> 'C' and OWOR.Status <> 'L' and OITM.ItmsGrpCod= '113' and 
	WOR1.wareHouse <> 'AMP-ST'
		
-- Ordenes de Produccion Fundas con Material Diferentes a Piel que consumen material de AMP-CC
	Select '045 OP CONSUME AMP-CC' AS REPORTE_045, OWOR.Status, WOR1.DocEntry, OWOR.ItemCode, WOR1.ItemCode, OITM.ItemName, WOR1.wareHouse
	from WOR1
	inner join OWOR on WOR1.DocEntry = OWOR.DocEntry
	inner join OITM on WOR1.ItemCode = OITM.ItemCode
	where OWOR.Status <> 'C' and OWOR.Status <> 'L' and OITM.ItmsGrpCod <> '113' 
	and WOR1.wareHouse = 'AMP-CC'

-- Ordenes de Produccion Fundas con Material Diferentes a Piel que consumen material de AMP-CC
	Select '050 CONSUME <> APG-ST' AS REPORTE_050, OWOR.Status, WOR1.DocEntry, OWOR.ItemCode, WOR1.ItemCode, OITM.ItemName, WOR1.wareHouse
	from WOR1
	inner join OWOR on WOR1.DocEntry = OWOR.DocEntry
	inner join OITM on WOR1.ItemCode = OITM.ItemCode
	where OWOR.Status <> 'C' and OWOR.Status <> 'L' and OITM.ItmsGrpCod <> '113' 
	AND OWOR.ItemCode <> '17814' and 
	OWOR.ItemCode <> '17620' and OWOR.ItemCode <> '17621' and OWOR.ItemCode <> '17701'
	and OWOR.ItemCode <> '19415' and OWOR.ItemCode <> '19646' and OWOR.ItemCode <> '18939'
	and OWOR.ItemCode <> '20414' and OWOR.ItemCode <> '20415' and OWOR.ItemCode <> '18943'
	and OWOR.ItemCode <> '19416'
	and WOR1.wareHouse <> 'APG-ST' and OITM.U_GrupoPlanea <> 6  and OITM.U_GrupoPlanea <> 11

	
	-- La 050 la cancele segun creo solo la 045 esta mas completa.
-- Ordenes de Produccion Fundas con Material Diferentes a Piel que consumen <> de APP-ST
-- 9 AGOSTO 18 CAMBIE A APG-ST EN LUGAR DEL APP-ST
-- Sub-Ensambles de Herrajes consumen de AMP-ST
	--Select '050 OP CONSUME <> APG-ST' AS REPORTE_050, OWOR.Status, WOR1.DocEntry, OWOR.ItemCode,
	--	A3.ItemName, WOR1.ItemCode, A1.ItemName, WOR1.wareHouse
	--from WOR1
	--inner join OWOR on WOR1.DocEntry = OWOR.DocEntry
	--inner join OITM A1 on WOR1.ItemCode = A1.ItemCode
	--inner join OITM A3 on OWOR.ItemCode = A3.ItemCode
	--where (A3.U_TipoMat = 'PT' or A3.U_TipoMat = 'SP') and OWOR.Status <> 'C' and OWOR.Status <> 'L' and
	 --A1.ItmsGrpCod <> '113' and WOR1.wareHouse <> 'APG-ST' and  
	 --OWOR.ItemCode <> '17814' and OWOR.ItemCode <> '17620' and 
	 --OWOR.ItemCode <> '17621'

	 	
-- Ordenes de Produccion Casco que consumen diferente a APT-PA; 9 AGOSTO 18 CAMBIE A APG-ST
	Select '055 OP CONSUME APG-ST' AS REPORTE_055, OWOR.Status, WOR1.DocEntry, 
		A3.ItemName, WOR1.ItemCode, OITM.ItemName, WOR1.wareHouse, WOR1.ItemCode,
		A3.QryGroup29, A3.QryGroup30, A3.QryGroup31
	from WOR1
	inner join OWOR on WOR1.DocEntry = OWOR.DocEntry
	inner join OITM on WOR1.ItemCode = OITM.ItemCode 
	inner join OITM A3 on OWOR.ItemCode = A3.ItemCode 
	where OWOR.Status <> 'C' and OWOR.Status <> 'L' 
	and WOR1.wareHouse <> 'APG-ST'
	and (A3.QryGroup29 = 'Y' or A3.QryGroup30 = 'Y' or A3.QryGroup31 = 'Y')
	
--ORDENES DE PRODUCCION GENERADAS NIVEL LISTA DE MATERIALES.
-- Lista de Materiales de Ordenes con Almacen 01 o no definido el Almacen No Piel
-- PLANIFICADAS set Warehouse='APP-ST' 
	Select '075 OP P. ALMACEN 01' AS REPORTE_075
		, OWOR.DocEntry as NumOrde, OWOR.Status, OWOR.ItemCode as Produto, OWOR.Warehouse as ALM_PRO,
		WOR1.ItemCode as Material, WOR1.wareHouse as ALM_MAT 
	from OWOR
	inner join WOR1 on OWOR.DocEntry=WOR1.DocEntry
	inner join OITM on OITM.ItemCode = WOR1.ItemCode 
	where OWOR.Status='P' and WOR1.wareHouse = '01' and OITM.ItmsGrpCod <> '113'

-- Lista de Materiales con Almacen 01 LIBERADAS set Warehouse = 'APP-ST'
	Select '080 OP P. ALMACEN 01' AS REPORTE_080
		, OWOR.DocEntry as NumOrde, OWOR.Status, OWOR.ItemCode as Produto, OWOR.Warehouse as ALM_PRO,
		WOR1.ItemCode as Material, WOR1.wareHouse as ALM_MAT 
	from OWOR
	inner join WOR1 on OWOR.DocEntry=WOR1.DocEntry
	inner join OITM on OITM.ItemCode = WOR1.ItemCode 
	where OWOR.Status='R' and WOR1.wareHouse = '01' and OITM.ItmsGrpCod <> '113'

-- Lista de Materiales de Ordenes con Almacen AMP-CC o no definido el Almacen
-- PLANIFICADAS set Warehouse='APP-ST' 
	Select '085 OP P. ALMACEN AMP-CC' AS REPORTE_085
		, OWOR.DocEntry as NumOrde, OWOR.Status, OWOR.ItemCode as Produto, OWOR.Warehouse as ALM_PRO,
		WOR1.ItemCode as Material, WOR1.wareHouse as ALM_MAT 
	from OWOR
	inner join WOR1 on OWOR.DocEntry=WOR1.DocEntry
	inner join OITM on OITM.ItemCode = WOR1.ItemCode 
	where OWOR.Status='P' and WOR1.wareHouse = 'AMP-CC' and OITM.ItmsGrpCod <> '113'

/*	Ordenes Complementos Liberadas en Proceso con Almacen equivocado set owor.Warehouse= 'APT-ST' */
		select '095 OP DIF ALM. NO APT-ST' AS REPORTE_095, owor.DocNum as Orden,owor.ItemCode, oitm.ItemName, owor.Warehouse
		from owor 
		inner join OITM on OITM.ItemCode = OWOR.ItemCode 
		where owor.CmpltQty < owor.PlannedQty and owor.Warehouse <> 'APT-ST' and OITM.U_TipoMat='PT' 
		and OWOR.Status = 'R'

-- ORDENES QUE NO SE COMPLETO EL PROCESO Y NO QUEDARON REGISTRADAS
	Select '100 SIN REGISTRO' as REPORTE_010, OWOR.DocEntry, OWOR.CmpltQty, [@CP_LOGOF].U_DocEntry, 
		OITM.ItemName, OITM.U_VS, OWOR.Type, OWOR.Status
	from OWOR
	inner join OITM on OWOR.ItemCode=OITM.ItemCode
	left join [@CP_LOGOF] on OWOR.DocEntry=[@CP_LOGOF].U_DocEntry 
	and [@CP_LOGOF].U_CT=175
	where OWOR.CmpltQty > 0 and OITM.QryGroup29='N' 
	and OITM.QryGroup30='N' and OITM.QryGroup31='N' 
	and [@CP_LOGOF].U_DocEntry is null
	and OITM.ItemName not like '%CINTIL%' 
	and OWOR.Type='S' and OITM.U_TipoMat='PT'
	and OWOR.Status = 'R'
	Order by OWOR.DocEntry
		
-- ORDENES QUE NO SE A CARGADO PIEL Y YA FUERON ENTREGADAS A PISO
	Select '020 NO SE CARGO PIEL' AS REPORTE_020, OWOR.DocEntry as NumOrde, OWOR.Status, OWOR.ItemCode as Produto,A3.ItemName, OWOR.Warehouse as ALM_PRO,
		WOR1.ItemCode as Material, A1.itemname, WOR1.wareHouse as ALM_MAT, WOR1.PlannedQty, WOR1.IssuedQty,
		OWOR.U_Entrega_Piel
	from WOR1
	inner join OWOR on OWOR.DocEntry=WOR1.DocEntry
	inner join OITM A1 on A1.ItemCode = WOR1.ItemCode 
	inner join OITM A3 on A3.ItemCode = OWOR.ItemCode
	where OWOR.Status<>'C' and OWOR.Status<>'L' and  A1.ItmsGrpCod = '113'
	and OWOR.U_Entrega_Piel is not null and WOR1.IssuedQty = 0
		  
-- VER-150615 ORDENES QUE SE CARGO PIEL Y ESTAN EN ESTATUS DE NO PROCESO
	Select '025 CON PIEL STATUS NO PROCESO' AS REPORTE_02S, OWOR.DocEntry as NumOrde, OWOR.Status, A1.ItemName, OWOR.U_Grupo, OWOR.U_Starus,OWOR.U_Entrega_Piel,
		OWOR.ItemCode as Produto, OWOR.Warehouse as ALM_PRO,
		WOR1.ItemCode as Material, oitm.ItemName,WOR1.wareHouse as ALM_MAT, WOR1.BaseQty, WOR1.IssuedQty
	from OWOR
	inner join WOR1 on OWOR.DocEntry=WOR1.DocEntry
	inner join OITM on OITM.ItemCode = WOR1.ItemCode 
	inner join OITM A1 on OWOR.ItemCode=A1.ItemCode
	where OWOR.Status='R' and OITM.ItmsGrpCod = '113' and WOR1.IssuedQty>0 and U_Starus <> '06'
	order by U_Grupo, NumOrde

-- ORDENES EN PROCESO Y CON STATUS DIFERENTE A 06 PROCESO.
	Select '030 OP EN WIP DIF A 06 PROCESO' AS REPORTE_030, OP, NO_SERIE, Pedido, CODIGO, Descripcion, Cantidad,VSInd, VS, Funda, U_Starus 
		from Vw_BackOrderExcel 
	where CodFunda between 109 and 175 
	and U_Starus <> '06'
	
-- Ordenes que se movieron a Planificadas y no se Borro de Control de Piso.
-- Se borra historial para nuevamente ser capturadas.
	Select '070 BASURA EN PISO' AS REPORTE_070
		, CP.Code, CP.U_DocEntry, OP.ItemCode, A3.ItemName, OP.Status 
	from [@CP_OF] CP 
	inner join OWOR OP on CP.U_DocEntry= OP.DocEntry 
	inner join OITM A3 on OP.ItemCode = A3.ItemCode 
	where OP.Status = 'P' 

/*
	delete [@CP_OF] where Code = 313032
*/
	
/*ORDENES DE PRODUCCION GENERADAS NIVEL CABECERA. */
/*  Orden Generada como tipo diferente a STANDAR, Cambiar a STANDAR  */
		select '090 OP DIF STANDAR' AS REPORTE_090
			, OWOR.DocEntry as NumOrde, OWOR.Status, OWOR.ItemCode as Produto,
		OITM.ItemName, OWOR.Warehouse as ALM_PRO, OWOR.Type
		from OWOR
		inner join OITM on OITM.ItemCode = OWOR.ItemCode
		where OWOR.Status='R' and OWOR.Type <> 'S'
		
	--ORDENESDE CASCO
	-- Se quitaron las OP: 821, 1084, 1095, 4523 y 4900 20828
	-- NOTA: PARA para finales de septiembre quitar y ver si ya fueron terminadas para que quede
	-- la consulta sin trucos.
	Select '100 RUTA OP CASCO' AS REPORTE_100
		, OWOR.DocEntry, OWOR.ItemCode, OITM.ItemName, OWOR.U_Ruta
	from OWOR
	inner join OITM on OWOR.ItemCode=OITM.ItemCode
	Where OITM.QryGroup29='Y' and OWOR.U_Ruta <> '400,403,406,409,415,418' 
	and OWOR.DocEntry <> 821 and OWOR.DocEntry <> 1084 and OWOR.DocEntry <> 1095
	and OWOR.DocEntry <> 4523 and OWOR.DocEntry <> 4900
	and OWOR.Status <>'C' and OWOR.Status <>'L'

	--ORDENES:
	Select '105 RUTA OP HABILITADO' AS REPORTE_105
		, OWOR.DocEntry, OWOR.ItemCode, OITM.ItemName, OWOR.U_Ruta
	from OWOR
	inner join OITM on OWOR.ItemCode=OITM.ItemCode
	Where OITM.QryGroup30='Y' and OWOR.U_Ruta <> '300,303,306,309,315' and OWOR.Status<>'C' and OWOR.Status<>'L'


/*
---------------------------------------------------------------------------------------------------------------------------------
|        Validar que las Ordenes que tienen Datos en Complejo se haya cargado sino para que se actualice.                       |
---------------------------------------------------------------------------------------------------------------------------------
*/ -- Consulta todos las Ordenes diferentes.

Select '110 ERROR EN COMPLEJO' AS REPORTE_110
	, ORDR.DocEntry AS PEDIDO
	, OWOR.ItemCode AS CODIGO
	, OITM.ItemName AS MODELO
	, SUM(OWOR.PlannedQty) AS CANTIDAD
	, OWOR.U_cc AS COMPLEJO_OP
	, ORDR.U_comp AS COMPLEJO_P
from OWOR
INNER JOIN OITM on OWOR.ItemCode = OITM.ItemCode
INNER JOIN ORDR ON OWOR.OriginNum = ORDR.DocEntry
Where OWOR.U_cc <> ORDR.U_comp and OWOR.Status<>'C' and OWOR.Status<>'L'
Group By ORDR.DocEntry, OWOR.ItemCode, OITM.ItemName, OWOR.U_cc, ORDR.U_comp   
Order By ORDR.DocEntry

 -- Para corregir hacerlo por Pedidos 
 /*

Declare @Complejo as nvarchar(100)
Declare @Pedido as integer
Set @Pedido = 1655
Set @Complejo = (Select ORDR.U_comp from ORDR Where ORDR.DocEntry = @Pedido)

Update OWOR Set U_cc = @Complejo Where OWOR.OriginNum = @Pedido


*/


/*
--Select @Complejo, * from OWOR Where OWOR.OriginNum = @Pedido and OWOR.Status<>'C' and OWOR.Status<>'L'

*/

-- Ordenes de Produccion con materiales a Manual sin haber cargado, Ordenes Planificadas.
	SELECT '115 MP MANUAL PLANIFICADAS' AS REPORTE_115
		, OWOR.DocNum AS OP 
		, OWOR.ItemCode AS CODIGO
		, A1.ItemName AS DESCRIPCION
		, A1.InvntryUom AS UDM
		, WOR1.PlannedQty AS POR_CARGAR
		, WOR1.IssuedQty AS CARGADO
	FROM  OWOR
	inner Join WOR1 on OWOR.DocEntry = WOR1.DocEntry
	Inner Join OITM A1 on WOR1.ItemCode = A1.ItemCode 
	WHERE OWOR.Status = 'P' 
	and WOR1.IssueType = 'M' and A1.ItmsGrpCod <> '113' and A1.U_GrupoPlanea <> 11
ORDER BY OWOR.DocNum, A1.ItemName

-- Ordenes de Produccion con materiales a Manual sin haber cargado, Ordenes Planificadas.
	SELECT '117 MP MANUAL LIBERADAS' AS REPORTE_117
		, OWOR.DocNum AS OP 
		, OWOR.ItemCode AS CODIGO
		, A1.ItemName AS DESCRIPCION
		, A1.InvntryUom AS UDM
		, WOR1.PlannedQty AS POR_CARGAR
		, WOR1.IssuedQty AS CARGADO
	FROM  OWOR
	inner Join WOR1 on OWOR.DocEntry = WOR1.DocEntry
	Inner Join OITM A1 on WOR1.ItemCode = A1.ItemCode 
	WHERE OWOR.Status = 'R' 
	and OWOR.CmpltQty = 0
	and WOR1.IssueType = 'M' and A1.ItmsGrpCod <> '113' 
	and WOR1.IssuedQty = 0 and A1.U_GrupoPlanea <> 11
ORDER BY OWOR.DocNum, A1.ItemName

	
--< EOF > EXCEPCIONES DE ORDENES DE FABRICACION.