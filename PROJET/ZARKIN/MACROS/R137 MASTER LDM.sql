-- Macro 137 Master de LDM
-- Objetivo: Manejo de LDM a traves un LDM Base calcular las variantes.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Viernes 29 de Diciembre del 2023; Origen.

/* ==============================================================================================
|     PARAMETROS GENERALES.                                                                     |
============================================================================================== */

Declare @FechaIS as Date
Declare @FechaFS as Date
Declare @xCodProd AS VarChar(20)

Set @FechaIS = CONVERT (DATE, '2023-12-04', 102)
Set @FechaFS = CONVERT (DATE, '2023-12-31', 102)

Set @xCodProd =  '3707-07-P0596'

/* ==============================================================================================
|  Presentar la LDM del Modelo seleccionado.                                                    |
============================================================================================== */

Select OITM.ItemCode AS CODIGO
	, OITM.ItemName AS MODELO
	, OITM.InvntryUom AS UDM
	, ITT1.Quantity AS CAN_BASE 
from ITT1 
inner join OITM on OITM.ItemCode = ITT1.Code 
where  ITT1.Father = @xCodProd
Order by MODELO