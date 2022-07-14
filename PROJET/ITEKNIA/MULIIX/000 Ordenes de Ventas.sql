-- Consulta para Ordenes de Venta

Select  Cast(OV_FechaOV as Date) as FE_OV,
        OV_CodigoOV,
        (Select CLI_CodigoCliente + '  '+ CLI_RazonSocial from Clientes Where CLI_ClienteId = OV_CLI_ClienteId) as CLIENTE,
        (Select CCON_Nombre from ClientesContactos Where CCON_ContactoId = OV_CCON_ContactoId) as CONTACTO,
        (Select PRY_CodigoEvento + '  ' PRY_NombreProyecto from Proyectos Where PRY_ProyectoId = OV_PRO_ProyectoId) as PROYECTO,
        OV_ReferenciaOC,
        (select CMM_Valor from ControlesMaestrosMultiples where CMM_ControlId = OV_CMM_EstadoOVId) as EDO_OV,
        OV_Eliminado,
        (select CMM_Valor from ControlesMaestrosMultiples where CMM_ControlId = OV_CMM_TipoOrdenVentaId) as TIPO_OV
From OrdenesVenta
Order By Cast(OV_FechaOV as Date), OV_CodigoOV

-- Validar que todos los Eliminados tengan estatus de Cerradas por usuario.
select * from OrdenesVenta 
Where OV_Eliminado = 1 and 
OV_CMM_EstadoOVId <> '2209C8BF-8259-4D8C-A0E9-389F52B33B46'

-- Para corregir asignar este cambio.
--update OrdenesVenta set OV_CMM_EstadoOVId = '2209C8BF-8259-4D8C-A0E9-389F52B33B46' Where OV_Eliminado = 1 and  OV_CMM_EstadoOVId <> '2209C8BF-8259-4D8C-A0E9-389F52B33B46'


-- select * from Proyectos


/*
select * from ControlesMaestrosMultiples where CMM_Control = 'CMM_VEN_EstadoOV'
select CMM_Valor from ControlesMaestrosMultiples where CMM_ControlId = 

        CMM_ControlId                      CMM_Control          CMM_Valor               CMM_ValorPredeterminado
3CE37D96-1E8A-49A7-96A1-2E837FA3DCF5	CMM_VEN_EstadoOV	Abierta	                true         Activas o vigentes.
2209C8BF-8259-4D8C-A0E9-389F52B33B46	CMM_VEN_EstadoOV	Cerrada Por Usuario	false        Aplicar para cuando se Cancelan
D528E9EC-83CF-49BE-AEED-C3751A3B0F27	CMM_VEN_EstadoOV	Embarque Completo	false        Cuando se concluye el proceso
3C387542-8DFC-42CC-8C49-5B6D32092C0C	CMM_VEN_EstadoOV	Embarque Parcial	false
90CAC435-DE6B-4148-BD20-16BCE3112936	CMM_VEN_EstadoOV	Facturado Completo	false
C580C240-44D7-4CE7-9EED-339F2DA967F5	CMM_VEN_EstadoOV	Facturado Parcial	false


Abierta
Cerrada Por Usuario
Embarque Completo
Embarque Parcial
Facturado Completo
Facturado Parcial	


*/




Select  OV_CodigoOV
        , (Select CLI_CodigoCliente + '  '+ CLI_RazonSocial from Clientes Where CLI_ClienteId = OV_CLI_ClienteId) as CLIENTE
        , (select CMM_Valor from ControlesMaestrosMultiples where CMM_ControlId = OV_CMM_EstadoOVId) as EDO_OV
        , OV_Eliminado
        , OV_Archivo1
        , OV_Archivo2
        , OV_Archivo3        
From OrdenesVenta
where OV_CodigoOV = 'OV00613'

Order By OV_CodigoOV

Select *        
From OrdenesVenta where OV_CodigoOV = 'OV01009'
Order By OV_CodigoOV

Select *        
From OrdenesVenta where OV_MON_MonedaId = '1EA50C6D-AD92-4DE6-A562-F155D0D516D3' and OV_MONP_Paridad = 1
and OV_CodigoOV > 'OV00887'
Order By OV_CodigoOV


Select  OV_CodigoOV
        , (Select CLI_CodigoCliente + '  '+ CLI_RazonSocial from Clientes Where CLI_ClienteId = OV_CLI_ClienteId) as CLIENTE
        , (select CMM_Valor from ControlesMaestrosMultiples where CMM_ControlId = OV_CMM_EstadoOVId) as EDO_OV   
From OrdenesVenta
Where OV_Eliminado = 0
Order By OV_CodigoOV