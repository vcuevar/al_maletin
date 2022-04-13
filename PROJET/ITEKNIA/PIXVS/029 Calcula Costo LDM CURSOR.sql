-- MACRO 029 LO Comparativo Costos por OT
-- Consulta para Obtener el Importe de la LDM, con Sub-Ensambles.
-- Desarrollo: Ing. Vicente Cueva R.
-- Actualizado: Martes 15 de Enero del 2019; Origen.
-- Actualizado: Miercoles 16 de Enero del 2019; Culmen.

-- Utilizando Set CURSOR
DECLARE @CODPT as nvarchar(50)
DECLARE @MATAR as nvarchar(50)
DECLARE @TIPAR as nvarchar(50)
DECLARE @COSTE as Decimal(18,5)
DECLARE @COSTO as Decimal(18,5)
DECLARE @TTLDM as Decimal(18,5)
DECLARE @CATSB as Decimal(18,5)

Set @CODPT = '5250.2-5'
Set @COSTE = 0
Set @TTLDM = 0
Set @CATSB = 1

DECLARE LisDM CURSOR FOR 

Select	A1.ART_CodigoArticulo AS MATAR,
		(Select ATP_Descripcion from ArticulosTipos
		Where ATP_TipoId = (Select ART_ATP_TipoId from Articulos
		Where ART_ArticuloId = EAR_ART_ComponenteId)) AS TIPAR,
		EAR_CantidadEnsamble AS CANTSUB,
		(EAR_CantidadEnsamble * A1.ART_CostoMaterialEstandar) AS COSTO
from EstructurasArticulos 
inner join Articulos A3 on EAR_ART_ArticuloPadreId = A3.ART_ArticuloId 
inner join Articulos A1 on EAR_ART_ComponenteId = A1.ART_ArticuloId 
Where A3.ART_CodigoArticulo = @CODPT 
Order by A1.ART_Nombre 
  
OPEN LisDM

FETCH NEXT FROM LisDM INTO @MATAR, @TIPAR, @CATSB, @COSTO
WHILE @@fetch_status = 0

BEGIN
	If @TIPAR = 'Subensamble fabricado' or @TIPAR = 'Subensamble comprado'
		Begin
		Set @COSTE = (Select SUM(@CATSB * EAR_CantidadEnsamble * A1.ART_CostoMaterialEstandar)
		from EstructurasArticulos 
		inner join Articulos A3 on EAR_ART_ArticuloPadreId = A3.ART_ArticuloId 
		inner join Articulos A1 on EAR_ART_ComponenteId = A1.ART_ArticuloId 
		Where A3.ART_CodigoArticulo = @MATAR )
		
		Set @TTLDM = @TTLDM + @COSTE
		--PRINT 'Registro Uno ' + @MATAR + ' ' + @TIPAR + ' ' + Str(@COSTE) + ' Acumulado ' + Str(@TTLDM) 
		Set @COSTE = 0
		End
	Else	
		Begin
		Set @TTLDM = @TTLDM + @COSTO
		--PRINT 'Registro Dos ' + @MATAR + ' ' + @TIPAR + ' ' + Str(@COSTO) + ' Acumulado ' + Str(@TTLDM)
		End
	
    FETCH NEXT FROM LisDM INTO @MATAR, @TIPAR, @CATSB, @COSTO
END

PRINT @TTLDM

CLOSE LisDM
DEALLOCATE LisDM


/*

Select (EAR_CantidadEnsamble * A1.ART_CostoMaterialEstandar) AS IMPORTE
from EstructurasArticulos 
inner join Articulos A1 on EAR_ART_ComponenteId = A1.ART_ArticuloId 
Where A3.ART_CodigoArticulo = @CODPT 


 
Into @COSTO 


DECLARE @Description AS nvarchar(400)
DECLARE ProdInfo CURSOR FOR SELECT [Description] FROM Production.ProductDescription

OPEN ProdInfo

FETCH NEXT FROM ProdInfo INTO @Description
WHILE @@fetch_status = 0

BEGIN

    PRINT @Description

    FETCH NEXT FROM ProdInfo INTO @Description

END

CLOSE ProdInfo

DEALLOCATE ProdInfo

*/

