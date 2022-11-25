-- Reporte de Excepciones EXCEPCIONES DEL AREA DE COMPRAS.
-- Elaborado: Vicente Cueva Ramirez.
-- Actualizado: 15 de Julio del 2019; Inicio.
-- Actualizado: 26 de Julio del 2021; SAP-10.


-- Asigna comprador a Materiales, segun tipo de Material.
-- SP		Sub-Productos		PL	Planeación
-- CA		Cascos				PL	Planeación
-- PT		Producto Terminado	PL	Planeación

-- MP		Materia Prima		KE	Depto de Compras
-- RF		Refacciones			KE	Depto de Compras
-- Solo estos se actualizaron el 15 de Julio, para que los actualice
-- Compras de acuerdo al Comprador.

-- Para CA, PT y SP cargar como comprador PL
	SELECT '005 ! COMPRADOR PL' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_Comprador
	from OITM 
	Where U_Comprador <> 'PL' and (U_TipoMat = 'CA' or U_TipoMat = 'SP' or U_TipoMat = 'PT')

	-- Para MP material Habilitados cargar a comprador PL
	SELECT '010 ! COMP. PL HAB' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_Comprador
	from OITM 
	Where QryGroup30 = 'Y' and U_Comprador <> 'PL'

-- Para MP material Patas de Madera cargar comprador PL
	SELECT '015 ! COMP. PL PATA' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_Comprador
	from OITM 
	Where QryGroup31 = 'Y' and U_Comprador <> 'PL'

	
-- Materias Primas y Refacciones  se cargan a KE (Se valida segun vayan dando de
-- alta los materiales ya que se supone que esto lo asignara compras.

	SELECT '020 ! COMP. KE ' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_Comprador
	from OITM 
	Where U_TipoMat = 'MP' and U_Comprador <> 'C1'

			

	SELECT '025 ! COMP. KE REF' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_Comprador
	from OITM 
	Where U_TipoMat = 'RF' and U_Comprador <> 'PL' and U_Comprador <> 'KE'


/* EXCEPCIONES DE PROVEEDORES SOLO PROVEEDORES ACTIVOS (frozenfor <> 'Y') */

-- Provedores sin lista de compras o equivocada.
	Select '004 SIN LISTA A-COMPRAS' AS REPORTE, OCRD.CardCode, OCRD.CardName, OCRD.CardType, OCRD.GroupCode, OCRD.ListNum
	from OCRD
	Where OCRD.CardType = 'S' and OCRD.ListNum <> 9

	Select '004 SIN LISTA A-COMPRAS' AS REPORTE, OCRD.CardCode, OCRD.CardName, OCRD.CardType, OCRD.GroupCode, OCRD.ListNum
	from OCRD
	Where OCRD.CardType = 'S' and OCRD.ListNum IS NULL

-- Actualizar los Tiempo de Entrega.
-- PT Tiempo de Entrega a 21 dias.

Select '014 LEAD 21 DIAS' AS REPORTE, OITM.ItemCode AS CODIGO, OITM.ItemName AS ARTICULO, OITM.LeadTime AS LEADTIME
From OITM 
Where OITM.U_TipoMat='PT' and OITM.LeadTime <> 21 or OITM.U_TipoMat='PT' and LeadTime is null and OITM.frozenFor='Y'
 
 -- Cascos Tiempo de Entrega a 7 días

 Select '016 LEAD 7 DIAS' AS REPORTE, OITM.ItemCode AS CODIGO, OITM.ItemName AS ARTICULO, OITM.LeadTime AS LEADTIME 
 From OITM 
 Where OITM.QryGroup29='Y'  and OITM.LeadTime <> 7 or OITM.QryGroup29='Y' and LeadTime is null and OITM.frozenFor='Y'
 
 -- Verificar que los Habilitado (Propiedad 30) tengan un Lead Time de 15 dias.

Select '018 LEAD 15 DIAS' AS REPORTE, OITM.ItemCode AS CODIGO, OITM.ItemName AS ARTICULO, OITM.LeadTime AS LEADTIME 
From OITM 
Where OITM.QryGroup30='Y'  and OITM.LeadTime <> 15 or OITM.QryGroup30='Y' and LeadTime is null and OITM.frozenFor='Y'

-- Verificar que los Complementos de Madera (Propiedad 31) tengan un Lead Time de 15 dias.

Select '020 LEAD 15 DIAS' AS REPORTE, OITM.ItemCode AS CODIGO, OITM.ItemName AS ARTICULO, OITM.LeadTime AS LEADTIME 
From OITM 
Where OITM.QryGroup31='Y'  and OITM.LeadTime <> 15 or OITM.QryGroup31='Y' and LeadTime is null and OITM.frozenFor='Y'


--< EOF > EXCEPCIONES DEL AREA DE COMPRAS.
