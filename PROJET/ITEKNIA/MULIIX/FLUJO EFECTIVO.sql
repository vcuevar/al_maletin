use ItekniaDB
SELECT
   CLIENTE,
   SUM(COBRADO) AS COBRADO,
   SUM(MONTO) AS MONTO,
   SUM (ANTERIOREST) AS ANTERIOREST,
   SUM (ANTERIORCOM) AS ANTERIORCOM,
   SUM (RESTOEST) AS RESTOEST,
   SUM (RESTOCOM) AS RESTOCOM,
   SUM([2143_ESTIMADO])[2143_ESTIMADO],
   SUM([2144_ESTIMADO])[2144_ESTIMADO],
   SUM([2145_ESTIMADO])[2145_ESTIMADO],
   SUM([2146_ESTIMADO])[2146_ESTIMADO],
   SUM([2147_ESTIMADO])[2147_ESTIMADO],
   SUM([2148_ESTIMADO])[2148_ESTIMADO],
   SUM([2150_ESTIMADO])[2150_ESTIMADO],
   SUM([2143_COMPROMETIDO])[2143_COMPROMETIDO],
   SUM([2144_COMPROMETIDO])[2144_COMPROMETIDO],
   SUM([2145_COMPROMETIDO])[2145_COMPROMETIDO],
   SUM([2146_COMPROMETIDO])[2146_COMPROMETIDO],
   SUM([2147_COMPROMETIDO])[2147_COMPROMETIDO],
   SUM([2148_COMPROMETIDO])[2148_COMPROMETIDO],
   SUM([2150_COMPROMETIDO])[2150_COMPROMETIDO] 
FROM
   (
      SELECT
(SUM(ROUND(SUBTOTAL, 2)) - SUM(ROUND(DESCUENTO, 2))) + SUM(ROUND(IVA, 2)) - COALESCE((Pagos.cantidadPagoFactura), 0) AS XCOBRAR,
         OV_OrdenVentaId AS ID,
         CASE
            WHEN
               (
(SUM(ROUND(SUBTOTAL, 2)) - SUM(ROUND(DESCUENTO, 2))) + SUM(ROUND(IVA, 2)) - COALESCE((Pagos.cantidadPagoFactura), 0)
               )
               > 0 
               AND CANTPROVISION IS NULL 
               AND CANTPROVISION_PAGADAS IS NULL 
            THEN
               'SIN CAPTURA' 
            WHEN
               (
(SUM(ROUND(SUBTOTAL, 2)) - SUM(ROUND(DESCUENTO, 2))) + SUM(ROUND(IVA, 2)) - COALESCE((Pagos.cantidadPagoFactura), 0)
               )
               = 0 
            THEN
               'COMPLETO' 
            WHEN
               (
(SUM(ROUND(SUBTOTAL, 2)) - SUM(ROUND(DESCUENTO, 2))) + SUM(ROUND(IVA, 2)) - COALESCE((Pagos.cantidadPagoFactura), 0)
               )
               > CANTPROVISION 
               OR CANTPROVISION_PAGADAS = 0 
            THEN
               'INCOMPLETO' 
            WHEN
               (
(SUM(ROUND(SUBTOTAL, 2)) - SUM(ROUND(DESCUENTO, 2))) + SUM(ROUND(IVA, 2)) - COALESCE((Pagos.cantidadPagoFactura), 0)
               )
               = CANTPROVISION 
            THEN
               'PROVISIONADO' 
            ELSE
               'NO ESPECIFICADO' 
         END
         AS PROVISION, OV_CodigoOV AS OV, 
         CASE
            WHEN
               OV_CMM_EstadoOVId = '3CE37D96-1E8A-49A7-96A1-2E837FA3DCF5' 
            THEN
               'Abierta' 
            WHEN
               OV_CMM_EstadoOVId = '2209C8BF-8259-4D8C-A0E9-389F52B33B46' 
            THEN
               'Cerrada' 
            WHEN
               OV_CMM_EstadoOVId = 'D528E9EC-83CF-49BE-AEED-C3751A3B0F27' 
            THEN
               'Embarque Completo' 
            ELSE
               'Cancelado' 
         END
         ESTATUS, SUBSTRING(CLI_CodigoCliente + ' - ' + CLI_RazonSocial, 1, 50) AS CLIENTE, PRY_CodigoEvento + ' - ' + PRY_NombreProyecto AS PROYECTO, 
         (
(ROUND(SUBTOTAL, 2)) - (ROUND(DESCUENTO, 2))
         )
         + (ROUND(IVA, 2)) AS MONTO, COALESCE((Pagos.cantidadPagoFactura), 0) COBRADO , 
         (
            coalesce( SEM.[2045_ESTIMADO] , 0) + coalesce( SEM.[2047_ESTIMADO] , 0) + coalesce( SEM.[2048_ESTIMADO] , 0) + coalesce( SEM.[2051_ESTIMADO] , 0) + coalesce( SEM.[2053_ESTIMADO] , 0) + coalesce( SEM.[2101_ESTIMADO] , 0) + coalesce( SEM.[2102_ESTIMADO] , 0) + coalesce( SEM.[2103_ESTIMADO] , 0) + coalesce( SEM.[2108_ESTIMADO] , 0) + coalesce( SEM.[2112_ESTIMADO] , 0) + coalesce( SEM.[2113_ESTIMADO] , 0) + coalesce( SEM.[2120_ESTIMADO] , 0) + coalesce( SEM.[2124_ESTIMADO] , 0) + coalesce( SEM.[2125_ESTIMADO] , 0) + coalesce( SEM.[2126_ESTIMADO] , 0) + coalesce( SEM.[2128_ESTIMADO] , 0) + coalesce( SEM.[2130_ESTIMADO] , 0) + coalesce( SEM.[2131_ESTIMADO] , 0) + coalesce( SEM.[2132_ESTIMADO] , 0) + coalesce( SEM.[2133_ESTIMADO] , 0) + coalesce( SEM.[2136_ESTIMADO] , 0) + coalesce( SEM.[2139_ESTIMADO] , 0) + coalesce( SEM.[2141_ESTIMADO] , 0)
         )
         as ANTERIOREST , 
         (
            coalesce( SEM.[2045_COMPROMETIDO] , 0) + coalesce( SEM.[2047_COMPROMETIDO] , 0) + coalesce( SEM.[2048_COMPROMETIDO] , 0) + coalesce( SEM.[2051_COMPROMETIDO] , 0) + coalesce( SEM.[2053_COMPROMETIDO] , 0) + coalesce( SEM.[2101_COMPROMETIDO] , 0) + coalesce( SEM.[2102_COMPROMETIDO] , 0) + coalesce( SEM.[2103_COMPROMETIDO] , 0) + coalesce( SEM.[2108_COMPROMETIDO] , 0) + coalesce( SEM.[2112_COMPROMETIDO] , 0) + coalesce( SEM.[2113_COMPROMETIDO] , 0) + coalesce( SEM.[2120_COMPROMETIDO] , 0) + coalesce( SEM.[2124_COMPROMETIDO] , 0) + coalesce( SEM.[2125_COMPROMETIDO] , 0) + coalesce( SEM.[2126_COMPROMETIDO] , 0) + coalesce( SEM.[2128_COMPROMETIDO] , 0) + coalesce( SEM.[2130_COMPROMETIDO] , 0) + coalesce( SEM.[2131_COMPROMETIDO] , 0) + coalesce( SEM.[2132_COMPROMETIDO] , 0) + coalesce( SEM.[2133_COMPROMETIDO] , 0) + coalesce( SEM.[2136_COMPROMETIDO] , 0) + coalesce( SEM.[2139_COMPROMETIDO] , 0) + coalesce( SEM.[2141_COMPROMETIDO], 0)
         )
         as ANTERIORCOM , COALESCE(SEM.[2143_ESTIMADO], 0)[2143_ESTIMADO], COALESCE(SEM.[2144_ESTIMADO], 0)[2144_ESTIMADO], COALESCE(SEM.[2145_ESTIMADO], 0)[2145_ESTIMADO], COALESCE(SEM.[2146_ESTIMADO], 0)[2146_ESTIMADO], COALESCE(SEM.[2147_ESTIMADO], 0)[2147_ESTIMADO], COALESCE(SEM.[2148_ESTIMADO], 0)[2148_ESTIMADO], COALESCE(SEM.[2150_ESTIMADO], 0)[2150_ESTIMADO] , COALESCE(SEM.[2143_COMPROMETIDO], 0)[2143_COMPROMETIDO], COALESCE(SEM.[2144_COMPROMETIDO], 0)[2144_COMPROMETIDO], COALESCE(SEM.[2145_COMPROMETIDO], 0)[2145_COMPROMETIDO], COALESCE(SEM.[2146_COMPROMETIDO], 0)[2146_COMPROMETIDO], COALESCE(SEM.[2147_COMPROMETIDO], 0)[2147_COMPROMETIDO], COALESCE(SEM.[2148_COMPROMETIDO], 0)[2148_COMPROMETIDO], COALESCE(SEM.[2150_COMPROMETIDO], 0)[2150_COMPROMETIDO] , 
         (
            coalesce( SEM.[2150_ESTIMADO] , 0) + coalesce( SEM.[2152_ESTIMADO] , 0) + coalesce( SEM.[2201_ESTIMADO] , 0) + coalesce( SEM.[2204_ESTIMADO] , 0) + coalesce( SEM.[2252_ESTIMADO], 0)
         )
         as RESTOEST , 
         (
            coalesce( SEM.[2150_COMPROMETIDO] , 0) + coalesce( SEM.[2152_COMPROMETIDO] , 0) + coalesce( SEM.[2201_COMPROMETIDO] , 0) + coalesce( SEM.[2204_COMPROMETIDO] , 0) + coalesce( SEM.[2252_COMPROMETIDO], 0)
         )
         as RESTOCOM 
      FROM
         OrdenesVenta 
         INNER JOIN
            Clientes 
            ON OV_CLI_ClienteId = CLI_ClienteId 
         LEFT JOIN
            Proyectos 
            ON OV_PRO_ProyectoId = PRY_ProyectoId 
            AND PRY_Activo = 1 
            AND PRY_Borrado = 0 
         LEFT JOIN
            (
               SELECT
                  OVD_OV_OrdenVentaId,
                  SUM(OVD_CantidadRequerida * OVD_PrecioUnitario) AS SUBTOTAL,
                  SUM(OVD_CantidadRequerida * OVD_PrecioUnitario * ISNULL(OVD_PorcentajeDescuento, 0.0)) AS DESCUENTO,
                  SUM(((OVD_CantidadRequerida * OVD_PrecioUnitario) - (OVD_CantidadRequerida * OVD_PrecioUnitario * ISNULL(OVD_PorcentajeDescuento, 0.0))) * ISNULL(OVD_CMIVA_Porcentaje, 0.0)) AS IVA,
                  SUM(OVD_CantidadRequerida) OVD_CantidadRequerida 
               FROM
                  OrdenesVentaDetalle 
                  LEFT JOIN
                     ArticulosEspecificaciones 
                     ON OVD_ART_ArticuloId = AET_ART_ArticuloId 
                     AND AET_CMM_ArticuloEspecificaciones = 'DF85FC23-720F-4E99-A794-FCE3F8D3B66F' 
               GROUP BY
                  OVD_OV_OrdenVentaId 
            )
            AS OrdenesVentaDetalle 
            ON OV_OrdenVentaId = OVD_OV_OrdenVentaId 
         LEFT JOIN
            (
               select
                  FTR_OV_OrdenVentaId,
                  CXCP_CMM_FormaPagoId,
                  ControlesMaestrosMultiples.CMM_Valor,
                  SUM(CXCPD_MontoAplicado * CXCP_MONP_Paridad) as cantidadPagoFactura 
               from
                  CXCPagos 
                  inner join
                     CXCPagosDetalle 
                     on CXCP_CXCPagoId = CXCPD_CXCP_CXCPagoId 
                  inner join
                     Facturas 
                     on CXCPD_FTR_FacturaId = FTR_FacturaId 
                  INNER JOIN
                     ControlesMaestrosMultiples 
                     ON CXCP_CMM_FormaPagoId = ControlesMaestrosMultiples.CMM_ControlId 
               WHERE
                  CXCP_Eliminado = 0 
                  and CXCP_CMM_FormaPagoId <> 'F86EC67D-79BD-4E1A-A48C-08830D72DA6F' 
               group by
                  FTR_OV_OrdenVentaId,
                  CXCP_CMM_FormaPagoId,
                  CMM_Valor 
            )
            AS Pagos 
            ON Pagos.FTR_OV_OrdenVentaId = OV_OrdenVentaId 
         LEFT JOIN
            (
               SELECT
                  PCXC_OV_Id,
                  SUM( 
                  CASE
                     WHEN
                        PCXC_Activo = 1 
                     THEN
                        COALESCE(PCXC_Cantidad_provision, 0) 
                  END
) AS CANTPROVISION, SUM( 
                  CASE
                     WHEN
                        PCXC_Activo = 0 
                     THEN
                        COALESCE(PCXC_Cantidad, 0) 
                  END
) AS CANTPROVISION_PAGADAS 
               FROM
                  RPT_ProvisionCXC 
               WHERE
                  PCXC_Activo = 1 
                  AND PCXC_Eliminado = 0 
               GROUP BY
                  PCXC_OV_Id 
            )
            AS PROVISIONES 
            ON PCXC_OV_Id = CONVERT (VARCHAR(100), OV_CodigoOV ) 
         LEFT JOIN
            (
               SELECT
                  p.* 
               FROM
                  (
                     SELECT
                        PCXC_OV_Id as ov,
                        PCXC_Cantidad_provision,
                        CASE
                           WHEN
                              PCXC_Concepto = 'RE-NEGOCIADO' 
                           THEN
                              [PCXC_Semana_fecha] + '_COMPROMETIDO' 
                           ELSE
                              [PCXC_Semana_fecha] + '_' + PCXC_Concepto 
                        END
                        as [col] 
                     FROM
                        [dbo].[RPT_ProvisionCXC] 
                     WHERE
                        PCXC_Activo = 1 
                        AND PCXC_Eliminado = 0 
                  )
                  AS j PIVOT (SUM(PCXC_Cantidad_provision) FOR [col] in 
                  (
                     [2045_ESTIMADO], [2047_ESTIMADO], [2048_ESTIMADO], [2051_ESTIMADO], [2053_ESTIMADO], [2101_ESTIMADO], [2102_ESTIMADO], [2103_ESTIMADO], [2108_ESTIMADO], [2112_ESTIMADO], [2113_ESTIMADO], [2120_ESTIMADO], [2124_ESTIMADO], [2125_ESTIMADO], [2126_ESTIMADO], [2128_ESTIMADO], [2130_ESTIMADO], [2131_ESTIMADO], [2132_ESTIMADO], [2133_ESTIMADO], [2136_ESTIMADO], [2139_ESTIMADO], [2141_ESTIMADO], [2143_ESTIMADO], [2144_ESTIMADO], [2145_ESTIMADO], [2146_ESTIMADO], [2147_ESTIMADO], [2148_ESTIMADO], [2150_ESTIMADO], [2152_ESTIMADO], [2201_ESTIMADO], [2204_ESTIMADO], [2252_ESTIMADO], [2045_COMPROMETIDO], [2047_COMPROMETIDO], [2048_COMPROMETIDO], [2051_COMPROMETIDO], [2053_COMPROMETIDO], [2101_COMPROMETIDO], [2102_COMPROMETIDO], [2103_COMPROMETIDO], [2108_COMPROMETIDO], [2112_COMPROMETIDO], [2113_COMPROMETIDO], [2120_COMPROMETIDO], [2124_COMPROMETIDO], [2125_COMPROMETIDO], [2126_COMPROMETIDO], [2128_COMPROMETIDO], [2130_COMPROMETIDO], [2131_COMPROMETIDO], [2132_COMPROMETIDO], [2133_COMPROMETIDO], [2136_COMPROMETIDO], [2139_COMPROMETIDO], [2141_COMPROMETIDO], [2143_COMPROMETIDO], [2144_COMPROMETIDO], [2145_COMPROMETIDO], [2146_COMPROMETIDO], [2147_COMPROMETIDO], [2148_COMPROMETIDO], [2150_COMPROMETIDO], [2152_COMPROMETIDO], [2201_COMPROMETIDO], [2204_COMPROMETIDO], [2252_COMPROMETIDO]
                  )
) AS p 
            )
            AS SEM 
            ON ov = CONVERT (VARCHAR(100), OV_CodigoOV ) 
      WHERE
         OV_CMM_EstadoOVId = '3CE37D96-1E8A-49A7-96A1-2E837FA3DCF5' 
      GROUP BY
         SEM.ov, [2045_ESTIMADO], [2047_ESTIMADO], [2048_ESTIMADO], [2051_ESTIMADO], [2053_ESTIMADO], [2101_ESTIMADO], [2102_ESTIMADO], [2103_ESTIMADO], [2108_ESTIMADO], [2112_ESTIMADO], [2113_ESTIMADO], [2120_ESTIMADO], [2124_ESTIMADO], [2125_ESTIMADO], [2126_ESTIMADO], [2128_ESTIMADO], [2130_ESTIMADO], [2131_ESTIMADO], [2132_ESTIMADO], [2133_ESTIMADO], [2136_ESTIMADO], [2139_ESTIMADO], [2141_ESTIMADO], [2143_ESTIMADO], [2144_ESTIMADO], [2145_ESTIMADO], [2146_ESTIMADO], [2147_ESTIMADO], [2148_ESTIMADO], [2150_ESTIMADO], [2152_ESTIMADO], [2201_ESTIMADO], [2204_ESTIMADO], [2252_ESTIMADO], [2045_COMPROMETIDO], [2047_COMPROMETIDO], [2048_COMPROMETIDO], [2051_COMPROMETIDO], [2053_COMPROMETIDO], [2101_COMPROMETIDO], [2102_COMPROMETIDO], [2103_COMPROMETIDO], [2108_COMPROMETIDO], [2112_COMPROMETIDO], [2113_COMPROMETIDO], [2120_COMPROMETIDO], [2124_COMPROMETIDO], [2125_COMPROMETIDO], [2126_COMPROMETIDO], [2128_COMPROMETIDO], [2130_COMPROMETIDO], [2131_COMPROMETIDO], [2132_COMPROMETIDO], [2133_COMPROMETIDO], [2136_COMPROMETIDO], [2139_COMPROMETIDO], [2141_COMPROMETIDO], [2143_COMPROMETIDO], [2144_COMPROMETIDO], [2145_COMPROMETIDO], [2146_COMPROMETIDO], [2147_COMPROMETIDO], [2148_COMPROMETIDO], [2150_COMPROMETIDO], [2152_COMPROMETIDO], [2201_COMPROMETIDO], [2204_COMPROMETIDO], [2252_COMPROMETIDO], PROVISIONES.CANTPROVISION, PROVISIONES.CANTPROVISION_PAGADAS, OV_OrdenVentaId, OV_CodigoOV, CLI_CodigoCliente, CLI_RazonSocial, PRY_CodigoEvento, cantidadPagoFactura, SUBTOTAL, DESCUENTO, IVA, PRY_NombreProyecto, OV_FechaOV, OV_ReferenciaOC, OV_FechaRequerida, OV_CMM_EstadoOVId 
   )
   AS RESUMENCXC 
GROUP BY
   RESUMENCXC.CLIENTE 
ORDER BY
   RESUMENCXC.CLIENTE