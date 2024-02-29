-- Macro 137 Master de LDM
-- Objetivo: Manejo de LDM a traves un LDM Base calcular las variantes.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Viernes 29 de Diciembre del 2023; Origen.

/* ==============================================================================================
|     PARAMETROS GENERALES.                                                                     |
============================================================================================== */

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

Select * from SIZ_Acabados

