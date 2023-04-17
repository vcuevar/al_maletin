-- Catalogo de Hules Espuma
-- Definiendo cuales tienen LDM
-- Desarrollado: Ing. Vicente Cueva Ramírez.
-- Actualizado: Lunes 23 de Enero del 2023.

-- Catalogo
Select OITM.ItemCode AS CODIGO
	, OITM.ItemName AS DESCRIPCION
	, Case When (Select top(1) ITT1.Father from ITT1 Where OITM.ItemCode = ITT1.Father ) is null then 'SIN_LDM' else 'CON_LDM' end AS LDM
From OITM
Where OITM.U_GrupoPlanea = '6'
