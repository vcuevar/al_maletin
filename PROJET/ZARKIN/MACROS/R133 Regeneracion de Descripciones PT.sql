-- R133 Regeneracion de Descripciones PT
-- Macro para restructura las descripciones en funcion a los Datos Llave.
-- Desarrollado: Ing. Vicente Cueva Ramírez.
-- Actualizado: Lunes 16 de Enero del 2023; Origen.

-- Relacion de Modelos.

Select OITM.ItemCode AS CODE
	, OITM.ItemName AS MODELO
	, OITB.ItmsGrpNam AS GRUPO
	, UFD1.Descr AS ESTATUS
From OITM
Inner Join OITB on OITM.ItmsGrpCod = OITB.ItmsGrpCod 
Left join UFD1 on OITM.U_Linea = UFD1.FldValue and UFD1.TableID = 'OITM' and UFD1.FieldID = 7
Where U_TipoMat = 'PT' and U_IsModel = 'S'
Order By OITM.ItemName

-- Relacion de Tipos de PT que tienen como base un modelo

Select Left(OITM.ItemCode, 7) AS CODE
	, OITM.ItemName AS DESCRIPCION
	, OITM.InvntryUom AS UDM
From OITM
Inner Join (Select A3.ItemCode, A3.ItemName From OITM A3 Where A3.U_IsModel = 'S') M on M.ItemCode = Left(OITM.ItemCode, 4)
Where OITM.U_TipoMat = 'PT' and Len(OITM.ItemCode) > 5 and OITM.frozenFor = 'N'
Order By OITM.ItemName

-- Relacion de Acabados

Select Distinct(CODIDATO) AS CODE
	, DESCDATO AS ACABADO
	, Len(DESCDATO) AS LARG
From SIZ_Acabados 
Order By DESCDATO 

-- Buscar Informacion del Acabdo.

Select Top(1) OITM.ItemCode AS CODE
	, OITM.ItemName AS ACABADO
	, OITB.ItmsGrpNam AS GRUPO
	, UFD1.Descr AS ESTATUS
From OITM
Inner Join OITB on OITM.ItmsGrpCod = OITB.ItmsGrpCod and OITM.ItmsGrpCod = 113
Left join UFD1 on OITM.U_Linea = UFD1.FldValue and UFD1.TableID = 'OITM' and UFD1.FieldID = 7
Where OITM.ItemName Like '%PIEL 0201 NEGRO%'
-- Where OITM.ItemName Like '%" & xNombre & "%'
Order By OITM.ItemName DESC

-- Sacar Catalogo de Acuerdo al Modelo Seleccionado

Select OITM.ItemCode AS CODE
	, OITM.ItemName AS MODELO
	, OITM.InvntryUom AS UDM
From OITM
Where U_TipoMat = 'PT' and OITM.U_IsModel = 'N' and Left(OITM.ItemCode,4) = '3448'
Order By OITM.ItemName





Select * From SIZ_Acabados Where CODIDATO = 'P0201'