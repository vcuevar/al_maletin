-- Consulta para Obtener Datos de la ficha de Articulos.
-- Desarrollo: Ing. Vicente Cueva Ramírez.
-- Actualizado: Miercoles 23 de Diciembre del 2020.


-- Consulta de Materias Primas.

Select	ItemCode,
		ItemName,
		FrgnName,
		DfltWH,
		CardCode,
		BuyUnitMsr,
		NumInBuy,
		SalUnitMsr,
		QryGroup1,
		QryGroup2,
		QryGroup29,
		QryGroup30,
		QryGroup31,
		QryGroup32,
		AvgPrice,
		PurPackMsr,
		PurPackUn,
		SalPackMsr,
		IssueMthd,	
		InvntryUom,
		LeadTime,
		U_estacion,	
		U_IsModel,
		U_CodAnt,	
		U_Ruta,	
		U_VS,	
		U_Comprador,	
		U_TipoMat,
		U_Linea,
		U_Metodo,
		U_GrupoPlanea,
		U_ReOrden,	
		U_Maximo,	
		U_Minimo,	
		U_VerReporte,
		U_Utiliza_CCE,
		U_ClaveProdServ,	
		U_ClaveUnidad,	
		U_FraccAran,	
		U_UnidadAduana,	
		U_Marca,	
		U_SubModelo,	
		U_NumeroSerie 
from OITM




update OITM	ItemCode = '',
		ItemName,
		FrgnName,
		DfltWH,
		CardCode,
		BuyUnitMsr,
		NumInBuy,
		SalUnitMsr,
		QryGroup1,
		QryGroup2,
		QryGroup29,
		QryGroup30,
		QryGroup31,
		QryGroup32,
		AvgPrice,
		PurPackMsr,
		PurPackUn,
		SalPackMsr,
		IssueMthd,	
		InvntryUom,
		LeadTime,
		U_estacion,	
		U_IsModel,
		U_CodAnt,	
		U_Ruta,	
		U_VS,	
		U_Comprador,	
		U_TipoMat,
		U_Linea,
		U_Metodo,
		U_GrupoPlanea,
		U_ReOrden,	
		U_Maximo,	
		U_Minimo,	
		U_VerReporte,
		U_Utiliza_CCE,
		U_ClaveProdServ,	
		U_ClaveUnidad,	
		U_FraccAran,	
		U_UnidadAduana,	
		U_Marca,	
		U_SubModelo,	
		U_NumeroSerie 
Where ItemCode = '1000001'










