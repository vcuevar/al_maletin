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
Where OITM.U_TipoMat = 'PT' and Len(OITM.ItemCode) > 5
Order By OITM.ItemName






Select OITM.ItemCode AS CODIGO, OITM.ItemName AS DESCRIPCION, OITM.InvntryUom AS UDM, 'PROTOTIPOS' AS NEW_NOMBRE FROM  OITM WHERE OITM.U_TipoMat = 'PT' AND OITM.U_IsModel = 'N' AND left(OITM.ItemCode,2) = 'ZA' and (OITM.FrgnName is null) 



Union All 

Select OITM.ItemCode AS CODIGO, OITM.ItemName AS DESCRIPCION, OITM.InvntryUom AS UDM, OITM.FrgnName AS NEW_NOMBRE FROM  OITM WHERE OITM.U_TipoMat = 'PT' and (OITM.FrgnName is null) AND OITM.U_IsModel = 'N' 






