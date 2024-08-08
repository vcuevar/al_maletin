-- Reporte de Excepciones
-- ITEKNIA EQUIPAMIENTO, S.A. de C.V.
-- Desarrollo: Ing. Vicente Cueva Ramírez
-- Actualizado: 07 de Enero del 2022; Origen.

--Validar Usuario Vigentes y con Empleado NO ACTIVO, Actividad Dar de Baja Como Usuario.
--Se cargo a las Alertas.
/*
select EMP_CodigoEmpleado AS CODIGO
        , EMP_Nombre + '  ' + EMP_PrimerApellido + '  ' + EMP_SegundoApellido AS NOMBRE
        , Case When EMP_Activo = 1 then 'ACTIVO' else 'DAR DE BAJA' end AS ACTIVO
        , PER_CodigoPermiso AS COD_PERMISO	
        , PER_TipoPermiso AS TIPO_PERMISO
from Usuarios
Inner Join Empleados on EMP_EmpleadoId = USU_EMP_EmpleadoId
Inner Join Permisos on PER_PermisoId = USU_PER_PermisoId
where USU_Activo = 1 and EMP_Activo = 0
--Where EMP_CodigoEmpleado = '788'
*/

--Validar Usuario Inactivo sin fecha de Baja. (VEN EN MULIIX CREO FUERON BORRADOS PARA PONER FECHA BAJA IGUAL A FECHA ALTA)
-- Se cargo a las Alertas el 05 de Junio del 2024.
/*
 select '002 SIN FECHA BAJA' AS REPORTE
        , EMP_EmpleadoId AS ID
        , EMP_CodigoEmpleado AS CODIGO
        , EMP_Nombre + '  ' + EMP_PrimerApellido + '  ' + EMP_SegundoApellido AS NOMBRE
        , Case When EMP_Activo = 1 then 'ACTIVO' else 'DAR DE BAJA' end AS ACTIVO
        , Cast(EMP_FechaIngreso as date) AS FECH_ING
        , Cast(EMP_FechaEgreso as date) AS FECH_BAJA
        --, USU_Contrasenia AS CONTRASEÑA
        --, PER_CodigoPermiso AS COD_PERMISO	
        --, PER_TipoPermiso AS TIPO_PERMISO
        -- , *
from Empleados
--Inner Join Empleados on EMP_EmpleadoId = USU_EMP_EmpleadoId
--Inner Join Permisos on PER_PermisoId = USU_PER_PermisoId
--where EMP_CodigoEmpleado = '759' 
Where EMP_Activo = 0 and EMP_FechaEgreso is null



select '002 SIN FECHA BAJA' AS REPORTE
        , EMP_CodigoEmpleado AS CODIGO
        , EMP_Nombre + '  ' + EMP_PrimerApellido + '  ' + EMP_SegundoApellido AS NOMBRE
        , Case When EMP_Activo = 1 then 'ACTIVO' else 'DAR DE BAJA' end AS ACTIVO
        , Cast(EMP_FechaIngreso as date) AS FECH_ING
        , Cast(EMP_FechaEgreso as date) AS FECH_BAJA
from Empleados
Where EMP_Activo = 0 and EMP_FechaEgreso is null
*/


/*
Excepcion del 9 de Marzo del 2023. Solicite informacion a Jaq/Este.
Update Empleados Set EMP_FechaEgreso = Cast('2021-01-01' as date) Where EMP_EmpleadoId = 'C2DE42C9-9863-4B93-9A03-3B45F4BF6F79'

select * from empleados where EMP_CodigoEmpleado = '002'
select * from empleados where EMP_EmpleadoId = '3A2D4A67-BB29-493B-BFB1-3A1A03310372' --Este es el 0001 y el 002 es el 75
select * from usuarios where USU_EMP_EmpleadoId = '8EDFC690-978A-4112-B61C-1999CD0C71F5'
select * from usuarios where USU_Nombre = '002'
update Usuarios set USU_EMP_EmpleadoId = '8EDFC690-978A-4112-B61C-1999CD0C71F5' where USU_Nombre = '002'

select * from empleados where EMP_CodigoEmpleado = '1006'
Update Empleados Set EMP_FechaEgreso = Cast('2021-01-01' as date) Where EMP_EmpleadoId = 'AF1CC802-F0EE-4D32-8971-D6B5AA5D906F'


*/

-- Determinar Materiales que no tienen tiempo de Entrega y se concideran para M&M

Select	'SIN TIEMPO DE ABAST' AS REPORTE_030
		, ART_CodigoArticulo as CODIGO
        , ART_Nombre as NOMBRE
        , Convert(Decimal(28,2), ART_NoDiasAbastecimiento) AS DIA_ABS  
        , Convert(Decimal(28,2), ART_CantMinimaOrden) AS MINIMO
        , Convert(Decimal(28,2), ART_CantMaximaOrden) AS MAXIMO
from Articulos
Where ART_Activo = 1 and ART_CantMaximaOrden > 0.01 and ART_NoDiasAbastecimiento = 0

--and (ART_NoDiasAbastecimiento = 0 or ART_NoDiasAbastecimiento is null)
--and (ART_CantMaximaOrden > 0 or ART_CantMaximaOrden is not null)

-- Para Bateria de Excepciones de MULIIX
-- Validar y ver que funcion tienen estas dos 

--Los Articulos en factor de conversion no deben ser cero, en caso que se de dejar en 1 

-- select * from Articulos

select * from ArticulosFactoresConversion
where AFC_FactorConversion IS NULL


--update ArticulosFactoresConversion set AFC_FactorConversion = 1 Where AFC_FactorConversion = 0

Select * from OrdenesCompraDetalle where OCD_AFC_FactorConversion = 0


-- Validar que todos los Eliminados tengan estatus de Cerradas por usuario.
-- Posiblemente agregar Empaque completo.
select 'ELIMINADO -> CERRADA POR USUA'
		, OV_CodigoOV  AS OV_OrdenVentaId 
		, OV_FechaOV  AS FECHA_OV
		, OV_Comentarios AS NOTAS
from OrdenesVenta 
Where OV_Eliminado = 1 and 
OV_CMM_EstadoOVId <> '2209C8BF-8259-4D8C-A0E9-389F52B33B46'


-- Para corregir asignar este cambio.
--update OrdenesVenta set OV_CMM_EstadoOVId = '2209C8BF-8259-4D8C-A0E9-389F52B33B46' Where OV_Eliminado = 1 and  OV_CMM_EstadoOVId <> '2209C8BF-8259-4D8C-A0E9-389F52B33B46'


-- Validar que NO haya Dolar a 1

Select*
From OrdenesVenta where OV_MON_MonedaId ='1EA50C6D-AD92-4DE6-A562-F155D0D516D3'and OV_MONP_Paridad = 1
and OV_CodigoOV >'OV00887'
Order By OV_CodigoOV

--Update OrdenesVenta Set OV_MONP_Paridad = 17.238 Where OV_CodigoOV = 'OV01340'

--identificar estatus de bultos y sus tablas iteknia
-- Para hacer la validacion de las existencias contra los bultos
--PARA SABER QUE EL BULTO ESTA RECIBIDO bultos
-- Pendiente 230420 se termine de hacer movimientos de bultos para generar la relacion.

--Select *
--from Bultos
--left join BultosDetalle on BULD_BUL_BultoId = BUL_BultoId
--WHERE BUL_NumeroBulto  = '430'
 
--BUL_CMM_EstatusBultoId = 'F742508D-9B5B-4B8E-9F43-AE5C31ADD7DF' and BUL_Eliminado = 0



--PARA SABER QUE EL BULTO ESTA RECIBIDO estatus bultos complemento
--Select *
--from Bultos
--left join BultosDetalle on BULD_BUL_BultoId = BUL_BultoPadreId
--Where BUL_CMM_EstatusBultoId = 'F742508D-9B5B-4B8E-9F43-AE5C31ADD7DF' and BUL_Eliminado = 0  and BUL_CMM_TipoBultoId = 'A00E0707-1CC9-4F59-8BA6-CD1DC4D82DD4'

--PARA SABER QUE EL BULTO ESTA RECIBIDO Y SE CONSIDERE EXISTENTE EN ALMACEN NO TIENE QUE ESTAR PRE-EMBARCADO 
--Select *
--From Bu
--WHERE BUL_CMM_EstatusBultoId = 'F742508D-9B5B-4B8E-9F43-AE5C31ADD7DF' and BUL_Eliminado = 0 AND ISNULL(PREBD_Embarcado, 0) = 0



--PARA SABER SI ESTA PREEMBARCADO

--Select *
--from Bultos
--left join BultosDetalle on BULD_BUL_BultoId = BUL_BultoPadreId
--LEFT JOIN PreembarqueBultoDetalle ON BULD_BultoDetalleId = PREBD_BULD_BultoDetalleId AND PREBD_Eliminado = 0
--WHERE ISNULL(PREBD_Embarcado, 0) = 1


--PARA SABER SI ESTA EMBARCADO

--select * from PreembarqueBulto
--INNER JOIN PreembarqueBultoDetalle ON PREBD_PREB_PreembarqueBultoId = PREB_PreembarqueBultoId AND PREBD_Eliminado = 0
--INNER JOIN BultosDetalle ON BULD_BultoDetalleId = PREBD_BULD_BultoDetalleId
--INNER JOIN Bultos ON BUL_BultoId = BULD_BUL_BultoId
--WHERE ISNULL(PREBD_Embarcado, 0) = 1


--para saber en que embarque se genero esta el reporte embaruqes bultos
--Select *
--FROM EmbarquesBultos
--INNER JOIN EmbarquesBultosDetalle ON  EMBB_EmbarqueBultoId = EMBBD_EMBB_EmbarqueBultoId AND EMBBD_Eliminado = 0
--INNER JOIN TraspasosMovtos ON EMBBD_EmbarqueBultoDetalleId = TRAM_ReferenciaMovtoId
--LEFT JOIN Articulos ON ART_ArticuloId = TRAM_ART_ArticuloId
--INNER JOIN PreembarqueBultoDetalle ON EMBBD_PREBD_PreembarqueBultoDetalleId = PREBD_PreembarqueBultoDetalleId
--INNER JOIN PreembarqueBulto ON PREBD_PREB_PreembarqueBultoId = PREB_PreembarqueBultoId AND PREBD_Eliminado = 0
--INNER JOIN BultosDetalle ON BULD_BultoDetalleId = PREBD_BULD_BultoDetalleId
--INNER JOIN Bultos ON BUL_BultoId = BULD_BUL_BultoId
--WHERE TRAM_CMM_TipoTransferenciaId = 'FB9DD40D-14AB-4AD4-AB2E-AD887C80FDE3'
--AND EMBB_Eliminado = 0
--AND EMBB_FechaCreacion between '20220901 00:00:00' and '20220921 23:59:59'
--order by EMBB_CodigoEmbarqueBulto, ART_CodigoArticulo



-- Validar que todos los proveedores cuenten con un contacto por default.
-- Se cargo a las Alertas el 05 de Junio del 2024.
/*
Select 'SIN CONTACTO PROV' AS EXC_040 
	, PRO_CodigoProveedor 
	, PRO_Nombre 
	, PCON_Nombre
	, ProveedoresContactos.*
From Proveedores
Left Join ProveedoresContactos on PRO_ProveedorId = PCON_PRO_ProveedorId and PCON_Eliminado = 0
Where PRO_Activo = 1  and PCON_Nombre is NULL  
--AND PRO_CodigoProveedor  = 'P0348'
*/

--Consulta para Lista de Presion sin Predeterminado.
Select 'YA EN ALERTA; SIN PREDETERMINADO' AS REPORTE_201 
	, ART_CodigoArticulo as CODIGO
	, ART_Nombre as DESCRIPCION
	, (Select CMUM_Nombre from ControlesMaestrosUM Where CMUM_UnidadMedidaId = ART_CMUM_UMInventarioId) as UM_INV
	, (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId = ART_CMM_SubcategoriaId) as SUB_CATEG
	, PRO_CodigoProveedor as C_PROV
	, PRO_Nombre as PROVEEDOR
	, LPC_FechaVigencia as F_VIGENTE
from ListaPreciosCompra
inner join Articulos on LPC_ART_ArticuloId = ART_ArticuloId
inner join Proveedores on LPC_PRO_ProveedorId = PRO_ProveedorId
Where LPC_Eliminado = 0 
and (Select sum(convert (int,LPC_ProvPreProgramado)) from ListaPreciosCompra where LPC_ART_ArticuloId = ART_ArticuloId AND LPC_Eliminado = 0) = 0 
Order by ART_Nombre, PRO_Nombre




-- Lista de Precios de Proveedores. Fecha de Vencimiento pasada y material de linea.
      Select 'YA EN ALERTA;VENCIDO PRECIO' AS REPORTE_210 
    , ART_CodigoArticulo as CODIGO
	, ART_Nombre as DESCRIPCION
	, (Select CMUM_Nombre from ControlesMaestrosUM Where CMUM_UnidadMedidaId = ART_CMUM_UMInventarioId) as UM_INV
	, (Select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId = ART_CMM_SubcategoriaId) as SUB_CATEG
	, PRO_CodigoProveedor as C_PROV
	, PRO_Nombre as PROVEEDOR
	, LPC_FechaVigencia as F_VIGENTE
from ListaPreciosCompra
inner join Articulos on LPC_ART_ArticuloId = ART_ArticuloId
inner join Proveedores on LPC_PRO_ProveedorId = PRO_ProveedorId
Where LPC_Eliminado = 0 
and Cast(LPC_FechaVigencia AS DATE) < Cast(getdate() AS DATE) and ART_CMM_SubcategoriaId = '27BC3A6A-D075-4C6C-AFDF-1DEE95B23DC1'
Order by ART_Nombre, PRO_Nombre
            
     
-- Consulta para Traslados pendientes o en transito
-- Tomar Fecha de Un mes hacia atras y al dia de ayer se cargo a Alertas 12 de Junio del 2024.
Select * 
From (Select TSM_CodigoSolicitud
	, CMM_Valor
	, CAST(TSM_FechaSolicitud AS DATE) AS FECHA
	, ART_CodigoArticulo
	, ART_Nombre
    , '('+ ORIGEN.ALM_CodigoAlmacen + ') ' + ORIGEN.ALM_Nombre AS ORIGEN
    , '('+ DESTINO.ALM_CodigoAlmacen + ') ' + DESTINO.ALM_Nombre AS DESTINO
    , TSDM_Cantidad AS CANTIDAD_SOLICITADA  
    , SUM(ISNULL(TDM_CantidadATraspasar,0)) AS CANTIDAD_SURTIDA
    , ISNULL(CANTIDAD_RECIBIDA,0) AS CANTIDAD_RECIBIDA
    From TraspasosSolicitudesManufactura
    INNER JOIN TraspasosSolicitudesDetalleManufactura ON TSDM_TSM_TraspasoSolicitudId = TSM_TraspasoSolicitudId
    INNER JOIN Articulos ON ART_ArticuloId = TSDM_ART_ArticuloId
    INNER JOIN ControlesMaestrosMultiples ON CMM_ControlId = TSM_CMM_EstatusSolicitudId
    INNER JOIN Almacenes ORIGEN ON ORIGEN.ALM_AlmacenId = TSM_ALM_AlmacenOrigenId
    INNER JOIN Almacenes DESTINO ON DESTINO.ALM_AlmacenId = TSM_ALM_AlmacenDestinoId
    LEFT JOIN TraspasosDetalleManufactura ON TDM_TSDM_DetalleId = TSDM_DetalleId AND TDM_Eliminado = 0
    LEFT JOIN (SELECT TRM_TDM_TraspasoDetalleId, SUM(ISNULL(TRM_CantidadRecibo,0)) AS CANTIDAD_RECIBIDA 
            	FROM TraspasosRecibosManufactura 
            	WHERE TRM_Eliminado = 0
            	GROUP BY TRM_TDM_TraspasoDetalleId
    			) AS RECIBO ON RECIBO.TRM_TDM_TraspasoDetalleId = TDM_TraspasoDetalleId
     WHERE ISNULL(TSM_Eliminado,0) = 0
     AND TSM_CMM_EstatusSolicitudId <> 'AFD19273-9945-49BA-B857-CBF06852F5D1' -- Cerrada por el usuario
     AND CAST(TSM_FechaSolicitud AS DATE) between Cast(DATEADD(DAY,-30,getdate()) AS DATE) and Cast(DATEADD(DAY,-1,getdate()) AS DATE) 
     GROUP BY TSM_CodigoSolicitud, TSM_FechaSolicitud, CMM_Valor,ART_CodigoArticulo, ART_Nombre
    , ORIGEN.ALM_CodigoAlmacen, ORIGEN.ALM_Nombre, DESTINO.ALM_CodigoAlmacen, DESTINO.ALM_Nombre, TSDM_Cantidad, CANTIDAD_RECIBIDA
	) AS QUERY
WHERE CANTIDAD_SURTIDA > 0 AND CANTIDAD_RECIBIDA <= 0
ORDER BY TSM_CodigoSolicitud,FECHA











