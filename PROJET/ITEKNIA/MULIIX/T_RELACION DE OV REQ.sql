

--Select top(10) * from OrdenesVenta --where OV_COT_CotizacionId is not null

--Select top(10) * from OrdenesVentaDetalle --Where OVD_COT_CotizacionId is not null	--OVD_COTD_CotizacionDetalleId



--Select top(10) * from Cotizaciones
--Select top(10) * from CotizacionesDetalles


Select COT_CodigoCotizacion
        , COT_Concepto
        , COT_Revision
        , COTD_Concepto
        , OV_CodigoOV
        --, OV_Concepto
from OrdenesVentaDetalle 
inner join OrdenesVenta on OV_OrdenVentaId = OVD_OV_OrdenVentaId
inner join Cotizaciones on  OVD_COT_CotizacionId = OV_OrdenVentaId
inner join CotizacionesDetalles  on COT_CotizacionId = OVD_COTD_CotizacionDetalleId
--Where OVD_COT_CotizacionId is not null	--OVD_COTD_CotizacionDetalleId

