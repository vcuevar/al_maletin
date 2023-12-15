-- Reporte de Materiales Capturados en OT
-- Estas Consultas se usaran en Macro 036
-- Ing. Vicente Cueva Ramírez
-- Actualizado: Viernes 08 de Enero del 2021; Origen.
-- Actualizado: Martes 12 de Enero del 2021; Generar Resumen de OT en Proceso.
-- Actualizado: Miercoles 10 de Marzo del 2021; Tomar en cuenta Tipo de Cambio a los USD.

-- MACRO 036-B, Sacar Materiales por Orden de Trabajo.

Select  OT_Codigo as OT
	, AFC_FactorConversion as CONVER,
        A3.ART_CodigoArticulo as CODE,
        A3.ART_Nombre as DESCRIPCION,       
        OTDA_Cantidad as CANT,
        ACAT_Nombre as CATEGORIA,
        A1.ART_CodigoArticulo as CODIGO,
        A1.ART_Nombre as MATERIAL,       
        CMUM_Nombre as UDM,
        OTARA_Cantidad as CONSUMO,
        ISNULL((LPC_PrecioCompra / AFC_FactorConversion),0) as COSTO_P,
        (Case When LPC_MON_MonedaId = '748BE9C9-B56D-4FD2-A77F-EE4C6CD226A1' then 'MXP' else
        Case When LPC_MON_MonedaId = '1EA50C6D-AD92-4DE6-A562-F155D0D516D3'then 'USD' else 'NOSE' end end) as MONEDA,                
        (Case When LPC_MON_MonedaId = '1EA50C6D-AD92-4DE6-A562-F155D0D516D3' then
        (select MONP_TipoCambioOficial from MonedasParidad
        where Cast(MONP_FechaInicio as Date) = CONVERT (date, GETDATE()) and MONP_MON_MonedaId = '1EA50C6D-AD92-4DE6-A562-F155D0D516D3')*
        (OTARA_Cantidad * ISNULL((LPC_PrecioCompra / AFC_FactorConversion),0))
        Else (OTARA_Cantidad * ISNULL((LPC_PrecioCompra / AFC_FactorConversion),0)) End) as IMPORTE,
        OTARA_FechaAsignacion as FE_ASIG,
        CMM_Valor as ESTATUS
from OrdenesTrabajo
inner join OrdenesTrabajoDetalleArticulos on OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId
inner Join Articulos A3 on A3.ART_ArticuloId = OTDA_ART_ArticuloId
inner join OrdenesTrabajoAsignacionRecursosArticulos on OT_OrdenTrabajoId = OTARA_OT_OrdenTrabajoId
inner join Articulos A1 on A1.ART_ArticuloId = OTARA_ART_ArticuloId
inner join ControlesMaestrosUM on CMUM_UnidadMedidaId = A1.ART_CMUM_UMInventarioId
inner join ArticulosCategorias on ACAT_CategoriaId = A1.ART_ACAT_CategoriaId
left join ListaPreciosCompra on A1.ART_ArticuloId = LPC_ART_ArticuloId and LPC_ProvPreProgramado = 1
inner join ArticulosFactoresConversion on A1.ART_ArticuloId =AFC_ART_ArticuloId and A1.ART_CMUM_UMConversionOCId = AFC_CMUM_UnidadMedidaId  
inner join ControlesMaestrosMultiples on CMM_ControlId = OT_CMM_Estatus
Where  OT_Codigo = 'OT03690'
Order By A1.ART_Nombre, Cast(OTARA_FechaAsignacion As Date)

-- MACRO 036-A Cabecera del Reporte, Numero de OT por Estatus de Abiertas y Proceso.

select Distinct  Count(OT_Codigo) as Numer_OT,
        CMM_Valor as STATUS
from OrdenesTrabajo
inner join ControlesMaestrosMultiples on CMM_ControlId = OT_CMM_Estatus
Where (CMM_Valor = 'En Producción' or CMM_Valor = 'Abierta') and OT_Eliminado = 0
Group By CMM_Valor

-- MACRO 036-A Cuerpo del Reporte, Resumen de Materiales Cargados a las OT

Select  OTRES.OT
        , OTRES.CODE
        , OTRES.DESCRIPCION
        , OTRES.CANT
        , ISNULL(SUM(OTRES.IMPORTE), 0) as IMPORTE
        , OTRES.ESTATUS
From (
Select  OT_Codigo as OT, 
        A3.ART_CodigoArticulo as CODE,
        A3.ART_Nombre as DESCRIPCION,       
        OTDA_Cantidad as CANT,
        (Case When LPC_MON_MonedaId = '1EA50C6D-AD92-4DE6-A562-F155D0D516D3' then
        (select MONP_TipoCambioOficial from MonedasParidad
        where Cast(MONP_FechaInicio as Date) = CONVERT (date, GETDATE()) and MONP_MON_MonedaId = '1EA50C6D-AD92-4DE6-A562-F155D0D516D3')*
        (OTARA_Cantidad * ISNULL((LPC_PrecioCompra / AFC_FactorConversion),0))
        Else (OTARA_Cantidad * ISNULL((LPC_PrecioCompra / AFC_FactorConversion),0)) End) as IMPORTE,
        CMM_Valor as ESTATUS
from OrdenesTrabajo
inner join OrdenesTrabajoDetalleArticulos on OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId
inner Join Articulos A3 on A3.ART_ArticuloId = OTDA_ART_ArticuloId
inner join OrdenesTrabajoAsignacionRecursosArticulos on OT_OrdenTrabajoId = OTARA_OT_OrdenTrabajoId
inner join Articulos A1 on A1.ART_ArticuloId = OTARA_ART_ArticuloId
inner join ControlesMaestrosUM on CMUM_UnidadMedidaId = A1.ART_CMUM_UMInventarioId
inner join ArticulosCategorias on ACAT_CategoriaId = A1.ART_ACAT_CategoriaId
left join ListaPreciosCompra on A1.ART_ArticuloId = LPC_ART_ArticuloId and LPC_ProvPreProgramado = 1
inner join ArticulosFactoresConversion on A1.ART_ArticuloId =AFC_ART_ArticuloId and A1.ART_CMUM_UMConversionOCId = AFC_CMUM_UnidadMedidaId  
inner join ControlesMaestrosMultiples on CMM_ControlId = OT_CMM_Estatus
Where   CMM_Valor = 'En Producción' and OT_Eliminado = 0
)OTRES
Group by OTRES.OT,OTRES.CODE, OTRES.DESCRIPCION, OTRES.CANT, OTRES.ESTATUS
Order By OTRES.OT




"Select  OT_Codigo as OT, A3.ART_CodigoArticulo as CODE, A3.ART_Nombre as DESCRIPCION, OTDA_Cantidad as CANT, SUM((OTARA_Cantidad * ISNULL((LPC_PrecioCompra / AFC_FactorConversion),0))) as IMPORTE, CMM_Valor as ESTATUS from OrdenesTrabajo inner join OrdenesTrabajoDetalleArticulos on OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId inner Join Articulos A3 on A3.ART_ArticuloId = OTDA_ART_ArticuloId inner join OrdenesTrabajoAsignacionRecursosArticulos on OT_OrdenTrabajoId = OTARA_OT_OrdenTrabajoId inner join Articulos A1 on A1.ART_ArticuloId = OTARA_ART_ArticuloId inner join ControlesMaestrosUM on CMUM_UnidadMedidaId = A1.ART_CMUM_UMInventarioId inner join ArticulosCategorias on ACAT_CategoriaId = A1.ART_ACAT_CategoriaId " _
& " left join ListaPreciosCompra on A1.ART_ArticuloId = LPC_ART_ArticuloId and LPC_ProvPreProgramado = 1 inner join ArticulosFactoresConversion on A1.ART_ArticuloId =AFC_ART_ArticuloId and A1.ART_CMUM_UMConversionOCId = AFC_CMUM_UnidadMedidaId inner join ControlesMaestrosMultiples on CMM_ControlId = OT_CMM_Estatus Where   CMM_Valor = 'En Producción' and OT_Eliminado = 0 Group by OT_Codigo, CMM_Valor, A3.ART_CodigoArticulo, A3.ART_Nombre, OTDA_Cantidad Order By OT_Codigo "