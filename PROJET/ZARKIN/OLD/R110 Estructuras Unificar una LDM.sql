-- Reporte de LDM Generar una sola LDM.
-- Elaboro: Ing. vicente Cueva Ramirez.
-- Actualizado: Miercoles 31 de Marzo del 2021; Origen.

-- Consulta que obtiene datos del Articulo Padres.

Select oitm.ItemCode AS CODIGO, OITM.ItemName AS MATERIAL, InvntryUom AS UDM, RUTE.Name AS ESTACION, CONVERT(int, '1') AS CANTIDAD, 
ITM1.Price AS L_10,  (CONVERT(int, '1') * ITM1.Price) AS IMPORTE, ITM1.Currency AS MONEDA
from OITM 
inner join [@PL_RUTAS] RUTE on RUTE.Code = U_estacion 
inner join ITM1 on ITM1.ItemCode = OITM.ItemCode and ITM1.PriceList=10
where  OITM.ItemCode = '3831-62-B0109' 
Order by MATERIAL

-- Consulta que obtiene de un codigo los sub ensambles.

Select OITM.ItemCode AS CODIGO, OITM.ItemName AS MATERIAL, OITM.InvntryUom AS UDM, RUTE.Name AS ESTACION, ITT1.Quantity AS CANTIDAD 
, ITM1.Price AS L_10,  (ITT1.Quantity * ITM1.Price) AS IMPORTE, ITM1.Currency AS MONEDA
from ITT1 
inner join OITM on OITM.ItemCode = ITT1.Code 
inner join [@PL_RUTAS] RUTE on RUTE.Code = OITM.U_estacion 
inner join ITM1 on ITM1.ItemCode = OITM.ItemCode and ITM1.PriceList=10
where  ITT1.Father = '3831-62-B0109' and (OITM.QryGroup29 = 'Y' or OITM.QryGroup30 = 'Y' or OITM.QryGroup31 = 'Y' or OITM.QryGroup32 = 'Y')
Order by MATERIAL


-- Consulta que obtiene solo los materiales de un codigo, eSTA INCOMPLETA YA QUE EN LA MACRO SE AGREO MAS CAMPOS

Select OITM.ItemCode AS CODIGO, OITM.ItemName AS MATERIAL, OITM.InvntryUom AS UDM, RUTE.Name AS ESTACION, (ITT1.Quantity * 1) AS CANTIDAD 
, ITM1.Price AS L_10,  (ITT1.Quantity * ITM1.Price * 1) AS IMPORTE, ITM1.Currency AS MONEDA
from ITT1 
inner join OITM on OITM.ItemCode = ITT1.Code 
inner join [@PL_RUTAS] RUTE on RUTE.Code = OITM.U_estacion 
inner join ITM1 on ITM1.ItemCode = OITM.ItemCode and ITM1.PriceList=10
where  ITT1.Father = '3831-62-B0109' and OITM.QryGroup29 = 'N' and OITM.QryGroup30 = 'N' and OITM.QryGroup31 = 'N' and OITM.QryGroup32 = 'N'
Order by MATERIAL
