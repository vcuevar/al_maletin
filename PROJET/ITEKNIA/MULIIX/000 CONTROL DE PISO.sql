-- Consultas Para el Control de Piso
-- Desarrollada: Ing. Vicente Cueva Ramirez.
-- Actualizado: Martes 03 de Mayo del 2022; Origen.

-- Consulta para definir Estaciones del Articulo (Ruta)

-- OT:02410
-- Articulo: 1174.4-07
-- Descripcion: FUNDA COJIN ASIENTO
-- Fecha: 03/MAY/2022 

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
Where FAB_Eliminado = 0 and FAE_Eliminado = 0 
and ART_CodigoArticulo = '1174.4-07'
Order by FAE_Codigo






-- Tabla de RPT_Seguimiento_OT
-- Se controla las cantidades que se tienen en cada Estacion

Select *
From RPT_Seguimiento_OT




-- Tabla de RPT_Seguimiento_OTF
-- Se lleva el historial del las OT que se han producido.

Select *
From RPT_Seguimiento_OTF





-- Tabla de RPT_Seguimiento_OTF
-- Se lleva el Inicio de cuando la autorizan para Produccion.

Select *
From RPT_Seguimiento_OTI