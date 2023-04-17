SELECT 
	OV_OrdenVentaId , 
	OV_CodigoOV , 
	OV_FechaOV , 
	Case When OV_FechaOV IS NULL Then '9000' Else DATEPART(WK, OV_FechaOV) END AS SEMANA,
	OV_Comentarios , 
	OV_ReferenciaOC , 
	OV_CMM_EstadoOVId , 
	OV_EmbarqueCompleto , 
	STATUS_OV , 
	CLI_ClienteId , 
	CLI_CodigoCliente , 
	CLI_RazonSocial , 
	DOMICILIOFACTURAR , 
	CPEFACTURAR , 
	CPTFACTURAR , 
	CDE_Nombre , 
	DOMICILIO , 
	CPE , 
	CPT , 
	CONTACTOEMBARQUE , 
	CONTACTOOV , 
	MON_MonedaId , 
	MON_Nombre , 
	OV_MONP_Paridad ,
	TRANSPORTE , 
	CONDICIONES , 
	COT_CodigoCOT , 
	NOMBRE , 
	COD_EMP , 
	CMDSC_TermsDescuento , 
	OV_EMP_ModificadoPor , 
	EV_CodigoEvento , 
	EV_Descripcion , 
	OVD_OVDetalleId , 
	OVD_NumeroLinea , 
	OVD_TipoDetalle , 
	ART_ArticuloId , 
	ART_CodigoArticulo , 
	ART_GLN AS INSUMO,
	SUBSTRING(ART_GLN,8,20) AS COD,
	ART_Nombre , 
	ACAT_Nombre , 
	ACAT_CategoriaId , 
	OVD_ART_Nombre , 
	OVD_CMUM_Nombre , 
	OVR_PrecioUnitario , 
	SUBTOTAL , 
	DESCUENTO , 
	( SUBTOTAL - DESCUENTO ) * ISNULL ( OVD_CMIVA_Porcentaje , 0.0 ) AS IVA , 
	OVD_CMIVA_Porcentaje , 
	( SUBTOTAL - DESCUENTO ) * ( 1 + ISNULL ( OVD_CMIVA_Porcentaje , 0.0 ) ) AS TOTAL , 
	SUM(( SUBTOTAL - DESCUENTO ) * ( 1 + ISNULL ( OVD_CMIVA_Porcentaje , 0.0 ) )) OVER (PARTITION BY OV_OrdenVentaId) AS TOTALOV, 
	OVR_FechaPromesa , 
	OVR_FechaRequerida , 
	OVR_CantidadRequerida , 
	OVD_Comentario , 
	OVD_COMENTARIOS , 
	OVD_InstEspeciales , 
	EMB_CodigoEmbarque , 
	ISNULL ( CANTIDAD_EMBARCADA , 0.0 ) AS CANTIDAD_EMBARCADA , 
	OVR_CantidadRequerida - ISNULL ( CANTIDAD_EMBARCADA , 0.0 ) AS CANTIDAD_POR_EMBARCAR , 
	FTR_NumeroFactura , 
	CANTIDAD_FACTURADA , 
	CANTIDAD_POR_FACTURAR 
FROM ( 
		SELECT 
				OV_OrdenVentaId , 
				OV_CodigoOV , 
				OV_FechaOV , 
				OV_Comentarios , 
				OV_ReferenciaOC , 
				OV_CMM_EstadoOVId , 
				OV_EmbarqueCompleto ,
				OV_MONP_Paridad, 
				ESTADO_OV.CMM_Valor AS STATUS_OV , 
				CLI_ClienteId , 
				CLI_CodigoCliente , 
				CLI_RazonSocial , 
				CASE WHEN CLI_Domicilio IS NULL OR CLI_Domicilio = '' THEN '' ELSE UPPER ( CLI_Domicilio ) END + 
				CASE WHEN CLI_Colonia IS NULL OR CLI_Colonia = '' THEN '' ELSE + ' , ' + UPPER ( CLI_Colonia ) END + 
				CASE WHEN CLI_NoExt IS NULL OR CLI_NoExt = '' THEN '' ELSE ' ' + UPPER ( CLI_NoExt ) END + 
				CASE WHEN CLI_NoInt IS NULL OR CLI_NoInt = '' THEN '' ELSE ' - ' + UPPER ( CLI_NoInt ) END DOMICILIOFACTURAR , 
				CASE WHEN CIU_Nombre IS NULL OR CIU_Nombre = '' THEN '' ELSE UPPER ( CIU_Nombre ) + ' , ' END + 
				CASE WHEN EST_Nombre IS NULL OR EST_Nombre = '' THEN '' ELSE UPPER ( EST_Nombre ) + ' , ' END + 
				CASE WHEN PAI_Nombre IS NULL OR PAI_Nombre = '' THEN '' ELSE UPPER ( PAI_Nombre ) + ' ' END CPEFACTURAR , 
				CASE WHEN CLI_CodigoPostal IS NULL OR CLI_CodigoPostal = '' THEN '' ELSE 'C.P : ' + CLI_CodigoPostal END + 
				CASE WHEN CLI_Telefono IS NULL OR CLI_Telefono = '' THEN '' ELSE ' TELEFONO : ' + CLI_Telefono END AS CPTFACTURAR , 
				CDE_Nombre , 
				DOMICILIO , 
				CPE , 
				CPT , 
				CONTACTOEMBARQUE , 
				CCON_Nombre AS CONTACTOOV , 
				MON_MonedaId , 
				MON_Nombre , 
				EMBARQUEOV.CMM_Valor AS TRANSPORTE , 
				LIBREABORDO.CMM_Valor AS CONDICIONES , 
				COT_CodigoCOT , 
				ISNULL ( EMP_Nombre , '' ) + SPACE ( 1 ) + ISNULL ( EMP_PrimerApellido , '' ) + SPACE ( 1 ) + ISNULL ( EMP_SegundoApellido , '' ) AS NOMBRE , 
				EMP_CodigoEmpleado AS COD_EMP , 
				CMDSC_TermsDescuento , 
				OV_EMP_ModificadoPor , 
				EV_CodigoEvento , 
				EV_Descripcion , 
				OVD_OVDetalleId , 
				OVD_NumeroLinea , 
				OVD_TipoDetalle , 
				ART_ArticuloId , 
				ART_CodigoArticulo , 
				ART_GLN,
				ART_Nombre , 
				ACAT_Nombre , 
				ACAT_CategoriaId , 
				OVD_ART_Nombre , 
				OVD_CMUM_Nombre , 
				OVR_PrecioUnitario , 
				OVR_CantidadRequerida * OVR_PrecioUnitario AS SUBTOTAL , 
				OVR_CantidadRequerida * OVR_PrecioUnitario * ISNULL ( OVD_PorcentajeDescuento , 0.0 ) AS DESCUENTO , 
				OVD_CMIVA_Porcentaje , 
				OVR_FechaPromesa , 
				OVR_FechaRequerida , 
				OVR_CantidadRequerida , 
				OVD_Comentario , 
				OVD_COMENTARIOS , 
				OVD_InstEspeciales , 
				dbo.getCodigosEmbarques ( OVR_OVRequeridaId ) AS EMB_CodigoEmbarque , 
				dbo.getFechasEmbarques ( OVR_OVRequeridaId ) AS EMB_FechaEmbarque , 
				ISNULL ( CANTIDAD_EMBARCADA , 0.0 ) AS CANTIDAD_EMBARCADA , 
				OVR_CantidadRequerida - ISNULL ( CANTIDAD_EMBARCADA , 0.0 ) AS CANTIDAD_POR_EMBARCAR , 
				dbo.getCodigosFactura ( OVR_OVRequeridaId ) AS FTR_NumeroFactura , 
				CASE WHEN ISNULL ( CANTIDAD_EMBARCADA , 0.0 ) - ISNULL ( CANTIDAD_FACTURADA , 0.0 ) < 0 THEN 0.0 ELSE ISNULL ( CANTIDAD_FACTURADA , 0.0 ) END AS CANTIDAD_FACTURADA , 
				CASE WHEN ISNULL ( CANTIDAD_EMBARCADA , 0.0 ) - ISNULL ( CANTIDAD_FACTURADA , 0.0 ) < 0 THEN ISNULL ( CANTIDAD_FACTURADA , 0.0 ) ELSE ISNULL ( CANTIDAD_EMBARCADA , 0.0 ) - ISNULL ( CANTIDAD_FACTURADA , 0.0 ) END AS CANTIDAD_POR_FACTURAR 
		FROM OrdenesVenta 
		INNER JOIN OrdenesVentaDetalle ON OV_OrdenVentaId = OVD_OrdenVentaId 
		INNER JOIN OrdenesVentaReq ON OVR_OVDetalleId = OVD_OVDetalleId AND OV_OrdenVentaId = OVD_OrdenVentaId 
		LEFT JOIN Articulos ON OVD_ART_ArticuloId = ART_ArticuloId 
		LEFT JOIN ArticulosCategorias ON ART_ACAT_CategoriaId = ACAT_CategoriaId 
		INNER JOIN Clientes ON OV_CLI_ClienteId = CLI_ClienteId 
		INNER JOIN Ciudades ON CLI_CIU_CiudadId = CIU_CiudadIId 
		INNER JOIN Estados ON CIU_EST_EstadoIId = EST_EstadoIId 
		INNER JOIN Paises ON EST_PAI_PaisIId = PAI_PaisIId 
		INNER JOIN ControlesMaestrosMultiples ESTADO_OV ON OV_CMM_EstadoOVId = ESTADO_OV.CMM_ControllId 
		INNER JOIN Monedas ON OV_MON_MonedaId = MON_MonedaId 
		INNER JOIN ClientesContactos ON OV_CCON_ContactoId = CCON_ContactoId AND CCON_Borrado = 0 
		LEFT JOIN Eventos ON EV_EventoId = OV_EV_EventoId 
		INNER JOIN Empleados ON EMP_EmpleadoId = OV_EMP_ModificadoPor 
		LEFT JOIN ControlesMaestrosMultiples EMBARQUEOV ON OV_CMM_MetodoEmbarque = EMBARQUEOV.CMM_ControllId 
		LEFT JOIN ControlesMaestrosMultiples LIBREABORDO ON OV_CMM_LibreABordo = LIBREABORDO.CMM_ControllId 
		LEFT JOIN ControlesMaestrosDSC ON CMDSC_CodigoId = OV_CMDSC_CodigoId 
		LEFT JOIN Cotizaciones ON COT_CotizacionId = OV_COT_CotizacionId 
		LEFT JOIN ( 
					SELECT 
							CDE_DireccionEmbarqueId , 
							UPPER ( CDE_Nombre ) AS CDE_Nombre , 
							CASE WHEN CDE_Domicilio IS NULL OR CDE_Domicilio = '' THEN '' ELSE UPPER ( CDE_Domicilio ) END + 
							CASE WHEN CDE_Colonia IS NULL OR CDE_Colonia = '' THEN '' ELSE + ' , ' + UPPER ( CDE_Colonia ) END + 
							CASE WHEN CDE_NoExt IS NULL OR CDE_NoExt = '' THEN '' ELSE ' ' + UPPER ( CDE_NoExt ) END + 
							CASE WHEN CDE_NoInt IS NULL OR CDE_NoInt = '' THEN '' ELSE ' - ' + UPPER ( CDE_NoInt ) END DOMICILIO , 
							CASE WHEN CIU_Nombre IS NULL OR CIU_Nombre = '' THEN '' ELSE UPPER ( CIU_Nombre ) + ' , ' END + 
							CASE WHEN EST_Nombre IS NULL OR EST_Nombre = '' THEN '' ELSE UPPER ( EST_Nombre ) + ' , ' END + 
							CASE WHEN PAI_Nombre IS NULL OR PAI_Nombre = '' THEN '' ELSE UPPER ( PAI_Nombre ) + ' ' END CPE , 
							CASE WHEN CDE_CodigoPostal IS NULL OR CDE_CodigoPostal = '' THEN '' ELSE 'C.P : ' + CDE_CodigoPostal END + 
							CASE WHEN CDE_Telefono IS NULL OR CDE_Telefono = '' THEN '' ELSE ' TELEFONO : ' + CDE_Telefono END AS CPT , 
							UPPER ( CCON_Nombre ) AS CONTACTOEMBARQUE 
					FROM ClientesDireccionesEmbarques 
					LEFT JOIN Ciudades ON CDE_CIU_CiudadId = CIU_CiudadIId 
					LEFT JOIN Estados ON CIU_EST_EstadoIId = EST_EstadoIId 
					LEFT JOIN Paises ON EST_PAI_PaisIId = PAI_PaisIId 
					LEFT JOIN ClientesContactos ON CDE_CCON_ContactoId = CCON_ContactoId ) AS DIRECCIONESEMBARQUES ON OV_CDE_DireccionEmbarqueId = CDE_DireccionEmbarqueId 
		LEFT JOIN ( 
					SELECT 
							EMBD_OVR_OVREQUERIDAID , 
							SUM ( EMBD_CantidadEmbarcada ) AS CANTIDAD_EMBARCADA 
					FROM EmbarquesDetalle 
					INNER JOIN Embarques ON EMBD_EMBARQUEID = EMB_EMBARQUEID 
					GROUP BY 
							EMBD_OVR_OVREQUERIDAID 
		) AS Embarques ON OVR_OVRequeridaId = EMBD_OVR_OVREQUERIDAID 
		LEFT JOIN ( 
					SELECT 
							FTRR_ReferenciaId , 
							SUM ( FTRR_CantidadRequerida ) AS CANTIDAD_FACTURADA 
					FROM Facturas 
					INNER JOIN FacturasReq ON FTR_FacturaId = FTRR_FTR_FacturaId 
					WHERE FTR_Eliminado = 0 
					GROUP BY 
							FTRR_ReferenciaId 
		) AS Facturas ON OVR_OVRequeridaId = FTRR_ReferenciaId  
		WHERE OV_Borrado = 0 
	) AS TEMP 
WHERE CANTIDAD_POR_EMBARCAR != 0  AND OV_CMM_EstadoOVId <> '2B53F727-33FC-4A1F-90C6-7B8A7B713CDA' 
ORDER BY 
		MON_Nombre DESC, 
		OV_FechaOV , 
		OVD_TipoDetalle , 
		OVD_NumeroLinea , 
		ART_CodigoArticulo