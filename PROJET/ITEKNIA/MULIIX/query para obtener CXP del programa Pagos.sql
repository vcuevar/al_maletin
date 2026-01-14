DECLARE @tipo_cambio DECIMAL = 20
SELECT SAL.tipodoc,
                       SAL.codigo,--SAL.FECHA,
                       SAL.pro_proveedorid,
                       SAL.proveedor,
                       SAL.pro_rfc,
                       CASE
                         WHEN mon_monedaid =
                              '1EA50C6D-AD92-4DE6-A562-F155D0D516D3'
                       THEN
                         SAL.saldo * @tipo_cambio
                         ELSE SAL.saldo
                       END
                       AS
                       MONTO_PESOS,
                       ( Sum(CASE
                               WHEN mon_monedaid =
                                    '1EA50C6D-AD92-4DE6-A562-F155D0D516D3' THEN
                               retenciones * @tipo_cambio
                               ELSE retenciones
                             END) )
                       RETENCIONES,
                       TAB.saldo,
                       COALESCE (SAL.vencimiento, Dateadd(day, -7, Getdate()))
                       VENCIMIENTO
                FROM   rpt_view_saldos_proveedores SAL
                       INNER JOIN (SELECT pro_proveedorid,
                                          proveedor,
                                          pro_rfc,
                       Sum(CASE
                             WHEN mon_monedaid =
                                  '1EA50C6D-AD92-4DE6-A562-F155D0D516D3'
                           THEN
                             saldo *
                             @tipo_cambio
                             ELSE saldo
                           END) SALDO
                                   FROM   rpt_view_saldos_proveedores
                                   GROUP  BY pro_proveedorid,
                                             proveedor,
                                             pro_rfc
                                   HAVING
                       Sum(CASE
                             WHEN mon_monedaid =
                                  '1EA50C6D-AD92-4DE6-A562-F155D0D516D3'
                           THEN
                             saldo *
                             @tipo_cambio
                             ELSE saldo
                           END) > 0) TAB
                               ON TAB.pro_proveedorid = SAL.pro_proveedorid
                WHERE 
                 TAB.saldo > 0 --AND SAL.proveedor like '%P09%'
                GROUP  BY SAL.tipodoc,
                          SAL.codigo,--SAL.FECHA,
                          SAL.pro_proveedorid,
                          SAL.proveedor,
                          SAL.pro_rfc,
                          mon_monedaid,
                          SAL.saldo,
                          TAB.saldo,
                          SAL.vencimiento