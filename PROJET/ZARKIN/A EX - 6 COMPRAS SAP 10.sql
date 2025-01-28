-- Reporte de Excepciones EXCEPCIONES DEL AREA DE COMPRAS.
-- Elaborado: Vicente Cueva Ramirez.
-- Actualizado: 15 de Julio del 2019; Inicio.
-- Actualizado: 26 de Julio del 2021; SAP-10.
-- Actualizado: 16 de Enero del 2026; Depurar

/* ================================================================================================
|    EXCEPCIONES ASIGNACION DE COMPRADOR AL ARTICULO.                                             |
================================================================================================= */

-- Asigna comprador a Materiales, segun tipo de Material.
-- SP		Sub-Productos		PL	Planeación
-- CA		Cascos				PL	Planeación
-- PT		Producto Terminado	PL	Planeación
-- HB		Habilitado			PL  Planeación
-- RF		Refacciones			PL  Planeación

-- MP		Materia Prima		C1	Depto de Compras
-- GF		Gastos Financieros  C1  Depto de Compras

-- Para CA, PT, HB y SP cargar como comprador PL
Select '001 COMPRADOR PL' AS REP_001
	, OITM.ItemCode AS CODIGO
	, OITM.ItemName AS ARTICULO
	, OITM.U_Comprador AS COMPRADOR
From OITM 
Where U_Comprador <> 'PL' and (U_TipoMat = 'CA' or U_TipoMat = 'SP' or U_TipoMat = 'PT' or U_TipoMat = 'HB' or U_TipoMat = 'RF')

-- Para MP y GF se asigna C1 Depto de Compras.
Select '003 COMPRADOR 1' AS REP_003
	, OITM.ItemCode AS CODIGO
	, OITM.ItemName AS ARTICULO
	, OITM.U_Comprador AS COMPRADOR
From OITM 
Where U_Comprador <> 'C1' and (U_TipoMat = 'MP' or U_TipoMat = 'GF')

/* ================================================================================================
|    EXCEPCIONES LISTA DE PRECIOS (PROVEEDORES ACTIVOS).                                          |
================================================================================================= */
	
-- Provedores sin lista de compras o equivocada.
Select '005 LISTA EQUIVOCADA' AS REP_005
	, OCRD.CardCode AS CODIGO
	, OCRD.CardName AS NOMBRE
	, OCRD.CardType AS TIPO
	, OCRD.GroupCode AS GRUPO
	, OCRD.ListNum AS L_PRECIOS
From OCRD
Where OCRD.CardType = 'S' and OCRD.ListNum <> 10

Select '007 SIN LISTA A-COMPRAS' AS REP_007
	, OCRD.CardCode AS CODIGO
	, OCRD.CardName AS NOMBRE
	, OCRD.CardType AS TIPO
	, OCRD.GroupCode AS GRUPO
	, OCRD.ListNum AS L_PRECIOS
From OCRD
Where OCRD.CardType = 'S' and OCRD.ListNum IS NULL

/* ================================================================================================
|    EXCEPCIONES ARTICULOS CON TIEMPO DE ENTREGA.                                                 |
================================================================================================= */

-- Articulos sin tiempo de entrega.
Select '009 NULL; 15 DIAS' AS REP_009
	, OITM.ItemCode AS CODIGO
	, OITM.ItemName AS ARTICULO
	, OITM.LeadTime AS LEADTIME
From OITM 
Where OITM.LeadTime is null and OITM.frozenFor = 'N'

-- Articulos PT Tiempo de Entrega a 21 dias.
Select '011 PT; 21 DIAS' AS REP_011
	, OITM.ItemCode AS CODIGO
	, OITM.ItemName AS ARTICULO
	, OITM.LeadTime AS LEADTIME
From OITM 
Where OITM.U_TipoMat = 'PT' and OITM.LeadTime <> 21 and OITM.frozenFor = 'N'
 
 -- Cascos Tiempo de Entrega a 7 días
Select '013 CA; 7 DIAS' AS REP_013
	, OITM.ItemCode AS CODIGO
	, OITM.ItemName AS ARTICULO
	, OITM.LeadTime AS LEADTIME 
From OITM 
Where OITM.U_TipoMat = 'CA' and OITM.LeadTime <> 7 and OITM.frozenFor = 'N'
 
 -- Habilitado Tiempo de Entrega a 15 dias.
Select '015 HB; 15 DIAS' AS REP_015
	, OITM.ItemCode AS CODIGO
	, OITM.ItemName AS ARTICULO
	, OITM.LeadTime AS LEADTIME 
From OITM 
Where OITM.U_TipoMat = 'HB' and OITM.LeadTime <> 15 and OITM.frozenFor = 'N'


-- Sub-Producto Tiempo de Entrega a 15 dias.
Select '017 SP; 15 DIAS' AS REP_017
	, OITM.ItemCode AS CODIGO
	, OITM.ItemName AS ARTICULO
	, OITM.LeadTime AS LEADTIME 
From OITM 
Where OITM.U_TipoMat = 'SP' and OITM.LeadTime <> 15 and OITM.frozenFor = 'N'
Order By OITM.ItemCode Desc



-- Sub-Producto Tiempo de Entrega.

-- CA		Cascos				7 dias
-- HB		Habilitado			15 dias
-- SP		Sub-Productos		15 dias
-- RF		Refacciones			15 dias
-- GF		Gastos Financieros  15 dias
-- PT		Producto Terminado	21 dias

-- MP		Materia Prima		Se define con Proveedor

Select OITM.ItemCode AS CODIGO
	, OITM.ItemName AS ARTICULO
	, OITM.InvntryUom AS UDM
	, OITM.LeadTime AS LEADTIME 
	, OITM.U_TipoMat AS TM
	, NLT.N_LT AS NEW_LT
	, 'POR ACTUALIZAR' AS ACCION
From OITM 
inner Join (
Select A5.ItemCode AS CODE
	, Case 
			When A5.U_TipoMat = 'CA' then 7 
			When A5.U_TipoMat = 'HB' then 15 
			When A5.U_TipoMat = 'SP' then 15 
			When A5.U_TipoMat = 'RF' then 15 
			When A5.U_TipoMat = 'GF' then 15 
			When A5.U_TipoMat = 'PT' then 21
	End AS N_LT
From OITM A5
Where A5.U_TipoMat <> 'MP') NLT on OITM.ItemCode = NLT.CODE
Where OITM.U_TipoMat <> 'MP' and OITM.LeadTime <> NLT.N_LT and OITM.LeadTime <> 15 and OITM.frozenFor = 'N'
Order By OITM.ItemCode Desc






--< EOF > EXCEPCIONES DEL AREA DE COMPRAS.
