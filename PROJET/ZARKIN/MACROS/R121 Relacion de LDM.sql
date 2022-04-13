-- Nombre Reporte: R121 Relacion de LDM.
-- Solicito: Mauricio y Osiel de Diseño.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Martes 15 de Junio del 2021; Origen.

-- Variables: No requiere.


--Select Top (20) * from ITT1
--Select * from OITT

Select OITT.Code AS CODIGO
		, OITM.ItemName AS DESCRIPCION
		, OITM.InvntryUom AS UDM
		, Cast(OITT.CreateDate as date) AS FECH_CREADO
		, (Select U_NAME from OUSR Where OUSR.USERID = OITT.UserSign) as USUARIO
		--, Cast(OITT.UpdateDate as date) AS FECH_MODIF
		, ISNULL(ITT1.ItemName, 'S/C') AS INDICADOR 
From OITT
Left Join ITT1 on ITT1.Father = OITT.Code and ITT1.Code = '19043' 
Inner Join OITM on OITT.Code = OITM.ItemCode
Order By OITM.ItemName

Select * from OUSR



Select OITT.Code AS CODIGO, OITM.ItemName AS DESCRIPCION, OITM.InvntryUom AS UDM, Cast(OITT.CreateDate as date) AS FECH_CREADO, (Select U_NAME from OUSR Where OUSR.USERID = OITT.UserSign) as USUARIO, ISNULL(ITT1.ItemName, 'S/C') AS INDICADOR From OITT Left Join ITT1 on ITT1.Father = OITT.Code and ITT1.Code = '19043' Inner Join OITM on OITT.Code = OITM.ItemCode

