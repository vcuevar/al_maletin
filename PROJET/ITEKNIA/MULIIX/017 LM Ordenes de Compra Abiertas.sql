-- 017 Reporte de Ordenes de Compras Abiertas.
-- Ing. Vicente Cueva R.
-- Actualizado: Miercoles 21 de Agosto del 2018; Habilitar en MULIIX.

--Parametros Ninguno

-- Desarrollo de la Consulta.

Select	OC_CodigoOC AS NUM_OC, 
		--(Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = OC_CMM_TipoOCId) AS TIPO_OC, 
		--(Select CMM_Valor from ControlesMaestrosMultiples where CMM_ControllId = OC_CMM_EstadoOC) AS STA_OC, (Select CMM_Valor from ControlesMaestrosMultiples where CMM_ControllId = OCFR_CMM_EstadoFechaRequeridaId) AS STA_PAR, (Select CMM_Valor from ControlesMaestrosMultiples where CMM_ControllId = OCD_CMM_TipoPartidaId ) AS TIPO_PART, (Select REQ_CodigoRequisicion + '  REQUIERE:  ' + (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = REQ_CMM_TipoRequisicion) from Requisiciones Where REQ_RequisicionId = OCD_REQ_RequisicionId) AS REQUIERE, 
		OC_FechaOC AS FEC_OC, 
		OC_PDOC_Nombre AS PROVEEDOR, 
		ISNULL(ART_CodigoArticulo, '0000') AS CODE, 
		OCD_DescripcionArticulo AS MATERIAL, 
		OCD_CMUM_UMCompras AS UDMC, 
		ISNULL(OCD_AFC_FactorConversion, 1) AS FAC_CONV, 
		ISNULL(OCD_CMUM_UMInventario, 'S/UMI') AS UDMI, 
		(Select CMUM_Nombre from ControlesMaestrosUM Where CMUM_UnidadMedidaId = ISNULL(ART_CMUM_UMInventarioId,10)) AS UMI, 
		OCFR_CantidadRequerida AS CAN_REQ, 
		ISNULL((Select SUM(OCRC_CantidadRecibo) from OrdenesCompraRecibos where OCRC_OCR_OCRequeridaId = OCFR_FechaRequeridaId),0) AS CAN_ENT,
		Convert(Decimal(28,10),OCFR_PrecioUnitario)	AS PRECIO,
		OCFR_PorcentajeDescuento AS POR_DEC_PA, 
		OC_PorcentajeDescuento AS POR_DESC_GB,
		OC_CMIVA_PorcentajeIVA AS POR_IVA, 
		(Select MON_Nombre from Monedas Where MON_MonedaId = OC_MON_MonedaId) AS MONEDA, 
		(CASE When ISNULL(OC_MONP_Paridad, 1) = 0 then 1 else ISNULL(OC_MONP_Paridad, 1) end) AS PARIDAD, 
		ISNULL(OCFR_FechaPromesa, OCFR_FechaRequerida) AS FEC_ENTREGA, 
		DATEPART(WK, ISNULL(OCFR_FechaPromesa, OCFR_FechaRequerida)) AS SEMANA, 
		--(Select CMDSC_TermsDescuento from ControlesMaestrosDSC Where CMDSC_CodigoId = OC_CMDSC_DescuentoId ) AS CONDIC, 
		--(Select CMDSC_TermsDiasVenc from ControlesMaestrosDSC Where CMDSC_CodigoId = OC_CMDSC_DescuentoId ) AS TERM_DIAS, 
		ISNULL((Select PRY_CodigoEvento + '  ' + PRY_NombreProyecto from Proyectos Where PRY_ProyectoId = OC_EV_ProyectoId ), 'S/P') AS PROYECT1, 
		ISNULL((Select PRY_CodigoEvento + '  ' + PRY_NombreProyecto from Proyectos Where PRY_ProyectoId = OCFR_EV_ProyectoId ), 'S/P') AS PROYECT2, 
		(Select EMP_Nombre + '  ' + EMP_PrimerApellido from Empleados Where EMP_EmpleadoId = OC_EMP_ModificadoPor) AS ELABORO
from OrdenesCompra 
inner join OrdenesCompraDetalle on OC_OrdenCompraId = OCD_OC_OrdenCompraId 
left join OrdenesCompraFechasRequeridas on OCD_PartidaId = OCFR_OCD_PartidaId 
left JOIN Articulos ON OCD_ART_ArticuloId = ART_ArticuloId  
where OC_Borrado = 0 AND 
OCFR_CMM_EstadoFechaRequeridaId = 'B7DAE8A8-76F6-4CB4-A941-ECE2CADE427D' 
--and OC_CodigoOC = 'OC2667'
Order by Cast(OC_FechaOC AS DATE), OC_CodigoOC  


select OC_CodigoOC,  OC_FechaOC,  OCD_AFC_FactorConversion, * from OrdenesCompra
inner join OrdenesCompraDetalle on OCD_OC_OrdenCompraId = OC_OrdenCompraId
Where OC_CodigoOC = 'OC03773'


Select * from OrdenesCompra
Where OC_CodigoOC = 'OC02936'

update OrdenesCompra set OC_Borrado = 0 Where OC_CodigoOC = 'OC03048'


-- Para corregir error de OC que trae el Factorde Conversion 0

Select * from OrdenesCompraDetalle 
inner join OrdenesCompra on OCD_OC_OrdenCompraId = OC_OrdenCompraId
Where OC_CodigoOC = 'OC03773' --and OCD_AFC_FactorConversion is null


Select * from OrdenesCompraDetalle Where OCD_PartidaId = 'F3270CAF-7A20-4738-9F9B-BEA5606E0C54'

update OrdenesCompraDetalle set OCD_AFC_FactorConversion = 1 Where OCD_PartidaId = 'F3270CAF-7A20-4738-9F9B-BEA5606E0C54'


-- Si la cantidad en Null significa que no existe LDM para el articulo.

select  OC_CodigoOC as OC,  
        OC_FechaOC as FEC_OC, 
        A1.ART_CodigoArticulo as CODE, 
        A1.ART_Nombre as MATERIAL, 
        OCFR_CantidadRequerida as CANT_OC,
        OT_Codigo as OT,
        A3.ART_CodigoArticulo as COD_PT, 
        A3.ART_Nombre as PRODUCTO,
        (select top(1) EAR_CantidadEnsamble from EstructurasArticulos Where EAR_ART_ArticuloPadreId = A3.ART_ArticuloId and EAR_ART_ComponenteId = A1.ART_ArticuloId) AS LDM
from OrdenesCompraDetalle
inner join OrdenesCompra on OCD_OC_OrdenCompraId = OC_OrdenCompraId
inner join Articulos A1 on OCD_ART_ArticuloId = A1.ART_ArticuloId
inner join OrdenesTrabajo on OCD_OT_OrdenTrabajoId = OT_OrdenTrabajoId
inner join OrdenesTrabajoDetalleArticulos on OTDA_OT_OrdenTrabajoId = OT_OrdenTrabajoId
inner join Articulos A3 on OTDA_ART_ArticuloId = A3.ART_ArticuloId
left join OrdenesCompraFechasRequeridas on OCD_PartidaId = OCFR_OCD_PartidaId 
where OC_Borrado = 0
Order by OC_CodigoOC



Select * from OrdenesCompraFechasRequeridas
