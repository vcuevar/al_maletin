
SELECT        *
FROM            (SELECT 'F' AS tipodoc, FP_FacturaProveedorId AS DT_RowId, PRO_ProveedorId, FP_CMM_TipoFactura AS TIPO_REGISTRO, /*TIENDA.CMM_Valor AS TIENDA,*/ PRO_CodigoProveedor + ' - ' + PRO_Nombre AS proveedor, PRO_RFC, 
                                                    FP_CFDI_CfdiId AS XML_Id, FP_CodigoFactura AS CODIGO, CAST(FP_FechaFactura AS DATE) AS FECHA, CAST((DATEADD(day, TEP_DiasVencimiento, FP_FechaFactura)) AS DATE) AS VENCIMIENTO, 
                                                    dbo.getMontoFacturaProveedor(FP_FacturaProveedorId) AS MONTO, '' montopago, dbo.getSaldoFacturaProveedores(FP_FacturaProveedorId) AS SALDO, (COALESCE (FacturasProveedores.FP_RetencionISR, 0) 
                                                    + COALESCE (FacturasProveedores.FP_RetencionIVA, 0)) AS RETENCIONES, DBO.TIPOS_DE_IVA_PROVEEDOR(FP_CMM_TipoFactura, FP_FacturaProveedorId) AS IVAS, FP_MONP_Paridad AS PARIDAD, 
                                                    FP_MON_MonedaId AS MON_MonedaId
                          FROM            FacturasProveedores /*INNER JOIN FacturasDatos ON FTD_FP_FacturaId = FP_FacturaId*/ INNER JOIN
                                                    Proveedores ON PRO_ProveedorId = FP_PRO_ProveedorId INNER JOIN
                                                    ProveedoresCriteriosAdmon ON PCA_PRO_ProveedorId = PRO_ProveedorId /*LEFT JOIN TerminosPago ON TEP_TerminoPagoId = FTD_TEP_TerminoPagoId*/ LEFT JOIN
                                                    TerminosPago ON TEP_TerminoPagoId = PCA_TEP_TerminosPagoId LEFT JOIN
                                                    Monedas ON MON_MonedaId = FP_MON_MonedaId
                          WHERE        /*---AND */ FP_Eliminado = 0 AND CAST(FP_FechaFactura AS DATE) >= '2022/06/01' AND CAST(FP_FechaFactura AS DATE) <= GETDATE()
                          and PRO_CodigoProveedor like '%P0993%'
                          ) AS FACT
                          
WHERE        SALDO > 0
UNION ALL
SELECT        *
FROM            (SELECT 'N' AS tipodoc, ND_NotaDebitoId AS DT_RowId, PRO_ProveedorId,
                                                        (SELECT        TOP 1 CMM_ControlId
                                                          FROM            ControlesMaestrosMultiples
                                                          WHERE        CMM_Control = 'CMM_CCXP_NotaDebito') AS TIPO_REGISTRO, proveedor, PRO_RFC, XML_Id, CODIGO, CAST(FECHA AS DATE) AS FECHA, CAST(FECHA AS DATE) AS VENCIMIENTO, 
                                                    CAST(ROUND(MONTO * - 1, 2) AS DECIMAL(28, 2)) AS MONTO, montopago, CAST(ROUND((Monto * - 1) + ISNULL(MontoPago, 0.0), 2) AS DECIMAL(28, 2)) AS SALDO, 0 AS RETENCIONES, dbo.TIPOS_DE_IVA_PROVEEDOR(NULL, 
                                                    ND_NotaDebitoId) AS IVAS, PARIDAD, ND_MON_MonedaId AS MON_MonedaId
                          FROM            (SELECT        PRO_CodigoProveedor + ' - ' + PRO_Nombre AS proveedor, PRO_RFC, PRO_ProveedorId, ND_MON_MonedaId, ND_NotaDebitoId, ND_CodigoNotaDebito AS CODIGO, ND_CFDI_CfdiId AS XML_Id, 
                                                                              ND_FechaUltimaModificacion AS FECHA, ROUND(SUM(NDD_Monto) + (SUM((NDD_Monto) * (ISNULL(NDD_CMIVA_Porcentaje, 0)))), 2) AS MONTO, ND_MONP_Paridad AS PARIDAD
                                                    FROM            NotasDebito /*LEFT JOIN ControlesMaestrosMultiples on NC_CMM_CuentaCXCId = CMM_ControlId*/ INNER JOIN
                                                                              NotasDebitoDetalle ON NDD_ND_NotaDebitoId = ND_NotaDebitoId INNER JOIN
                                                                              Proveedores ON PRO_ProveedorId = ND_PRO_ProveedorId
                                                    /*LEFT JOIN ControlesMaestrosMultiples ON CMM_ControlId = CDE_CMM_TipoTiendaId*/ 
                                                    WHERE /*---AND */ ND_Eliminado = 0 AND CAST(ND_FechaNotaDebito AS DATE) >= '2022/06/01' AND 
                                                                              CAST(ND_FechaNotaDebito AS DATE) <= GETDATE()
                                                                              and PRO_CodigoProveedor like '%P0993%'
                                                    GROUP BY ND_NotaDebitoId, ND_CodigoNotaDebito, ND_FechaUltimaModificacion, /*CMM_Valor,*/ ND_MONP_Paridad, ND_MON_MonedaId, PRO_CodigoProveedor, PRO_Nombre, PRO_RFC, PRO_ProveedorId, 
                                                                              NotasDebito.ND_CFDI_CfdiId) AS Tabla1 LEFT JOIN
                                                        (SELECT        CXPPD_ND_NotaDebitoId AS IdNota, SUM(CXPPD_MontoAplicado) AS MontoPago
                                                          FROM            CXPPagosDetalle INNER JOIN
                                                                                    CXPPagos ON CXPP_CXPPagoId = CXPPD_CXPP_CXPPagoId
                                                          WHERE        CXPP_Eliminado = 0
                                                          GROUP BY CXPPD_ND_NotaDebitoId) AS Tabla2 ON ND_NotaDebitoId = IdNota) AS Tabla2
WHERE        Saldo < 0
UNION ALL
SELECT   'P' AS tipodoc, PAGO_ID AS DT_RowId, PRO_ProveedorId, TIPO_REGISTRO, proveedor, PRO_RFC, XML_Id, CODIGO, CXPP_FechaCaptura AS FECHA, NULL AS VENCIMIENTO, CAST(ROUND(Monto + ISNULL(MontoPago, 0.0), 2) AS DECIMAL(28, 
                         2)) AS MONTO, montopago, CAST(ROUND(Saldo + ISNULL(MontoPago, 0.0), 2) AS DECIMAL(28, 2)) AS SALDO, 0 AS RETENCIONES, /*0.0,*/ NULL AS IVAS, /*null,*/ CXPP_ParidadUsuario AS PARIDAD, 
                         /*null*/ CXPP_MON_MonedaId AS MON_MonedaId
FROM            ((SELECT        PRO_CodigoProveedor + ' - ' + PRO_Nombre AS proveedor, PRO_RFC, PRO_ProveedorId, CXPPD_CMM_TipoRegistro AS TIPO_REGISTRO, CXPP_CXPPagoId AS PAGO_ID, CXPP_Descripcion AS CODIGO, 
                                                     CXPP_CFDI_CfdiId AS XML_Id, CXPPD_MontoAplicado AS Monto, CXPPD_MontoAplicado AS Saldo, CXPP_ParidadUsuario, CAST(CXPP_FechaCaptura AS DATE) AS CXPP_FechaCaptura, CXPP_MON_MonedaId
                            FROM            CXPPagos INNER JOIN
                                                     CXPPagosDetalle ON CXPP_CXPPagoId = CXPPD_CXPP_CXPPagoId INNER JOIN
                                                     Proveedores ON PRO_ProveedorId = CXPP_PRO_ProveedorId
                            /*LEFT JOIN ControlesMaestrosMultiples ON CMM_ControlId = CDE_CMM_TipoTiendaId*/ 
                            WHERE CXPP_CMM_TipoRegistro = '1ED4BE9A-C32E-4973-827E-48B0AD254755' /*---AND CXPP_MON_MonedaId = '748BE9C9-B56D-4FD2-A77F-EE4C6CD226A1'*/ AND
                                  CXPP_Eliminado = 0 AND CXPP_Descripcion LIKE '$%' AND CXPPD_MontoAplicado <= 0.01 /*AND CAST(CXPP_FechaPago AS DATE)  >= '2022/06/01'    */ AND CAST(CXPP_FechaPago AS DATE) <= GETDATE()
                                            and PRO_CodigoProveedor like '%P0993%'          
                                                      ) 
                         AS Tabla11 LEFT JOIN
                             (SELECT        CXPPD_RegistroPagoId AS id, SUM(CXPPD_MontoAplicado) AS MontoPago
                               FROM            CXPPagosDetalle INNER JOIN
                                                         CXPPagos ON CXPP_CXPPagoId = CXPPD_CXPP_CXPPagoId
                               WHERE        CXPP_Eliminado = 0 AND (CXPPD_CMM_TipoRegistro = 'B820B23A-DF7F-4AA5-9C60-58A36EE46C6D' OR
                                                         CXPPD_CMM_TipoRegistro = '23693D81-BB7D-4097-9B55-15C6B37C8FAD') /*AND CAST(CXPP_FechaPago AS DATE)  >= '2022/06/01'*/ AND CAST(CXPP_FechaPago AS DATE) <= GETDATE()
                               GROUP BY CXPPD_RegistroPagoId) AS Tabla12 ON PAGO_ID = id)
WHERE        (Monto + ISNULL(MontoPago, 0.0)) < 0

