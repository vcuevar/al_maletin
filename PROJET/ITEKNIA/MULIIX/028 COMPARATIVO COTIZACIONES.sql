-- Consulta para comparativo de Cotizaciones
-- Desarrollado: Ing. Vicente Cueva Ramirez.
-- Actualizado: Martes 24 de Mayo del 2022; Origen

-- Parametros
Declare @OT_Code as nvarchar(30)
Declare @OT_Inic as nvarchar(30)
Declare @OT_Tope as nvarchar(30)

Set @OT_Code = 'OT02449'
Set @OT_Inic = 'OT02449'
Set @OT_Tope = 'OT02450'

-- Consulta de OT
Select OT_Codigo
		, ART_CodigoArticulo
		, ART_Nombre
		, OTDA_Cantidad AS CANT
		, ISNULL(OT_COT_MAT, 0) AS MAT
		, ISNULL(OT_COT_MOB, 0) AS MOB
		, ISNULL(OT_COT_IND, 0) AS IND
		, ISNULL(OT_COT_VEN, 0) AS VEN
 from OrdenesTrabajo
 Inner Join OrdenesTrabajoDetalleArticulos on OT_OrdenTrabajoId = OTDA_OT_OrdenTrabajoId
 Inner Join Articulos on ART_ArticuloId = OTDA_ART_ArticuloId
 Where OT_Codigo BETWEEN @OT_Inic AND @OT_Tope 
 --ISNULL(OT_COT_MAT, 0) + ISNULL(OT_COT_MOB, 0) + ISNULL(OT_COT_IND, 0) = 0 
 --AND 
 Order By OT_Codigo

 -- Subir Informacion a Muliix
 Update OrdenesTrabajo Set OT_COT_MAT = 300, OT_COT_MOB = 25000, OT_COT_IND = 400, OT_COT_VEN = 55000 Where OT_Codigo = 'OT02449'

-- Select * from OrdenesTrabajoDetalleArticulos