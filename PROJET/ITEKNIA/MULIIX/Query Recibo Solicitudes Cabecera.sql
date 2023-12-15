SELECT * FROM
		(
			SELECT 
			ISNULL(ABS(SUM(TRLOT_CantidadTraspaso)) - SUM(ISNULL(CANT_RECIBO,0.0)), 0) AS CANTIDAD_POR_RECIBIR
			, TSM_TraspasoSolicitudId, ALM_Nombre, TSM_FechaCreacion
			, CMM_Valor
			, TSM_CMM_EstatusSolicitudId
			, TSM_CodigoSolicitud
			FROM TraspasosSolicitudesManufactura
			INNER JOIN Almacenes ON TSM_ALM_AlmacenOrigenId = ALM_AlmacenId
			inner join ControlesMaestrosMultiples on CMM_ControlId = TSM_CMM_EstatusSolicitudId
			INNER JOIN TraspasosSolicitudesDetalleManufactura ON TSDM_TSM_TraspasoSolicitudId = TSM_TraspasoSolicitudId
			LEFT JOIN TraspasosDetalleManufactura ON TDM_TSDM_DetalleId = TSDM_DetalleId
			LEFT JOIN TraspasosLotes ON TDM_TRAM_TraspasoMovtoId = TRLOT_TRAM_TraspasoMovtoId
			LEFT JOIN LotesLocalidades PREVIO ON TRLOT_LOTL_LoteLocalidadId = PREVIO.LOTL_LoteLocalidadId
			LEFT JOIN Lotes ON LOT_LoteId = LOTL_LOT_LoteId
			LEFT JOIN (
				SELECT TRM_TDM_TraspasoDetalleId, LOTL_LOT_LoteId AS LOT_ID, SUM(TRM_CantidadRecibo) AS CANT_RECIBO
				FROM TraspasosRecibosManufactura
				INNER JOIN TraspasosMovtos ON TRAM_TraspasoMovtoId = TRM_TRAM_TraspasoMovtoId
				INNER JOIN TraspasosLotes ON TRLOT_TRAM_TraspasoMovtoId = TRAM_TraspasoMovtoId
				INNER JOIN LotesLocalidades ON LOTL_LoteLocalidadId = TRLOT_LOTL_LoteLocalidadId
				GROUP BY TRM_TDM_TraspasoDetalleId,LOTL_LOT_LoteId--,TRM_CantidadRecibo
			) AS RECIBO ON TRM_TDM_TraspasoDetalleId = TDM_TraspasoDetalleId AND LOT_LoteId = LOT_ID 
			--WHERE CMM_Valor  IN (  'Traspaso Parcial','Traspasado','Recibo Parcial')
			-- WHERE CMM_Valor  IN ( 'Solicitado')
			WHERE TSM_FechaCreacion > (SELECT  DATEADD(DAY, -30, GETDATE()))
			and TSM_ALM_AlmacenOrigenId = 'D4FF91B0-97CA-47B3-B262-39F3B898A256'
			AND TSM_SalidaProduccion = 0 AND TSM_EntregaWIP = 0
			--AND TSM_TraspasoSolicitudId= '21C383DE-DBE5-47F3-A2D5-3AA040AFAF9C'
		
			GROUP BY 
			 TSM_TraspasoSolicitudId, ALM_Nombre, TSM_FechaCreacion, TSM_CodigoSolicitud
			, CMM_Valor
			, TSM_CMM_EstatusSolicitudId
			, TSM_CodigoSolicitud
		) AS QUERY
		WHERE CANTIDAD_POR_RECIBIR > 0
		ORDER BY TSM_FechaCreacion ASC


		SELECT * FROM TraspasosSolicitudesManufactura
		INNER JOIN Almacenes ON TSM_ALM_AlmacenOrigenId = ALM_AlmacenId
			inner join ControlesMaestrosMultiples on CMM_ControlId = TSM_CMM_EstatusSolicitudId
			INNER JOIN TraspasosSolicitudesDetalleManufactura ON TSDM_TSM_TraspasoSolicitudId = TSM_TraspasoSolicitudId
			LEFT JOIN TraspasosDetalleManufactura ON TDM_TSDM_DetalleId = TSDM_DetalleId
			LEFT JOIN TraspasosLotes ON TDM_TRAM_TraspasoMovtoId = TRLOT_TRAM_TraspasoMovtoId
			LEFT JOIN LotesLocalidades PREVIO ON TRLOT_LOTL_LoteLocalidadId = PREVIO.LOTL_LoteLocalidadId
			LEFT JOIN Lotes ON LOT_LoteId = LOTL_LOT_LoteId
			   where TSM_TraspasoSolicitudId= '21C383DE-DBE5-47F3-A2D5-3AA040AFAF9C'
			   --AND CMM_Valor  IN (  'Traspaso Parcial','Traspasado','Recibo Parcial')
			and TSM_FechaCreacion > (SELECT  DATEADD(DAY, -30, GETDATE()))
			and TSM_ALM_AlmacenOrigenId = 'D4FF91B0-97CA-47B3-B262-39F3B898A256'
			AND TSM_SalidaProduccion = 0 AND TSM_EntregaWIP = 0
			   and TSM_ALM_AlmacenOrigenId = 'D4FF91B0-97CA-47B3-B262-39F3B898A256'


		Select TSM_CodigoSolicitud 
			, TSM_FechaCreacion
			, CMM_Valor AS ESTATUS
			, ALM_Nombre AS ALMACEN_ORIGEN
			, ART_CodigoArticulo
			, ART_Nombre
			, TSDM_Cantidad
			, TSDM_NumeroPartida
		from TraspasosSolicitudesManufactura 
		inner join ControlesMaestrosMultiples on CMM_ControlId = TSM_CMM_EstatusSolicitudId
		INNER JOIN TraspasosSolicitudesDetalleManufactura ON TSDM_TSM_TraspasoSolicitudId = TSM_TraspasoSolicitudId
		INNER JOIN Almacenes ON TSM_ALM_AlmacenOrigenId = ALM_AlmacenId
		Inner Join Articulos on ART_ArticuloId = TSDM_ART_ArticuloId
		Where TSM_CodigoSolicitud  = 'SM06211'
		
		
		Select * from Articulos
		
		
		--	   where TSM_TraspasoSolicitudId= '21C383DE-DBE5-47F3-A2D5-3AA040AFAF9C'
  --             SELECT * FROM Almacenes
		--	   WHERE ALM_AlmacenId='D4FF91B0-97CA-47B3-B262-39F3B898A256' --GDL-CTROL ORIGEN
		--	   SELECT * FROM Almacenes
		--	   WHERE ALM_AlmacenId='CB35B14B-7BB1-4771-84DA-A4CBE159C8D6' --A11_MP DESTINO 
			   --WHERE ALM

			   --UPDATE TraspasosSolicitudesManufactura
			   --SET TSM_EntregaWIP = 0
			   --where TSM_TraspasoSolicitudId= '21C383DE-DBE5-47F3-A2D5-3AA040AFAF9C'
			   
		Select * from ControlesMaestrosMultiples Where CMM_ControlId ='9367F403-C6E8-4952-8276-F71B8E92B641'
			   
			   
			   
			   
			   
			   
			   
			   