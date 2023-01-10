-- Procedimiento para cambiar el precio de un Lote.
-- Desarrolló; Ing. Vicente Cueva Ramirez.
-- Actualizado: Jueves 22 de Octubre del 2020; Origen

-- Desarrollo de la Consulta.

Select  UPPER(ALM_CodigoAlmacen) AS ALM_CodigoAlmacen
            , LOC_LocalidadId
            , UPPER(LOC_Nombre) AS LOC_Nombre
            , UPPER(LOT_CodigoLote) AS LOT_CodigoLote 
            , ART_ArticuloId
            , UPPER(ART_CodigoArticulo) AS ART_CodigoArticulo
            , ART_Nombre AS ART_Nombre
            , CASE WHEN CMUM_UnidadMedidaId = '3A70E33B-B8D5-405D-B5AD-3A84A8A52875' THEN 'Kg' ELSE CMUM_Nombre END AS CMUM_Nombre
            , TRLOT_CantidadTraspaso as CANTIDAD
            , (ISNULL(LOT_CostoUnitario, 0.0) + ISNULL(LOT_ValorIndirectoMaterial, 0.0) * TRLOT_CantidadTraspaso) / TRLOT_CantidadTraspaso AS UNITARIO
            , (ISNULL(LOT_CostoUnitario, 0.0) + ISNULL(LOT_ValorIndirectoMaterial, 0.0) * TRLOT_CantidadTraspaso) / (TRLOT_CantidadTraspaso * TRLOT_CantidadTraspaso) AS COSTO_TOTAL
FROM TraspasosMovtos
INNER JOIN TraspasosLotes ON TRAM_TraspasoMovtoId = TRLOT_TRAM_TraspasoMovtoId
INNER JOIN LotesLocalidades ON TRLOT_LOTL_LoteLocalidadId = LOTL_LoteLocalidadId
INNER JOIN Localidades ON LOTL_LOC_LocalidadId = LOC_LocalidadId
INNER JOIN Almacenes ON LOC_ALM_AlmacenId = ALM_AlmacenId
INNER JOIN Lotes ON LOTL_LOT_LoteId = LOT_LoteId
INNER JOIN Articulos ON LOT_ART_ArticuloId = ART_ArticuloId
INNER JOIN ArticulosFamilias ON ART_AFAM_FamiliaId = AFAM_FamiliaId
LEFT  JOIN ArticulosCategorias ON ART_ACAT_CategoriaId = ACAT_CategoriaId 
LEFT  JOIN ArticulosFactoresConversion ON ART_ArticuloId = AFC_ART_ArticuloId AND AFC_CMUM_UnidadMedidaId = '3A70E33B-B8D5-405D-B5AD-3A84A8A52875'
INNER JOIN ControlesMaestrosUM ON ART_CMUM_UMInventarioId = CMUM_UnidadMedidaId
        
Where ART_CodigoArticulo = '12829' and LOT_CodigoLote = '960128290308'


Select * from Lotes where LOT_CodigoLote = '960128290308'
Select * from Lotes where LOT_ART_ArticuloId = 'B8EC979E-A3C7-40DC-909A-11A0AE6FF2B5'



221216: Solicitado por Mauricio
update Lotes set LOT_CostoUnitario = 0.0075408 where LOT_CodigoLote = '960128290308'

210707: Solicitado por Julio
update Lotes set LOT_CostoUnitario = 0.0481222222 where LOT_CodigoLote = '00145'

201120: Solicitado por Erika
update Lotes set LOT_CostoUnitario = 23.26 where LOT_CodigoLote = '01574'

Herramientas solicitadas por Paco.
update Lotes set LOT_CostoUnitario = 9 where LOT_CodigoLote = '12018'

update Lotes set LOT_CostoUnitario = 17391.3 where LOT_CodigoLote =  '12018'
update Lotes set LOT_CostoUnitario = 26086.96 where LOT_CodigoLote =  '12019'
update Lotes set LOT_CostoUnitario = 430013.79 where LOT_CodigoLote =  '12020'
update Lotes set LOT_CostoUnitario = 200000 where LOT_CodigoLote =  '12021'
update Lotes set LOT_CostoUnitario = 26086.96 where LOT_CodigoLote =  '12022'
update Lotes set LOT_CostoUnitario = 7182 where LOT_CodigoLote =  '12023'
update Lotes set LOT_CostoUnitario = 25000 where LOT_CodigoLote =  '12024'
update Lotes set LOT_CostoUnitario = 7800 where LOT_CodigoLote =  '12025'
update Lotes set LOT_CostoUnitario = 25000 where LOT_CodigoLote =  '12026'
update Lotes set LOT_CostoUnitario = 25000 where LOT_CodigoLote =  '12027'
update Lotes set LOT_CostoUnitario = 13235.33 where LOT_CodigoLote =  '12028'
update Lotes set LOT_CostoUnitario = 155409.6 where LOT_CodigoLote =  '12029'
update Lotes set LOT_CostoUnitario = 23518.77 where LOT_CodigoLote =  '12030'
update Lotes set LOT_CostoUnitario = 8000 where LOT_CodigoLote =  '12031'
update Lotes set LOT_CostoUnitario = 69112.75 where LOT_CodigoLote =  '12032'
update Lotes set LOT_CostoUnitario = 312037.8 where LOT_CodigoLote =  '12033'
update Lotes set LOT_CostoUnitario = 5827.75 where LOT_CodigoLote =  '12034'
update Lotes set LOT_CostoUnitario = 5450 where LOT_CodigoLote =  '12035'

update Lotes set LOT_CostoUnitario =17391.3 where LOT_CodigoLote = '12018'
update Lotes set LOT_CostoUnitario =26086.96 where LOT_CodigoLote = '12019'
update Lotes set LOT_CostoUnitario =430013.79 where LOT_CodigoLote = '12020'
update Lotes set LOT_CostoUnitario =200000 where LOT_CodigoLote = '12021'
update Lotes set LOT_CostoUnitario =26086.96 where LOT_CodigoLote = '12022'
update Lotes set LOT_CostoUnitario =7182 where LOT_CodigoLote = '12023'
update Lotes set LOT_CostoUnitario =25000 where LOT_CodigoLote = '12024'
update Lotes set LOT_CostoUnitario =7800 where LOT_CodigoLote = '12025'
update Lotes set LOT_CostoUnitario =25000 where LOT_CodigoLote = '12026'
update Lotes set LOT_CostoUnitario =25000 where LOT_CodigoLote = '12027'
update Lotes set LOT_CostoUnitario =13235.33 where LOT_CodigoLote = '12028'
update Lotes set LOT_CostoUnitario =155409.6 where LOT_CodigoLote = '12029'
update Lotes set LOT_CostoUnitario =23518.77 where LOT_CodigoLote = '12030'
update Lotes set LOT_CostoUnitario =8000 where LOT_CodigoLote = '12031'
update Lotes set LOT_CostoUnitario =69112.75 where LOT_CodigoLote = '12032'
update Lotes set LOT_CostoUnitario =312037.8 where LOT_CodigoLote = '12033'
update Lotes set LOT_CostoUnitario =5827.75 where LOT_CodigoLote = '12034'
update Lotes set LOT_CostoUnitario =5450 where LOT_CodigoLote = '12035'

update Lotes set LOT_CostoUnitario = 2.27 where LOT_CodigoLote = '11839'

update Lotes set LOT_CostoUnitario = 46.87 where LOT_CodigoLote = '9495'
update Lotes set LOT_CostoUnitario = 28.037 where LOT_CodigoLote = '9180'
update Lotes set LOT_CostoUnitario = 62.8854 where LOT_CodigoLote = '5220'
update Lotes set LOT_CostoUnitario = 17.271 where LOT_CodigoLote = '8225'
update Lotes set LOT_CostoUnitario = 34.27 where LOT_CodigoLote = '8898'
update Lotes set LOT_CostoUnitario = 10.04 where LOT_CodigoLote = '7238'
update Lotes set LOT_CostoUnitario = 67.778 where LOT_CodigoLote = '8333'
update Lotes set LOT_CostoUnitario = 23.26 where LOT_CodigoLote = '1574'
update Lotes set LOT_CostoUnitario = 66 where LOT_CodigoLote = '8403'
update Lotes set LOT_CostoUnitario = 109.618 where LOT_CodigoLote = '9475'
update Lotes set LOT_CostoUnitario = 18.469 where LOT_CodigoLote = '7258'
update Lotes set LOT_CostoUnitario = 43 where LOT_CodigoLote = '10220'
update Lotes set LOT_CostoUnitario = 18.706 where LOT_CodigoLote = '126'
update Lotes set LOT_CostoUnitario = 9.52 where LOT_CodigoLote = '9918'
update Lotes set LOT_CostoUnitario = 12.5 where LOT_CodigoLote = '7749'
update Lotes set LOT_CostoUnitario = 0.4562 where LOT_CodigoLote = '5875'
update Lotes set LOT_CostoUnitario = 89.5 where LOT_CodigoLote = '3800'
update Lotes set LOT_CostoUnitario = 47.07 where LOT_CodigoLote = '11987'
update Lotes set LOT_CostoUnitario = 93.1 where LOT_CodigoLote = '1971'
update Lotes set LOT_CostoUnitario = 0.16 where LOT_CodigoLote = '11048'
update Lotes set LOT_CostoUnitario = 0.3843 where LOT_CodigoLote = '7634'
update Lotes set LOT_CostoUnitario = 232.53 where LOT_CodigoLote = '8693'
update Lotes set LOT_CostoUnitario = 0.16 where LOT_CodigoLote = '12250'
update Lotes set LOT_CostoUnitario = 29.87 where LOT_CodigoLote = '10096'
update Lotes set LOT_CostoUnitario = 6.49 where LOT_CodigoLote = '11512'
update Lotes set LOT_CostoUnitario = 150 where LOT_CodigoLote = '6078'
update Lotes set LOT_CostoUnitario = 16.139 where LOT_CodigoLote = '12115'
update Lotes set LOT_CostoUnitario = 46.85 where LOT_CodigoLote = '10134'
update Lotes set LOT_CostoUnitario = 230.03 where LOT_CodigoLote = '10534'
update Lotes set LOT_CostoUnitario = 100 where LOT_CodigoLote = '10219'
update Lotes set LOT_CostoUnitario = 95.36 where LOT_CodigoLote = '2184'
update Lotes set LOT_CostoUnitario = 180 where LOT_CodigoLote = '9868'
update Lotes set LOT_CostoUnitario = 293 where LOT_CodigoLote = '4763'
update Lotes set LOT_CostoUnitario = 37.78 where LOT_CodigoLote = '11047'
update Lotes set LOT_CostoUnitario = 84.5152 where LOT_CodigoLote = '9999'
update Lotes set LOT_CostoUnitario = 66.3 where LOT_CodigoLote = '2777'
update Lotes set LOT_CostoUnitario = 86.24 where LOT_CodigoLote = '1286'
update Lotes set LOT_CostoUnitario = 50.2269 where LOT_CodigoLote = '2842'
update Lotes set LOT_CostoUnitario = 29.58 where LOT_CodigoLote = '10699'
update Lotes set LOT_CostoUnitario = 53.5882 where LOT_CodigoLote = '11773'
update Lotes set LOT_CostoUnitario = 28 where LOT_CodigoLote = '9708'
update Lotes set LOT_CostoUnitario = 4.09 where LOT_CodigoLote = '4698'
update Lotes set LOT_CostoUnitario = 1.93 where LOT_CodigoLote = '4697'
update Lotes set LOT_CostoUnitario = 38.294 where LOT_CodigoLote = '8831'
update Lotes set LOT_CostoUnitario = 74.82 where LOT_CodigoLote = '8754'
update Lotes set LOT_CostoUnitario = 104.35 where LOT_CodigoLote = '1735'

