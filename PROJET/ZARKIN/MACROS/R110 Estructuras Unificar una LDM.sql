-- Reporte de LDM Generar una sola LDM.
-- Elaboro: Ing. vicente Cueva Ramirez.
-- Actualizado: Miercoles 31 de Marzo del 2021; Origen.

-- Consulta que obtiene datos del Articulo Padres.

Select oitm.ItemCode AS CODIGO, OITM.ItemName AS MATERIAL, InvntryUom AS UDM, RUTE.Name AS ESTACION, CONVERT(int, '1') AS CANTIDAD, 
ITM1.Price AS L_10,  (CONVERT(int, '1') * ITM1.Price) AS IMPORTE, ITM1.Currency AS MONEDA
from OITM 
inner join [@PL_RUTAS] RUTE on RUTE.Code = U_estacion 
inner join ITM1 on ITM1.ItemCode = OITM.ItemCode and ITM1.PriceList=10
where  OITM.ItemCode = '3642-02-P0301' 
Order by MATERIAL

-- Consulta que obtiene de un codigo los sub ensambles.

Select OITM.ItemCode AS CODIGO, OITM.ItemName AS MATERIAL, OITM.InvntryUom AS UDM, RUTE.Name AS ESTACION, ITT1.Quantity AS CANTIDAD 
, ITM1.Price AS L_10,  (ITT1.Quantity * ITM1.Price) AS IMPORTE, ITM1.Currency AS MONEDA
from ITT1 
inner join OITM on OITM.ItemCode = ITT1.Code 
inner join [@PL_RUTAS] RUTE on RUTE.Code = OITM.U_estacion 
inner join ITM1 on ITM1.ItemCode = OITM.ItemCode and ITM1.PriceList=10
where  ITT1.Father = '3642-02-P0301' and (OITM.QryGroup29 = 'Y' or OITM.QryGroup30 = 'Y' or OITM.QryGroup31 = 'Y' or OITM.QryGroup32 = 'Y')
Order by MATERIAL

-- Consulta que obtiene solo los materiales de un codigo, Se va Tomando los codigos del Indice.
Select	OITM.ItemCode AS CODIGO		
		, OITM.ItemName AS MATERIAL
		, OITM.InvntryUom AS UDM
		, RUTE.Name AS ESTACION
		, (ITT1.Quantity * 5 ) AS CANTIDAD
		, ITM1.Price AS L_10
		, (ITT1.Quantity * ITM1.Price * 5) AS IMPORTE
		, ITM1.Currency AS MONEDA
		, ITT1.Father AS ORIGEN 
		, OITM.U_SubModelo + ' ' +UFD1.Descr AS CLASIFICA
		, OITM.LastPurPrc AS ULT_PRE
		, OITM.LastPurCur AS ULT_MON
		, OITM.LastPurDat AS ULT_DAT
from ITT1 
inner join OITM on OITM.ItemCode = ITT1.Code 
inner join [@PL_RUTAS] RUTE on RUTE.Code = OITM.U_estacion 
inner join ITM1 on ITM1.ItemCode = OITM.ItemCode and ITM1.PriceList= 1
inner join UFD1 on OITM.U_SubModelo = UFD1.FldValue and UFD1.TableID = 'OITM'and UFD1.FieldID = 20 
where  ITT1.Father = '16721' and OITM.QryGroup29 = 'N' and OITM.QryGroup30 = 'N' and OITM.QryGroup31 = 'N' and OITM.QryGroup32 = 'N' 

Exec SIZ_MATERIALES_LDM_CODIGO '3642-02-P0301',1
Exec SIZ_MATERIALES_LDM_CODIGO '364202',1
Exec SIZ_MATERIALES_LDM_CODIGO '16721',1
Exec SIZ_MATERIALES_LDM_CODIGO '364202-H',1
Exec SIZ_MATERIALES_LDM_CODIGO '19078',1

