
-- Cotizador Invtek Selectores y configuracion de Seectores.
-- ITEKNIA EQUIPAMIENTO, S.A. de C.V.
-- Desarrollo: Ing. Alberto Jimenez Medina
-- Actualizado: Martes 08 de julio del 2025; Origen.

-- Tabla de Selectores 
/*
SELECT TOP (1000) [PAS_PasoId] AS ID
      ,[PAS_Pantalla_Ubicacion] AS PANTALLA
      ,[PAS_Orden] AS SELECTOR
      ,[PAS_Nombre] AS NOMBRE
      ,[PAS_Activo]
      ,[PAS_Eliminado]
      ,[PAS_Tipo_Selector]
  FROM [ItekniaDB].[dbo].[RPT_PasosCotizador]
  Where PAS_Activo  = 1
  Order By PAS_Orden 
  */

--Update RPT_PasosCotizador Set PAS_Nombre = 'Modelo del Riel' Where PAS_PasoId = 10

-- Tabla de configuración de Selectores
-- Tabla actualizada Jueves 10 de julio del 2025.

-- Select * from RPT_OpcionesCotizador
RUTA SELECCIONADA > Quit > Riel recto > Medidas Riel Recto > Frescura > 【Sistema Ripplefold 60%】

  Select PAS_Pantalla_Ubicacion AS PANTALLA
  	,PAS_Orden AS N_SEL
  	,PAS_Nombre AS SELECTOR
	,OPC_OpcionId AS ID_OPC
	,OPC_ValorOpcion AS VALOR
	,[OPC_S1]
    ,[OPC_S2]
    ,[OPC_S3]
    ,[OPC_S4]
    ,[OPC_S5]
    ,[OPC_S6]
    ,[OPC_S7]
    ,[OPC_S8]
    ,[OPC_S9]
    ,[OPC_S10]
    ,[OPC_S11]
    ,[OPC_S12]
    ,[OPC_S13]
    ,[OPC_S14]
    ,[OPC_S15]
    ,[OPC_S16]
    ,[OPC_S17]
    ,[OPC_S18]
    ,[OPC_S19]
    ,[OPC_S20]
From RPT_OpcionesCotizador opc
Inner Join RPT_PasosCotizador selector on opc.OPC_PasoId = selector.PAS_PasoId
Where PAS_Activo = 1  --and 
 --PAS_Orden = 1 						-- Para Seleccionar Area de Instalacion  
 --PAS_Orden = 2 and OPC_S1 = '00025' 	-- Seleccion de Tipo de Producto
 --PAS_Orden = 3 and OPC_S2 = '00259' 	-- Seleccion de Sub Producto
 --PAS_Orden = 4 and OPC_S3 = '00260' 	-- Seleccion de Tipo de Confeccion
-- PAS_Orden = 5 and OPC_S4 = '00261' 	-- Seleccion de Tipo de Confeccion
--PAS_Orden = 6 --and OPC_S5 = '00263' 	-- Seleccion del Tipo de Riel
 
--PAS_Orden = 7 --and OPC_S6 = '00012'  	-- Captura de las Medidas
 --PAS_Orden = 8 and OPC_S7 = '00035'   -- Numero de Hojas  
 --PAS_Orden = 9 and OPC_S8 = '00048'   -- Direccion de Apertura
 --PAS_Orden = 10 and OPC_S9 = '00236'  -- Categoria de Material
 --PAS_Orden = 12 and OPC_S10 = '00015'    -- Sistema de Apertura
 --PAS_Orden = 13 and OPC_S12 = '00016' 		-- Superficie de Instalacion
 --PAS_Orden = 14 and OPC_S13 = '00018'	-- Sistema de Riel
 --PAS_Orden = 15 and OPC_S14 = '00194'  -- Material del Riel
 --PAS_Orden = 16 and OPC_S15 = '00207'  -- Color del Riel
 --PAS_Orden = 17 and OPC_S16 = '00223'	-- Accesorio de Apertura 
 --PAS_Orden = 18 and OPC_S17 = '00241' -- Material del Accsesorio
 --PAS_Orden = 19 and OPC_S18 = '00042' -- Modelo del Accesorio
 --PAS_Orden = 20 and OPC_S19 = '00243' -- Largo del Accesorio.
 
 --[OPC_OpcionId]= 18

-- PAS_Orden = 6 and OPC_S5 = '00009' 	-- Seleccion del Tipo de Riel
-- PAS_Orden = 7 and OPC_S6 = '00013' 	-- Captura de las Medidas
-- PAS_Orden = 8 and OPC_S7 = '00034' 	-- Hojas (Debe brincar esta opción)
-- PAS_Orden = 9 and OPC_S8 = '00237'  	-- Direccion Apertura (Debe brincar esta opción)
-- PAS_Orden = 10 and OPC_S9 = '00236'  -- Categoria de Material
 
order by 
selector.PAS_Pantalla_Ubicacion asc, 	--pantalla donde se ubica el selector
selector.PAS_Orden asc, 				-- campo que se usara para el orden de los selectores, no esta actualizado
opc.OPC_ValorOpcion 					-- la opcion debe estar ordenada alfabeticamente
  
-- Update RPT_OpcionesCotizador Set OPC_Eliminado  = 1 Where OPC_OpcionId = 2

--Select * from RPT_OpcionesCotizador Where OPC_S1 = 'T'

--Select * from RPT_OpcionesCotizador Where OPC_OpcionId = 2 --OR OPC_OpcionId = 264 


/*
-- Para Sacar la ruta de lo que se lleva Seleccionado.




--PAS_Orden = 11 and OPC_S10 = '00015' 	-- Selecciona la Tela Y despues de ahi como le hariamos.
Select 
	'RUTA DE COTIZACION' AS TITULO
	, (Select OPC_ValorOpcion from RPT_OpcionesCotizador Where OPC_OpcionId = CAST(RTA.OPC_S1 as NUMERIC)) AS SEL01
	, (Select OPC_ValorOpcion from RPT_OpcionesCotizador Where OPC_OpcionId = CAST(RTA.OPC_S2 as NUMERIC)) AS SEL02
	, (Select OPC_ValorOpcion from RPT_OpcionesCotizador Where OPC_OpcionId = CAST(RTA.OPC_S3 as NUMERIC)) AS SEL03
	, (Select OPC_ValorOpcion from RPT_OpcionesCotizador Where OPC_OpcionId = CAST(RTA.OPC_S4 as NUMERIC)) AS SEL04
	, (Select OPC_ValorOpcion from RPT_OpcionesCotizador Where OPC_OpcionId = CAST(RTA.OPC_S5 as NUMERIC)) AS SEL05
	, (Select OPC_ValorOpcion from RPT_OpcionesCotizador Where OPC_OpcionId = CAST(RTA.OPC_S6 as NUMERIC)) AS SEL06
	, (Select OPC_ValorOpcion from RPT_OpcionesCotizador Where OPC_OpcionId = CAST(RTA.OPC_S7 as NUMERIC)) AS SEL07
	, (Select OPC_ValorOpcion from RPT_OpcionesCotizador Where OPC_OpcionId = CAST(RTA.OPC_S8 as NUMERIC)) AS SEL08
	, (Select OPC_ValorOpcion from RPT_OpcionesCotizador Where OPC_OpcionId = CAST(RTA.OPC_S9 as NUMERIC)) AS SEL09
	, (Select OPC_ValorOpcion from RPT_OpcionesCotizador Where OPC_OpcionId = CAST(RTA.OPC_S10 as NUMERIC)) AS SEL10
	, (Select OPC_ValorOpcion from RPT_OpcionesCotizador Where OPC_OpcionId = CAST(RTA.OPC_S11 as NUMERIC)) AS SEL11
	, (Select OPC_ValorOpcion from RPT_OpcionesCotizador Where OPC_OpcionId = CAST(RTA.OPC_S12 as NUMERIC)) AS SEL12
	, (Select OPC_ValorOpcion from RPT_OpcionesCotizador Where OPC_OpcionId = CAST(RTA.OPC_S13 as NUMERIC)) AS SEL13
	, (Select OPC_ValorOpcion from RPT_OpcionesCotizador Where OPC_OpcionId = CAST(RTA.OPC_S14 as NUMERIC)) AS SEL14
from RPT_OpcionesCotizador RTA
inner join RPT_PasosCotizador SEL on RTA.OPC_PasoId = SEL.PAS_PasoId
Where PAS_Activo = 1  and OPC_OpcionId = 194
 




Select * from RPT_OpcionesCotizador Where OPC_PasoId = 6

Select * from RPT_PasosCotizador Order By PAS_Orden
 

-- Captura de Ruta

Declare @nIndice integer

Set @nIndice = 37
   
Update RPT_OpcionesCotizador Set OPC_S1  = '00006' Where OPC_OpcionId = 37
Update RPT_OpcionesCotizador Set OPC_S2  = '00247' Where OPC_OpcionId = 37
Update RPT_OpcionesCotizador Set OPC_S3  = '00001' Where OPC_OpcionId = 37
Update RPT_OpcionesCotizador Set OPC_S4  = '00008' Where OPC_OpcionId = 37
Update RPT_OpcionesCotizador Set OPC_S5  = '00009' Where OPC_OpcionId = 37
Update RPT_OpcionesCotizador Set OPC_S6  = '00012' Where OPC_OpcionId = 37
Update RPT_OpcionesCotizador Set OPC_S7  = '00035' Where OPC_OpcionId = 37
Update RPT_OpcionesCotizador Set OPC_S8  = '00048' Where OPC_OpcionId = 37
Update RPT_OpcionesCotizador Set OPC_S9  = '00236' Where OPC_OpcionId = 37
Update RPT_OpcionesCotizador Set OPC_S10  = '00015' Where OPC_OpcionId = 37
Update RPT_OpcionesCotizador Set OPC_S11  = '00015' Where OPC_OpcionId = 37
Update RPT_OpcionesCotizador Set OPC_S12  = '00016' Where OPC_OpcionId = 37
Update RPT_OpcionesCotizador Set OPC_S13  = '00018' Where OPC_OpcionId = 37
Update RPT_OpcionesCotizador Set OPC_S14  = '00194' Where OPC_OpcionId = 37
Update RPT_OpcionesCotizador Set OPC_S15  = '00037' Where OPC_OpcionId = 37
Update RPT_OpcionesCotizador Set OPC_S16  = '00223' Where OPC_OpcionId = 37





Update RPT_OpcionesCotizador Set OPC_ValorOpcion  = 'Aluminio doble (Blanco)' Where OPC_OpcionId = 204
Update RPT_OpcionesCotizador Set OPC_ValorOpcion  = 'Aluminio (Blanco)' Where OPC_OpcionId = 207



Select COLUMN_NAME, DATA_TYPE
From  INFORMATION_SHEMA.COLUMNS
Where TABLE_NAME = 'ControlesMaestrosMultiples' 


SELECT TOP(10) * FROM ControlesMaestrosMultiples


SELECT TOP(10) * FROM OrdenesCompra oc 

*/




