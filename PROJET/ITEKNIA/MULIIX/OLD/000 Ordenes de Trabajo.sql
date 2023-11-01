
/*
--Select * from MenuPrincipalConfiguracion where MPC_Movil = 1 Order by MPC_Orden

Select * from OrdenesTrabajoAsignacionRecursos
Select * from OrdenesTrabajoAsignacionRecursosDetalle


Select * from OrdenesTrabajoAsignacionRecursosEmpleados


-- Tablas donde se registra los tiempos cargados a la OT
-- Hacer analisis, para extraer tiempos cargados por OT y ver si se puede cargar quien realizo, hay campo de Empleadoid
Select * from OrdenesTrabajoSeguimiento
Select * from OrdenesTrabajoSeguimientoOperacion
Select * from OrdenesTrabajoSeguimientoOperacionDetalle

Select * from OrdenesTrabajoSeguimientoOperacionEmpleados (Vacia)


Select * from OrdenesTrabajoSurtimiento
Select * from OrdenesTrabajoSurtimientoDetalle
Select * from OrdenesTrabajoSurtimientoRecibos

Select * from OrdenesTrabajoSurtimientoPartida (Vacia)
Select * from OrdenesTrabajoSurtimientoCostosH (Vacia)

Select * from OrdenesTrabajoRecibo



-- Informacion para los traslados y poder sacar reporte de Excepciones

Select * from TraspasosSolicitudes (Vacia)
Select * from TraspasosSolicitudesDetalle (Vacia)
Select * from TraspasosSolicitudesTiempos (Vacia)


Select * from TraspasosSolicitudesDetalleManufactura --aparenta ser detalle de la Solicitud

Select * from TraspasosSolicitudesManufactura --Codigo almacenes u empleado del traslado

Select * from ControlesMaestrosMultiples Where CMM_Control = 'B8749E06-0936-4171-85C1-90615BCCE41E'

Select OT_Codigo,  OV_CodigoOV
From OrdenesTrabajoReferencia
Inner Join OrdenesTrabajo on OT_OrdenTrabajoId = OTRE_OT_OrdenTrabajoId
Inner join OrdenesVenta on OV_OrdenVentaId = OTRE_OV_OrdenVentaId


*/

Select OT_Codigo, OT_FechaOT, 
        ART_CodigoArticulo,
       -- ART_Nombre,
       -- OTDA_Cantidad,
        (Select CMUM_Nombre from ControlesMaestrosUM Where CMUM_UnidadMedidaId = ART_CMUM_UMInventarioId) AS UM,
        OV_CodigoOV, 
        OV_ReferenciaOC,
        (Select CLI_CodigoCliente + '  ' + CLI_RazonSocial from Clientes where CLI_ClienteId = OV_CLI_ClienteId) AS CLIENTE,
        (Select CCON_Nombre from ClientesContactos where CCON_ContactoId = OV_CCON_ContactoId) AS CONTACTO,
        (Select PRY_CodigoEvento + '  ' + PRY_NombreProyecto from Proyectos where PRY_ProyectoId = OV_PRO_ProyectoId) AS PROYECTO
        , OrdenesTrabajoReferencia.*
from OrdenesTrabajo
inner join OrdenesTrabajoReferencia on OT_OrdenTrabajoId = OTRE_OT_OrdenTrabajoId
inner join OrdenesVenta on OV_OrdenVentaId = OTRE_OV_OrdenVentaId
inner join OrdenesTrabajoDetalleArticulos on OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId
inner join Articulos on ART_ArticuloId = OTDA_ART_ArticuloId 
Where 
--  ART_CodigoArticulo = '1085.5-12'
--  ART_CodigoArticulo = '1093.2-02' 
--ART_CodigoArticulo = '1080.4-15'

--OT_Eliminado = 0 
--and
--OT_Activo = 1 and (OT_OrdenTrabajoId = '5D7D3E58-0F99-4EAF-BB29-560F2589A85A'
--or OT_OrdenTrabajoId = 'E997A01E-3AA9-4DB2-B2B1-A58E65C2383C')
--OT_Codigo = 'OT01550'

--OT_Codigo = 'OT01537'
--or OT_Codigo = 'OT01682'
--or OT_Codigo = 'OT01669'
--  1682, 1669 
--and
 
--OV_CodigoOV = 'OV00728' or
--OV_CodigoOV = 'OV00726'

--OV_CodigoOV = 'OV00718' --or
OV_CodigoOV = 'OV00719'

Order By OV_CodigoOV, OT_Codigo


--Select * from OrdenesTrabajo Where OT_Codigo = 'OT01676'

--Select * from ControlesMaestrosMultiples Where CMM_ControlId = '213ED3B9-12B3-41C9-8C6E-230DC86BBF90'