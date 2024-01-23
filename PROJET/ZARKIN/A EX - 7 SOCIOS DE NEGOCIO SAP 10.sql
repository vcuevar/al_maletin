-- Reporte de Excepciones EXCEPCIONES DE LOS SOCIOS DE NEGOCIOS.
-- Elaborado: Vicente Cueva Ramirez.
-- Actualizado: 15 de Julio del 2019; Inicio.
-- Actualizado: 26 de Julio del 2021; SAP-10.
-- Actualizado: 16 de Enero del 2024; Depurar.

/* ================================================================================================
|    EXCEPCIONES PARA PROVEEDORES.                                                                |
================================================================================================= */
	
-- Provedores sin lista de compras o equivocada. Deben tener Lista de Precios A-COMPRAS
Select '001 SIN LISTA A-VENTAS' AS REP_001
	, OCRD.CardCode
	, OCRD.CardName
	, OCRD.CardType
	, OCRD.GroupCode
	, OCRD.ListNum
from OCRD
Where OCRD.CardType = 'C' and OCRD.ListNum <> 2

/* ================================================================================================
|    EXCEPCIONES PARA CLIENTES.                                                                   |
================================================================================================= */
	
-- Clientes sin Canal de Distribucion asignado.
Select '003 CLIENTE SIN CANAL' AS REP_003
	, OCRD.CardCode
	,  OCRD.CardType
	, OCRD.CardName
	, OCRD.GroupCode
	, OCRG.GroupName
from OCRD 
inner join OCRG on OCRD.GroupCode=OCRG.GroupCode
where OCRD.GroupCode= '100' and OCRD.CardType <> 'L'
	
	
	

	
--< EOF > EXCEPCIONES DE SOCIOS DE NEGOCIOS.
