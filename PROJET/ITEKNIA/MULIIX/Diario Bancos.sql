Select * from BancosCuentasSimples



SELECT BCS_BancoCuentaId DT_RowId
	, BAN_NombreBanco
	, BCS_Cuenta
	, BCS_BAN_BancoId Id
	, MON_Nombre
	, CASE
    	WHEN CON.CON_FechaFinal IS NULL THEN CAST(BCS_FechaInicial AS DATE)
        WHEN CON.CON_FechaFinal = '' THEN CAST(BCS_FechaInicial AS DATE)
      	ELSE DATEADD(DAY,1,CAST(CON.CON_FechaFinal AS DATE))
      END AS BCS_FechaInicial
    --,CAST(BCS_FechaInicial AS DATE) AS BCS_FechaInicial
    , CASE
      	WHEN CON.CON_SaldoFinal IS NULL THEN BCS_MontoInicial
        --WHEN CON.CON_SaldoFinal = '' THEN BCS_MontoInicial
        ELSE CON.CON_SaldoFinal
      END AS BCS_MontoInicial
FROM BancosCuentasSimples
INNER JOIN Bancos ON BCS_BAN_BancoId = BAN_BancoId AND BAN_Activo = 1
INNER JOIN Monedas ON MON_MonedaId = BCS_MON_MonedaId
LEFT JOIN (
                                SELECT
                                    CON_FechaFinal
                                    ,CON_SaldoFinal
                                    ,CON_BCS_BancoCuentaId
                                    ,ROW_NUMBER() OVER(PARTITION BY CON_BCS_BancoCuentaId ORDER BY CON_FechaFinal DESC) AS 'RowNum'
                                FROM Conciliaciones
                                INNER JOIN BancosCuentasSimples ON CON_BCS_BancoCuentaId = BCS_BancoCuentaId
                                WHERE CON_Eliminado = 0
                                 AND CONVERT(DATE , CON_FechaInicio) = CONVERT(DATE ,'2023-08-01') 
                            ) AS CON ON CON.CON_BCS_BancoCuentaId = BCS_BancoCuentaId
                            WHERE BCS_Eliminado = 0 AND Bancos.BAN_CajaChica = 0
                            AND BCS_BancoCuentaId = '2F109467-2EF2-481A-A5C6-DCB7014B00EA'
                            AND (RowNum = 1 OR RowNum IS NULL)

//////////  DESPUES CON ESTA CONSULTA OBTENGO LOS DEPOSITOS Y RETIROS DEL 1 A 15 SEPTIEMBRE
EXEC SP_RPT_DiarioBancos '2F109467-2EF2-481A-A5C6-DCB7014B00EA', '2023-09-01', '20230915', '%'

//////  DESPUES EXTRAIGO LOS MOVIMIENTOS QUE NO SON PROVISIONES PARA PODER SACAR EL TOTAL DE DEPOSITOS Y RETIROS (por QUE LAS PROVISIONES NO JUEGAN)
////// Y AL SALDO INICIAL DE LA CONCILIACION LE VAMOS A SUMAR LOS DEPOSITOS Y RESTAR LOS RETIROS PARA PRESENTAR EL SALDO INICIAL


////// POR ULTIMO OBTENGO LOS LOS DEPOSITOS Y RETIROS DEL 16 A 27 SEPTIEMBRE PARA CARGAR LA TABLA
EXEC SP_RPT_DiarioBancos '2F109467-2EF2-481A-A5C6-DCB7014B00EA', '20230916', '20230927', '%'

//////  DESPUES EXTRAIGO LOS MOVIMIENTOS QUE NO SON PROVISIONES PARA PODER SACAR EL TOTAL DE DEPOSITOS Y RETIROS (por QUE LAS PROVISIONES NO JUEGAN)
////// PARA CARGAR LOS CAMPOS "DEPOSITOS", "RETIROS" Y SALDO FINAL

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
LA CONSULTA DEL PROCEDIMIENTO ALMACENADO ES ESTA:

USE [ItekniaDB]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPT_DiarioBancos]    Script Date: 02/10/2023 09:52:02 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,Alberto Medina>
-- Description:	Proyeccion CXC Reportik
-- exec SP_RPT_DiarioBancos '2F109467-2EF2-481A-A5C6-DCB7014B00EA', '20230501', '20230520', '%'
-- =============================================
ALTER PROCEDURE [dbo].[SP_RPT_DiarioBancos]
    @Banco_Id as uniqueidentifier, @fecha_inicio as date, @fecha_fin as date, @filtro as varchar(20)
AS
BEGIN

SELECT Semana, Fecha, Descripcion, Concepto, Cheque, Retiros, Depositos, Retiros_curr, Depositos_curr, Tipo, --COALESCE(Observaciones, '') Observaciones,
ID, LINK_DETALLE from (

SELECT
    0 as Orden,
	DATEPART(iso_week, CXCP_FechaPago) Semana,
	CONVERT(varchar, CXCP_FechaPago,103	) Fecha,
	--LEFT(CLI_CodigoCliente + ' - ' + CLI_RazonSocial, 40) AS Descripcion --MODIFIQUE DESCRIPCION 19/07/2023,
	CASE WHEN CLI_NombreComercial IS NULL THEN LEFT(CXCP_Pagador,40)
     WHEN CLI_RazonSocial IS NULL THEN LEFT(CLI_NombreComercial, 40)
     ELSE LEFT(CLI_CodigoCliente + ' - ' + CLI_RazonSocial, 40)
    END AS Descripcion,
	CXCP_IdentificacionPago AS Concepto,
	LEFT(CMM_Valor,13) AS Cheque,
	FORMAT(0, 'c', 'es-MX') AS Retiros_curr,
	0 AS Retiros,
	FORMAT((SUM(CXCP_MontoPago * CASE WHEN BCS_MON_MonedaId = CXCP_MON_MonedaId 
												THEN 1 ELSE CASE WHEN CXCP_ParidadUsuario > 0 
															THEN CXCP_ParidadUsuario 
															ELSE 1 
												  END 
											END)), 'c', 'es-MX') AS Depositos_curr,
	(SUM(CXCP_MontoPago * CASE WHEN BCS_MON_MonedaId = CXCP_MON_MonedaId 
												THEN 1 ELSE CASE WHEN CXCP_ParidadUsuario > 0 
															THEN CXCP_ParidadUsuario 
															ELSE 1 
												  END 
											END)) AS Depositos,
    'D' AS Tipo,
    --EMP_CodigoEmpleado + ' - ' + EMP_Nombre + ' ' + EMP_PrimerApellido + ' ' + EMP_SegundoApellido AS Empleado,
    --CXCP_ObservacionesRpt as Observaciones,
	CASE WHEN CXCP_IdentificacionPago like 'F%' THEN 1 ELSE 0 END AS LINK_DETALLE,
    CXCP_CXCPagoId ID
		 FROM CXCPagos 
		 INNER JOIN BancosCuentasSimples ON CXCPagos.CXCP_BCS_BancoCuentaId = BancosCuentasSimples.BCS_BancoCuentaId
		 INNER JOIN Bancos ON BCS_BAN_BancoId = BAN_BancoId
		 INNER JOIN ControlesMaestrosMultiples ON CXCP_CMM_FormaPagoId = CMM_ControlId
		 INNER JOIN Monedas ON MON_MonedaId = BCS_MON_MonedaId
		 LEFT JOIN Empleados ON CXCP_EMP_ModificadoPorId = EMP_EmpleadoId
		 --LEFT JOIN Empleados ON CXCP_EMP_ConciliacionModificadoPorId = EMP_EmpleadoId
		 LEFT JOIN Clientes ON CXCP_CLI_ClienteId = CLI_ClienteId
	      WHERE BancosCuentasSimples.BCS_BancoCuentaId = @Banco_Id --P{CUENTAID}
		  --AND CXCPagos.CXCP_CandidatoConciliacion = 1  
		  AND CXCPagos.CXCP_Eliminado = 0 
		  AND CONVERT(DATE, CXCP_FechaPago) BETWEEN @fecha_inicio AND @fecha_fin --P{FECHAINICIO} AND P{FECHAFINAL}
		  GROUP BY
		  CLI_NombreComercial,
		  CXCP_Pagador,
		  CXCP_IdentificacionPago,
		  BCS_BancoCuentaId,
		  BAN_NombreBanco,
		  BCS_Cuenta,
		  CXCP_FechaPago,
		  CMM_Valor,
		  BCS_MontoInicial,
		  EMP_CodigoEmpleado,
		  EMP_Nombre,
		  EMP_PrimerApellido,
		  EMP_SegundoApellido,
		  CLI_CodigoCliente,
		  CLI_RazonSocial,
		  CLI_ClienteId,
		  EMP_EmpleadoId,
          --CXCP_ObservacionesRpt,
          CXCP_CXCPagoId
		 -- order by CXCP_FechaPago, CLI_CodigoCliente
		  
  UNION ALL 
  
  SELECT  
    0 as Orden,
	DATEPART(iso_week, CXPP_FechaPago) Semana,
	CONVERT(varchar, CXPP_FechaPago, 103) Fecha,
	--MODIFIQUE DESCRIPCION 19/07/2023,
	CASE
                            WHEN PRO_NombreComercial IS NULL
                                THEN LEFT(CXPP_CXCP_Pagador,40)
                            ELSE LEFT(PRO_CodigoProveedor + ' - ' + PRO_Nombre, 40)
    END
    AS Descripcion,
--	COALESCE((SELECT
--  CASE WHEN CFDI_Serie IS NULL THEN '' ELSE CFDI_Serie END + 
--  CASE WHEN CFDI_Folio IS NULL OR CFDI_Folio = '' THEN '' ELSE '-' + CFDI_Folio 
--  END AS FACTURA
--	FROM Cfdi
--WHERE CFDI_CfdiId IN ( CXPP_CFDI_CfdiId )), 'X')+ ' '+
--CASE WHEN CFDI_Serie IS NULL THEN '' ELSE CFDI_Serie END + 
 CASE WHEN CFDI_Folio IS NULL OR CFDI_Folio = '' THEN '' ELSE CFDI_Folio 
 END+ ' '+
	CXPP_IdentificacionPago AS Concepto,
	LEFT(CMM_Valor, 13) AS Cheque,
	FORMAT((SUM(CXPP_MontoPago * CASE WHEN BCS_MON_MonedaId = CXPP_MON_MonedaId 
												THEN 1 ELSE CASE WHEN CXPP_ParidadUsuario > 0 
															THEN CXPP_ParidadUsuario 
															ELSE 1 
												  END 
											END)), 'c', 'es-MX') AS Retiros_curr,
	(SUM(CXPP_MontoPago * CASE WHEN BCS_MON_MonedaId = CXPP_MON_MonedaId 
												THEN 1 ELSE CASE WHEN CXPP_ParidadUsuario > 0 
															THEN CXPP_ParidadUsuario 
															ELSE 1 
												  END 
	END)) AS Retiros,
	FORMAT(0, 'c', 'es-MX') AS Depositos_curr,
	0 AS Depositos,
	'R' AS Tipo,
		--EMP_CodigoEmpleado + ' - ' + EMP_Nombre + ' ' + EMP_PrimerApellido + ' ' + EMP_SegundoApellido AS Empleado,
        --CXPP_ObservacionesRpt as Observaciones,
		'' AS LINK_DETALLE,
        CXPP_CXPPagoId ID
		 FROM CXPPagos		 
		 INNER JOIN BancosCuentasSimples ON CXPPagos.CXPP_BCS_BancoCuentaId = BancosCuentasSimples.BCS_BancoCuentaId
		 INNER JOIN Bancos ON BCS_BAN_BancoId = BAN_BancoId
		 INNER JOIN ControlesMaestrosMultiples ON CXPP_CMM_FormaPagoId = CMM_ControlId
		 INNER JOIN Monedas ON MON_MonedaId = BCS_MON_MonedaId
		 LEFT JOIN Empleados ON CXPP_EMP_ModificadoPor = EMP_EmpleadoId
		 --LEFT JOIN Empleados ON CXPP_EMP_ConciliacionModificadoPor = EMP_EmpleadoId
		 LEFT JOIN Proveedores ON CXPP_PRO_ProveedorId = PRO_ProveedorId
		 LEFT JOIN Cfdi ON CFDI_CfdiId = CXPP_CFDI_CfdiId
		 WHERE BancosCuentasSimples.BCS_BancoCuentaId = @Banco_Id --P{CUENTAID}
		  --AND CXPPagos.CXPP_CandidatoConciliacion = 1  
		  AND CXPPagos.CXPP_Eliminado = 0 
		  AND CONVERT(DATE, CXPP_FechaPago) BETWEEN @fecha_inicio AND @fecha_fin
		  GROUP BY
		  PRO_NombreComercial,
		  CXPP_CXCP_Pagador,
		  CXPP_IdentificacionPago,
		  BCS_BancoCuentaId,
		  BAN_NombreBanco,
		  BCS_Cuenta,
		  CXPP_FechaPago,
		  CMM_Valor,
		  BCS_MontoInicial,
		  EMP_CodigoEmpleado,
		  EMP_Nombre,
		  EMP_PrimerApellido,
		  EMP_SegundoApellido,
		  PRO_CodigoProveedor,
		  PRO_Nombre,
		  PRO_ProveedorId,
		  EMP_EmpleadoId,
          --CXPP_ObservacionesRpt,
          CXPP_CXPPagoId,
		  --order by CXPP_FechaPago, PRO_CodigoProveedor
		  CXPP_CFDI_CfdiId,
		  CFDI_Folio
		  UNION ALL

		  SELECT 
		  --SELECT Semana, Fecha, Descripcion, Concepto, Cheque, Retiros, Depositos, Tipo
          0 as Orden,
	DATEPART(iso_week, CCCD_Fecha) Semana,
	CONVERT(varchar, CCCD_Fecha,103	) Fecha,
	LEFT(PRO_CodigoProveedor + ' - ' + PRO_Nombre, 40) AS Descripcion,
	LEFT(CMM_Valor, 20) AS Concepto,
	'Efectivo' AS Cheque,
	FORMAT(CCCD_Total, 'c', 'es-MX') AS Retiros_curr,
	CCCD_Total AS Retiros,
	FORMAT(0, 'c', 'es-MX') AS Depositos_curr,
	0 AS Depositos,
	'R' AS Tipo,
	'' AS LINK_DETALLE,
	ComprobacionCajaChicaDetalle.CCCD_DetalleId ID
FROM ComprobacionCajaChicaDetalle
INNER JOIN ComprobacionCajaChica ON CCC_ComprobacionCajaChicaId = CCCD_CCC_ComprobacionCajaChicaId AND CCCD_Eliminado = 0
LEFT JOIN Proveedores ON Proveedores.PRO_RFC = CCCD_Rfc AND CCCD_Rfc <> 'XAXX010101000'
INNER JOIN ControlesMaestrosMultiples ON CCCD_CMM_ConceptoId = CMM_ControlId
where CCC_BCS_BancoCuentaId = @Banco_Id--'156D06EF-BF6F-4149-8DE5-2766241371C0'
AND CONVERT(DATE, CCCD_Fecha) BETWEEN @fecha_inicio AND @fecha_fin --BETWEEN '20230501' AND '20230520'

UNION ALL

select 
    CASE WHEN DBP_Tipo = 'Libre' THEN 3 ELSE 2 END as Orden,
   -- DATEPART(iso_week, DBP_Fecha) Semana 
    --,CONVERT(varchar, DBP_Fecha, 103) Fecha 
	
	 DATEPART(iso_week, @fecha_fin) Semana 
    ,CONVERT(varchar, @fecha_fin, 103) Fecha
    ,DBP_Observacion AS Descripcion
    ,DBP_Tipo AS Concepto
    , 'Provision' Cheque
   , FORMAT(DBP_Retiro, 'c', 'es-MX') AS Retiros_curr
                ,DBP_Retiro AS Retiros
                ,FORMAT(DBP_Deposito, 'c', 'es-MX') AS Depositos_curr
                ,DBP_Deposito AS Depositos
                ,CASE WHEN DBP_Deposito > 0 THEN 'D' ELSE 'R' END AS Tipo
                --,( DBP_Deposito - DBP_Retiro ) DBP_Monto
				,'' AS LINK_DETALLE
,DBP_ProvisionId AS ID
                from RPT_DiarioBancarioProvision Where DBP_Eliminado = 0 AND DBP_Activo = 1
AND DBP_BancoId = @Banco_Id--'156D06EF-BF6F-4149-8DE5-2766241371C0'
AND CONVERT(DATE, @fecha_fin) BETWEEN @fecha_inicio AND @fecha_fin
          ) t 
          where Tipo like @filtro
          Order by Orden, Fecha
END

