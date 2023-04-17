-- Consultas para la Gestion de Excepciones
-- Buscar y validar posibles errores en los Articulos y corregir.
-- Desarrollo: Ing. Vicente Cueva Ramirez.
-- Actualizado: Viernes 08 de Abril del 2022; Origen.

-- ================================================================================================
-- |  EXCEPCIONES MODULO 7 INVALIDAR ARTICULOS SIN LDM Y SIN EXISTENCIA.                          |
-- ================================================================================================
/*
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
*/
-- ================================================================================================
-- |  EXCEPCIONES MODULO 8 PARA ARTICULOS QUE MANEJAN PROPIEDADES PARA HULE ESPUMA.                        |
-- ================================================================================================
/*
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
*/
-- ================================================================================================
-- |  EXCEPCIONES MODULO 9 PARA CALCULO DE VALOR SALA A LOS JUEGOS DE HULE ESPUMA EN BASE LDM.    |
-- ================================================================================================
/*
' =========================================================================
' | Procedimiento:                                                        |
' |                                                                       |
' | Se procede con:                                                       |
' |      1.- Obtener el Listado de los Hules de Cojineria y Anexar su     |
' |           Complemento de Preparado Deben tener activo propiedad 1     |
' |           No estar Inactivo y debe ser de Linea y debe tener Cod_Ant. |
' |      2.- Listado de Cojinerias que no llevan Preparado.               |
' |      3.- Listado de Preparados que no llevan Cojineria.               |
' =========================================================================
*/

Select OITM.ItemCode AS CODIGO
	, OITM.ItemName AS DESCRIPCION
	, OITM.InvntryUom AS UDM
	, Cast(OITM.U_VS as decimal(16,3)) AS VS
	, ISNULL(Cast(((
	Select SUM(ITT1.Quantity) 
	From ITT1 
	Inner Join OITM AC on ITT1.Code = AC.ItemCode and AC.U_GrupoPlanea = 6 and AC.InvntryUom like '%K%' 
	Where ITT1.Father = OITM.ItemCode) 
	/ ((
	
	Select SUM(ITT1.Quantity) 
	From ITT1 
	Where ITT1.Father = OITM.ItemCode) + (Select SUM(ITT1.Quantity) From ITT1 Inner Join OITM A1 on ITT1.Code = A1.ItemCode and A1.U_GrupoPlanea = 6 and A1.InvntryUom like '%K%' Where ITT1.Father = A1.ItemCode))) *
		(Select ALM.U_VS from OITM ALM Where ALM.ItemCode = (Select Top(1) ITT1.Father From ITT1 Where ITT1.Code = OITM.ItemCode)) as decimal(16,3)), 0) AS VS_CAL


	, A1.ItemCode AS CODIGO_P
	, A1.ItemName AS DESCRIPCION_P
	, A1.InvntryUom AS UDM_P

	, Cast(A1.U_VS as decimal(16,3)) AS VS_P

	, ISNULL(Cast(((
	Select SUM(ITT1.Quantity) From ITT1 Where ITT1.Father = A1.ItemCode) / ((Select SUM(ITT1.Quantity) From ITT1 Where ITT1.Father = OITM.ItemCode) + (Select SUM(ITT1.Quantity) From ITT1 Where ITT1.Father = A1.ItemCode))) *
		(Select ALM.U_VS from OITM ALM Where ALM.ItemCode = (Select Top(1) ITT1.Father From ITT1 Where ITT1.Code = OITM.ItemCode)) as decimal(16,3)),0) AS VS_P_CAL

	, Cast((Select ALM.U_VS from OITM ALM Where ALM.ItemCode = (Select Top(1) ITT1.Father From ITT1 Where ITT1.Code = OITM.ItemCode)) as decimal(16,3)) AS VS_MODEL
From OITM
Left Join OITM A1 on OITM.U_CodAnt = A1.ItemCode
Where OITM.QryGroup1 = 'Y' and OITM.frozenFor = 'N' and OITM.U_Linea = 01 and OITM.U_CodAnt <> 'NOUSA'

and OITM.ItemCode = '20552'

Order By OITM.ItemName



-- ================================================================================================
-- |  EXCEPCIONES MODULO 10 PARA CALCULO DE VALOR SALA A LOS HULE ESPUMA NO JUEGOS (NOUSA)        |
-- ================================================================================================
/*
' =========================================================================
' | Procedimiento:                                                        |
' |                                                                       |
' | Se procede con:                                                       |
' |      1.- Obtener el Listado de los Hules de NOUSAR y asignar el valor |
' |        que le corresponde por el mueble.                              |
' =========================================================================
*/

Select OITM.ItemCode AS CODIGO
	, OITM.ItemName AS DESCRIPCION
	, OITM.InvntryUom AS UDM
	, Cast(OITM.U_VS as decimal(16,3)) AS VS
	, Cast((Select ALM.U_VS from OITM ALM Where ALM.ItemCode = (Select Top(1) ITT1.Father From ITT1 Where ITT1.Code = OITM.ItemCode)) as decimal(16,3)) AS VS_MODEL		
From OITM
Left Join OITM A1 on OITM.U_CodAnt = A1.ItemCode
Where (OITM.QryGroup1 = 'Y' or OITM.QryGroup2 = 'Y') and OITM.frozenFor = 'N' and OITM.U_Linea = 01 and OITM.U_CodAnt = 'NOUSA'
and Cast(OITM.U_VS as decimal(16,3)) <>
Cast((Select ALM.U_VS from OITM ALM Where ALM.ItemCode = (Select Top(1) ITT1.Father From ITT1 Where ITT1.Code = OITM.ItemCode)) as decimal(16,3)) 
Order By OITM.ItemName

-- ================================================================================================
-- |  EXCEPCIONES MODULO 12 CALCULO DEL PESO DEL HULE PARA ASIGNAR AL CATALOGO MENOS 30%          |
-- ================================================================================================
/*
' =========================================================================
' | Procedimiento:                                                        |
' |                                                                       |
' | Se procede con:                                                       |
' |      1.- Obtener el Listado de los articulos hule espuma, calcular su |
' | contenido en kilos de hules y restar el 30% para asignar al peso del  |
' | articulo padre.                                                       |
' =========================================================================
*/

Select OITM.ItemCode AS CODIGO
	, OITM.ItemName AS DESCRIPCION
	, OITM.InvntryUom AS UDM
	, ISNULL(Cast(IWeight1 as decimal(16,3)), 0) AS PESO
	, ISNULL(Cast(TKGS.KG_LM*0.7 as decimal(16,3)), 0) AS PESO_LM
	, 'POR ACTUALIZAR' AS ACCION
	From OITM
Inner Join (Select ITT1.Father AS PADRE, SUM(ITT1.Quantity) KG_LM 
From ITT1 
Inner Join OITM A1 on ITT1.Code = A1.ItemCode and A1.U_GrupoPlanea = 6 and A1.InvntryUom like '%K%'
Group By ITT1.Father ) TKGS on TKGS.PADRE = OITM.ItemCode
Where OITM.ItmsGrpCod = 109 and ItemCode= '17979'
Order By OITM.ItemName

Select * from OITM Where ItemCode= '17979'


-- ================================================================================================
-- | FIN DEL PROYECTO.                                                                            |
-- ================================================================================================


--Aqui ttratar de llegar al modelo PT que los consume y realizar sumatoria

/*

(Select ALM.U_VS from OITM ALM Where ALM.ItemCode = (Select Top(1) ITT1.Father From ITT1 Where ITT1.Code = '17726')) 
Select Top(1) ITT1.Father From ITT1 Where ITT1.Code = '17726'
*/

--Select * from OITM Where OITM.U_CodAnt is null 



--and OITM.SWeight1 > 0
