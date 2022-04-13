-- Consultas que se cargaron a las Alertas de SAP.
-- Desarrollo: Ing. Vicente Cueva Ramírez.
-- Actualizado: Miercoles 17 de Noviembre del 2021; Origen.

-- Consumo de materiales no direccionado al APG-ST. 
Select '001 CONSUMA APG-ST' AS REPORTE_001
	, ITT1.Father
	, A3.ItemName
	, A3.U_TipoMat
	, ITT1.Code,A1.ItemName
	,ITT1.Warehouse
from ITT1 
inner join OITM A3 on A3.ItemCode=ITT1.Father
inner join OITM A1 on A1.ItemCode=ITT1.Code
where A3.U_TipoMat = 'PT' and ITT1.warehouse <> 'APG-ST' 
and A1.ItmsGrpCod <> '113' and A3.InvntItem = 'Y'
ORDER BY A3.ItemName

-- Almacen de Consumo para Piel al AMP-ST.
SELECT '002 PIEL ALMACEN <> AMP-ST' AS REPORTE_002
	, A3.ItemCode AS CODE
	, A3.ItemName AS MODELO
	, A1.ItemCode AS CODIGO
	, A1.ItemName AS DESCRIPCION
	, ITT1.Warehouse AS ALMACEN
FROM ITT1
INNER JOIN OITM A3 on ITT1.Father = A3.ItemCode
INNER JOIN OITM A1 on ITT1.Code=A1.ItemCode and A1.ItmsGrpCod = '113'
WHERE ITT1.Warehouse <> 'AMP-ST'  

-- Articulos que les quitaron Retencion de Impuestos.
-- CARGADO A LAS ALERTAS DE SAP EL 16/NOV/2021
SELECT '003 ? SIN RET. IMP.' AS REPORTE_003
	, OITM.ItemCode
	, OITM.ItemName
	, OITM.WTLiable
FROM OITM
WHERE OITM.WTLiable = 'N'
	
-- Articulos sin Sujeto a impuestos.
-- CARGADO A LAS ALERTAS DE SAP 17/NOV/2021
SELECT '004 ARTICULOS S-IVA' AS REPORTE_004
	, T0.[ItemCode]
	, T0.[ItemName]
	, T0.[InvntryUom]
	, T0.[VATLiable]
FROM OITM T0
WHERE T0.[VATLiable] = 'N'
ORDER BY T0.[ItemName]

-- Material que se consume de AMP-CC en lugar de APG-ST.
-- CARGADO A LAS ALERTAS DE SAP 01/DIC/2021
select '005 SB CONSUME AMP-CC' AS REPORTE, ITT1.Father, A3.ItemName, ITT1.Code, A1.ItemName, ITT1.Warehouse
	from ITT1 
	inner join OITM A3 on ITT1.Father=A3.ItemCode
	inner join OITM A1 on ITT1.Code=A1.ItemCode
	Where ITT1.Warehouse = 'AMP-CC' and A1.ItmsGrpCod <> '113'
	AND A3.U_TipoMat <> 'PT'
	Order by A3.ItemName


-- LINEAS CAMBIADAS A MANUAL Y NO SE HA CARGADO MATERIAL. 	
-- CARGADO A LAS ALERTAS DE SAP 03/DIC2021
	Select	'006 FALTA CARGA CONSUMO' AS REPORTE
			,OWOR.Status
			, WOR1.DocEntry AS OP
			, WOR1.ItemCode AS CODIGO
			, A1.ItemName AS NATERIAL
			, A1.InvntryUom AS UDM
			, Cast(OITW.OnHand as decimal(16,2)) AS WIP
			, Cast(WOR1.PlannedQty as decimal(16,2)) AS NECESIDAD
			, Cast(WOR1.IssuedQty as decimal(16,2)) AS CARGADO
			, Cast((WOR1.PlannedQty - WOR1.IssuedQty) as decimal(16,2)) AS PENDIENTE
	From WOR1 
	inner join OITM A1 on WOR1.ItemCode=A1.ItemCode 
	inner join OWOR on WOR1.DocEntry=OWOR.DocEntry 
	inner join OITW on A1.ItemCode=OITW.ItemCode AND OITW.WhsCode = 'APG-ST'
	where  OWOR.Status = 'R' and A1.U_TipoMat <> 'CG' and WOR1.IssueType = 'M' and
	WOR1.IssuedQty < WOR1.PlannedQty and OWOR.CmpltQty=0  and A1.ItmsGrpCod <> 113 and A1.QryGroup30='N'
		
-- Validar que los PT (ESTRUCTURA) CONSUMAN DEL APG-ST (NO KIT de VENTAS)
-- CARGADO A LAS ALERTAS DE SAP 10/DIC/2021
	Select '007 LDM PT. CONSUMA APG-ST' AS REPORTE_007
		, ITT1.Father AS CODIGO
		, A3.ItemName AS MUEBLE
		, A3.U_TipoMat AS T_MAT
		, ITT1.Code AS CODE
		, A1.ItemName AS MATERIAL
		, ITT1.Warehouse AS ALM_CONSUME
	from ITT1 
	inner join OITM A3 on A3.ItemCode=ITT1.Father
	inner join OITM A1 on A1.ItemCode=ITT1.Code
	where A3.U_TipoMat = 'PT' and ITT1.warehouse <> 'APG-ST' 
	and A1.ItmsGrpCod <> '113' and A3.InvntItem = 'Y'
	ORDER BY A3.ItemName

-- Articulos Sin unidad de Inventario. 
-- CARGADO A LAS ALESTAS DE SAP 08/ABR/2022
	Select '008 SIN UDM INVENTARIO' AS REPO_008, OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat, OITM.DfltWH, oitm.ItmsGrpCod, OITB.ItmsGrpNam,
	OITM.U_GrupoPlanea, UFD1.Descr, OITM.U_estacion, OITM.InvntryUom,
	OITM.PurPackMsr, OITM.NumInBuy, OITM.BuyUnitMsr from OITM 
	inner join UFD1 on OITM.U_GrupoPlanea=UFD1.FldValue and UFD1.TableID='UITM'
	inner join OITB on OITM.ItmsGrpCod=OITB.ItmsGrpCod
	where OITM.InvntryUom is null
	ORDER BY OITM.ItemName		

