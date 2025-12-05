


Select PAS_Pantalla_Ubicacion 
  	,PAS_Orden
  	,PAS_Nombre 
	,OPC_OpcionId 
	,OPC_ValorOpcion 
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
Where -- PAS_Activo = 1 and 
OPC_OpcionId = 74 

--PAS_Orden = 1 						-- Para Seleccionar Area de Instalacion  
 --PAS_Orden = 2 --and OPC_S1 = '00025' 	-- Seleccion de Tipo de Producto
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



