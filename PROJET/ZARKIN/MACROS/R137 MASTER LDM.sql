-- Macro 137 Master de LDM
-- Objetivo: Manejo de LDM a traves un LDM Base calcular las variantes.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Viernes 29 de Diciembre del 2023; Origen.

/* ==============================================================================================
|     PARAMETROS GENERALES.                                                                     |
============================================================================================== */
/*
Declare @xCodiBase AS VarChar(20)
Declare @xCodiNuev AS VarChar(20)
Declare @xCodiAcab AS VarChar(20)

Set @xCodiBase =  '3754-07-P0301'
Set @xCodiNuev =  '3754-07-P0699'
Set @xCodiAcab = Right(@xCodiNuev,5)

/* ==============================================================================================
|  Validar los codigo registrados.     Hoja 4 de Excel.                                               |
============================================================================================== */

Select OITM.ItemCode AS CODIGO
	, OITM.ItemName AS MODELO
	, OITM.frozenFor AS BLOQUEADO
From OITM
Where @xCodiBase  = OITM.ItemCode 
Order By MODELO

--Select OITM.ItemName AS MODELO From OITM Where @xCodiBase = OITM.ItemCode 

/* ==============================================================================================
|  Presentar la LDM del Modelo seleccionado con cambio de acabado.                                                    |
============================================================================================== */

Select A3.ItemCode AS CODE
	, A3.ItemName AS MODELO
	, Case When ACAB.Surtir is null then A1.ItemCode else ACAB.Surtir end AS CODIGO
	, Case When ACAB.Surtir is null then A1.ItemName else  A4.ItemName end AS MATERIAL
	, ITT1.Quantity AS CAN_BASE 
	, A1.InvntryUom AS UDM
	, 'APG-ST' AS ALMACEN
	, Case When A1.IssueMthd = 'B' then 'Notificación' else 'Manual' end AS METODO
	, '00 CALCULO DISEÑO' AS LDPRECIOS
	, Cast(Cast(ITM1.Price as decimal(14,4)) as varchar(20)) + ' ' + ITM1.Currency AS L_10
	, Cast(Cast(ITT1.Quantity * ITM1.Price as decimal(14,4)) as varchar(20)) + ' ' + ITM1.Currency AS TOTAL
	, RT.Name AS ESTACION
	, Cast(ITT1.Quantity * ITM1.Price as decimal(14,4)) AS IMPORTE
from ITT1 
inner join OITM A1 on A1.ItemCode = ITT1.Code 
Inner Join [@PL_RUTAS] RT on A1.U_Estacion = RT.Code
Inner Join OITM A3 on A3.ItemCode = ITT1.Father
inner join ITM1 on ITM1.ItemCode = A1.ItemCode and ITM1.PriceList=1
Left Join SIZ_Acabados ACAB on A1.ItemCode = ACAB.Arti and ACAB.CODIDATO = @xCodiAcab and ACAB.ACA_Eliminado = 0
Left Join OITM A4 on ACAB.Surtir = A4.ItemCode
where  ITT1.Father = @xCodiBase
Order by MATERIAL
*/


-- Consultas para Proyecto de SIZ Gestion de Modelos.
-- Objetivo: Modulo en SIZ para Generacion de Codigos en forma automatica.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Jueves 29 de febrero del 2024; Origen.

/* ==============================================================================================
|     LISTADO DE MODELOS PARA EDITAR.                                                                     |
============================================================================================== */

-- Tabla para los modelos
Select A3.ItemCode AS CODIGO
	, A3.ItemName AS MODELO
	, A3.U_Linea AS ESTADO
	, UFD1.Descr AS NOMB_Estado
From OITM A3
inner join UFD1 on A3.U_Linea= UFD1.FldValue and UFD1.TableID='OITM'and UFD1.FieldID=7
Where A3.U_TipoMat = 'PT' and A3.U_IsModel = 'S'
Order by A3.ItemName

-- Proximo Modelo
Select Top(1) A3.ItemCode AS ULTIMO
	, Cast(A3.ItemCode as int) + 1 AS NEW_CODE
From OITM A3
Where A3.U_TipoMat = 'PT' and A3.U_IsModel = 'S'
Order by A3.ItemCode Desc


select * from UFD1 Where 10 = UFD1.FldValue and UFD1.TableID='OITM'and UFD1.FieldID=7

-- Tabla para los muebles
Select Left(A3.ItemCode, 7) AS CODIGO
	, A3.ItemName AS MODELO
	, A3.U_Linea AS ESTADO
	, UFD1.Descr AS NOMB_Estado
From OITM A3
inner join UFD1 on A3.U_Linea= UFD1.FldValue and UFD1.TableID='OITM'and UFD1.FieldID=7
Where  A3.U_TipoMat = 'PT' and A3.U_IsModel = 'N'
Group By Left(A3.ItemCode, 7), A3.ItemName, A3.U_Linea, UFD1.Descr
Order by A3.ItemName

Left(A3.ItemCode,4) = '3881' and



-- Tabla para los acabados
Select Right(A3.ItemCode, 5) AS CODIGO
	, A3.ItemName AS MODELO
	, A3.U_Linea AS ESTADO
	, UFD1.Descr AS NOMB_Estado
From OITM A3
inner join UFD1 on A3.U_Linea= UFD1.FldValue and UFD1.TableID='OITM'and UFD1.FieldID=7
Where  A3.U_TipoMat = 'PT' and A3.U_IsModel = 'N'
--Group By Left(A3.ItemCode, 7), A3.ItemName, A3.U_Linea, UFD1.Descr
Order by A3.ItemName




Select * from SIZ_Acabados