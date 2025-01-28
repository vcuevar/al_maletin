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
Where OC_CodigoOC = 'OC00597'


Select Distinct(OC_CMM_EstadoOC), CMM_Valor from OrdenesCompra
Inner join ControlesMaestrosMultiples on OC_CMM_EstadoOC = CMM_ControlID

--update OrdenesCompra set OC_Borrado = 0 Where OC_CodigoOC = 'OC03048'


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






SELECT
    OC_OrdenCompraId AS DT_RowId,
    OC_CodigoOC,
    PRO_CodigoProveedor,
    PRO_Nombre AS PRO_NombreComercial,
    PRO_NombreComercial AS PRO_RazonSocial,
    CMM_Valor AS OC_CMM_EstadoOC,
    MON_Nombre,
    ROUND(SUM(((OCFR_CantidadRequerida * OCFR_PrecioUnitario) - ((OCFR_CantidadRequerida * OCFR_PrecioUnitario) * (OCFR_PorcentajeDescuento/100))) +
    (((OCFR_CantidadRequerida * OCFR_PrecioUnitario) - ((OCFR_CantidadRequerida * OCFR_PrecioUnitario) * (OCFR_PorcentajeDescuento/100))) * ISNULL(OCD_CMIVA_PorcentajeIVA, 0.0))),2) AS OC_Total,
    CAST(OC_FechaOC AS DATE) AS OC_FechaOC,
    CAST(OC_FechaUltimaModificacion AS DATETIME) AS OC_FechaUltimaModificacion
FROM OrdenesCompra
INNER JOIN OrdenesCompraDetalle ON OCD_OC_OrdenCompraId = OC_OrdenCompraId
INNER JOIN OrdenesCompraFechasRequeridas ON OCFR_OC_OrdenCompraId = OC_OrdenCompraId AND OCD_PartidaId = OCFR_OCD_PartidaId
INNER JOIN Proveedores ON PRO_ProveedorId = OC_PRO_ProveedorId
INNER JOIN ControlesMaestrosMultiples ON CMM_ControlId = OC_CMM_EstadoOC
INNER JOIN Monedas ON MON_MonedaId = OC_MON_MonedaId
WHERE OC_Borrado = 0
AND OCD_Borrado = 0
--AND OCFR_Borrado = 0
--AND OC_EMP_CreadoPor = '".$idEmpleado."'
AND OC_CMM_EstadoOC = '59CE1E71-3AEE-4ACC-B5DE-6A03C2983D6CIN' -- ('0825D10C-15F4-4C8F-A3E9-4C480E00068D')
GROUP BY
    OC_OrdenCompraId,
    OC_CodigoOC,
    PRO_CodigoProveedor,
    PRO_Nombre,
    PRO_NombreComercial,
    CMM_Valor,
    MON_Nombre,
    OC_FechaOC,
    OC_FechaUltimaModificacion
ORDER BY  OC_CodigoOC DESC
    
    
    Select * from ControlesMaestrosMultiples Where CMM_Control =  'CMM_EstadoOC'
    
    
Select Distinct(OC_CMM_EstadoOC) --, CMM_Valor 
from OrdenesCompra
Inner join ControlesMaestrosMultiples on OC_CMM_EstadoOC = CMM_ControlID

Select * from ControlesMaestrosMultiples Where CMM_Control like '%OC%' Order By CMM_Control 

Select * from ControlesMaestrosMultiples --Where CMM_ControlId = '0825D10C-15F4-4C8F-A3E9-4C480E00068D' 
Where CMM_Control like 'CMM_COC_EstadoOrdenCompra'

C801F991-979A-4C36-BC5C-F0BA88D05826	CMM_COC_EstadoOrdenCompra	CANCELADA
C845EF49-4729-416C-9E7B-288B11BCDF47	CMM_COC_EstadoOrdenCompra	Por Aprobar
DF4DA5D4-B56C-4319-89D5-A3010359BADA	CMM_COC_EstadoOrdenCompra	Cerrada
5A8C87F2-B6F0-4580-A581-F1A7DBF70C54	CMM_COC_EstadoOrdenCompra	Etiquetada
0825D10C-15F4-4C8F-A3E9-4C480E00068D	CMM_COC_EstadoOrdenCompra	Recibida Completa
4C9DCE78-3461-4499-A579-8DDD5179B941	CMM_COC_EstadoOrdenCompra	Recibida Parcial

Select * from ControlesMaestrosMultiples  
Where CMM_Control like 'CMM_COC_EstadoPartidaOC'

E85A2462-BE47-47B1-85E9-ED4E8AF82E19	CMM_COC_EstadoPartidaOC	Abierta
3B2F2B9C-F9A9-40FD-A2EF-FE476106CA45	CMM_COC_EstadoPartidaOC	Completa
C9B6428B-E1B1-44C5-AAC9-DCD65628B530	CMM_COC_EstadoPartidaOC	Correspondida Completa
AA726CB7-987C-4607-929F-0FB5B226F616	CMM_COC_EstadoPartidaOC	Correspondida Parcial
6D5762C9-CA9C-4DC3-A6A6-61237BC6DD06	CMM_COC_EstadoPartidaOC	Parcial

Select * from ControlesMaestrosMultiples  
Where CMM_Control = 'CMM_EstadoOC'

C801F991-979A-4C36-BC5C-F0BA88D05826	CMM_EstadoOC	CANCELADA
C845EF49-4729-416C-9E7B-288B11BCDF47	CMM_EstadoOC	Por Aprobar
59CE1E71-3AEE-4ACC-B5DE-6A03C2983D6C	CMM_EstadoOC	Abierta
CFD16CB6-91DD-423F-AF53-5CAA86701D7F	CMM_EstadoOC	Completa
545CF84B-BBBA-46FE-ADEC-586AEEF4ED78	CMM_EstadoOC	Correspondida Completa
1C086C08-E99B-4166-895C-FFDEE5D8437D	CMM_EstadoOC	Correspondida Parcial
F005FA77-8026-472F-A288-8680DFD711C0	CMM_EstadoOC	Parcial


select * from OrdenesCompra
inner join OrdenesCompraDetalle on OCD_OC_OrdenCompraId = OC_OrdenCompraId
Where OC_CodigoOC = 'OC11336'

Select * from Empleados Where EMP_EmpleadoId ='FF6BED60-4F54-42DD-83E9-6DB365B9EE00'
Select * from Empleados Where EMP_EmpleadoId = '973FE41A-7BCF-4550-9957-4695BEE4BA73'



-- Correccion de Estatus despues de los cambios que hizo Francisco 250116
-- Envio correo Elizbeth para cambiar estatus.

Select OC_CMM_EstadoOC,  * from OrdenesCompra Where  OC_CodigoOC = 'OC11337' 


-- Deben estar abiertas.
Update OrdenesCompra Set OC_CMM_EstadoOC = '59CE1E71-3AEE-4ACC-B5DE-6A03C2983D6C' Where OC_CodigoOC = 'OC11337'
Update OrdenesCompra Set OC_CMM_EstadoOC = '59CE1E71-3AEE-4ACC-B5DE-6A03C2983D6C' Where OC_CodigoOC = 'OC11333'
Update OrdenesCompra Set OC_CMM_EstadoOC = '59CE1E71-3AEE-4ACC-B5DE-6A03C2983D6C' Where OC_CodigoOC = 'OC11323'
Update OrdenesCompra Set OC_CMM_EstadoOC = '59CE1E71-3AEE-4ACC-B5DE-6A03C2983D6C' Where OC_CodigoOC = 'OC11322'
Update OrdenesCompra Set OC_CMM_EstadoOC = '59CE1E71-3AEE-4ACC-B5DE-6A03C2983D6C' Where OC_CodigoOC = 'OC11321'
Update OrdenesCompra Set OC_CMM_EstadoOC = '59CE1E71-3AEE-4ACC-B5DE-6A03C2983D6C' Where OC_CodigoOC = 'OC11288'
Update OrdenesCompra Set OC_CMM_EstadoOC = '59CE1E71-3AEE-4ACC-B5DE-6A03C2983D6C' Where OC_CodigoOC = 'OC11280'

--Deben estar Completas.
Update OrdenesCompra Set OC_CMM_EstadoOC = 'CFD16CB6-91DD-423F-AF53-5CAA86701D7F' Where OC_CodigoOC = 'OC11292'
Update OrdenesCompra Set OC_CMM_EstadoOC = 'CFD16CB6-91DD-423F-AF53-5CAA86701D7F' Where OC_CodigoOC = 'OC11320'
Update OrdenesCompra Set OC_CMM_EstadoOC = 'CFD16CB6-91DD-423F-AF53-5CAA86701D7F' Where OC_CodigoOC = 'OC11319'
Update OrdenesCompra Set OC_CMM_EstadoOC = 'CFD16CB6-91DD-423F-AF53-5CAA86701D7F' Where OC_CodigoOC = 'OC11045'
Update OrdenesCompra Set OC_CMM_EstadoOC = 'CFD16CB6-91DD-423F-AF53-5CAA86701D7F' Where OC_CodigoOC = 'OC11778'
Update OrdenesCompra Set OC_CMM_EstadoOC = 'CFD16CB6-91DD-423F-AF53-5CAA86701D7F' Where OC_CodigoOC = 'OC10736'
Update OrdenesCompra Set OC_CMM_EstadoOC = 'CFD16CB6-91DD-423F-AF53-5CAA86701D7F' Where OC_CodigoOC = 'OC10655'
Update OrdenesCompra Set OC_CMM_EstadoOC = 'CFD16CB6-91DD-423F-AF53-5CAA86701D7F' Where OC_CodigoOC = 'OC10638'
Update OrdenesCompra Set OC_CMM_EstadoOC = 'CFD16CB6-91DD-423F-AF53-5CAA86701D7F' Where OC_CodigoOC = 'OC10633'
Update OrdenesCompra Set OC_CMM_EstadoOC = 'CFD16CB6-91DD-423F-AF53-5CAA86701D7F' Where OC_CodigoOC = 'OC10584'
Update OrdenesCompra Set OC_CMM_EstadoOC = 'CFD16CB6-91DD-423F-AF53-5CAA86701D7F' Where OC_CodigoOC = 'OC10429'
Update OrdenesCompra Set OC_CMM_EstadoOC = 'CFD16CB6-91DD-423F-AF53-5CAA86701D7F' Where OC_CodigoOC = 'OC10395'
Update OrdenesCompra Set OC_CMM_EstadoOC = 'CFD16CB6-91DD-423F-AF53-5CAA86701D7F' Where OC_CodigoOC = 'OC10263'
Update OrdenesCompra Set OC_CMM_EstadoOC = 'CFD16CB6-91DD-423F-AF53-5CAA86701D7F' Where OC_CodigoOC = 'OC10220'
Update OrdenesCompra Set OC_CMM_EstadoOC = 'CFD16CB6-91DD-423F-AF53-5CAA86701D7F' Where OC_CodigoOC = 'OC10192'
Update OrdenesCompra Set OC_CMM_EstadoOC = 'CFD16CB6-91DD-423F-AF53-5CAA86701D7F' Where OC_CodigoOC = 'OC10142'
Update OrdenesCompra Set OC_CMM_EstadoOC = 'CFD16CB6-91DD-423F-AF53-5CAA86701D7F' Where OC_CodigoOC = 'OC10139'
Update OrdenesCompra Set OC_CMM_EstadoOC = 'CFD16CB6-91DD-423F-AF53-5CAA86701D7F' Where OC_CodigoOC = 'OC09955'

--250122 Se deja parcial para que las modifiquen.
Update OrdenesCompra Set OC_CMM_EstadoOC = 'F005FA77-8026-472F-A288-8680DFD711C0' Where OC_CodigoOC = 'OC11319'
Update OrdenesCompra Set OC_CMM_EstadoOC = 'F005FA77-8026-472F-A288-8680DFD711C0' Where OC_CodigoOC = 'OC11320'

-- 250122 Seregresan a Completas.
Update OrdenesCompra Set OC_CMM_EstadoOC = 'CFD16CB6-91DD-423F-AF53-5CAA86701D7F' Where OC_CodigoOC = 'OC11320'
Update OrdenesCompra Set OC_CMM_EstadoOC = 'CFD16CB6-91DD-423F-AF53-5CAA86701D7F' Where OC_CodigoOC = 'OC11319'

