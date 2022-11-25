-- Nombre: 023 Recibos de Producion (Montar en Macro)
-- Objetivo: Mostrar la producion ingresada al Almacen de PT.
-- Desarrollo: Ing. Vicente Cueva Ramírez.
-- Actualizado: Miercoles 07 de Septiembre del 2022; Origen

-- Parametros 
Declare @FechaIS as nvarchar(30)
Declare @FechaFS as nvarchar(30)

Set @FechaIS = CONVERT (DATE, '2022/09/14', 102)
Set @FechaFS = CONVERT (DATE, '2022/09/14', 102)

-- Desarrollo de la Consulta.

Select Cast(BOR_FechaRecibo As Date) AS FECH_RECIBO
        , BUL_NumeroBulto AS BULTO
        , OT_Codigo AS NUM_OT
        , OV_CodigoOV AS OV
        , PRY_CodigoEvento + '   ' + PRY_NombreProyecto AS PROYECTO
        , ART_CodigoArticulo + '  ' + ART_Nombre AS ARTICULO
        , BOR_Cantidad AS CANT_RECIBIDA
        , OVD_PrecioUnitario AS PRECIO
        , MON_Abreviacion AS MONEDA  
        , OV_MONP_Paridad AS PARIDAD
        , BOR_Cantidad * OVD_PrecioUnitario * OV_MONP_Paridad AS IMPORTE_MX
        , EMP_CodigoEmpleado + '  ' +  EMP_Nombre + '  ' + EMP_PrimerApellido AS RECIBIO        
from BultoOTRecibo
Inner Join Bultos on BOR_BUL_BultoId = BUL_BultoId
Inner Join OrdenesTrabajo on BOR_OT_OrdenTrabajoId = OT_OrdenTrabajoId
Inner Join Articulos on BOR_ART_ArticuloId = ART_ArticuloId
Inner Join OrdenesTrabajoReferencia on OTRE_OT_OrdenTrabajoId = OT_OrdenTrabajoId
Inner Join OrdenesVentaDetalle on OTRE_OV_OrdenVentaId = OVD_OV_OrdenVentaId and OVD_ART_ArticuloId = ART_ArticuloId
Inner join OrdenesVenta on OVD_OV_OrdenVentaId = OV_OrdenVentaId
Inner Join Monedas on MON_MonedaId = OV_MON_MonedaId
Inner Join Proyectos on PRY_ProyectoId = OV_PRO_ProyectoId
Inner Join Empleados on EMP_EmpleadoId = BOR_EMP_CreadoPorId
where Cast(BOR_FechaRecibo As Date) BETWEEN @FechaIS and @FechaFS


Select * from BultoOTRecibo 
Inner Join Bultos on BOR_BUL_BultoId = BUL_BultoId
where Cast(BOR_FechaRecibo As Date) BETWEEN @FechaIS and @FechaFS



-- Para montar en la Macro

Select Cast(BOR_FechaRecibo As Date) AS FECH_RECIBO, BUL_NumeroBulto AS BULTO, OT_Codigo AS NUM_OT, OV_CodigoOV AS OV, PRY_CodigoEvento + '   ' + PRY_NombreProyecto AS PROYECTO, ART_CodigoArticulo + '  ' + ART_Nombre AS ARTICULO, BOR_Cantidad AS CANT_RECIBIDA, OVD_PrecioUnitario AS PRECIO, MON_Abreviacion AS MONEDA, OV_MONP_Paridad AS PARIDAD, BOR_Cantidad * OVD_PrecioUnitario * OV_MONP_Paridad AS IMPORTE_MX, EMP_CodigoEmpleado + '  ' +  EMP_Nombre + '  ' + EMP_PrimerApellido AS RECIBIO from BultoOTRecibo Inner Join Bultos on BOR_BUL_BultoId = BUL_BultoId Inner Join OrdenesTrabajo on BOR_OT_OrdenTrabajoId = OT_OrdenTrabajoId Inner Join Articulos on BOR_ART_ArticuloId = ART_ArticuloId Inner Join OrdenesTrabajoReferencia on OTRE_OT_OrdenTrabajoId = OT_OrdenTrabajoId Inner Join OrdenesVentaDetalle on OTRE_OV_OrdenVentaId = OVD_OV_OrdenVentaId and OVD_ART_ArticuloId = ART_ArticuloId
Inner join OrdenesVenta on OVD_OV_OrdenVentaId = OV_OrdenVentaId Inner Join Monedas on MON_MonedaId = OV_MON_MonedaId Inner Join Proyectos on PRY_ProyectoId = OV_PRO_ProyectoId Inner Join Empleados on EMP_EmpleadoId = BOR_EMP_CreadoPorId where Cast(BOR_FechaRecibo As Date) BETWEEN @FechaIS and @FechaFS 





/*

-- Consulta inicial no funciono.
Select	'VAL_REG' AS VAL_RBV
        , OTR_FechaUltimaModificacion AS F_RECIBO
        , OT_Codigo AS NUM_OT
        , ISNULL((Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = PR_ID ), 'SIN_RELACION') AS PROYECTO
        , ISNULL((Select ART_CodigoArticulo + '   ' + ART_Nombre from Articulos Where ART_ArticuloId = AR_ID), 'SIN RELACION') AS ARTICULO
        , OTRD_CantidadRecibo AS CANT
        , ISNULL(OV_CD, 'SIN RELACION') AS OV_RBV
        , ISNULL((Select OVR_PrecioUnitario 
from OrdenesVentaReq 
where OVR_OVDetalleId = OVD_ID), PRE_OV) AS P_VENTA

, ISNULL((Select MON_Nombre from Monedas Where MON_MonedaId = MON_OV),'S/REL') AS MONEDA
, ISNULL((Select OV_MONP_Paridad from OrdenesVenta where OV_OrdenVentaId = OV_ID), TCA_OV) AS PARIDAD 
from OrdenesTrabajoRecibo 

inner join OrdenesTrabajoReciboDetalle on OTR_OrdenTrabajoReciboId = OTRD_OTR_OrdenTrabajoReciboId
inner join OrdenesTrabajo on OTR_OT_OrdenTrabajoId = OT_OrdenTrabajoId 
left join RBV_OT on OTR_OT_OrdenTrabajoId = OT_ID 

where Cast(OTR_FechaUltimaModificacion As Date) BETWEEN @FechaIS and @FechaFS 
Order by Cast(OTR_FechaUltimaModificacion As Date)
*/
