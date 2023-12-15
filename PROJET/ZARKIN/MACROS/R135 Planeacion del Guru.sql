-- Macro Planeacion del Gurú.
-- Objetivo: Validar la planeacion en funcion a los Sub-Ensambles.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Jueves 27 de Julio del 2023; Origen.
-- Actualizado: Viernes 10 de Noviembre del 2023; Hacer dinamico mediante la Propiedad.

/* ==============================================================================================
|     PARAMETROS GENERALES.                                                                     |
============================================================================================== */

Declare @SubProd AS VarChar(20)

-- Set @SubProd = 'CASCO'	-- Cascos.
-- Set @SubProd = 'HABIL'	-- Habilitado de Carpinteria
-- Set @SubProd = 'PATAS'	-- Complementos de Madera Patas o Bastidores.
-- Set @SubProd = 'COMPL'	-- Cajas de Madera.
Set @SubProd = 'HULE'	-- Hule Espuma Fabricado.
-- Set @SubProd = 'REFA'	-- Refacciones Cintillos
-- Set @SubProd = 'ESTR'	-- Estructuras No Fabricables.
-- Set @SubProd = 'EMPA'	-- Empaque No Fabricables.

/* ==============================================================================================
|     DETALLE DE LA NECESIDAD.                                                                  |
============================================================================================== */

/*
Select BO.OP AS ID,  SUPO.COD_PADRE AS COD_PADRE, BO.Descripcion
	, SUPO.COD_MAT, SUPO.NOM_MAT, SUPO.CANT_MAT *BO.Cant AS CANT_MAT
	, SUPO.SUB_ENS
	, Case When BO.U_Starus = '01' then '010 Detenido Ventas.  ' When BO.U_Starus = '02' 
	then '020 Falta Informacion.' When BO.U_Starus = '03' then '030 Falta Piel o Tela.' 
	When BO.U_Starus = '04' then '040 Revision de Piel. ' 
	When BO.U_Starus = '05' then '050 Por Ordenar.      ' 
	When BO.U_Starus = '06' then BO.prefunda End AS AVANCE
	
	, BO.SEMANA3 AS SEM_P 
from SIZ_View_ReporteBO BO 
Left Join (Select T0.Father AS COD_PADRE, T3.ItemName AS NOM_PADRE, T3.U_TipoMat AS TIPO_PADRE, T1.ItemCode AS COD_MAT, T1.ItemName AS NOM_MAT, T0.Quantity AS CANT_MAT, T1.U_TipoMat AS TIPO_MAT, T1.U_GrupoPlanea AS PLANEA, Case When T1.QryGroup29 = 'Y' then 'CASCO' When T1.QryGroup30 = 'Y' then 'HABIL'
When T1.QryGroup31 = 'Y' then 'PATAS' When T1.QryGroup32 = 'Y' and T1.U_GrupoPlanea = '28' then 'COMPL' When T1.QryGroup32 = 'Y' and T1.U_GrupoPlanea = '6' then 'HULE' When T1.QryGroup32 = 'Y' and T1.U_GrupoPlanea = '13' then 'REFA' When T1.QryGroup32 = 'Y' and T1.U_GrupoPlanea = '4' then 'ESTR' When T1.QryGroup32 = 'Y' and T1.U_GrupoPlanea = '3' then 'EMPA' End AS SUB_ENS From ITT1 T0 Inner Join OITM T1 ON T0.Code = T1.ItemCode Inner join OITM T3 ON T0.father = T3.ItemCode Where T3.U_TipoMat = 'PT' and T3.InvntItem = 'Y' and (T1.QryGroup29 = 'Y' or T1.QryGroup30 = 'Y' or T1.QryGroup31 = 'Y' or T1.QryGroup32 = 'Y') Union All Select T0.Father AS COD_PADRE, T3.ItemName AS NOM_PADRE, T3.U_TipoMat AS TIPO_PADRE, NIV1.COD_MAT, NIV1.NOM_MAT, NIV1.CANT_MAT, NIV1.TIPO_MAT, NIV1.PLANEA, NIV1.SUB_ENS From ITT1 T0 
Inner Join OITM T1 ON T0.Code = T1.ItemCode Inner join OITM T3 ON T0.father = T3.ItemCode Inner join (Select U0.Father AS COD_PADRE, U3.ItemName AS NOM_PADRE, U3.U_TipoMat AS TIPO_PADRE, U1.ItemCode AS COD_MAT, U1.ItemName AS NOM_MAT, U0.Quantity AS CANT_MAT, U1.U_TipoMat AS TIPO_MAT, U1.U_GrupoPlanea AS PLANEA, Case When U1.QryGroup29 = 'Y' then 'CASCO' When U1.QryGroup30 = 'Y' then 'HABIL'	When U1.QryGroup31 = 'Y' then 'PATAS' When U1.QryGroup32 = 'Y' and U1.U_GrupoPlanea = '28' then 'COMPL' When U1.QryGroup32 = 'Y' and U1.U_GrupoPlanea = '6' then 'HULE' When U1.QryGroup32 = 'Y' and U1.U_GrupoPlanea = '13' then 'REFA' When U1.QryGroup32 = 'Y' and U1.U_GrupoPlanea = '4' then 'ESTR' When U1.QryGroup32 = 'Y' and U1.U_GrupoPlanea = '3' then 'EMPA' End AS SUB_ENS From ITT1 U0 Inner Join OITM U1 ON U0.Code = U1.ItemCode 
Inner join OITM U3 ON U0.father = U3.ItemCode Where U1.U_TipoMat <> 'GF' and (U1.QryGroup29 = 'Y' or U1.QryGroup30 = 'Y' or U1.QryGroup31 = 'Y' or U1.QryGroup32 = 'Y')) NIV1 on NIV1.COD_PADRE = T1.ItemCode Where T3.U_TipoMat = 'PT' and T3.InvntItem = 'Y' Union All Select T0.Father AS COD_PADRE, T3.ItemName AS NOM_PADRE, T3.U_TipoMat AS TIPO_PADRE, NIV2.COD_MAT, NIV2.NOM_MAT, NIV2.CANT_MAT, NIV2.TIPO_MAT, NIV2.PLANEA, NIV2.SUB_ENS From ITT1 T0 Inner Join OITM T1 ON T0.Code = T1.ItemCode Inner join OITM T3 ON T0.father = T3.ItemCode Inner join (Select U0.Father AS COD_PADRE, U3.ItemName AS NOM_PADRE, U3.U_TipoMat AS TIPO_PADRE, U1.ItemCode AS COD_MAT, U1.ItemName AS NOM_MAT, U0.Quantity AS CANT_MAT, U1.U_TipoMat AS TIPO_MAT, U1.U_GrupoPlanea AS PLANEA From ITT1 U0 Inner Join OITM U1 ON U0.Code = U1.ItemCode 
Inner join OITM U3 ON U0.father = U3.ItemCode Where U1.U_TipoMat <> 'GF' and (U1.QryGroup29 = 'Y' or U1.QryGroup30 = 'Y' or U1.QryGroup31 = 'Y' or U1.QryGroup32 = 'Y')) NIV1 on NIV1.COD_PADRE = T1.ItemCode Inner join (Select V0.Father AS COD_PADRE, V3.ItemName AS NOM_PADRE, V3.U_TipoMat AS TIPO_PADRE, V1.ItemCode AS COD_MAT, V1.ItemName AS NOM_MAT, V0.Quantity AS CANT_MAT, V1.U_TipoMat AS TIPO_MAT, V1.U_GrupoPlanea AS PLANEA, Case When V1.QryGroup29 = 'Y' then 'CASCO' When V1.QryGroup30 = 'Y' then 'HABIL' When V1.QryGroup31 = 'Y' then 'PATAS' When V1.QryGroup32 = 'Y' and V1.U_GrupoPlanea = '28' then 'COMPL' When V1.QryGroup32 = 'Y' and V1.U_GrupoPlanea = '6' then 'HULE' When V1.QryGroup32 = 'Y' and V1.U_GrupoPlanea = '13' then 'REFA' When V1.QryGroup32 = 'Y' and V1.U_GrupoPlanea = '4' then 'ESTR' When V1.QryGroup32 = 'Y' and V1.U_GrupoPlanea = '3' then 'EMPA'
End AS SUB_ENS From ITT1 V0 Inner Join OITM V1 ON V0.Code = V1.ItemCode Inner join OITM V3 ON V0.father = V3.ItemCode Where V1.U_TipoMat <> 'GF' and (V1.QryGroup29 = 'Y' or V1.QryGroup30 = 'Y'or V1.QryGroup31 = 'Y' or V1.QryGroup32 = 'Y')) NIV2 on NIV2.COD_PADRE = NIV1.COD_MAT Where T3.U_TipoMat = 'PT' and T3.InvntItem = 'Y') SUPO on SUPO.COD_PADRE = Left(BO.codigo1,4) + '-' + Right(BO.codigo1,2) + '-' + (BO.codigo3) Where SUPO.SUB_ENS = @SubProd Order by AVANCE Desc, SUPO.NOM_MAT 
*/

/* ==============================================================================================
|     RESUMEN DE LA NECESIDAD DEL SUBENSAMBLE.                                                                  |
============================================================================================== */
/*
Select SUPO.COD_MAT
	, SUPO.NOM_MAT
	, SUM(SUPO.CANT_MAT *BO.Cant) AS CANT_MAT
	, 0 AS TAPIZ
from SIZ_View_ReporteBO BO
Left Join (

-- Primer Nivel
Select T0.Father AS COD_PADRE
	, T3.ItemName AS NOM_PADRE
	, T3.U_TipoMat AS TIPO_PADRE
	, T1.ItemCode AS COD_MAT
	, T1.ItemName AS NOM_MAT
	, T0.Quantity AS CANT_MAT
	, T1.U_TipoMat AS TIPO_MAT
	, T1.U_GrupoPlanea AS PLANEA
	, Case
		When T1.QryGroup29 = 'Y' then 'CASCO' 
		When T1.QryGroup30 = 'Y' then 'HABIL'
		When T1.QryGroup31 = 'Y' then 'PATAS'
		When T1.QryGroup32 = 'Y' and T1.U_GrupoPlanea = '28' then 'COMPL'
		When T1.QryGroup32 = 'Y' and T1.U_GrupoPlanea = '6' then 'HULE'
		When T1.QryGroup32 = 'Y' and T1.U_GrupoPlanea = '13' then 'REFA'
		When T1.QryGroup32 = 'Y' and T1.U_GrupoPlanea = '4' then 'ESTR'
		When T1.QryGroup32 = 'Y' and T1.U_GrupoPlanea = '3' then 'EMPA'
	End AS SUB_ENS 
From ITT1 T0 
Inner Join OITM T1 ON T0.Code = T1.ItemCode 
Inner join OITM T3 ON T0.father = T3.ItemCode 
Where T3.U_TipoMat = 'PT' and T3.InvntItem = 'Y' 
and (T1.QryGroup29 = 'Y' or T1.QryGroup30 = 'Y' or T1.QryGroup31 = 'Y' or T1.QryGroup32 = 'Y')

Union All 

-- Segundo Nivel
Select T0.Father AS COD_PADRE
	, T3.ItemName AS NOM_PADRE
	, T3.U_TipoMat AS TIPO_PADRE
	, NIV1.COD_MAT
	, NIV1.NOM_MAT
	, NIV1.CANT_MAT
	, NIV1.TIPO_MAT
	, NIV1.PLANEA 
	, NIV1.SUB_ENS
From ITT1 T0 
Inner Join OITM T1 ON T0.Code = T1.ItemCode 
Inner join OITM T3 ON T0.father = T3.ItemCode 
Inner join (
Select U0.Father AS COD_PADRE
	, U3.ItemName AS NOM_PADRE
	, U3.U_TipoMat AS TIPO_PADRE
	, U1.ItemCode AS COD_MAT
	, U1.ItemName AS NOM_MAT
	, U0.Quantity AS CANT_MAT
	, U1.U_TipoMat AS TIPO_MAT
	, U1.U_GrupoPlanea AS PLANEA
	, Case
		When U1.QryGroup29 = 'Y' then 'CASCO' 
		When U1.QryGroup30 = 'Y' then 'HABIL'
		When U1.QryGroup31 = 'Y' then 'PATAS'
		When U1.QryGroup32 = 'Y' and U1.U_GrupoPlanea = '28' then 'COMPL'
		When U1.QryGroup32 = 'Y' and U1.U_GrupoPlanea = '6' then 'HULE'
		When U1.QryGroup32 = 'Y' and U1.U_GrupoPlanea = '13' then 'REFA'
		When U1.QryGroup32 = 'Y' and U1.U_GrupoPlanea = '4' then 'ESTR'
		When U1.QryGroup32 = 'Y' and U1.U_GrupoPlanea = '3' then 'EMPA'
	End AS SUB_ENS 
From ITT1 U0 
Inner Join OITM U1 ON U0.Code = U1.ItemCode 
Inner join OITM U3 ON U0.father = U3.ItemCode 
Where U1.U_TipoMat <> 'GF'
and (U1.QryGroup29 = 'Y' or U1.QryGroup30 = 'Y' or U1.QryGroup31 = 'Y' or U1.QryGroup32 = 'Y')
) NIV1 on NIV1.COD_PADRE = T1.ItemCode
Where T3.U_TipoMat = 'PT' and T3.InvntItem = 'Y' 

Union All

-- Tercer Nivel
Select T0.Father AS COD_PADRE
	, T3.ItemName AS NOM_PADRE
	, T3.U_TipoMat AS TIPO_PADRE
	, NIV2.COD_MAT
	, NIV2.NOM_MAT
	, NIV2.CANT_MAT
	, NIV2.TIPO_MAT
	, NIV2.PLANEA 
	, NIV2.SUB_ENS
From ITT1 T0 
Inner Join OITM T1 ON T0.Code = T1.ItemCode 
Inner join OITM T3 ON T0.father = T3.ItemCode 
Inner join (
Select U0.Father AS COD_PADRE
	, U3.ItemName AS NOM_PADRE
	, U3.U_TipoMat AS TIPO_PADRE
	, U1.ItemCode AS COD_MAT
	, U1.ItemName AS NOM_MAT
	, U0.Quantity AS CANT_MAT
	, U1.U_TipoMat AS TIPO_MAT
	, U1.U_GrupoPlanea AS PLANEA
From ITT1 U0 
Inner Join OITM U1 ON U0.Code = U1.ItemCode 
Inner join OITM U3 ON U0.father = U3.ItemCode 
Where U1.U_TipoMat <> 'GF'
and (U1.QryGroup29 = 'Y' or U1.QryGroup30 = 'Y' or U1.QryGroup31 = 'Y' or U1.QryGroup32 = 'Y')
) NIV1 on NIV1.COD_PADRE = T1.ItemCode
Inner join (
Select V0.Father AS COD_PADRE
	, V3.ItemName AS NOM_PADRE
	, V3.U_TipoMat AS TIPO_PADRE
	, V1.ItemCode AS COD_MAT
	, V1.ItemName AS NOM_MAT
	, V0.Quantity AS CANT_MAT
	, V1.U_TipoMat AS TIPO_MAT
	, V1.U_GrupoPlanea AS PLANEA
	, Case
		When V1.QryGroup29 = 'Y' then 'CASCO' 
		When V1.QryGroup30 = 'Y' then 'HABIL'
		When V1.QryGroup31 = 'Y' then 'PATAS'
		When V1.QryGroup32 = 'Y' and V1.U_GrupoPlanea = '28' then 'COMPL'
		When V1.QryGroup32 = 'Y' and V1.U_GrupoPlanea = '6' then 'HULE'
		When V1.QryGroup32 = 'Y' and V1.U_GrupoPlanea = '13' then 'REFA'
		When V1.QryGroup32 = 'Y' and V1.U_GrupoPlanea = '4' then 'ESTR'
		When V1.QryGroup32 = 'Y' and V1.U_GrupoPlanea = '3' then 'EMPA'
	 End AS SUB_ENS 
From ITT1 V0 
Inner Join OITM V1 ON V0.Code = V1.ItemCode 
Inner join OITM V3 ON V0.father = V3.ItemCode 
Where V1.U_TipoMat <> 'GF'
and (V1.QryGroup29 = 'Y' or V1.QryGroup30 = 'Y'or V1.QryGroup31 = 'Y' or V1.QryGroup32 = 'Y')
) NIV2 on NIV2.COD_PADRE = NIV1.COD_MAT
Where T3.U_TipoMat = 'PT' and T3.InvntItem = 'Y' 
) SUPO on SUPO.COD_PADRE = Left(BO.codigo1,4) + '-' + Right(BO.codigo1,2) + '-' + (BO.codigo3) 
Where SUPO.SUB_ENS = @SubProd 
Group by SUPO.COD_MAT, SUPO.NOM_MAT
Order by SUPO.NOM_MAT

*/
/* ==============================================================================================
|     NECESIDAD DEL SUBENSAMBLE A TOMAR COMO VIRTUAL.                                           |
============================================================================================== */
/*
Select SUPO.COD_MAT
	, SUPO.NOM_MAT
	, SUPO.SUB_ENS AS SUB_ENS
	, SUM(SUPO.CANT_MAT *BO.Cant) AS TAPIZ
from SIZ_View_ReporteBO BO
Left Join (

-- Primer Nivel
Select T0.Father AS COD_PADRE
	, T3.ItemName AS NOM_PADRE
	, T3.U_TipoMat AS TIPO_PADRE
	, T1.ItemCode AS COD_MAT
	, T1.ItemName AS NOM_MAT
	, T0.Quantity AS CANT_MAT
	, T1.U_TipoMat AS TIPO_MAT
	, T1.U_GrupoPlanea AS PLANEA
	, Case
		When T1.QryGroup29 = 'Y' then 'CASCO' 
		When T1.QryGroup30 = 'Y' then 'HABIL'
		When T1.QryGroup31 = 'Y' then 'PATAS'
		When T1.QryGroup32 = 'Y' and T1.U_GrupoPlanea = '28' then 'COMPL'
		When T1.QryGroup32 = 'Y' and T1.U_GrupoPlanea = '6' then 'HULE'
		When T1.QryGroup32 = 'Y' and T1.U_GrupoPlanea = '13' then 'REFA'
		When T1.QryGroup32 = 'Y' and T1.U_GrupoPlanea = '4' then 'ESTR'
		When T1.QryGroup32 = 'Y' and T1.U_GrupoPlanea = '3' then 'EMPA'
	End AS SUB_ENS 
From ITT1 T0 
Inner Join OITM T1 ON T0.Code = T1.ItemCode 
Inner join OITM T3 ON T0.father = T3.ItemCode 
Where T3.U_TipoMat = 'PT' and T3.InvntItem = 'Y' 
and (T1.QryGroup29 = 'Y' or T1.QryGroup30 = 'Y' or T1.QryGroup31 = 'Y' or T1.QryGroup32 = 'Y')

Union All 

-- Segundo Nivel
Select T0.Father AS COD_PADRE
	, T3.ItemName AS NOM_PADRE
	, T3.U_TipoMat AS TIPO_PADRE
	, NIV1.COD_MAT
	, NIV1.NOM_MAT
	, NIV1.CANT_MAT
	, NIV1.TIPO_MAT
	, NIV1.PLANEA 
	, NIV1.SUB_ENS
From ITT1 T0 
Inner Join OITM T1 ON T0.Code = T1.ItemCode 
Inner join OITM T3 ON T0.father = T3.ItemCode 
Inner join (
Select U0.Father AS COD_PADRE
	, U3.ItemName AS NOM_PADRE
	, U3.U_TipoMat AS TIPO_PADRE
	, U1.ItemCode AS COD_MAT
	, U1.ItemName AS NOM_MAT
	, U0.Quantity AS CANT_MAT
	, U1.U_TipoMat AS TIPO_MAT
	, U1.U_GrupoPlanea AS PLANEA
	, Case
		When U1.QryGroup29 = 'Y' then 'CASCO' 
		When U1.QryGroup30 = 'Y' then 'HABIL'
		When U1.QryGroup31 = 'Y' then 'PATAS'
		When U1.QryGroup32 = 'Y' and U1.U_GrupoPlanea = '28' then 'COMPL'
		When U1.QryGroup32 = 'Y' and U1.U_GrupoPlanea = '6' then 'HULE'
		When U1.QryGroup32 = 'Y' and U1.U_GrupoPlanea = '13' then 'REFA'
		When U1.QryGroup32 = 'Y' and U1.U_GrupoPlanea = '4' then 'ESTR'
		When U1.QryGroup32 = 'Y' and U1.U_GrupoPlanea = '3' then 'EMPA'
	End AS SUB_ENS 
From ITT1 U0 
Inner Join OITM U1 ON U0.Code = U1.ItemCode 
Inner join OITM U3 ON U0.father = U3.ItemCode 
Where U1.U_TipoMat <> 'GF'
and (U1.QryGroup29 = 'Y' or U1.QryGroup30 = 'Y' or U1.QryGroup31 = 'Y' or U1.QryGroup32 = 'Y')
) NIV1 on NIV1.COD_PADRE = T1.ItemCode
Where T3.U_TipoMat = 'PT' and T3.InvntItem = 'Y' 

Union All

-- Tercer Nivel
Select T0.Father AS COD_PADRE
	, T3.ItemName AS NOM_PADRE
	, T3.U_TipoMat AS TIPO_PADRE
	, NIV2.COD_MAT
	, NIV2.NOM_MAT
	, NIV2.CANT_MAT
	, NIV2.TIPO_MAT
	, NIV2.PLANEA 
	, NIV2.SUB_ENS
From ITT1 T0 
Inner Join OITM T1 ON T0.Code = T1.ItemCode 
Inner join OITM T3 ON T0.father = T3.ItemCode 
Inner join (
Select U0.Father AS COD_PADRE
	, U3.ItemName AS NOM_PADRE
	, U3.U_TipoMat AS TIPO_PADRE
	, U1.ItemCode AS COD_MAT
	, U1.ItemName AS NOM_MAT
	, U0.Quantity AS CANT_MAT
	, U1.U_TipoMat AS TIPO_MAT
	, U1.U_GrupoPlanea AS PLANEA
From ITT1 U0 
Inner Join OITM U1 ON U0.Code = U1.ItemCode 
Inner join OITM U3 ON U0.father = U3.ItemCode 
Where U1.U_TipoMat <> 'GF'
and (U1.QryGroup29 = 'Y' or U1.QryGroup30 = 'Y' or U1.QryGroup31 = 'Y' or U1.QryGroup32 = 'Y')
) NIV1 on NIV1.COD_PADRE = T1.ItemCode
Inner join (
Select V0.Father AS COD_PADRE
	, V3.ItemName AS NOM_PADRE
	, V3.U_TipoMat AS TIPO_PADRE
	, V1.ItemCode AS COD_MAT
	, V1.ItemName AS NOM_MAT
	, V0.Quantity AS CANT_MAT
	, V1.U_TipoMat AS TIPO_MAT
	, V1.U_GrupoPlanea AS PLANEA
	, Case
		When V1.QryGroup29 = 'Y' then 'CASCO' 
		When V1.QryGroup30 = 'Y' then 'HABIL'
		When V1.QryGroup31 = 'Y' then 'PATAS'
		When V1.QryGroup32 = 'Y' and V1.U_GrupoPlanea = '28' then 'COMPL'
		When V1.QryGroup32 = 'Y' and V1.U_GrupoPlanea = '6' then 'HULE'
		When V1.QryGroup32 = 'Y' and V1.U_GrupoPlanea = '13' then 'REFA'
		When V1.QryGroup32 = 'Y' and V1.U_GrupoPlanea = '4' then 'ESTR'
		When V1.QryGroup32 = 'Y' and V1.U_GrupoPlanea = '3' then 'EMPA'
	 End AS SUB_ENS 
From ITT1 V0 
Inner Join OITM V1 ON V0.Code = V1.ItemCode 
Inner join OITM V3 ON V0.father = V3.ItemCode 
Where V1.U_TipoMat <> 'GF'
and (V1.QryGroup29 = 'Y' or V1.QryGroup30 = 'Y'or V1.QryGroup31 = 'Y' or V1.QryGroup32 = 'Y')
) NIV2 on NIV2.COD_PADRE = NIV1.COD_MAT
Where T3.U_TipoMat = 'PT' and T3.InvntItem = 'Y' 
) SUPO on SUPO.COD_PADRE = Left(BO.codigo1,4) + '-' + Right(BO.codigo1,2) + '-' + (BO.codigo3) 
Where SUPO.SUB_ENS = @SubProd and Left(BO.prefunda, 3) > 148 
Group by SUPO.COD_MAT, SUPO.NOM_MAT, SUPO.SUB_ENS
Order by SUPO.NOM_MAT

*/
-- ================================================================================================
-- |     Existencia en Almacenes Resumen por Tipo de Material.                                    |
-- ================================================================================================
/*
Select INV.CODIGO
	, B0.ItemName AS DESCRIPCION
	, INV.EXI_ALMA AS EXI_ALMA
	, Case
		When B0.QryGroup29 = 'Y' then 'CASCO' 
		When B0.QryGroup30 = 'Y' then 'HABIL'
		When B0.QryGroup31 = 'Y' then 'PATAS'
		When B0.QryGroup32 = 'Y' and B0.U_GrupoPlanea = '28' then 'COMPL'
		When B0.QryGroup32 = 'Y' and B0.U_GrupoPlanea = '6' then 'HULE'
		When B0.QryGroup32 = 'Y' and B0.U_GrupoPlanea = '13' then 'REFA'
		When B0.QryGroup32 = 'Y' and B0.U_GrupoPlanea = '4' then 'ESTR'
		When B0.QryGroup32 = 'Y' and B0.U_GrupoPlanea = '3' then 'EMPA'
		When B0.QryGroup32 = 'Y' and B0.U_GrupoPlanea = '26' then 'MAQI'
	 End AS SUB_ENS 
From OITM B0 
Inner Join 
(Select B1.ItemCode AS CODIGO
	, SUM(B1.OnHand) AS EXI_ALMA
From OITW B1
Where (B1.WhsCode = 'AMP-ST' or B1.WhsCode = 'AMP-CC' or B1.WhsCode = 'APT-PA' or B1.WhsCode = 'APP-ST')
and  B1.OnHand > 0
Group By B1.ItemCode ) INV on INV.CODIGO = B0.ItemCode
Where (B0.QryGroup29 = 'Y' or B0.QryGroup30 = 'Y'or B0.QryGroup31 = 'Y' or B0.QryGroup32 = 'Y')
Order By B0.ItemName
*/

/* ==============================================================================================
|     ORDENES GENERADAS PARA LOS SUB-ENSAMBLES.                                                  |
============================================================================================== */
/*
Select W0.ItemCode AS CODIGO
	, W3.ItemName AS DESCRIPCION
	, QW1.CANT AS CANT
	, Case
		When W3.QryGroup29 = 'Y' then 'CASCO' 
		When W3.QryGroup30 = 'Y' then 'HABIL'
		When W3.QryGroup31 = 'Y' then 'PATAS'
		When W3.QryGroup32 = 'Y' and W3.U_GrupoPlanea = '28' then 'COMPL'
		When W3.QryGroup32 = 'Y' and W3.U_GrupoPlanea = '6' then 'HULE'
		When W3.QryGroup32 = 'Y' and W3.U_GrupoPlanea = '13' then 'REFA'
		When W3.QryGroup32 = 'Y' and W3.U_GrupoPlanea = '4' then 'ESTR'
		When W3.QryGroup32 = 'Y' and W3.U_GrupoPlanea = '3' then 'EMPA'
		When W3.QryGroup32 = 'Y' and W3.U_GrupoPlanea = '26' then 'MAQI'
	 End AS SUB_ENS 
From OWOR W0
Inner Join OITM W3 on W0.ItemCode = W3.ItemCode
Inner Join (
Select W1.ItemCode AS CODIGO,
	SUM(W1.PlannedQty) AS CANT
From OWOR W1 
Where W1.Status <> 'C' and W1.Status <> 'L'
Group By W1.ItemCode ) QW1 on QW1.CODIGO = W0.ItemCode

*/

-- ================================================================================================
-- |     DETALLE POR ALMACEN EXISTENCIA.                                                          |
-- ================================================================================================
/*
Select B1.WhsCode AS COD_ALMA
	, B2.WhsName AS ALMACEN
	, B0.ItemCode AS CODIGO
	, B0.ItemName AS DESCRIPCION
	, B0.InvntryUom AS UDM
	, B1.OnHand AS EXISTE
	, Case
		When B0.QryGroup29 = 'Y' then 'CASCO' 
		When B0.QryGroup30 = 'Y' then 'HABIL'
		When B0.QryGroup31 = 'Y' then 'PATAS'
		When B0.QryGroup32 = 'Y' and B0.U_GrupoPlanea = '28' then 'COMPL'
		When B0.QryGroup32 = 'Y' and B0.U_GrupoPlanea = '6' then 'HULE'
		When B0.QryGroup32 = 'Y' and B0.U_GrupoPlanea = '13' then 'REFA'
		When B0.QryGroup32 = 'Y' and B0.U_GrupoPlanea = '4' then 'ESTR'
		When B0.QryGroup32 = 'Y' and B0.U_GrupoPlanea = '3' then 'EMPA'
		When B0.QryGroup32 = 'Y' and B0.U_GrupoPlanea = '26' then 'MAQI'
	 End AS SUB_ENS 
From OITM B0 
inner join OITW B1 on B0.ItemCode = B1.ItemCode 
inner join OWHS B2 on B2.WhsCode = B1.WhsCode 
Where (B1.WhsCode = 'AMP-ST' or B1.WhsCode = 'AMP-CC' or B1.WhsCode = 'APT-PA' or B1.WhsCode = 'APP-ST')
and  B1.OnHand > 0
and (B0.QryGroup29 = 'Y' or B0.QryGroup30 = 'Y'or B0.QryGroup31 = 'Y' or B0.QryGroup32 = 'Y')
Order By ALMACEN, B0.ItemName

*/

/*================================================================================================
|     DETALLE DE OP PARA LOS SUB ENSAMBLES.                                                      |
================================================================================================*/


Select Case
	When C0.Status = 'P' then 'PLANIFICADO'
		When C0.Status = 'R' then 'LIBERADO'
	End AS ESTATUS
	, C0.DocEntry AS OP 
	, C0.ItemCode AS CODIGO
	, C1.ItemName AS DESCRIPCION
	
	, CP.U_Recibido-CP.U_Entregado AS CANTIDAD

	, (ISNULL(RT.Name,  
		Case 
		When C0.U_Starus = '01' then '010 Detenido Ventas.  '
		When C0.U_Starus = '02'	then '020 Falta Informacion.' 
		When C0.U_Starus = '03' then '030 Falta Piel o Tela.' 
		When C0.U_Starus = '04' then '040 Revision de Piel. ' 
		When C0.U_Starus = '05' then '050 Por Ordenar.      ' 
		When C0.U_Starus = '06' then  'Proceso de Fabricacion.'
		End
	)) AS AVANCE

	, C0.PostDate AS FEC_ELABORA
	, C0.DueDate AS FEC_TERMINO


		, Case
		When C1.QryGroup29 = 'Y' then 'CASCO' 
		When C1.QryGroup30 = 'Y' then 'HABIL'
		When C1.QryGroup31 = 'Y' then 'PATAS'
		When C1.QryGroup32 = 'Y' and C1.U_GrupoPlanea = '28' then 'COMPL'
		When C1.QryGroup32 = 'Y' and C1.U_GrupoPlanea = '6' then 'HULE'
		When C1.QryGroup32 = 'Y' and C1.U_GrupoPlanea = '13' then 'REFA'
		When C1.QryGroup32 = 'Y' and C1.U_GrupoPlanea = '4' then 'ESTR'
		When C1.QryGroup32 = 'Y' and C1.U_GrupoPlanea = '3' then 'EMPA'
		When C1.QryGroup32 = 'Y' and C1.U_GrupoPlanea = '26' then 'MAQI'
	 End AS SUB_ENS
	
From OWOR C0
inner join OITM C1 on C0.ItemCode = C1.ItemCode 
Left Join [@CP_OF] CP  on CP.U_DocEntry = C0.DocEntry 
Left Join [@PL_RUTAS] RT on CP.U_CT = RT.Code

Where C0.PlannedQty-C0.CmpltQty > 0 
and C0.Status <> 'C' and C0.Status <> 'L'
and C1.U_TipoMat <> 'PT' 
Order by DESCRIPCION,  OP, CANTIDAD Desc

