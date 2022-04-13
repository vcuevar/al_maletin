-- Consulta para Lista de Materiales costeadas.
-- Ing. Vicente Cueva R.
-- Viernes 27 de Abril del 2018

Select 	PAD.ART_CodigoArticulo AS COD_PADRE,
		pad.ART_Nombre  AS MUEBLE,
		EAR_ART_ComponenteId AS COD_COMPONE,
		EAR_CantidadEnsamble AS CANTIDAD
from EstructurasArticulos
inner join Articulos PAD on EAR_ART_ArticuloPadreId = PAD.ART_ArticuloId
--Where EMP_FechaEgreso is null
--Order by DEPARTAMENTO, PUESTO, NOMBRE



--select * from EstructurasArticulos