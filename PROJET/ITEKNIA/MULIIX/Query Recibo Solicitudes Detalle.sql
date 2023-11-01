SELECT
					ART_ArticuloId,ART_CodigoArticulo, ART_Nombre, CMUM_Nombre, LOT_CodigoLote,TSM_ALM_AlmacenOrigenId,
					--CAST(ISNULL(LOCA_Cantidad,0)AS INT) AS Existencia_Localidad,
					--CAST(ISNULL(EXISTENCIA.LOTL_Cantidad,0)AS INT) AS Existencia_Lote,
					TSDM_Cantidad AS CANTIDAD_SOLICITADA, ABS(SUM(TRLOT_CantidadTraspaso)) AS CANTIDAD_TRASPASADA,
					TSDM_Cantidad - SUM(ISNULL(TDM_CantidadATraspasar,0.0)) AS CANTIDAD_FALTANTE_POR_TRASPASAR,
					SUM(ISNULL(CANT_RECIBO,0.0)) AS CANTIDAD_RECIBO,
					ABS(SUM(TRLOT_CantidadTraspaso)) - SUM(ISNULL(CANT_RECIBO,0.0)) AS CANTIDAD_POR_RECIBIR,
					CMM_Valor, TDM_TraspasoDetalleId, LOT_LoteId, TSDM_DetalleId,
					(select top 1 LOC_LocalidadId from Localidades where LOC_ALM_AlmacenId = TSM_ALM_AlmacenOrigenId
					 and LOC_LocalidadGeneral = 0
					 and LOC_Eliminado = 0) as TRS_LOC_LocalidadOrigenId
					--TRS_LOC_LocalidadOrigenId,TRS_LOC_LocalidadDestinoId
				FROM TraspasosSolicitudesDetalleManufactura
				INNER JOIN Articulos ON ART_ArticuloId=TSDM_ART_ArticuloId
				--INNER JOIN ControlesMaestrosUM ON CMUM_UnidadMedidaId = TSDM_CMUM_UnidadMedidaId
				INNER JOIN ControlesMaestrosUM ON CMUM_UnidadMedidaId = ART_CMUM_UMInventarioId
				INNER JOIN TraspasosSolicitudesManufactura ON TSM_TraspasoSolicitudId = TSDM_TSM_TraspasoSolicitudId
				INNER JOIN ControlesMaestrosMultiples ON CMM_ControlId=TSM_CMM_EstatusSolicitudId
				LEFT JOIN TraspasosDetalleManufactura ON TDM_TSDM_DetalleId = TSDM_DetalleId
				LEFT JOIN TraspasosLotes ON TDM_TRAM_TraspasoMovtoId = TRLOT_TRAM_TraspasoMovtoId
				LEFT JOIN LotesLocalidades PREVIO ON TRLOT_LOTL_LoteLocalidadId = PREVIO.LOTL_LoteLocalidadId
				LEFT JOIN Lotes ON LOT_LoteId = LOTL_LOT_LoteId
				--LEFT JOIN LotesLocalidades EXISTENCIA  ON LOT_LoteId = EXISTENCIA.LOTL_LOT_LoteId AND TRS_LOC_LocalidadOrigenId = EXISTENCIA.LOTL_LOC_LocalidadId
				-- LEFT JOIN Localidades ON LOC_LocalidadId = TRS_LOC_LocalidadOrigenId
				--LEFT JOIN LocalidadesArticulo ON ART_ArticuloId = LOCA_ART_ArticuloId AND LOCA_LOC_LocalidadId = LOC_LocalidadId
				LEFT JOIN (
					SELECT TRM_TDM_TraspasoDetalleId, LOTL_LOT_LoteId AS LOT_ID, SUM(TRM_CantidadRecibo) AS CANT_RECIBO
					FROM TraspasosRecibosManufactura
					INNER JOIN TraspasosMovtos ON TRAM_TraspasoMovtoId = TRM_TRAM_TraspasoMovtoId
					INNER JOIN TraspasosLotes ON TRLOT_TRAM_TraspasoMovtoId = TRAM_TraspasoMovtoId
					INNER JOIN LotesLocalidades ON LOTL_LoteLocalidadId = TRLOT_LOTL_LoteLocalidadId
					GROUP BY TRM_TDM_TraspasoDetalleId,LOTL_LOT_LoteId--,TRM_CantidadRecibo
				) AS RECIBO ON TRM_TDM_TraspasoDetalleId = TDM_TraspasoDetalleId AND LOT_LoteId = LOT_ID	--TraspasosRecibosManufactura ON TRM_TDM_TraspasoDetalleId= TDM_TraspasoDetalleId
				WHERE
					TSDM_TSM_TraspasoSolicitudId = '21C383DE-DBE5-47F3-A2D5-3AA040AFAF9C'
				GROUP BY
					TSDM_DetalleId,ART_CodigoArticulo,ART_ArticuloId, ART_Nombre, CMUM_Nombre, LOT_CodigoLote,
					--LOCA_Cantidad,--EXISTENCIA.LOTL_Cantidad,
						TSDM_Cantidad, CMM_Valor, TDM_TraspasoDetalleId,TSM_ALM_AlmacenOrigenId,
					LOT_LoteId--,TRS_LOC_LocalidadOrigenId,TRS_LOC_LocalidadDestinoId
				ORDER BY
					ART_CodigoArticulo ASC
					
					
					
Select top(10) * from TraspasosSolicitudesDetalleManufactura Where TSDM_FechaUltimaModificacion = '2023-10-17'
					
					