-- Excepcion para corregir los almacenes de Entrada de los Materiales y los PT.
-- Valida y cambia las Localidades por defauld
-- Elaboro: Ing. Vicente Cueva Ramirez.
-- Actualizado: 02 de Junio del 2020; Origen

--Select * from Articulos
--Where ART_ATP_TipoId = '84F680E5-C596-45DE-971B-8DE7AA565123'
--and ART_LOC_LocPredEntradasId <> '49D778C5-BF1C-4683-A9B5-46DB602862C8'

-- Corregir Almacenes de Materias Primas, Debe caer en Almacen Materias Primas
-- Entrada
-- 1 ALMACEN MATERIAS PRIMAS
-- Almacen:     CB35B14B-7BB1-4771-84DA-A4CBE159C8D6
-- Localidad:   49D778C5-BF1C-4683-A9B5-46DB602862C8

-- Salida
-- 2 Almacen WIP 1
-- Almacen:     A3ECCB9D-13E6-4942-9EF1-0C64CECAB672
-- Localidad:   581650A9-63D6-43C0-815D-30922AD402D9

--Materias Pimas
Update Articulos set ART_LOC_LocPredEntradasId = '49D778C5-BF1C-4683-A9B5-46DB602862C8', ART_LOC_LocPredSalidasId = '581650A9-63D6-43C0-815D-30922AD402D9'
Where ART_ATP_TipoId = '8418208F-EC34-41E8-9802-83B4404764DA'
and ART_LOC_LocPredEntradasId <> '49D778C5-BF1C-4683-A9B5-46DB602862C8'

--Consignado valor contable
Update Articulos set ART_LOC_LocPredEntradasId = '49D778C5-BF1C-4683-A9B5-46DB602862C8', ART_LOC_LocPredSalidasId = '581650A9-63D6-43C0-815D-30922AD402D9'
Where ART_ATP_TipoId = '15185803-A98F-4757-8CD5-845EA0492254'
and ART_LOC_LocPredEntradasId <> '49D778C5-BF1C-4683-A9B5-46DB602862C8'

--Consignado valor no contable
Update Articulos set ART_LOC_LocPredEntradasId = '49D778C5-BF1C-4683-A9B5-46DB602862C8', ART_LOC_LocPredSalidasId = '581650A9-63D6-43C0-815D-30922AD402D9'
Where ART_ATP_TipoId = '84F680E5-C596-45DE-971B-8DE7AA565123'
and ART_LOC_LocPredEntradasId <> '49D778C5-BF1C-4683-A9B5-46DB602862C8'

--Especiales	               
Update Articulos set ART_LOC_LocPredEntradasId = '49D778C5-BF1C-4683-A9B5-46DB602862C8', ART_LOC_LocPredSalidasId = '581650A9-63D6-43C0-815D-30922AD402D9'
Where ART_ATP_TipoId = '7A661D85-451C-46A5-BB1A-A71BBD846B03'
and ART_LOC_LocPredEntradasId <> '49D778C5-BF1C-4683-A9B5-46DB602862C8'

-- Corregir Almacenes de Producto Terminado, Debe caer en Almacen de PT
-- Entrada y Salida
-- 3 ALMACEN PRODUCTO TERMINADO
-- Almacen:     0B2FFBB7-44A4-485F-A2D4-792E281591E5
-- Localidad:   62EAAF01-1020-4C75-9503-D58B07FFC6EF

--Receta		               
Update Articulos set ART_LOC_LocPredEntradasId = '62EAAF01-1020-4C75-9503-D58B07FFC6EF', ART_LOC_LocPredSalidasId = '62EAAF01-1020-4C75-9503-D58B07FFC6EF'
Where ART_ATP_TipoId = '51D1BC11-7AFC-493D-A78F-32181EAB1F14'
and ART_LOC_LocPredEntradasId <> '62EAAF01-1020-4C75-9503-D58B07FFC6EF'

--Servicios		               
Update Articulos set ART_LOC_LocPredEntradasId = '62EAAF01-1020-4C75-9503-D58B07FFC6EF', ART_LOC_LocPredSalidasId = '62EAAF01-1020-4C75-9503-D58B07FFC6EF'
Where ART_ATP_TipoId = 'EA07185D-2032-4629-AF5F-3ED6B040237D'
and ART_LOC_LocPredEntradasId <> '62EAAF01-1020-4C75-9503-D58B07FFC6EF'

--Subensamble fabricado		               
Update Articulos set ART_LOC_LocPredEntradasId = '62EAAF01-1020-4C75-9503-D58B07FFC6EF', ART_LOC_LocPredSalidasId = '62EAAF01-1020-4C75-9503-D58B07FFC6EF'
Where ART_ATP_TipoId = '56B66D49-FE82-4414-A7E8-43F3916572D3'
and ART_LOC_LocPredEntradasId <> '62EAAF01-1020-4C75-9503-D58B07FFC6EF'

--Subensamble comprado	               
Update Articulos set ART_LOC_LocPredEntradasId = '62EAAF01-1020-4C75-9503-D58B07FFC6EF', ART_LOC_LocPredSalidasId = '62EAAF01-1020-4C75-9503-D58B07FFC6EF'
Where ART_ATP_TipoId = 'EF2269C7-EE46-433B-A4F5-69ADD76EC016'
and ART_LOC_LocPredEntradasId <> '62EAAF01-1020-4C75-9503-D58B07FFC6EF'

--Subproducto fabricado	               
Update Articulos set ART_LOC_LocPredEntradasId = '62EAAF01-1020-4C75-9503-D58B07FFC6EF', ART_LOC_LocPredSalidasId = '62EAAF01-1020-4C75-9503-D58B07FFC6EF'
Where ART_ATP_TipoId = '4DF75938-C7F2-4957-9B99-B59D5A4EFFCD'
and ART_LOC_LocPredEntradasId <> '62EAAF01-1020-4C75-9503-D58B07FFC6EF'

--Subproducto comprado              
Update Articulos set ART_LOC_LocPredEntradasId = '62EAAF01-1020-4C75-9503-D58B07FFC6EF', ART_LOC_LocPredSalidasId = '62EAAF01-1020-4C75-9503-D58B07FFC6EF'
Where ART_ATP_TipoId = '01FED95D-BA24-4148-A93B-C097B2834BE9'
and ART_LOC_LocPredEntradasId <> '62EAAF01-1020-4C75-9503-D58B07FFC6EF'

--P.T Fabricado             
Update Articulos set ART_LOC_LocPredEntradasId = '62EAAF01-1020-4C75-9503-D58B07FFC6EF', ART_LOC_LocPredSalidasId = '62EAAF01-1020-4C75-9503-D58B07FFC6EF'
Where ART_ATP_TipoId = '0D0B9D8A-C779-4D11-8CF6-C1DA16E4334C'
and ART_LOC_LocPredEntradasId <> '62EAAF01-1020-4C75-9503-D58B07FFC6EF'

--P.T. Comprado	           
Update Articulos set ART_LOC_LocPredEntradasId = '62EAAF01-1020-4C75-9503-D58B07FFC6EF', ART_LOC_LocPredSalidasId = '62EAAF01-1020-4C75-9503-D58B07FFC6EF'
Where ART_ATP_TipoId = '7352AF9D-F21D-4ED0-8FC3-ED3B2536E8C6'
and ART_LOC_LocPredEntradasId <> '62EAAF01-1020-4C75-9503-D58B07FFC6EF'

