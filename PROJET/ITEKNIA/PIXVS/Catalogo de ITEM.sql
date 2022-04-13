-- Reporte para sacar los ITEM que les hace falta las cuentas contables de ventas.

-- Articulos de PT y Sub-Productos
	Select		A1.ART_CodigoArticulo as CODIGO, 
				A1.ART_Nombre as NOMBRE, 
				AF.AFAM_Nombre as FAMILIA, 
				AC.ACAT_Nombre as CATEGORIA,
				AT.ATP_Descripcion as TIPO, 
				UM.CMUM_Nombre as UM_Inv, 
				A1.ART_Activo ACTIVO_1, 
				A1.ART_CMM_CtaVentaId as C_VENTAS,
				A1.ART_CMM_CtaInventarioId as C_INVENTARIO,
				A1.ART_CMM_CtaCostoVentaId as C_COSTOS,
				A1.ART_FechaCreacion,
				(EM.EMP_Nombre + ' ' + EM.EMP_PrimerApellido) as MODIFICADO  
	from Articulos A1
	left join ArticulosFamilias AF on A1.ART_AFAM_FamiliaId = AF.AFAM_FamiliaId 
	left join ArticulosCategorias AC on A1.ART_ACAT_CategoriaId= AC.ACAT_CategoriaId
	left join ArticulosTipos AT on A1.ART_ATP_TipoId = AT.ATP_TipoId 
	left join ControlesMaestrosUM UM on A1.ART_CMUM_UMInventarioId = UM.CMUM_UnidadMedidaId
	left join Empleados EM on A1.ART_EMP_ModificadoPor = EM.EMP_EmpleadoId 

	where A1.ART_Activo  <> 0 and A1.ART_CodigoArticulo like 'IT%'
	order by  A1.ART_FechaCreacion, A1.ART_Nombre


	--select * from Articulos where ART_Activo  <> 0 and ART_CodigoArticulo like 'IT%'

	--select * from ControlesMaestrosMultiples where CMM_ControllId = '5147619C-6B33-4F19-A057-CD193104E2FC'

	--select * from CuentasContables  where CC_CodigoId = '5147619C-6B33-4F19-A057-CD193104E2FC'