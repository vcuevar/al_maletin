-- 221116-5: Consulta para Catalogo de Productos terminados (Arie).
-- Desarrollado: Ing. Vicente Cueva Ramírez.
-- Actualizado: Miercoles 16 de Noviembre del 2022; Origen.

Select OITM.ItemCode AS CODIGO
	, 1 AS CONTADOR
	, OITM.ItemName AS MUEBLE
	, OITM.InvntryUom AS UDM
	, OITB.ItmsGrpNam AS GRUPO_ART
	, Case When OITM.frozenFor = 'Y' then 'BLOQUEADO' else 'ACTIVO' end AS ACTIVO
	, Case When OITM.U_Linea = '01' Then 'LINEA' else 'DESCONTINUADO' end AS ESTATUS
	, Case When (Select OITT.TreeType from OITT Where OITT.Code = OITM.ItemCode) is null then 'SIN LDM' else 'CON LISTA' end AS CON_LDM
	--, ISNULL((Select OITT.TreeType from OITT Where OITT.Code = OITM.ItemCode), 'X') AS TIPO_LDM
	--, Case When (Select OITT.TreeType from OITT Where OITT.Code = OITM.ItemCode) = 'P' then 'MUEBLE' else
	-- Case When (Select OITT.TreeType from OITT Where OITT.Code = OITM.ItemCode) = 'S' then 'JUEGO' else 'NO IDENTIFICADO' end end AS PRODUCTO
	, Case When  OITM.InvntryUom = 'PZA' then 'MUEBLE' else 'JUEGO SALA' end  AS PRODUCTO
from OITM
Inner join OITB on OITM.ItmsGrpCod = OITB.ItmsGrpCod
Where U_TipoMat = 'PT' and U_IsModel = 'N' and  OITM.InvntryUom <> 'ACT' and OITM.ItmsGrpCod <> '125' and OITM.ItmsGrpCod <> '136'
Order by OITM.ItemName

--Select * FROM OITB



--Select TreeType from OITT Where OITT.Code = '20301A1054'
--Select TreeType, * from OITT Where OITT.Code = '3840-03-P0301'
--3840-60-P0308