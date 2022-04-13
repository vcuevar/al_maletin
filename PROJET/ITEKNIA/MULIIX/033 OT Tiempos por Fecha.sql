-- Reporte de Tiempos Capturados en OT
-- Desarrolló: Ing. Vicente Cueva Ramírez
-- Actualizado: Viernes 16 de Octubre del 2020; Origen.
-- Actualizado: Miercoles 21 de Octubre del 2020; Filtrar por fecha de Creacion y agregar quien hizo.
-- Actualizado: Viernes 05 de Febrero del 2021; Agregar estatus de OT.

--Parametros Fecha Inicial y Fecha Final (aaaa-mm-dd)

Declare @FechaIS nvarchar(30), @FechaFS nvarchar(30)

Set @FechaIS = '2022-01-01'
Set @FechaFS = '2022-01-12' 

-- Consulta de Tiempos por Rango de Fecha

Select  OT_Codigo as OT, 
        ART_CodigoArticulo as CODE,
        ART_Nombre as DESCRIPCION,       
        OTDA_Cantidad as CANT,
        CET_Codigo + '  ' + CET_Nombre + '  ' + MAQ_Nombre as AREA,
        (Select (EMP_Nombre+'  '+EMP_PrimerApellido+'  '+EMP_SegundoApellido) from Empleados Where  EMP_EmpleadoId = OTSOD_EMP_OperadorId) as PERSONAL,
        OTSOD_FechaRegistroInicio as FEC_INC, 
        OTSOD_FechaRegistroFin as FEC_FIN,
        OTSOD_TiempoTotal as HORAS,
        OTSOD_FechaCreacion as FEC_ELA,
        (EMP_Nombre+'  '+EMP_PrimerApellido+'  '+EMP_SegundoApellido) as MODIFICADO
        , (select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId = OT_CMM_Estatus) as ESTATUS
        , OrdenesTrabajoSeguimientoOperacionDetalle.*
from OrdenesTrabajo
inner join OrdenesTrabajoDetalleArticulos on OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId
inner Join Articulos on ART_ArticuloId = OTDA_ART_ArticuloId
inner join OrdenesTrabajoSeguimiento on OT_OrdenTrabajoId = OTS_OT_OrdenTrabajoId
inner join OrdenesTrabajoSeguimientoOperacion on OTS_OrdenesTrabajoSeguimientoId = OTSO_OTS_OrdenesTrabajoSeguimientoId
inner join OrdenesTrabajoSeguimientoOperacionDetalle on OTSO_OrdenTrabajoSeguimientoOperacionId = OTSOD_OTSO_OrdenTrabajoSeguimientoOperacionId
inner join Maquinas on MAQ_MaquinaId = OTSOD_MAQ_MaquinaId
inner join CentrosTrabajo on CET_CentroTrabajoId = MAQ_CET_CentroTrabajoId
inner join Empleados on EMP_EmpleadoId = OTSOD_EMP_ModificadoPorId
Where  Cast(OTSOD_FechaCreacion As Date) BETWEEN @FechaIS and @FechaFS 
Order By Cast(OTSOD_FechaRegistroInicio As Date), CET_Codigo, OT_Codigo



/*


Select top (10) * from OrdenesTrabajo Where OT_Codigo = 'OT01219'

-- Departamentos del Area de Produccion.
Select DEP_DeptoId
        --, DEP_Codigo
        , DEP_Nombre 
        , *
from Departamentos 
where DEP_Eliminado = 0 and DEP_CMM_TipoDeptoId = '2D0DA641-8E75-4E7A-BC08-6AC624D41C7B'
and DEP_DeptoPadreId = 'A62D7F90-5FE9-4987-B3CA-3246F5AEAC0F'  and DEP_Codigo <> '7.4'
Order by DEP_Codigo

Select * from Departamentos where DEP_DeptoId = 'A62D7F90-5FE9-4987-B3CA-3246F5AEAC0F'

--Update Departamentos Set DEP_DeptoPadreId = 'CB8B684D-2B22-4786-A66A-A5A243306627' Where DEP_DeptoId = '6B9DC3A3-7ACF-4146-B5B7-1651EBF9D3A2'

Select * from Departamentos Where DEP_DeptoId = 'F8495875-6C76-4BF0-8BB0-8378BECE7587'

select * from ControlesMaestrosMultiples
--Where CMM_ControlId = '2D0DA641-8E75-4E7A-BC08-6AC624D41C7B'
Where CMM_Control = 'CMM_TipoDepartamento'

--Update CentrosTrabajo set CET_DEP_DeptoId = 'F8495875-6C76-4BF0-8BB0-8378BECE7587' Where CET_CentroTrabajoId = 'D9F17A12-9EC3-6F40-A9EF-C579F4A5F9DF'


-- Centros de Trabajo Segun el Departamento 
Select CET_CentroTrabajoId
        , CET_Codigo
        , CET_Nombre
from CentrosTrabajo 
where  CET_DEP_DeptoId = 'F8495875-6C76-4BF0-8BB0-8378BECE7587' 
--where  CET_DEP_DeptoId = 'F8495875-6C76-4BF0-8BB0-8378BECE7587' 
and CET_Borrado = 0

A3DC8029-E636-409F-B5C7-1F8169A19B44
0BAAC9A6-33B5-4C61-9203-A68663AE0013
65AF7115-0ED6-4B11-8CD2-AF73FD481068
F8495875-6C76-4BF0-8BB0-8378BECE7587


-- Consultas para el proyecto de Registro de Tiempos de Produccion.
-- Validar que la OT se puede cargar tiempos: Una OT se le puede cargar tiempos mientras no traiga estatus de Cerrada, 
-- o no este cancelada.

Select OT_OrdenTrabajoId
        , OT_Codigo
        , OTDA_ART_ArticuloId
        , ART_CodigoArticulo
        , ART_Nombre
        , OTDA_Cantidad
from OrdenesTrabajo
inner join OrdenesTrabajoDetalleArticulos on OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId
inner join Articulos on ART_ArticuloId = OTDA_ART_ArticuloId
Where OT_Codigo = 'OT01614'  --'OT01110'
and OT_CMM_Estatus <> '3887AF19-EA11-4464-A514-8FA6030E5E93' and OT_CMM_Estatus <> '46B96B9F-3A45-4CF9-9775-175C845B6198'
and OT_CMM_Estatus <> '7246798D-137A-4E94-9404-1D80B777EE09' and OT_CMM_Estatus <> '3E35C727-DAEE-47FE-AA07-C50EFD93B25F'
and OT_Activo = 1 and OT_Eliminado = 0

-- Validación del Empleado seleccionado, debe estar vigente y traernos a que Departamento pertenece:

Select EMP_EmpleadoId AS EMP_ID
        , EMP_CodigoEmpleado AS NUMERO
        , (EMP_Nombre + '  ' + EMP_PrimerApellido + '  ' + EMP_SegundoApellido) AS NOMBRE 
        , EMP_DEP_DeptoId AS EMP_DEPTO_ID
      from Empleados
Where EMP_Activo = 1 and EMP_CodigoEmpleado = '076'


-- Determinar en función al Departamento que centros de trabajo son las que se cargarían, de acuerdo a la Ruta del articulo: 

Select CET_DEP_DeptoId
        , FAE_Codigo
        , FAE_Descripcion 
        , CET_CentroTrabajoId
        , CET_Codigo
        , CET_Nombre
from Fabricacion
inner join FabricacionEstructura on FAB_FabricacionId = FAE_FAB_FabricacionId
inner join FabricacionDetalle on FAE_EstructuraId = FAD_FAE_EstructuraId
inner join CentrosTrabajo on  CET_CentroTrabajoId = FAD_ReferenciaId
--Where FAB_ART_ArticuloId = 'CE44AA8E-CD4C-47E4-9603-B557B2DFE423'
Where FAB_ART_ArticuloId = 'AF9A5026-502B-4015-869D-F65DDC1AEB24'
and FAB_Eliminado = 0
and FAD_CMM_TipoDetalleId = 'B5075BDA-BD6F-44E0-B56B-4C67AA3FDF98'
and FAD_Eliminado = 0
--and CET_DEP_DeptoId = '0BAAC9A6-33B5-4C61-9203-A68663AE0013'
Order By FAE_Codigo


-- Seleccionar el Departamento si el departamento que esta asignado el empleado no esta en la ruta
Select Distinct CET_DEP_DeptoId
        , FAE_EstructuraId
        , FAE_Codigo
        , FAE_Descripcion 
from Fabricacion
inner join FabricacionEstructura on FAB_FabricacionId = FAE_FAB_FabricacionId
inner join FabricacionDetalle on FAE_EstructuraId = FAD_FAE_EstructuraId
inner join CentrosTrabajo on  CET_CentroTrabajoId = FAD_ReferenciaId
Where FAB_ART_ArticuloId = 'CE44AA8E-CD4C-47E4-9603-B557B2DFE423'
and FAB_Eliminado = 0
and FAD_CMM_TipoDetalleId = 'B5075BDA-BD6F-44E0-B56B-4C67AA3FDF98'
and FAD_Eliminado = 0
Order By FAE_Codigo




--and FAE_DEP_DeptoId =  '0BAAC9A6-33B5-4C61-9203-A68663AE0013' --Carpinteria
--and FAE_DEP_DeptoId =  'A3DC8029-E636-409F-B5C7-1F8169A19B44' -- Tapiceria



Select top(10) * from Fabricacion Where FAB_ART_ArticuloId = 'EBD2DDE7-47D0-4D8B-BC91-CDED01E073AA'

OTSO_FAE_EstructuraId
AF5BB65A-2A78-43CE-BAA8-D92BF0C18412
4534B0A4-5000-4AD4-9C96-B6BC06CEEF74


Select top(10) * from FabricacionEstructura --Where FAE_FAB_FabricacionId = '2BDBCCF5-C551-4163-AAFC-C60E015438DF'
Where FAE_EstructuraId = 'AF5BB65A-2A78-43CE-BAA8-D92BF0C18412'
--Where FAE_EstructuraId = '4534B0A4-5000-4AD4-9C96-B6BC06CEEF74'

Select top(10) * from FabricacionDetalle Where FAD_FAE_EstructuraId = 'E306A196-D851-4E8C-AADE-C8D84DBC7E52' --'50C70C45-0AE9-4D4E-B312-E6BC9EEB4613'

Select top(10) * from FabricacionNodo Where FAN_FAE_EstructuraId = '9FAF61EE-535D-4CFA-9D12-D6C6FE1FCBCB'

select * from ControlesMaestrosMultiples
Where CMM_Control = 'CMM_TipoDetalleFabricacion'
--Where CMM_Control = 'CMM_OT_Estatus'
--Where CMM_Control = 'CMM_TipoOperacionFabricacion'
--Where CMM_ControlId = 'AB183DE8-BD9F-4AA6-BDD4-3E61936841E3'
Where 

FAD_CMM_TipoDetalleId = '4D0C2A30-89DB-418F-8D13-76F661FA93E1'
CMM_ControlId = '4D0C2A30-89DB-418F-8D13-76F661FA93E1' Maquinaria
Select * from Maquinas Where MAQ_MaquinaId = 'D068BA80-0F7F-FDAE-BEA4-ED14397FE871'

FAD_CMM_TipoDetalleId = 'B5075BDA-BD6F-44E0-B56B-4C67AA3FDF98'
CMM_ControlId = 'B5075BDA-BD6F-44E0-B56B-4C67AA3FDF98' Centro de Trabajo

Select * from CentrosTrabajo 
Where CET_Activo = 1 and CET_Borrado = 0
Order By CET_Codigo


Select DEP_DeptoId
        , DEP_Codigo
        , DEP_Nombre 
from Departamentos 
where DEP_Eliminado = 0 and DEP_CMM_TipoDeptoId = '2D0DA641-8E75-4E7A-BC08-6AC624D41C7B'
--and DEP_DeptoPadreId = 'A62D7F90-5FE9-4987-B3CA-3246F5AEAC0F'  and DEP_Codigo <> '7.4'
Order by DEP_Codigo



Select  OT_Codigo AS APP_OT_Codigo
        , OT_OrdenTrabajoID AS APP_OT_OrdenTrabajoId
        , ART_CodigoArticulo as APP_ART_CodigoArticulo
        , ART_ArticuloId AS APP_AticuloId
        , ART_Nombre AS APP_ART_Nombre
        , OTDA_Cantidad AS APP_OTDA_Cantidad
        , CET_Codigo
        , CET_Nombre
        , MAQ_Nombre as AREA
        ,CET_CentroTrabajoId
        , (Select (EMP_Nombre+'  '+EMP_PrimerApellido+'  '+EMP_SegundoApellido) from Empleados Where  EMP_EmpleadoId = OTSOD_EMP_OperadorId) as PERSONAL,
        OTSOD_FechaRegistroInicio as FEC_INC, 
        OTSOD_FechaRegistroFin as FEC_FIN,
        OTSOD_TiempoTotal as HORAS,
        OTSOD_FechaCreacion as FEC_ELA,
        (EMP_Nombre+'  '+EMP_PrimerApellido+'  '+EMP_SegundoApellido) as MODIFICADO
        , (select CMM_Valor from ControlesMaestrosMultiples Where CMM_ControlId = OT_CMM_Estatus) as ESTATUS
from OrdenesTrabajo
inner join OrdenesTrabajoDetalleArticulos on OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId
inner Join Articulos on ART_ArticuloId = OTDA_ART_ArticuloId
inner join OrdenesTrabajoSeguimiento on OT_OrdenTrabajoId = OTS_OT_OrdenTrabajoId
inner join OrdenesTrabajoSeguimientoOperacion on OTS_OrdenesTrabajoSeguimientoId = OTSO_OTS_OrdenesTrabajoSeguimientoId
inner join OrdenesTrabajoSeguimientoOperacionDetalle on OTSO_OrdenTrabajoSeguimientoOperacionId = OTSOD_OTSO_OrdenTrabajoSeguimientoOperacionId
inner join Maquinas on MAQ_MaquinaId = OTSOD_MAQ_MaquinaId
inner join CentrosTrabajo on CET_CentroTrabajoId = MAQ_CET_CentroTrabajoId
inner join Empleados on EMP_EmpleadoId = OTSOD_EMP_ModificadoPorId
Where  Cast(OTSOD_FechaCreacion As Date) BETWEEN '2021/11/23' and '2021/11/24' 
and OT_Codigo = 'OT01761'
Order By Cast(OTSOD_FechaRegistroInicio As Date), CET_Codigo, OT_Codigo

select * from centrosTrabajo
-- Tabla de Tiempos se registra

--

-- Para Guardar los regitros en Muliix serian.

Select  OTS_OrdenesTrabajoSeguimientoId        -- Id que se genera en automatico.              -- 
	, OTS_OT_OrdenTrabajoId                -- Id de la Orden de Trabajo.                   APP_OT_OrdenTrabajoId
	, OTS_ART_ArticuloId                   -- null                                         --
	, OTS_Activo                           -- true                                         1
	, OTS_Eliminado	                       -- false                                        0
	, OTS_FechaUltimaModificacion          -- Fecha del Movimiento                         Date()
	, OTS_Timestamp                        -- Automatico Timestamp                         --
from OrdenesTrabajoSeguimiento Where Cast(OTS_FechaUltimaModificacion as date) = '2021/08/02'
and OTS_OT_OrdenTrabajoId = 'DF580849-BFB0-45F5-984F-7CB348E70B31'


Select *
from OrdenesTrabajoSeguimiento Where Cast(OTS_FechaUltimaModificacion as date) = '2021/08/02'
and OTS_OT_OrdenTrabajoId = 'A02584C1-DB74-4C90-B9EE-9B1841054BC7'






Select top(10) * from OrdenesTrabajoSeguimientoOperacion
--Where OTSO_OTS_OrdenesTrabajoSeguimientoId = '6C3B3FB8-0FD7-4E03-825B-E6CE702935F4'
Where OTSO_OTS_OrdenesTrabajoSeguimientoId = 'BBE4D83D-F235-4720-BB6A-EA57084ABCCD'

Select top (10) * from OrdenesTrabajoSeguimientoOperacionDetalle
--Where OTSOD_OTSO_OrdenTrabajoSeguimientoOperacionId = '787C0162-C541-44A8-BAB5-E569C7F9C83B'
--Where OTSOD_OTSO_OrdenTrabajoSeguimientoOperacionId = 'E00ADB5F-1E64-48C7-AAA0-1E3478F8D1BF'
Where OTSOD_OTSO_OrdenTrabajoSeguimientoOperacionId = '28C36572-5B35-4A82-898A-D04388B43881'

        "id" : "DFF45628-5A45-7FD9-B7C3-16463EE714DE",


--Where OTSOD_OTSO_OrdenTrabajoSeguimientoOperacionId = 'C640276B-067A-4071-8717-EC38E462FFD1'
Where  Cast(OTSOD_FechaCreacion As Date) BETWEEN  '2021/08/17' and '2021/08/18'

-- Tablas vacias al parecer no se utilizan.
Select * from OrdenesTrabajoSeguimientoDetalleArticulo
Select * from OrdenesTrabajoSeguimientoGastos
Select * from OrdenesTrabajoSeguimientoGastosDetalle
Select * from OrdenesTrabajoSeguimientoGastosOperacion
Select * from OrdenesTrabajoSeguimientoDetalle
Select * from OrdenesTrabajoSeguimientoOperacionEmpleados



Select EMP_EmpleadoId AS EMP_ID
        , EMP_CodigoEmpleado AS NUMERO
        , (EMP_Nombre + '  ' + EMP_PrimerApellido + '  ' + EMP_SegundoApellido) AS NOMBRE 
        , EMP_DEP_DeptoId AS EMP_DEPTO_ID
        , DEP_Codigo 
        , DEP_Nombre
from Empleados
inner join Departamentos on DEP_DeptoId = EMP_DEP_DeptoId
Where EMP_Activo = 1 --and EMP_CodigoEmpleado = '777'

Select  DEP_DeptoId
        , CET_CentroTrabajoId
        , CET_Codigo
        , CET_Nombre
from CentrosTrabajo
inner join Departamentos on CET_DEP_DeptoId = DEP_DeptoId
Where CET_Activo = 1 and CET_Borrado = 0


Select * from Departamentos


inner join CentrosTrabajo on  CET_CentroTrabajoId = FAD_ReferenciaId




-- Ejemplo de Captura del dia 24 de Noviembre del 2021.

Select * 
from OrdenesTrabajoSeguimiento 
Where OTS_OrdenesTrabajoSeguimientoId = '48D6212E-40AC-4D40-82CE-0E6DF9AD03EE'

Select * 
from 
OrdenesTrabajoSeguimientoOperacion 
Where OTSO_OrdenTrabajoSeguimientoOperacionId = '4433E932-3F4D-43DC-80E4-D339B4E17857'

Select * 
from OrdenesTrabajoSeguimientoOperacionDetalle 
Where OTSOD_DetalleId = 'BA5BD09D-56A0-41F1-B612-E64F7ACD32AE'

-- La Estructura de la captura anterior seria... OTSO_FAE_EstructuraId = 399AEE79-A554-47C4-B160-9A86978901AB
Select FAE_EstructuraId
from FabricacionEstructura
inner join Fabricacion on FAB_FabricacionId = FAE_FAB_FabricacionId
inner join Articulos on ART_ArticuloId = FAB_ART_ArticuloId
Where ART_ArticuloId = '4598658D-AD20-403A-8466-B1FB5C1B63E6' 
and FAE_DEP_DeptoId =  'A3DC8029-E636-409F-B5C7-1F8169A19B44'

-- Para sacar el dato de la Maquina del ejemplo anterio seria... OTSOD_MAQ_MaquinaId = 16FBE618-07B6-5751-83ED-4D6813B9F307
Select MAQ_MaquinaId AS OTSOD_MAQ_MaquinaId
from CentrosTrabajo 
inner join Maquinas on CET_CentroTrabajoId = MAQ_CET_CentroTrabajoId
Where MAQ_CMM_TipoMaquinaId = '7E6CD62F-B9CD-4909-A37E-8AA7BF400BC6' and MAQ_Borrado = 0
and CET_CentroTrabajoId = '21DAFE17-4F06-0824-BA3A-A5E03CC2A3CD'


-- Para el ejemplo que traes de Mongo seria... FAE_EstructuraId = 5169A843-29A1-4625-B7C3-6E3B7CE0188A
Select FAE_EstructuraId
from FabricacionEstructura
inner join Fabricacion on FAB_FabricacionId = FAE_FAB_FabricacionId
inner join Articulos on ART_ArticuloId = FAB_ART_ArticuloId
Where ART_ArticuloId = '11423BDC-A3BF-4B97-BEFE-144269E60EFD' 
and FAE_DEP_DeptoId =  '0BAAC9A6-33B5-4C61-9203-A68663AE0013'


-- Para sacar el dato de la Maquina en mediante el ID de WorkCenter (Mongo) Seria... OTSOD_MAQ_MaquinaId = 29CE792E-1331-90A2-D46E-4DE4A5D18073
Select MAQ_MaquinaId AS OTSOD_MAQ_MaquinaId
from CentrosTrabajo 
inner join Maquinas on CET_CentroTrabajoId = MAQ_CET_CentroTrabajoId
Where MAQ_CMM_TipoMaquinaId = '7E6CD62F-B9CD-4909-A37E-8AA7BF400BC6' and MAQ_Borrado = 0
and CET_CentroTrabajoId = 'DFF45628-5A45-7FD9-B7C3-16463EE714DE'







Select * 
from OrdenesTrabajoSeguimientoOperacionDetalle 
inner join Maquinas on MAQ_MaquinaId = OTSOD_MAQ_MaquinaId
inner join CentrosTrabajo on CET_CentroTrabajoId = MAQ_CET_CentroTrabajoId
Where Cast(OTSOD_FechaCreacion As Date) BETWEEN '2021/11/23' and '2021/11/24' 

Select MAQ_MaquinaId AS OTSOD_MAQ_MaquinaId
from CentrosTrabajo 
inner join Maquinas on CET_CentroTrabajoId = MAQ_CET_CentroTrabajoId
Where MAQ_CMM_TipoMaquinaId = '7E6CD62F-B9CD-4909-A37E-8AA7BF400BC6' and MAQ_Borrado = 0
and CET_CentroTrabajoId = '21DAFE17-4F06-0824-BA3A-A5E03CC2A3CD' 

Select * from ControlesMaestrosMultiples where CMM_Control = 'CMM_TipoMaquina' CMM_ControlID = '7E6CD62F-B9CD-4909-A37E-8AA7BF400BC6'

Select * from ControlesMaestrosMultiples where CMM_Control = 'CMM_TipoOperacionFabricacion' CMM_ControlID = 'AB183DE8-BD9F-4AA6-BDD4-3E61936841E3'

*/