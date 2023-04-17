-- 028-A Subir datos de la Cotizacion.
-- Ing. Vicente Cueva R.
-- Actualizado: Miercoles 02 de Enero del 2019; Orige.

-- Declaraciones
DECLARE @OTCode nvarchar(50)
DECLARE @CodProy nvarchar(50)
DECLARE @CodArti nvarchar(50)

--Asignar Valor
Set @OTCode = 'OT0914'

-- Validar que se cargo en RBV_OT
Select * from RBV_OT
Where RBV_OT.OT_CD= @OTCode


-- Validar que se cuente con registro en RBV_OT
Select OT_ID, AR_ID, OV_ID, PR_ID, ISNULL(CT_MP,0) AS MT, AR_QT from RBV_OT
Where RBV_OT.OT_CD= @OTCode

Set @CodProy = (Select PR_ID from RBV_OT Where RBV_OT.OT_CD= @OTCode)
Set @CodArti = (Select AR_ID from RBV_OT Where RBV_OT.OT_CD= @OTCode)

-- Busca Información de Proyecto y Articulo.
Select (EV_CodigoEvento + '  ' + EV_Descripcion) AS PROY 
from Eventos 
Where EV_EventoId= @CodProy

Select (ART_CodigoArticulo + '  ' + ART_Nombre) AS ARTI
From Articulos
Where ART_ArticuloId = @CodArti

--Actualizar Informacion de Cotizaciones en la Tabla de RBV_OT

--Update RBV_OT Set CT_MP = xDatos(10), CT_MO = xDatos(11),
--CT_IN = xDatos(12), CT_UT = xDatos(14), CT_NT = xDatos(15)
--Where RBV_OT.OT_CD= @OTCode


--Update RBV_OT Set CT_MP = 0, CT_MO = 0, CT_IN = 0, CT_UT = 0, CT_NT = 0
--Where RBV_OT.OT_CD= @OTCode


-- Relacion de Ordenes de Trabajo con Cotizaciones
Select	OT_CD AS OT,
		(Select (EV_CodigoEvento + '  ' + EV_Descripcion)  
		from Eventos Where EV_EventoId= PR_ID) AS PROY,
		(Select (ART_CodigoArticulo + '  ' + ART_Nombre) 
		From Articulos Where ART_ArticuloId = AR_ID) AS PRODUCTO,
		AR_QT AS CANTIDAD,
		CT_MP AS MATERIAL,
		CT_MO AS MANOBRA,
		CT_IN AS INDIRECTO,
		CT_UT AS UTILIDAD		
from RBV_OT
Where (CT_MP+CT_MO+CT_IN+CT_UT) > 0


Select OT_CD AS OT, (Select (EV_CodigoEvento + '  ' + EV_Descripcion) from Eventos Where EV_EventoId= PR_ID) AS PROY, (Select (ART_CodigoArticulo + '  ' + ART_Nombre) From Articulos Where ART_ArticuloId = AR_ID) AS PRODUCTO, CT_MP AS MATERIAL, CT_MO AS MANOBRA, CT_IN AS INDIRECTO, CT_UT AS UTILIDAD from RBV_OT Where (CT_MP+CT_MO+CT_IN+CT_UT) > 0




-- Relacion de Ordenes de Trabajo SIN Cotizaciones
Select	OT_CD AS OT,
		(Select (EV_CodigoEvento + '  ' + EV_Descripcion)  
		from Eventos Where EV_EventoId= PR_ID) AS PROY,
		(Select (ART_CodigoArticulo + '  ' + ART_Nombre) 
		From Articulos Where ART_ArticuloId = AR_ID) AS PRODUCTO,
		AR_QT AS CANTIDAD,
		CT_MP AS MATERIAL,
		CT_MO AS MANOBRA,
		CT_IN AS INDIRECTO,
		CT_UT AS UTILIDAD		
from RBV_OT
Where ((CT_MP+CT_MO+CT_IN+CT_UT) = 0 and OT_CD > 'OT1790' ) or ((CT_MP+CT_MO+CT_IN+CT_UT) is null
and OT_CD > 'OT1790')
Order By OT

Select OT_CD AS OT, (Select (EV_CodigoEvento + '  ' + EV_Descripcion) from Eventos Where EV_EventoId= PR_ID) AS PROY, (Select (ART_CodigoArticulo + '  ' + ART_Nombre) From Articulos Where ART_ArticuloId = AR_ID) AS PRODUCTO, AR_QT AS CANTIDAD, CT_MP AS MATERIAL, CT_MO AS MANOBRA, CT_IN AS INDIRECTO, CT_UT AS UTILIDAD from RBV_OT Where ((CT_MP+CT_MO+CT_IN+CT_UT) = 0 and OT_CD > 'OT1790' ) or ((CT_MP+CT_MO+CT_IN+CT_UT) is null and OT_CD > 'OT1790') Order By OT
