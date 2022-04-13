-- Consulta para sacar Datos de Resumen de CxC
-- Elaboro: Ing. Alberto Jimenez Medina.
-- Actualizado: Jueves 10 de Diciembre del 2020; Enviado.

SELECT  OV_OrdenVentaId AS DT_ID,   
        OV_CodigoOV AS CODIGO,   
        OV_CMM_EstadoOVId AS EstadoOV,   
        CASE    WHEN OV_CMM_EstadoOVId = '3CE37D96-1E8A-49A7-96A1-2E837FA3DCF5' THEN 'Abierta'    
                WHEN OV_CMM_EstadoOVId = '2209C8BF-8259-4D8C-A0E9-389F52B33B46' THEN 'Cerrada'    
                WHEN OV_CMM_EstadoOVId = 'D528E9EC-83CF-49BE-AEED-C3751A3B0F27' THEN 'Embarque Completo'    
                ELSE 'Cancelado' END ESTATUS_OV,   
        CLI_CodigoCliente + ' - ' + CLI_RazonSocial AS CLIENTE,    
        PRY_CodigoEvento + ' - ' + PRY_NombreProyecto AS PROYECTO,    
        CCON_Nombre as COMPRADOR,   
        CONVERT(varchar, OV_FechaOV,103) AS FECHA_OV,   
        OV_ReferenciaOC,    
        (SUM(ROUND(SUBTOTAL,2)) - SUM(ROUND(DESCUENTO, 2))) + SUM(ROUND(IVA, 2)) AS TOTAL,
        (ISNULL(SUM(ROUND(FTR_SUBTOTAL,2)), 0.0) - ISNULL(SUM(ROUND(FTR_DESCUENTO, 2)), 0.0) ) + ISNULL(SUM(ROUND(FTR_IVA, 2)), 0.0) AS FTR_TOTAL,
        ((SUM(ROUND(SUBTOTAL,2)) - SUM(ROUND(DESCUENTO, 2))) + SUM(ROUND(IVA, 2))) - ((ISNULL(SUM(ROUND(FTR_SUBTOTAL,2)), 0.0) - ISNULL(SUM(ROUND(FTR_DESCUENTO, 2)), 0.0) ) + ISNULL(SUM(ROUND(FTR_IVA, 2)), 0.0)) AS IMPORTE_XFACTURAR,
        SUM(OrdenesVentaDetalle.OVD_CantidadRequerida) - ISNULL(SUM(FTRD_CantidadRequerida), 0.0) AS CANTIDAD_PENDIENTE,
        COALESCE(SUM(NotaCredito.TotalNC), 0) TotalNC,   
        ((ISNULL(SUM(ROUND(FTR_SUBTOTAL,2)), 0.0) - ISNULL(SUM(ROUND(FTR_DESCUENTO, 2)), 0.0) ) + ISNULL(SUM(ROUND(FTR_IVA, 2)), 0.0)) - COALESCE(SUM(NotaCredito.TotalNC), 0) AS IMPORTE_FACTURADO,
        COALESCE(SUM(Pagos.cantidadPagoFactura), 0) PAGOS_FACTURAS,
        (SUM(ROUND(SUBTOTAL,2)) - SUM(ROUND(DESCUENTO, 2))) + SUM(ROUND(IVA, 2)) - COALESCE(SUM(Pagos.cantidadPagoFactura), 0) AS X_PAGAR,
        CANTPROVISION,   
        CASE    WHEN ((SUM(ROUND(SUBTOTAL,2)) - SUM(ROUND(DESCUENTO, 2))) + SUM(ROUND(IVA, 2)) - COALESCE(SUM(Pagos.cantidadPagoFactura), 0)) > 0 AND CANTPROVISION IS NULL THEN 'SIN CAPTURA'   
                WHEN ((SUM(ROUND(SUBTOTAL,2)) - SUM(ROUND(DESCUENTO, 2))) + SUM(ROUND(IVA, 2)) - COALESCE(SUM(Pagos.cantidadPagoFactura), 0)) > CANTPROVISION THEN 'INCOMPLETO'   
                WHEN ((SUM(ROUND(SUBTOTAL,2)) - SUM(ROUND(DESCUENTO, 2))) + SUM(ROUND(IVA, 2)) - COALESCE(SUM(Pagos.cantidadPagoFactura), 0)) = CANTPROVISION THEN 'PROVISIONADO'   
                ELSE 'NO ESPECIFICADO' END AS PROVISION, 
        COALESCE(SUM(Embarque.EMB_TOTAL), 0 ) AS EMBARCADO,  
        ((SUM(ROUND(SUBTOTAL,2)) - SUM(ROUND(DESCUENTO, 2))) + SUM(ROUND(IVA, 2))) - COALESCE(SUM(Embarque.EMB_TOTAL), 0 ) AS IMPORTE_XEMBARCAR   
FROM OrdenesVenta    
INNER JOIN Clientes ON OV_CLI_ClienteId = CLI_ClienteId   
LEFT JOIN Proyectos ON OV_PRO_ProyectoId = PRY_ProyectoId AND PRY_Activo = 1 AND PRY_Borrado = 0   
INNER JOIN ClientesContactos ON OV_CCON_ContactoId = CCON_ContactoId AND CCON_Eliminado = 0             
LEFT JOIN (

SELECT  OVD_DetalleId, OVD_OV_OrdenVentaId, OVD_CantidadRequerida * OVD_PrecioUnitario AS SUBTOTAL,
        OVD_CantidadRequerida * OVD_PrecioUnitario * ISNULL(OVD_PorcentajeDescuento, 0.0) AS DESCUENTO,
        ((OVD_CantidadRequerida * OVD_PrecioUnitario) - (OVD_CantidadRequerida * OVD_PrecioUnitario * ISNULL(OVD_PorcentajeDescuento, 0.0))) * ISNULL(OVD_CMIVA_Porcentaje, 0.0) AS IVA,
        OVD_CantidadRequerida              
FROM OrdenesVentaDetalle   
LEFT JOIN ArticulosEspecificaciones ON OVD_ART_ArticuloId = AET_ART_ArticuloId AND AET_CMM_ArticuloEspecificaciones = 'DF85FC23-720F-4E99-A794-FCE3F8D3B66F') AS OrdenesVentaDetalle ON OV_OrdenVentaId = OVD_OV_OrdenVentaId             

LEFT JOIN (

SELECT  FTR_FacturaId,
        FTR_MON_MonedaId, 
        FTR_OV_OrdenVentaId,                
        FTRD_CantidadRequerida * FTRD_PrecioUnitario AS FTR_SUBTOTAL,                
        FTRD_CantidadRequerida * FTRD_PrecioUnitario * ISNULL(FTRD_PorcentajeDescuento, 0.0) AS FTR_DESCUENTO,
        ((FTRD_CantidadRequerida * FTRD_PrecioUnitario) - (FTRD_CantidadRequerida * FTRD_PrecioUnitario * ISNULL(FTRD_PorcentajeDescuento, 0.0))) * ISNULL(FTRD_CMIVA_Porcentaje, 0.0) AS FTR_IVA,
        FTRD_ReferenciaId, 
        FTRD_CantidadRequerida                
FROM Facturas                
inner join FacturasDetalle fd on fd.FTRD_FTR_FacturaId = Facturas.FTR_FacturaId  
WHERE FTR_Eliminado = 0                 
GROUP BY FTR_MON_MonedaId, FTR_FacturaId, FTRD_ReferenciaId, FTR_OV_OrdenVentaId, FTRD_CantidadRequerida, FTRD_PrecioUnitario, FTRD_PorcentajeDescuento,
FTRD_CMIVA_Porcentaje ) AS Facturas ON OVD_DetalleId = FTRD_ReferenciaId       

LEFT JOIN (   
SELECT   NC_FTR_FacturaId ,   
        (SUM(ISNULL( NCD_Cantidad*NCD_PrecioUnitario , 0.0)) + (SUM(ISNULL( NCD_Cantidad*NCD_PrecioUnitario , 0.0)) * (ISNULL( NCD_CMIVA_Porcentaje , 0.0) ))) AS TotalNC,
        NC_MON_MonedaId   
FROM NotasCredito   
INNER JOIN NotasCreditoDetalle ON NC_NotaCreditoId = NCD_NC_NotaCreditoId   
INNER JOIN Clientes ON NC_CLI_ClienteId = CLI_ClienteId   
INNER JOIN Monedas ON NC_MON_MonedaId = MON_MonedaId   
WHERE NC_FTR_FacturaId IS NOT NULL AND   NC_Eliminado = 0   
GROUP BY  NCD_CMIVA_Porcentaje,   NC_MON_MonedaId ,   NC_FTR_FacturaId   
) AS NotaCredito ON Facturas.FTR_FacturaId = NC_FTR_FacturaId AND FTR_MON_MonedaId = NC_MON_MonedaId           

LEFT JOIN (       
SELECT  (OVD_CantidadRequerida * OVD_PrecioUnitario) - ( OVD_CantidadRequerida * OVD_PrecioUnitario * ISNULL(OVD_PorcentajeDescuento, 0.0) ) + ( ((OVD_CantidadRequerida * OVD_PrecioUnitario) - (OVD_CantidadRequerida * OVD_PrecioUnitario * ISNULL(OVD_PorcentajeDescuento, 0.0))) * ISNULL(OVD_CMIVA_Porcentaje, 0.0) ) AS EMB_TOTAL,
        EMBD_OVD_DetalleId          
FROM OrdenesVentaDetalle   
INNER JOIN EmbarquesDetalle ON OVD_DetalleId = EMBD_OVD_DetalleId   
INNER JOIN Embarques ON EMB_EmbarqueId = EMBD_EMB_EmbarqueId       
WHERE EMBD_OVD_DetalleId IS NOT NULL 
) AS Embarque ON EMBD_OVD_DetalleId = OVD_DetalleId      

LEFT JOIN ( 
SELECT  CXCPD_FTR_FacturaId ,   
        ROUND( ISNULL( SUM( ABS(CXCPD_MontoAplicado )), 0.0), 2) AS cantidadPagoFactura,   
        CXCP_MON_MonedaId ,   
        CXCP_CLI_ClienteId   
FROM CXCPagos   
INNER JOIN CXCPagosDetalle ON CXCP_CXCPagoId = CXCPD_CXCP_CXCPagoId   
WHERE CXCP_Eliminado = 0 AND CXCPD_FTR_FacturaId is not null   
GROUP BY  CXCPD_FTR_FacturaId, CXCP_MON_MonedaId, CXCP_CLI_ClienteId   
) AS Pagos ON FTR_FacturaId = CXCPD_FTR_FacturaId AND   FTR_MON_MonedaId = CXCP_MON_MonedaId    

LEFT JOIN (      
SELECT  PCXC_OV_Id ,
        SUM(COALESCE(PCXC_Cantidad_provision,0)) AS CANTPROVISION      
FROM RPT_ProvisionCXC      
WHERE PCXC_Activo = 1 AND PCXC_Eliminado = 0      
GROUP BY PCXC_OV_Id     
) AS PROVISIONES ON PCXC_OV_Id = CONVERT (VARCHAR(100), OV_CodigoOV ) 

--WHERE OV_CodigoOV = 'OV00320'


GROUP BY CANTPROVISION, OV_OrdenVentaId, OV_CodigoOV, CLI_CodigoCliente, CLI_RazonSocial, PRY_CodigoEvento, PRY_NombreProyecto, OV_FechaOV,   
OV_ReferenciaOC, OV_FechaRequerida, OV_CMM_EstadoOVId, CCON_Nombre   
ORDER BY  OV_CodigoOV
 

 



 

