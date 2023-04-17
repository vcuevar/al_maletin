-- Consulta: Relacion de Articulos PT con LDM en piel 0301
-- Objetivo: Validar los modelos que se tienen para costos.
-- Desarrrollo: Ing. Vicente Cueva Ramirez.
-- Actualizado: Viernes 09 de Septiembre del 2022; Origen

-- Desarrollo del Reporte
-- Relacion de Modelos

Select OITM.ItemCode AS CODIGO
		, OITM.ItemName AS DESCRIPCION
From OITM
Where OITM.frozenFor = 'N' and OITM.U_TipoMat = 'PT' and OITM.U_Linea = '01'
and OITM.U_IsModel = 'S'
Order By OITM.ItemName

-- Relacion de Modelos Completa.

Select OITM.ItemCode AS CODIGO
		, OITM.ItemName AS DESCRIPCION
		, OITM.InvntryUom AS UDM	
		, ITT1.ItemName AS PIEL_NEGRO
		, (Select SUM(LM.PriceList) from ITT1 LM where LM.Father= OITM.ItemCode) AS LDM 
		, (Select SUM(LM.Quantity * LM.Price) from ITT1 LM where LM.Father = OITM.ItemCode) AS PRECIO_LDM
		, (Select LP1.Price from ITM1 LP1 Where ItemCode = OITM.ItemCode and PriceList = 1) AS PRECIO_DISEÑO
		, (Select LP10.Price from ITM1 LP10 Where ItemCode = OITM.ItemCode and PriceList = 10) AS PRECIO_STD
From OITM
Left Join ITT1 on ITT1.Father = OITM.ItemCode and ITT1.Code = '12826' 
Where OITM.frozenFor = 'N' and OITM.U_TipoMat = 'PT' and OITM.U_Linea = '01'
and OITM.U_IsModel = 'N' 
Order By OITM.ItemName




	

