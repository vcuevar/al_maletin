-- Consulta para sacar Estrucura Operacional
-- Inicio: Lunes 30 de Julio del 2018.
-- Actualizado: Jueves 02 de Agosto del 2018.

-- Estructura Operacional  (21 Registros):

select  DEP_Codigo
        , DEP_Nombre
        , CET_Codigo
        , CET_Nombre
        , CMM_Valor
        , EMP_CodigoEmpleado + ' ' + EMP_Nombre + ' ' + EMP_PrimerApellido AS RESPONSABLE
from CentrosTrabajo
inner join Departamentos on CET_DEP_DeptoId = DEP_DeptoId
inner join ControlesMaestrosMultiples on CET_CMM_TipoCarga = CMM_ControlId
inner join Empleados on DEP_EMP_EncargadoId = EMP_EmpleadoId
where CET_Borrado = 0
Order By CET_Codigo


Select CMM_Valor, CentrosTrabajo.* from CentrosTrabajo 
inner join ControlesMaestrosMultiples on CET_CMM_TipoCarga = CMM_ControlId
Where CET_Borrado = 0 Order By CET_Codigo

--Cambio de Depto al Centro de trabajo de Empaque
-- Este asi estaba.
--Update CentrosTrabajo Set  CET_DEP_DeptoId = 'EBAEE381-19DB-441D-BCC6-191BBC91AF4F' Where CET_CentroTrabajoId = 'D9F17A12-9EC3-6F40-A9EF-C579F4A5F9DF'

-- Cambie a 
--Update CentrosTrabajo Set  CET_DEP_DeptoId = 'F8495875-6C76-4BF0-8BB0-8378BECE7587' Where CET_CentroTrabajoId = 'D9F17A12-9EC3-6F40-A9EF-C579F4A5F9DF'




Select * from Departamentos Where DEP_Eliminado = 0
--and DEP_DeptoId = 'EBAEE381-19DB-441D-BCC6-191BBC91AF4F'
Order By DEP_Codigo

DEP_DeptoId =  'F8495875-6C76-4BF0-8BB0-8378BECE7587' --500 TERMINADO-EMPAQUE



Select	ART_CodigoArticulo
        , ART_Nombre
        , FAE_DEP_DeptoId
	, FAE_Codigo
	, FAE_Descripcion
	, FAE_Comentarios
	, CMM_Valor
		--CET_Codigo, 
		--CET_Nombre, 
		--DEP_Codigo, 
		--DEP_Nombre,
		--FAE_Codigo,
		--FAE_Descripcion,
		--EMP_CodigoEmpleado + ' ' + EMP_Nombre + ' ' + EMP_PrimerApellido AS RESPONSABLE
		--, FabricacionEstructura.*
from Fabricacion 
inner join Articulos on FAB_ART_ArticuloId = ART_ArticuloId
inner join FabricacionEstructura on FAE_FAB_FabricacionId = FAB_FabricacionId
inner join ControlesMaestrosMultiples on FAE_CMM_TipoOperacionId = CMM_ControlId
--inner join Departamentos on FAE_DEP_DeptoId = DEP_DeptoId
--inner join Empleados on DEP_EMP_EncargadoId = EMP_EmpleadoId
--Left join Fabricacion on FAE_SecuencialAntecesorId = FAB_FabricacionId
Where FAB_Eliminado = 0 and FAE_Eliminado = 0 and ART_CodigoArticulo = '1109.2-57'
Order by FAE_Codigo


Select * from Fabricacion
inner join FabricacionEstructura on FAE_FAB_FabricacionId = FAB_FabricacionId
Where FAE_Eliminado = 0 and FAB_ART_ArticuloId = '1404AE48-501C-44E2-B9FA-E29B83A7AD86'


Select * from FabricacionEstructura
Where FAE_FAB_FabricacionId = '8343E78B-06E1-454D-A69F-F81C01632545'

select * from CentrosTrabajo
inner join Departamentos on CET_DEP_DeptoId = DEP_DeptoId
where CET_Borrado = 0
Order By CET_Codigo


Select * from Departamentos




Select * from Departamentos
where DEP_Eliminado = 0 --and DEP_Nivel = 1
Order By DEP_Codigo

Select * from DepartamentosDatos


Select * from ControlesMaestrosMultiples
--where CMM_ControlId = '2D0DA641-8E75-4E7A-BC08-6AC624D41C7B'
where CMM_Control = 'CMM_TipoDepartamento'

select * from RutasOperacionDetalle







Select OT_OrdenTrabajoId
, OT_Codigo
, OTDA_ART_ArticuloId
, ART_CodigoArticulo
, ART_Nombre
, OTDA_Cantidad
from OrdenesTrabajo
inner join OrdenesTrabajoDetalleArticulos on OT_OrdenTrabajoId =
OTDA_OT_OrdenTrabajoId
inner join Articulos on ART_ArticuloId = OTDA_ART_ArticuloId
Where OT_Codigo = 'OT01879'
and OT_CMM_Estatus <> '3887AF19-EA11-4464-A514-8FA6030E5E93' and OT_CMM_Estatus <>
'46B96B9F-3A45-4CF9-9775-175C845B6198'
and OT_CMM_Estatus <> '7246798D-137A-4E94-9404-1D80B777EE09' and OT_CMM_Estatus <>
'3E35C727-DAEE-47FE-AA07-C50EFD93B25F'
and OT_Activo = 1 and OT_Eliminado = 0


Select EMP_EmpleadoId AS EMP_ID
, EMP_CodigoEmpleado AS NUMERO
, (EMP_Nombre + ' ' + EMP_PrimerApellido + ' ' + EMP_SegundoApellido) AS NOMBRE
, EMP_DEP_DeptoId AS EMP_DEPTO_ID
from Empleados
Where EMP_CodigoEmpleado = '836' and EMP_Activo = 1

Select CET_DEP_DeptoId
, FAE_Codigo
, FAE_Descripcion
, CET_CentroTrabajoId
, CET_Codigo
, CET_Nombre
from Fabricacion
inner join FabricacionEstructura on FAB_FabricacionId = FAE_FAB_FabricacionId
inner join FabricacionDetalle on FAE_EstructuraId = FAD_FAE_EstructuraId
inner join CentrosTrabajo on CET_CentroTrabajoId = FAD_ReferenciaId
Where FAB_ART_ArticuloId = 'EBD2DDE7-47D0-4D8B-BC91-CDED01E073AA'
and FAB_Eliminado = 0
and FAD_CMM_TipoDetalleId = 'B5075BDA-BD6F-44E0-B56B-4C67AA3FDF98'
and FAD_Eliminado = 0
and CET_DEP_DeptoId = 'A3DC8029-E636-409F-B5C7-1F8169A19B44'
Order By FAE_Codigo



Select Distinct CET_DEP_DeptoId
, FAE_Codigo
, FAE_Descripcion
from Fabricacion
inner join FabricacionEstructura on FAB_FabricacionId = FAE_FAB_FabricacionId
inner join FabricacionDetalle on FAE_EstructuraId = FAD_FAE_EstructuraId
inner join CentrosTrabajo on CET_CentroTrabajoId = FAD_ReferenciaId
Where FAB_ART_ArticuloId = 'EBD2DDE7-47D0-4D8B-BC91-CDED01E073AA'
and FAB_Eliminado = 0
and FAD_CMM_TipoDetalleId = 'B5075BDA-BD6F-44E0-B56B-4C67AA3FDF98'
and FAD_Eliminado = 0
Order By FAE_Codigo


Select CET_DEP_DeptoId
, FAE_Codigo
, FAE_Descripcion
, CET_CentroTrabajoId
, CET_Codigo
, CET_Nombre
from Fabricacion
inner join FabricacionEstructura on FAB_FabricacionId = FAE_FAB_FabricacionId
inner join FabricacionDetalle on FAE_EstructuraId = FAD_FAE_EstructuraId
inner join CentrosTrabajo on CET_CentroTrabajoId = FAD_ReferenciaId
Where FAB_ART_ArticuloId = 'EBD2DDE7-47D0-4D8B-BC91-CDED01E073AA'
and FAB_Eliminado = 0
and FAD_CMM_TipoDetalleId = 'B5075BDA-BD6F-44E0-B56B-4C67AA3FDF98'
and FAD_Eliminado = 0
and CET_DEP_DeptoId = 'EBAEE381-19DB-441D-BCC6-191BBC91AF4F'
Order By FAE_Codigo

