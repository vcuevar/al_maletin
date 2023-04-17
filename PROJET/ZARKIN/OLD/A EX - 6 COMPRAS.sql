-- Reporte de Excepciones para el area de Compras
-- Elaborado: Vicente Cueva Ramirez.
-- Actualizado: 15 de Julio del 2019; Inicio.


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

	-- Se corrige con 
	UPDATE OITM set U_Comprador='PL'
	Where U_Comprador <> 'PL' and (U_TipoMat = 'CA' or U_TipoMat = 'SP' or U_TipoMat = 'PT')

-- Para MP material Habilitados cargar a comprador PL
	SELECT '010 ! COMP. PL HAB' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_Comprador
	from OITM 
	Where QryGroup30 = 'Y' and U_Comprador <> 'PL'

	--Se corrige con
	UPDATE OITM set U_Comprador='PL'
	Where QryGroup30 = 'Y' and U_Comprador <> 'PL'			

-- Para MP material Patas de Madera cargar comprador PL
	SELECT '015 ! COMP. PL PATA' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_Comprador
	from OITM 
	Where QryGroup31 = 'Y' and U_Comprador <> 'PL'

	--Se corrige con
	UPDATE OITM set U_Comprador='PL'
	Where QryGroup31 = 'Y' and U_Comprador <> 'PL'

-- Materias Primas y Refacciones  se cargan a KE (Se valida segun vayan dando de
-- alta los materiales ya que se supone que esto lo asignara compras.

	SELECT '020 ! COMP. KE ' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_Comprador
	from OITM 
	Where U_TipoMat = 'MP' and U_Comprador <> 'PL' and U_Comprador <> 'KE'

	--Se corrige Manualmente se usa este Script para resetear todo a KE
	--UPDATE OITM set U_Comprador='KE'
	--Where U_TipoMat = 'MP' and U_Comprador <> 'PL' and U_Comprador <> 'KE'			

	SELECT '025 ! COMP. KE REF' AS REPORTE, OITM.ItemCode, OITM.ItemName, OITM.U_Comprador
	from OITM 
	Where U_TipoMat = 'RF' and U_Comprador <> 'PL' and U_Comprador <> 'KE'

	--Se corrige Manualmente se usa este Script para resetear todo a KE
	--UPDATE OITM set U_Comprador='KE'
	--Where U_TipoMat = 'RF' and U_Comprador <> 'PL' and U_Comprador <> 'KE'			




-- Fin del Archivo de Excepciones de Datos de Compras.