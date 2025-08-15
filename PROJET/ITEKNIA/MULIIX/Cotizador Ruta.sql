-- Cotizador Invtek Selectores y configuracion de Seectores.
-- ITEKNIA EQUIPAMIENTO, S.A. de C.V.
-- Desarrollo: Ing. Alberto Jimenez Medina
-- Modificado: Ing. Vicente Cueva Ramírez.
-- Actualizado: Martes 29 de julio del 2025; Origen.

-- -- Captura de Ruta

--44
--244

Declare @nIndice integer

Set @nIndice = 2

Update RPT_OpcionesCotizador Set OPC_S1  = '00025' Where OPC_OpcionId = @nIndice
Update RPT_OpcionesCotizador Set OPC_S2  = '00259' Where OPC_OpcionId = @nIndice
Update RPT_OpcionesCotizador Set OPC_S3  = '00260' Where OPC_OpcionId = @nIndice
Update RPT_OpcionesCotizador Set OPC_S4  = '00261' Where OPC_OpcionId = @nIndice
Update RPT_OpcionesCotizador Set OPC_S5  = '00179' Where OPC_OpcionId = @nIndice
Update RPT_OpcionesCotizador Set OPC_S6  = '00002' Where OPC_OpcionId = @nIndice

/*

Update RPT_OpcionesCotizador Set OPC_S7  = '00035' Where OPC_OpcionId = @nIndice
Update RPT_OpcionesCotizador Set OPC_S8  = '00048' Where OPC_OpcionId = @nIndice
Update RPT_OpcionesCotizador Set OPC_S9  = '00236' Where OPC_OpcionId = @nIndice
Update RPT_OpcionesCotizador Set OPC_S10  = '00015' Where OPC_OpcionId = @nIndice
Update RPT_OpcionesCotizador Set OPC_S11  = 'T' 	Where OPC_OpcionId = @nIndice
Update RPT_OpcionesCotizador Set OPC_S12  = '00016' Where OPC_OpcionId = @nIndice
Update RPT_OpcionesCotizador Set OPC_S13  = '00018' Where OPC_OpcionId = @nIndice
Update RPT_OpcionesCotizador Set OPC_S14  = '00194' Where OPC_OpcionId = @nIndice
Update RPT_OpcionesCotizador Set OPC_S15  = '00207' Where OPC_OpcionId = @nIndice
Update RPT_OpcionesCotizador Set OPC_S16  = '00223' Where OPC_OpcionId = @nIndice
Update RPT_OpcionesCotizador Set OPC_S17  = '00241' Where OPC_OpcionId = @nIndice
Update RPT_OpcionesCotizador Set OPC_S18  = '00042' Where OPC_OpcionId = @nIndice
Update RPT_OpcionesCotizador Set OPC_S19  = '00243' Where OPC_OpcionId = @nIndice
Update RPT_OpcionesCotizador Set OPC_S20  = '0044' Where OPC_OpcionId = @nIndice
*/



-- Cambios a Nombres de Opciones de los Selectores.
/*
Update RPT_OpcionesCotizador Set OPC_ValorOpcion  = 'N/A' Where OPC_OpcionId = 43
Update RPT_OpcionesCotizador Set OPC_ValorOpcion  = 'Aluminio doble (Blanco)' Where OPC_OpcionId = 204
Update RPT_OpcionesCotizador Set OPC_ValorOpcion  = 'Aluminio (Blanco)' Where OPC_OpcionId = 207
*/

--
-- Insertar un nuevo registro
/*
Select * From RPT_OpcionesCotizador Where OPC_OpcionId = 43 



"OPC_OpcionId","OPC_PasoId","OPC_ValorOpcion","OPC_OpcionPadreId","OPC_EsMultiSeleccion","OPC_Imagen","OPC_EsDefault","OPC_Activo","OPC_Eliminado","OPC_Programacion","OPC_Descripcion","OPC_EsProducto","OPC_S1","OPC_S2","OPC_S3","OPC_S4","OPC_S5","OPC_S6","OPC_S7","OPC_S8","OPC_S9","OPC_S10","OPC_S11","OPC_S12","OPC_S13","OPC_S14","OPC_S15","OPC_S16","OPC_S17","OPC_S18","OPC_S19","OPC_S20"
43,16,N/A,42,0,"1748974416.png",0,1,0,,,,"00006","00247","00001","00008","00009","00012","00035","00048","00236","00015","00015","00016","00018","00194","00207","00223","00241","00042","00043",T




*/