-- Reporte de Bultos.
-- Objetivo: Conocer los contenidos de los bultos elaborados en Empaque.
-- Elaborado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Martes 03 de Noviembre del 2020; Origen.
-- Actualizado: Domingo 22 de Mayo del 201; Completar Información.
-- Actualizado: Miercoles 02 de Junio del 2021; Reporte Detallado.


-- IDTIPO       COMPLEMENTO     A00E0707-1CC9-4F59-8BA6-CD1DC4D82DD4
-- IDTIPO       PRINCIPAL       CDBBF4F2-3A62-475B-A0AB-B235496DFE7D

-- Estatus de los Bultos
-- A1DDDA80-4B1C-4F72-AA48-BF69C66B64BA	CMM_PRe_EstatusBulto	Abierto
-- 2E47CE88-247A-43B3-89D8-71928C35B8EC	CMM_PRO_EstatusBulto	PreEmbarcado
-- F742508D-9B5B-4B8E-9F43-AE5C31ADD7DF	CMM_PRO_EstatusBulto	Recibo Completo
-- EB967196-EF77-49A5-82B8-57DAC0ABD632	CMM_PRO_EstatusBulto	Recibo Parcial


Select * from Bultos Where BUL_NumeroBulto = '3617'
Select Distinct BUL_CMM_EstatusBultoId from Bultos

Select * from Bultos Where BUL_CMM_EstatusBultoId = 'F742508D-9B5B-4B8E-9F43-AE5C31ADD7DF'

Select * from Bultos Where BUL_NumeroBulto = '3889' (BUL_BultoId = 'F48DC438-49E7-43D3-A8C9-ACB5B52BAFAA')

-- Cambio de Principal al Generico
--Update Bultos Set BUL_BultoPadreId = 'F48DC438-49E7-43D3-A8C9-ACB5B52BAFAA' Where BUL_NumeroBulto = '3829'

-- Bulto Principal Original del Bulto 3829
-- Update Bultos Set BUL_BultoPadreId = 'C246F62E-CFA3-45EC-AFB6-E58BB4B9A5F5' Where BUL_NumeroBulto = '3829'


--Update Bultos set BUL_Contenido = 'COMPLEMENTO DE GR-700.1 CUSTOM MIRROR LEFT @ VANITY (HARDWIRED) 92 X 13 X 84H' Where BUL_NumeroBulto = '3829'

--Update Bultos set BUL_CMM_EstatusBultoId = '2E47CE88-247A-43B3-89D8-71928C35B8EC' Where BUL_NumeroBulto = '3829'




Select * from Bultos 
inner join BultosDetalle on BULD_BUL_BultoId = BUL_BultoId
Where BUL_NumeroBulto = '3617'

Select * from ControlesMaestrosMultiples Where CMM_Control = 'CMM_PRO_EstatusBulto'
 
 
-- Reporte de Bultos a Detalles Solicitar a Jorge (Recibo Completo).
Select   Cast(Isnull(BUL_FechaUltimaModificacion, BUL_FechaCreacion) as Date) AS FEC_MOD
        , BUL_NumeroBulto as BUL_PRINC
        , IsNull(BUL_Complemento, '0000') AS BUL_COMPL
        , ART_CodigoArticulo AS CODE
        , ART_Nombre AS DESCRIPCION
        , (select OV_CodigoOV from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId) as OV
        , (Select CLI_CodigoCliente + '  ' + CLI_RazonSocial from Clientes Where CLI_ClienteId =  (Select OV_CLI_ClienteId from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId)) AS CLIENTE        
        , (select OV_ReferenciaOC from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId) as OC
        , (Select (PRY_CodigoEvento + '  ' + PRY_NombreProyecto) from Proyectos Where PRY_ProyectoId = (Select OV_PRO_ProyectoId from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId)) as PROYECTO
        , (Select OT_Codigo from OrdenesTrabajo Where OT_OrdenTrabajoId =  BULD_OT_OrdenTrabajoId) as OT
        , BULD_Cantidad as CANTIDAD
        , BUL_X
        , BUL_Y
        , BUL_Z
        , BUL_W
        , BUL_CMM_EstatusBultoId
from Bultos
left join BultosDetalle on BULD_BUL_BultoId = BUL_BultoId
left join Articulos on BULD_ART_ArticuloId = ART_ArticuloId
Left join OrdenesTrabajoReferencia on OTRE_OT_OrdenTrabajoId = BULD_OT_OrdenTrabajoId
Where --BUL_CMM_EstatusBultoId = 'F742508D-9B5B-4B8E-9F43-AE5C31ADD7DF' and BUL_Eliminado = 0 and BUL_CMM_TipoBultoId = 'CDBBF4F2-3A62-475B-A0AB-B235496DFE7D'
--BULD_ART_ArticuloId = 'DDBB01BA-BB0C-4B0A-95EE-D20495597E4B'
BUL_NumeroBulto = '3617'

Union All
Select   Cast(Isnull(BUL_FechaUltimaModificacion, BUL_FechaCreacion) as Date) AS FEC_MOD
        , BUL_Complemento AS BUL_PRINC
        , BUL_NumeroBulto AS BUL_COMPL
        , 'N/A' AS CODE
        , BUL_Contenido AS DESCRIPCION
        , (select OV_CodigoOV from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId) as OV
        , (Select CLI_CodigoCliente + '  ' + CLI_RazonSocial from Clientes Where CLI_ClienteId =  (Select OV_CLI_ClienteId from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId)) AS CLIENTE        
        , (select OV_ReferenciaOC from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId) as OC
        , (Select (PRY_CodigoEvento + '  ' + PRY_NombreProyecto) from Proyectos Where PRY_ProyectoId = (Select OV_PRO_ProyectoId from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId)) as PROYECTO
        , (Select OT_Codigo from OrdenesTrabajo Where OT_OrdenTrabajoId =  BULD_OT_OrdenTrabajoId) as OT
        , 1   as CANTIDAD
        , BUL_X
        , BUL_Y
        , BUL_Z
        , BUL_W
from Bultos
left join BultosDetalle on BULD_BUL_BultoId = BUL_BultoPadreId
left join Articulos on BULD_ART_ArticuloId = ART_ArticuloId
Left join OrdenesTrabajoReferencia on OTRE_OT_OrdenTrabajoId = BULD_OT_OrdenTrabajoId
Where --BUL_CMM_EstatusBultoId = 'F742508D-9B5B-4B8E-9F43-AE5C31ADD7DF' and BUL_Eliminado = 0  and BUL_CMM_TipoBultoId = 'A00E0707-1CC9-4F59-8BA6-CD1DC4D82DD4'
--and 
BUL_NumeroBulto = '0141'
Order By BUL_PRINC, BUL_COMPL



Select Distinct BUL_CMM_EstatusBultoId
from Bultos
left join BultosDetalle on BULD_BUL_BultoId = BUL_BultoId
left join Articulos on BULD_ART_ArticuloId = ART_ArticuloId
Left join OrdenesTrabajoReferencia on OTRE_OT_OrdenTrabajoId = BULD_OT_OrdenTrabajoId
--Where --BUL_CMM_EstatusBultoId = 'F742508D-9B5B-4B8E-9F43-AE5C31ADD7DF' and BUL_Eliminado = 0 and BUL_CMM_TipoBultoId = 'CDBBF4F2-3A62-475B-A0AB-B235496DFE7D'
--BUL_NumeroBulto = '2700'


--Para Marcar como que esta en Almacen esperando Embarque.
--Ajuste al 06 de Agosto del 2021.
--Update Bultos set BUL_CMM_EstatusBultoId = 'F742508D-9B5B-4B8E-9F43-AE5C31ADD7DF' Where  BUL_NumeroBulto = '2572'


-- Cambiar cantidad del Bulto.
-- Solo hacerlo en bultos principales.

Select * from Articulos 
Where ART_CodigoArticulo = '1085.5-11'
ART_ArticuloId = '2A07C031-249E-4E5B-9BED-0BEC68BAAABD'


Select * from Empleados WHere EMP_EmpleadoId = '973FE41A-7BCF-4550-9957-4695BEE4BA73'


Select * from OrdenesTrabajo Where OT_OrdenTrabajoId = 'EE3CC463-5DE6-49CE-B323-DFEC361F4227'

-- Para Bultos complementos no se puede modificar cantidad asi que se modifica descripcion.
Select * from Bultos Where BUL_NumeroBulto = '2572'

--Update Bultos set BUL_Contenido = 'SILLA AVE PARAISO 27 PZ' Where BUL_NumeroBulto = '2572'

Select * from Bultos 
inner join BultosDetalle on BULD_BUL_BultoId = BUL_BultoId
Where BUL_NumeroBulto = '2690'

Select * from BultoOTRecibo Where BOR_BUL_BultoId = '69534C0E-CBA0-406E-8837-19C6E6C39A83'



Select * from BultosDetalle Where  BULD_BultoDetalleId = '2B7170C6-EBFA-4977-9C82-98B9F3BCF7EC'

--Update BultosDetalle Set BULD_Cantidad = 75 Where  BULD_BultoDetalleId = '2B7170C6-EBFA-4977-9C82-98B9F3BCF7EC'



-- Consultas para el procedimiento de Recibo de Produción
-- Tabla de Bultos.

select * 
from Bultos
left join BultosDetalle on BULD_BUL_BultoId = BUL_BultoId
Where --BUL_CMM_EstatusBultoId = 'A1DDDA80-4B1C-4F72-AA48-BF69C66B64BA'  and 
BUL_NumeroBulto = '4458'


-- Cambio de Estatus a Recibo Completo:

--Update Bultos set 
--        BUL_CMM_EstatusBultoId = 'F742508D-9B5B-4B8E-9F43-AE5C31ADD7DF' Estatus Recibo Completo
--        , BUL_FechaUltimaModificacion = '2021-07-09 11:41:06'           FechaHora de la aplicacion.
--        , BUL_EMP_ModificadoPorId = '12ECA1A3-0C27-44B8-B898-93BABCADD30F' El Id del usuario logiado
--        , BUL_ALM_AlmacenId = '0B2FFBB7-44A4-485F-A2D4-792E281591E5'    Almacen seleccionado en el recibo.
--        , BUL_LOC_LocalidadId = '62EAAF01-1020-4C75-9503-D58B07FFC6EF'  Localidad Seleccionada en el recibo
--Where BUL_CMM_EstatusBultoId = 'A1DDDA80-4B1C-4F72-AA48-BF69C66B64BA'  and BUL_BultoId = '80B45A9D-4681-474D-BF4A-659A6BCF93FF' Bulto 2732

        
-- Si el bulto es del tipo PRINCIPAL se carga BultosDetalles:
--  BUL_CMM_TipoBultoId = 'CDBBF4F2-3A62-475B-A0AB-B235496DFE7D' 
-- Si es complemento no se hace lo siguiente.

--Update BultosDetalle set 
--        BULD_FechaUltimaModificacion = '2021-07-09 11:41:06'            FechaHora de la aplicacion.
--        , BULD_EMP_ModificadoPorId = '12ECA1A3-0C27-44B8-B898-93BABCADD30F'El Id del usuario logiado
--Where BULD_BUL_BultoId = '80B45A9D-4681-474D-BF4A-659A6BCF93FF' Bulto 2732



select * from TraspasosMovtos 
Where  TRAM_TraspasoMovtoId = '182D6DF2-503A-42EA-B04A-F9C18596E408'
--Cast(TRAM_FechaTraspaso as date) = '2021/07/09'
Order By TRAM_FechaTraspaso 



-- Sacar informacion para Movimiento de Articulos.
Select   Cast(Isnull(BUL_FechaUltimaModificacion, BUL_FechaCreacion) as Date) AS FEC_MOD
        , BUL_NumeroBulto as BUL_PRINC
        , IsNull(BUL_Complemento, '0000') AS BUL_COMPL
        , ART_CodigoArticulo AS CODE
        , ART_Nombre AS DESCRIPCION
        , (select OV_CodigoOV from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId) as OV
        , (Select CLI_CodigoCliente + '  ' + CLI_RazonSocial from Clientes Where CLI_ClienteId =  (Select OV_CLI_ClienteId from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId)) AS CLIENTE        
        , (select OV_ReferenciaOC from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId) as OC
        , (Select (PRY_CodigoEvento + '  ' + PRY_NombreProyecto) from Proyectos Where PRY_ProyectoId = (Select OV_PRO_ProyectoId from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId)) as PROYECTO
        , (Select OT_Codigo from OrdenesTrabajo Where OT_OrdenTrabajoId =  BULD_OT_OrdenTrabajoId) as OT
        , BULD_Cantidad as CANTIDAD
        , BUL_CMM_EstatusBultoId
from Bultos
left join BultosDetalle on BULD_BUL_BultoId = BUL_BultoId
left join Articulos on BULD_ART_ArticuloId = ART_ArticuloId
Left join OrdenesTrabajoReferencia on OTRE_OT_OrdenTrabajoId = BULD_OT_OrdenTrabajoId
Where --BUL_CMM_EstatusBultoId = 'F742508D-9B5B-4B8E-9F43-AE5C31ADD7DF' and BUL_Eliminado = 0 and BUL_CMM_TipoBultoId = 'CDBBF4F2-3A62-475B-A0AB-B235496DFE7D'
BUL_NumeroBulto = '6644'


-- Seguimiento de Bultos del Articulos.
Select   Cast(Isnull(BUL_FechaUltimaModificacion, BUL_FechaCreacion) as Date) AS FEC_MOD
        , BUL_NumeroBulto as BUL_PRINC
        , IsNull(BUL_Complemento, '0000') AS BUL_COMPL
        , ART_CodigoArticulo AS CODE
        , ART_Nombre AS DESCRIPCION
        , (select OV_CodigoOV from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId) as OV
       -- , (Select CLI_CodigoCliente + '  ' + CLI_RazonSocial from Clientes Where CLI_ClienteId =  (Select OV_CLI_ClienteId from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId)) AS CLIENTE        
       -- , (select OV_ReferenciaOC from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId) as OC
       -- , (Select (PRY_CodigoEvento + '  ' + PRY_NombreProyecto) from Proyectos Where PRY_ProyectoId = (Select OV_PRO_ProyectoId from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId)) as PROYECTO
        , (Select OT_Codigo from OrdenesTrabajo Where OT_OrdenTrabajoId =  BULD_OT_OrdenTrabajoId) as OT
        , BULD_Cantidad as CANTIDAD
        -- , BUL_CMM_EstatusBultoId
        , (Select CMM_Control + ' -> ' + CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlID =  BUL_CMM_EstatusBultoId) AS ESTATUS
        , BUL_Eliminado AS ELIM_BULTO
        , BULD_Eliminado AS ELIM_DETALLE
        , BULD_PreEmbarcado AS EMBARCADO
from Bultos
left join BultosDetalle on BULD_BUL_BultoId = BUL_BultoId
left join Articulos on BULD_ART_ArticuloId = ART_ArticuloId
Left join OrdenesTrabajoReferencia on OTRE_OT_OrdenTrabajoId = BULD_OT_OrdenTrabajoId
Where ART_CodigoArticulo = '1082.5-23'


Select CMM_Control + ' -> ' + CMM_Valor from ControlesMaestrosMultiples 
Where CMM_ControlID = '2E47CE88-247A-43B3-89D8-71928C35B8EC'


Select  EMBB_CodigoEmbarqueBulto AS EMBARQUE
        , SUM(EMBBD_Cantidad) AS CANTIDAD
        , Cast(EMBBD_FechaCreacion as date) AS FECHA
        , EMBBD_Eliminado AS ELIMINADO
from EmbarquesBultos
Inner Join EmbarquesBultosDetalle on EMBBD_EMBB_EmbarqueBultoId = EMBB_EmbarqueBultoId
Inner Join PreembarqueBultoDetalle on EMBBD_PREBD_PreembarqueBultoDetalleId = PREBD_PreembarqueBultoDetalleId
Inner join BultosDetalle on BULD_BultoDetalleId = PREBD_BULD_BultoDetalleId
Inner join Articulos on BULD_ART_ArticuloId = ART_ArticuloId
Where ART_CodigoArticulo = '1085.5-23'
Group By EMBB_CodigoEmbarqueBulto, Cast(EMBBD_FechaCreacion as date), EMBBD_Eliminado


Select * from PreembarqueBulto
Select * from PreembarqueBultoDetalle

Select * from BultosDetalle Where BULD_BultoDetalleId = 'B4AD5511-ADFA-461E-80BE-490D52846920' 
PREBD_BULD_BultoDetalleId


-- Para Marcar como Embarcado.
-- Se ajustaron de acuerdo al Correo que Envio Sharom 05 de Agosto del 2021
--Update Bultos set BUL_CMM_EstatusBultoId = '2E47CE88-247A-43B3-89D8-71928C35B8EC' Where  BUL_NumeroBulto = '2887'

Select BUL_NumeroBulto, BUL_CMM_EstatusBultoId, * From Bultos Where BUL_NumeroBulto = '2693'

Update Bultos set BUL_CMM_EstatusBultoId = '2E47CE88-247A-43B3-89D8-71928C35B8EC' Where  BUL_NumeroBulto = '2914'

-- 210927: Solictito Cancelación Jazzmin, por error de cantidad.
-- Marque como Embarcado y puse eliminado como verdadero.
-- Creo que no era cancelar asi, regreso a Abierta y Eliminada Falso
-- los bultos 4101, 4102, 4103, 4104, 4105, 4106, 4107 y 4108.

Update Bultos set BUL_CMM_EstatusBultoId = 'A1DDDA80-4B1C-4F72-AA48-BF69C66B64BA', BUL_Eliminado = 0 Where  BUL_NumeroBulto = '4101'


select * 
from Bultos
--left join BultosDetalle on BULD_BUL_BultoId = BUL_BultoId
Where --BUL_CMM_EstatusBultoId = 'A1DDDA80-4B1C-4F72-AA48-BF69C66B64BA'  and 
BUL_NumeroBulto = '6644'



-- 220824 Presentar informacion de almacen del Bulto.
Select  (Select ALM_CodigoAlmacen + '  ' + ALM_Nombre from Almacenes Where ALM_AlmacenId = BUL_ALM_AlmacenId) AS ALMACEN
        , (Select LOC_CodigoLocalidad + '  ' + LOC_Nombre  from Localidades Where LOC_LocalidadId = BUL_LOC_LocalidadId) AS LOCALIDAD
        , Cast(Isnull(BUL_FechaUltimaModificacion, BUL_FechaCreacion) as Date) AS FEC_MOD
        , BUL_NumeroBulto as BUL_PRINC
        , IsNull(BUL_Complemento, '0000') AS BUL_COMPL
        , ART_CodigoArticulo AS CODE
        , ART_Nombre AS DESCRIPCION
        , (select OV_CodigoOV from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId) as OV
        , (Select CLI_CodigoCliente + '  ' + CLI_RazonSocial from Clientes Where CLI_ClienteId =  (Select OV_CLI_ClienteId from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId)) AS CLIENTE        
        , (select OV_ReferenciaOC from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId) as OC
        , (Select (PRY_CodigoEvento + '  ' + PRY_NombreProyecto) from Proyectos Where PRY_ProyectoId = (Select OV_PRO_ProyectoId from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId)) as PROYECTO
        , (Select OT_Codigo from OrdenesTrabajo Where OT_OrdenTrabajoId =  BULD_OT_OrdenTrabajoId) as OT
        , BULD_Cantidad as CANTIDAD
        , BUL_CMM_EstatusBultoId
from Bultos
left join BultosDetalle on BULD_BUL_BultoId = BUL_BultoId
left join Articulos on BULD_ART_ArticuloId = ART_ArticuloId
Left join OrdenesTrabajoReferencia on OTRE_OT_OrdenTrabajoId = BULD_OT_OrdenTrabajoId
Where --BUL_CMM_EstatusBultoId = 'F742508D-9B5B-4B8E-9F43-AE5C31ADD7DF' and BUL_Eliminado = 0 and BUL_CMM_TipoBultoId = 'CDBBF4F2-3A62-475B-A0AB-B235496DFE7D'
BUL_NumeroBulto = '3617' -- or BUL_NumeroBulto = '6645' 

Select ALM_CodigoAlmacen + '  ' + ALM_Nombre, * from Almacenes Where ALM_Eliminado = 0 Order By ALM_Nombre
Select LOC_CodigoLocalidad + '  ' + LOC_Nombre, * from Localidades Where LOC_Eliminado = 0 Order By LOC_Nombre

-- 220831-A Reporte de Bultos contra Almacen de Articulos.
-- Bultos Principales.

Select  (Select ALM_CodigoAlmacen + '  ' + ALM_Nombre from Almacenes Where ALM_AlmacenId = BUL_ALM_AlmacenId) AS ALMACEN
        , (Select LOC_CodigoLocalidad + '  ' + LOC_Nombre  from Localidades Where LOC_LocalidadId = BUL_LOC_LocalidadId) AS LOCALIDAD
        , Cast(Isnull(BUL_FechaUltimaModificacion, BUL_FechaCreacion) as Date) AS FEC_MOD
        , BUL_NumeroBulto as BULTO
        , ART_CodigoArticulo AS CODE
        , ART_Nombre AS DESCRIPCION
        , (select OV_CodigoOV from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId) as OV
        , (Select CLI_CodigoCliente + '  ' + CLI_RazonSocial from Clientes Where CLI_ClienteId =  (Select OV_CLI_ClienteId from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId)) AS CLIENTE        
        , (select OV_ReferenciaOC from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId) as OC
        , (Select (PRY_CodigoEvento + '  ' + PRY_NombreProyecto) from Proyectos Where PRY_ProyectoId = (Select OV_PRO_ProyectoId from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId)) as PROYECTO
        , (Select OT_Codigo from OrdenesTrabajo Where OT_OrdenTrabajoId =  BULD_OT_OrdenTrabajoId) as OT
        , BULD_Cantidad as CANTIDAD
        , (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId =  BUL_CMM_EstatusBultoId) AS ESTATUS
        , (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId =  BUL_CMM_TipoBultoId) AS TIPO_BUL
        , (Select SUM(TRAM_CantidadATraspasar) From TraspasosMovtos Where  TRAM_ART_ArticuloId = ART_ArticuloId) AS INVENT
        , PREBD_Embarcado AS EMBARCADO
from Bultos
left join BultosDetalle on BULD_BUL_BultoId = BUL_BultoId
left join PreembarqueBultoDetalle on PREBD_BULD_BultoDetalleId = BULD_BultoDetalleId
left join Articulos on BULD_ART_ArticuloId = ART_ArticuloId
Left join OrdenesTrabajoReferencia on OTRE_OT_OrdenTrabajoId = BULD_OT_OrdenTrabajoId
Where BUL_NumeroBulto = '8230' or BUL_NumeroBulto = '3617' or BUL_NumeroBulto = '8233' 
or BUL_NumeroBulto = '8248' or BUL_NumeroBulto = '8249' or BUL_NumeroBulto = '8335' or BUL_NumeroBulto = '8333' 
Order By LOCALIDAD, DESCRIPCION

-- Informacion de Bultos complementos

Select   (Select ALM_CodigoAlmacen + '  ' + ALM_Nombre from Almacenes Where ALM_AlmacenId = BUL_ALM_AlmacenId) AS ALMACEN
        , (Select LOC_CodigoLocalidad + '  ' + LOC_Nombre  from Localidades Where LOC_LocalidadId = BUL_LOC_LocalidadId) AS LOCALIDAD
        , Cast(Isnull(BUL_FechaUltimaModificacion, BUL_FechaCreacion) as Date) AS FEC_MOD
        , BUL_Complemento AS BUL_PRINC
        , BUL_NumeroBulto AS BUL_COMPL
        , 'N/A' AS CODE
        , BUL_Contenido AS DESCRIPCION
        , (select OV_CodigoOV from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId) as OV
        , (Select CLI_CodigoCliente + '  ' + CLI_RazonSocial from Clientes Where CLI_ClienteId =  (Select OV_CLI_ClienteId from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId)) AS CLIENTE        
        , (select OV_ReferenciaOC from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId) as OC
        , (Select (PRY_CodigoEvento + '  ' + PRY_NombreProyecto) from Proyectos Where PRY_ProyectoId = (Select OV_PRO_ProyectoId from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId)) as PROYECTO
        , (Select OT_Codigo from OrdenesTrabajo Where OT_OrdenTrabajoId =  BULD_OT_OrdenTrabajoId) as OT
        , 1   as CANTIDAD
        , (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId =  BUL_CMM_EstatusBultoId) AS ESTATUS
        , (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId =  BUL_CMM_TipoBultoId) AS TIPO_BUL
        , 0 AS INVENT
from Bultos
left join BultosDetalle on BULD_BUL_BultoId = BUL_BultoPadreId
left join Articulos on BULD_ART_ArticuloId = ART_ArticuloId
Left join OrdenesTrabajoReferencia on OTRE_OT_OrdenTrabajoId = BULD_OT_OrdenTrabajoId
Where BUL_CMM_EstatusBultoId = 'F742508D-9B5B-4B8E-9F43-AE5C31ADD7DF' and BUL_Eliminado = 0  and BUL_CMM_TipoBultoId = 'A00E0707-1CC9-4F59-8BA6-CD1DC4D82DD4'
--and BUL_NumeroBulto = '0141'


-- Update para cambiar de localidad un Bulto, Pasamos a Vallarta
select * from Bultos Where BUL_NumeroBulto = '6644'

Almacen de Vallarta = 'DCC5A0E6-3FA4-4C23-B48E-A120D5B2F6B8'
Localidad de Vallarta '8DCEC3E4-B9C1-4014-9643-5B777473576C'

Update Bultos Set BUL_ALM_AlmacenId = 'DCC5A0E6-3FA4-4C23-B48E-A120D5B2F6B8', BUL_LOC_LocalidadId = '8DCEC3E4-B9C1-4014-9643-5B777473576C' Where BUL_NumeroBulto = '6868'


-- Update para dejar como Embarcados los Bultos. Solo es cambiar el Estatus a Pre-Embarcado
-- Ya que la bandera es en el PreEmbarque y seguro que no va a existir checar???


Select * 
from Bultos
inner join BultosDetalle on BULD_BUL_BultoId = BUL_BultoId
Inner join PreembarqueBultoDetalle on PREBD_BULD_BultoDetalleId = BULD_BultoDetalleId
Where BUL_NumeroBulto = '8230' or BUL_NumeroBulto = '3617' or BUL_NumeroBulto = '8233' 
or BUL_NumeroBulto = '8248' or BUL_NumeroBulto = '8249' or BUL_NumeroBulto = '8335' or BUL_NumeroBulto = '8333' 

-- Estatus de los Bultos
-- A1DDDA80-4B1C-4F72-AA48-BF69C66B64BA	CMM_PRe_EstatusBulto	Abierto
-- 2E47CE88-247A-43B3-89D8-71928C35B8EC	CMM_PRO_EstatusBulto	PreEmbarcado
-- F742508D-9B5B-4B8E-9F43-AE5C31ADD7DF	CMM_PRO_EstatusBulto	Recibo Completo
-- EB967196-EF77-49A5-82B8-57DAC0ABD632	CMM_PRO_EstatusBulto	Recibo Parcial

-- Auditar que los Bultos no esten cargados a un Pre-Embarque
-- Los que estan cargados a un Pre-Embarque y traen estatus de Recibo Completo
-- Cambiar Estatus a Pre-Embarque.

Select BUL_NumeroBulto AS NUM_BULTO
        , (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId = BUL_CMM_TipoBultoId) AS TIPO_BULTO
        , BUL_Eliminado AS ELIMINADO
        , (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId = BUL_CMM_EstatusBultoId) AS ESTATUS_BULTO
        , BULD_PreEmbarcado AS EMBARCADO
        , PREBD_Eliminado AS BORRADO
        --, * 
from Bultos 
inner join BultosDetalle on BULD_BUL_BultoId = BUL_BultoId 
Inner join PreembarqueBultoDetalle on PREBD_BULD_BultoDetalleId = BULD_BultoDetalleId 
Where BUL_CMM_EstatusBultoId = 'F742508D-9B5B-4B8E-9F43-AE5C31ADD7DF' and BULD_PreEmbarcado = 1 AND PREBD_Eliminado = 0

Update Bultos Set BUL_CMM_EstatusBultoId = '2E47CE88-247A-43B3-89D8-71928C35B8EC' Where BUL_NumeroBulto = '2712'

Select * from Bultos inner join BultosDetalle on BULD_BUL_BultoId = BUL_BultoId Inner join PreembarqueBultoDetalle on PREBD_BULD_BultoDetalleId = BULD_BultoDetalleId Where BUL_NumeroBulto = '6190'

Select * from Bultos 
Where  BUL_NumeroBulto = '8159' or BUL_NumeroBulto = '8157' 

Select * from Bultos 
Where BUL_BultoId = '84FD462A-62A7-40A7-B36C-7830FB0BAAD3'


-- Buscar Bultos por un codigo de articulo
Select  (Select ALM_CodigoAlmacen + '  ' + ALM_Nombre from Almacenes Where ALM_AlmacenId = BUL_ALM_AlmacenId) AS ALMACEN
        , (Select LOC_CodigoLocalidad + '  ' + LOC_Nombre  from Localidades Where LOC_LocalidadId = BUL_LOC_LocalidadId) AS LOCALIDAD
        , Cast(Isnull(BUL_FechaUltimaModificacion, BUL_FechaCreacion) as Date) AS FEC_MOD
        , BUL_NumeroBulto as BULTO
        , ART_CodigoArticulo AS CODE
        , ART_Nombre AS DESCRIPCION
        , (select OV_CodigoOV from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId) as OV
        , (Select CLI_CodigoCliente + '  ' + CLI_RazonSocial from Clientes Where CLI_ClienteId =  (Select OV_CLI_ClienteId from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId)) AS CLIENTE        
        , (select OV_ReferenciaOC from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId) as OC
        , (Select (PRY_CodigoEvento + '  ' + PRY_NombreProyecto) from Proyectos Where PRY_ProyectoId = (Select OV_PRO_ProyectoId from OrdenesVenta Where OV_OrdenVentaId = OTRE_OV_OrdenVentaId)) as PROYECTO
        , (Select OT_Codigo from OrdenesTrabajo Where OT_OrdenTrabajoId =  BULD_OT_OrdenTrabajoId) as OT
        , BULD_Cantidad as CANTIDAD
        , (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId =  BUL_CMM_EstatusBultoId) AS ESTATUS
        , (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId =  BUL_CMM_TipoBultoId) AS TIPO_BUL
        , (Select SUM(TRAM_CantidadATraspasar) From TraspasosMovtos Where  TRAM_ART_ArticuloId = ART_ArticuloId) AS INVENT
        , PREBD_Embarcado AS EMBARCADO
from Bultos
left join BultosDetalle on BULD_BUL_BultoId = BUL_BultoId
left join PreembarqueBultoDetalle on PREBD_BULD_BultoDetalleId = BULD_BultoDetalleId
left join Articulos on BULD_ART_ArticuloId = ART_ArticuloId
Left join OrdenesTrabajoReferencia on OTRE_OT_OrdenTrabajoId = BULD_OT_OrdenTrabajoId
--Where ART_CodigoArticulo = '1731.1-09'
--Where BUL_NumeroBulto = '8159' --or BUL_NumeroBulto = '9210'
Where BUL_NumeroBulto = '8156' or BUL_NumeroBulto = '8159' or BUL_NumeroBulto = '8157' 
Order By LOCALIDAD, DESCRIPCION


--identificar estatus de bultos y sus tablas iteknia
-- Envio Jorge el 220921 en el grupo.

--PARA SABER QUE EL BULTO ESTA RECIBIDO bultos
Select (Select ALM_CodigoAlmacen + '  ' + ALM_Nombre from Almacenes Where ALM_AlmacenId = BUL_ALM_AlmacenId) AS ALMACEN
        , (Select LOC_CodigoLocalidad + '  ' + LOC_Nombre  from Localidades Where LOC_LocalidadId = BUL_LOC_LocalidadId) AS LOCALIDAD
        , Cast(Isnull(BUL_FechaUltimaModificacion, BUL_FechaCreacion) as Date) AS FEC_MOD
        , BUL_NumeroBulto as BULTO
        , ART_CodigoArticulo AS CODE
        , ART_Nombre AS DESCRIPCION
        , (Select OT_Codigo from OrdenesTrabajo Where OT_OrdenTrabajoId =  BULD_OT_OrdenTrabajoId) as OT
        , BULD_Cantidad as CANTIDAD
        , (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId =  BUL_CMM_EstatusBultoId) AS ESTATUS
        , (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId =  BUL_CMM_TipoBultoId) AS TIPO_BUL
        , (Select SUM(TRAM_CantidadATraspasar) From TraspasosMovtos Where  TRAM_ART_ArticuloId = ART_ArticuloId) AS INVENT
from Bultos
left join BultosDetalle on BULD_BUL_BultoId = BUL_BultoId
left join Articulos on BULD_ART_ArticuloId = ART_ArticuloId
WHERE BUL_CMM_EstatusBultoId = 'F742508D-9B5B-4B8E-9F43-AE5C31ADD7DF' and BUL_Eliminado = 0
Order By BUL_NumeroBulto, ART_Nombre



--PARA SABER QUE EL BULTO ESTA RECIBIDO estatus bultos complemento
Select (Select ALM_CodigoAlmacen + '  ' + ALM_Nombre from Almacenes Where ALM_AlmacenId = BUL_ALM_AlmacenId) AS ALMACEN
        , (Select LOC_CodigoLocalidad + '  ' + LOC_Nombre  from Localidades Where LOC_LocalidadId = BUL_LOC_LocalidadId) AS LOCALIDAD
        , Cast(Isnull(BUL_FechaUltimaModificacion, BUL_FechaCreacion) as Date) AS FEC_MOD
        , BUL_NumeroBulto as BULTO
        , ART_CodigoArticulo AS CODE
        , ART_Nombre AS DESCRIPCION
        , (Select OT_Codigo from OrdenesTrabajo Where OT_OrdenTrabajoId =  BULD_OT_OrdenTrabajoId) as OT
        , BULD_Cantidad as CANTIDAD
        , (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId =  BUL_CMM_EstatusBultoId) AS ESTATUS
        , (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId =  BUL_CMM_TipoBultoId) AS TIPO_BUL
        , (Select SUM(TRAM_CantidadATraspasar) From TraspasosMovtos Where  TRAM_ART_ArticuloId = ART_ArticuloId) AS INVENT
from Bultos
left join BultosDetalle on BULD_BUL_BultoId = BUL_BultoPadreId
left join Articulos on BULD_ART_ArticuloId = ART_ArticuloId
Where BUL_CMM_EstatusBultoId = 'F742508D-9B5B-4B8E-9F43-AE5C31ADD7DF' and BUL_Eliminado = 0  and BUL_CMM_TipoBultoId = 'A00E0707-1CC9-4F59-8BA6-CD1DC4D82DD4'

--PARA SABER QUE EL BULTO ESTA RECIBIDO Y SE CONSIDERE EXISTENTE EN ALMACEN NO TIENE QUE ESTAR PRE-EMBARCADO 
Select (Select ALM_CodigoAlmacen + '  ' + ALM_Nombre from Almacenes Where ALM_AlmacenId = BUL_ALM_AlmacenId) AS ALMACEN
        , (Select LOC_CodigoLocalidad + '  ' + LOC_Nombre  from Localidades Where LOC_LocalidadId = BUL_LOC_LocalidadId) AS LOCALIDAD
        , Cast(Isnull(BUL_FechaUltimaModificacion, BUL_FechaCreacion) as Date) AS FEC_MOD
        , BUL_NumeroBulto as BULTO
        , ART_CodigoArticulo AS CODE
        , ART_Nombre AS DESCRIPCION
        , (Select OT_Codigo from OrdenesTrabajo Where OT_OrdenTrabajoId =  BULD_OT_OrdenTrabajoId) as OT
        , BULD_Cantidad as CANTIDAD
        , (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId =  BUL_CMM_EstatusBultoId) AS ESTATUS
        , (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId =  BUL_CMM_TipoBultoId) AS TIPO_BUL
        , (Select SUM(TRAM_CantidadATraspasar) From TraspasosMovtos Where  TRAM_ART_ArticuloId = ART_ArticuloId) AS INVENT
from Bultos
left join BultosDetalle on BULD_BUL_BultoId = BUL_BultoPadreId
left join Articulos on BULD_ART_ArticuloId = ART_ArticuloId
LEFT JOIN PreembarqueBultoDetalle ON BULD_BultoDetalleId = PREBD_BULD_BultoDetalleId AND PREBD_Eliminado = 0
WHERE BUL_CMM_EstatusBultoId = 'F742508D-9B5B-4B8E-9F43-AE5C31ADD7DF' and BUL_Eliminado = 0 AND ISNULL(PREBD_Embarcado, 0) = 0

--PARA SABER SI ESTA PREEMBARCADO
Select (Select ALM_CodigoAlmacen + '  ' + ALM_Nombre from Almacenes Where ALM_AlmacenId = BUL_ALM_AlmacenId) AS ALMACEN
        , (Select LOC_CodigoLocalidad + '  ' + LOC_Nombre  from Localidades Where LOC_LocalidadId = BUL_LOC_LocalidadId) AS LOCALIDAD
        , Cast(Isnull(BUL_FechaUltimaModificacion, BUL_FechaCreacion) as Date) AS FEC_MOD
        , BUL_NumeroBulto as BULTO
        , ART_CodigoArticulo AS CODE
        , ART_Nombre AS DESCRIPCION
        , (Select OT_Codigo from OrdenesTrabajo Where OT_OrdenTrabajoId =  BULD_OT_OrdenTrabajoId) as OT
        , BULD_Cantidad as CANTIDAD
        , (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId =  BUL_CMM_EstatusBultoId) AS ESTATUS
        , (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId =  BUL_CMM_TipoBultoId) AS TIPO_BUL
        , (Select SUM(TRAM_CantidadATraspasar) From TraspasosMovtos Where  TRAM_ART_ArticuloId = ART_ArticuloId) AS INVENT
from Bultos
left join BultosDetalle on BULD_BUL_BultoId = BUL_BultoPadreId
left join Articulos on BULD_ART_ArticuloId = ART_ArticuloId
LEFT JOIN PreembarqueBultoDetalle ON BULD_BultoDetalleId = PREBD_BULD_BultoDetalleId AND PREBD_Eliminado = 0
WHERE ISNULL(PREBD_Embarcado, 0) = 1

--PARA SABER SI ESTA EMBARCADO
 
Select (Select ALM_CodigoAlmacen + '  ' + ALM_Nombre from Almacenes Where ALM_AlmacenId = BUL_ALM_AlmacenId) AS ALMACEN
        , (Select LOC_CodigoLocalidad + '  ' + LOC_Nombre  from Localidades Where LOC_LocalidadId = BUL_LOC_LocalidadId) AS LOCALIDAD
        , Cast(Isnull(BUL_FechaUltimaModificacion, BUL_FechaCreacion) as Date) AS FEC_MOD
        , BUL_NumeroBulto as BULTO
        , ART_CodigoArticulo AS CODE
        , ART_Nombre AS DESCRIPCION
        , (Select OT_Codigo from OrdenesTrabajo Where OT_OrdenTrabajoId =  BULD_OT_OrdenTrabajoId) as OT
        , BULD_Cantidad as CANTIDAD
        , (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId =  BUL_CMM_EstatusBultoId) AS ESTATUS
        , (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId =  BUL_CMM_TipoBultoId) AS TIPO_BUL
        , (Select SUM(TRAM_CantidadATraspasar) From TraspasosMovtos Where  TRAM_ART_ArticuloId = ART_ArticuloId) AS INVENT
from PreembarqueBulto
INNER JOIN PreembarqueBultoDetalle ON PREBD_PREB_PreembarqueBultoId = PREB_PreembarqueBultoId AND PREBD_Eliminado = 0
INNER JOIN BultosDetalle ON BULD_BultoDetalleId = PREBD_BULD_BultoDetalleId
INNER JOIN Bultos ON BUL_BultoId = BULD_BUL_BultoId
left join Articulos on BULD_ART_ArticuloId = ART_ArticuloId
WHERE ISNULL(PREBD_Embarcado, 0) = 1


--para saber en que embarque se genero esta el reporte embaruqes bultos
Select (Select ALM_CodigoAlmacen + '  ' + ALM_Nombre from Almacenes Where ALM_AlmacenId = BUL_ALM_AlmacenId) AS ALMACEN
        , (Select LOC_CodigoLocalidad + '  ' + LOC_Nombre  from Localidades Where LOC_LocalidadId = BUL_LOC_LocalidadId) AS LOCALIDAD
        , Cast(Isnull(BUL_FechaUltimaModificacion, BUL_FechaCreacion) as Date) AS FEC_MOD
        , BUL_NumeroBulto as BULTO
        , ART_CodigoArticulo AS CODE
        , ART_Nombre AS DESCRIPCION
        , (Select OT_Codigo from OrdenesTrabajo Where OT_OrdenTrabajoId =  BULD_OT_OrdenTrabajoId) as OT
        , BULD_Cantidad as CANTIDAD
        , (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId =  BUL_CMM_EstatusBultoId) AS ESTATUS
        , (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId =  BUL_CMM_TipoBultoId) AS TIPO_BUL
        , (Select SUM(TRAM_CantidadATraspasar) From TraspasosMovtos Where  TRAM_ART_ArticuloId = ART_ArticuloId) AS INVENT
        , EmbarquesBultos.EMBB_CodigoEmbarqueBulto AS EMBARQUE
FROM EmbarquesBultos
INNER JOIN EmbarquesBultosDetalle ON  EMBB_EmbarqueBultoId = EMBBD_EMBB_EmbarqueBultoId AND EMBBD_Eliminado = 0
INNER JOIN TraspasosMovtos ON EMBBD_EmbarqueBultoDetalleId = TRAM_ReferenciaMovtoId
LEFT JOIN Articulos ON ART_ArticuloId = TRAM_ART_ArticuloId
INNER JOIN PreembarqueBultoDetalle ON EMBBD_PREBD_PreembarqueBultoDetalleId = PREBD_PreembarqueBultoDetalleId
INNER JOIN PreembarqueBulto ON PREBD_PREB_PreembarqueBultoId = PREB_PreembarqueBultoId AND PREBD_Eliminado = 0
INNER JOIN BultosDetalle ON BULD_BultoDetalleId = PREBD_BULD_BultoDetalleId
INNER JOIN Bultos ON BUL_BultoId = BULD_BUL_BultoId
WHERE TRAM_CMM_TipoTransferenciaId = 'FB9DD40D-14AB-4AD4-AB2E-AD887C80FDE3'
AND EMBB_Eliminado = 0
AND EMBB_FechaCreacion between '20220901 00:00:00' and '20220921 23:59:59'
order by EMBB_CodigoEmbarqueBulto, ART_CodigoArticulo


--Cosnulta que envio Juan para validar el Bulto Embarcado

SELECT BUL_NumeroBulto, PREB_CodigoPreembarqueBulto, PREB_FechaCreacion, PREBD_Embarcado, EMBB_CodigoEmbarqueBulto, EMBB_FechaCreacion, EMBBD_Cantidad
FROM PreembarqueBulto
INNER JOIN PreembarqueBultoDetalle ON PREB_PreembarqueBultoId = PREBD_PREB_PreembarqueBultoId AND PREBD_Eliminado = 0
INNER JOIN Bultos ON PREBD_BUL_BultoId = BUL_BultoId
LEFT  JOIN (
			SELECT EMBB_CodigoEmbarqueBulto, EMBBD_PREBD_PreembarqueBultoDetalleId, EMBBD_Cantidad, EMBB_FechaCreacion
			FROM EmbarquesBultos 
			INNER JOIN EmbarquesBultosDetalle ON EMBB_EmbarqueBultoId = EMBBD_EMBB_EmbarqueBultoId AND EMBBD_Eliminado = 0
			WHERE EMBB_Eliminado = 0
			) AS EmbarquesBultos ON PREBD_PreembarqueBultoDetalleId = EMBBD_PREBD_PreembarqueBultoDetalleId
WHERE PREB_Eliminado = 0
      AND BUL_NumeroBulto = '8305'




