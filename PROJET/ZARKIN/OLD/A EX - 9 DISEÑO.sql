-- Concentrado de Excepciones del Area de Siseño.
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Viernes 28 de Diciembre del 2018; Origen.
-- Actualizado: ;  Integrar Excepcion de 

--EX-DISEÑO
--	EX-DIS-001 Validar que los articulos modelos sean Tipo = PT 
		Select	'001 ? MODELOS NO SON PT' AS REPORTE, 
				OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat,
				OITM.U_VS, OITM.AvgPrice
		from OITM
		where  OITM.U_IsModel = 'S' 
		and OITM.U_TipoMat <> 'PT'
		order by OITM.ItemName

--	EX-DIS-005 Validar que los articulos modelos cuenten con Estandar de 0.0001 
		Select	'005 ? SIN ESTANDAR MODELO' AS REPORTE, 
				OITM.ItemCode, OITM.ItemName, OITM.U_TipoMat,
				OITM.U_VS, OITM.AvgPrice
		from OITM
		where  OITM.U_IsModel = 'S' 
		and OITM.AvgPrice <> 0.0001
		order by OITM.ItemName

--	EX-DIS-010 Validar que los articulos modelos no haya borrado la Descripcion 
		Select	'010 ? SIN DESCRIPCION' AS REPORTE, 
				OITM.ItemCode, Isnull(OITM.ItemName,'BORRARON DESCRIPCION'),
				OITM.U_TipoMat,
				OITM.U_VS, OITM.AvgPrice
		from OITM
		where  OITM.U_IsModel = 'S' 
		and OITM.ItemName Is Null 
		order by OITM.ItemName

--	EX-DIS-015 Validar que los articulos hule espuma (preparado) consuma estacion 415
		Select	'015 ! HE PREP->EST 415' AS REPORTE, 
				OITM.ItemCode, 
				OITM.ItemName,
				OITM.U_TipoMat,
				OITM.U_VS, OITM.AvgPrice
		from OITM
		where QryGroup2 = 'Y'  and U_estacion <> 415
		order by OITM.ItemName

		--Update OITM Set U_estacion = 415 where QryGroup2 = 'Y'  and U_estacion <> 415

--	EX-DIS-020 Validar que los articulos hule espuma (cojineria) consuma estacion 145
		Select	'020 ! HE COJIN->EST 145' AS REPORTE, 
				OITM.ItemCode, 
				OITM.ItemName,
				OITM.U_TipoMat,
				OITM.U_VS, OITM.AvgPrice
		from OITM
		where QryGroup1 = 'Y'  and U_estacion <> 145
		order by OITM.ItemName

		--Update OITM Set U_estacion = 145 where QryGroup1 = 'Y'  and U_estacion <> 145

--	EX-DIS-025 Validar que los articulos HABILITADO, consuma estacion 403
		Select	'025 ! HABIL->EST 403' AS REPORTE, 
				OITM.ItemCode, 
				OITM.ItemName,
				OITM.U_TipoMat,
				OITM.U_VS, OITM.AvgPrice
		from OITM
		where QryGroup30 = 'Y'  and U_estacion <> 403
		order by OITM.ItemName

		--Update OITM Set U_estacion = 403 where QryGroup30 = 'Y'  and U_estacion <> 403


--	EX-DIS-030 Validar que los articulos modelos Tengan LDM para que no los Borren (1 Pza 10121) 
		Select	'030 ? SIN LDM' AS REPORTE, 
				OITM.ItemCode,
				OITM.ItemName,
				OITM.U_TipoMat,
				OITM.U_VS, OITM.AvgPrice,
				ITT1.Father
		from OITM
		left join ITT1 on OITM.ItemCode = ITT1.Father 
		where  OITM.U_IsModel = 'S' 
		and ITT1.Father Is Null 
		order by OITM.ItemName

		
--	EX-DIS-035 Sin Almacen por Default 
		Select	'035 ? SIN ALMACEN DFT' AS REPORTE, 
				OITM.ItemCode,
				OITM.ItemName,
				OITM.U_TipoMat,
				OITM.DfltWH
		from OITM
		where  OITM.DfltWH is null  
		order by OITM.ItemName

		--Update OITM set OITM.DfltWH = 'AMP-CC' where  OITM.DfltWH is null 