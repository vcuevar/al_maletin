SELECT ART_CodigoArticulo, ART_Nombre, ISNULL(CANTIDAD_RECIBIDA, 0.0) AS CANTIDAD_RECIBIDA, OC_CodigoOC, OCFR_CantidadRequerida
FROM OrdenesCompra
INNER JOIN OrdenesCompraDetalle ON OC_OrdenCompraId = OCD_OC_OrdenCompraId
INNER JOIN Articulos ON OCD_ART_ArticuloId = ART_ArticuloId
INNER JOIN OrdenesCompraFechasRequeridas ON OC_OrdenCompraId = OCFR_OC_OrdenCompraId AND OCD_PartidaId = OCFR_OCD_PartidaId
LEFT  JOIN (SELECT SUM(OCRC_CantidadRecibo) AS CANTIDAD_RECIBIDA, OCRC_OC_OrdenCompraId, OCRC_OCR_OCRequeridaId
			FROM OrdenesCompraRecibos
			GROUP BY OCRC_OC_OrdenCompraId, OCRC_OCR_OCRequeridaId 
			) AS OrdenesCompraRecibos ON OC_OrdenCompraId = OCRC_OC_OrdenCompraId AND OCFR_FechaRequeridaId = OCRC_OCR_OCRequeridaId
WHERE OC_Borrado = 0
ORDER BY OC_CodigoOC