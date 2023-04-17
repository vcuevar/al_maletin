-- Consulta para Obtener el Reporte de Facturacion que lleva Fabiola.
-- Elaboro por: Ing. Alberto Jimenez Medina
-- Actualizado: Viernes 21 de Enero del 2022: Origen.
-- Modificado por: Ing. Vicente Cueva Ramirez.
-- Actualizado: Lunes 24 de Enero del 2022; Anexar Facturas. 

-- Consulta Original de Alberto
/*
SELECT ((SUM(ROUND(SUBTOTAL, 2)) - SUM(ROUND(DESCUENTO, 2))) + SUM(ROUND(IVA, 2)) - COALESCE((Pagos.cantidadPagoFactura), 0)) AS XCOBRAR
        , OV_OrdenVentaId AS ID,
        CASE 
        WHEN (((SUM(ROUND(SUBTOTAL, 2)) - SUM(ROUND(DESCUENTO, 2))) + SUM(ROUND(IVA, 2)) - COALESCE((Pagos.cantidadPagoFactura), 0)) <= 0 )
          AND ((((ROUND(SUBTOTAL, 2)) - (ROUND(DESCUENTO, 2))) + (ROUND(IVA, 2))) - (ISNULL((ROUND(FTR_TOTAL, 2)), 0.0) + COALESCE(SUM(NotaCredito.TotalNC), 0)) <= 0 )
          AND ((((ROUND(SUBTOTAL, 2)) - (ROUND(DESCUENTO, 2))) + (ROUND(IVA, 2))) - COALESCE((Embarque.EMB_TOTAL), 0 )) <= 0 THEN 'COMPLETO' 
        WHEN ((SUM(ROUND(SUBTOTAL, 2)) - SUM(ROUND(DESCUENTO, 2))) + SUM(ROUND(IVA, 2)) - COALESCE((Pagos.cantidadPagoFactura), 0)) > 0 
         AND CANTPROVISION IS NULL AND CANTPROVISION_PAGADAS IS NULL THEN 'SIN CAPTURA' 
        WHEN ((SUM(ROUND(SUBTOTAL, 2)) - SUM(ROUND(DESCUENTO, 2))) + SUM(ROUND(IVA, 2)) - COALESCE((Pagos.cantidadPagoFactura), 0)) > COALESCE(CANTPROVISION, 0) 
         OR COALESCE(CANTPROVISION_PAGADAS, 0) = 0 THEN 'INCOMPLETO' 
        WHEN ((SUM(ROUND(SUBTOTAL, 2)) - SUM(ROUND(DESCUENTO, 2))) + SUM(ROUND(IVA, 2)) - COALESCE((Pagos.cantidadPagoFactura), 0)) <= COALESCE(CANTPROVISION, 0) 
         THEN CASE
        WHEN ((((ROUND(SUBTOTAL, 2)) - (ROUND(DESCUENTO, 2))) + (ROUND(IVA, 2))) - (ISNULL((ROUND(FTR_TOTAL, 2)), 0.0) + COALESCE(SUM(NotaCredito.TotalNC), 0)) <= 0 )
            THEN CASE
        WHEN (((SUM(ROUND(SUBTOTAL, 2)) - SUM(ROUND(DESCUENTO, 2))) + SUM(ROUND(IVA, 2)) - COALESCE((Pagos.cantidadPagoFactura), 0)) <= 0 )
        THEN 'POR EMBARCAR' ELSE 'POR PAGAR' END ELSE 'POR FACTURAR' END ELSE 'NO ESPECIFICADO' END AS PROVISION
        
        , OV_CodigoOV AS OV, 
        CASE WHEN OV_CMM_EstadoOVId = '3CE37D96-1E8A-49A7-96A1-2E837FA3DCF5' THEN 'Abierta' 
        WHEN OV_CMM_EstadoOVId = '2209C8BF-8259-4D8C-A0E9-389F52B33B46' THEN 'Cerrada' 
        WHEN OV_CMM_EstadoOVId = 'D528E9EC-83CF-49BE-AEED-C3751A3B0F27' THEN 'Embarque Completo' ELSE 'Cancelado' END ESTATUS
        , CLI_CodigoCliente + ' - ' + CLI_RazonSocial AS CLIENTE
        , PRY_CodigoEvento + ' - ' + PRY_NombreProyecto AS PROYECTO
        , MON_Nombre AS MONEDA
        , (((ROUND(SUBTOTAL, 2)) - (ROUND(DESCUENTO, 2))) + (ROUND(IVA, 2))) AS MONTO
        , COALESCE((Pagos.cantidadPagoFactura), 0) COBRADO
        , (coalesce( SEM.[2045_ESTIMADO] , 0) + coalesce( SEM.[2047_ESTIMADO] , 0) + coalesce( SEM.[2048_ESTIMADO] , 0) + 
                coalesce( SEM.[2051_ESTIMADO] , 0) + coalesce( SEM.[2053_ESTIMADO] , 0) + coalesce( SEM.[2101_ESTIMADO] , 0) + 
                coalesce( SEM.[2102_ESTIMADO] , 0) + coalesce( SEM.[2103_ESTIMADO] , 0) + coalesce( SEM.[2108_ESTIMADO] , 0) + 
                coalesce( SEM.[2112_ESTIMADO] , 0) + coalesce( SEM.[2113_ESTIMADO] , 0) + coalesce( SEM.[2120_ESTIMADO] , 0) + 
                coalesce( SEM.[2124_ESTIMADO] , 0) + coalesce( SEM.[2125_ESTIMADO] , 0) + coalesce( SEM.[2126_ESTIMADO] , 0) + 
                coalesce( SEM.[2128_ESTIMADO] , 0) + coalesce( SEM.[2130_ESTIMADO] , 0) + coalesce( SEM.[2131_ESTIMADO] , 0) + 
                coalesce( SEM.[2132_ESTIMADO] , 0) + coalesce( SEM.[2133_ESTIMADO] , 0) + coalesce( SEM.[2136_ESTIMADO] , 0) + 
                coalesce( SEM.[2143_ESTIMADO] , 0) + coalesce( SEM.[2146_ESTIMADO] , 0) + coalesce( SEM.[2147_ESTIMADO] , 0) + 
                coalesce( SEM.[2152_ESTIMADO] , 0) + coalesce( SEM.[2201_ESTIMADO] , 0) + coalesce( SEM.[2045_COMPROMETIDO] , 0) + 
                coalesce( SEM.[2047_COMPROMETIDO] , 0) + coalesce( SEM.[2048_COMPROMETIDO] , 0) + coalesce( SEM.[2051_COMPROMETIDO] , 0) + 
                coalesce( SEM.[2053_COMPROMETIDO] , 0) + coalesce( SEM.[2101_COMPROMETIDO] , 0) + coalesce( SEM.[2102_COMPROMETIDO] , 0) + 
                coalesce( SEM.[2103_COMPROMETIDO] , 0) + coalesce( SEM.[2108_COMPROMETIDO] , 0) + coalesce( SEM.[2112_COMPROMETIDO] , 0) + 
                coalesce( SEM.[2113_COMPROMETIDO] , 0) + coalesce( SEM.[2120_COMPROMETIDO] , 0) + coalesce( SEM.[2124_COMPROMETIDO] , 0) + 
                coalesce( SEM.[2125_COMPROMETIDO] , 0) + coalesce( SEM.[2126_COMPROMETIDO] , 0) + coalesce( SEM.[2128_COMPROMETIDO] , 0) + 
                coalesce( SEM.[2130_COMPROMETIDO] , 0) + coalesce( SEM.[2131_COMPROMETIDO] , 0) + coalesce( SEM.[2132_COMPROMETIDO] , 0) + 
                coalesce( SEM.[2133_COMPROMETIDO] , 0) + coalesce( SEM.[2136_COMPROMETIDO] , 0) + coalesce( SEM.[2143_COMPROMETIDO] , 0) + 
                coalesce( SEM.[2146_COMPROMETIDO] , 0) + coalesce( SEM.[2147_COMPROMETIDO] , 0) + coalesce( SEM.[2152_COMPROMETIDO] , 0) + 
                coalesce( SEM.[2201_COMPROMETIDO] , 0)) as ANTERIOR 
        , COALESCE(SEM.[2203_ESTIMADO], 0) [2203_ESTIMADO], COALESCE(SEM.[2204_ESTIMADO], 0) [2204_ESTIMADO], COALESCE(SEM.[2205_ESTIMADO], 0) [2205_ESTIMADO],
                COALESCE(SEM.[2206_ESTIMADO], 0) [2206_ESTIMADO], COALESCE(SEM.[2207_ESTIMADO], 0) [2207_ESTIMADO], 
                COALESCE(SEM.[2208_ESTIMADO], 0) [2208_ESTIMADO], COALESCE(SEM.[2209_ESTIMADO], 0) [2209_ESTIMADO], 
                COALESCE(SEM.[2210_ESTIMADO], 0) [2210_ESTIMADO], COALESCE(SEM.[2211_ESTIMADO], 0) [2211_ESTIMADO] , 
                COALESCE(SEM.[2203_COMPROMETIDO], 0) [2203_COMPROMETIDO], COALESCE(SEM.[2204_COMPROMETIDO], 0) [2204_COMPROMETIDO], 
                COALESCE(SEM.[2205_COMPROMETIDO], 0) [2205_COMPROMETIDO], COALESCE(SEM.[2206_COMPROMETIDO], 0) [2206_COMPROMETIDO], 
                COALESCE(SEM.[2207_COMPROMETIDO], 0) [2207_COMPROMETIDO], COALESCE(SEM.[2208_COMPROMETIDO], 0) [2208_COMPROMETIDO], 
                COALESCE(SEM.[2209_COMPROMETIDO], 0) [2209_COMPROMETIDO], COALESCE(SEM.[2210_COMPROMETIDO], 0) [2210_COMPROMETIDO], 
                COALESCE(SEM.[2211_COMPROMETIDO], 0) [2211_COMPROMETIDO] , (coalesce( SEM.[2211_ESTIMADO] , 0) + 
                coalesce( SEM.[2212_ESTIMADO] , 0) + coalesce( SEM.[2213_ESTIMADO] , 0) + coalesce( SEM.[2216_ESTIMADO] , 0) + 
                coalesce( SEM.[2217_ESTIMADO] , 0) + coalesce( SEM.[2220_ESTIMADO] , 0) + coalesce( SEM.[2222_ESTIMADO] , 0) + 
                coalesce( SEM.[2252_ESTIMADO] , 0) + coalesce( SEM.[2306_ESTIMADO] , 0) + coalesce( SEM.[2308_ESTIMADO] , 0) + 
                coalesce( SEM.[2211_COMPROMETIDO] , 0) + coalesce( SEM.[2212_COMPROMETIDO] , 0) + coalesce( SEM.[2213_COMPROMETIDO] , 0) + 
                coalesce( SEM.[2216_COMPROMETIDO] , 0) + coalesce( SEM.[2217_COMPROMETIDO] , 0) + coalesce( SEM.[2220_COMPROMETIDO] , 0) + 
                coalesce( SEM.[2222_COMPROMETIDO] , 0) + coalesce( SEM.[2252_COMPROMETIDO] , 0) + coalesce( SEM.[2306_COMPROMETIDO] , 0) + 
                coalesce( SEM.[2308_COMPROMETIDO] , 0)) as RESTO 
FROM OrdenesVenta 
INNER JOIN Clientes ON OV_CLI_ClienteId = CLI_ClienteId 
LEFT JOIN Proyectos ON OV_PRO_ProyectoId = PRY_ProyectoId AND PRY_Activo = 1 AND PRY_Borrado = 0 
LEFT JOIN (  SELECT OVD_OV_OrdenVentaId
                , SUM(OVD_CantidadRequerida * OVD_PrecioUnitario) AS SUBTOTAL
                , SUM(OVD_CantidadRequerida * OVD_PrecioUnitario * ISNULL(OVD_PorcentajeDescuento, 0.0)) AS DESCUENTO
                , SUM(((OVD_CantidadRequerida * OVD_PrecioUnitario) - (OVD_CantidadRequerida * OVD_PrecioUnitario *
                  ISNULL(OVD_PorcentajeDescuento, 0.0))) * ISNULL(OVD_CMIVA_Porcentaje, 0.0)) AS IVA
                , SUM(OVD_CantidadRequerida) OVD_CantidadRequerida 
             FROM OrdenesVentaDetalle 
             LEFT JOIN ArticulosEspecificaciones ON OVD_ART_ArticuloId = AET_ART_ArticuloId AND AET_CMM_ArticuloEspecificaciones = 'DF85FC23-720F-4E99-A794-FCE3F8D3B66F' 
             GROUP BY OVD_OV_OrdenVentaId ) AS OrdenesVentaDetalle ON OV_OrdenVentaId = OVD_OV_OrdenVentaId 
LEFT JOIN (  select FTR_OV_OrdenVentaId
                , SUM(CXCPD_MontoAplicado * CXCP_MONP_Paridad) as cantidadPagoFactura 
              from CXCPagos 
              inner join CXCPagosDetalle on CXCP_CXCPagoId = CXCPD_CXCP_CXCPagoId 
              inner join Facturas on CXCPD_FTR_FacturaId = FTR_FacturaId 
              INNER JOIN ControlesMaestrosMultiples ON CXCP_CMM_FormaPagoId = ControlesMaestrosMultiples.CMM_ControlId 
              WHERE CXCP_Eliminado = 0 and CXCP_CMM_FormaPagoId <> 'F86EC67D-79BD-4E1A-A48C-08830D72DA6F' 
              group by FTR_OV_OrdenVentaId ) AS Pagos ON Pagos.FTR_OV_OrdenVentaId = OV_OrdenVentaId 
LEFT JOIN (SELECT PCXC_OV_Id
                , SUM(CASE WHEN PCXC_Activo = 1 THEN COALESCE(PCXC_Cantidad_provision, 0) END) AS CANTPROVISION
                , SUM(CASE WHEN PCXC_Activo = 0 THEN COALESCE(PCXC_Cantidad, 0) END) AS CANTPROVISION_PAGADAS 
        FROM RPT_ProvisionCXC 
        WHERE PCXC_Activo = 1 AND PCXC_Eliminado = 0 
        GROUP BY PCXC_OV_Id ) AS PROVISIONES ON PCXC_OV_Id = CONVERT (VARCHAR(100), OV_CodigoOV ) 
LEFT JOIN (SELECT p.* 
        FROM (SELECT PCXC_OV_Id as ov
                , PCXC_Cantidad_provision
                , CASE WHEN PCXC_Concepto = 'RE-NEGOCIADO' THEN [PCXC_Semana_fecha] + '_COMPROMETIDO' ELSE
                  [PCXC_Semana_fecha] + '_' + PCXC_Concepto END as [col] 
               FROM [dbo].[RPT_ProvisionCXC] 
               WHERE PCXC_Activo = 1 AND PCXC_Eliminado = 0 ) AS j PIVOT (SUM(PCXC_Cantidad_provision) FOR [col] in 
               ([2045_ESTIMADO], [2047_ESTIMADO], [2048_ESTIMADO], [2051_ESTIMADO], [2053_ESTIMADO], [2101_ESTIMADO], [2102_ESTIMADO]
               , [2103_ESTIMADO], [2108_ESTIMADO], [2112_ESTIMADO], [2113_ESTIMADO], [2120_ESTIMADO], [2124_ESTIMADO], [2125_ESTIMADO]
               , [2126_ESTIMADO], [2128_ESTIMADO], [2130_ESTIMADO], [2131_ESTIMADO], [2132_ESTIMADO], [2133_ESTIMADO], [2136_ESTIMADO]
               , [2143_ESTIMADO], [2146_ESTIMADO], [2147_ESTIMADO], [2152_ESTIMADO], [2201_ESTIMADO], [2203_ESTIMADO], [2204_ESTIMADO]
               , [2205_ESTIMADO], [2206_ESTIMADO], [2207_ESTIMADO], [2208_ESTIMADO], [2209_ESTIMADO], [2210_ESTIMADO], [2211_ESTIMADO]
               , [2212_ESTIMADO], [2213_ESTIMADO], [2216_ESTIMADO], [2217_ESTIMADO], [2220_ESTIMADO], [2222_ESTIMADO], [2252_ESTIMADO]
               , [2306_ESTIMADO], [2308_ESTIMADO], [2045_COMPROMETIDO], [2047_COMPROMETIDO], [2048_COMPROMETIDO], [2051_COMPROMETIDO]
               , [2053_COMPROMETIDO], [2101_COMPROMETIDO], [2102_COMPROMETIDO], [2103_COMPROMETIDO], [2108_COMPROMETIDO]
               , [2112_COMPROMETIDO], [2113_COMPROMETIDO], [2120_COMPROMETIDO], [2124_COMPROMETIDO], [2125_COMPROMETIDO]
               , [2126_COMPROMETIDO], [2128_COMPROMETIDO], [2130_COMPROMETIDO], [2131_COMPROMETIDO], [2132_COMPROMETIDO]
               , [2133_COMPROMETIDO], [2136_COMPROMETIDO], [2143_COMPROMETIDO], [2146_COMPROMETIDO], [2147_COMPROMETIDO]
               , [2152_COMPROMETIDO], [2201_COMPROMETIDO], [2203_COMPROMETIDO], [2204_COMPROMETIDO], [2205_COMPROMETIDO]
               , [2206_COMPROMETIDO], [2207_COMPROMETIDO], [2208_COMPROMETIDO], [2209_COMPROMETIDO], [2210_COMPROMETIDO]
               , [2211_COMPROMETIDO], [2212_COMPROMETIDO], [2213_COMPROMETIDO], [2216_COMPROMETIDO], [2217_COMPROMETIDO]
               , [2220_COMPROMETIDO], [2222_COMPROMETIDO], [2252_COMPROMETIDO], [2306_COMPROMETIDO], [2308_COMPROMETIDO])) AS p ) AS SEM 
                ON ov = CONVERT (VARCHAR(100), OV_CodigoOV ) 
LEFT JOIN Monedas ON OV_MON_MonedaId = Monedas.MON_MonedaId 
LEFT JOIN ( SELECT FTR_OV_OrdenVentaId
                , SUM((FTRD_CantidadRequerida * FTRD_PrecioUnitario) - (FTRD_CantidadRequerida * FTRD_PrecioUnitario * 
                ISNULL(FTRD_PorcentajeDescuento, 0.0)) + (((FTRD_CantidadRequerida * FTRD_PrecioUnitario) - (FTRD_CantidadRequerida 
                * FTRD_PrecioUnitario * ISNULL(FTRD_PorcentajeDescuento, 0.0))) * ISNULL(FTRD_CMIVA_Porcentaje, 0.0))) AS FTR_TOTAL
                , SUM (FTRD_CantidadRequerida) FTRD_CantidadRequerida 
        FROM Facturas  
        inner join FacturasDetalle fd on fd.FTRD_FTR_FacturaId = Facturas.FTR_FacturaId 
        WHERE FTR_Eliminado = 0 
        GROUP BY FTR_OV_OrdenVentaId ) AS Facturas ON Facturas.FTR_OV_OrdenVentaId = OV_OrdenVentaId 
LEFT JOIN (Select OVD_OV_OrdenVentaId AS OVD_id
                , SUM((BULD_Cantidad * OVD_PrecioUnitario) - ( BULD_Cantidad * OVD_PrecioUnitario * 
                ISNULL(OVD_PorcentajeDescuento, 0.0) ) + ( ((BULD_Cantidad * OVD_PrecioUnitario) - (BULD_Cantidad *
                OVD_PrecioUnitario * ISNULL(OVD_PorcentajeDescuento, 0.0))) * ISNULL(OVD_CMIVA_Porcentaje, 0.0) )) AS EMB_TOTAL 
        from EmbarquesBultosDetalle 
        Inner Join PreembarqueBultoDetalle on EMBBD_PREBD_PreembarqueBultoDetalleId = PREBD_PreembarqueBultoDetalleId and PREBD_Eliminado = 0 
        Inner Join BultosDetalle on PREBD_BULD_BultoDetalleId = BULD_BultoDetalleId and BULD_Eliminado = 0 
        Inner Join OrdenesTrabajoReferencia on BULD_OT_OrdenTrabajoId = OTRE_OT_OrdenTrabajoId 
        Inner Join OrdenesVentaDetalle on OVD_OV_OrdenVentaId = OTRE_OV_OrdenVentaId and OVD_ART_ArticuloId = BULD_ART_ArticuloId 
        Inner Join EmbarquesBultos on EMBB_EmbarqueBultoId = EMBBD_EMBB_EmbarqueBultoId 
        Where EMBBD_Eliminado = 0 
        GROUP BY OVD_OV_OrdenVentaId ) AS Embarque ON OVD_id = OV_OrdenVentaId 
LEFT JOIN (SELECT FTR_OV_OrdenVentaId
                , SUM (CXCP_MontoPago * CXCP_MONP_Paridad * - 1) as TotalNC 
         From CXCPagos 
         Inner Join CXCPagosDetalle on CXCP_CXCPagoId = CXCPD_CXCP_CXCPagoId 
         inner Join NotasCredito on NC_NotaCreditoId = CXCPD_NC_NotaCreditoId 
         inner join NotasCreditoDetalle on NCD_NC_NotaCreditoId = NC_NotaCreditoId 
         inner join Facturas on NC_FTR_FacturaId = FTR_FacturaId 
         Where CXCP_Eliminado = 0 
         GROUP BY FTR_OV_OrdenVentaId) AS NotaCredito ON NotaCredito.FTR_OV_OrdenVentaId = OV_OrdenVentaId 
GROUP BY SEM.ov, [2045_ESTIMADO], [2047_ESTIMADO], [2048_ESTIMADO], [2051_ESTIMADO], [2053_ESTIMADO], [2101_ESTIMADO], [2102_ESTIMADO]
        , [2103_ESTIMADO], [2108_ESTIMADO], [2112_ESTIMADO], [2113_ESTIMADO], [2120_ESTIMADO], [2124_ESTIMADO], [2125_ESTIMADO]
        , [2126_ESTIMADO], [2128_ESTIMADO], [2130_ESTIMADO], [2131_ESTIMADO], [2132_ESTIMADO], [2133_ESTIMADO], [2136_ESTIMADO]
        , [2143_ESTIMADO], [2146_ESTIMADO], [2147_ESTIMADO], [2152_ESTIMADO], [2201_ESTIMADO], [2203_ESTIMADO], [2204_ESTIMADO]
        , [2205_ESTIMADO], [2206_ESTIMADO], [2207_ESTIMADO], [2208_ESTIMADO], [2209_ESTIMADO], [2210_ESTIMADO], [2211_ESTIMADO]
        , [2212_ESTIMADO], [2213_ESTIMADO], [2216_ESTIMADO], [2217_ESTIMADO], [2220_ESTIMADO], [2222_ESTIMADO], [2252_ESTIMADO]
        , [2306_ESTIMADO], [2308_ESTIMADO], [2045_COMPROMETIDO], [2047_COMPROMETIDO], [2048_COMPROMETIDO], [2051_COMPROMETIDO]
        , [2053_COMPROMETIDO], [2101_COMPROMETIDO], [2102_COMPROMETIDO], [2103_COMPROMETIDO], [2108_COMPROMETIDO], [2112_COMPROMETIDO]
        , [2113_COMPROMETIDO], [2120_COMPROMETIDO], [2124_COMPROMETIDO], [2125_COMPROMETIDO], [2126_COMPROMETIDO], [2128_COMPROMETIDO]
        , [2130_COMPROMETIDO], [2131_COMPROMETIDO], [2132_COMPROMETIDO], [2133_COMPROMETIDO], [2136_COMPROMETIDO], [2143_COMPROMETIDO]
        , [2146_COMPROMETIDO], [2147_COMPROMETIDO], [2152_COMPROMETIDO], [2201_COMPROMETIDO], [2203_COMPROMETIDO], [2204_COMPROMETIDO]
        , [2205_COMPROMETIDO], [2206_COMPROMETIDO], [2207_COMPROMETIDO], [2208_COMPROMETIDO], [2209_COMPROMETIDO], [2210_COMPROMETIDO]
        , [2211_COMPROMETIDO], [2212_COMPROMETIDO], [2213_COMPROMETIDO], [2216_COMPROMETIDO], [2217_COMPROMETIDO], [2220_COMPROMETIDO]
        , [2222_COMPROMETIDO], [2252_COMPROMETIDO], [2306_COMPROMETIDO], [2308_COMPROMETIDO], PROVISIONES.CANTPROVISION
        , PROVISIONES.CANTPROVISION_PAGADAS, OV_OrdenVentaId, OV_CodigoOV, CLI_CodigoCliente, CLI_RazonSocial, PRY_CodigoEvento
        , cantidadPagoFactura, SUBTOTAL, DESCUENTO, IVA, PRY_NombreProyecto, OV_FechaOV, OV_ReferenciaOC, OV_MONP_Paridad
        , OV_FechaRequerida, OV_CMM_EstadoOVId, MON_Nombre, EMB_TOTAL, FTR_TOTAL 
ORDER BY OV_CodigoOV
*/


-- Consulta para Reporte de CxC
-- Filtros: Solo ordenes de Venta Abiertas. 

Select CLI_CodigoCliente + ' - ' + CLI_RazonSocial AS CLIENTE
        , PRY_CodigoEvento + ' - ' + PRY_NombreProyecto AS PROYECTO
        , OV_ReferenciaOC AS OC
        , OV_CodigoOV AS OV 
        , CAST((((ROUND(SUBTOTAL, 2)) - (ROUND(DESCUENTO, 2))) + (ROUND(IVA, 2))) as decimal(16,2)) AS IMPORTE
        , MON_Nombre AS MONEDA     
        , CAST(COALESCE(FACT.IMP_FAC, 0) as decimal(16,2)) AS IMPORTE_FACTURADO
        , CAST(COALESCE((Pagos.cantidadPagoFactura), 0) as decimal(16,2)) IMPORTE_COBRADOS
        --, NotaCredito.TotalNC
        , ISNULL((Select STUFF ((Select 'F-' + FTR_NumeroFactura + ' ($ ' +
        CAST(CAST(SUM(FTRD_CantidadRequerida * FTRD_PrecioUnitario -                
        FTRD_CantidadRequerida * FTRD_PrecioUnitario * ISNULL(FTRD_PorcentajeDescuento, 0.0) +
        ((FTRD_CantidadRequerida * FTRD_PrecioUnitario) - (FTRD_CantidadRequerida * FTRD_PrecioUnitario * 
        ISNULL(FTRD_PorcentajeDescuento, 0.0))) * ISNULL(FTRD_CMIVA_Porcentaje, 0.0)) as decimal(16,2)) as VARCHAR(16)) + '), '       
        From Facturas Inner join FacturasDetalle on FTRD_FTR_FacturaId = FTR_FacturaId  
        Where FTR_Eliminado = 0 and FTR_OV_OrdenVentaId = OV_OrdenVentaId
        Group By FTR_NumeroFactura
        FOR XML PATH ('')), 1, 0, '')), 'S/F') AS N_FAC    
From OrdenesVenta 
Inner Join Clientes ON OV_CLI_ClienteId = CLI_ClienteId 
Left Join Proyectos ON OV_PRO_ProyectoId = PRY_ProyectoId AND PRY_Activo = 1 AND PRY_Borrado = 0 
LEFT JOIN Monedas ON OV_MON_MonedaId = Monedas.MON_MonedaId 

LEFT JOIN (SELECT OVD_OV_OrdenVentaId
        , SUM(OVD_CantidadRequerida * OVD_PrecioUnitario) AS SUBTOTAL
        , SUM(OVD_CantidadRequerida * OVD_PrecioUnitario * ISNULL(OVD_PorcentajeDescuento, 0.0)) AS DESCUENTO
        , SUM(((OVD_CantidadRequerida * OVD_PrecioUnitario) - (OVD_CantidadRequerida * OVD_PrecioUnitario *
        ISNULL(OVD_PorcentajeDescuento, 0.0))) * ISNULL(OVD_CMIVA_Porcentaje, 0.0)) AS IVA
        , SUM(OVD_CantidadRequerida) OVD_CantidadRequerida 
        FROM OrdenesVentaDetalle 
        LEFT JOIN ArticulosEspecificaciones ON OVD_ART_ArticuloId = AET_ART_ArticuloId AND AET_CMM_ArticuloEspecificaciones = 'DF85FC23-720F-4E99-A794-FCE3F8D3B66F' 
        GROUP BY OVD_OV_OrdenVentaId ) AS OrdenesVentaDetalle ON OV_OrdenVentaId = OVD_OV_OrdenVentaId 

LEFT JOIN (  select FTR_OV_OrdenVentaId
        , SUM(CXCPD_MontoAplicado * CXCP_MONP_Paridad) as cantidadPagoFactura 
        from CXCPagos 
        inner join CXCPagosDetalle on CXCP_CXCPagoId = CXCPD_CXCP_CXCPagoId 
        inner join Facturas on CXCPD_FTR_FacturaId = FTR_FacturaId 
        INNER JOIN ControlesMaestrosMultiples ON CXCP_CMM_FormaPagoId = ControlesMaestrosMultiples.CMM_ControlId 
        WHERE CXCP_Eliminado = 0 and CXCP_CMM_FormaPagoId <> 'F86EC67D-79BD-4E1A-A48C-08830D72DA6F' 
        group by FTR_OV_OrdenVentaId ) AS Pagos ON Pagos.FTR_OV_OrdenVentaId = OV_OrdenVentaId 

Left Join (Select FTR_OV_OrdenVentaId AS ID_OV
        , SUM(FTRD_CantidadRequerida * FTRD_PrecioUnitario -                
        FTRD_CantidadRequerida * FTRD_PrecioUnitario * ISNULL(FTRD_PorcentajeDescuento, 0.0) +
        ((FTRD_CantidadRequerida * FTRD_PrecioUnitario) - (FTRD_CantidadRequerida * FTRD_PrecioUnitario * 
        ISNULL(FTRD_PorcentajeDescuento, 0.0))) * ISNULL(FTRD_CMIVA_Porcentaje, 0.0)) as IMP_FAC      
        From Facturas                
        Inner join FacturasDetalle on FTRD_FTR_FacturaId = FTR_FacturaId  
        Where FTR_Eliminado = 0 
        Group By FTR_OV_OrdenVentaId) AS FACT ON ID_OV = OV_OrdenVentaId
        
/*
LEFT JOIN (SELECT   NC_FTR_FacturaId ,   
        (SUM(ISNULL( NCD_Cantidad*NCD_PrecioUnitario , 0.0)) + (SUM(ISNULL( NCD_Cantidad*NCD_PrecioUnitario , 0.0)) * (ISNULL( NCD_CMIVA_Porcentaje , 0.0) ))) AS TotalNC,
        NC_MON_MonedaId   
        FROM NotasCredito   
        INNER JOIN NotasCreditoDetalle ON NC_NotaCreditoId = NCD_NC_NotaCreditoId   
        INNER JOIN Clientes ON NC_CLI_ClienteId = CLI_ClienteId   
        INNER JOIN Monedas ON NC_MON_MonedaId = MON_MonedaId   
        WHERE NC_FTR_FacturaId IS NOT NULL AND   NC_Eliminado = 0   
        GROUP BY  NCD_CMIVA_Porcentaje,   NC_MON_MonedaId ,   NC_FTR_FacturaId   
        ) AS NotaCredito ON Facturas.FTR_FacturaId = NC_FTR_FacturaId AND FTR_MON_MonedaId = NC_MON_MonedaId           
*/
              
        
Where OV_CMM_EstadoOVId = '3CE37D96-1E8A-49A7-96A1-2E837FA3DCF5'
Order By CLI_RazonSocial, OV_CodigoOV, PRY_NombreProyecto


--and CLI_CodigoCliente = 'C00015'
/*
SELECT   NC_FTR_FacturaId ,   
        (SUM(ISNULL( NCD_Cantidad*NCD_PrecioUnitario , 0.0)) + (SUM(ISNULL( NCD_Cantidad*NCD_PrecioUnitario , 0.0)) * (ISNULL( NCD_CMIVA_Porcentaje , 0.0) ))) AS TotalNC,
        NC_MON_MonedaId   
        FROM NotasCredito   
        INNER JOIN NotasCreditoDetalle ON NC_NotaCreditoId = NCD_NC_NotaCreditoId   
        INNER JOIN Clientes ON NC_CLI_ClienteId = CLI_ClienteId   
        INNER JOIN Monedas ON NC_MON_MonedaId = MON_MonedaId   
        WHERE NC_FTR_FacturaId IS NOT NULL AND   NC_Eliminado = 0   
        GROUP BY  NCD_CMIVA_Porcentaje,   NC_MON_MonedaId ,   NC_FTR_FacturaId   
        
        */