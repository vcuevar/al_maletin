-- Consulta para generar 040 Back Order
-- Actualizado al 29 de Septiembre del 2021; (Origen)
-- Actualizado al 01 de Diciembre del 2021; (Se adecuo para Macro y nuevo acomodo de Columnas).
-- Actualizado: Martes 25 de Octubre del 2022; (Ligar a la tabla de Procesos) 

Select top(50) OT_Codigo AS OT
        , OT_OrdenTrabajoId AS ID
        , ART_CodigoArticulo AS ARTICULO
        , ART_Nombre AS PRODUCTO
        
	--, Cast(ISNULL(SOT_Recibido-SOT_Entregado, OTDA_Cantidad) as decimal(16,2)) AS CANT
        --, Cast(OVD_CantidadRequerida as decimal(16,2)) AS CANT
	, Cast(OTDA_Cantidad as decimal(16,2)) AS CANT_OT
	--, SOT_Recibido-SOT_Entregado AS CANT_EST
	--, SOT_Estacion
	
	
	
        , CMUM_Nombre AS UNIDAD
        , ART_Comentarios AS DESCRIPCION
        , (Select AET_Valor from ArticulosEspecificaciones Where AET_ART_ArticuloId = ART_ArticuloId and AET_CMM_ArticuloEspecificaciones = 'CADE29BF-1459-4C9E-9A66-DA478E96D5E7') AS MEDIDA
        , (Select AET_Valor from ArticulosEspecificaciones Where AET_ART_ArticuloId = ART_ArticuloId and AET_CMM_ArticuloEspecificaciones = 'CE6EB5D1-7298-432E-94E5-2EB23D431C78') AS AREA
        , (Select AET_Valor from ArticulosEspecificaciones Where AET_ART_ArticuloId = ART_ArticuloId and AET_CMM_ArticuloEspecificaciones = '2ACE7D3D-734B-4603-B7C9-48E32FA7312E') AS ACABADOS
        , (Select AET_Valor from ArticulosEspecificaciones Where AET_ART_ArticuloId = ART_ArticuloId and AET_CMM_ArticuloEspecificaciones = '0DDB36A5-E60A-447A-8F22-D65C08886E8F') AS TELAS
        , ART_Imagen AS IMAGEN        
        , PRY_NombreProyecto AS PROYECTO        
        --, Cast(OVR_FechaRequerida as date) AS FECHA_DE_ENTREGA
        , Cast(OT_FechaOT as date) AS FECHA_DE_ENTREGA

        , ISNULL( (Select Case When SOI_Id < 1 THEN 'PLANIFICADA' ELSE 'LIBERADA'END
          from RPT_Seguimiento_OTI 
          Where SOI_OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId  
          AND SOI_Eliminado = 0 ),'PLANIFICADA') AS ESTATUS1



	--, Case When SOI_ID is null then 'PLANIFICADA' Else 'LIBERADA' end AS ESTATUS 
	--, Case When CET_Codigo is null then 'LIBERA2' Else CET_Codigo + '  ' + CET_Nombre + ' / ' + DEP_Nombre end AS ESTA2
		
		
		
        , Cast((OVD_PrecioUnitario / 5000) * OVD_CantidadRequerida as decimal(16,3)) AS PUNTOS                        
        , OV_CodigoOV AS OV
        , Cast(OVD_PrecioUnitario as decimal(16,2)) AS PRECIO_U

        -- , CLI_CodigoCliente + '  ' + CLI_RazonSocial AS CLIENTE
        -- , PRY_CodigoEvento AS CODIGO_PROYECTO
        --, OTDA_Cantidad AS CANT
        , Cast(OV_FechaOV as date) AS FECH_OV 
From OrdenesTrabajo 
inner join OrdenesTrabajoDetalleArticulos on OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId
inner join Articulos on ART_ArticuloId = OTDA_ART_ArticuloId
inner Join ControlesMaestrosUM on ART_CMUM_UMInventarioId = CMUM_UnidadMedidaId
inner join OrdenesTrabajoReferencia on  OT_OrdenTrabajoId = OTRE_OT_OrdenTrabajoId
inner join OrdenesVenta on OV_OrdenVentaId = OTRE_OV_OrdenVentaId
inner join OrdenesVentaDetalle on OVD_OV_OrdenVentaId =OV_OrdenVentaId and OTDA_ART_ArticuloId = OVD_ART_ArticuloId
inner join OrdenesVentaReq on OVR_OVD_DetalleId = OVD_DetalleId
inner join Proyectos on OV_PRO_ProyectoId  = PRY_ProyectoId
inner Join Clientes on OV_CLI_ClienteId = CLI_ClienteId

--Left Join RPT_Seguimiento_OTI on OTDA_OT_OrdenTrabajoId = SOI_OT_OrdenTrabajoId
--Left Join RPT_Seguimiento_OT on  OTDA_OT_OrdenTrabajoId = SOI_OT_OrdenTrabajoId

--Left Join CentrosTrabajo on CET_Codigo = SOT_Estacion and CET_Activo = 1 and CET_Borrado = 0
--Left Join Departamentos on DEP_DeptoId = CET_DEP_DeptoId and DEP_Eliminado = 0 and DEP_Activo = 1

Where ( OT_CMM_Estatus = '3C843D99-87A6-442C-8B89-1E49322B265A' or
        OT_CMM_Estatus = 'A488B27B-15CD-47D8-A8F3-E9FB8AC70B9B' or
        OT_CMM_Estatus = '213ED3B9-12B3-41C9-8C6E-230DC86BBF90' ) and OT_Eliminado = 0
        --and SOT_Recibido > 0
	--and (SOT_Recibido - SOT_Entregado) <> 0 	
	
        --and Cast(OV_FechaOV As Date) BETWEEN '" & FechaIS & "' and '" & FechaFS & "'
        --and OT_Codigo = 'OT02422'
        --and OT_Codigo = 'OT01763'
        --and OV_CodigoOV = 'OV00976'
Order By OVR_FechaRequerida, OT_Codigo



/*

Select SOT_Estacion AS ESTACION
        --, CET_Nombre AS NOM_EST
        , SOT_Recibido-SOT_Entregado AS CANT_EST
from RPT_Seguimiento_OT 
--Left Join CentrosTrabajo on CET_Codigo = SOT_Estacion and CET_Activo = 1 and CET_Borrado = 0
Where SOT_OT_OrdenTrabajoId ='C54B5DF1-8955-4D03-A220-F1659F4F9164' 

--Select * from CentrosTrabajo

--Select * from OrdenesVenta
--De un Articulo Presentar su Ruta de Trabajo (Centros de Trabajo)



CMM_ControlId	                          CMM_Control	                    CMM_Valor
CE6EB5D1-7298-432E-94E5-2EB23D431C78	CMM_INV_ArticulosEspecificaciones	AREA
CADE29BF-1459-4C9E-9A66-DA478E96D5E7	CMM_INV_ArticulosEspecificaciones	MEDIDA
2ACE7D3D-734B-4603-B7C9-48E32FA7312E	CMM_INV_ArticulosEspecificaciones	ACABADO
0DDB36A5-E60A-447A-8F22-D65C08886E8F	CMM_INV_ArticulosEspecificaciones	TELA




Select  ART_CodigoArticulo
        , ART_Nombre
        , CET_Codigo
        , CET_Nombre
        , DEP_Codigo
        , DEP_Nombre
from Articulos
inner join Fabricacion on FAB_ART_ArticuloId = ART_ArticuloId and  ART_ATP_TipoId = '0D0B9D8A-C779-4D11-8CF6-C1DA16E4334C'
inner join FabricacionEstructura on FAB_FabricacionId = FAE_FAB_FabricacionId
inner join FabricacionDetalle on FAE_EstructuraId = FAD_FAE_EstructuraId
inner join CentrosTrabajo on  CET_CentroTrabajoId = FAD_ReferenciaId
inner join Departamentos on CET_DEP_DeptoId = DEP_DeptoId
Where ART_CodigoArticulo = '1403.1-21'
and FAB_Eliminado = 0 and CET_Activo = 1 and CET_Borrado = 0
Order By CET_Codigo
*/

-- Total de Centros de Trabajo activos.
--Select CET_Codigo, CET_Nombre from CentrosTrabajo Where CET_Activo = 1 and CET_Borrado = 0 Order By CET_Codigo









/*
En base de Datos de QA

Select TOP(10) * from OrdenesTrabajo Where OT_Codigo = 'OT01961'
Select TOP(10) * from OrdenesTrabajoDetalleArticulos Where OTDA_OT_OrdenTrabajoId = '8AEEFFF0-7122-475E-8BB0-F37947EB583C'
Select TOP(10) * from OrdenesTrabajoReferencia Where OTRE_OT_OrdenTrabajoId = '8AEEFFF0-7122-475E-8BB0-F37947EB583C'


Select TOP(10) * from OrdenesTrabajoAsignacionRecursosArticulos Where OTARA_OT_OrdenTrabajoId = '8AEEFFF0-7122-475E-8BB0-F37947EB583C'
Select TOP(10) * from OrdenesTrabajoAsignacionRecursosDetalle Where OTARD_OT_OrdenTrabajoId = '8AEEFFF0-7122-475E-8BB0-F37947EB583C'
Select TOP(10) * from OrdenesTrabajoAsignacionRecursosEmpleados Where OTARE_OT_OrdenTrabajoId = '8AEEFFF0-7122-475E-8BB0-F37947EB583C'

Select TOP(10) * from OrdenesTrabajoSeguimiento Where OTS_OT_OrdenTrabajoId  = '8AEEFFF0-7122-475E-8BB0-F37947EB583C'
Select TOP(10) * from OrdenesTrabajoSeguimientoOperacion
Select TOP(10) * from OrdenesTrabajoSeguimientoOperacionDetalle

Select TOP(10) * from OrdenesTrabajoSurtimiento Where OTSU_OT_OrdenTrabajoId = '8AEEFFF0-7122-475E-8BB0-F37947EB583C'
Select TOP(10) * from OrdenesTrabajoSurtimientoDetalle

Select TOP(10) * from OrdenesTrabajoTasasCostos Where OTTC_OT_OrdenTrabajoId = '8AEEFFF0-7122-475E-8BB0-F37947EB583C'

-- (Vacia) Select TOP(10) * from OrdenesTrabajoAsignacionRecursos
-- (Vacia) Select TOP(10) * from OrdenesTrabajoDetalleOVR
-- (Vacia) Select TOP(10) * from OrdenesTrabajoEntregas
-- (Vacia) Select TOP(10) * from OrdenesTrabajoGastos
-- (Vacia) Select TOP(10) * from OrdenesTrabajoGastosDetalle
-- (Vacia) Select TOP(10) * from OrdenesTrabajoRecibo
-- (Vacia) Select TOP(10) * from OrdenesTrabajoReciboDetalle
-- (Vacia) Select TOP(10) * from OrdenesTrabajoSeguimientoDetalle
-- (Vacia) Select TOP(10) * from OrdenesTrabajoSeguimientoDetalleArticulo
-- (Vacia) Select TOP(10) * from OrdenesTrabajoSeguimientoGastos
-- (Vacia) Select TOP(10) * from OrdenesTrabajoSeguimientoGastosDetalle
-- (Vacia) Select TOP(10) * from OrdenesTrabajoSeguimientoGastosOperacion
-- (Vacia) Select TOP(10) * from OrdenesTrabajoSeguimientoOperacionEmpleados
-- (Vacia) Select TOP(10) * from OrdenesTrabajoSurtimientoCostosH
-- (Vacia) Select TOP(10) * from OrdenesTrabajoSurtimientoPartida
-- (Vacia) Select TOP(10) * from OrdenesTrabajoSurtimientoRecibos

Select OT_Codigo AS MULIIX
From OrdenesTrabajo
inner join OrdenesTrabajoDetalleArticulos on OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId
inner join Articulos on ART_ArticuloId = OTDA_ART_ArticuloId
inner Join ControlesMaestrosUM on ART_CMUM_UMInventarioId = CMUM_UnidadMedidaId
Inner join OrdenesTrabajoReferencia on  OT_OrdenTrabajoId = OTRE_OT_OrdenTrabajoId
inner join OrdenesVenta on OV_OrdenVentaId = OTRE_OV_OrdenVentaId
inner join OrdenesVentaDetalle on OVD_OV_OrdenVentaId =OV_OrdenVentaId and OTDA_ART_ArticuloId = OVD_ART_ArticuloId
--inner join OrdenesVentaReq on OVR_OVD_DetalleId = OVD_DetalleId
--inner join Proyectos on OV_PRO_ProyectoId  = PRY_ProyectoId
--inner Join Clientes on OV_CLI_ClienteId = CLI_ClienteId

Where ( OT_CMM_Estatus = '3C843D99-87A6-442C-8B89-1E49322B265A' or
        OT_CMM_Estatus = 'A488B27B-15CD-47D8-A8F3-E9FB8AC70B9B' or
        OT_CMM_Estatus = '213ED3B9-12B3-41C9-8C6E-230DC86BBF90' ) and OT_Eliminado = 0
        --and OT_Codigo = 'OT01837'

Order By OT_Codigo

-- ----------------------------------------------------------------------------



Select * from OrdenesVentaDetalle
*/


/*

Select top(10) * from OrdenesTrabajo
Select top(10) * from OrdenesTrabajoDetalleArticulos
Select top(10) * from Articulos Where ART_CodigoArticulo = '1258.1-06'


(Select AET_Valor from ArticulosEspecificaciones Where AET_ART_ArticuloId = '25B231F7-1D21-45C1-A410-D05525A446BC' and AET_CMM_ArticuloEspecificaciones = 'CADE29BF-1459-4C9E-9A66-DA478E96D5E7') AS MEDIDA

AET_CMM_ArticuloEspecificaciones	AET_Valor
CE6EB5D1-7298-432E-94E5-2EB23D431C78	80
CADE29BF-1459-4C9E-9A66-DA478E96D5E7	100
2ACE7D3D-734B-4603-B7C9-48E32FA7312E	120
0DDB36A5-E60A-447A-8F22-D65C08886E8F	0

Select * from ControlesMaestrosMultiples Where CMM_Control = 'CMM_INV_ArticulosEspecificaciones'
CMM_ControlId = 'CADE29BF-1459-4C9E-9A66-DA478E96D5E7'




AET_ART_ArticuloId
A838034E-D07C-4BBF-9915-54C29F005AA5
Select top (10) * from ArticulosCotizados
Select top (10) * from ArticulosEspecialesCotizados

Select top (10) * from ArticulosParametrosCalidad Where APC_ART_ArticuloId = '25B231F7-1D21-45C1-A410-D05525A446BC'

Select top(10) * from ControlesMaestrosUM
Select top(10) * from Proyectos

Select top (10) * from OrdenesVenta
Select top (10) * from OrdenesVentaDetalle
Select top (10) * from OrdenesVentaReq
Select top (10) * from Clientes
Select top (10) * from ClientesContactos

*/

