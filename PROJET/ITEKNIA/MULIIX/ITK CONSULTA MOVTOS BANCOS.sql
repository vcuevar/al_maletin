SELECT 
	BCS_BancoCuentaId,
	BAN_BancoId,
	BAN_NombreBanco,
	BCS_Cuenta,
	MON_MonedaId,
	MON_Nombre
	FROM  
			Bancos
			INNER JOIN BancosCuentasSimples ON BCS_BAN_BancoId = BAN_BancoId AND BCS_Eliminado = 0
			INNER JOIN Monedas ON MON_MonedaId = BCS_MON_MonedaId AND MON_Eliminado = 0
			WHERE BAN_Activo = 1
			ORDER BY 
			BAN_NombreBanco

DECLARE 
@Banco_Id as uniqueidentifier = '8A38643A-4FF6-4139-87FF-7BC683A389A6', 
@fecha_inicio as date = '20230101', 
@fecha_fin as date = '20230315', 
@filtro as varchar(20) = '%' --% COMPLETO, R RETIROS, D DEPOSITOS

--select @fecha_fin

SELECT Semana, Fecha, Descripcion, Concepto, Cheque, Retiros, Depositos, Tipo from (
SELECT  
	DATEPART(iso_week, CXCP_FechaPago) Semana,
	CONVERT(varchar, CXCP_FechaPago,103	) Fecha,
	LEFT(CLI_CodigoCliente + ' - ' + CLI_RazonSocial, 40) AS Descripcion,
	CXCP_IdentificacionPago AS Concepto,
	LEFT(CMM_Valor,13) AS Cheque,
	0 AS Retiros,
	
	(SUM(CXCP_MontoPago * CASE WHEN BCS_MON_MonedaId = CXCP_MON_MonedaId 
												THEN 1 ELSE CASE WHEN CXCP_ParidadUsuario > 0 
															THEN CXCP_ParidadUsuario 
															ELSE 1 
												  END 
											END)) AS Depositos,
    'D' AS Tipo,
    EMP_CodigoEmpleado + ' - ' + EMP_Nombre + ' ' + EMP_PrimerApellido + ' ' + EMP_SegundoApellido AS Empleado
		 FROM CXCPagos 
		 INNER JOIN BancosCuentasSimples ON CXCPagos.CXCP_BCS_BancoCuentaId = BancosCuentasSimples.BCS_BancoCuentaId
		 INNER JOIN Bancos ON BCS_BAN_BancoId = BAN_BancoId
		 INNER JOIN ControlesMaestrosMultiples ON CXCP_CMM_FormaPagoId = CMM_ControlId
		 INNER JOIN Monedas ON MON_MonedaId = BCS_MON_MonedaId
		 LEFT JOIN Empleados ON CXCP_EMP_ModificadoPorId = EMP_EmpleadoId
		 --LEFT JOIN Empleados ON CXCP_EMP_ConciliacionModificadoPorId = EMP_EmpleadoId
		 INNER JOIN Clientes ON CXCP_CLI_ClienteId = CLI_ClienteId
	      WHERE BancosCuentasSimples.BCS_BAN_BancoId = @Banco_Id --P{CUENTAID}
		  AND CXCPagos.CXCP_CandidatoConciliacion = 1  
		  AND CXCPagos.CXCP_Eliminado = 0 
		  AND CONVERT(DATE, CXCP_FechaPago) BETWEEN @fecha_inicio AND @fecha_fin --P{FECHAINICIO} AND P{FECHAFINAL}
		  GROUP BY 
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
		  EMP_EmpleadoId
		 -- order by CXCP_FechaPago, CLI_CodigoCliente
		  
  UNION ALL 
  
  SELECT  
	DATEPART(iso_week, CXPP_FechaPago) Semana,
	CONVERT(varchar, CXPP_FechaPago, 103) Fecha,
	LEFT(PRO_CodigoProveedor + ' - ' + PRO_Nombre, 40) AS Descripcion,
	CXPP_IdentificacionPago AS Concepto,
	LEFT(CMM_Valor, 13) AS Cheque,
	(SUM(CXPP_MontoPago * CASE WHEN BCS_MON_MonedaId = CXPP_MON_MonedaId 
												THEN 1 ELSE CASE WHEN CXPP_ParidadUsuario > 0 
															THEN CXPP_ParidadUsuario 
															ELSE 1 
												  END 
											END)) AS Retiros,
	0 AS Depositos,
	'R' AS Tipo,
		EMP_CodigoEmpleado + ' - ' + EMP_Nombre + ' ' + EMP_PrimerApellido + ' ' + EMP_SegundoApellido AS Empleado
		 FROM CXPPagos 
		 INNER JOIN BancosCuentasSimples ON CXPPagos.CXPP_BCS_BancoCuentaId = BancosCuentasSimples.BCS_BancoCuentaId
		 INNER JOIN Bancos ON BCS_BAN_BancoId = BAN_BancoId
		 INNER JOIN ControlesMaestrosMultiples ON CXPP_CMM_FormaPagoId = CMM_ControlId
		 INNER JOIN Monedas ON MON_MonedaId = BCS_MON_MonedaId
		 LEFT JOIN Empleados ON CXPP_EMP_ModificadoPor = EMP_EmpleadoId
		 --LEFT JOIN Empleados ON CXPP_EMP_ConciliacionModificadoPor = EMP_EmpleadoId
		 INNER JOIN Proveedores ON CXPP_PRO_ProveedorId = PRO_ProveedorId
		 WHERE BancosCuentasSimples.BCS_BAN_BancoId = @Banco_Id --P{CUENTAID}
		  AND CXPPagos.CXPP_CandidatoConciliacion = 1  
		  AND CXPPagos.CXPP_Eliminado = 0 
		  AND CONVERT(DATE, CXPP_FechaPago) BETWEEN @fecha_inicio AND @fecha_fin
		  GROUP BY 
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
		  EMP_EmpleadoId
		  --order by CXPP_FechaPago, PRO_CodigoProveedor
          ) t 
          where Tipo like @filtro
          Order by Fecha, Cheque, Descripcion
          
          
          
          
          
          
          
          
          
          
--  Son Pruebas no inegrar          
          
Select * from CXCPagos Where CXCP_DefinidoPorUsuario5 is not null



          