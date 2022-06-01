-- 012-D Lista de Materiales, completo.
-- Ing. Vicente Cueva R.
-- Actualizado: Viernes 11 de Enero del 2019; Sacar Materiales de Sub-Ensamble.

-- Declaraciones
DECLARE @OTCode nvarchar(50)
DECLARE @IdedArt nvarchar(50)
DECLARE @CodPro nvarchar(50)

-- Asignar Valores a Variables
Set @OTCode = 'OT02449'

Set @IdedArt = (Select AR_ID from RBV_OT Where OT_CD = @OTCode)

Select * from OrdenesTrabajo Where OT_Codigo = 'OT02449' --@OTCode
Inner join OrdenesTrabajo

Select	EAR_ART_ComponenteId AS ID_Compo,	
		ART_CodigoArticulo AS COD_MAT, 
		ART_Nombre AS MATERIAL, 
		--CMUM_Nombre AS PAD_UM, 
		EAR_CantidadEnsamble AS CANTIDAD, 
		ART_CostoMaterialEstandar AS ESTANDAR,
		(EAR_CantidadEnsamble * ART_CostoMaterialEstandar) AS IMPORTE,
		
		(Select ATP_Descripcion from ArticulosTipos
		Where ATP_TipoId = (Select ART_ATP_TipoId from Articulos
		Where ART_ArticuloId = EAR_ART_ComponenteId)) AS TIP_MAT

from EstructurasArticulos 
inner join Articulos on EAR_ART_ComponenteId = ART_ArticuloId 
Where EAR_ART_ArticuloPadreId = @IdedArt
Order by MATERIAL 


Select	EAR_ART_ComponenteId AS ID_Compo,	
		ART_CodigoArticulo AS COD_MAT, 
		ART_Nombre AS MATERIAL, 
		--CMUM_Nombre AS PAD_UM, 
		EAR_CantidadEnsamble AS CANTIDAD, 
		ART_CostoMaterialEstandar AS ESTANDAR,
		(EAR_CantidadEnsamble * ART_CostoMaterialEstandar) AS IMPORTE,
		
		(Select ATP_Descripcion from ArticulosTipos
		Where ATP_TipoId = (Select ART_ATP_TipoId from Articulos
		Where ART_ArticuloId = EAR_ART_ComponenteId)) AS TIP_MAT,
*
from EstructurasArticulos 
inner join Articulos on EAR_ART_ComponenteId = ART_ArticuloId 
Where EAR_ART_ArticuloPadreId = '240B74EC-895E-4A5E-AF94-182D11472FBE'
Order by MATERIAL 

--'240B74EC-895E-4A5E-AF94-182D11472FBE'
--'6387F9D5-D117-4BC3-9018-265B85DBCD6E'
--A090FE0B-E60C-4F29-9D46-2626F301A6A3
--0D980687-50EE-4DDC-BEF9-14919BCAEEF7





