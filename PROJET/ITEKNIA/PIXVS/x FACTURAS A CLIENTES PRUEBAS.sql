-- 001 Consulta para Kardex de Cuentas por Pagar. 
-- Objetivo: Realizar Kardex de Cuentas por pagar por un Proveedor.
-- Desarrollado: Ing. Vicente Cueva R.
-- Actualizado: Sabado 15 de Junio del 2019; Inicio del reporte.
-- Actualizado: Lunes 17 de Junio del 2019; Culmen del Reporte.
-- Actualizado: Miercoles 26 de Junio del 2019; Cambio de FechaLibroMayor x FechaRegistro.
-- Actualizado: Jueves 04 de Julio del 2019; Usar en Plantillas FechaLibroMayor.

--Parametros Fecha Inicial y Fecha Final
Declare @Proyect uniqueidentifier
Declare @CodProy VarChar(100)
Declare @FechaFS as nvarchar(30)

Set @FechaFS = CONVERT (DATE, '2018-01-01', 102) 
Set @CodProy = '5468.3'

Set @Proyect = (Select EV_EventoId 
from Eventos
where EV_CodigoEvento = @CodProy)

-- Datos de Facturacion 

--Cuentas Contables que se Manejan (Proveedores esta como miscelanea tiene OV)
     --FTR_CMM_CuentasCXC                      CUENTA
--C2944318-F23E-4D66-B7C2-203AEF1A9225	PROVEEDORES MN
--06255ABF-151C-454D-8777-DB1D8EDED766	CLIENTES USD
--C5D7A7A9-B908-4979-941F-ACFAB4526838	CLEINTES EXT
--A2A83524-CE0D-4E09-93D5-6E9247C345E6	HOTELES DINAMICOS SA DE CV
--C42D3850-770B-4D85-8777-B20B1825B72C	CLIENTES M.N.

-- Tipo de Facturas
       --FTR_CMM_TipoFactura					Tipo
--'EA169681-AC4F-4664-986E-9302579B68B6'		FacturaOV
--'2688FE37-D52A-45D6-B2A6-1A6D34577756'		Miscelanea

-- SubTipo de Factura en todos los casos en NULL
--(Select CMM_Valor from ControlesMaestrosMultiples 
--where CMM_ControllId = FTR_CMM_SubTipoFactura) as SUBTIPO,

-- Tipo de Registro
--   FTR_CMM_TipoRegistroId					TIPOREG
--NULL									NULL
--39AF436A-E011-4372-8D63-3FFC199E5718	Factura OV Liquidación
--A560151D-E230-4B58-A091-4EB8B18B8AFF	Factura Miscelanea Anticipo 100 %
--8B9BD26F-9B82-4A00-A0AD-98A863509C44	Factura Miscelanea
--B217AB59-285A-4F59-A2B7-AAED7A248205	Por Sobrante
--038126BC-75D3-422E-8850-75A574F26AFE	Factura Miscelanea Anticipo
--7B9338FF-A0DE-4C03-B037-F76C2CE41838	Factura OV


Select	'FACTURA' AS IDENTIF,
		FTR_FechaFactura,
		FTR_NumeroFactura,

		Case When 

		(Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos 
		Where EV_EventoId = (Select OV_EV_EventoId from OrdenesVenta
		Where OV_OrdenVentaId = (
		Select OVR_OrdenventaId from OrdenesVentaReq 
		Where OVR_OVRequeridaId = (
		Select TOP 1 EMBD_OVR_OVRequeridaId from Embarques
		inner join EmbarquesDetalle on EMB_EmbarqueId = EMBD_EmbarqueId
		Where EMB_FTR_FacturaId = FTR_FacturaId)))) is not Null 
		then
		(Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos 
		Where EV_EventoId = (Select OV_EV_EventoId from OrdenesVenta
		Where OV_OrdenVentaId = (
		Select OVR_OrdenventaId from OrdenesVentaReq 
		Where OVR_OVRequeridaId = (
		Select TOP 1 EMBD_OVR_OVRequeridaId from Embarques
		inner join EmbarquesDetalle on EMB_EmbarqueId = EMBD_EmbarqueId
		Where EMB_FTR_FacturaId = FTR_FacturaId))))
		Else

			Case When 
			FTR_OV_OrdenVentaId is not Null
			Then
			
		(Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos 
		Where EV_EventoId = 
		(Select OV_EV_EventoId from OrdenesVenta Where FTR_OV_OrdenVentaId = OV_OrdenVentaId
		 ))
			Else

			Case When
			FTR_Proyecto is not null
			Then


		(Select EV_CodigoEvento + '  ' + EV_Descripcion from Eventos 
		Where EV_EventoId = FTR_Proyecto ) 
		Else
		'SIN PROYECTO ASIGNADO'
		end END END as PROYECTO,
		
		
		(Select Cast(EV_FechaTermina AS DATE) from Eventos Where EV_EventoId = FTR_Proyecto ) AS FF_PROY,

		(Select CC_Descripcion from CuentasContables
		Where CC_CodigoId = (Select CMM_Valor from ControlesMaestrosMultiples 
		where CMM_ControllId = FTR_CMM_CuentasCXC)) as CCONTA,
		
		(Select CMM_Valor from ControlesMaestrosMultiples 
		where CMM_ControllId = FTR_CMM_TipoFactura) as TIPOFAC,
		(Select CMM_Valor from ControlesMaestrosMultiples 
		where CMM_ControllId = FTR_CMM_TipoRegistroId) as TIPOREG

		
from Facturas
inner join FacturasDetalle on FTRD_FTR_FacturaId = FTR_FacturaId
inner join FacturasReq on FTRR_FTRD_DetalleId = FTRD_DetalleId
Where FTR_Eliminado = 0 


--and  (FTR_NumeroFactura = '8057' or FTR_NumeroFactura = '8022' or FTR_NumeroFactura = '7946') 

--and FTR_CMM_TipoFactura = 'EA169681-AC4F-4664-986E-9302579B68B6'
--and FTR_CMM_TipoFactura = '2688FE37-D52A-45D6-B2A6-1A6D34577756'
--and FTR_Proyecto is null
--and FTR_OV_OrdenVentaId is not null

Order by FTR_FechaFactura




--Select * from ControlesMaestrosMultiples
--where CMM_Control = 'CXC_TipoRegistro'
--Where CMM_ControllId = '39AF436A-E011-4372-8D63-3FFC199E5718'

--FTR_CMM_TipoFactura = 'EA169681-AC4F-4664-986E-9302579B68B6' Factura OV
--FTR_CMM_TipoFactura = '2688FE37-D52A-45D6-B2A6-1A6D34577756' Miscelanea
