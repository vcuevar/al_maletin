

-- Base de Datos para validar cambios de costos.
-- Estar pasando al Excel y de hay determinar que ajustes estar realizando.
/*
Select	OITM.ItemCode AS CODIGO,
		OITM.ItemName AS DESCRIPCION,
		OITM.InvntryUom AS UM,
		OITM.U_TipoMat AS TM,
		OITM.U_Linea AS LINE,				
		OITM.AvgPrice AS ESTANDAR,
		ITM1.Price as L_10,
		ISNULL((Select	SUM(ITT1.Quantity * ITT1.Price) From ITT1 
		where  ITT1.Father = OITM.ItemCode ),0) AS P_LDM,
		ISNULL(Case When OITM.LastPurCur = 'USD' then OITM.LastPurPrc * 20  
			When OITM.LastPurCur = 'CAN' then OITM.LastPurPrc * 15.14
			When OITM.LastPurCur = 'EUR' then OITM.LastPurPrc * 22.83
			When OITM.LastPurCur = 'MXP' then OITM.LastPurPrc * 1 end,0) AS P_UCOM,
		OITM.LastPurPrc AS U_COMP,
		ISNULL(OITM.LastPurCur,'MXP') AS U_MON,	
		Cast(OITM.LastPurDat AS DATE) AS F_UC,
		OITM.OnHand AS EXIS, 
		OITM.IsCommited AS COMP,
		OITM.OnOrder AS INORD
		--OITM.FrozenFor AS INACTIVO 
from OITM
inner join ITM1 on ITM1.ItemCode = OITM.ItemCode and ITM1.PriceList=10
where OITM.FrozenFor = 'N'

--and OITM.InvntItem = 'Y'
--and OITM.U_TipoMat = 'MP'
--and OITM.U_Linea = '01'
--and OITM.QryGroup31 = 'N' and OITM.QryGroup30 = 'N'
--and OITM.OnHand = 0
--and OITM.U_CodAnt <> 'NOUSA'
--and OITM.AvgPrice > 0.0001
Order by DESCRIPCION
*/ 

 

-- Hule Espuma de Preparado con contraparte de Cojineria dejas Conto a $ 0.0001
Select	OITM.ItemCode AS CODIGO,
		OITM.ItemName AS DESCRIPCION,
		OITM.InvntryUom AS UM,
		OITM.U_TipoMat AS TM,
		OITM.U_Linea AS LINE,				
		OITM.AvgPrice AS ESTANDAR,
		ITM1.Price as L_10,
		ISNULL((Select	SUM(ITT1.Quantity * ITT1.Price) From ITT1 
		where  ITT1.Father = OITM.ItemCode ),0) AS P_LDM,
		ISNULL(Case When OITM.LastPurCur = 'USD' then OITM.LastPurPrc * 20  
			When OITM.LastPurCur = 'CAN' then OITM.LastPurPrc * 15.14
			When OITM.LastPurCur = 'EUR' then OITM.LastPurPrc * 22.83
			When OITM.LastPurCur = 'MXP' then OITM.LastPurPrc * 1 end,0) AS P_UCOM,
		OITM.LastPurPrc AS U_COMP,
		ISNULL(OITM.LastPurCur,'MXP') AS U_MON,	
		Cast(OITM.LastPurDat AS DATE) AS F_UC,
		OITM.OnHand AS EXIS, 
		OITM.IsCommited AS COMP,
		OITM.OnOrder AS INORD
from OITM
inner join ITM1 on ITM1.ItemCode = OITM.ItemCode and ITM1.PriceList=10
where OITM.FrozenFor = 'N'
and OITM.InvntItem = 'Y'
and OITM.U_CodAnt <> 'NOUSA'
and OITM.AvgPrice > 0.0001
and OITM.OnHand = 0
and OITM.QryGroup2 = 'Y'




