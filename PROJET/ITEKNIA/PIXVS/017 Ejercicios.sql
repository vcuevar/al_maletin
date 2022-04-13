-- 017 Ejercicios para Ordenes de Compras Abiertas.
-- Ing. Vicente Cueva R.
-- Actualizado: Lunes 16 de Julio del 2018

Declare @FechaIS nvarchar(30), @FechaFS nvarchar(30)
--Parametros Fecha Inicial y Fecha Final
Set @FechaIS = '2018-07-14'
Set @FechaFS = '2018-07-14' 


Select * from OrdenesCompra		-- Reg. 2,316
where OC_CodigoOC = 'OC0003'
--where OC_OrdenCompraId = '8B2D9EC0-FB2F-4E20-9C97-1B0BFC32E0AE' -- Id de la Orden de Compra

Select * from OrdenesCompraDetalle		-- Reg 5,515
Where OCD_OC_OrdenCompraId = '050073D9-0D90-457A-8DFE-8C571B0A0CC1'
 --OC_OrdenCompraId = OCD_OC_OrdenCompraId

Select * from OrdenesCompraFechasRequeridas		-- Reg 5,508
Where OCFR_OCD_PartidaId = 'D3CD86F2-1039-47A4-BDED-245AC87DCC76'
-- OCD_PartidaId = OCFR_OCD_PartidaId

Select * from OrdenesCompraRecibos			-- Reg 5,581
where OCRC_OCR_OCRequeridaId = 'CB0C3F99-869F-47A8-9EA3-BF86B244A770' 
--  OCFR_FechaRequeridaId =OCRC_OCR_OCRequeridaId

Select OCFR_CMM_EstadoFechaRequeridaId, OCFR_FechaPromesa, OCD_PartidaId, * from OrdenesCompra
inner join OrdenesCompraDetalle on OC_OrdenCompraId = OCD_OC_OrdenCompraId
left join OrdenesCompraFechasRequeridas on OCD_PartidaId = OCFR_OCD_PartidaId
--Left Join OrdenesCompraRecibos on OCFR_FechaRequeridaId =OCRC_OCR_OCRequeridaId
where OCFR_FechaPromesa is null

Where 'OC0003'


Select SUM(OCRC_CantidadRecibo) AS RECIBO from OrdenesCompraRecibos
where OCRC_OCR_OCRequeridaId = OCFR_FechaRequeridaId 
--  OCFR_FechaRequeridaId =OCRC_OCR_OCRequeridaId




--Bases de Soporte.

Select * from ControlesMaestrosMultiples
--where CMM_ControllId = 'B7DAE8A8-76F6-4CB4-A941-ECE2CADE427D'  -- Abierta
--where CMM_ControllId = '1573B91D-D1F0-48FE-80D3-FDC2814164A3'  -- Completa
--where CMM_ControllId = '256AC98B-E210-4E53-AE04-B093D22BCF22'  -- Correspondida
Where CMM_Control = 'CMM_COC_EstadoFechaRequeridaOC'

Select MON_Nombre from Monedas Where MON_MonedaId = '748BE9C9-B56D-4FD2-A77F-EE4C6CD226A1'

Select * from ControlesMaestrosDSC Where CMDSC_CodigoId = 16 

Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos Where EV_EventoId = OC_EV_ProyectoId
F282CD7E-FAD0-4F72-827F-C82838205E0A

Select EMP_Nombre + '  ' + EMP_PrimerApellido from Empleados Where EMP_EmpleadoId = OC_EMP_ModificadoPor
B27AB946-01C7-4C70-A82D-E984E27E7EE3


Select REQ_CodigoRequisicion + '  REQUIERE:  ' + (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = REQ_CMM_TipoRequisicion)
from Requisiciones Where REQ_RequisicionId = '70E45446-277D-4F8C-BDA2-5A94872ED95A'

Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControllId = 'DFA4AF5D-E9D6-4D4B-B851-8C56FE575167'










---- oldidados
Select * from OrdenesCompraRecibos
where OCRC_OC_OrdenCompraId = '8B2D9EC0-FB2F-4E20-9C97-1B0BFC32E0AE' --Orden de Compra 

Select * from CXPRegistrosDetalle 
Where CXPRD_OCRC_ReciboId = 'CF4151EF-8A84-4B1C-B98F-6423757CB419'  -- Id Recibo de Compras

Select * from CXPRegistros
where CXPR_RegistroCXPId = 'C5C1045F-FD3E-42DC-ABB3-1CF52BECDDF1'

Select * from CXPRegistros
where CXPR_RegistroCXPId = 'B18A2467-C717-4B53-A8B2-00DD107FD517'
Select * from ControlesMaestrosMultiples
Where CMM_ControllId = '3EDB1C8E-2C5D-443B-A402-38ABBB307188'


Select CXPR_CodigoRegistro, *
from OrdenesCompraRecibos
left join CXPRegistrosDetalle on OCRC_ReciboId = CXPRD_OCRC_ReciboId
left join CXPRegistros on CXPR_RegistroCXPId = CXPRD_CXPR_RegistroCXPId
--where OCRC_OCR_OCRequeridaId = 'C4D64A07-CCFF-4AE7-B574-E42DDCC1BE2F'
where OCRC_OC_OrdenCompraId  = '778F973B-DA57-4FF8-AC96-2D030208967E'
AND OCRC_OCR_OCRequeridaId = '778F973B-DA57-4FF8-AC96-2D030208967E'

--) AS NUM_FACT,

Select * from OrdenesCompraFechasRequeridas
Where OCFR_FechaRequeridaId = 'C4D64A07-CCFF-4AE7-B574-E42DDCC1BE2F'

Select CXPR_CodigoRegistro, CXPRD_PRY_ProyectoId , CXPRegistrosDetalle.* 
from OrdenesCompraRecibos
left join CXPRegistrosDetalle on OCRC_ReciboId = CXPRD_OCRC_ReciboId
left join CXPRegistros on CXPR_RegistroCXPId = CXPRD_CXPR_RegistroCXPId
Where Cast(OCRC_FechaRecibo As Date) BETWEEN '2018-07-14' and '2018-07-14'






Select * from CXPRegistros
where CXPR_RegistroCXPId = '855C9DEF-4883-4C61-9C36-F6D4D543B330'

Select * from CXPRegistrosDetalle 
Where CXPRD_OCRC_ReciboId = 'E5C957F9-A076-4565-BC4F-095644B6471D'

Select * from CXPPagos
Where CXPP_PagoCXPId = '76A6C2F0-13A9-42FD-BB67-D294AA959098'

Select * from CXPPagosDetalle
where CXPPD_CXPR_RegistroCXPId = '855C9DEF-4883-4C61-9C36-F6D4D543B330'




Select CXPR_CodigoRegistro, * 
from OrdenesCompraRecibos 
left join CXPRegistrosDetalle on CXPRD_OCRC_ReciboId = OCRC_ReciboId
inner join CXPRegistros on  CXPR_RegistroCXPId = CXPRD_CXPR_RegistroCXPId
Where CXPRD_OCRC_ReciboId = 'E5C957F9-A076-4565-BC4F-095644B6471D'
