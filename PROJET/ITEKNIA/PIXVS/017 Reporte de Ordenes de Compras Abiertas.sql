-- 017 Reporte de Ordenes de Compras Abiertas.
-- Ing. Vicente Cueva R.
-- Solicitado: Sabado 14 de Julio del 2018.
-- Actualizado: Lunes 16 de Julio del 2018
-- Actualizado: Sabado 18 de Agosto del 2018; Cambiar Proyecto tomarlo de Detalles.
-- Actualizado: Jueves 28 de Marzo del 2019; Validar Fecha de Entrega.

Select OC_CodigoOC AS NUM_OC, (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = OC_CMM_TipoOCId) AS TIPO_OC, (Select CMM_Valor from ControlesMaestrosMultiples where CMM_ControllId = OC_CMM_EstadoOC) AS STA_OC, (Select CMM_Valor from ControlesMaestrosMultiples where CMM_ControllId = OCFR_CMM_EstadoFechaRequeridaId) AS STA_PAR, (Select CMM_Valor from ControlesMaestrosMultiples where CMM_ControllId = OCD_CMM_TipoPartidaId ) AS TIPO_PART, (Select REQ_CodigoRequisicion + '  REQUIERE:  ' + (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = REQ_CMM_TipoRequisicion) from Requisiciones Where REQ_RequisicionId = OCD_REQ_RequisicionId) AS REQUIERE, 
OC_FechaOC AS FEC_OC, OC_PDOC_Nombre AS PROVEEDOR, ISNULL(ART_CodigoArticulo, '0000') AS CODE, OCD_DescripcionArticulo AS MATERIAL, OCD_CMUM_UMCompras AS UDMC, ISNULL(OCD_AFC_FactorConversion, 1) AS FAC_CONV, ISNULL(OCD_CMUM_UMInventario, 'S/UMI') AS UDMI, (Select CMUM_Nombre from ControlesMaestrosUM Where CMUM_UnidadMedidaId = ISNULL(ART_CMUM_UMInventarioId,10)) AS UMI, OCFR_CantidadRequerida AS CAN_REQ, ISNULL((Select SUM(OCRC_CantidadRecibo) from OrdenesCompraRecibos where OCRC_OCR_OCRequeridaId = OCFR_FechaRequeridaId),0) AS CAN_ENT, Convert(Decimal(28,10),OCFR_PrecioUnitario)	AS PRECIO, OCFR_PorcentajeDescuento AS POR_DEC_PA, OC_PorcentajeDescuento AS POR_DESC_GB, OC_CMIVA_PorcentajeIVA AS POR_IVA, 
(Select MON_Nombre from Monedas Where MON_MonedaId = OC_MON_MonedaId) AS MONEDA, (CASE When ISNULL(OC_MONP_Paridad, 1) = 0 then 1 else ISNULL(OC_MONP_Paridad, 1) end) AS PARIDAD, 
ISNULL(OCFR_FechaPromesa, OCFR_FechaRequerida) AS FEC_ENTREGA, DATEPART(WK, ISNULL(OCFR_FechaPromesa, OCFR_FechaRequerida)) AS SEMANA, (Select CMDSC_TermsDescuento from ControlesMaestrosDSC Where CMDSC_CodigoId = OC_CMDSC_DescuentoId ) AS CONDIC, (Select CMDSC_TermsDiasVenc from ControlesMaestrosDSC Where CMDSC_CodigoId = OC_CMDSC_DescuentoId ) AS TERM_DIAS, ISNULL((Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OC_EV_ProyectoId ), 'S/P') AS PROYECT1, 
ISNULL((Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OCFR_EV_ProyectoId ), 'S/P') AS PROYECT2, (Select EMP_Nombre + '  ' + EMP_PrimerApellido from Empleados Where EMP_EmpleadoId = OC_EMP_ModificadoPor) AS ELABORO from OrdenesCompra inner join OrdenesCompraDetalle on OC_OrdenCompraId = OCD_OC_OrdenCompraId left join OrdenesCompraFechasRequeridas on OCD_PartidaId = OCFR_OCD_PartidaId left JOIN Articulos ON OCD_ART_ArticuloId = ART_ArticuloId  
where OC_Borrado = 0 AND OCFR_CMM_EstadoFechaRequeridaId = 'B7DAE8A8-76F6-4CB4-A941-ECE2CADE427D' 
--and OC_CodigoOC = 'OC2667'
Order by Cast(OC_FechaOC AS DATE), OC_CodigoOC  


/* Por alguna razon no funciona
Declare @FechaIS nvarchar(30), @FechaFS nvarchar(30)
--Parametros Fecha Inicial y Fecha Final
Set @FechaIS = '2018-07-13'
Set @FechaFS = '2018-07-13' 

-- Consulta para Ordenes de Compra Abiertas.
Select	OC_CodigoOC AS NUM_OC,
		(Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = OC_CMM_TipoOCId) AS TIPO_OC,
		(Select CMM_Valor from ControlesMaestrosMultiples where CMM_ControllId = OC_CMM_EstadoOC) AS STA_OC,
		(Select CMM_Valor from ControlesMaestrosMultiples where CMM_ControllId = OCFR_CMM_EstadoFechaRequeridaId) AS STA_PAR,
		(Select CMM_Valor from ControlesMaestrosMultiples where CMM_ControllId = OCD_CMM_TipoPartidaId ) AS TIPO_PART,
		(Select REQ_CodigoRequisicion + '  REQUIERE:  ' + (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = REQ_CMM_TipoRequisicion) from Requisiciones Where REQ_RequisicionId = OCD_REQ_RequisicionId) AS REQUIERE,
		OC_FechaOC AS FEC_OC,
		OC_PDOC_Nombre AS PROVEEDOR,
		ISNULL(ART_CodigoArticulo, '0000') AS CODE,
		OCD_DescripcionArticulo AS MATERIAL,
		OCD_CMUM_UMCompras AS UDMC,
		ISNULL(OCD_AFC_FactorConversion, 1) AS FAC_CONV,
		ISNULL(OCD_CMUM_UMInventario, 'S/UMI') AS UDMI,
		(Select CMUM_Nombre from ControlesMaestrosUM
		Where CMUM_UnidadMedidaId = ISNULL(ART_CMUM_UMInventarioId,10)) AS UMI,
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
		(Select CMDSC_TermsDescuento from ControlesMaestrosDSC Where CMDSC_CodigoId = OC_CMDSC_DescuentoId ) AS CONDIC,
		(Select CMDSC_TermsDiasVenc from ControlesMaestrosDSC Where CMDSC_CodigoId = OC_CMDSC_DescuentoId ) AS TERM_DIAS,
		ISNULL((Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OC_EV_ProyectoId ), 'S/P') AS PROYECT1,
		ISNULL((Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OCFR_EV_ProyectoId ), 'S/P') AS PROYECT2,
		(Select EMP_Nombre + '  ' + EMP_PrimerApellido from Empleados Where EMP_EmpleadoId = OC_EMP_ModificadoPor) AS ELABORO
		
from OrdenesCompra
inner join OrdenesCompraDetalle on OC_OrdenCompraId = OCD_OC_OrdenCompraId
left join OrdenesCompraFechasRequeridas on OCD_PartidaId = OCFR_OCD_PartidaId
left JOIN Articulos ON OCD_ART_ArticuloId = ART_ArticuloId 
where OC_Borrado = 0 AND OCFR_CMM_EstadoFechaRequeridaId = 'B7DAE8A8-76F6-4CB4-A941-ECE2CADE427D'
and OC_CodigoOC = 'OC3692'
Order by Cast(OC_FechaOC AS DATE), OC_CodigoOC 
*/
--and OC_CodigoOC = 'OC3036'
--and OC_CodigoOC = 'OC0003'
--AND OCFR_CantidadRequerida > ISNULL((Select SUM(OCRC_CantidadRecibo) from OrdenesCompraRecibos where OCRC_OCR_OCRequeridaId = OCFR_FechaRequeridaId),0)
--AND OC_CMM_EstadoOC = '0589CDF3-3175-4501-A47E-BAAEC11B3D60'

-- Estatus de las Ordenes de Compra
--CMM_Valor				CMM_ControllId
--Abierta		= 0589CDF3-3175-4501-A47E-BAAEC11B3D60
--Completa		= DF4DA5D4-B56C-4319-89D5-A3010359BADA
--Correspondida	= A1F8F1C1-55D9-45DD-96D0-ADC6831C6A59

-- Estatus de las Partida de las Ordenes de Compra
--CMM_Valor				CMM_ControllId
--Abierta		= B7DAE8A8-76F6-4CB4-A941-ECE2CADE427D
--Completa		= 1573B91D-D1F0-48FE-80D3-FDC2814164A3
--Correspondida	= 256AC98B-E210-4E53-AE04-B093D22BCF22


--Select * From OrdenesCompra
--where OC_OrdenCompraId = '1566D62D-59A9-4EBF-B99B-330896E9BEA7'

--Update OrdenesCompra set OC_PDOC_Nombre = 'MADERAS INDUSTRIALIZADAS DE JALISCO SA DE CV'
--where OC_OrdenCompraId = '1566D62D-59A9-4EBF-B99B-330896E9BEA7'


