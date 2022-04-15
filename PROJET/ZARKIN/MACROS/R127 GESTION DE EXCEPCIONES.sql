-- Consultas para la Gestion de Excepciones
-- Buscar y validar posibles errores en los Articulos y corregir.
-- Desarrollo: Ing. Vicente Cueva Ramirez.
-- Actualizado: Viernes 08 de Abril del 2022; Origen.

-- ================================================================================================
-- |  EXCEPCIONES MODULO 7 INVALIDAR ARTICULOS SIN LDM Y SIN EXISTENCIA.                          |
-- ================================================================================================

-- Para pasar a Invalido articulos PT, CA, HB, RF y SP sin LDM y que no haya existencia.
SELECT  OITM.ItemCode AS CODIGO
	, OITM.ItemName AS NOMBRE
	, OITM.InvntryUom AS UDM
	, T1.Descr AS LINEA
	, OITM.onHand AS EXISTENCIA 
	, OITB.ItmsGrpNam AS GRUPO
	, (Case When OITT.Name is null then 'SIN/LDM' else 'CON/LDM' end) AS LDM
	, ITM1.Price AS ESTANDAR
FROM OITM 
LEFT JOIN OITT on OITT.Code = OITM.ItemCode 
INNER JOIN OITB on OITM.ItmsGrpCod=OITB.ItmsGrpCod 
INNER JOIN ITM1 on OITM.ItemCode=ITM1.ItemCode and ITM1.PriceList=10 
LEFT JOIN UFD1 T1 on T1.FldValue=OITM.U_Linea and T1.TableID='OITM' and T1.FieldID=7 
WHERE OITM.U_TipoMat = 'PT' 
	and OITM.U_IsModel = 'N'
	and OITT.Name is null
	and OITM.frozenFor = 'N'
	and OITM.OnHand = 0
	and OITM.U_ClaveUnidad <> 'ACT'
ORDER BY OITM.ItemName

-- ================================================================================================
-- |  EXCEPCIONES MODULO 8 PARA ARTICULOS QUE MANEJAN PROPIEDADES PARA HULE ESPUMA.                        |
-- ================================================================================================

-- Validar que Grupo Hule Espuma tenga marcada una propiedad 2 Correspondiente a PREPARADO.
-- Para este caso no importa que este Inactivo u Obsoleto
Select OITM.ItemCode AS CODIGO
	, OITM.ItemName AS DESCRIPCION
	, OITM.InvntryUom AS UDM
	, T1.Descr AS LINEA
	, OITM.onHand AS EXISTENCIA 
	, OITB.ItmsGrpNam AS GRUPO
	, OITM.SWeight1 AS PESO
	, ITM1.Price AS ESTANDAR
From OITM
INNER JOIN OITB on OITM.ItmsGrpCod=OITB.ItmsGrpCod 
LEFT JOIN UFD1 T1 on T1.FldValue=OITM.U_Linea and T1.TableID='OITM' and T1.FieldID=7 
INNER JOIN ITM1 on OITM.ItemCode=ITM1.ItemCode and ITM1.PriceList=10 
Where OITM.U_GrupoPlanea = '6' 
		and OITM.QryGroup2 = 'N'
		and OITM.ItemName like '%PREPARA%'
Order By OITM.ItemName

-- Validar que Grupo Hule Espuma tenga marcada una propiedad 1 Correspondiente a COJINERIA.
Select OITM.ItemCode AS CODIGO
	, OITM.ItemName AS DESCRIPCION
	, OITM.InvntryUom AS UDM
	, T1.Descr AS LINEA
	, OITM.onHand AS EXISTENCIA 
	, OITB.ItmsGrpNam AS GRUPO
	, OITM.SWeight1 AS PESO
	, ITM1.Price AS ESTANDAR
From OITM
INNER JOIN OITB on OITM.ItmsGrpCod=OITB.ItmsGrpCod 
LEFT JOIN UFD1 T1 on T1.FldValue=OITM.U_Linea and T1.TableID='OITM' and T1.FieldID=7 
INNER JOIN ITM1 on OITM.ItemCode=ITM1.ItemCode and ITM1.PriceList=10 
Where OITM.U_GrupoPlanea = '6' 
		and OITM.QryGroup2 = 'N'
		and OITM.ItemName not like '%PREPARA%'
Order By OITM.ItemName





-- ================================================================================================
-- | FIN DEL PROYECTO.                                                                            |
-- ================================================================================================


--Aqui ttratar de llegar al modelo PT que los consume y realizar sumatoria

Select 
From (

Select OITM.ItemCode, OITM.ItemName, OITM.InvntryUom
		, Case When OITM.QryGroup1 = 'Y' then Isnull(OITM.SWeight1, 0) else 0 end AS HE_COJIN 
		, Case When OITM.QryGroup2 = 'Y' then Isnull(OITM.SWeight1, 0) else 0 end AS HE_PREPA 
From OITM
Where OITM.frozenFor = 'N'
		and OITM.U_Linea = '01'
		and OITM.U_GrupoPlanea = '6'
Order By OITM.ItemName


) HE

--and OITM.SWeight1 > 0



-- Validar que cada hule este asignado a su propiedad correcta.

Select OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.QryGroup1, OITM.QryGroup2
From OITM
Where OITM.U_GrupoPlanea = '6' and OITM.QryGroup1 = 'Y' 
and OITM.ItemName not like '%COJINERIA%'

Select OITM.ItemCode, OITM.ItemName, OITM.InvntryUom, OITM.QryGroup1, OITM.QryGroup2
From OITM
Where OITM.U_GrupoPlanea = '6' and OITM.QryGroup2 = 'Y' 
and OITM.ItemName not like '%PREPARA%'






Select OITM.ItemCode AS CODIGO, OITM.ItemName as DESCRIPCION, OITM.InvntryUom as UDM, 'APG-ST' as ALMACEN
, OITW.OnHand as IN_STOCK, OITM.IsCommited AS COMPROMETIDO, OITW.OnHand - OITM.IsCommited as NECESIDAD
, ITM1.Price as PRECIO, (OITW.OnHand - OITM.IsCommited) * ITM1.Price AS IMPORTE, '501-200-000' AS CC
, (select COUNT(OWOR.ItemCode) from OWOR inner join WOR1 on OWOR.DocNum = WOR1.DocEntry and 
OWOR.Status = 'R' Where WOR1.ItemCode = OITM.ItemCode) AS LISTA
, OITM.U_Linea AS LINEA
from OITM inner join OITW on OITM.ItemCode=OITW.ItemCode and OITW.WhsCode = 'APG-ST' inner join ITM1 on OITM.ItemCode= ITM1.ItemCode and ITM1.PriceList= 10 where OITW.OnHand > 0 order by IMPORTE DESC, DESCRIPCION 

    


SELECT OITM.ItemCode AS CODIGO, OITM.ItemName AS NOMBRE, OITM.InvntryUom AS UDM, T1.Descr AS LINEA, OITM.onHand AS EXISTENCIA, OITB.ItmsGrpNam AS GRUPO, (Case When OITT.Name is null then 'SIN/LDM' else 'CON/LDM' end) AS LDM, ITM1.Price AS ESTANDAR FROM OITM LEFT JOIN OITT on OITT.Code = OITM.ItemCode INNER JOIN OITB on OITM.ItmsGrpCod=OITB.ItmsGrpCod INNER JOIN ITM1 on OITM.ItemCode=ITM1.ItemCode and ITM1.PriceList=10 LEFT JOIN UFD1 T1 on T1.FldValue=OITM.U_Linea and T1.TableID='OITM' and T1.FieldID=7 WHERE OITM.U_TipoMat = 'RF' and OITM.U_IsModel = 'N' and OITT.Name is null and OITM.frozenFor = 'N' and OITM.OnHand = 0 ORDER BY OITM.ItemName
