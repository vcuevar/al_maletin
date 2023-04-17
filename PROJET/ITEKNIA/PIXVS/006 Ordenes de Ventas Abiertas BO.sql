-- Consulta para Ordenes de Venta Abiertas (Con Base a consulta Enviada por Juan)
-- Actualizado al 18 de Abril del 2018
-- Vicente Cueva Ramirez.

SELECT 
	OV_CMM_EstadoOVId, 
	OV_OrdenVentaId,	

ISNULL((Select STUFF ((Select Distinct ' F-' + FTR_NumeroFactura + ', ' from Facturas
Where FTR_OV_OrdenVentaId = OV_OrdenVentaId
FOR XML PATH ('')), 1, 0, '')), 'S/F') AS N_FAC,


	STATUS_OV,
	Cast (OV_FechaOV as DATE) as F_ORDEN, 
	Case When OV_FechaOV IS NULL Then '9000' Else DATEPART(WK, OV_FechaOV) END AS SEMANA,
	OV_CodigoOV AS ORD_VEN,
	CLI_CodigoCliente AS COD_CLI, 
	CLI_RazonSocial AS CLIENTE, 
	EV_CodigoEvento AS COD_PROY, 
	EV_Descripcion AS PROYECTO,
	OV_ReferenciaOC AS ORD_COM,
	ART_GLN AS INSUMO,
	SUBSTRING(ART_GLN,8,20) AS COD, 
	ART_CodigoArticulo AS CODIGO,
	OVD_ART_Nombre AS PRODUCTO,	
	OVD_CMUM_Nombre AS UNIDAD,
	OVR_CantidadRequerida AS CANTIDAD,
	MON_MonedaId AS COD_MONEY, 
	MON_Nombre AS MONEDA, 
	OV_MONP_Paridad TIP_CAMBIO,
	OVR_PrecioUnitario AS PRE_UNIT,
	ACAT_Nombre as CATEGORIA,
	OVR_FechaRequerida AS F_ENTREGA,
	OV_Comentarios AS OBSERV,	
	OV_Comentarios , 
	OV_ReferenciaOC ,  
	OV_EmbarqueCompleto , 
	CONTACTOOV , 
	TRANSPORTE , 
	CONDICIONES , 
	COT_CodigoCOT , 
	NOMBRE , 
	COD_EMP , 
	CMDSC_TermsDescuento , 
	OV_EMP_ModificadoPor , 
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
	TIP_CLIENTE,
	FAMILIA,
	OVD_ART_Nombre , 
	OVD_CMUM_Nombre , 
	OVR_PrecioUnitario , 
	SUBTOTAL , 
	DESCUENTO , 
	( SUBTOTAL - DESCUENTO ) * ISNULL ( OVD_CMIVA_Porcentaje , 0.0 ) AS IVA , 
	OVD_CMIVA_Porcentaje , 
	( SUBTOTAL - DESCUENTO ) * ( 1 + ISNULL ( OVD_CMIVA_Porcentaje , 0.0 ) ) AS TOTAL , 
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
 		SELECT 	OV_CodigoOV , 
				OV_OrdenVentaId ,
					
				OV_FechaOV , 
				OV_Comentarios , 
				OV_ReferenciaOC , 
				OV_CMM_EstadoOVId , 
				OV_EmbarqueCompleto ,
				OV_MONP_Paridad, 
				ESTADO_OV.CMM_Valor AS STATUS_OV , 
				CLI_CodigoCliente , 
				CLI_RazonSocial , 
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
				MM4.CMM_Valor AS TIP_CLIENTE,
				AFAM_Nombre as FAMILIA,
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
		INNER JOIN ControlesMaestrosMultiples ESTADO_OV ON OV_CMM_EstadoOVId = ESTADO_OV.CMM_ControllId 
		INNER JOIN Monedas ON OV_MON_MonedaId = MON_MonedaId 
		INNER JOIN ClientesContactos ON OV_CCON_ContactoId = CCON_ContactoId AND CCON_Borrado = 0 
		LEFT JOIN Eventos ON EV_EventoId = OV_EV_EventoId 
		INNER JOIN Empleados ON EMP_EmpleadoId = OV_EMP_ModificadoPor 
		LEFT JOIN ControlesMaestrosMultiples EMBARQUEOV ON OV_CMM_MetodoEmbarque = EMBARQUEOV.CMM_ControllId 
		LEFT JOIN ControlesMaestrosMultiples LIBREABORDO ON OV_CMM_LibreABordo = LIBREABORDO.CMM_ControllId 
		LEFT JOIN ControlesMaestrosDSC ON CMDSC_CodigoId = OV_CMDSC_CodigoId 
		LEFT JOIN Cotizaciones ON COT_CotizacionId = OV_COT_CotizacionId 
		left join ControlesMaestrosMultiples MM4 on CLI_CMM_CDC_TipoClienteID = MM4.CMM_ControllId
		left join ArticulosFamilias on ART_AFAM_FamiliaId = AFAM_FamiliaId 
		LEFT JOIN ( SELECT EMBD_OVR_OVREQUERIDAID, SUM( EMBD_CantidadEmbarcada ) AS CANTIDAD_EMBARCADA 
					FROM EmbarquesDetalle 
					INNER JOIN Embarques ON EMBD_EMBARQUEID = EMB_EMBARQUEID 
					GROUP BY EMBD_OVR_OVREQUERIDAID ) AS Embarques ON OVR_OVRequeridaId = EMBD_OVR_OVREQUERIDAID 
		
		LEFT JOIN (	SELECT FTRR_ReferenciaId, SUM(FTRR_CantidadRequerida) AS CANTIDAD_FACTURADA 
					FROM Facturas 
					INNER JOIN FacturasReq ON FTR_FacturaId = FTRR_FTR_FacturaId 
					WHERE FTR_Eliminado = 0 
					GROUP BY FTRR_ReferenciaId) AS Facturas ON OVR_OVRequeridaId = FTRR_ReferenciaId  
					WHERE OV_Borrado = 0
		) AS TEMP					 
WHERE CANTIDAD_POR_EMBARCAR != 0  AND OV_CMM_EstadoOVId <> '2B53F727-33FC-4A1F-90C6-7B8A7B713CDA' 
ORDER BY OV_FechaOV, OVD_TipoDetalle, OVD_NumeroLinea, ART_CodigoArticulo


/*
Select STUFF ((Select Distinct ' ' + FTR_NumeroFactura FROM FACTURAS
Where FTR_OV_OrdenVentaId = '9F1E952B-5A5F-4DDB-8A93-4B6069417844'
FOR XML PATH ('')), 1, 0, '') AS N_FAC


Select * from Facturas
inner Join OrdenesVenta on FTR_OV_OrdenVentaId = OV_OrdenVentaId
Where OV_CodigoOV = 'OV544'
 A9E16E25-975C-4049-89D4-7E79A4B762A6
--Where OV_CodigoOV = 'OV519'


(Select STUFF ((Select Distinct ' F-' + FTR_NumeroFactura + ', ' from Facturas
Where FTR_OV_OrdenVentaId = 'A9E16E25-975C-4049-89D4-7E79A4B762A6'
FOR XML PATH ('')), 1, 0, '')) AS N_FAC


Select STUFF ((Select Distinct ' ' + FTR_NumeroFactura FROM FACTURAS
Where FTR_OV_OrdenVentaId = '9F1E952B-5A5F-4DDB-8A93-4B6069417844'
FOR XML PATH ('')), 1, 0, '') AS N_FAC

*/